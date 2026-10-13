# Design: Future Call Retry

## 1. Purpose

Future calls have no built-in way to retry. When a call throws, it is dropped, and developers who need retries write the rescheduling logic inside the call itself. This proposal lets a developer attach a retry policy when scheduling a future call. If the call fails, Serverpod runs it again later according to that policy, with no scheduling code in the call. Retries are stored in the database, so they survive restarts and deployments, stop when the call is cancelled, and respect the future call concurrency limit.

## 2. User-facing API

### Scheduling a call with a retry policy

The retry policy is added with its own chained call, `withRetryPolicy`. It works the same way after every way of scheduling:

```dart
await pod.futureCalls
    .callWithDelay(const Duration(minutes: 5))
    .withRetryPolicy(
      const ExponentialBackoffRetryPolicy(
        maxAttempts: 5,
        initialDelay: Duration(seconds: 2),
        maxDelay: Duration(minutes: 5),
      ),
    )
    .emailCall
    .send(user);
```

```dart
await pod.futureCalls
    .callRecurring(identifier: 'daily-digest')
    .cron('0 8 * * *')
    .withRetryPolicy(
      const FixedDelayRetryPolicy(
        maxAttempts: 3,
        delay: Duration(minutes: 1),
      ),
    )
    .digestCall
    .send();
```

Leaving `withRetryPolicy` out means the call is not retried, which is today's behaviour:

```dart
await pod.futureCalls
    .callWithDelay(const Duration(minutes: 5))
    .emailCall
    .send(user);
```

### Built-in policies

- **`FixedDelayRetryPolicy`** waits the same `delay` before every retry.
- **`LinearBackoffRetryPolicy`** waits `initialDelay` before the first retry, then adds `increment` to the wait for each retry after that.
- **`ExponentialBackoffRetryPolicy`** waits `initialDelay` before the first retry, then multiplies the wait by `multiplier` for each retry after that.
- **`RandomDelayRetryPolicy`** waits a random time between `min` and `max` before every retry.
- **`CustomDelaysRetryPolicy`** takes a list of delays and uses them in order, one for each retry. After the last one, it stops retrying.
- **`ChainedRetryPolicies`** takes a list of policies. It uses the first one until that policy stops retrying, then moves on to the next, and so on.

### Choosing which errors are retried

A future call class can override `shouldRetry` to stop retries for errors that will never succeed:

```dart
class EmailCall extends FutureCall {
  @override
  FutureOr<bool> shouldRetry(
    Session session,
    FutureCallRetryContext context,
  ) => context.error is! InvalidRecipientException;

  Future<void> send(Session session, User user) async {
    // ...
  }
}
```

It returns `true` by default.

- **`session`** is the session of the attempt that failed. It can be used to read or store data that the decision depends on.
- **`context`** describes the failure:
  - `error`: the error the call threw.
  - `stackTrace`: the stack trace of that error.
  - `retryAttempt`: how many retries had already run when the call failed, the same number as `FutureCallSession.retryAttempt`. It is 0 when the first run fails.

The failure is passed as one object so that more information can be added to it later without breaking existing overrides.

### Knowing which attempt is running

Inside a future call, `FutureCallSession.retryAttempt` gives the number of the current retry: 0 for the first run, 1 for the first retry, and so on.

### Writing a custom policy

A custom policy is a regular Dart class in the server project. It extends `FutureCallRetryPolicy` and provides `nextDelay`, `toJson` and a `fromJson` constructor:

```dart
class DecorrelatedJitterRetryPolicy extends FutureCallRetryPolicy {
  DecorrelatedJitterRetryPolicy({required this.maxAttempts, required this.base});

  factory DecorrelatedJitterRetryPolicy.fromJson(Map<String, dynamic> json) =>
      DecorrelatedJitterRetryPolicy(
        maxAttempts: json['maxAttempts'],
        base: Duration(milliseconds: json['baseMs']),
      );

  final int maxAttempts;
  final Duration base;

  /// Returns the delay before the next retry, or null to stop retrying.
  @override
  Duration? nextDelay(FutureCallRetryContext context) {
    // context.retryAttempt, context.error and context.stackTrace are available.
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxAttempts': maxAttempts,
    'baseMs': base.inMilliseconds,
  };
}
```

