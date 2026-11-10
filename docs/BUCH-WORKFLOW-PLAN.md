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
| Taschenbuch (normal) | 40 bis 70 (entschieden 10.11.2026) | ca. 12.000 bis 21.000 |
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
- ✅ **Zielgruppe:** Kinder **und** Erwachsene (entschieden 10.11.2026). Pro Buch wird festgelegt, für wen es ist. Das ändert Motive, Linienstärke und Schwierigkeit.

## 2e. Anleitungs-Sachbücher mit Bildern, Maßen und Bauplänen
Der Workflow ist **themenoffen**. Selbstverteidigung war nur ein Beispiel. Ebenso gehören Anleitungsbücher dazu, zum Beispiel **Holzbearbeitung** oder Handwerk. Dort braucht das Buch **schöne Bilder, genaue Maße und Baupläne**, sonst funktioniert es nicht.

- **Pläne und Maße kommen aus Code, nicht aus einer Bild-KI.** Bild-KIs zeichnen keine maßhaltigen Pläne. Der Workflow erzeugt Zeichnungen (Vorne, Seite, Oben, Explosionsansicht) aus einer Beschreibung des Projekts mit echten Maßen in Millimetern, mit Bemaßung und Maßstab.
- **Stückliste und Zuschnittliste** werden ebenfalls per Code berechnet. Eine Prüfung vergleicht: Jedes Maß in der Zeichnung steht in der Liste, die Summen stimmen, die Teile passen aus dem angegebenen Material.
- **Fotos:** am besten **eigene Fotos** vom gebauten Stück und von Arbeitsschritten. Freie Bilder passen selten genau zu einem bestimmten Bauvorhaben. Der Workflow liefert dir dafür eine **Fotoliste** (Schritt, was muss zu sehen sein).
- **Schöne Bilder:** Stimmungsbilder und Titelbilder dürfen von einer Bild-KI kommen, Anleitungsbilder nicht, wenn auf ihnen ein Handgriff oder ein Detail stimmen muss.
- **Sicherheit:** Pflichtabschnitt zu Schutzausrüstung und Werkzeug, Haftungshinweis. Ein **Probebau** oder die Prüfung durch jemanden vom Fach ist bei Bauplänen besonders sinnvoll, weil ein falsches Maß teures Material kostet.
- **Einheiten und Schreibweise:** metrisch, einheitlich (mm oder cm, Dezimalkomma). Der Prüfer achtet darauf.
- **Seitenmaßstab:** Pläne im Buch werden mit angegebenem Maßstab auf die Buchseite eingepasst, damit sie lesbar bleiben.

## 2f. KI-Zugänge: Bestandsaufnahme (10.11.2026)
Gefunden in den Einstellungen des alten Workflows (V7.8) und in Mails. Schlüssel wurden nicht gelesen und stehen hier nicht.

| Zugang | Fundstelle | Stand | Mögliche Rolle |
|---|---|---|---|
| Claude (Anthropic-API) | V7.8: Schlüssel, Workspace, Modell `claude-sonnet-5` (Hinweis im Workflow: `claude-opus-5` für mehr Qualität) | vorhanden, **kostenpflichtig**. In Mail-Zusammenfassungen taucht „Anthropic-Rechnung bezahlen" auf: prüfen, sonst kann der Zugang gesperrt sein | Analyst, Konzept, Schreiber, Lektor |
| Gemini (Google) | V7.8: Schlüssel, Modelle `gemini-3.6-flash`, `gemini-3.5-flash-lite`, Bildmodell `gemini-3.1-flash-image` | vorhanden. Schlüssel lag im Klartext, **neu erzeugen** (siehe `sammlung/sicherheit.md`). Gratis-Kontingent mit Grenzen (meines Wissens) | Recherche mit Google-Suche, Bilder, günstige Aufgaben (Planer, Redaktion) |
| OmniRoute (lokal) | V7.8: `http://host.docker.internal:20128`, Modell `auto`, eigener Schlüssel | läuft auf dem Laptop. **Welche Anbieter dahinter hängen, ist unbekannt** (auch ob kostenlos) | Fehlersuche, Sprachausgabe, Ausweichweg |
| Ollama (lokal) | V7.8: `http://host.docker.internal:11434`, Modell `llama3.3`. Mails: Ollama-Konto, Hinweis „Gratis-Cloudnutzung endet" | lokale Modelle sind gratis, Qualität und Tempo hängen vom Laptop ab | Planer, Vorschau-Entwürfe (nicht für lange Bücher) |
| OpenRouter | Mails: Konto vorhanden, Anmeldung am 05.11. | Guthaben unbekannt | Alternative zum Router |
| Cheaper Inference | Mails: Konto, Test „mitsch book design" (22.09.) | Guthaben unbekannt | günstiger Claude-Zugang möglich |
| Perplexity | nichts gefunden | unklar | Recherche mit Quellen |

