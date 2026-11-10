# Bauplan: Mitsch Book Design, Neustart

**Status: ENTWURF v2.** Es wird erst gebaut, wenn der Plan freigegeben ist. Offene Entscheidungen sind mit ❓ markiert, getroffene mit ✅.

## Getroffene Entscheidungen (10.11.2026)
- ✅ **Umfang Version 1:** Bücher **und** Werbung zusammen.
- ✅ **Technik:** n8n bleibt, aber in kleinen Teil-Workflows statt eines großen.
- ✅ **Pilotbuch:** „Der 34a-Schein" wird neu erzeugt.
- ✅ **Stand:** Das Buch ist noch **nicht** veröffentlicht. Der Neustart passiert also vor dem Livegang, ein sauberer Zeitpunkt.

## 1. Ziel
Ein System, das aus einer Buchidee ein **KDP-fertiges Buch** macht (Innen-PDF, Cover, Metadaten) und anschließend **Werbematerial** dazu erzeugt. Der Mensch gibt an den wichtigen Stellen frei. Qualität vor Menge.

✅ Bücher und Werbung gehören zu Version 1. Weil das Buch noch nicht live ist, startet das Posting erst, wenn es einen Kauflink gibt (Vorbereitung vorher, Posting danach).

## 2. Was wir aus der alten Version mitnehmen
- Die Stufen: Recherche → Konzept → Manuskript → Lektorat → Endfassung → KDP-Paket → Cover → Innen-PDF → Prüfbericht.
- Den KDP-Formatkatalog (Maße, Seitenlimits).
- Die Buchtypen: Sachbuch/Ratgeber, Roman/Lesebuch, Kinderbuch, Malbuch, Rätselbuch, Low-Content, Hörspiel.
- Das Logo, die Canva-Designs und den Claim „Bücher mit Herz".
- Prüfpunkte nach jeder Stufe statt blindem Durchlaufen.

## 3. Was wir anders machen
| Alt (V7.x) | Neu |
|---|---|
| 107 Knoten in einem n8n-Workflow, Logik in Regex und Marker-Texten | Kleine, getrennte Bausteine mit klaren Ein- und Ausgaben, einzeln testbar |
| Schlüssel im Workflow | Schlüssel nur in Umgebungsvariablen, nie im Repo |
| Zielumfang wird gefordert, aber nicht gemessen | Messbare Abnahmekriterien pro Stufe (Wörter, Kapitel, Formatprüfung) |
| Alles in einem Lauf | Jede Stufe speichert ihr Ergebnis, der Mensch kann prüfen, ändern, weitermachen |
| Windows-Pfade, lokales Docker | Läuft in jeder Umgebung gleich, Pfade konfigurierbar |
| Buchdaten verstreut | Eine Datei pro Buch (`books/<slug>/book.yaml`) als einzige Wahrheit |

## 4. Vorgeschlagene Architektur (❓ zur Diskussion)

```
books/<slug>/book.yaml            Buchdaten: Titel, Zielgruppe, Umfang, Format, Stil
        │
        ▼
 1 Recherche & Konzept   →  research.md, concept.md          ── Freigabe 1 (Mensch)
 2 Gliederung            →  outline.md                       ── Freigabe 2 (Mensch)
 3 Manuskript            →  manuscript/kapitel-01.md …
 4 Lektorat & Prüfung    →  manuscript-final.md, report.md   (Wörter, Fakten, Rechtsstand)
 5 Satz                  →  interior.pdf                     (KDP-Maße, Prüfung)
 6 Cover                 →  cover-print.pdf, cover-ebook.jpg
 7 KDP-Paket             →  kdp-metadata.yaml, Upload-Checkliste ── Freigabe 3 (Mensch)
 8 Werbung (Phase 2)     →  Texte, Bilder, Clips, Posting-Plan
```

Jede Stufe liest die Ausgabe der vorigen und schreibt in denselben Buchordner. Dadurch kann man jederzeit bei Stufe N neu starten.

✅ **Technik: n8n.** Aufbau: ein **Dirigenten-Workflow** (Chat-Eingabe, Freigaben, Wiedereinstieg) ruft pro Stufe einen eigenen **Teil-Workflow** auf (Execute Workflow). Jeder Teil-Workflow hat höchstens ca. 10–15 Knoten, feste Ein- und Ausgabe-Dateien und einen eigenen Testlauf. Die Workflow-JSONs liegen versioniert in `workflows/` in diesem Repo. Schlüssel nur als n8n-Credentials.

