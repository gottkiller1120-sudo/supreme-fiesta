#!/usr/bin/env bash
# n8n-Agent: überwacht n8n (Docker Compose) und aktualisiert es sicher.
# Befehle: check | update | status | rollback
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${N8N_AGENT_CONFIG:-$SCRIPT_DIR/n8n-agent.env}"
[ -f "$CONFIG" ] && . "$CONFIG"

COMPOSE_DIR="${COMPOSE_DIR:-/opt/n8n}"
SERVICE="${SERVICE:-n8n}"
HEALTH_URL="${HEALTH_URL:-http://localhost:5678/healthz}"
BACKUP_DIR="${BACKUP_DIR:-/var/backups/n8n}"
BACKUP_KEEP="${BACKUP_KEEP:-7}"
STATE_DIR="${STATE_DIR:-/var/lib/n8n-agent}"
LOG_FILE="${LOG_FILE:-/var/log/n8n-agent.log}"
FAIL_THRESHOLD="${FAIL_THRESHOLD:-2}"      # Fehlchecks bis zum Neustart
HEALTH_TIMEOUT="${HEALTH_TIMEOUT:-180}"    # Sekunden Wartezeit nach Update
AUTO_UPDATE="${AUTO_UPDATE:-true}"
NOTIFY_URL="${NOTIFY_URL:-}"               # z.B. https://ntfy.sh/mein-topic
NOTIFY_TELEGRAM_TOKEN="${NOTIFY_TELEGRAM_TOKEN:-}"
NOTIFY_TELEGRAM_CHAT="${NOTIFY_TELEGRAM_CHAT:-}"

mkdir -p "$STATE_DIR" "$BACKUP_DIR" "$(dirname "$LOG_FILE")" 2>/dev/null || true

log() { echo "$(date '+%F %T') $*" | tee -a "$LOG_FILE" >&2; }

notify() {
  local msg="[n8n-agent @ $(hostname)] $*"
  log "NOTIFY: $*"
  [ -n "$NOTIFY_URL" ] && curl -fsS -m 10 -d "$msg" "$NOTIFY_URL" >/dev/null 2>&1
  if [ -n "$NOTIFY_TELEGRAM_TOKEN" ] && [ -n "$NOTIFY_TELEGRAM_CHAT" ]; then
    curl -fsS -m 10 "https://api.telegram.org/bot${NOTIFY_TELEGRAM_TOKEN}/sendMessage" \
      --data-urlencode "chat_id=${NOTIFY_TELEGRAM_CHAT}" --data-urlencode "text=$msg" >/dev/null 2>&1
  fi
  return 0
}

dc() { (cd "$COMPOSE_DIR" && docker compose "$@"); }

container_id() { dc ps -q "$SERVICE" 2>/dev/null | head -n1; }
image_ref()    { dc config --images 2>/dev/null | grep -i n8n | head -n1; }
current_image_id() { local c; c=$(container_id); [ -n "$c" ] && docker inspect -f '{{.Image}}' "$c" 2>/dev/null; }
n8n_version() { local c; c=$(container_id); [ -n "$c" ] && docker exec "$c" n8n --version 2>/dev/null | tr -d '\r'; }

healthy() { curl -fsS -m 10 "$HEALTH_URL" >/dev/null 2>&1; }

wait_healthy() {
  local t=0
  while [ "$t" -lt "$HEALTH_TIMEOUT" ]; do
    healthy && return 0
    sleep 5; t=$((t+5))
  done
  return 1
}

# ---------- check: Überwachung ----------
cmd_check() {
  local f="$STATE_DIR/fails" n
  if healthy; then
    [ -f "$f" ] && { notify "n8n ist wieder erreichbar ✅"; rm -f "$f"; }
    return 0
  fi
  n=$(( $(cat "$f" 2>/dev/null || echo 0) + 1 )); echo "$n" > "$f"
  log "Health-Check fehlgeschlagen ($n/$FAIL_THRESHOLD)"
  if [ "$n" -ge "$FAIL_THRESHOLD" ]; then
    notify "n8n antwortet nicht – starte Container neu ⚠️"
    dc up -d "$SERVICE" >>"$LOG_FILE" 2>&1
    dc restart "$SERVICE" >>"$LOG_FILE" 2>&1
    if wait_healthy; then
      notify "Neustart erfolgreich ✅"; rm -f "$f"
    else
      notify "Neustart fehlgeschlagen ❌ – manuelles Eingreifen nötig"
      return 1
    fi
  fi
}