**Stand 10.11.2026 (Auftraggeber):** Das **API-Guthaben bei Anthropic ist leer**. Es gibt ein **Claude-Pro-Abo**. Wichtig: Das Pro-Abo gilt für die Claude-App und Claude Code, die **API** (die n8n benutzt) wird **getrennt** über Guthaben bezahlt. Der Claude-Knoten im alten Workflow läuft deshalb ohne Aufladung nicht.

Wege für das Schreiben (zur Entscheidung):
- **A. Kleines API-Guthaben aufladen** und pro Auftrag in der Vorschau die Kosten zeigen. Sauberster Weg für einen Workflow, der selbst arbeitet.
- **B. Claude Code mit dem Pro-Abo als Schreiber auf dem Laptop.** Das spart API-Kosten, aber das Abo hat Nutzungsgrenzen, und meines Wissens darf man die Abo-Anmeldung nicht in fremden Programmen wie n8n als API verwenden. Das wird vor dem Bauen in den aktuellen Bedingungen geprüft.
- **C. Nur Gratis-Modelle** (Gemini-Gratiskontingent, Ollama, OmniRoute). Kostet nichts, ist aber bei langen Büchern begrenzt und schwächer.

**Entscheidung 10.11.2026 (Auftraggeber): Alle KI-Aufrufe laufen über OmniRoute.** Der bisherige Workflow läuft damit nach Aussage des Auftraggebers **ohne Aufladen** von API-Guthaben. Die Wege A, B und C oben sind damit zunächst nicht nötig.

So wird es umgesetzt:
- **Ein Zugang für alles:** Der neue Workflow ruft nur OmniRoute auf (`http://host.docker.internal:20128`, OpenAI-kompatibel). Welche Anbieter dahinter hängen, regelt OmniRoute.
- **Eine Einstellungsdatei** ordnet jeder Rolle ein Modell zu (Planer, Rechercheur, Analyst, Schreiber, Prüfer, Bild). Wechselt ein Anbieter oder fällt aus, ändert man eine Zeile, nicht den Workflow.
- **Modell pro Rolle festnageln statt `auto`.** Bei `auto` kann mitten im Buch das Modell wechseln, und dann ändern sich Stil und Qualität zwischen den Kapiteln. Nur für Planer und Redaktion ist `auto` unkritisch.
- **Kosten- und Mengenanzeige in der Vorschau bleibt**, auch bei Gratis-Anbietern. Sie zeigt dort die Menge (Tokens) und die Gefahr, an Grenzen zu stoßen.

Was offen und zu prüfen ist (ich sehe die OmniRoute-Einstellungen nicht):
- **Welche Anbieter und Modelle** dort hängen und welche für lange deutsche Texte taugen.
- **Mengenbegrenzungen:** Gratis- und Abo-Zugänge haben Grenzen. Ein Buch mit 40 bis 70 Seiten sollte gehen. Geschichtsbücher mit 300 Seiten stoßen eher an Grenzen.
- **Bedingungen der Anbieter:** Ob ein Abo-Zugang über einen Router erlaubt ist, hängt vom Anbieter ab. Das sollte der Auftraggeber bei seinen Anbietern prüfen, damit Konten nicht gesperrt werden.

### OmniRoute: Bestand laut Screenshot (10.11.2026, Version 3.8.50)
Verbundene Anbieter in der Anbieter-Übersicht: Gemini (Google AI Studio), Groq, OpenRouter, OpenAI, Anthropic, Perplexity, Kimi, Ollama Cloud, Cloudflare AI Playground, NVIDIA (über g4f.space), OpenCode Free, The Old LLM (Free), UncloseAI, Felo, AI Horde, DuckDuckGo AI Chat, Chipotle Pepper AI (Free).

