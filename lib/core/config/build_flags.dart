/// Single switch for the "no Firebase configured yet" build variant.
///
/// Set to `false` while there's no real Firebase project / google-services.json
/// wired into CI — this skips Firebase.initializeApp() and routes straight
/// into an offline guest session instead of the login flow, so the APK still
/// builds and runs. Flip to `true` once Firebase is actually configured (see
/// README.md "Enabling Firebase" section) — no other code changes needed,
/// the auth/profile flow already exists behind this flag.
const bool kFirebaseEnabled = false;
