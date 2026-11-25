# n8n-Agent

Überwacht n8n (Docker Compose) und hält es aktuell – ohne Handarbeit.

**Überwachung** (alle 2 Min): Health-Check auf `/healthz`. Nach `FAIL_THRESHOLD` Fehlschlägen wird der Container neu gestartet, du bekommst eine Benachrichtigung.

**Update** (täglich ~04:00): `docker compose pull` → nur wenn ein neues Image da ist: Backup (Workflow-/Credential-Export + `.n8n`-Ordner) → Update → Health-Check. Schlägt der fehl, **automatischer Rollback** aufs alte Image.

## Installation
```bash
git clone <repo> && cd supreme-fiesta/n8n-agent
sudo ./install.sh
sudo nano /opt/n8n-agent/n8n-agent.env   # COMPOSE_DIR, HEALTH_URL, Benachrichtigung
sudo /opt/n8n-agent/n8n-agent.sh status
```

## Befehle
`n8n-agent.sh check | update | status | rollback`

## Hinweise
- Voraussetzung: n8n läuft per `docker compose`, Datenverzeichnis ist ein Volume, `curl` und `flock` vorhanden.
- Image-Tag in der Compose-Datei bestimmt den Kanal (`latest` = stabil). Feste Versionen (z. B. `1.80.0`) werden nicht automatisch angehoben.
- Major-Updates können Breaking Changes enthalten: bei Bedarf `AUTO_UPDATE=false` setzen und manuell mit `update` auslösen.
- Der Verschlüsselungsschlüssel (`N8N_ENCRYPTION_KEY`) steckt nicht im Backup – separat sichern!
- Logs: `/var/log/n8n-agent.log`, Timer: `systemctl list-timers 'n8n-agent*'`
