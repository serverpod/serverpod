import 'dart:io';

import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod/serverpod.dart';
// ignore: implementation_imports
import 'package:serverpod/src/server/serverpod.dart'
    show ServerpodInternalMethods;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_test/serverpod_test.dart'
    show EphemeralTestDatabase, TestDatabaseManager;
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/redis_probe.dart';
import 'package:test/test.dart';

var _integrationTestMode =
    Platform.environment['INTEGRATION_TEST_SERVERPOD_MODE'] ?? 'production';

var _integrationTestFlags = ['-m', _integrationTestMode];

class IntegrationTestServer extends TestServerpod {
  IntegrationTestServer({
    ServerpodConfig? config,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
    bool withRedis = false,
  }) : super(
         _integrationTestFlags,
         Protocol(),
         Endpoints(),
         config: config,
         runtimeParametersBuilder: runtimeParametersBuilder,
         withRedis: withRedis,
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
    int? apiPort,
    bool withRedis = false,
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
      configOverride: (config) => _isolatedTestConfig(
        config,
        apiPort: apiPort,
        withRedis: withRedis,
      ),
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

/// Instance-style test helpers for servers built by
/// [IntegrationTestServer.create]. URLs address the server by its BOUND port
/// ([Server.port]), so they work with an ephemeral (0) configured port.
extension IntegrationTestServerExtension on Serverpod {
  /// Starts this server for an integration test, first provisioning the
  /// suite's own database (created + migrated) so the per-suite-named,
  /// ephemeral-port server that [IntegrationTestServer.create] configures can
  /// connect to it.
  Future<void> startWithDatabase() async {
    await ensureDatabase();
    await start();
  }

  /// Provisions this suite's database (create + migrate) without starting the
  /// server - for tests that need a manual `start(...)` with options
  /// [startWithDatabase] does not forward (e.g. `runInGuardedZone: false`).
  /// Idempotent per isolate.
  Future<void> ensureDatabase() async {
    // Only a server pointed at the embedded per-suite database needs
    // provisioning. A server with no database, or one deliberately pointed at
    // an unreachable host (the diagnostics "missing database" suite), is left
    // alone so its own start() exercises the real connection path.
    final database = config.database;
    if (database is! PostgresDatabaseConfig || database.dataPath == null) {
      return;
    }
    await _IsolateTestDatabase.ensureReady(
      runMode: runMode,
      serverDirectory: serverDirectory.path,
      migrate: _migrateDatabase,
    );
  }

  /// Applies migrations to this suite's freshly-created database using a
  /// session from this server (pointed at it via [_isolatedTestConfig]). Runs
  /// once per isolate, via [_IsolateTestDatabase.ensureReady].
  Future<void> _migrateDatabase() async {
    final session = await createSession();
    try {
      await applyMigrationsAndVerify(
        session: session,
        projectDirectory: serverDirectory,
        runMode: runMode,
        applyMigrations: true,
        applyRepairMigration: false,
      );
    } finally {
      await session.close();
    }
  }

  /// `http://localhost:<bound api port>/`.
  String get apiUrl => 'http://localhost:${server.port}/';

  /// `http://localhost:<bound web-server port>/`.
  String get webUrl => 'http://localhost:${webServer.port}/';

  /// `ws://localhost:<bound api port>/websocket` (endpoint streaming).
  String get endpointWebSocketUrl => 'ws://localhost:${server.port}/websocket';

  /// `ws://localhost:<bound api port>/v1/websocket` (method streaming).
  String get methodWebSocketUrl => 'ws://localhost:${server.port}/v1/websocket';
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
    bool withRedis = false,
  }) {
    _serverpod = Serverpod(
      args,
      serializationManager,
      endpoints,
      config: config,
      authenticationHandler: auth.authenticationHandler,
      runtimeParametersBuilder: runtimeParametersBuilder,
      configOverride: (config) => withRedis
          ? _useIsolateDatabase(config).copyWith(redis: redisTestConfig())
          : _useIsolateDatabase(config),
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

/// The embedded PostgreSQL data path the run points at, from
/// `ServerpodEnv.databaseDataPath` (set by the integration run script). Empty
/// or unset means a non-embedded run (e.g. an external server).
final String _embeddedDataPath = () {
  final path = Platform.environment['SERVERPOD_DATABASE_DATA_PATH']?.trim();
  return (path == null || path.isEmpty) ? '.serverpod/test/pgdata' : path;
}();

/// Returns [database] targeting this isolate's per-suite database on the shared
/// embedded postmaster.
///
/// A config loaded from disk already carries the embedded `dataPath`; one built
/// in-Dart (as several suites do, to set custom logging/future-call/etc.
/// options) with the Docker-era 'postgres' host does not, so the pool would
/// fail to resolve that host. Inject the run's `dataPath` so those configs
/// launch/attach the managed postmaster instead. A config on another host (e.g.
/// the diagnostics "missing database" suite's `localhost`) is left untouched so
/// its connection still fails as intended.
PostgresDatabaseConfig _embeddedDatabase(PostgresDatabaseConfig database) {
  final named = database.withName(_IsolateTestDatabase.name);
  if (named.dataPath != null || named.host != 'postgres') {
    return named;
  }
  return PostgresDatabaseConfig(
    host: named.host,
    port: named.port,
    user: named.user,
    password: named.password,
    name: named.name,
    requireSsl: named.requireSsl,
    isUnixSocket: named.isUnixSocket,
    searchPaths: named.searchPaths,
    maxConnectionCount: named.maxConnectionCount,
    dataPath: _embeddedDataPath,
  );
}

/// Points a test server at this isolate's own database (see
/// [_IsolateTestDatabase]) so test files run concurrently without sharing
/// committed state. PostgreSQL only; other configs (e.g. SQLite) are left
/// untouched.
ServerpodConfig _useIsolateDatabase(ServerpodConfig config) {
  final database = config.database;
  if (database is! PostgresDatabaseConfig) return config;
  return config.copyWith(
    database: _embeddedDatabase(database),
  );
}

/// Names a per-isolate database (like [_useIsolateDatabase]) and binds every
/// user-facing server to an ephemeral port (0), so servers that bind sockets do
/// not collide on a fixed port. Tests read the bound port via
/// [IntegrationTestServerExtension.apiUrl] etc.
ServerpodConfig _isolatedTestConfig(
  ServerpodConfig config, {
  int? apiPort,
  bool withRedis = false,
}) {
  final database = config.database;
  final insightsServer = config.insightsServer;
  final webServer = config.webServer;
  return config.copyWith(
    // [apiPort] lets a suite opt out of an ephemeral API port when it needs a
    // stable address across a restart (see reconnect_to_server_test). Pick one
    // below the OS ephemeral range so it can't collide with the port-0 suites.
    apiServer: _boundTo(config.apiServer, port: apiPort ?? 0),
    insightsServer: insightsServer == null ? null : _boundTo(insightsServer),
    webServer: webServer == null ? null : _boundTo(webServer),
    database: database is PostgresDatabaseConfig
        ? _embeddedDatabase(database)
        : database,
    redis: withRedis ? redisTestConfig() : null,
  );
}

/// A copy of [config] bound to [port] (default 0 = an OS-assigned ephemeral
/// port).
ServerConfig _boundTo(ServerConfig config, {int port = 0}) => ServerConfig(
  port: port,
  publicScheme: config.publicScheme,
  publicHost: config.publicHost,
  publicPort: config.publicPort,
);

/// A port that stays stable across server restarts within this test run yet
/// is unique per run, so concurrent runs don't collide.
///
/// Hashed from the [pid] into 20000-29999 (below every platform's OS
/// ephemeral range that the port-0 suites draw from).
///
/// Suites needing more than one stable port pass distinct [offset]s
int stableTestPort([int offset = 0]) => 20000 + (pid + offset * 101) % 10000;

/// The PostgreSQL database backing this isolate's integration tests.
///
/// `dart test` runs each test suite (file) in its own isolate, and statics are
/// per-isolate, so each suite's runner isolate gets a private database on the
/// shared embedded postmaster. Suites therefore run concurrently without
/// colliding on each other's committed data.
///
/// Creation itself is delegated to [EphemeralTestDatabase] (same path as
/// `withServerpod`); this type only owns the isolate lifecycle: generate
/// [name], [attachTo] for child isolates, lazy [ensureReady] + migrate, and
/// never drop (reclaimed when the data directory is cleared between runs).
///
/// The runner isolate that generates [name] owns the database: it creates and
/// migrates it. A child isolate the suite spawns can [attachTo] the runner's
/// database (passing [name] in the spawn message) to share the same data; an
/// attached isolate never creates or migrates it.
class _IsolateTestDatabase {
  static String? _name;
  static bool _owns = true;

  /// This isolate's database. The owner generates it once on first use; an
  /// isolate that called [attachTo] uses the database it was given.
  static String get name =>
      _name ??= TestDatabaseManager.generateDatabaseName();

  /// Binds this isolate to a database owned by another isolate (the suite's
  /// runner), so isolates within a suite share one database. The owner creates
  /// and migrates it; this isolate only reads and writes. Call before [name] is
  /// first read - before constructing any server in this isolate.
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
    // Only reached for embedded PostgreSQL (see [ensureDatabase]). Null means
    // no database to provision; the postmaster is left running for the process.
    final created = await EphemeralTestDatabase.create(
      runMode: runMode,
      databaseName: name,
      serverDirectory: Directory(serverDirectory),
    );
    if (created == null) return;
    await migrate();
  }
}