# ---------- backup ----------
do_backup() {
  local ts file c
  ts=$(date +%Y%m%d-%H%M%S); file="$BACKUP_DIR/n8n-$ts.tar.gz"; c=$(container_id)
  [ -z "$c" ] && { log "Kein Container für Backup"; return 1; }
  # Workflows/Credentials (verschlüsselt) exportieren, dann komplettes Datenverzeichnis sichern
  docker exec "$c" sh -c 'mkdir -p /home/node/.n8n/_export && n8n export:workflow --backup --output=/home/node/.n8n/_export/workflows/ && n8n export:credentials --backup --output=/home/node/.n8n/_export/credentials/' >>"$LOG_FILE" 2>&1 || log "Export-Warnung (Backup läuft weiter)"
  docker run --rm --volumes-from "$c" -v "$BACKUP_DIR:/backup" alpine \
    tar czf "/backup/$(basename "$file")" -C /home/node .n8n >>"$LOG_FILE" 2>&1 || return 1
  log "Backup erstellt: $file"
  ls -1t "$BACKUP_DIR"/n8n-*.tar.gz 2>/dev/null | tail -n +$((BACKUP_KEEP+1)) | xargs -r rm -f
}

# ---------- update ----------
cmd_update() {
  [ "$AUTO_UPDATE" = "true" ] || { log "AUTO_UPDATE=false – übersprungen"; return 0; }
  healthy || { log "n8n nicht gesund – Update abgebrochen"; return 1; }

  local ref old_id old_ver new_id new_ver
  ref=$(image_ref); old_id=$(current_image_id); old_ver=$(n8n_version)
  [ -z "$ref" ] || [ -z "$old_id" ] && { log "Image/Container nicht ermittelbar"; return 1; }

  log "Prüfe Updates für $ref (aktuell: $old_ver)"
  dc pull "$SERVICE" >>"$LOG_FILE" 2>&1 || { notify "docker pull fehlgeschlagen ❌"; return 1; }
  new_id=$(docker image inspect -f '{{.Id}}' "$ref" 2>/dev/null)
  if [ "$new_id" = "$old_id" ]; then log "Bereits aktuell ($old_ver)"; return 0; fi

  # altes Image sichern, damit Rollback möglich ist
  docker tag "$old_id" n8n-agent-rollback:previous
  do_backup || { notify "Backup fehlgeschlagen – Update abgebrochen ❌"; docker tag "$old_id" "$ref"; return 1; }

  log "Aktualisiere n8n…"
  dc up -d "$SERVICE" >>"$LOG_FILE" 2>&1
  if wait_healthy; then
    new_ver=$(n8n_version)
    notify "n8n aktualisiert: $old_ver → $new_ver ✅"
    docker image prune -f >/dev/null 2>&1
  else
    notify "Update auf neue Version fehlgeschlagen ❌ – Rollback auf $old_ver"
    cmd_rollback
  fi
}

# ---------- rollback ----------
cmd_rollback() {
  local ref; ref=$(image_ref)
  docker image inspect n8n-agent-rollback:previous >/dev/null 2>&1 || { log "Kein Rollback-Image vorhanden"; return 1; }
  docker tag n8n-agent-rollback:previous "$ref"
  dc up -d --force-recreate "$SERVICE" >>"$LOG_FILE" 2>&1
  if wait_healthy; then notify "Rollback erfolgreich ✅ ($(n8n_version))"
  else notify "Rollback fehlgeschlagen ❌ – manuelles Eingreifen nötig"; return 1; fi
}

cmd_status() {
  echo "Container : $(container_id || echo -)"
  echo "Version   : $(n8n_version || echo ?)"
  echo "Image     : $(image_ref)"
  healthy && echo "Health    : OK" || echo "Health    : FEHLER"
  echo "Backups   : $(ls -1 "$BACKUP_DIR"/n8n-*.tar.gz 2>/dev/null | wc -l) in $BACKUP_DIR"
}

# Nur ein Lauf gleichzeitig
exec 9>"$STATE_DIR/lock"
flock -n 9 || { log "Läuft bereits – Abbruch"; exit 0; }

case "${1:-status}" in
  check)    cmd_check ;;
  update)   cmd_update ;;
  rollback) cmd_rollback ;;
  status)   cmd_status ;;
  *) echo "Nutzung: $0 {check|update|status|rollback}"; exit 2 ;;
esac
