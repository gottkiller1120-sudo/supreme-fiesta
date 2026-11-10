# Die bisherige Pipeline (n8n, Stand V7.7 / V7.8)

Gebaut in n8n, gestartet über einen Chat („Buchauftrag"). Ziel: aus einem Thema ein KDP-fertiges Buch (Innen-PDF, Cover, Metadaten) erzeugen.

## Ablauf (V7.8, 107 Knoten)
1. **Eingabe:** Chat-Trigger mit Buchauftrag, Einstellungen (Sprache, Zielumfang, KDP-Format, Autorenfoto, Ausgabeordner).
2. **Buchart erkennen:** per Regex (Lernmalbuch, Malbuch, Activity Book, Rätselbuch, Low-Content, Kinderbuch, Ratgeber, Sachbuch, sonst Lesebuch/Roman). Daraus folgt der Produktionsmodus `LESEBUCH` oder `VISUELL`.
3. **Recherche und Analyse:** Claude, dazu Gemini-Grounding mit Google-Suche und eine optionale NotebookLM-Quellenanalyse.
4. **Planung:** Zielgruppe analysieren → Buchkonzept → kritische Selbstprüfung → Produktionsplan (Marker `<<<04_TARGET>>>`, `<<<05_CONCEPT>>>`, `<<<07_PRODUCTION>>>`).
5. **Schreiben:** Manuskript → Lektorat → Endfassung → Rechtschreibung → zwei Erweiterungsrunden bis Mindestlänge. Nach jedem Schritt eine „OK?"-Prüfung mit Fallback.
6. **Spezialwege:** Lesebuch; Malbuch/Activity (Ausmalbilder per Gemini-Bildmodell); Rätselbuch (Wortlisten, Seitengenerator); Low-Content (Seitenplan).
7. **KDP-Paket:** Formatkatalog (Taschenbuch-Maße, Seitenlimits je Papierart), Metadaten als JSON und TXT.
8. **Cover:** Prompt → Coverbild → HTML → Gotenberg → PDF (Taschenbuch) und JPEG (E-Book).
9. **Innen-PDF:** HTML → Gotenberg → PDF, danach automatische Prüfung.
10. **Prüfbericht und Ablaufprotokoll:** unabhängige Fehlersuche über OmniRoute, Protokoll aller Warnungen.
11. **Hörspiel (optional):** Drehbuch per Claude, Intro-Audio per TTS über OmniRoute.

## Chat-Befehle
- Thema schreiben = neuer Komplettlauf
- `ab manuskript` = Lektorat und Cover ohne neues Schreiben
- `ab kdp` = Innen-PDF und Cover
- `ab cover` = nur Cover und Dateien
- `ab hoerspiel` = Hörspiel-Drehbuch und Intro-Audio

Checkpoints liegen in `/home/node/.n8n-files` und in der Workflow-Static-Data.

## Modellrollen in V7.8
| Aufgabe | Modell/Dienst |
|---|---|
| Schreiben, Lektorat, Endfassung, Rechtschreibung, Erweiterungen, Hörspiel-Drehbuch | Claude (über konfigurierbare `claude_base_url`) |
| Recherche mit Google-Suche, alle Bildmotive und Cover | Gemini (`gemini-3.1-flash-image` für Bilder) |
| Unabhängige Fehlersuche, Hörspiel-TTS, Kosten-Fallback | OmniRoute (OpenAI-kompatibel), optional Ollama lokal |
| PDF-Erzeugung | Gotenberg (muss laufen) |

V7.7 „Quality+" war schlanker: Gemini als Hauptmodell mit Flash-Fallback, Recherche und Grounding in einem Call, Lektorat und Endfassung in einem Call, Qualitätsmodus `standard | hoch | maximal`.

## Was gut war
- Klare Stufen mit Prüfpunkten und Fallbacks statt Abbruch.
- Eigene Prüfungen für PDF und Cover, KDP-Formatkatalog eingebaut.
- Checkpoints erlauben Wiedereinstieg.

## Was im Neustart besser werden soll
- **Zu groß und zu verschachtelt:** 107 Knoten, viele Code-Blöcke mit Regex-Parsing von Marker-Texten. Schwer zu testen und zu ändern.
- **Geheimnisse im Workflow:** API-Schlüssel standen als Klartext in den Einstellungen.
- **Versionsnamen stimmen nicht:** Datei „V7.8", intern „V7.6". Kein Changelog im Code.
- **Abhängigkeit von lokalem Windows-Setup:** feste Pfade, Gotenberg, Docker-Volume.
- **Qualität nicht messbar:** Zielumfang wird gefordert, das fertige 34a-Buch hat aber nur ca. 12.200 statt 18.000+ Wörtern.
- **Kein Test mit echtem KDP-Upload dokumentiert.**
