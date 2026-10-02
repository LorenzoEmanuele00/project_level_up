# CLAUDE.md — project_level_up

Costituzione del repo: regole che Claude Code e chiunque contribuisca devono rispettare. Per i dettagli e lo stato attuale, i link alle fonti canoniche sono in fondo a ogni sezione — questo file resta corto.

## Cos'è

**LevelUp**: app mobile Flutter (iOS + Android) di habit tracking gamificato in stile RPG (EXP, livelli, reward points, reward create dall'utente, medaglie).

**Specifica di riferimento**: `docs/design/design.md`. Leggerlo prima di implementare qualunque vista o regola di gioco — definisce architettura `lib/`, token di tema, regole di gioco, le 15 viste e i flussi. Gli altri file in `docs/design/` (gli `.html`) sono solo riferimento visivo di progettazione: non copiare markup, script o logica da lì.

## Stack

Flutter, piattaforme solo iOS e Android. `go_router` · Riverpod (stato) · drift/SQLite (persistenza locale) · Supabase (auth Apple/Google/email + sync cloud) · `flutter_local_notifications` + `timezone` (promemoria locali). Font Space Mono, icone SVG Streamline (line).

ID app `com.lorenzoemanuele.levelup` (pacchetto Dart `levelup`) — immutabile dopo la pubblicazione.

Dettagli e stato delle dipendenze: nota `Stack Tecnologico` nel vault (link sotto).

## Comandi

```sh
flutter pub get       # dipendenze
flutter analyze       # lint statico — deve restare verde
flutter test          # test — deve restare verde
```

Nessun comando di build/release è ancora definito (si aggiungerà quando serve).

## Struttura `lib/`

Vedi `docs/design/design.md` §2 per l'albero completo (`app/`, `theme/`, `domain/`, `data/`, `state/`, `ui/atoms|molecules|organisms|screens|overlays`). Regole chiave:
- Widget `Lu*` usano solo token di tema (`context.lu.*`, `LuText.*`, `LuSpace.*`), mai colori hex.
- Il modello dati salva chiavi (`hue`, `icon`, `tier`, `accent`), non colori risolti.
- `domain/game_rules.dart` è logica pura, senza UI, testabile in isolamento.

## TDD e qualità

- Ciclo RED → GREEN → REFACTOR per ogni nuova funzionalità o bug fix.
- Copertura minima 80%.
- `game_rules.dart` in particolare va coperto con unit test su EXP, multi level up, riscatto reward, medaglie (vedi design.md §4 e §8).
- `flutter analyze` e `flutter test` verdi prima di proporre un merge in `develop`.

## Workflow Git

| Branch | Ruolo |
|---|---|
| `main` | Stabile. Riceve `develop` solo a fine macro funzionalità. |
| `develop` | Integrazione. Ogni sviluppo parte da qui e torna qui. |
| `<tipo>/PLU-n-descrizione` | Un branch per card, da `develop` a `develop` (es. `feat/PLU-9-game-rules`). |

Mai commit diretti su `main` o `develop`. Commit in conventional format (`feat:`, `fix:`, `chore:`…). "Master" detto a voce indica `main`.

**A fine di uno sviluppo** (card completata, `flutter analyze`/`flutter test` verdi): commit, push del branch della card e apertura di una PR verso `develop`, senza bisogno di una richiesta esplicita per questi tre passi (regola generale per tutti i progetti, in `~/.claude/CLAUDE.md`). PR con **Lorenzo (`LorenzoEmanuele00`)** come reviewer.

Dettagli e gotcha (es. Flutter via cask chezmoi, non `flutter upgrade`): nota `Setup Ambiente di Sviluppo` nel vault.

## Cosa richiede conferma di Lorenzo

- Merge della PR in `develop`: sempre a cura o su richiesta esplicita di Lorenzo, mai automatico.
- Merge di `develop` in `main`: manuale, solo a fine macro funzionalità, su richiesta esplicita.
- Qualunque scelta di prodotto non ancora decisa (vedi design.md §9 e la nota "Domande Aperte" nel vault) va chiesta prima di implementare, non assunta.
- Cancellazioni irreversibili (`rm -rf`, reset distruttivi) fuori dal repo: le lancia Lorenzo.

## Documentazione — fonti canoniche

Questo file è la costituzione (regole). Per il resto, il vault Obsidian è la documentazione di progetto completa (mai duplicarla qui):

- **Indice del progetto**: nota `project_level_up - Indice` nel vault — punto di partenza, link a tutte le altre.
- **Board / Backlog**: `project_level_up - Board` e `project_level_up - Backlog` — cosa si sta facendo ora, cosa c'è dopo.
- **Stack e Setup Ambiente**: `project_level_up - Stack Tecnologico`, `project_level_up - Setup Ambiente di Sviluppo`.
- **Decisioni aperte e incoerenze**: `project_level_up - Domande Aperte e Disallineamenti`.

Se questo file e il vault non coincidono con il codice, **vince il codice**: correggere entrambi e segnalare la differenza nella nota "Domande Aperte".
