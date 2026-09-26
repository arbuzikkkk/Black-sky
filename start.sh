#!/data/data/com.termux/files/usr/bin/bash
# Standard entrypoint for `~/get_latest.sh` — matches the pattern used across
# all other projects (aiogram bots etc.), adapted for a Flutter app instead
# of a Python server: there is no long-running process to hand off to a
# watchdog, so this just gets deps and launches `flutter run` in foreground.
set -e

echo "[black_sky] flutter pub get..."
flutter pub get

if [ ! -f ".env" ]; then
  echo "[black_sky] no .env found — copying .env.example (fill in real NAKAMA_*/Firebase values before a real match)"
  cp .env.example .env
fi

echo "[black_sky] launching..."
flutter run
