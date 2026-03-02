---
name: serverpod-testing
description: Test Serverpod endpoints and business logic — withServerpod, sessionBuilder, authentication, DB seeding, rollback, streams, running tests. Use when writing server tests or working with serverpod_test.
---

# Serverpod Testing

Generated test tools let you call endpoints in tests with full server context (DB, caching, etc.). Import the **generated** test tools file, not `serverpod_test` directly — it re-exports everything needed.

## Basic test

```dart
import 'package:test/test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Greeting endpoint', (sessionBuilder, endpoints) {
    test('when calling hello then returns greeting', () async {
      final greeting = await endpoints.greeting.hello(sessionBuilder, 'Bob');
      expect(greeting.message, 'Hello Bob');
    });
  });
}
```

Start DB before running: `docker compose up -d`, then `dart test`.

## Session builder

Use `sessionBuilder.copyWith(...)` to create modified sessions. Call `sessionBuilder.build()` to get a `Session` for DB operations or passing to helpers.

### Authenticated tests

```dart
withServerpod('Given AuthEndpoint', (sessionBuilder, endpoints) {
  final userId = '550e8400-e29b-41d4-a716-446655440000';

  group('when authenticated', () {
    var authed = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(userId, {Scope('user')}),
    );

    test('then hello succeeds', () async {
      final greeting = await endpoints.authExample.hello(authed, 'Michael');
      expect(greeting, 'Hello, Michael!');
    });
  });

  group('when unauthenticated', () {
    var unauthed = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    test('then hello throws', () async {
      await expectLater(
        endpoints.authExample.hello(unauthed, 'Michael'),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
});
```

### Seeding the database

```dart
withServerpod('Given Products endpoint', (sessionBuilder, endpoints) {
  var session = sessionBuilder.build();

  setUp(() async {
    await Product.db.insert(session, [
      Product(name: 'Apple', price: 10),
      Product(name: 'Banana', price: 10),
    ]);
  });

  test('then all returns both products', () async {
    final products = await endpoints.products.all(sessionBuilder);
    expect(products, hasLength(2));
  });
});
```

No manual tearDown needed — by default each test runs in a transaction that is rolled back.

## Rollback behavior

Default: `RollbackDatabase.afterEach` — each test in a rolled-back transaction.

- `afterAll` — roll back after all tests in the group. Useful for scenario tests where consecutive tests depend on each other and setup is expensive.
- `disabled` — no automatic rollback. Required when endpoint code uses concurrent `session.db.transaction(...)` calls (nested transactions would throw `InvalidConfigurationException`). Clean up manually in `tearDownAll`; consider `--concurrency=1`.

```dart
withServerpod(
  'Given concurrent transactions',
  (sessionBuilder, endpoints) {
    tearDownAll(() async {
      var session = sessionBuilder.build();
      await Product.db.deleteWhere(session, where: (_) => Constant.bool(true));
    });

    test('then should commit all', () async {
      await endpoints.products.concurrentTransactionCalls(sessionBuilder);
    });
  },
  rollbackDatabase: RollbackDatabase.disabled,
);
```

## Testing business logic with Session

If logic lives outside endpoints but needs a `Session`, use `withServerpod` and ignore the endpoints parameter:

```dart
withServerpod('Given product quantity is zero', (sessionBuilder, _) {
  var session = sessionBuilder.build();

  setUp(() async {
    await Product.db.insertRow(session, Product(id: 123, name: 'Apple', quantity: 0));
  });

  test('then decreasing throws', () async {
    await expectLater(
      ProductsBusinessLogic.updateQuantity(session, id: 123, decrease: 1),
      throwsA(isA<InvalidOperationException>()),
    );
  });
});
```

## Testing streams

Use `flushEventQueue()` to ensure a generator executes up to its `yield` before asserting:

```dart
withServerpod('Given shared stream', (sessionBuilder, endpoints) {
  final user1 = sessionBuilder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo('user-1', {}));
  final user2 = sessionBuilder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo('user-2', {}));

  test('when posting numbers then listener receives them', () async {
    var stream = endpoints.comm.listenForNumbers(user1);
    await flushEventQueue(); // Wait for stream to register

    await endpoints.comm.postNumber(user2, 111);
    await endpoints.comm.postNumber(user2, 222);

    await expectLater(stream.take(2), emitsInOrder([111, 222]));
  });
});
```

## withServerpod options

| Option | Default | Description |
| ------ | ------- | ----------- |
| `applyMigrations` | `true` | Apply pending migrations on start |
| `enableSessionLogging` | `false` | Enable session logging |
| `rollbackDatabase` | `afterEach` | When to rollback (afterEach, afterAll, disabled) |
| `runMode` | `ServerpodRunMode.test` | Run mode (test, development, etc.) |
| `serverpodLoggingMode` | `normal` | Logging mode |
| `serverpodStartTimeout` | `30s` | Timeout for Serverpod startup |
| `testGroupTagsOverride` | `['integration']` | Tags for the test group |

## Running tests

```bash
docker compose up -d          # Start DB and Redis
dart test                     # All tests
dart test -t integration      # Only integration tests
dart test -x integration      # Only unit tests
dart test -t integration --concurrency=1  # Sequential (for rollback disabled)
```

## Test exceptions

Exported from generated test tools:

- `ServerpodUnauthenticatedException` — endpoint called without auth
- `ServerpodInsufficientAccessException` — auth key lacks required scope
- `ConnectionClosedException` — stream connection closed with error
- `InvalidConfigurationException` — invalid config (e.g. nested transactions with rollback enabled)

## DB connection limits

Each `withServerpod` lazily creates a Serverpod instance on first `sessionBuilder.build()`. With many concurrent tests, DB connections can exceed limits. Fix: raise the DB limit, or defer `build()` to `setUpAll`:

```dart
withServerpod('Given example', (sessionBuilder, endpoints) {
  late Session session;
  setUpAll(() { session = sessionBuilder.build(); });
  // ...
});
```

## Project structure

Keep tests organized:

- `test/unit/` — unit tests (no Serverpod dependency)
- `test/integration/` — tests using `withServerpod`

Always call endpoints via the `endpoints` parameter, not by instantiating endpoint classes directly — the test tools handle lifecycle and validation to match production behavior.