Letzte Anfragen (alle vor 2 Tagen):
| Modell | Ergebnis laut Anzeige |
|---|---|
| `openai/gpt-oss-120b` | lief, Antworttext kam an |
| `gemma4:31b` | lief |
| `qwen/qwen3.8-27b` | lief |
| `aihorde/Deliberate` | ohne Text (0 Tokens) |
| `claude-sonnet-5-5` | **rot, 0 Tokens**: sieht nach Fehlschlag aus |
| `gemini-3.1-flash-image` | **rot, 0 Tokens**: sieht nach Fehlschlag aus |
| `aphrodite/TheDrummer/Cydonia` | rot, 0 Tokens |

Einordnung (aus einem Bild abgeleitet, nicht geprüft):
- **Echte Anbieter mit Gratisstufe** (meines Wissens, jeweils mit Mengengrenzen): Gemini AI Studio, Groq, OpenRouter (einzelne Modelle), Ollama Cloud, Cloudflare, NVIDIA.
- **Inoffizielle oder Community-Zugänge** (g4f.space, UncloseAI, The Old LLM, Felo, DuckDuckGo AI Chat, Chipotle Pepper, AI Horde): Das wirkt wie unzuverlässige Gratis-Wege. Qualität und Verfügbarkeit schwanken, und Texte gehen an Dritte. Für den **Schreiber nicht verwenden**, höchstens als Notreserve für unwichtige Aufgaben.
- **Anthropic und Claude:** Die letzte Claude-Anfrage ist fehlgeschlagen. Ob der Anthropic-Zugang in OmniRoute per Abo-Anmeldung oder per Schlüssel hängt, ist unbekannt (offene Frage).
- **Brauchbar für lange Texte laut Anzeige:** `gpt-oss-120b`, `qwen3.8-27b`, `gemma4:31b`. Ob die Qualität auf Deutsch für ein ganzes Buch reicht, zeigt nur ein **Testkapitel** im Vergleich.

**Nachtrag 10.11.2026, 22:47 (Foto der Anthropic-Seite in OmniRoute):** 16 von 22 Anthropic-Modellen sind aktiv, ein Test lief gerade. Sichtbar grün: `anthropic/claude-sonnet-5`, `claude-opus-5`, `claude-fable-5`, `claude-fable-5-2`, `claude-opus-4.5`, `claude-haiku-5-5`. Die ältere Fehlermeldung (`claude-sonnet-5-5`, vor 2 Tagen) ist damit wahrscheinlich ein einmaliger Ausfall oder eine Mengengrenze gewesen. **Nicht sichtbar:** ob diese Modelle gratis sind oder über Abo-Kontingent, Schlüssel oder Guthaben laufen. Die Seite hat dafür die Filter „Nur kostenlose" und „Nur kostenpflichtige". Das Ergebnis des Filters entscheidet, wie wir die Kosten in der Vorschau anzeigen.

### OmniRoute: Endpunkt (Screenshot 10.11.2026, 22:59)
- **Adresse:** `http://localhost:20128/v1`, OpenAI-kompatibel. Das passt zum alten Workflow (`http://host.docker.internal:20128` aus n8n im Docker). Der lokale Server läuft (intern `172.18.0.2:20128`, also in Docker).
- **Tunnel:** „Cloud OmniRoute" ist **aktiv**. Cloudflare Quick Tunnel gestoppt, Tailscale nicht installiert, Ngrok braucht eine Anmeldung.
- **Sicherheit:** Ein aktiver Cloud-Zugang macht den Router von außen erreichbar. Dahinter hängen deine Anbieter-Konten. Im **API-Manager** sollte ein Schlüssel für den Zugriff Pflicht sein, und die Cloud-Adresse nicht weitergeben. Das ist von hier nicht prüfbar.
- OmniRoute bietet außer APIs auch MCP und A2A (Agent-zu-Agent). Für den Plan nicht nötig, aber später für die KI-Kette denkbar.

**Zusätzlicher Zugang: „Free LLM API" (lokal auf dem Laptop).** Vom Auftraggeber genannt. Details sind noch unbekannt: Name des Programms, Adresse und Port, welche Modelle, ob OpenAI-kompatibel. Sobald das bekannt ist, wird sie wie OmniRoute als weiterer Zugang in der Einstellungsdatei eingetragen. Eine Ausweichkette ist denkbar: erst OmniRoute, bei Fehler Free LLM API.