`nextDelay` receives the same `FutureCallRetryContext` as `shouldRetry`.

There is nothing to configure for a policy in the server project or in a Serverpod module. Running `serverpod generate` picks the class up, and it can then be passed to `withRetryPolicy`.

A policy class defined in a plain Dart package is not supported out of the box. `serverpod generate` does not pick it up, and there is no setting to add it.

### Cancelling

`pod.futureCalls.cancel(identifier)` works as today. It also stops any retry that is pending for that identifier.

## 3. Configurations and their behaviours

### What counts as a failure

A future call fails when it throws. A call that returns normally has succeeded and is never retried.

### Outcome of a run

| Situation | What happens |
| --- | --- |
| The call succeeds | The call is done. |
| The call fails and was scheduled without a policy | The failure is reported and the call is dropped, as today. `shouldRetry` is not called. |
| The call fails, has a policy, and `shouldRetry` returns `false` | The failure is reported and the call is dropped. |
| The call fails, has a policy, and the policy returns a delay | The failure is reported and the call runs again after at least that delay. |
| The call fails, has a policy, and the policy returns no delay | The failure is reported and the call is dropped. A separate error is logged saying the call gave up and after how many retries. |
| `shouldRetry` or the policy itself throws | That error is reported and the call is not retried. |

Every failure is reported the way failures are reported today, with the attempt number added.

### How attempts are counted

- The first run is attempt 0. The first retry is attempt 1. `FutureCallSession.retryAttempt` and `FutureCallRetryContext.retryAttempt` both use this numbering.
- `maxAttempts` counts retries only. `maxAttempts: 3` means the first run plus at most three retries, so up to four runs. `maxAttempts: 0` means no retries.
- `maxAttempts` is optional on the fixed, linear, exponential and random policies. Without it, the policy never stops retrying by itself. The call is then retried until it succeeds, is cancelled, or `shouldRetry` returns `false`.
- `CustomDelaysRetryPolicy` retries once for each delay in its list.
- `ChainedRetryPolicies` retries until its last policy stops retrying. Each policy in the chain counts its own retries from zero when its turn starts.

For `maxAttempts: 3`, with every run failing:

| Run | Attempt number | Outcome |
| --- | --- | --- |
| First run | 0 | retry 1 is scheduled |
| Retry 1 | 1 | retry 2 is scheduled |
| Retry 2 | 2 | retry 3 is scheduled |
| Retry 3 | 3 | gives up |

### Delays of the built-in policies

After attempt `n` fails, the delay before the next retry is:

| Policy | Delay | Example | Delays before retries 1, 2, 3, … |
| --- | --- | --- | --- |
| Fixed | `delay` | `maxAttempts: 3`, `delay: 30s` | 30s, 30s, 30s |
| Linear | `initialDelay + increment * n`, at most `maxDelay` | `maxAttempts: 4`, `initialDelay: 10s`, `increment: 10s` | 10s, 20s, 30s, 40s |
| Exponential | `initialDelay * multiplier^n`, at most `maxDelay` | `maxAttempts: 5`, `initialDelay: 2s`, `maxDelay: 20s` | 2s, 4s, 8s, 16s, 20s |
| Random | a new random value between `min` and `max` each time | `maxAttempts: 3`, `min: 1s`, `max: 10s` | for example 7s, 2s, 9s |
| Custom delays | item `n` of the list | `[1s, 1s, 2s, 3s, 5s, 8s]` | 1s, 1s, 2s, 3s, 5s, 8s |
| Chained | the delay from the policy whose turn it is | the `ChainedRetryPolicies` example below | 1s, 2s, 4s, 8s, then 1m, 10m, 20m |

```dart
// After one policy is exhausted, take the delay from the next.
ChainedRetryPolicies([
  ExponentialBackoffRetryPolicy(
    initialDelay: const Duration(seconds: 1),
    multiplier: 2,
    maxAttempts: 4,
  ),
  CustomDelaysRetryPolicy([
    const Duration(minutes: 1),
    const Duration(minutes: 10),
    const Duration(minutes: 20),
  ]),
]);
```

