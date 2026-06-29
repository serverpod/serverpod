import 'dart:io';

import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod/serverpod.dart';
// ignore: implementation_imports
import 'package:serverpod/src/server/serverpod.dart'
    show ServerpodInternalMethods;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_database/embedded.dart'
    show startOrAttachEmbeddedPostgres;
import 'package:serverpod_shared/serverpod_shared.dart' show PasswordManager;
import 'package:serverpod_test/serverpod_test.dart' show TestDatabaseManager;
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

var _integrationTestMode =
    Platform.environment['INTEGRATION_TEST_SERVERPOD_MODE'] ?? 'production';

var _integrationTestFlags = ['-m', _integrationTestMode];

class IntegrationTestServer extends TestServerpod {
  IntegrationTestServer({
    ServerpodConfig? config,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) : super(
         _integrationTestFlags,
         Protocol(),
         Endpoints(),
         config: config,
         runtimeParametersBuilder: runtimeParametersBuilder,
       );

  /// The database owned by this suite's runner isolate. Pass it to a child
  /// isolate (in its spawn message) and have that isolate call
  /// [attachToDatabase] before constructing its own server, so the two share
  /// one database. See [_IsolateTestDatabase].
  static String get databaseName => _IsolateTestDatabase.name;

  /// Binds this (child) isolate to a database owned by another isolate - the
  /// suite's runner, identified by [databaseName] - instead of creating its
  /// own, so isolates within a suite can share one database. The runner owns
  /// the lifecycle; an attached isolate never creates, migrates, or drops it.
  /// Call before constructing any [IntegrationTestServer] in this isolate.
  static void attachToDatabase(String databaseName) =>
      _IsolateTestDatabase.attachTo(databaseName);

  static Serverpod create({
    ServerpodConfig? config,
    AuthenticationHandler? authenticationHandler,
    SecurityContextConfig? securityContextConfig,
    ExperimentalFeatures? experimentalFeatures,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) {
    final server = Serverpod(
      _integrationTestFlags,
      Protocol(),
      Endpoints(),
      config: config,
      authenticationHandler:
          authenticationHandler ?? auth.authenticationHandler,
      securityContextConfig: securityContextConfig,
      experimentalFeatures: experimentalFeatures,
      runtimeParametersBuilder: runtimeParametersBuilder,
    );

    // Runtime settings persist in the serverpod_runtime_settings table
    // across tests in the same run. Without a reset, a test that calls
    // `server.updateRuntimeSettings(LogSettingsBuilder().withLoggingTurnedDown()...)`
    // leaves logLevel=fatal for every subsequent test, silently filtering
    // all log.warning / log.error output and breaking assertions in
    // unrelated tests (future_call_manager, broken_future_calls, ...).
    //
    // Register a reset hook so each test leaves a clean slate. addTearDown
    // is registered after the enclosing group's `tearDown(...)` block, so
    // it runs earlier in LIFO order - i.e. before the caller's explicit
    // `server.shutdown(...)` - while the session/pool are still live.
    //
    // If `create` is called at group-declaration time rather than inside
    // a test/setUp, `addTearDown` throws and there's no test-scoped place
    // to hang cleanup. Swallow that case: those tests don't touch
    // runtime settings themselves (websockets/*), so nothing pollutes.
    try {
      addTearDown(() async {
        try {
          await server.internalSession.db.unsafeExecute(
            'DELETE FROM serverpod_runtime_settings',
          );
        } catch (_) {
          // Server or pool may already be gone; nothing to clean up.
        }
      });
    } on StateError {
      // Called outside a running test (group declaration time). Skip.
    }

    return server;
  }
}

class TestServerpod {
  static final Finalizer<Session> _sessionFinalizer = Finalizer(
    (session) async => await session.close(),
  );

  late final Serverpod _serverpod;

  late final Session _session;

  TestServerpod(
    List<String> args,
    DatabaseSerializationManager serializationManager,
    EndpointDispatch endpoints, {
    ServerpodConfig? config,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) {
    _serverpod = Serverpod(
      args,
      serializationManager,
      endpoints,
      config: config,
      authenticationHandler: auth.authenticationHandler,
      runtimeParametersBuilder: runtimeParametersBuilder,
      configOverride: _useIsolateDatabase,
    );
  }

  Future<void> updateRuntimeSettings(serverpod.RuntimeSettings settings) async {
    await _serverpod.updateRuntimeSettings(settings);
  }

  Future<Session> session() async {
    await _IsolateTestDatabase.ensureReady(
      runMode: _serverpod.runMode,
      serverDirectory: _serverpod.serverDirectory.path,
      migrate: _migrateIsolateDatabase,
    );
    _session = await _serverpod.createSession();
    _sessionFinalizer.attach(this, _session, detach: this);
    return _session;
  }

  /// Applies migrations to this isolate's freshly-created database, using a
  /// session that connects to it ([_serverpod] is pointed at it via
  /// [_useIsolateDatabase]). Runs once per isolate, driven by
  /// [_IsolateTestDatabase.ensureReady].
  Future<void> _migrateIsolateDatabase() async {
    final session = await _serverpod.createSession();
    try {
      await applyMigrationsAndVerify(
        session: session,
        projectDirectory: _serverpod.serverDirectory,
        runMode: _serverpod.runMode,
        applyMigrations: true,
        applyRepairMigration: false,
      );
    } finally {
      await session.close();
    }
  }
}

/// Points a test server at this isolate's own database (see
/// [_IsolateTestDatabase]) so test files run concurrently without sharing
/// committed state. PostgreSQL only; other configs (e.g. SQLite) are left
/// untouched.
ServerpodConfig _useIsolateDatabase(ServerpodConfig config) {
  final database = config.database;
  if (database is! PostgresDatabaseConfig) return config;
  return config.copyWith(
    database: database.withName(_IsolateTestDatabase.name),
  );
}

/// The PostgreSQL database backing the integration tests in this isolate.
///
/// `dart test` runs each test suite (file) in its own isolate sharing one OS
/// process, and statics are per-isolate - so each suite's runner isolate gets
/// a private database on the shared embedded postmaster. Suites therefore run
/// concurrently without colliding on each other's committed data, which is
/// what previously forced these suites to run serially (the `concurrency_one`
/// tag).
///
/// The runner isolate that generates [name] owns the database: it creates and
/// migrates it. A child isolate the suite spawns can instead [attachTo] the
/// runner's database (passing [name] across in the spawn message) to share the
/// same data; an attached isolate never creates, migrates, or drops it.
///
/// The database is created lazily on first use and intentionally not dropped:
/// it lives on the shared postmaster for the process's lifetime and is
/// reclaimed when the test data directory is cleared between runs. Per-database
/// teardown (by the owning isolate) is a later refinement.
class _IsolateTestDatabase {
  static String? _name;
  static bool _owns = true;

  /// This isolate's database. The owner generates it once on first use; an
  /// isolate that called [attachTo] uses the database it was given.
  static String get name =>
      _name ??= TestDatabaseManager.generateDatabaseName();

  /// Binds this isolate to an existing database created by another isolate
  /// (the suite's runner), so isolates within a suite can share one database.
  /// The owner creates, migrates, and (eventually) drops it; this isolate only
  /// reads and writes. Call before [name] is first read - i.e. before
  /// constructing any server in this isolate.
  static void attachTo(String databaseName) {
    _name = databaseName;
    _owns = false;
  }

  static Future<void>? _ready;

  /// Creates and migrates [name] exactly once for the owning isolate. An
  /// attached isolate ([attachTo]) skips this - the owner already created and
  /// migrated the database. [migrate] applies migrations against a session
  /// connected to [name].
  static Future<void> ensureReady({
    required String runMode,
    required String serverDirectory,
    required Future<void> Function() migrate,
  }) {
    if (!_owns) return Future<void>.value();
    return _ready ??= _provision(
      runMode: runMode,
      serverDirectory: serverDirectory,
      migrate: migrate,
    );
  }

  static Future<void> _provision({
    required String runMode,
    required String serverDirectory,
    required Future<void> Function() migrate,
  }) async {
    final database = _resolveProjectDatabaseConfig(
      runMode: runMode,
      serverDirectory: serverDirectory,
    );
    // Only PostgreSQL is provisioned per isolate; other configs (e.g. SQLite)
    // keep their previous shared behaviour.
    if (database is! PostgresDatabaseConfig) return;

    // Resolve the shared postmaster's coordinates against the *project*
    // database (launching it on first use), then create this isolate's own
    // database on it. The launched postmaster is intentionally left running -
    // it is shared by every isolate and reclaimed when the process exits.
    final resolved = await startOrAttachEmbeddedPostgres(
      database,
      baseDirectory: Directory(serverDirectory),
    );
    final connectivity = resolved?.connectivity ?? database;

    await TestDatabaseManager(connectivity).createEmptyDatabase(name);
    await migrate();
  }

  /// Loads the project's database config (run mode, passwords, environment) the
  /// way the server would, but without the per-isolate name swap - so the
  /// shared postmaster is launched against the project database, not this
  /// isolate's.
  static DatabaseConfig? _resolveProjectDatabaseConfig({
    required String runMode,
    required String serverDirectory,
  }) {
    final passwords = PasswordManager(
      runMode: runMode,
    ).loadPasswords(serverDir: serverDirectory);
    final config = ServerpodConfig.load(
      runMode,
      null,
      passwords,
      serverDir: serverDirectory,
    );
    return config.database;
  }
}
