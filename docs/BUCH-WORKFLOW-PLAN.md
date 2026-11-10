# Plan: Der Buch-Workflow (Stufe für Stufe)

Status: **PLAN, nicht gebaut.** Grundlage sind die Wünsche des Auftraggebers vom 10.11.2026 (siehe `INTERVIEW.md`, Runde 10). Erst wenn dieser Plan freigegeben ist, wird gebaut.

## 1. Bedienung: Telegram-Chat
Der Auftraggeber schreibt dem Bot einen Auftrag, zum Beispiel: „Buch über Selbstverteidigung für Frauen". Der Bot meldet sich mit Zwischenständen und fragt bei Freigaben nach.

Befehle (Vorschlag): `/neu <Thema>`, `/ok` (Vorschau bestätigen oder freigeben), `/aendern <Wunsch>`, `/status`, `/stopp`.
Technik: Telegram-Bot (Token von @BotFather) und n8n. Auf dem Laptop braucht n8n dafür einen kostenlosen Tunnel oder fragt Telegram regelmäßig selbst ab.

## 2. Die Kette der KI-Rollen
```
Telegram-Auftrag
  → 1 PLANER (nimmt Auftrag an, teilt in Aufgaben auf, verteilt)
  → 2 RECHERCHEUR (10 beste Bücher zum Thema finden)
  → 3 KONKURRENZ-ANALYST (zerlegt die 10 Bücher, Bericht + Einschätzung)
  → 4 KONZEPT-AUTOR (wie wird unser Buch besser? Gliederung, USP)   ── FREIGABE 1 (du)
  → 5 BILD-BESCHAFFER (richtige, erlaubte Bilder suchen, sonst korrekt erstellen)
     + COVER (gleichzeitig)
  → 6 REDAKTION (sammelt alles in ein Briefing-Paket für den Schreiber)
  → 7 SCHREIBER (Kapitel für Kapitel, menschlicher Stil)
  → 8 FAKTENPRÜFER + LEKTOR (zweite, unabhängige KI)
  → 9 FORMATIERER (kein KI: Code, feste KDP-Maße)
  → 10 ENDKONTROLLE (Buch + Cover gegen Analyse, Fehler beheben, erneut prüfen)
  → 11 AUSGABE auf den Laptop + Metadaten für Amazon                ── FREIGABE 2 (du)
```

| Rolle | Aufgabe | Vorgeschlagene KI (je nach Zugang) |
|---|---|---|
| Planer | Auftrag verstehen, Aufgaben verteilen, Telegram-Meldungen | günstiges, schnelles Modell (z. B. Gemini Flash) |
| Rechercheur | Top-10-Bücher im Netz finden, Fachquellen sammeln | Perplexity oder Gemini mit Websuche |
| Konkurrenz-Analyst | Bücher auseinandernehmen, Bericht + Einschätzung | Claude (starke Analyse) |
| Konzept-Autor | besseres Buch planen | Claude |
| Bild-Beschaffer | erlaubte Bilder finden, Lizenz protokollieren | Suche über freie Bildquellen + Prüfregeln |
| Redaktion | Briefing-Paket zusammenstellen | günstiges Modell |
| Schreiber | Text, der menschlich klingt | Claude |
| Faktenprüfer | jede Aussage gegen Quelle | Gemini oder Perplexity (anderes Modell als der Schreiber) |
| Formatierer | Maße, PDF, Cover-Rücken | **Code, keine KI** |

Über welchen Zugang die KIs laufen (freie LLM-API auf dem Laptop, OmniRoute, eigene Schlüssel), ist noch offen.

## 2a. Ablauf mit Vorschau und paralleler Aufteilung (Stand 10.11.2026, ersetzt das Schema oben)

