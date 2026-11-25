# Testkapitel: so bewertest du die Modelle

Baustein `workflows/00-modelltest.json` lässt mehrere Modelle über OmniRoute **dasselbe Kapitel** schreiben: „Notwehr: Was ich darf und was nicht" für das Buch „Selbstverteidigung für Frauen" (+18), 600 bis 800 Wörter. Alle Texte landen in einer Datei `modelltest__<Datum>.json` im Ordner `Buch Ergebnisse`. Der Chat zeigt dazu eine automatische Vorprüfung.

## Starten
1. Workflow importieren, Credential `OmniRoute (Authorization)` wie bei Baustein 01 auswählen (siehe `workflows/README.md`).
2. Chat öffnen und `test` eingeben. Eigene Modelle: `test modelle:anthropic/claude-sonnet-5,openai/gpt-oss-120b`. Die Namen müssen genau so heißen wie in OmniRoute (`http://localhost:20128/v1/models`).
3. Die Datei öffnen und die Texte lesen.

## Was die automatische Vorprüfung zeigt
Wörter (soll 500 bis 950 sein), ob § 32 und § 33 vorkommen, ob ein Haftungshinweis dabei ist, ob **verdächtige Quellen oder Urteile** auftauchen (Aktenzeichen, „BGH, Urteil vom …"), und typische KI-Floskeln. Das ersetzt dein Lesen nicht.

## Dein Bewertungsbogen (je Modell)
| Frage | Ja / Nein oder 1-5 |
|---|---|
| Klingt es **menschlich**, wie von einem erfahrenen Autor? (1 = Roboter, 5 = sehr gut) | |
| Ist es **verständlich** für Laien? | |
| **Stimmt der Inhalt?** (Merkpunkte unten) | |
| Sind **keine Urteile oder Zahlen erfunden**? | |
| Passt die **Länge**? | |
| Ist ein **Haftungshinweis** am Ende? | |
| Gab es **Fehler oder Ausfälle** beim Abruf? | |

## Merkpunkte zum Prüfen (Gesetzestext nachsehen auf gesetze-im-internet.de)
- **§ 32 StGB:** Wer eine Tat begeht, die durch Notwehr geboten ist, handelt nicht rechtswidrig. Notwehr ist die Verteidigung, die erforderlich ist, um einen **gegenwärtigen rechtswidrigen Angriff** von sich oder einem anderen abzuwenden.
- **§ 33 StGB:** Überschreitet der Täter die Grenzen der Notwehr aus **Verwirrung, Furcht oder Schrecken**, wird er nicht bestraft.
- Ein Modell darf **keine Gerichtsurteile oder Aktenzeichen** nennen. Der Auftrag verbietet es. Taucht eines auf, ist das ein Warnzeichen für Erfindungen.

## Ergebnis
Zeig mir die Bewertung (oder schick die Datei und deine Noten). Daraus lege ich fest: **Schreiber**, **Faktenprüfer** (anderes Modell) und **Planer/Redaktion** (günstig). Das trage ich in `config/modelle.yaml` ein. Die Modelle werden dort mit einer Begründung belegt, nicht geraten.
