# Mitsch Book Design: Plan zur Freigabe

Stand: 10.11.2026. Gesammelt aus allen Gesprächen (Details in `INTERVIEW.md`, Einzelheiten in `BUCH-WORKFLOW-PLAN.md`). **Gebaut wird erst nach deiner Freigabe.**

## 1. Ziel
Ein Workflow, der aus einem Telegram-Auftrag ein **verkaufsfertiges KDP-Buch** macht: Text, Bilder, Cover, Formate, Metadaten. Er schreibt nur Wahres (außer bei erfundenen Geschichten). Du gibst an den wichtigen Stellen frei. Das Ziel ist, damit Geld zu verdienen, langsam wachsend, mit mehreren Büchern.

## 2. Bedienung per Telegram
`/neu <Thema>` startet. Der Bot schickt zuerst eine **Vorschau** (Titel, Gliederung, Bildbedarf, Seiten, geschätzter Verbrauch). `/ok` bestätigt, `/aendern <Wunsch>` ändert, `/los` schreibt das ganze Buch, `/freigeben` gibt das Ergebnis frei, `/status`, `/stopp`.

## 3. Der Ablauf
1. **Planer** nimmt den Auftrag an und verteilt die Aufgaben.
2. Nach deinem `/ok` laufen **drei Stränge gleichzeitig:** Recherche und Analyse (10 beste Bücher), Bilder (und Pläne), Cover (Vorentwurf).
3. **Konzept**, dann **Freigabe 1** durch dich. Cover und Bilder werden fertiggestellt.
4. **Redaktion** bündelt alles zu einem Briefing.
5. Auf `/los` schreibt der **Schreiber** das komplette Buch, Kapitel für Kapitel, menschlich im Ton.
6. **Prüfung:** zwei andere Modelle prüfen Fakten und Lektorat, dann Endkontrolle für Buch, Cover, Format. Fehler werden behoben, höchstens 3 Runden.
7. **Freigabe 2** durch dich (Prüfbericht, Cover, Auszug, Seitenzahl, Gewinnrechnung, unsichere Aussagen). Nach `/freigeben` werden die fertigen Dateien samt KDP-Eintragsliste gespeichert.
8. **Upload** bei Amazon machst du selbst (KDP hat keine Schnittstelle).

Das Bild dazu: Pipeline-Arbeitsfläche (Link im Chat).

## 4. Feste Regeln
- **Wahrheitsregel:** Sachbuch, Ratgeber, Anleitung, Dokumentation, Geschichtsbuch: nur belegte Tatsachen, jede Aussage mit Quelle. Erfinden nur bei Roman, Fantasy, erfundenen Geschichten.
- **Bilder:** Nur richtige Bilder. Eigene von dir oder öffentlich erlaubte mit Lizenz, für Anleitungen Pläne und Maße aus Code, nicht aus einer Bild-KI. Nie Falsches.
- **Seitenziele:** Geschichtsbuch 300 bis 400+, Dokumentation ca. 100, Taschenbuch 40 bis 70, Malbuch 24 bis 30 (KDP-Minimum 24), Kinder und Erwachsene.
- **Formate:** Maße für Taschenbuch, E-Book und Cover kommen aus einer festen Tabelle im Code, nicht von der KI. Du musst nichts nachmessen.
- **Cover:** Vorne Titel, Erklärtext und Logo. Hinten Klappentext und Logo.
- **Speicherpunkte:** Nach jeder Stufe wird gespeichert. Man macht nie von vorn weiter, sondern ab dem letzten Punkt.
- **Prüfung:** am Schluss durch KI, danach durch dich.
- **Werbung:** nur eigene Kanäle, keine Garantien, keine falschen Rezensionen, nie ohne funktionierenden Kauflink.

## 5. Technik
- **n8n** in Docker auf dem Laptop, als Dirigenten-Workflow mit kleinen Teil-Workflows.
- **KI-Zugang:** alles über **OmniRoute** (`http://localhost:20128/v1`), Modell pro Rolle festgelegt (nicht `auto`), die Gratis-Anbieter darin als Ausweichstufe.
- **Speicherort:** `Desktop\Die Firma\Buch Ergebnisse` (in Docker `/data/firma/Buch Ergebnisse`), ein Unterordner pro Buch.
- **GitHub-Repo (öffentlich):** nur Pläne, Workflow-Dateien, `book.yaml`. Keine Bücher, Bilder, Schlüssel.
- **Später:** Der alte Acer Predator als Server, wenn Zeitsteuerung gebraucht wird.

## 6. Reihenfolge des Baus
| Phase | Inhalt | Ergebnis |
|---|---|---|
| 0 | **Sicherheit:** Gemini- und OmniRoute-Schlüssel aus dem alten Workflow erneuern, Repo auf privat, API-Schlüssel im OmniRoute-API-Manager prüfen | sauberes Fundament |
| 1 | Ordner, Speicherpunkte, Modell-Zuordnung, **Testkapitel** mit 2 bis 3 Modellen im Vergleich | belegte Modellwahl |
| 2 | Telegram-Bot mit Vorschau (`/neu`, `/ok`, `/status`) | Bedienung steht |
| 3 | Recherche, Analyse, Konzept, Freigabe 1 | Konzept für ein Buch |
| 4 | Schreiber, Prüfung, Endkontrolle, `/los`, `/freigeben` | geprüftes Manuskript |
| 5 | Formatierer und Cover (KDP-Maße als Code), Ausgabe samt Eintragsliste | upload-fertiges Paket |
| 6 | Pilotbuch „Der 34a-Schein" neu durchlaufen lassen | erstes echtes Buch |
| 7 | Bilder und Pläne (Anleitungsbücher), Malbücher, Rätsel/Sudoku | breiteres Angebot |
| 8 | Werbung und Webseite (erst nach Livegang mit Kauflink) | erste Kampagne |
| 9 | Comics mit Serien-Rücken (eigene Figuren), Hörbuch/Hörspiel | spätere Erweiterung |

## 7. Entscheidungen
**Von dir:** Bücher und Werbung zusammen. n8n. Pilot ist der 34a-Schein. Wahrheitsregel. Telegram-Bedienung mit Vorschau. Alles über OmniRoute. Fachprüfung durch KI am Schluss. Speicherort im Ordner „Die Firma". Taschenbuch 40 bis 70 Seiten, Malbuch für Kinder und Erwachsene.

**Von Claude entschieden am 10.11.2026 (du kannst ändern):**
- Die „Free LLM API" ist OmniRoute, es gibt keinen zweiten Zugang.
- Ein Geschichtsbuch über wirkliche Geschichte ist **streng**.
- Läuft ein Modell an eine Grenze, wechselt der Workflow auf das nächste in der Kette.
- Mit dem **34a-Schein** wird zuerst begonnen, weil das Material vorliegt.

## 8. Noch offen (blockiert den Start nicht)
- Autorenname und Autorenfoto fürs Cover
- KDP: Steuerangaben und Bankverbindung eingetragen?
- Impressum und Datenschutz für die Webseite (erst Phase 8)
- Namen und Links der Telegram- und Facebook-Gruppe (erst Phase 8)
- Anthropic-Modelle in OmniRoute: gratis oder nicht (Filter „Nur kostenlose")
- Ein Textbeispiel, das du „menschlich" findest (für die Stilvorlage)
- Laptop-Ordner in der Claude-App freigeben (hilft ab Phase 1)

## 9. Deine Freigabe
Schreib **„Plan freigegeben"**, dann beginne ich mit **Phase 0 und 1**. Änderungen schreibst du einfach dazu, sie kommen vorher in den Plan.