**1. Vorschau zuerst (spart Tokens und Geld).** Nach dem Auftrag erzeugt der Planer mit einem günstigen Modell nur eine **Vorschau** und schickt sie per Telegram: Arbeitstitel, Zielgruppe, grobe Gliederung, ob Bilder nötig sind, geschätzte Seitenzahl, welche KI welche Aufgabe übernimmt, geschätzte Kosten (Tokens). Nichts Teures läuft, bevor du `/ok` sagst. Mit `/aendern` korrigierst du, mit `/stopp` brichst du ab. Dieselbe Regel gilt später vor dem Schreiben: erst der Kapitelplan als Vorschau, dann der Text.

**2. Aufteilung in drei Stränge, gleichzeitig.** Nach deinem OK verteilt der Planer die Arbeit:
- **Strang A:** Recherche (10 beste Bücher) → Analyse → Konzept → **Freigabe 1** durch dich.
- **Strang B:** Bilder. Bildbedarf vorab ermitteln, Bilder suchen oder beschaffen, Lizenz notieren.
- **Strang C:** Cover. Vorentwurf aus dem Thema.
- Ehrlich dazu: Cover und Bilder können erst **fertig** werden, wenn Titel und Gliederung feststehen. Die Vorarbeit läuft parallel, die Endfassung kommt nach Freigabe 1.

**3. Sammelstelle.** Sobald die Stränge fertig sind, geht alles an die **Redaktion**. Sie bündelt Berichte, Konzept, Bilder samt Lizenzen und Cover in ein Briefing. Erst damit schreibt der **Schreiber**.

**4. Cover-Vorgabe.** Auf dem Cover steht ein **Erklärtext** (worum es im Buch geht, für wen) und das **Logo**. Vorderseite: Titel, Untertitel, kurzer Erklärtext, Logo. Rückseite: Klappentext und Logo. Rücken (nur wenn KDP ihn bei der Seitenzahl erlaubt): Titel, Autor, Logo. Logo liegt in `assets/marke/`.

**5. Sparregeln.** Günstiges Modell für Planer und Redaktion, starkes nur für Analyse, Schreiben, Lektorat. Recherche einmal speichern und wiederverwenden. Nur geänderte Kapitel neu schreiben.

Das Pipeline-Bild (Arbeitsfläche) zeigt diesen Ablauf.

## 2b. Speicherpunkte: nie wieder von vorn anfangen
Der Workflow speichert nach jeder wichtigen Stufe einen **Speicherpunkt** im Buchordner (`books/<slug>/state.json` plus die Ergebnisdateien). Fällt etwas aus oder willst du etwas ändern, geht es **ab dem letzten Punkt** weiter, nicht von vorn.

| Speicherpunkt | Danach liegt vor |
|---|---|
| 0 Auftrag | Thema, Buchtyp, Seitenziel |
| 1 Vorschau bestätigt (`/ok`) | Plan und Kostenschätzung |
| 2 Recherche | 10 Bücher, Quellen |
| 3 Analyse | Bericht und Einschätzung |
| 4 Konzept (Freigabe 1) | Gliederung, Titel, Bildbedarf |
| 5 Briefing | alles gebündelt für den Schreiber |
| 6 Kapitel 1 … n | jedes fertige Kapitel einzeln |
| 7 Prüfung/Endkontrolle | geprüftes Buch |
| 8 Ausgabe | Dateien und KDP-Eintragsliste |

Befehle dazu: `/los` (schreibt **ab dem letzten Punkt das ganze Buch**), `/ab analyse`, `/ab konzept`, `/ab kapitel 7`, `/status` (zeigt den aktuellen Punkt). Ein Kapitel, das schon fertig ist, wird nicht neu geschrieben, wenn du nichts daran änderst.

Ein weiterer Nutzen: Recherche und Analyse bleiben gespeichert. Für ein ähnliches Buch (zum Beispiel Selbstverteidigung für Männer) startet man ab Punkt 3 mit angepasstem Bericht.

## 2c. Seitenziele je Buchtyp
Vorgaben des Auftraggebers: **viele Seiten**.

