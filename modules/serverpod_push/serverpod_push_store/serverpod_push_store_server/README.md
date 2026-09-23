![Serverpod banner](https://github.com/serverpod/serverpod/raw/main/misc/images/github-header.webp)

# Serverpod Push Store

Durable push queue, dispatcher, and device registration endpoints.

See [https://docs.serverpod.dev](https://docs.serverpod.dev) for Serverpod
documentation.

## Setup

Register providers, then initialize the store on your `Serverpod` instance:

```dart
PushService.set(providers: [FcmPushProviderBuilder(credentials: ...)]);
await pod.initializePushStore();
```

The dispatcher runs only when the pod's role is `monolith`. Serverless and
maintenance roles still enqueue; they never drain. A deployment with no
monolith anywhere is a queue that fills forever.

## Security

`registerDevice` / `unregisterDevice` are unauthenticated by design — anonymous
registration is legitimate. Deployments should **rate-limit these endpoints at
the edge**. An authenticated caller who obtains another user's credential can
re-point it, so **credential secrecy is load-bearing**.

`acknowledge` treats the delivery id in the push payload as a capability:
anonymous devices can record `receivedAt` / `openedAt` without login. Owned
devices still require the owning user.

`unregisterDevice` is a soft-delete. Deleting a `PushDevice` row cascades away
its delivery history, including `receivedAt` / `openedAt`. Use `purgeDevice`
only when that history should actually go.

## Operations

The per-process auth circuit breaker trips independently on each replica.
`authFailureCooldown` grows on repeated trips to bound the aggregate retry
rate.

`serverpod_push_delivery` is a high-churn queue table. Tighten autovacuum on
it, for example:

```sql
ALTER TABLE serverpod_push_delivery SET (
  autovacuum_vacuum_scale_factor = 0.01,
  autovacuum_analyze_scale_factor = 0.02
);
```
