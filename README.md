# PROJECT BLACK SKY

Original mobile RTS — Flutter + Flame client, Firebase for auth/profile/social
data, Nakama for authoritative realtime multiplayer. Built and iterated from
an Android phone via Termux; CI/signing/release builds run on Codemagic.

## Honest status (read this first)

This repo is a **working architectural skeleton + one playable vertical
slice**, not the full 400-unit / 20-map / 150-level game described in the
original brief. That full scope is a multi-year, multi-person production. What
exists right now and actually runs end-to-end:

- Clean Architecture (domain / data / presentation / game) wired with GetIt
- Firebase Auth (anonymous + email) and a Firestore player profile
- A Flame RTS scene: pinch-zoom/pan camera, box-select, tap-to-move, two
  factions (USA, RUSSIA) with 8 units each, two maps
- A Nakama client integration point (`NakamaDataSource` /
  `MatchRepositoryImpl`) — **the server-side authoritative match handler
  (Go/TS Nakama runtime module) is a separate project and is not included
  here.** Until that exists, matches run as local-only simulation.

## Known gaps / next milestones, in order

1. **Nakama server module** — write the actual authoritative match loop
   (Go or TypeScript, runs inside Nakama, not Flutter) that resolves combat,
   validates orders, and broadcasts state. Nothing here can matter online
   without it.
2. **Combat resolution system** — `UnitInstance.applyDamage` exists but
   nothing currently calls it; no targeting/attack logic yet.
3. **Persistence for Battle Group decks** — `BattleGroupScreen` builds a
   deck in memory only; needs a Firestore/Hive schema.
4. **Real sprites** — units/maps render as colored placeholders
   (`UnitComponent`, `MapComponent`) by design, swap for `SpriteAnimationComponent`
   / `TiledComponent` once art exists.
5. Everything else in the original brief (campaign missions, clans, battle
   pass, 150-level progression, admin panel, etc.) — none of it is started.

## Requirements

- Flutter 3.35+, Dart 3.4+
- A Firebase project (Auth + Firestore enabled), `google-services.json`
  placed at `android/app/google-services.json` (never commit this file)
- A running Nakama server you control the address of — **Termux cannot host
  Nakama itself** (it needs Docker or a real Linux host); run it on a VPS,
  a home server, or `docker run` on a desktop machine, and point `.env` at it

## Setup (Termux)

```bash
cp .env.example .env        # fill in NAKAMA_* values
# put your Firebase android/app/google-services.json in place manually
flutter pub get
flutter run                 # or: flutter build apk --debug
```

## CI / release builds

`codemagic.yaml` builds signed APK + AAB. Configure these in Codemagic's
environment variable groups (`black_sky_secrets`), never in the repo:
`NAKAMA_HOST`, `NAKAMA_PORT`, `NAKAMA_SERVER_KEY`, `NAKAMA_USE_SSL`,
`FIREBASE_GOOGLE_SERVICES_JSON_BASE64`, `CM_KEYSTORE` (base64), `CM_KEYSTORE_PASSWORD`,
`CM_KEY_ALIAS`, `CM_KEY_PASSWORD`.
