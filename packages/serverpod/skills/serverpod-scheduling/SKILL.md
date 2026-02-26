---
name: serverpod-scheduling
description: Schedule future work in Serverpod — FutureCall, callWithDelay, callAtTime, recurring tasks, cancellation. Use when scheduling delayed or recurring tasks.
---

# Serverpod Scheduling (Future Calls)

Future calls run at a specified time, are stored in the database, and survive restarts. Each call executes once across all instances. Not available in serverless mode.

## Defining a future call

```dart
class ExampleFutureCall extends FutureCall {
  Future<void> doWork(Session session) async {
    // Work here.
  }

  Future<void> doOtherWork(Session session, MyModel data) async {
    // Work with data.
  }
}
```

Run `serverpod generate` for the type-safe API on `pod.futureCalls`.

## Supported parameter and return types

The same parameters as for endpoint methods are supported:

- Primitives: `bool`, `int`, `double`, `String`
- `Duration`, `DateTime` (UTC), `ByteData`, `UuidValue`, `Uri`, `BigInt`
- Generated serializable models (from `.spy.yaml`)
- `List`, `Map`, `Set`, `Record` — strictly typed with the above

## Scheduling

```dart
// Delay
await pod.futureCalls
    .callWithDelay(const Duration(hours: 1))
    .example.doWork();

// At specific time (UTC)
await pod.futureCalls
    .callAtTime(DateTime.utc(2026, 1, 1))
    .example.doOtherWork(myModel);

// With identifier (for cancellation)
await pod.futureCalls
    .callWithDelay(const Duration(hours: 1), identifier: 'my-job-id')
    .example.doWork();

await pod.futureCalls.cancel('my-job-id');  // Cancels all with that identifier
```

## Recurring tasks

Have the future call reschedule itself:

```dart
Future<void> doWork(Session session) async {
  await _actualWork(session);
  // Reschedule next run
  await session.serverpod.futureCalls
      .callWithDelay(const Duration(minutes: 20))
      .example.doWork();
}
```

Handle failures inside the call and reschedule if the work must eventually succeed.

## Configuration

```yaml
futureCallExecutionEnabled: true  # SERVERPOD_FUTURE_CALL_EXECUTION_ENABLED
futureCall:
  concurrencyLimit: 5             # SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT (default 1, negative=unlimited)
  scanInterval: 2000              # SERVERPOD_FUTURE_CALL_SCAN_INTERVAL (ms, default 5000)
```
