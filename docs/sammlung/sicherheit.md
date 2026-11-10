# Sicherheit: bitte zuerst erledigen

## 1. API-Schlüssel im Klartext (dringend)
Im n8n-Workflow `Mitsch_Book_Design_V7_8_Erweiterung2_Fix.json` (Google Drive, ID `1e1TbBi9oRluoZkfiGux1ca0Y3epdGc64`) stehen in den Einstellungen:
- ein **Gemini-API-Schlüssel** (`gemini_api_key`)
- ein **OmniRoute-API-Schlüssel** (`omniroute_api_key`, beginnt mit `sk-`)

Was zu tun ist:
1. Gemini-Schlüssel bei Google löschen und neu erzeugen.
2. OmniRoute-Schlüssel dort neu erzeugen.
3. Neue Schlüssel nur als n8n-Credentials oder Umgebungsvariablen eintragen, nie in Felder des Workflows.
4. Prüfen, wer Zugriff auf die Drive-Datei hat, und die Datei durch die geschwärzte Kopie aus diesem Repo ersetzen.

Beide Schlüssel sind in den Kopien in `archiv/n8n/` entfernt. Die Originale in Drive sind unverändert, ich habe dort nichts geändert.

## 2. Repo ist öffentlich
`gottkiller1120-sudo/supreme-fiesta` ist öffentlich sichtbar. Alles, was hier liegt, ist für jeden lesbar. Deshalb liegen hier weder der Buch-Volltext noch Schlüssel noch private Daten. Empfehlung: Repo auf **privat** stellen (GitHub → Settings → Danger Zone → Change visibility). Das kann ich von hier aus nicht ändern.

## 3. Shopify-Zahlung abgelehnt
Die Shopify-Rechnung für Mitsch-Group (36 €) wurde am 27.10.2026 abgelehnt. Sonst kann der Shop gesperrt werden.