| Buchtyp | Seitenziel | grob in Wörtern* |
|---|---|---|
| Geschichtsbuch | 300 bis 400 und mehr | ca. 90.000 bis 120.000 |
| Dokumentationsbuch | ca. 100 | ca. 30.000 |
| Taschenbuch (normal) | 60 bis 100, oder 40 bis 70 (❓ welche Art wann?) | ca. 12.000 bis 30.000 |
| Malbuch (Ausmalen, Malen nach Zahlen, gemischt) | 20 bis 30, **KDP verlangt mindestens 24** | fast nur Bilder |

*Schätzung für das Format 6 × 9 Zoll, Schrift 11 Punkt, nur Text, etwa 300 Wörter pro Seite. Mit Bildern sind es weniger Wörter. Die Umrechnung macht der Formatierer pro Buch mit dem echten Format.

Wichtig dazu:
- **Seiten dürfen nicht mit Füllmaterial entstehen.** Leere Seiten, Wiederholungen oder aufgeblähte Sätze fallen Lesern auf und senken die Bewertung. Bilder, Zeitleisten, Merkkästen, Übungen und Quellenverzeichnis zählen dagegen als echter Inhalt.
- **Ein Geschichtsbuch mit 300 bis 400 Seiten ist ein großes Projekt.** Es braucht sehr viele Quellen, eine strenge Faktenprüfung und deutlich mehr KI-Aufrufe als ein 60-Seiten-Buch. Mit rein kostenlosen KI-Zugängen ist das wegen der Mengenbegrenzungen schwer. Darum: erst ein kürzeres Buch als Pilot.
- **Mehr Seiten kosten bei KDP mehr Druckkosten.** Der Verkaufspreis muss mitwachsen, sonst bleibt kaum Gewinn.
- KDP verlangt mindestens 24 Seiten für Taschenbücher. Ein Rückenbild oder Rückentext geht erst ab einer bestimmten Seitenzahl (meines Wissens etwa 79 Seiten, wird im Formatierer geprüft).

## 2d. Sonderfall Malbuch
Wunsch des Auftraggebers: Malbücher mit **20 bis 30 Seiten**. Inhalt: **Ausmalbilder**, **Malen nach Zahlen** oder beides **gemischt**.

- **Seitenzahl:** Bei Taschenbüchern verlangt KDP mindestens 24 Seiten. Geplant werden deshalb 24 bis 30 Seiten inklusive Titelseite und Hinweisseite. Die Seiten werden einseitig bedruckt (Rückseite leer), damit Farbe nicht durchdrückt.
- **Gemischt:** Der Anteil wird pro Buch festgelegt, zum Beispiel die Hälfte Ausmalbilder, die Hälfte Malen nach Zahlen.
- **Ausmalbilder:** Linienzeichnungen mit gleichmäßigen Linien und geschlossenen Flächen. Bild-KIs liefern dabei oft Fehler (offene Linien, kleine Unsauberkeiten). Darum erzeugt der Bild-Beschaffer mehrere Kandidaten, ein Code-Schritt prüft (Auflösung 300 dpi, Schwarz-Weiß, Linien), und du wählst per Kontaktbogen im Telegram-Chat aus.
- **Malen nach Zahlen:** Nummerierte Flächen und die Farbtabelle werden per **Code** aus dem Bild berechnet, nicht per KI. Nur so stimmen die Nummern verlässlich.
- **Text:** wenig. Titel, Anleitung, Farbliste. Die Schreiber-Rolle ist klein, die Bild-Rolle groß.
- **Regeln:** keine geschützten Figuren (Marken, Filmfiguren). KI-Angabe bei KDP. Der Preis ist niedrig, der Gewinn pro Buch klein. Das rechnet sich erst mit mehreren Titeln, die Konkurrenz ist groß.
- ❓ **Zielgruppe:** Kinder oder Erwachsene? Das ändert Motive, Linienstärke und Schwierigkeit.