Übernommen aus V7.x: Gotenberg für PDFs, Checkpoint-Dateien, Chat-Befehle (`ab manuskript` usw.). Neu: Ein Knoten „Abnahme" am Ende jeder Stufe prüft die Kriterien aus Abschnitt 5 und bricht mit klarer Meldung ab, statt still weiterzulaufen.

## 5. Abnahmekriterien (Beispiele)
- Manuskript: Zielumfang in Wörtern erreicht (bei Sachbuch z. B. ≥ 18.000), alle Kapitel aus der Gliederung vorhanden, kein Kapitel unter Mindestlänge.
- Innen-PDF: Seitenzahl im KDP-Limit, Beschnitt und Ränder korrekt, Schriften eingebettet.
- Cover: Rückenbreite aus Seitenzahl und Papierart berechnet, Auflösung ≥ 300 dpi.
- Sachbuch mit Rechtsbezug (z. B. 34a): Rechtsstand mit Datum belegt, Quellen aufgeführt.

## 6. Marke und Design
- Logo, Claim und Canva-Designs sind vorhanden (siehe `docs/sammlung/marke.md`).
- Es fehlt ein festgelegtes **Brand-Kit**: Farben, Schriften, Cover-Stil je Buchtyp.
- ❓ Soll der Neustart mit einem Design-Fundament beginnen (Farben, Schriften, Cover-Raster), bevor das erste Buch entsteht?

## 7. Das erste Buch (Pilot)
✅ **„Der 34a-Schein"** wird neu erzeugt. Das Material liegt vor, wir vergleichen alt (ca. 12.200 Wörter) gegen neu (Ziel ≥ 18.000), und der Rechtsstand wird vor dem Livegang frisch geprüft. Erst danach folgt ein kleines Testbuch (z. B. Malbuch) für die visuellen Stufen.

## 7a. Webseite (Wunsch des Auftraggebers)
Ein **Webseiten-Agent** baut und pflegt eine eigene Seite nur für die Bücher. Kauf läuft über Amazon (Weiterleitung), kein eigener Versand. Hosting kostenlos über GitHub Pages. Pflichtseiten Impressum und Datenschutz vor dem Livegang. Details: `docs/INTERVIEW.md`, Runde 4.

## 8. Phasen
| Phase | Inhalt | Ergebnis |
|---|---|---|
| 0 | Sicherheit: Schlüssel erneuern, Repo privat | sauberes Fundament |
| 1 | Plan freigeben (dieses Dokument) und Brand-Kit | festgelegte Entscheidungen |
| 2 | Pilotbuch durch Stufen 1–4 | geprüftes Manuskript |
| 3 | Satz, Cover, KDP-Paket (Stufen 5–7) | Upload-fertiges Paket |
| 4 | Werbung: Texte, Bilder, Clips und Freigabe-Workflow vorbereiten; Posting erst nach KDP-Livegang | erste Kampagne |
| 5 | Weitere Buchtypen (Malbuch, Rätsel, Hörspiel) | breiteres Angebot |

## 9. Regeln für das Projekt
- Keine Schlüssel im Repo, nie.
- Keine erfundenen Rezensionen, keine Bestehensgarantien.
- Werbung nur auf eigenen Kanälen, nur mit funktionierendem Kauflink.
- Alles, was Geld kostet oder nach außen geht (Credits, Posts, KDP-Upload), wird vorher freigegeben.

## 10. Offene Fragen (Zusammenfassung)
1. ❓ Welche Buchtypen sind in Phase 1 wirklich wichtig (nur Sachbuch, oder gleich Malbuch/Rätsel)?
2. ❓ Welche Kanäle zählen für die Werbung: Facebook-Seite, Instagram, YouTube, Shopify? (Telegram „Deal-Radar" ist ein anderes Projekt.)
3. ❓ Brand-Kit: Farben und Schriften vorgeben oder aus dem Logo ableiten?
4. ❓ Gibt es ein Autorenfoto fürs Cover, und welcher Autorenname soll erscheinen?
5. ✅ n8n läuft zuerst auf dem Laptop. Der alte PC wird später zum Server (Zeitsteuerung, Telegram-Bot). Details: `docs/INTERVIEW.md`, Runde 6.
6. ❓ Werbebudget: nur organisch (Posts) oder auch bezahlte Anzeigen (Meta Ads)?
7. ❓ Schlüssel aus dem alten Workflow schon erneuert und Repo auf privat gestellt? (siehe `docs/sammlung/sicherheit.md`)
