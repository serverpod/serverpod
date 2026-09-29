# Design: Future Call Retry

## Summary

Future calls have no built-in way to retry. When a call throws, its entry is deleted, and developers write their own retry logic inside the call. That mixes business logic with scheduling logic.

This design adds retry policies. A retry policy is a regular Dart class that extends `FutureCallRetryPolicy`. It is serialized through Serverpod's existing `extraClasses` mechanism and stored with the future call entry.

When a call fails, the framework asks the policy for a delay. If there is one, it moves the same entry to a later time, records the attempt, and saves the policy's current state. The existing scanner, claim and heartbeat machinery then runs the retry.

No retry state lives only in memory. Retries therefore survive restarts and deployments, work with cancellation, and respect the configured concurrency limit.

## Goals

- Retry failed future calls without the developer writing any scheduling code.
- Provide fixed, linear and exponential backoff out of the box.
- Let developers write their own strategies without framework changes.
- Keep retry state durable. A restart, crash or deployment must not reset the attempt count or lose a retry.
- Keep cancellation and the concurrency limit working the same way while a call is retrying.
- Leave calls without a retry policy behaving exactly as they do today.

## Non-goals

- Retrying calls that failed before this feature shipped.
- Exactly-once execution. Future calls stay at-least-once, and retries add more attempts. Calls that retry should be idempotent.
- Sub-millisecond timing. A retry delay is a minimum: the retry runs at or after its due time, the same as `callWithDelay`. Retries are picked up by the periodic scan, so a retry can start up to one `scanInterval` (5 seconds by default) after it is due. See [Open questions](#open-questions).

## Proposed Solution

### Retry policy API

```dart
/// Decides whether, and after how long, a failed future call is retried.
///
/// Concrete subclasses are registered for serialization automatically by
/// `serverpod generate`, and must provide a
/// `factory X.fromJson(Map<String, dynamic> json)` constructor.
abstract class FutureCallRetryPolicy {
  const FutureCallRetryPolicy();

  /// Returns the delay before the next attempt, or null to stop retrying.
  ///
  /// The policy is serialized again after each call, so a policy can keep
  /// state between attempts by updating its own fields.
  Duration? nextDelay(FutureCallRetryContext context);

  /// Serializes the policy, including any state it keeps between attempts.
  Map<String, dynamic> toJson();
}
```

```dart
/// Information about a failed future call attempt.
class FutureCallRetryContext {
  /// The attempt that just failed. 0 for the first run, 1 for the first
  /// retry, and so on.
  final int attempt;

  /// The error thrown by the attempt.
  final Object error;

  /// The stack trace of [error].
  final StackTrace stackTrace;
}
```

### Serialization through server-only extra classes

`extraClasses` already gives each listed class:

- a name mapping in the generated `Protocol.getClassNameForObject`;
- a branch in `Protocol.deserializeByClassName` that calls the class's `fromJson` constructor.

`FutureCallManager` receives the project's `Protocol` as its serialization manager, so it stores and loads policies with existing methods:

```dart
// When scheduling, and after each nextDelay
final serialized = _serializationManager.encodeWithType(policy);
// {"className":"DecorrelatedJitterRetryPolicy","data":{...}}

// When a call fails
final policy = _serializationManager.decodeWithType(serialized)
    as FutureCallRetryPolicy;
```

**Required generator change.** Today, extra classes are generated into both the server and the client protocol. The client package can't import a class that lives in the server package, or one that extends a class from `package:serverpod`. This design adds server-only extra classes:

```yaml
# config/generator.yaml
serverOnlyExtraClasses:
  - package:my_project_server/src/retry/decorrelated_jitter.dart:DecorrelatedJitterRetryPolicy
```

The generator needs these changes:

- **Config:** parse `serverOnlyExtraClasses` the same way as `extraClasses`, and mark the entries as server-only.
- **Protocol:** include server-only extra classes when generating server code and skip them in client code. This is the same filter already used for server-only models.
- **Validation:** report an error when a server-only extra class is used where the client needs it, such as in endpoint parameters or return types, stream types, or fields of models that aren't server-only.

The feature is useful beyond retry policies for any server-only type that needs to be stored with `encodeWithType`.

Retry policies don't have to be listed under `serverOnlyExtraClasses` by hand; see [Automatic registration of policy classes](#automatic-registration-of-policy-classes).

**Built-in policies** are registered the same way when the `serverpod` package itself is generated. Project protocols already hand unknown classes to the core protocol under the `serverpod.` prefix, so built-ins need no setup in projects.

**Class lookup order.** The generated `getClassNameForObject` checks the project's own extra classes before modules and core. A project subclass of a built-in policy is therefore named correctly when it is registered. An unregistered subclass of a built-in, such as one from a plain Dart package, would be encoded under the built-in's name and lose its behavior when loaded. To prevent that, built-in policies are `final`.

### Automatic registration of policy classes

**Decision:** developers don't list retry policies in `generator.yaml`. `serverpod generate` finds them and registers them as server-only extra classes itself. The direction is still open for discussion; see [Open questions](#open-questions).

- **Which classes:** the same classes the [analyzer checks](#analyzer-checks-for-policy-classes) cover: concrete classes in the package's `lib/` directory whose supertypes include `FutureCallRetryPolicy`. Abstract and sealed classes are never serialized, so they aren't registered.
- **How:** the entries are added in memory for that generation run, and `generator.yaml` isn't modified. The generated server `Protocol` gets the same name mapping and `fromJson` branch as for a listed class, importing it through its `package:` URI. The client protocol doesn't get them.
- **When:** in `analyzers.dart`, future call analysis already runs before endpoint analysis and protocol generation. The registered classes are therefore known when the protocol is generated and when endpoint signatures are checked for server-only classes.
- **Explicit entries still work.** A policy that is also listed under `serverOnlyExtraClasses` is registered once. Listing is still needed for policies defined in plain Dart packages, which `serverpod generate` doesn't analyze.
- **Modules and core:** each Serverpod package registers its own policies when it is generated. A project reaches a module's policies through the module's protocol and the built-ins through the core protocol, as it does for other module classes.
- **Watch mode:** adding, removing or renaming a policy class changes the registered set, so the protocol must be regenerated. The incremental analyzer must treat a change to a policy class's file as affecting the protocol.
- **Classes with errors aren't registered.** A policy that fails the analyzer checks is left out, so the generated `Protocol` still compiles while the error is being fixed.

### Analyzer checks for policy classes

Dart can't require a constructor through an abstract class, so a policy without `fromJson` compiles on its own. It would only fail later: either the generated `Protocol` doesn't compile, or the policy can't be loaded when a retry is due. The CLI analyzer closes that gap by reporting an error, which fails generation, for any class that extends `FutureCallRetryPolicy` and doesn't have the expected shape.

**What counts as a usable `fromJson`:**

- A constructor named `fromJson` that is declared on the class itself. Constructors aren't inherited in Dart, so a subclass of a policy that has `fromJson` still needs its own. This is the case the check is most likely to catch.
- It can be a factory or a generative constructor.
- It must be public.
- It must be callable with one positional argument that is a JSON map: exactly one required positional parameter whose type accepts `Map<String, dynamic>`.

**Other rules, needed for automatic registration:**

- The class must be public. The generated `Protocol` can't refer to a private class.
- Its name must not clash with another registered extra class or model. Generated protocols identify classes by their bare name.

**What is reported:** an error on the class name, for example:

```txt
DecorrelatedJitterRetryPolicy extends FutureCallRetryPolicy but has no
fromJson constructor. Add `factory DecorrelatedJitterRetryPolicy.fromJson(
Map<String, dynamic> json)` so the policy can be loaded when a retry is due.
```

If a `fromJson` constructor exists but has the wrong shape (private, no positional parameter, a parameter type that doesn't accept a map, or extra required parameters), the message says which rule it breaks. The private class and name clash rules have their own messages.

**Where the check lives:** a new `FutureCallRetryPolicyAnalyzer` next to the existing analyzers in `analyzer/dart/future_call_analyzers/`, run by `FutureCallsAnalyzer` on each resolved library.

- **File selection:** today `FutureCallsAnalyzer` only resolves files whose text contains `extends FutureCall`. That happens to match direct subclasses of `FutureCallRetryPolicy`, but not indirect ones. The policy check therefore needs its own file selection over the server package's `lib/` directory, relying on the resolved supertypes rather than a text match.
- **Severity:** findings are reported with `SourceSpanSeverity.error` through the future calls analyzer's `CodeAnalysisCollector`. `hasSevereErrors` counts them, so the generation run's `success` becomes false and `serverpod generate` exits with an error.

### Built-in policies

```dart
/// Retries after the same delay every time.
final class FixedDelayRetryPolicy extends FutureCallRetryPolicy {
  const FixedDelayRetryPolicy({required this.maxAttempts, required this.delay});
  final int maxAttempts;
  final Duration delay;
}

/// Retries with a delay that grows by [increment] after each failure.
final class LinearBackoffRetryPolicy extends FutureCallRetryPolicy {
  const LinearBackoffRetryPolicy({
    required this.maxAttempts,
    required this.initialDelay,
    required this.increment,
    this.maxDelay,
  });
  // ...
}

/// Retries with a delay that is multiplied by [multiplier] after each failure.
final class ExponentialBackoffRetryPolicy extends FutureCallRetryPolicy {
  const ExponentialBackoffRetryPolicy({
    required this.maxAttempts,
    required this.initialDelay,
    this.multiplier = 2.0,
    this.maxDelay,
  });
  // ...
}
```

`maxAttempts` counts retries only. `maxAttempts: 3` means the first run plus at most three retries, so up to four runs in total. `maxAttempts: 0` means no retries.

Attempts are numbered from the first retry: the first run is attempt 0, the first retry is attempt 1, and so on. `FutureCallRetryContext.attempt` is the number of the attempt that just failed, which is also the number of retries that have already run.

The delay after attempt `n` fails:

| Policy | Delay before retry `n + 1` |
| --- | --- |
| Fixed | `delay` |
| Linear | `min(initialDelay + increment * n, maxDelay)` |
| Exponential | `min(initialDelay * multiplier^n, maxDelay)` |

A policy allows another retry while `n < maxAttempts`, and returns null once `n >= maxAttempts`.

For `maxAttempts: 3`, with every run failing:

| Run | `context.attempt` when it fails | Outcome |
| --- | --- | --- |
| First run | 0 | retry 1 |
| Retry 1 | 1 | retry 2 |
| Retry 2 | 2 | retry 3 |
| Retry 3 | 3 | 3 >= 3: gives up |

### Database schema

`FutureCallEntry` gets two fields, and neither is specific to a strategy:

```yaml
### A serialized future call with bindings to the database.
class: FutureCallEntry
table: serverpod_future_call

fields:
  # ... existing fields ...

  ### The retry policy and its current state, serialized with its class name.
  ### Null means the call is not retried.
  serializedRetryPolicy: String?

  ### Number of attempts of this entry that have already failed.
  failedAttempts: int, default=0
```

- **`serializedRetryPolicy`** follows the naming of the existing `serializedObject`. It holds the output of `encodeWithType`, so the class name and data are in one column.
- **`failedAttempts`** belongs to the framework, not to a strategy. It feeds `FutureCallRetryContext.attempt`, `FutureCallSession.attempt`, and the logs.

Existing rows get `null` and `0`, which is the current behavior. The change needs a migration.

### Retry policies are chosen when scheduling

A retry policy is only ever given when a call is scheduled (see [Scheduling API](#scheduling-api)). A call scheduled without a policy is never retried, exactly as today.

Because of this:

- **The row shows everything.** Whether a call retries, and how, can be read from its row without looking at code.
- **Deploys don't change retry behavior.** The policy for a pending call is fixed when the call is scheduled.
- **No opt-out is needed.** Leaving out `retryPolicy` is how a caller asks for no retries.

### Error filter

The author of a future call knows best which errors are worth retrying. `FutureCall` gets one overridable member:

```dart
abstract class FutureCall<T extends SerializableModel> {
  // ... existing members ...

  /// Returns false for errors that should never be retried, whatever the
  /// policy says. Returns true by default.
  FutureOr<bool> shouldRetry(Object error) => true;
}
```

`shouldRetry` stays separate from the policy. Which errors can be retried depends on the call's code; how long to wait between attempts depends on the policy. That lets a built-in policy be combined with a call-specific filter without subclassing. It has no effect on calls scheduled without a policy.

`shouldRetry` returns `FutureOr<bool>`, so a filter can do asynchronous work, such as looking up whether the record the call works on still exists. An override that returns a plain `bool` is still valid. The framework awaits the result while the call's claim and heartbeat are still held. A filter that takes a long time delays the retry decision, but the call is not claimed a second time while it waits.

The future call analyzer must not treat `shouldRetry` as a future call method. It doesn't take a `Session` and doesn't return `Future<void>`, so the current filter should already skip it.

### Scheduling API

`FutureCallDispatch` gets an optional `retryPolicy` parameter on each way of scheduling a call.

```dart
abstract class FutureCallDispatch<T> {
  T callAtTime(
    DateTime time, {
    String? identifier,
    FutureCallRetryPolicy? retryPolicy,
  });

  T callWithDelay(
    Duration delay, {
    String? identifier,
    FutureCallRetryPolicy? retryPolicy,
  });

  RecurringFutureCallDispatch<T> callRecurring({
    String? identifier,
    FutureCallRetryPolicy? retryPolicy,
  });

  // ...
}
```

`FutureCallManager.scheduleFutureCall` gets a matching named `retryPolicy` parameter. It serializes the policy with `encodeWithType`. A policy class that isn't registered makes `encodeWithType` throw `ArgumentError`, so the mistake shows up when the call is scheduled, not when it later fails.

### Execution flow

#### 1. Run the call

This works as today: the call is claimed, the heartbeat starts, and the call is invoked. The session gets the attempt number:

```dart
class FutureCallSession extends Session {
  final String futureCallName;

  /// The attempt currently running. 0 for the first run, 1 for the first
  /// retry, and so on. Equal to the entry's `failedAttempts`.
  final int attempt;
}
```

`FutureCallSessionBuilder` gets an `attempt` argument.

**Recurring calls:** the next occurrence is scheduled only when `failedAttempts == 0`. A retry must not add another occurrence. The inserted occurrence copies the entry with `failedAttempts: 0`. It also gets the originally scheduled policy, not state saved by earlier attempts.

#### 2. On success

Cancel the heartbeat and delete the entry, as today.

#### 3. On failure

Report the error as today, including the attempt number in the log. Then decide whether to retry:

```dart
Duration? delay;
FutureCallRetryPolicy? policy;

final serializedPolicy = entry.serializedRetryPolicy;
if (serializedPolicy != null && await futureCall.shouldRetry(error)) {
  policy = _serializationManager.decodeWithType(serializedPolicy)
      as FutureCallRetryPolicy;

  delay = policy.nextDelay(
    FutureCallRetryContext(
      attempt: entry.failedAttempts,
      error: error,
      stackTrace: stackTrace,
    ),
  );
}
```

A call scheduled without a policy skips the whole decision, so `shouldRetry` is never called for it.

If loading the policy, `shouldRetry` or `nextDelay` throws, the framework reports the error and does not retry.

If `delay` is null, cancel the heartbeat and delete the entry, as today. Log at error level that the call gave up after `n` retries, so the final failure can be told apart from failures that will be retried.

If `delay` is not null, save the new time, the attempt count and the policy's state, and release the claim, all in one transaction:

```dart
final nextTime = clock.now().toUtc().add(delay);

final retried = await _internalSession.db.transaction((transaction) async {
  final updated = await FutureCallEntry.db.updateWhere(
    _internalSession,
    where: (t) => t.id.equals(entry.id),
    columnValues: (t) => [
      t.time(nextTime),
      t.failedAttempts(entry.failedAttempts + 1),
      t.serializedRetryPolicy(_serializationManager.encodeWithType(policy)),
    ],
    transaction: transaction,
  );

  // The entry was cancelled while the attempt was running.
  if (updated.isEmpty) return false;

  await FutureCallClaimEntry.db.deleteWhere(
    _internalSession,
    where: (t) => t.futureCallId.equals(entry.id),
    transaction: transaction,
  );
  return true;
});
```

Then cancel the heartbeat. Do not delete the entry. When it is due, it becomes an ordinary entry that any instance can find and claim.

What this means:

- **Cancelled during the attempt:** `cancelFutureCall` deleted the row, so the update matches nothing and there is no retry.
- **Transaction fails**, for example because the database is unreachable: the row and claim are left as they are. The heartbeat is cancelled, so the claim goes stale and the same attempt runs again after the stale threshold. This matches today's crash behavior and keeps at-least-once delivery. The policy's state isn't saved, so the next failure starts from the previously saved state.
- **Process dies between the attempt and the transaction:** same as above.

#### Maintenance role

`runScheduledFutureCalls()` scans once and drains the scheduler. A failed call is moved to its retry time and runs on a later maintenance run, so a long backoff never keeps the maintenance job alive.

### Broken call check

`_checkBrokenFutureCalls` also tries to decode `serializedRetryPolicy`. It can fail when a policy class is renamed or removed, or otherwise stops being registered. Such entries are reported, and deleted when `deleteBrokenCalls` is on, the same way as entries whose argument can't be decoded.

## Developer experience

### Using a built-in policy

A future call with a filter for errors that won't recover:

```dart
class EmailCall extends FutureCall {
  @override
  FutureOr<bool> shouldRetry(Object error) => error is! InvalidRecipientException;

  Future<void> send(Session session, User user) async {
    // ...
  }
}
```

Scheduling it with a retry policy:

```dart
await pod.futureCalls
    .callWithDelay(
      const Duration(minutes: 5),
      retryPolicy: const ExponentialBackoffRetryPolicy(
        maxAttempts: 5,
        initialDelay: Duration(seconds: 2),
        maxDelay: Duration(minutes: 5),
      ),
    )
    .emailCall
    .send(user);
```

Scheduling it without one, so a failure is not retried:

```dart
await pod.futureCalls
    .callWithDelay(const Duration(minutes: 5))
    .emailCall
    .send(user);
```

A recurring call applies the policy to each occurrence separately:

```dart
await pod.futureCalls
    .callRecurring(
      identifier: 'daily-digest',
      retryPolicy: const FixedDelayRetryPolicy(
        maxAttempts: 3,
        delay: Duration(minutes: 1),
      ),
    )
    .cron('0 8 * * *')
    .digestCall
    .send();
```

### Writing a custom policy

Extend `FutureCallRetryPolicy` and provide a `fromJson` constructor along with implementations for the abstract methods.

```dart
class DecorrelatedJitterRetryPolicy extends FutureCallRetryPolicy {
  DecorrelatedJitterRetryPolicy({
    required this.maxAttempts,
    required this.base,
    required this.cap,
    Duration? previousDelay,
  }) : previousDelay = previousDelay ?? base;

  factory DecorrelatedJitterRetryPolicy.fromJson(Map<String, dynamic> json) =>
      DecorrelatedJitterRetryPolicy(
        maxAttempts: json['maxAttempts'],
        base: Duration(milliseconds: json['baseMs']),
        cap: Duration(milliseconds: json['capMs']),
        previousDelay: Duration(milliseconds: json['previousDelayMs']),
      );

  final int maxAttempts;
  final Duration base;
  final Duration cap;
  Duration previousDelay;

  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    // implementation goes here
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxAttempts': maxAttempts,
    'baseMs': base.inMilliseconds,
    'capMs': cap.inMilliseconds,
    'previousDelayMs': previousDelay.inMilliseconds,
  };
}
```

Running `serverpod generate` registers the class, as long as it is in the server package's `lib/` directory.

### What developers can rely on

- **Retries are visible.** A retrying call is a row in `serverpod_future_call` with `failedAttempts > 0`, a future `time`, and the policy's current state.
- **Cancel stops retries.** Cancelling by identifier also stops any pending retry.
- **Attempt limits and policy state survive restarts.**
- **Retries respect the concurrency limit.** They share `FutureCallConfig.concurrencyLimit` with other future calls, so a downstream outage doesn't multiply the load.
- **Policy classes are registered for them.** Writing the class is enough; there is nothing to add to `generator.yaml`.
- **Malformed policies fail generation.** A policy class without a usable `fromJson` constructor, a private one, or one whose name clashes with another class makes `serverpod generate` fail.
- **Remaining mistakes show up when the call is scheduled.** A policy class that isn't registered, such as one from a plain Dart package, fails in `scheduleFutureCall`.
- **Logs show the attempt.** Each failure is logged with its attempt number. Giving up is logged separately.

## Open questions

- **Automatic registration:** is automatic registration of policy classes the right direction? So far every extra class has been listed explicitly, and this makes one base type a special case in the generator. The options are:
  - **Register in memory (chosen):** nothing to configure, but registration isn't visible in `generator.yaml`.
  - **Require explicit listing:** keep `serverOnlyExtraClasses` as the only way, and have the analyzer report an error for policy classes that aren't listed. Configuration stays explicit, and the cost is one extra step for each policy.
  - **Write the entries into `generator.yaml`:** registration becomes visible, but the generator edits a file developers maintain by hand, which risks losing comments and formatting.
- **Config shape:** should `serverOnlyExtraClasses` instead be a `serverOnly: true` flag on individual `extraClasses` entries, or be inferred for classes from the server package, which the client can never import?
- **Retries due before the next scan:** retries are only picked up by the periodic scan. A retry due 1 second after a failure can therefore wait up to one `scanInterval` (5 seconds by default). Is that acceptable, or should short delays be honoured more closely? One option:
  - After saving a retry, the instance that ran the call sets a one-shot timer for the retry's due time. When the timer fires, it triggers an extra scan. A single timer, always pointing at the earliest due retry, covers all pending retries.
  - The retry still goes through scan → claim → scheduler, so cancellation, the concurrency limit, and claiming across instances are unchanged. If the process stops, the timer is lost but the row already has the correct `time`, so the worst case is today's delay.
- **Recurring overlap:** a retry of one recurring occurrence can still be pending when the next occurrence is due. The proposal is to allow this and document it. The alternative is to drop retries whose due time is at or after the next occurrence.
