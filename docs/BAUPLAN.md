# Bauplan: Mitsch Book Design, Neustart

**Status: ENTWURF.** Es wird erst gebaut, wenn der Plan zusammen mit dem Auftraggeber freigegeben ist. Offene Entscheidungen sind mit ❓ markiert.

## 1. Ziel
Ein System, das aus einer Buchidee ein **KDP-fertiges Buch** macht (Innen-PDF, Cover, Metadaten) und anschließend **Werbematerial** dazu erzeugt. Der Mensch gibt an den wichtigen Stellen frei. Qualität vor Menge.

❓ Ist das Ziel so richtig, oder soll Werbung erst in Phase 2 dazukommen?

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

❓ **Technik:** n8n weiterverwenden (kleinere Workflows, Teil-Workflows pro Stufe) oder ein Code-Projekt (z. B. Python/Node, in diesem Repo, läuft in GitHub Actions oder lokal)?

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
Vorschlag: **„Der 34a-Schein"** neu erzeugen. Es ist das einzige vorhandene Buch, das Material liegt vor und wir können alt gegen neu vergleichen.
❓ Oder lieber ein neues, kleineres Buch (z. B. Malbuch), um die Pipeline schnell zu testen?

## 8. Phasen
| Phase | Inhalt | Ergebnis |
|---|---|---|
| 0 | Sicherheit: Schlüssel erneuern, Repo privat | sauberes Fundament |
| 1 | Plan freigeben (dieses Dokument) und Brand-Kit | festgelegte Entscheidungen |
| 2 | Pilotbuch durch Stufen 1–4 | geprüftes Manuskript |
| 3 | Satz, Cover, KDP-Paket (Stufen 5–7) | Upload-fertiges Paket |
| 4 | Werbung: Texte, Bilder, Clips, Freigabe-Workflow | erste Kampagne |
| 5 | Weitere Buchtypen (Malbuch, Rätsel, Hörspiel) | breiteres Angebot |

## 9. Regeln für das Projekt
- Keine Schlüssel im Repo, nie.
- Keine erfundenen Rezensionen, keine Bestehensgarantien.
- Werbung nur auf eigenen Kanälen, nur mit funktionierendem Kauflink.
- Alles, was Geld kostet oder nach außen geht (Credits, Posts, KDP-Upload), wird vorher freigegeben.

## 10. Offene Fragen (Zusammenfassung)
1. Ziel und Reichweite der ersten Version (nur Bücher, oder gleich Werbung)?
2. Technik: n8n oder Code?
3. Pilotbuch: „Der 34a-Schein" neu oder neues Buch?
4. Welche Buchtypen sind in Phase 1 wirklich wichtig?
5. Ist „Der 34a-Schein" schon auf KDP veröffentlicht, und gibt es weitere Bücher?
6. Welche Kanäle zählen: Facebook-Seite, Instagram, YouTube, Shopify, Telegram?
7. Brand-Kit: Farben und Schriften vorgeben oder aus dem Logo ableiten?
