# Push matrix — Android + Web

Run every row of the core scenario table **one by one** from the example app.
Server-scripted cases (retry, concurrency, provider, queue, …) do not need a
notification tray. Real-FCM cases (`basic.success`, `payload.*`, `app.*`) do.

Do **not** commit provider credentials. Keep these files local (they are
gitignored):

- `push_server/config/passwords.yaml`
- `push_server/config/firebase_service_account_key.json`
- `push_server/config/onesignal.json` (`appId` + `restApiKey`)
- `push_server/config/sns.json` (`accessKeyId` + `secretAccessKey`)
- `push_flutter/android/app/google-services.json`
- `push_flutter/ios/Runner/GoogleService-Info.plist`

## 1. Start the server (your terminal — keep it running)

```bash
cd examples/push/push_server
dart run bin/main.dart --apply-migrations
```

## 2. Android

```bash
adb reverse tcp:8080 tcp:8080
cd examples/push/push_flutter
flutter run --dart-define=SERVER_URL=http://127.0.0.1:8080/
```

Allow notifications when Android asks. Wait until the screen shows
`Registered on android`.

Optional OneSignal:

```bash
flutter run --dart-define=SERVER_URL=http://127.0.0.1:8080/ \
  --dart-define=ONESIGNAL_APP_ID=your-onesignal-app-id
```

## 3. Web (Chrome)

Web FCM needs your Firebase web app config as `--dart-define`s **and** the
same values in `web/firebase-messaging-sw.js`.

```bash
cd examples/push/push_flutter
flutter run -d chrome \
  --dart-define=SERVER_URL=http://127.0.0.1:8080/ \
  --dart-define=FIREBASE_API_KEY=... \
  --dart-define=FIREBASE_APP_ID=... \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \
  --dart-define=FIREBASE_PROJECT_ID=... \
  --dart-define=FIREBASE_AUTH_DOMAIN=... \
  --dart-define=FIREBASE_STORAGE_BUCKET=... \
  --dart-define=FIREBASE_DATABASE_URL=... \
  --dart-define=FIREBASE_MEASUREMENT_ID=... \
  --dart-define=FCM_VAPID_KEY=... \
  --dart-define=ONESIGNAL_APP_ID=...
```

## 4. How to use the UI

1. Expand an area (`BASIC`, `RETRY`, …).
2. Select **one** radio case.
3. Read the hint under the status line (especially for `app.*`).
4. Tap **Run selected case**.
5. Read the selectable report (status / attempts / claimCount / errors).
6. Optionally tap the inbox icon for a queue-depth snapshot.

Suggested order:

| # | Case | What you should see |
|---|---|---|
| 0 | `broadcast.delayed_ping` | Tap **Schedule ping in 15s**, then bg/kill app before delivery |
| 1 | `basic.success` | Real FCM; Android tray or web notification / foreground data |
| 2 | `basic.invalid_recipient` | `deliveriesCreated=0` |
| 3 | `basic.invalid_token` | Device disabled with `invalidToken` |
| 4 | `lifecycle.register_status` | Lists live devices |
| 5 | `lifecycle.token_refresh` | One live row for the installation |
| 6 | `lifecycle.unregister_self` | Device disabled; re-launch app to register again |
| 7 | `delivery.online` | Same as success |
| 8 | `delivery.offline_queue` | Stuck in `sending` while provider hangs, then released |
| 9 | `delivery.provider_failure` | `abandoned` after permanentFailure |
| 10 | `retry.transient_then_success` | `failed` then `accepted` |
| 11 | `retry.timeout` | `attempts=0`, `claimCount>=1` |
| 12 | `retry.max_retries` | `abandoned` after maxAttempts |
| 13 | `concurrency.two_workers` | Two distinct `claimedBy` values |
| 14 | `concurrency.duplicate_claim` | Only one owner for a single row |
| 15 | `idempotency.duplicate_job` | Second call `deduped=true` |
| 16 | `idempotency.worker_crash_retry` | Hang then accept on retry |
| 17 | `payload.notification` | Real FCM title+body |
| 18 | `payload.data_only` | Data-only payload |
| 19 | `payload.malformed_large` | `PushPayloadTooLargeException` |
| 20 | `multi.one_device` / `two` / `many` | Fan-out count matches |
| 21 | `provider.*` | Scripted provider outcomes |
| 22 | `queue.empty` / `normal` / `high` | Depth / burst drain |
| 23 | `app.foreground` | Keep app open |
| 24 | `app.background` | Home immediately after Run |
| 25 | `app.terminated` | Kill app after Run (Android) |
| 26 | `security.unauthorized_send` | Anonymous `authorizedSend` rejected |
| 27 | `security.invalid_recipient` | Same as invalid recipient |

## Notes

- Agent-backgrounded processes die when the chat turn ends. Keep server +
  `flutter run` in **your** terminals.
- Concurrency / retry cases use a controllable FCM wrapper on the server; they
  do not always produce a tray notification.
- `app.*` on web with the tab closed needs a correctly configured
  `firebase-messaging-sw.js`.
