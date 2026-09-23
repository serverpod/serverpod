![Serverpod banner](https://github.com/serverpod/serverpod/raw/main/misc/images/github-header.webp)

# Serverpod Push Core

Provider-agnostic push types and the `PushProvider` contract used by
`serverpod_push_store`. Includes the FCM HTTP v1, OneSignal, and Amazon SNS
providers.

See [https://docs.serverpod.dev](https://docs.serverpod.dev) for Serverpod
documentation.

## Schema rule

`PushMessage` is persisted as a JSON column. It is append-only and
nullable-only: renaming or making a field non-nullable is a data-format break,
not a schema migration. Every `PushNotification` row records a `schemaVersion`
so a rolling deploy can detect rows it does not understand.

## Amazon SNS

`SnsPushProvider` publishes through the SNS query API (Signature Version 4).
The device credential is either a platform token or an existing endpoint ARN:

- **Token.** An FCM registration token or an APNs device token. The provider
  calls `CreatePlatformEndpoint` with the platform application ARN for that
  device's platform, then `Publish`. Pass
  `androidPlatformApplicationArn`, `iosPlatformApplicationArn`, and
  `macosPlatformApplicationArn` for the platforms you address this way.
- **Endpoint ARN.** `arn:aws:sns:…:endpoint/…` is published directly.

`identityKeyFor` returns the credential unchanged: both forms are stable.
Auth failures are reported as `UNAUTHENTICATED` or `PERMISSION_DENIED` so the
store's circuit breaker opens. Set `apnsEnvironment` to match the APNs
platform application; SNS will not deliver an `APNS` payload to a sandbox
endpoint.
