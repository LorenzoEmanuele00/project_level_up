# LevelUp — Design spec per Claude Code

App mobile **Flutter** di habit tracking gamificato (RPG). Questo file spiega **dove** trovare le informazioni di design, **come** tradurle in codice e **quali processi/flussi** implementare.

---

## 0. Fonti di verità (leggi in quest'ordine)

| File | Cosa contiene | Come usarlo |
|---|---|---|
| `design.md` (questo) | Mappa, regole, flussi, convenzioni | Leggi sempre per primo. È la specifica di riferimento |
| `LevelUp Design System.dc.html` | Design system: token, componenti con varianti/stati, viste, navigazione, modello dati, regole, motion | Documento di progettazione. Consultalo per i valori visivi (colori, misure, raggi, curve) leggendo i testi e le tabelle delle sezioni (vedi §1) |
| `LevelUp - Design-system.html` | Prototipo interattivo | Solo riferimento visivo da aprire nel browser |

**Questi file sono progettazione, non codice da riusare.** Non leggere, copiare o portare nessuno script, logica o markup dai file HTML. Tutto il necessario per implementare è descritto in questo documento e nelle specifiche testuali del Design System. Ogni altro file nella cartella va ignorato.

---

## 1. Come navigare il Design System

Ogni sezione e componente del Design System ha un anchor (`#id`). Apri il documento nel browser e vai all'anchor, oppure cerca il titolo della sezione. Leggi titoli, tabelle e note: non serve (e non va) interpretare il markup.

**Sezioni**
- `#intro` principi · `#domini` indice per dominio
- `#t-colori` token semantici chiaro/scuro
- `#t-accenti` 5 palette accento + derivati
- `#t-hue` hue habit, stat pastel, tier medaglie, rarità reward
- `#t-tipo` scala tipografica
- `#t-spazi` spacing, raggi, ombre + schema Dart di riferimento
- `#t-icone` chiavi icone (set Streamline line)
- `#atomi` · `#molecole` · `#organismi`
- `#viste` inventario viste · `#navigazione` mappa transizioni
- `#dati` modello dati + schema Dart di riferimento
- `#regole` regole di gioco + simulatore
- `#motion` curve e animazioni

**Componenti (anchor → widget Flutter)**

| Anchor | Livello | Widget |
|---|---|---|
| `#c-button` | atomo | `LuButton(variant, size)` |
| `#c-iconbtn` | atomo | `LuIconButton` |
| `#c-check` | atomo | `LuCheck` (HabitCheck / SelectCheck) |
| `#c-toggle` | atomo | `LuToggle` |
| `#c-segmented` | atomo | `LuSegmented<T>` |
| `#c-chip` | atomo | `LuChoiceChip` |
| `#c-field` | atomo | `LuTextField` |
| `#c-progress` | atomo | `LuProgressBar` |
| `#c-ring` | atomo | `LuProgressRing(size)` |
| `#c-avatar` | atomo | `LuAvatar(mode, expRing)` |
| `#c-pill` | atomo | `LuPoints` (pill / badge) |
| `#c-icontile` | atomo | `LuIconTile(size, hue)` |
| `#c-medal` | atomo | `LuMedal(tier, state)` |
| `#c-steps` | atomo | `LuStepper`, `LuDots`, divider, sheet handle |
| `#c-swatch` | atomo | `LuSwatch`, `LuIconCell` |
| `#c-habittile` | molecola | `LuHabitTile(habit, onComplete, onOpen)` |
| `#c-stat` | molecola | `LuStat(kind, tone)` |
| `#c-sectionhead` | molecola | `LuSectionHeader` |
| `#c-empty` | molecola | `LuEmptyState` |
| `#c-reward` | molecola | `LuRewardCard`, `LuRedeemedRow` |
| `#c-medalrow` | molecola | `LuMedalRow(track)` |
| `#c-consistency` | molecola | `LuConsistencyRow` |
| `#c-settings` | molecola | `LuSettingsRow(trailing)` |
| `#c-select` | molecola | `LuClassCard`, `LuDifficultyOption`, `LuTierOption`, `LuStarterHabitCard` |
| `#c-note` | molecola | `LuNote(tone)` |
| `#c-toast` | molecola | `LuToast` |
| `#c-hero` | organismo | `LuHeroBlock` |
| `#c-medalstrip` | organismo | `LuMedalStrip` |
| `#c-chart` | organismo | `LuWeekChart` |
| `#c-sheethead` | organismo | `LuSheetHeader`, `LuFormHeader` |
| `#c-sheet` | organismo | bottom sheet / `HabitDetailSheet` |
| `#c-overlay` | organismo | `LuExpOverlay`, `LuLevelUpOverlay`, `LuRewardOverlay` |
| `#c-onboarding` | organismo | `LuOnboardingPager` |
| `#c-register` | organismo | `LuStepScaffold` |

