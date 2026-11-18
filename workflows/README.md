# n8n-Workflows

## 01-planer-vorschau.json (Baustein 01)
Nimmt den Befehl `/neu +18 <Thema>` oder `/neu -18 <Thema>` entgegen, fragt bei fehlender Altersstufe nach, lässt den Planer (über OmniRoute) eine **Vorschau** erstellen und speichert `vorschau.json` und `state.json` (Speicherpunkt 1).

**Stand:** Der Code der vier Code-Knoten ist lokal mit Beispielaufträgen getestet. **Nicht getestet** sind der Import in n8n, der Aufruf von OmniRoute und das Schreiben der Dateien, weil ich von hier aus nicht an deinen Laptop komme.

### Einrichten (einmalig)
1. n8n öffnen, Workflows, **Import from File**, `01-planer-vorschau.json` wählen.
2. **Credential anlegen:** Typ **Header Auth**, Name des Credentials `OmniRoute (Authorization)`, Header-Name `Authorization`, Wert `Bearer <dein OmniRoute-Schlüssel>`. Den Schlüssel findest du im OmniRoute-**API-Manager**. Er kommt nur dort hinein, nicht in den Workflow und nicht in dieses Repo.
3. Im Knoten **03 OmniRoute: Planer** dieses Credential auswählen.
4. Im Knoten **00 Einstellungen** prüfen: `omniroute_base_url` (`http://host.docker.internal:20128`), `modell_planer` (`anthropic/claude-haiku-5-5`, so wie es in OmniRoute steht), `ausgabe_basis` (`/data/firma/Buch Ergebnisse`).

### Testen
Im Workflow auf **Chat** (Open Chat) klicken und eingeben:
- `/neu +18 Selbstverteidigung für Frauen` → Vorschau, zwei Dateien im Ordner `Buch Ergebnisse`.
- `/neu Selbstverteidigung für Frauen` → Rückfrage nach der Altersstufe, nichts wird gespeichert.
- `/neu -18 alter:6-9 Tiergeschichten` → Vorschau für Kinder.

### Wenn etwas nicht klappt
- „Der Planer hat nicht geantwortet": OmniRoute läuft nicht, Schlüssel falsch oder Modellname in OmniRoute anders. Modellnamen unter `http://localhost:20128/v1/models` nachsehen.
- Dateien werden nicht geschrieben: prüfen, ob der Ordner `/data/firma/Buch Ergebnisse` im Docker-Container eingebunden ist (wie im alten Workflow).
- Fehlermeldung beim Import: Text der Meldung schicken.

### Grenzen dieser Version
`/ok`, `/aendern`, `/stopp` und die Telegram-Anbindung kommen im nächsten Baustein. Dateien liegen flach als `<slug>__vorschau.json` im Ordner, wie im alten Workflow. Eigene Buch-Unterordner folgen, sobald geprüft ist, dass n8n sie anlegen darf.