Vorschlag zur Rollenverteilung (Modell je Rolle festnageln, vor dem Bau mit einem Testkapitel prüfen):
| Rolle | Vorschlag |
|---|---|
| Planer, Redaktion | `anthropic/claude-haiku-5-5`, `gemma4:31b` oder `qwen3.8-27b` (schnell, günstig) |
| Rechercheur | Perplexity oder Gemini mit Google-Suche |
| Analyst, Konzept | `anthropic/claude-sonnet-5` oder `gpt-oss-120b` |
| Schreiber | `anthropic/claude-sonnet-5` (für höchste Qualität `claude-opus-5`), per Testkapitel gegen ein zweites Modell bestätigen |
| Faktenprüfer | anderes Modell als der Schreiber (z. B. Gemini gegen gpt-oss) |
| Bild | `gemini-3.1-flash-image` (aktuell Fehler, prüfen) |

Daraus für den Plan:
- **Gratis genügt nicht für lange Bücher.** Kleine lokale Modelle und Gratis-Kontingente taugen für Vorschau, Planer und Redaktion. Für Schreiber, Analyst und Lektor braucht es ein starkes Modell. Das kostet Geld, auch wenn wenig. Der Plan bleibt: günstig wo möglich, stark wo nötig, und jede Stufe zeigt vorher die geschätzten Kosten.
- **Schritt zur Klärung:** den Stand der Anthropic-Rechnung prüfen und ein Bild der OmniRoute-Anbieterliste (ohne Schlüssel) ansehen, um zu wissen, was dahinter wirklich gratis läuft.

## 2g. Abschluss: `/los`, Prüfung, Freigabe
So läuft das Ende, wie vom Auftraggeber beschrieben:

1. **`/los`:** Der Workflow schreibt das **komplette Buch** ab dem letzten Speicherpunkt, ohne Zwischenfragen. Du bekommst nur kurze Meldungen (Kapitel x von y).
2. **Danach erst die Prüfung:** Eine zweite KI prüft Fakten und Lektorat, dann folgt die Endkontrolle für Buch, Cover und Format. Fehler werden behoben und neu geprüft (höchstens 3 Runden).
3. **Du bekommst die Freigabe-Nachricht** per Telegram: kurzer Prüfbericht, Cover, Auszug als PDF, Seitenzahl, Preis und Gewinnrechnung, offene Punkte. Du prüfst selbst.
4. **`/freigeben`:** Erst jetzt wird alles final auf dem Laptop gespeichert, samt KDP-Eintragsliste. Mit **`/aendern <Wunsch>`** gehst du gezielt zurück zum passenden Speicherpunkt, danach wird neu geprüft. Mit `/stopp` brichst du ab.
5. **Ohne `/freigeben` geht nichts raus.**

Vorschlag zur Tokenersparnis: Während des Schreibens läuft pro Kapitel nur ein **billiger Schnellcheck** (Länge, Aufbau, Quellenverweise). Die gründliche Faktenprüfung kommt einmal am Ende. Nachteil: Ein Fehler in einem frühen Kapitel kann spätere beeinflussen. Dafür ist der Schnellcheck da.

## 2h. Wahrheitsregel (Faktenmodus)
**Grundregel des Auftraggebers: In allen Büchern darf nur Wahres stehen. Erfunden werden darf nur dort, wo es Fantasy oder eine erfundene Geschichte ist.**

Jedes Buch bekommt in `book.yaml` ein Feld `faktenmodus`:

| Modus | Gilt für | Regel |
|---|---|---|
| **streng** | Sachbuch, Ratgeber, Anleitung, Dokumentation, **Geschichtsbuch** (wirkliche Geschichte), Prüfungsbuch, Atlas | Nur belegte Tatsachen. Nichts erfinden. |
| **frei** | Roman, Fantasy, erfundene Geschichten, Kinderbuchgeschichten | Erfinden ist erlaubt. Reale Fakten darin (Orte, Gesetze, Technik) bleiben trotzdem richtig. |
| **gemischt** | z. B. historischer Roman | Erfundene Handlung, aber echte historische Rahmendaten stimmen. Wird im Buch kenntlich gemacht. |