## 2e. Anleitungs-Sachbücher mit Bildern, Maßen und Bauplänen
Der Workflow ist **themenoffen**. Selbstverteidigung war nur ein Beispiel. Ebenso gehören Anleitungsbücher dazu, zum Beispiel **Holzbearbeitung** oder Handwerk. Dort braucht das Buch **schöne Bilder, genaue Maße und Baupläne**, sonst funktioniert es nicht.

- **Pläne und Maße kommen aus Code, nicht aus einer Bild-KI.** Bild-KIs zeichnen keine maßhaltigen Pläne. Der Workflow erzeugt Zeichnungen (Vorne, Seite, Oben, Explosionsansicht) aus einer Beschreibung des Projekts mit echten Maßen in Millimetern, mit Bemaßung und Maßstab.
- **Stückliste und Zuschnittliste** werden ebenfalls per Code berechnet. Eine Prüfung vergleicht: Jedes Maß in der Zeichnung steht in der Liste, die Summen stimmen, die Teile passen aus dem angegebenen Material.
- **Fotos:** am besten **eigene Fotos** vom gebauten Stück und von Arbeitsschritten. Freie Bilder passen selten genau zu einem bestimmten Bauvorhaben. Der Workflow liefert dir dafür eine **Fotoliste** (Schritt, was muss zu sehen sein).
- **Schöne Bilder:** Stimmungsbilder und Titelbilder dürfen von einer Bild-KI kommen, Anleitungsbilder nicht, wenn auf ihnen ein Handgriff oder ein Detail stimmen muss.
- **Sicherheit:** Pflichtabschnitt zu Schutzausrüstung und Werkzeug, Haftungshinweis. Ein **Probebau** oder die Prüfung durch jemanden vom Fach ist bei Bauplänen besonders sinnvoll, weil ein falsches Maß teures Material kostet.
- **Einheiten und Schreibweise:** metrisch, einheitlich (mm oder cm, Dezimalkomma). Der Prüfer achtet darauf.
- **Seitenmaßstab:** Pläne im Buch werden mit angegebenem Maßstab auf die Buchseite eingepasst, damit sie lesbar bleiben.

## 3. Stufe 2–3: Recherche und Konkurrenzanalyse
**Auftrag:** Die 10 besten Bücher zum Thema finden, gründlich auseinandernehmen, Bericht und Einschätzung.

**Was die KI aus öffentlichen Angaben lesen kann:** Titel, Untertitel, Klappentext, Inhaltsverzeichnis, Preis, Seitenzahl, Format, Erscheinungsjahr, Bewertungen und vor allem die Kritikpunkte aus 1–3-Sterne-Rezensionen, Verkaufsrang, Kategorien, Stichwörter in Titel und Beschreibung.

**Was sie nicht kann:** Die ganzen Bücher lesen (urheberrechtlich geschützt, nicht frei zugänglich). „Gründlich auseinandernehmen" heißt hier: Aufbau, Versprechen, Lücken und Leserbeschwerden analysieren. Inhalte werden nie abgeschrieben.

**Bericht (Ausgabe):** Tabelle der 10 Bücher, pro Buch Stärken/Schwächen, Lücken im Markt, was Leser vermissen, empfohlene Positionierung, Preisspanne.

## 4. Stufe 4: Das bessere Buch planen
Der Konzept-Autor nimmt den Bericht und legt fest: Zielgruppe, Versprechen, Gliederung, was **anders und besser** ist als die Konkurrenz, ob und wo Bilder nötig sind, Seitenumfang, Format. Du gibst frei (Freigabe 1), erst danach wird Geld ausgegeben.

## 5. Stufe 5: Bilder (wichtig und heikel)
**Regel des Auftraggebers: Es darf nie etwas Falsches dabei sein.**

