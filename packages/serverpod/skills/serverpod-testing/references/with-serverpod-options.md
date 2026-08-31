# `withServerpod` options

Reference for the [Serverpod Testing](../SKILL.md) skill. The generated test tools file documents the same options in its doc comments.

| Option | Default | Description |
| ------ | ------- | ----------- |
| `applyMigrations` | `true` | Apply pending migrations on start |
| `configOverride` | - | Override loaded server config for tests |
| `databaseInterceptor` | `null` | Replace the default database for each session |
| `enableSessionLogging` | `false` | Enable session logging |
| `experimentalFeatures` | `null` | Experimental features to enable for the tests |
| `rollbackDatabase` | `afterEach` | When to rollback (afterEach, afterAll, disabled) |
| `runMode` | `ServerpodRunMode.test` | Run mode (test, development, etc.) |
| `runtimeParametersBuilder` | `null` | Override global runtime parameters for the tests |
| `serverDirectory` | `Directory.current` | Directory that `config/` and `migrations/` are resolved against |
| `serverpodLoggingMode` | `normal` | Logging mode |
| `serverpodStartTimeout` | `120s` | Timeout for Serverpod startup |
| `testGroupTagsOverride` | `['integration']` | Tags for the test group |
| `testServerOutputMode` | `normal` | Control stdout/stderr from the test server |

Pass `serverDirectory` when the test isolate's working directory is not the server package root (for example when running tests from a workspace parent directory), so config and migrations are still found.

## DB connection limits

Each `withServerpod` lazily creates a Serverpod instance on first `sessionBuilder.build()`. With many concurrent tests, DB connections can exceed limits. Fix: raise the DB limit, or defer `build()` to `setUpAll`:

```dart
withServerpod('Given example', (sessionBuilder, endpoints) {
  late Session session;
  setUpAll(() { session = sessionBuilder.build(); });
  // ...
});
```
