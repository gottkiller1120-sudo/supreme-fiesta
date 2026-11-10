# Pipeline-Entwurf: vom Buchauftrag zum verkaufsfertigen Buch

Status: ENTWURF zur Besprechung. Passt zu `BAUPLAN.md`. Es wird noch nichts gebaut: erst Bauplan, dann Freigabe, dann Bau.

## Grundidee: parallel, wo es geht, nacheinander, wo es muss
Nicht alles kann gleichzeitig laufen, weil manches von etwas anderem abhängt:
- Das **Cover vorne** braucht nur Titel und Konzept, nicht das fertige Buch.
- Der **Buchrücken** braucht die endgültige **Seitenzahl**, also das fertige Innen-PDF.
- Die **Werbung** braucht Titel, Klappentext und Cover vorne, aber nicht das fertige Manuskript.
- Der **Amazon-Link** gibt es erst nach dem Livegang.

```
Auftrag (book.yaml)
  → 1 Recherche (Markt + Fachquellen)
  → 2 Konzept & Gliederung  ──► FREIGABE 1 (du)
        ├─► 3A Manuskript: Kapitel einzeln → Lektorat → Faktencheck → Endfassung
        │        → 4 Innen-PDF (Seitenzahl)
        ├─► 3B Cover vorne: 3 Motive → du wählst → Typografie
        └─► 3C Werbung vorbereiten: Texte, Bilder, Posting-Plan, Webseitenseite
                 → du gibst Teaser frei → Teaser in Gruppen (ohne Kauflink)
  4 + 3B → 5 Komplett-Cover (Rücken aus Seitenzahl, Rückseite)
  → 6 KDP-Paket (Metadaten, Keywords, Kategorien, Preis)  ──► FREIGABE 3 (du)
  → 7 Upload durch dich (KDP hat keine Upload-Schnittstelle)
  → 8 Livegang: Amazon-Link eintragen → Werbung, Webseite, Partnerlinks
```

## Was jede Stufe leistet (und woran man sie abnimmt)
| Stufe | Ergebnis | Abnahme |
|---|---|---|
| 1 Recherche | `research.md`, `quellen.json` | Konkurrenz (Titel, Preise, Lücken), Suchbegriffe, nur **offizielle Quellen** für Rechtsstoff, jede Aussage mit Quelle |
| 2 Konzept | Titel, Untertitel, USP, Kapitelplan, Klappentext, 7 Keywords, Preis | Du gibst frei. Erst danach wird Geld (KI-Aufrufe) ausgegeben |
| 3A Manuskript | ein Kapitel pro Datei | Mindestlänge je Kapitel, alle Kapitel da, Fakten gegen Quellen geprüft |
| 3B Cover vorne | 3 Motive, 1 gewähltes | Auflösung ≥ 300 dpi, Titel lesbar als Daumenbild |
| 3C Werbung | Texte, Bilder, Plan | Keine Garantien, keine falschen Rezensionen, Kennzeichnung |
| 4 Innen-PDF | `interior.pdf` | KDP-Maße, Ränder, Schriften eingebettet, Seitenzahl |
| 5 Komplett-Cover | `cover-print.pdf`, `cover-ebook.jpg` | Rücken aus Seitenzahl und Papierart berechnet |
| 6 KDP-Paket | `kdp-metadata.yaml`, Checkliste | Alle KDP-Pflichtfelder gefüllt |

## So bleibt es gut, billig und schnell
- **Qualität:** Jedes Kapitel einzeln schreiben (lange Texte brechen sonst ein), danach ein **zweiter, unabhängiger Prüfdurchgang** gegen die Quellen. Bei einem Prüfungsbuch die Fragen am amtlichen Stoffplan ausrichten. Genau da liegt der Unterschied zu den üblichen Fragensammlungen.
- **Kosten:** Günstiges Modell für Rohtexte und Routine, stärkeres Modell nur für Fachkapitel, Lektorat und Faktencheck. Recherche einmal speichern und wiederverwenden. Nichts wird neu geschrieben, wenn nur ein Kapitel geändert wird.
- **Tempo:** 3A, 3B und 3C laufen gleichzeitig. Kapitel können parallel entstehen, solange die Gliederung steht.
- **Mensch an drei Stellen:** Freigabe 1 (Konzept), Cover-Wahl, Freigabe 3 (Upload). Mehr braucht es nicht, weniger wäre riskant.

## Was die Pipeline nicht kann (und warum)
- **KDP-Upload:** Amazon bietet keine Schnittstelle zum Hochladen. Du lädst Dateien selbst hoch, ich liefere eine Schritt-für-Schritt-Checkliste.
- **Verkaufszahlen abrufen:** Nur über Amazon-Berichte, nicht automatisch. Du kannst sie mir später als Datei geben.
- **Garantierte Qualität:** Die Pipeline senkt Fehler, sie ersetzt nicht die fachliche Prüfung eines Menschen bei Rechtsstoff.

## Datei-Layout pro Buch
```
books/<slug>/
  book.yaml            Auftrag und Entscheidungen
  research/            research.md, quellen.json
  concept/             concept.md, outline.md, blurb.md
  manuscript/          kapitel-01.md … manuscript-final.md
  design/              cover-front-*.png, cover-print.pdf, cover-ebook.jpg
  print/               interior.pdf
  kdp/                 kdp-metadata.yaml, upload-checkliste.md
  marketing/           teaser-*.md, bilder/, posting-plan.md
```
