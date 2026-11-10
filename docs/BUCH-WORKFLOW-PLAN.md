# Plan: Der Buch-Workflow (Stufe für Stufe)

Status: **PLAN, nicht gebaut.** Grundlage sind die Wünsche des Auftraggebers vom 10.11.2026 (siehe `INTERVIEW.md`, Runde 10). Erst wenn dieser Plan freigegeben ist, wird gebaut.

## 1. Bedienung: Telegram-Chat
Der Auftraggeber schreibt dem Bot einen Auftrag, zum Beispiel: „Buch über Selbstverteidigung für Frauen". Der Bot meldet sich mit Zwischenständen und fragt bei Freigaben nach.

Befehle (Vorschlag): `/neu <Thema>`, `/status`, `/freigabe`, `/aendern <Wunsch>`, `/stopp`.
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
  → 10 KDP-PAKET                                                    ── FREIGABE 2 (du)
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

## 10. Gesetzt aus den Vorgaben
- Amazon verlangt bei KDP die Angabe, wenn Texte oder Bilder von KI erzeugt wurden. Der Workflow erzeugt dafür eine Angabe im KDP-Paket.
- Kein Hochladen durch den Workflow, da Amazon keine Schnittstelle bietet. Der Auftraggeber lädt mit Checkliste hoch.

## 11. Offene Fragen
1. ❓ Welche KI-Zugänge sind wirklich da und kostenlos nutzbar (Claude, Perplexity, Gemini, OmniRoute/„Free LLMs API")?
2. ❓ Bilder für Selbstverteidigung: eigene Fotos, Zeichnungen oder freie Bilder zuerst?
3. ❓ Fachprüfung bei Selbstverteidigung (Trainer oder Jurist)?
4. ❓ Stilvorlage: ein Textbeispiel, das der Auftraggeber „menschlich" findet.
5. ❓ Ablauf der Freigaben im Telegram-Chat (Knöpfe oder Text)?