Wann Bilder gebraucht werden, bestimmt das Konzept je Buchtyp:
- Selbstverteidigung, Anleitungen, Geschichte, Atlas, Dokumentation: viele Bilder.
- Ratgeber/Sachbuch: nur wo sie erklären.
- Roman, Sudoku: kaum oder keine.

Wege zu korrekten Bildern, in dieser Reihenfolge:
1. **Freie Bilder suchen** (z. B. Wikimedia Commons, Openverse, Pixabay) und **Lizenz pro Bild protokollieren**. Nur Lizenzen, die kommerzielle Nutzung erlauben. Bei Namensnennung (CC-BY) kommt der Nachweis ins Buch.
2. **Eigene Fotos** nach einer vom Workflow erstellten Schritt-Liste (Handy, ein Trainingspartner).
3. **Einfache Zeichnungen/Strichfiguren** aus Code, deren Körperhaltung stimmt.
4. **KI-Bilder nur dort, wo Fehler nicht schaden** (Stimmungsbilder, Cover). Für Griffe und Techniken nicht: KI-Bilder zeigen oft falsche Hände, Finger und Körperhaltungen.

Jedes Bild bekommt in `bilder.json` einen Eintrag: Quelle, Lizenz, Urheber, geprüft ja/nein. Ohne Eintrag kommt kein Bild ins Buch.

## 6. Stufe 6: Briefing-Paket (Redaktion)
Eine eigene Stufe sammelt Recherche, Konzept, Bilder samt Lizenzen, Cover-Entwurf und Stilvorgaben in **einer** Datei für den Schreiber. Das verhindert, dass der Schreiber raten muss.

## 7. Stufe 7: Der Schreiber
- Kapitel für Kapitel, jedes mit eigenem Auftrag.
- **Stilanleitung** für einen menschlichen Ton: konkrete Beispiele, kurze und lange Sätze gemischt, direkte Ansprache, Geschichten statt Floskeln, keine KI-typischen Standardsätze. Der Auftraggeber gibt ein Textbeispiel vor, das ihm gefällt.
- Der Workflow verspricht keinen „unauffindbaren" KI-Text. Wichtig ist, dass das Buch gut klingt und stimmt.

## 8. Stufe 8: Prüfung
Eine **andere** KI als der Schreiber prüft jede Tatsachenbehauptung gegen die gesammelten Quellen. Bei Selbstverteidigung zusätzlich: rechtliche Aussagen (Notwehr, Erlaubtes) und Sicherheitshinweise. Nicht belegbare Aussagen werden gestrichen oder markiert.