Wie der Workflow die Regel im Modus **streng** durchsetzt:
1. **Quellenpflicht:** Jede Tatsachenaussage im Text hat einen Eintrag im **Quellenregister** (`quellen.json`): Aussage, Quelle, Fundstelle, Datum des Abrufs. Ohne Eintrag darf die Aussage nicht ins Buch.
2. **Keine erfundenen Belege:** Keine erfundenen Zitate, Studien, Zahlen, Personen, Rezensionen oder Fußnoten. Der Prüfer ruft die Quelle wirklich ab (Code) und vergleicht die Stelle mit der Aussage. Wird die Quelle nicht gefunden oder sagt etwas anderes, fliegt die Aussage raus oder wird umformuliert.
3. **Zweite KI prüft:** Der Faktenprüfer ist ein **anderes Modell** als der Schreiber.
4. **Unsicher heißt sagen, nicht raten:** Ist etwas umstritten oder unklar, steht das so im Text („laut …", „nach heutigem Stand …"), oder es wird gestrichen.
5. **Stand und Datum:** Bei Gesetzen, Preisen und Regeln steht der Rechtsstand mit Datum im Buch.
6. **Bilder:** Ein Bild darf nur zeigen, was stimmt (siehe Bildregeln). Keine KI-Bilder von echten Ereignissen oder Personen als „Foto".
7. **Du als letzte Instanz:** In der Freigabe 2 bekommst du eine Liste der **unsicheren oder schwach belegten Aussagen** zur Entscheidung.

Ehrlich dazu: Keine KI kann hundert Prozent Wahrheit garantieren. Die Regeln oben senken das Risiko stark, aber bei Rechts-, Gesundheits- und Sicherheitsthemen bleibt eine Prüfung durch einen Menschen vom Fach ratsam.

## 2i. Speicherort auf dem Laptop
Alles Erzeugte wird im bestehenden Arbeitsordner des Auftraggebers gespeichert (aus dem alten Workflow übernommen):

| Wo | Pfad |
|---|---|
| Windows (Laptop) | `Desktop\Die Firma\Buch Ergebnisse` |
| In Docker/n8n | `/data/firma/Buch Ergebnisse` (n8n-Dateiordner: `/home/node/.n8n-files`) |

Aufbau darin, ein Unterordner pro Buch:
```
Buch Ergebnisse/<slug>/
  state.json            Speicherpunkte (siehe 2b)
  research/ concept/ manuscript/ design/ print/ marketing/
  quellen.json          Quellenregister (siehe 2h)
  bilder.json           Bilder mit Quelle und Lizenz
  ausgabe/              fertige Dateien nach /freigeben, dazu kdp-eintragen.md
```

Dieses GitHub-Repo ist öffentlich. Deshalb liegen **dort nur Pläne, Workflow-Dateien und `book.yaml`**, keine fertigen Bücher, Bilder oder Schlüssel. Die Bücher bleiben auf dem Laptop (und werden dort gesichert).

## 2j. Fachprüfung durch KI am Schluss
Entscheidung des Auftraggebers: Die Fachprüfung am Ende übernimmt eine KI, nicht ein menschlicher Experte. Danach prüft der Auftraggeber selbst (Freigabe 2).

Damit das möglichst verlässlich wird:
- **Zwei verschiedene Modelle** prüfen unabhängig voneinander (nicht das Modell, das geschrieben hat). Weichen sie voneinander ab, wird die Stelle markiert.
- **Prüfen gegen die Quellen** aus dem Quellenregister (siehe 2h), nicht aus dem Gedächtnis des Modells.
- **Kritische Aussagen** (Recht, Gesundheit, Sicherheit, Maße bei Bauplänen) bekommen eine eigene Liste. Du entscheidest dort einzeln.
- **Haftungshinweis** im Buch bei Themen mit Risiko (zum Beispiel Selbstverteidigung, Recht, Handwerk).
- Ehrlich: Eine KI-Prüfung findet viele, aber nicht alle Fehler. Gleiche Fehler können beide Modelle machen. Deshalb legt der Workflow dir die unsicheren Stellen offen vor.

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
Erst **nach deiner Freigabe 2** (`/freigeben`) wird alles in einem Ordner auf dem Laptop gespeichert (`books/<slug>/ausgabe/`):

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
3. ✅ Fachprüfung (entschieden 10.11.2026): macht am Schluss eine **KI**, danach prüft der Auftraggeber selbst in der Freigabe 2. Absicherung bei Recht, Gesundheit und Sicherheit: zwei verschiedene Modelle prüfen, kritische Aussagen werden dir einzeln vorgelegt, Haftungshinweis steht im Buch.
4. ❓ Stilvorlage: ein Textbeispiel, das der Auftraggeber „menschlich" findet.
5. ❓ Ablauf der Freigaben im Telegram-Chat (Knöpfe oder Text)?
