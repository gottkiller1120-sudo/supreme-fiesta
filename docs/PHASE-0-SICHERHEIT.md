# Phase 0: Sicherheit (bitte du, ca. 20 Minuten)

Das kann ich von hier aus nicht für dich tun. Die Reihenfolge zählt: erst neue Schlüssel, dann die alten löschen.

## 1. Gemini-Schlüssel erneuern
1. Google AI Studio öffnen, Bereich **API-Schlüssel**.
2. **Neuen Schlüssel erstellen.**
3. Den neuen Schlüssel in **OmniRoute** beim Anbieter „Gemini (Google AI Studio)" eintragen (Anbieter-Seite, Schlüssel ersetzen). **Nicht** in n8n.
4. Den **alten** Schlüssel löschen. Er steht im Workflow in Drive (`Mitsch_Book_Design_V7_8_Erweiterung2_Fix.json`) im Klartext und beginnt mit `AQ.`.

## 2. OmniRoute-Schlüssel erneuern
1. OmniRoute → **API-Manager** → neuen Schlüssel erstellen.
2. In n8n das Credential **OmniRoute (Authorization)** auf `Bearer <neuer Schlüssel>` ändern.
3. Den alten Schlüssel im API-Manager löschen (er beginnt mit `sk-4ad6`).
4. Prüfen, dass OmniRoute für Zugriffe einen Schlüssel **verlangt** (Einstellung im API-Manager bzw. unter Endpunkte).

## 3. Claude-Schlüssel im alten Workflow
Der alte Workflow hat auch ein Feld für einen Claude-Schlüssel. Falls dort ein echter Schlüssel stand: in der Anthropic-Konsole **löschen und neu erzeugen**. Wenn du ihn nicht mehr brauchst (alles läuft über OmniRoute), nicht neu erzeugen.

## 4. Alte Datei in Drive
`Mitsch_Book_Design_V7_8_Erweiterung2_Fix.json` löschen oder durch die geschwärzte Kopie aus `archiv/n8n/` ersetzen. Prüfen, wer Zugriff auf die Datei hat (Teilen-Einstellungen).

## 5. Cloud-Zugang von OmniRoute
Auf der Seite **Endpunkte** ist „Cloud OmniRoute" aktiv. Wenn du es nicht brauchst, auf **Cloud deaktivieren** klicken. n8n läuft lokal und erreicht OmniRoute auch so.

## 6. Repo auf privat stellen
GitHub → Repository `supreme-fiesta` → **Settings** → ganz unten **Danger Zone** → **Change repository visibility** → **Make private**.

## 7. Zum Schluss
Mir sagen „Phase 0 erledigt". Dann ist das Fundament sauber.