### Timing

- A delay is a minimum. A retry runs at or after its due time, never before.
- Retries are picked up by the same periodic scan as other future calls. A retry can therefore start up to one scan interval (5 seconds by default) after it is due. This also applies to delays shorter than the scan interval.

### Cancellation

- Cancelling by identifier removes a call that is waiting for a retry.
- If a call is cancelled while an attempt is running, that attempt finishes, and no retry is scheduled even if it fails.

### Restarts, deployments and crashes

- A call waiting for a retry is not lost when the server restarts or is redeployed. It runs when it is due, on any server instance.
- The number of retries used so far is kept, so `maxAttempts`, and the position in a list of delays or a chain of policies, holds across restarts.
- Future calls stay at-least-once. If a server crashes while an attempt is running, or right after it fails, that attempt runs again later and is not counted as a retry. A call can therefore run more times than `maxAttempts + 1`. Calls that use retries should be safe to run more than once.

### Concurrency

Retries share the future call concurrency limit with all other future calls. A dependency outage that makes many calls fail does not raise the number of calls running at once.

### Recurring calls

- The policy applies to each occurrence separately. Every occurrence starts at attempt 0 with the policy as it was given when scheduling.
- A retry does not create extra occurrences, and the schedule of later occurrences is not shifted by retries.
- A retry of one occurrence can still be pending or running when the next occurrence is due. Both run.

### Maintenance role

A server in the maintenance role runs due future calls once and exits. A call that fails there is scheduled for its retry time and runs on a later maintenance run or on another server. A long delay never keeps the maintenance run alive.

### The policy is fixed when the call is scheduled

- A pending call keeps the policy it was scheduled with. Deploying code that schedules the same call with a different policy only affects calls scheduled after the deploy.
- There is no default policy on the future call class. Whether a call retries is decided by the code that schedules it.

### Policies that keep state

A custom policy can change its own fields in `nextDelay`, for example to remember the previous delay. The updated values are saved after each failed attempt and are available on the next one, including after a restart or on another server instance.

### Invalid policies

A policy that can't work is rejected when the call is scheduled, with an error that says what is wrong:

- a negative `maxAttempts` or a negative delay;
- a `RandomDelayRetryPolicy` whose `min` is greater than its `max`;
- a `CustomDelaysRetryPolicy` or `ChainedRetryPolicies` with an empty list;

### Mistakes in custom policies and how they show up

| Mistake | When it shows up |
| --- | --- |
| A policy class has no usable `fromJson` constructor, is private, or has the same name as another registered class or model | `serverpod generate` fails with an error that names the class and the rule it breaks. |
| A policy class from a plain Dart package is used | Scheduling the call throws, because the class is not registered. |
| A policy class is renamed or removed while calls using it are still pending | On startup, those calls are reported as broken, together with calls whose arguments can no longer be read. They are deleted if `deleteBrokenCalls` is on. |

### What can be observed

- A call waiting for a retry is a row in `serverpod_future_call` with a count of failed attempts, its next run time, and its policy.
- Each failure is logged with its attempt number. Giving up is logged as a separate error.

## 4. Implementation strategy

### Retries reschedule the same future call

When a call fails and the policy returns a delay, Serverpod moves the existing database entry to the new time, increases its failure count, and releases it. From then on it is an ordinary future call that the existing scan picks up when it is due.

**Why:** the alternative is to keep the failed call in memory and wait there before running it again. That loses the retry count on restart, keeps retrying after a cancel, needs a second queue outside the concurrency limit, and makes shutdown wait for delays. Rescheduling the entry avoids all four, because it reuses the paths that already handle scheduling, cancelling and claiming.

### The policy is added with a chained call

`withRetryPolicy` is a method on the object that every scheduling method already returns. It gives back the same kind of object, now carrying the policy, so the call is then chosen and scheduled as usual.

**Why:**

- **One place for retries.** The alternative is a `retryPolicy` parameter on `callAtTime`, `callWithDelay` and `callRecurring`. A chained call keeps a single interface for retries and leaves the scheduling methods unchanged.
- **The cost is in generated code.** The object returned by the scheduling methods is generated for each project, so the generator has to add `withRetryPolicy` to it. That object also has one property per future call class, so a future call class whose property would be named `withRetryPolicy` has to be reported as a name clash.

