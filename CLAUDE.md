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
flutter gen-l10n      # rigenera lib/l10n dopo aver modificato gli ARB
dart run build_runner build --delete-conflicting-outputs   # rigenera i *.g.dart di drift dopo aver toccato le tabelle
dart run drift_dev schema dump lib/data/database/app_database.dart drift_schemas/   # dopo ogni cambio di schema (con bump di schemaVersion)
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/        # helper per i test di migrazione
dart format --set-exit-if-changed .   # formatter: deve restare pulito
```

(`build_runner` 2.16 ignora `--delete-conflicting-outputs` con un avviso: è il comportamento di default, il flag resta per compatibilità con le versioni precedenti.)

**File generati committati**: `lib/l10n/*` e i `*.g.dart` di drift (`lib/data/database/app_database.g.dart`) stanno in git, così un clone compila senza rigenerare. Dopo aver modificato tabelle o ARB si rigenera e si committa il risultato insieme alla modifica. Anche `drift_schemas/` (uno JSON per versione di schema) e `test/generated_migrations/` sono committati: lo schema esportato non si modifica mai a mano, una versione già rilasciata non si riscrive (si aggiunge `schemaVersion + 1`, il dump e uno step di migrazione con test).

Nessun comando di build/release è ancora definito (si aggiungerà quando serve).

## Struttura `lib/`

Vedi `docs/design/design.md` §2 per l'albero completo (`app/`, `theme/`, `domain/`, `data/`, `state/`, `ui/atoms|molecules|organisms|screens|overlays`). Regole chiave:
- I widget usano solo token di tema (`context.colors.*`, `AppText.*`, `Spacing.*`), mai colori hex.
- Niente prefisso `Lu`/`lu_` in classi e file (decisione di review PR #2): l'app è `LevelUpApp`, i file in `lib/theme/` sono `colors.dart`, `text.dart`, …; se un nome collide con Flutter si usa uno più specifico (`AppColors`, `AppText`). Gli enum di dominio stanno tutti in `lib/domain/enums.dart`.
- Il modello dati salva chiavi (`hue`, `icon`, `tier`, `accent`), non colori risolti.
- `domain/game_rules.dart` è logica pura, senza UI, testabile in isolamento. Il dominio non importa drift: la persistenza sta in `lib/data/` (tabelle drift, mapper, `GameRepository` con implementazioni drift e in memoria); i test del repository condividono una suite di contratto (`test/unit/data/game_repository_contract.dart`) che deve passare su entrambe.
- Nessuna stringa letterale visibile all'utente nei widget: testi in `lib/l10n/app_it.arb` (sorgente) e `app_en.arb`, letti con `context.l10n.*`; si aggiunge una chiave solo quando una schermata la usa (mai a priori); etichette degli enum come estensioni con switch esaustivo in `lib/ui/l10n/`, mai nel dominio, aggiunte insieme alla schermata che le usa, con test di completezza it+en; date/numeri via `intl` con locale esplicito. Il test `no_literal_strings_in_ui_test` lo verifica.

## TDD e qualità

- Ciclo RED → GREEN → REFACTOR per ogni nuova funzionalità o bug fix.
- Copertura minima 80%.
- I test sull'ora legale (DST) hanno bisogno di un fuso con cambio d'ora: girano con `TZ=Europe/Rome flutter test` (meglio per `test/unit/domain`, `test/unit/data`). In un fuso senza ora legale (es. UTC) vengono **saltati** con un messaggio esplicito (`skip: needs a zone with daylight saving`), non passano in silenzio. Prima di una PR lanciare entrambe le varianti.
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
