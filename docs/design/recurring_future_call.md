# Design: Recurring Future Calls

## Summary

Serverpod currently supports scheduling future calls using `callWithDelay` or `callAtTime`. These calls are stored in the database and executed once when their scheduled time arrives.

Recurring jobs are currently implemented by manually scheduling the next future call from inside the executing future call itself. This approach works but is unintuitive and requires developers to manually manage scheduling logic.

This design introduces native recurring future calls using cron expressions while preserving full compatibility with the existing future call system. Developers will be able to schedule recurring tasks using cron expressions or a utility API for common cases that converts to cron expressions internally.

Recurring calls will reuse the existing execution pipeline by computing the next execution time after each run and updating the existing future call entry.

## Proposed Solution

Extend the future call system to support two types of entries:

- oneOff – existing behavior
- recurring – scheduled using cron expressions

Recurring call entries will store a cron expression. After execution, the cron expression will be parsed to compute the next execution time and the future call entry will be updated accordingly. This ensures that the existing query used to fetch due future calls remains unchanged.

### Database Schema

The `serverpod_future_call` table schema will be extended to include a new `scheduling` field.

```yaml
class: FutureCallEntry
table: serverpod_future_call
fields:
  ### Specifies how recurring calls should be scheduled.
  scheduling: FutureCallScheduling?
```

```yaml
### Generic interface that specifies how recurring calls should be scheduled.
class: FutureCallScheduling
sealed: true
```

```yaml
## A recurring future call scheduling option that uses cron expression
class: CronFutureCallScheduling
extends: FutureCallScheduling
fields:
  ### Cron expression for recurring calls
  cron: String
```

```yaml
## A recurring future call scheduling option that uses a Duration interval
class: IntervalFutureCallScheduling
extends: FutureCallScheduling
fields:
  ### Interval for recurring calls
  duration: Duration
```

### Scheduling API

A new `RecurringFutureCallDispatch` API will be introduced to support cron and interval scheduling for recurring calls.

```dart
/// Provides type-safe access to recurring future calls on the server.
/// Typically, this class is overriden by a generated class.
abstract class RecurringFutureCallDispatch<T> {
  /// Calls a [FutureCall] at a recurring interval defined by [cronExpression].
  T cron(String cronExpression);

  /// Calls a [FutureCall] at a recurring interval defined by [interval],
  /// optionally passing a [start] time.
  /// If [start] is in the past, the [FutureCall] is first called immediately
  /// and then subsequently called recurrently on [interval].
  T every(Duration interval, {DateTime? start});
}
```

This API will be accessible through a new `callRecurring` method from `FutureCallDispatch`.

```dart
/// Calls a [FutureCall] at a recurring interval, optionally passing a [String] identifier.
T callRecurring({String? identifier}) {}
```

Developers can then schedule recurring calls using the generated type-safe API.

```dart
await pod.futureCalls.callRecurring().cron("0 * * * *").example.runTask();
```

```dart
await pod.futureCalls
    .callRecurring()
    .every(
      const Duration(hours: 1),
      start: DateTime.now().add(Duration(hours: 1)),
    )
    .example
    .runTask();
```

### Execution Flow

Existing logic for scanning and scheduling future calls will remain unchanged and only add a special case handling for running recurring future calls.

Before running a recurring future call, the next run time is derived and a new entry is inserted into the database with that time when the future call's execution is completed. The next run time is computed relative to the current time and not the last scheduled time for the `FutureCallEntry`. This is to ensure the next time is always in the future.

```dart
if (futureCallEntry.scheduling != null) {
  final nextRunTime = _computeNextRunTime(futureCallEntry.scheduling);
  await FutureCallEntry.db.insert(
    _internalSession,
    futureCallEntry.copyWith(id: null, time: nextRunTime),
  );
}
```

For cron scheduling, a cron parser will be implemented to parse cron expressions and compute the next execution time. The parser will support 5-field and 6-field cron expressions.

In the future, the parser may be updated to support special named values such as `L` (for last day), `JAN`, `MON`, etc.

### Potential Issues

#### 1. Long running jobs

If a recurring job takes longer than the interval between runs, the next run time may already be in the past.
When computing the next run time, always compute the next valid future occurrence rather than using the previous scheduled time.

#### 2. Invalid cron expressions

Cron expressions will be validated when scheduling the future call to provide feedback to developers when invalid expressions are used.
Recurring future calls with invalid cron expressions will not be stored in the database.

## Backwards Compatibility

This implementation maintains full backwards compatibility.
Existing future calls continue to work unchanged because:

- the scan query remains unchanged
- existing entries default to type = oneOff
- new fields are optional