### A policy is a class that returns the next delay

```dart
abstract class FutureCallRetryPolicy {
  /// Returns the delay before the next retry, or null to stop retrying.
  Duration? nextDelay(FutureCallRetryContext context);

  Map<String, dynamic> toJson();
}
```

**Why:**

- **Returning a delay** lets Serverpod do the waiting by rescheduling. A policy that only answered "retry or not" would have to wait inside the policy, in memory.
- **A class, not a fixed set of options,** lets developers add their own strategies without changes to Serverpod.
- **The context carries the error,** so a policy can decide based on what went wrong. It is the same `FutureCallRetryContext` that `shouldRetry` receives, so there is one description of a failure.
- **The policy is saved again after each failed attempt.** A strategy that needs to remember something between attempts keeps it in its own fields. The future call table needs no strategy-specific columns.

### What is stored with the future call

The future call entry gets two additions: the serialized policy, and the number of failed attempts. Existing entries have no policy and zero failures, which is today's behaviour. This needs a database migration.

### Policy classes are registered by `serverpod generate`

To save and load a policy, Serverpod's generated protocol has to know the class. `serverpod generate` finds every concrete class in the server project that extends `FutureCallRetryPolicy` and registers it for the server only.

**Why:**

- **No configuration step.** Without this, each policy would have to be listed in `generator.yaml` by hand, and forgetting to do so would only fail at runtime.
- **Server only.** Classes listed under today's `extraClasses` are also generated into the client. Retry policies depend on the server package, so they must not reach the client.
- **Checked at generation time.** Dart can't require a constructor through a base class. The generator therefore checks each policy class and fails with an error if it can't be loaded later. A class with an error is left out, so the generated code still compiles.

Built-in policies are registered the same way inside Serverpod and need no setup in projects. They are `final`, because a subclass that isn't registered would be saved as the built-in and silently lose its own behaviour.

### Policies from plain Dart packages are not supported out of the box

`serverpod generate` only looks at the package it is run in, so it finds policies in the server project and in Serverpod modules, but not in a plain Dart package that the server depends on.

**Why:** supporting them would need a way to list server-only classes in `generator.yaml`. Listing them under today's `extraClasses` is not an option, because those classes are also generated into the client. Adding a new setting for this one case is left out of the proposal.

A developer who wants to reuse a policy from such a package can declare a class in the server project that extends or wraps it. That class is then registered like any other policy in the project.

### The error filter is separate from the policy

Which errors can be retried depends on the call's code. How long to wait depends on the policy. Keeping `shouldRetry` on the future call class lets one built-in policy be reused across calls that have different retryable errors.

`shouldRetry` receives the failed attempt's session and a `FutureCallRetryContext`, not just the error.

**Why:**

- **A context object can grow.** Developers override `shouldRetry`, so adding a parameter later would break their code. Adding a field to the context object does not.
- **The session gives access to stored data.** A filter can look something up, or record something, before deciding. For that reason the decision is made before the failed attempt's session is closed.

### The policy is chosen when scheduling

Putting the policy on the scheduled call, with no class-level default, means the stored entry fully describes how the call will retry, and a deploy does not change the behaviour of calls already pending.

## Open questions

- **Unlimited retries:** the chained example relies on a `FixedDelayRetryPolicy` without `maxAttempts`, so `maxAttempts` is optional here and leaving it out means the policy never stops by itself. Is that the intended meaning, and should a policy without a limit be allowed outside a chain? A call that can never succeed would then be retried until someone cancels it.
- **Automatic registration:** is finding policy classes automatically the right direction? So far every extra class has been listed explicitly in `generator.yaml`, and the review feedback leans toward keeping it that way. Requiring explicit listing would need a way to list server-only classes, plus an error for policies that aren't listed.
- **Custom policies in a chain:** can `ChainedRetryPolicies` hold custom policies as well as built-in ones? Saving a chain means saving each policy in it together with its class. It needs confirming that a chain, which is defined in Serverpod, can load policy classes that are defined in a project.
