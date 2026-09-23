![Serverpod banner](https://github.com/serverpod/serverpod/raw/main/misc/images/github-header.webp)

# Serverpod Push Core

Provider-agnostic push types and the `PushProvider` contract used by
`serverpod_push_store`. Includes the FCM HTTP v1 provider.

See [https://docs.serverpod.dev](https://docs.serverpod.dev) for Serverpod
documentation.

## Schema rule

`PushMessage` is persisted as a JSON column. It is append-only and
nullable-only: renaming or making a field non-nullable is a data-format break,
not a schema migration. Every `PushNotification` row records a `schemaVersion`
so a rolling deploy can detect rows it does not understand.