Ogni card ha un footer con la **specifica** (misure, stati, regole): è la parte da leggere per implementare.

**Leggere i valori:** usa i nomi dei token delle tabelle (`surface`, `elev`, `text2`…), mai valori esadecimali sparsi. In Dart: `context.colors.surface`.

---

## 2. Architettura Flutter consigliata

```
lib/
  main.dart
  app/router.dart                 # go_router
  theme/
    tokens.dart                   # Spacing, Radius, Shadows, Motion
    colors.dart                   # ThemeExtension<AppColors> light/dark(accent)
    text.dart                       # AppText (Space Mono)
    icons.dart                 # chiave → asset SVG
  domain/
    models.dart                   # Hero, Habit, Reward, Redemption, Completion, enum
    game_rules.dart               # funzioni pure (vedi §4)
    medals.dart                   # MedalTrack + soglie
  data/                           # repository (locale + sync cloud)
  state/                          # controller (Riverpod / Bloc)
  ui/
    atoms/ molecules/ organisms/  # widget (senza prefisso Lu)
    screens/                      # una cartella per vista (§5)
    overlays/                     # feedback overlay + toast
assets/
  fonts/SpaceMono-*.ttf
  icons/*.svg                     # set Streamline (line), scaricati dalla libreria ufficiale
```

**Regole**
- I widget usano solo token (`context.colors.*`, `AppText.*`, `Spacing.*`), mai hex.
- I colori **non** si salvano nel modello: si salvano chiavi (`hue`, `icon`, `tier`, `accent`) risolte dal tema.
- `game_rules.dart` è logica pura e testabile, senza UI.
- I widget sono stateless dove possibile: lo stato sta nei controller.
- Font: Space Mono 400/700 (+ italic 400). Nessun altro font.

---

## 3. Theming

- Due temi (`light` default, `dark`) con la stessa struttura. Vedi tabella `#t-colori`.
- **Accento** scelto dall'utente tra 5 palette: Terra `#d9614c`, Ambra `#cf9c4d`, Salvia `#5b9c6f`, Ardesia `#5988c0`, Rosa `#c56b7a`.
- Derivati calcolati a runtime:
  - `accentDeep = shade(accent, .28)` (scurisce del 28%)
  - `accent2 = shade(accent, -.12)` (schiarisce)
  - `accentSoft = accent @ α .09 (light) / .15 (dark)`
  - `accentLine = accent @ α .32`
  - `obGlow = accent @ α .12 (light) / .22 (dark)`
- Hue habit: `red` usa sempre l'accento; `blue/teal/green/gold` sono fissi (tabella `#t-hue`).
- Stat pastel, tier medaglie e overlay **non** cambiano con il tema.

---

## 4. Regole di gioco (implementare in `game_rules.dart`)

Costanti configurabili: `expPerLevel = 100`, `rpPerLevel = 5` (range 3–10).

| Regola | Valore |
|---|---|
| EXP per completamento | facile 10 · media 20 · difficile 40 (fissa) |
| Completamento | max 1 al giorno per habit |
| Level up | `while (exp >= expPerLevel) { exp -= expPerLevel; level++; rp += rpPerLevel; }` |
| Costo reward | piccola 10 · media 25 · grande 60 RP |
| Livelli per reward | `ceil(cost / rpPerLevel)` (mostrato nel form reward) |
| Riscatto | se `rp >= cost`: `rp -= cost`, crea `Redemption` e rimuovi la reward dalla lista disponibili; altrimenti toast con `cost - rp` |
| Streak | +1 a ogni completamento. **Da definire:** azzeramento quando salti un giorno dovuto (job giornaliero) |
| Missione giornaliera | `questPct = doneToday / dueToday`; completata = tutte le dovute fatte |
| Medaglie | 4 tracce × 3 tier (tabella `#regole`): streak 10/50/100, completamenti 25/100/250, livello 5/15/30, riscatti 1/5/12 |

