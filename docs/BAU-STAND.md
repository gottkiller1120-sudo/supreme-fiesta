# Bau-Stand

Stand: 25.11.2026. **Plan freigegeben.** Gebaut wird in kleinen Bausteinen, jeder mit Anleitung zum Testen.

## Fertig (im Repo)
| Baustein | Datei | Stand |
|---|---|---|
| **01 Planer und Vorschau** (n8n) | `workflows/01-planer-vorschau.json` | Code der Knoten lokal getestet (16 Prüfungen bestanden). **Nicht** in n8n importiert und nicht gegen OmniRoute getestet. |
| **00 Modelltest** (n8n) | `workflows/00-modelltest.json`, Bewertung in `docs/TESTKAPITEL.md` | Code lokal getestet (11 Prüfungen bestanden). Nicht in n8n importiert, nicht gegen OmniRoute getestet. |
| Sicherheits-Checkliste Phase 0 | `docs/PHASE-0-SICHERHEIT.md` | bereit, von dir abzuarbeiten |
| Modell je Rolle | `config/modelle.yaml` | Vorschlag, mit Testkapitel zu bestätigen |
| Buchart-Bibliothek | `bibliothek/buchart.yaml` | alle Buchtypen und Altersstufen |
| Auftragsvorlage | `books/der-34a-schein/book.yaml` | Pilotbuch |

Was Baustein 01 kann: Befehl `/neu +18 <Thema>` oder `/neu -18 <Thema>` lesen (Altersstufe Pflicht, sonst Rückfrage), Buchart erkennen, Vorschau über OmniRoute erstellen lassen (Titel, Gliederung, Bildbedarf, Risiken, Verbrauchsschätzung), `vorschau.json` und `state.json` (Speicherpunkt 1) speichern.

Anleitung zum Einrichten und Testen: `workflows/README.md`.

## Jetzt dran (Phase 0 und 1)
1. **Du:** Phase 0 abarbeiten (`docs/PHASE-0-SICHERHEIT.md`).
2. **Du:** Baustein 01 testen (`workflows/README.md`) und Baustein 00 Modelltest laufen lassen (`docs/TESTKAPITEL.md`).
3. **Ich:** Aus dem Ergebnis die Rollen in `config/modelle.yaml` festlegen.

## Nächste Bausteine (Reihenfolge)
1. `/ok`, `/aendern`, `/stopp` und Telegram-Anbindung (Bot-Token von @BotFather als n8n-Credential)
2. Marktprüfung (Nische, Suchbegriffe, Konkurrenz, Wirtschaftlichkeit)
3. Recherche, Analyse, Konzept, Freigabe 1
4. Schreiber, Prüfung, Endkontrolle, `/los`, `/freigeben`
5. Formatierer und Cover (KDP-Maße als Code)

## Was ich dazu von dir brauche
- Baustein 01 in n8n importieren und den Testbefehl ausprobieren (Anleitung in `workflows/README.md`). Meldung oder Fehlertext schicken.
- Den Ordner `Die Firma` in der Claude-App freigeben, damit ich selbst nachsehen kann.