## 9. Stufe 9: Formate und Cover-Maße (ohne KI)
Damit du nie wieder Maße prüfen musst, gibt es eine **feste Formattabelle als Code**: Taschenbuch- und E-Book-Formate, Seitenlimits je Papierart, Beschnitt, Ränder, Rückenbreite aus Seitenzahl. Cover und Innen-PDF werden daraus berechnet und automatisch geprüft. Die Tabelle trägt ein Prüfdatum, weil Amazon Regeln ändert. Ein Vorbild liegt im alten Workflow (`archiv/n8n/…`, Knoten „KDP FORMATKATALOG").

## 9a. Stufe 10: Endkontrolle mit Verbesserungsschleife
Wenn Buch, Cover und Bilder fertig sind, geht alles noch einmal durch eine **Endkontrolle**:

1. **Buch gegen die Analyse:** Hält das Buch, was das Konzept versprochen hat? Sind die Lücken aus dem Konkurrenzbericht geschlossen? Fehlen Kapitel, gibt es Wiederholungen, Widersprüche oder Stilbrüche?
2. **Inhalt und Fakten:** letzter Durchgang gegen Quellen und Bildprotokoll.
3. **Cover:** Maße, Beschnitt, Ränder und Rücken per Code. Dazu ein Blick einer Bild-KI: Titel auch als Daumenbild lesbar, nichts schneidet in den Rand, Rücken und Rückseite sitzen.
4. **Innen-PDF:** Seitenumbrüche, Bilder an der richtigen Stelle, keine leeren oder halben Seiten, Inhaltsverzeichnis stimmt.
5. **Verbessern und neu prüfen:** Findet die Kontrolle etwas, wird genau das behoben und **danach nochmal geprüft**. Höchstens 3 Runden. Bleibt nach Runde 3 etwas offen, meldet der Bot es im Telegram-Chat, statt endlos weiterzuarbeiten.

Ergebnis: ein **Prüfbericht** (`kontrolle.md`) mit dem, was gefunden und behoben wurde.

Eine letzte Sicht bleibt bei dir: Amazon hat vor dem Veröffentlichen eine eigene Vorschau (KDP-Vorschau). Die kann kein Workflow ersetzen. Die Checkliste sagt dir, worauf du dort achtest.

## 9b. Stufe 11: Ausgabe auf dem Laptop und Metadaten für Amazon
Am Ende wird alles in einem Ordner auf dem Laptop gespeichert (`books/<slug>/ausgabe/`):

| Datei | Inhalt |
|---|---|
| `interior.pdf` | Innenteil Taschenbuch |
| `ebook.epub` (oder Dokument für Kindle) | E-Book-Fassung |
| `cover-print.pdf` | komplettes Taschenbuch-Cover |
| `cover-ebook.jpg` | E-Book-Cover |
| `kdp-eintragen.md` | **Eintrag-Anleitung in der Reihenfolge der KDP-Seiten** |
| `kdp-metadata.yaml` | dieselben Angaben maschinenlesbar |
| `kontrolle.md` | Prüfbericht der Endkontrolle |
| `bilder-lizenzen.md` | Quellen und Lizenzen aller Bilder |

`kdp-eintragen.md` enthält, zum Abschreiben und Einfügen: Titel, Untertitel, Reihe, Autorenname, Beschreibung (fertig formatiert), **7 Suchbegriffe**, **Kategorien** (mit Pfad), Sprache, Altersempfehlung, Preis je Land (mit Gewinnrechnung), Format, Papier (weiß/creme), Innenseiten (Schwarz-Weiß/Farbe), Beschnitt, Cover-Oberfläche (matt/glänzend), ISBN-Wahl, KI-Angabe, Kindle-Optionen (z. B. Kindle+/KDP Select) und Rechteangaben.
Preisrechnung und Kategorien sind Vorschläge aus dem Konkurrenzbericht. Amazon kann Regeln und Kategorien ändern, deshalb steht das Datum dabei.

## 10. Vorgaben von Amazon
- Amazon verlangt bei KDP die Angabe, wenn Texte oder Bilder von KI erzeugt wurden. Der Workflow erzeugt dafür eine Angabe im KDP-Paket.
- Kein Hochladen durch den Workflow, da Amazon keine Schnittstelle bietet. Der Auftraggeber lädt mit Checkliste hoch.

## 11. Offene Fragen
1. ❓ Welche KI-Zugänge sind wirklich da und kostenlos nutzbar (Claude, Perplexity, Gemini, OmniRoute/„Free LLMs API")?
2. ✅ Bilder (entschieden): Der Auftraggeber macht Bilder **selbst**, oder der Workflow sucht **öffentlich erlaubte** Bilder im Netz zum jeweiligen Griff/Thema (mit Lizenzprotokoll). Der Workflow liefert dazu eine Bildliste: Welches Bild wird gebraucht, was muss darauf zu sehen sein, damit es als Aufklärungsbild stimmt.
3. ❓ Fachprüfung je Thema (z. B. Selbstverteidigung: Trainer oder Jurist; Holzarbeiten: Tischler oder Probebau)
4. ❓ Stilvorlage: ein Textbeispiel, das der Auftraggeber „menschlich" findet.
5. ❓ Ablauf der Freigaben im Telegram-Chat (Knöpfe oder Text)?