**Pseudocodice completamento**
```dart
CompletionResult complete(Hero hero, Habit h, DateTime now) {
  if (h.isDoneOn(now)) return CompletionResult.noop();
  final habit = h.copyWith(streak: h.streak + 1, totalCompletions: h.totalCompletions + 1, lastCompletedAt: now);
  var exp = hero.exp + h.exp, level = hero.level, rp = hero.rewardPoints, gained = 0;
  while (exp >= expPerLevel) { exp -= expPerLevel; level++; rp += rpPerLevel; gained += rpPerLevel; }
  final overlay = gained > 0 ? Overlay.levelUp(rp: gained) : Overlay.exp(exp: h.exp, name: h.name);
  return CompletionResult(hero.copyWith(exp: exp, level: level, rewardPoints: rp), habit, overlay, Completion(h.id, now, h.exp));
}
```

---

## 5. Viste (15)

Dettaglio completo in `#viste`. Riepilogo:

| # | Vista | Tipo | Route | Widget |
|---|---|---|---|---|
| 01 | Registrazione (5 passi) | flusso | `/register` | `RegisterFlow` |
| 02 | Onboarding "Come funziona" (4 card) | overlay | — | `OnboardingOverlay` |
| 03 | Home · Oggi | root | `/` | `HomeScreen` |
| 04 | Tutte le Habits | sheet full | `/habits` | `AllHabitsSheet` |
| 05 | Dettaglio habit | bottom sheet | modal | `HabitDetailSheet` |
| 06 | Form habit | modale | `/habits/new`, `/habits/:id/edit` | `HabitFormScreen` |
| 07 | Profilo | sheet full | `/profile` | `ProfileSheet` |
| 08 | Impostazioni | bottom sheet | modal | `SettingsSheet` |
| 09 | Reward Shop (Disponibili / Sbloccate) | sheet full | `/rewards` | `RewardShopSheet` |
| 10 | Form reward | modale | `/rewards/new` | `RewardFormScreen` |
| 11 | Missione di oggi (statistiche) | sheet full | `/mission` | `MissionStatsSheet` |
| 12 | Overlay EXP | overlay | — | `ExpGainOverlay` |
| 13 | Overlay Level Up | overlay | — | `LevelUpOverlay` |
| 14 | Reward sbloccata | overlay | — | `RewardUnlockedOverlay` |
| 15 | Punti insufficienti | toast | — | `InsufficientToast` |

**Nessuna tab bar.** La Home è l'unico hub: Avatar → Profilo, pill punti → Reward Shop, area statistiche → Missione, "Vedi tutte" → Tutte le habits.

**Presentazioni**
- *sheet full*: route a schermo intero con transizione dal basso (`rise`, 380ms), fondo `canvas`, header `LuSheetHeader` con chevron giù.
- *bottom sheet*: `showModalBottomSheet`, scrim α.55, raggio 26 in alto, handle 40×5.
- *modale*: route full screen, fondo `bg`, `LuFormHeader` (Annulla · titolo · Salva).
- *overlay*: `OverlayEntry` sopra tutto, sempre scuro, uno alla volta.

---

## 6. Flussi

### F1 · Primo avvio → registrazione → onboarding
```
Avvio ──(nessun Hero salvato)──▶ /register
  Passo 1 Nome           (facoltativo, fallback "Eroe")
  Passo 2 Aspetto        Iniziale | Icona + colore personaggio (5 palette)
  Passo 3 Classe         facoltativa; selezionarla preseleziona le habit della classe
                         e imposta l'accento se l'utente non l'ha scelto a mano
  Passo 4 Prime habit    multi-selezione dal catalogo (8)
  Passo 5 Account        Apple / Google / email+password · "Salta per ora"
  ──▶ crea Hero(level 1, exp 0, rp 0), habit selezionate (se nessuna: le prime 3 del catalogo)
  ──▶ OnboardingOverlay (4 card: Completa → EXP → Reward points → Premi)
  ──▶ Home
```
- Back visibile dal passo 2. Segmenti progressivi in accento.
- CTA: "Avanti" (1–3), "Quasi fatto" (4), "Crea account ed entra" (5).

### F2 · Completare una habit (ciclo principale)
```
Home › HabitTile › tap check     (oppure Dettaglio › "Completa ora")
  ├─ già fatta oggi → noop (check pieno, CTA "Già completata oggi" disabilitata)
  └─ game_rules.complete()
       ├─ nessun level up → ExpGainOverlay(+EXP, barra livello) → Continua → Home
       └─ level up        → LevelUpOverlay(confetti, +RP)
                              ├─ "Vai al Reward Shop" → /rewards
                              └─ "Continua più tardi" → Home
```
Aggiornamenti UI: tile in stato *done* (opacità .72), HeroBlock (FATTE, EXP, barra missione), avatar ring EXP, pill RP. Se tutte le dovute sono fatte, la griglia è sostituita da `LuEmptyState` "Tutto fatto per oggi".

### F3 · Gestire habit
```
Tutte le habits › (+)        → Form habit (nuova): icona, nome, difficoltà, frequenza → Salva
Dettaglio › Modifica         → Form habit (precompilato) → Salva
Dettaglio › Archivia         → archived = true → chiude il sheet
```
- Nome vuoto → "Nuova habit". Default: difficoltà media, ogni giorno, icona `target`, hue `teal`.
- L'EXP **non** è modificabile: deriva dalla difficoltà (`LuNote` informativo nel form).

### F4 · Reward
```
Reward Shop › (+) | EmptyState "Crea reward" → Form reward: nome, nota, rarità → Salva → Reward Shop
Reward Shop › RewardCard › Sblocca
  ├─ rp >= cost → RewardUnlockedOverlay → "Fantastico" → tab Sbloccate aggiornata
  └─ rp <  cost → InsufficientToast ("Ti mancano N punti")
```
- Lista disponibili ordinata per costo crescente.
- Lo stato della card (sbloccabile / bloccata) si ricalcola da `hero.rewardPoints`.

### F5 · Profilo e impostazioni
```
Home › Avatar → Profilo: ring livello, EXP, 4 StatCard, accento (5 swatch), medaglie per traccia, toggle tema
Profilo › ingranaggio → Impostazioni: tema scuro, sync cloud (stato), notifiche (orari)
```
Cambiare accento o tema aggiorna subito l'intero `ThemeData`.

### F6 · Missione / statistiche
```
Home › area statistiche HeroBlock → Missione di oggi
  ring % · 4 MetricCard (EXP oggi, streak max, completate 7gg, tasso settimanale)
  2 WeeklyBarChart (completate, EXP) · ConsistencyRow per habit dovuta
```
I grafici leggono lo storico `Completion` (Lun→Dom; oggi evidenziato, giorni futuri vuoti).

---

## 7. Motion

Token in `#motion` → `Motion`:
- `spring` `cubic(.34,1.56,.5,1)` 180–200ms: feedback pressione (scale .965 grandi / .88 piccoli)
- `out` `cubic(.2,.8,.2,1)` 300–500ms: sheet, barre, ring
- `pop` `cubic(.2,.9,.3,1.2–1.3)` 450–600ms: overlay, level up
- `apple` `cubic(.32,.72,0,1)` 500–550ms: ingresso schermate, stagger liste (+50ms per elemento)

Animazioni nominate: `popIn`, `pop2`, `rise`, `floatUp`, `itemIn`, `blockUp`, `ringGlow`, `floaty`, `wiggle`, `confetti` (22 pezzi, 0.75–1.25s). Rispetta `MediaQuery.disableAnimations` (sostituisci con fade 150ms). Aptica: light su EXP, heavy su level up, success su reward.

---

## 8. Checklist di implementazione

1. Token e tema (`colors`, `text`, `tokens`), font, icone SVG
2. Modelli e `game_rules` con unit test (EXP, multi level up, riscatto, medaglie)
3. Atomi → molecole → organismi (verifica ogni widget con gli stati della card nel DS)
4. Router e viste nell'ordine: Home → Dettaglio/Form habit → Overlay → Reward Shop/Form → Profilo/Impostazioni → Missione → Registrazione/Onboarding
5. Persistenza locale, poi sync cloud e notifiche

## 9. Punti aperti (da confermare con design)
- Regola di azzeramento streak e calendario delle frequenze settimanali (`isDueOn`)
- Modifica reward (prevista nel modello, nessun accesso UI nel prototipo)
- Login reale (Apple/Google/email) e contenuto di "Sync cloud"
- Orari notifiche configurabili (nel prototipo sono fissi: 08:00, 20:00)
