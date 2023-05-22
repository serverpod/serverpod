import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cloud_storage/public_endpoint.dart';
import 'package:serverpod/src/config/version.dart';
import 'package:serverpod/src/database/migration_manager.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod/src/server/cluster_manager.dart';
import 'package:serverpod/src/server/future_call_manager.dart';
import 'package:serverpod/src/server/health_check_manager.dart';
import 'package:serverpod/src/server/log_manager.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../authentication/default_authentication_handler.dart';
import '../authentication/service_authentication.dart';
import '../cache/caches.dart';
import '../generated/endpoints.dart' as internal;
import '../generated/protocol.dart' as internal;

/// Performs a set of custom health checks on a [Serverpod].
typedef HealthCheckHandler = Future<List<internal.ServerHealthMetric>> Function(
  Serverpod pod,
  DateTime timestamp,
);

/// The [Serverpod] handles all setup and manages the main [Server]. In addition
/// to the user managed server, it also runs a server for handling the
/// [DistributedCache] and other connections through the [InsightsEndpoint].
class Serverpod {
  static Serverpod? _instance;

  DateTime? _startedTime;

  /// The time the [Serverpod] was started.
  DateTime get startedTime {
    assert(_startedTime != null, 'Server has not been started');
    return _startedTime!;
  }

  /// The last created [Serverpod]. In most cases the [Serverpod] is a singleton
  /// object, although it may be possible to run multiple instances in the same
  /// program it's not recommended.
  static Serverpod? get instance => _instance;

  late String _runMode;

  /// The servers run mode as specified in [ServerpodRunMode].
  String get runMode => _runMode;

  /// The parsed runtime arguments passed to Serverpod at startup.
  late final CommandLineArgs commandLineArgs;

  /// The server configuration, as read from the config/ directory.
  late ServerpodConfig config;
  Map<String, String> _passwords = <String, String>{};

  /// Custom [AuthenticationHandler] used to authenticate users.
  final AuthenticationHandler? authenticationHandler;

  /// [HealthCheckHandler] for any custom health checks. This can be used to
  /// check remotely if all services the server is depending on is up and
  /// running.
  final HealthCheckHandler? healthCheckHandler;

  /// [SerializationManager] used to serialize [SerializableEntities], both
  /// when sending data to a method in an [Endpoint], but also for caching, and
  /// [FutureCall]s.
  final SerializationManagerServer serializationManager;
  late SerializationManagerServer _internalSerializationManager;

  /// Definition of endpoints used by the server. This is typically generated.
  final EndpointDispatch endpoints;

  /// The database configuration.
  late DatabasePoolManager databaseConfig;

  late Caches _caches;

  /// The Redis controller used by Serverpod.
  RedisController? redisController;

  /// Caches used by the server.
  Caches get caches => _caches;

  /// The id of this [Serverpod].
  String serverId = 'default';

  /// The main server managed by this [Serverpod].
  late Server server;

  Server? _serviceServer;

  /// The service server managed by this [Serverpod].
  Server get serviceServer => _serviceServer!;

  internal.RuntimeSettings? _runtimeSettings;

  /// The web server managed by this [Serverpod].
  late WebServer webServer;

  /// Serverpod runtime settings as read from the database.
  internal.RuntimeSettings get runtimeSettings => _runtimeSettings!;

  /// Updates the runtime settings and writes the new settings to the database.
  Future<void> updateRuntimeSettings(internal.RuntimeSettings settings) async {
    _runtimeSettings = settings;
    _logManager = LogManager(settings);
    await _storeRuntimeSettings(settings);
  }

  late LogManager _logManager;

  /// The [LogManager] of the Serverpod, its typically only used internally
  /// by the Serverpod. Instead of using this object directly, call the log
  /// method on the current [Session].
  LogManager get logManager => _logManager;

  late final FutureCallManager _futureCallManager;

  /// Cloud storages used by the serverpod. By default two storages are set up,
  /// `public` and `private`. The default storages are using the database,
  /// which may not be ideal for larger scale applications. Consider replacing
  /// the storages with another service such as Google Cloud or Amazon S3,
  /// especially in production environments.
  final storage = <String, CloudStorage>{
    'public': DatabaseCloudStorage('public'),
    'private': DatabaseCloudStorage('private'),
  };

  /// Adds a [CloudStorage] to the Serverpod. You can use this method to
  /// override the default [DatabaseCloudStorage] to use S3 or Google Cloud
  /// Storage. E.g. see the serverpod_cloud_storage_s3 pub package.
  void addCloudStorage(CloudStorage cloudStorage) {
    storage[cloudStorage.storageId] = cloudStorage;
  }

  internal.RuntimeSettings get _defaultRuntimeSettings {
    return internal.RuntimeSettings(
      logSettings: internal.LogSettings(
        logAllSessions: false,
        logAllQueries: false,
        logSlowSessions: true,
        logSlowQueries: true,
        logFailedSessions: true,
        logFailedQueries: true,
        logStreamingSessionsContinuously: true,
        logLevel: internal.LogLevel.info,
        slowSessionDuration: 1.0,
        slowQueryDuration: 1.0,
      ),
      logMalformedCalls: false,
      logServiceCalls: false,
      logSettingsOverrides: [],
    );
  }

  Future<void> _storeRuntimeSettings(internal.RuntimeSettings settings) async {
    var session = await createSession(enableLogging: false);
    try {
      var oldRuntimeSettings =
          await session.db.findSingleRow<internal.RuntimeSettings>();
      if (oldRuntimeSettings == null) {
        settings.id = null;
        await session.db.insert(settings);
      }

      settings.id = oldRuntimeSettings!.id;
      await session.db.update(settings);
    } catch (e, stackTrace) {
      await session.close(error: e, stackTrace: stackTrace);
      return;
    }
    await session.close();
  }

  /// Reloads the runtime settings from the database.
  Future<void> reloadRuntimeSettings() async {
    var session = await createSession(enableLogging: false);
    try {
      var settings = await session.db.findSingleRow<internal.RuntimeSettings>();
      if (settings != null) {
        _runtimeSettings = settings;
        _logManager = LogManager(settings);
      }
      await session.close();
    } catch (e, stackTrace) {
      await session.close(error: e, stackTrace: stackTrace);
      return;
    }
  }

  /// Currently not used.
  List<String>? whitelistedExternalCalls;

  late final HealthCheckManager _healthCheckManager;

  /// The [ClusterManager] provides information about other servers in the same
  /// server cluster. This method isn't valid until the Serverpod has been
  /// started.
  late final ClusterManager cluster;

  /// Creates a new Serverpod.
  Serverpod(
    List<String> args,
    this.serializationManager,
    this.endpoints, {
    this.authenticationHandler,
    this.healthCheckHandler,
  }) {
    _internalSerializationManager = internal.Protocol();

    // Create a temporary log manager with default settings, until we have
    // loaded settings from the database.
    _logManager = LogManager(_defaultRuntimeSettings);

    // Read command line arguments.
    commandLineArgs = CommandLineArgs(args);
    _runMode = commandLineArgs.runMode;
    serverId = commandLineArgs.serverId;

    // Load passwords
    _passwords = PasswordManager(runMode: runMode).loadPasswords() ?? {};

    if (_passwords.isEmpty) {
      stderr.writeln('Failed to load passwords. Serverpod cannot not start.');
      exit(1);
    }

    // Load config
    config = ServerpodConfig(_runMode, serverId, _passwords);

    // Setup database
    databaseConfig = DatabasePoolManager(
      serializationManager,
      config.database,
    );

    // Setup Redis
    if (config.redis.enabled) {
      redisController = RedisController(
        host: config.redis.host,
        port: config.redis.port,
        user: config.redis.user,
        password: config.redis.password,
      );
    }

    _caches = Caches(serializationManager, config, serverId, redisController);

    server = Server(
      serverpod: this,
      serverId: serverId,
      port: config.apiServer.port,
      serializationManager: serializationManager,
      databaseConfig: databaseConfig,
      passwords: _passwords,
      runMode: _runMode,
      caches: caches,
      authenticationHandler:
          authenticationHandler ?? defaultAuthenticationHandler,
      whitelistedExternalCalls: whitelistedExternalCalls,
      endpoints: endpoints,
    );
    endpoints.initializeEndpoints(server);

    // Setup future calls
    _futureCallManager = FutureCallManager(
      server,
      serializationManager,
      _onCompletedFutureCalls,
    );

    _instance = this;

    // Setup health check manager
    _healthCheckManager = HealthCheckManager(
      this,
      _onCompletedHealthChecks,
    );

    // Create web server.
    webServer = WebServer(serverpod: this);

    // Print version and runtime arguments.
    stdout.writeln(
      'SERVERPOD version: $serverpodVersion, dart: ${Platform.version}, time: ${DateTime.now().toUtc()}',
    );
    stdout.writeln(commandLineArgs.toString());
    logVerbose(config.toString());
  }

  /// Starts the Serverpod and all [Server]s that it manages.
  Future<void> start() async {
    _startedTime = DateTime.now().toUtc();

    await runZonedGuarded(() async {
      // Register cloud store endpoint if we're using the database cloud store
      if (storage['public'] is DatabaseCloudStorage ||
          storage['private'] is DatabaseCloudStorage) {
        CloudStoragePublicEndpoint().register(this);
      }

      // Load runtime settings and check connection to the database.
      bool databaseConnectionIsUp = false;
      bool printedDatabaseConnectionError = false;

      while (!databaseConnectionIsUp) {
        var session = await createSession(enableLogging: false);
        try {
          // Initialize migration manager.
          logVerbose('Initializing migration manager.');
          var migrationManager = MigrationManager();
          await migrationManager.initialize(session);

          if (commandLineArgs.applyMigrations) {
            logVerbose('Applying database migrations.');
            await migrationManager.migrateToLatest(session);
          }

          logVerbose('Verifying database integrity.');
          await migrationManager.verifyDatabaseIntegrity(session);

          // We successfully connected to the database.
          databaseConnectionIsUp = true;
        } catch (e, stackTrace) {
          // Write connection error to stderr.
          stderr.writeln(
            'Failed to connect to the database. Retrying in 10 seconds. $e',
          );
          stderr.writeln('$stackTrace');
          if (!printedDatabaseConnectionError) {
            stderr.writeln('Database configuration:');
            stderr.writeln(config.database.toString());
            printedDatabaseConnectionError = true;
          }

          await Future.delayed(const Duration(seconds: 10));
        }

        try {
          logVerbose('Loading runtime settings.');

          _runtimeSettings =
              await session.db.findSingleRow<internal.RuntimeSettings>();
        } catch (e) {
          stderr.writeln(
            'Failed to load runtime settings. $e',
          );
        }
        try {
          if (_runtimeSettings == null) {
            logVerbose(
              'Runtime settings not found, creating default settings.',
            );

            // Store default settings.
            _runtimeSettings = _defaultRuntimeSettings;
            await session.db.insert(_runtimeSettings!);
          } else {
            logVerbose('Runtime settings loaded.');
          }
        } catch (e) {
          stderr.writeln(
            'Failed to store runtime settings. $e',
          );
        }

        await session.close();
      }

      // Setup log manager.
      _logManager = LogManager(_runtimeSettings!);

      // Connect to Redis
      if (redisController != null) {
        logVerbose('Connecting to Redis.');
        await redisController!.start();
      } else {
        logVerbose('Redis is disabled, skipping.');
      }

      // Start servers.
      if (commandLineArgs.role == ServerpodRole.monolith ||
          commandLineArgs.role == ServerpodRole.serverless) {
        // Serverpod Insights.
        await _startServiceServer();

        // Main API server.
        await server.start();

        /// Web server.
        if (webServer.routes.isNotEmpty) {
          logVerbose('Starting web server.');
          await webServer.start();
        } else {
          logVerbose('No routes configured for web server, skipping.');
        }

        logVerbose('All servers started.');
      }

      // Start maintenance tasks. If we are running in maintenance mode, we
      // will only run the maintenance tasks once.
      if (commandLineArgs.role == ServerpodRole.monolith ||
          commandLineArgs.role == ServerpodRole.maintenance) {
        logVerbose('Starting maintenance tasks.');

        // Start future calls
        _futureCallManager.start();

        // Start health check manager
        await _healthCheckManager.start();
      }

      logVerbose('Serverpod start complete.');

      // TODO: Run maintenance tasks once if in maintenance role.
    }, (e, stackTrace) {
      // Last resort error handling
      // TODO: Log to database?
      stderr.writeln(
        '${DateTime.now().toUtc()} Internal server error. Zoned exception.',
      );
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
    });
  }

  bool _completedHealthChecks = false;
  bool _completedFutureCalls = false;

  void _onCompletedHealthChecks() {
    logVerbose('Health checks completed.');
    _completedHealthChecks = true;
    _checkMaintenanceTasksCompletion();
  }

  void _onCompletedFutureCalls() {
    logVerbose('Future calls completed.');
    _completedFutureCalls = true;
    _checkMaintenanceTasksCompletion();
  }

  void _checkMaintenanceTasksCompletion() {
    if (_completedFutureCalls && _completedHealthChecks) {
      stdout.writeln('All maintenance tasks completed. Exiting.');
      exit(0);
    }
  }

  Future<void> _startServiceServer() async {
    // var context = SecurityContext();
    // context.useCertificateChain(sslCertificatePath(_runMode, serverId));
    // context.usePrivateKey(sslPrivateKeyPath(_runMode, serverId));

    var endpoints = internal.Endpoints();

    _serviceServer = Server(
      serverpod: this,
      serverId: serverId,
      port: config.insightsServer.port,
      serializationManager: _internalSerializationManager,
      databaseConfig: databaseConfig,
      passwords: _passwords,
      runMode: _runMode,
      name: 'Insights',
      caches: caches,
      authenticationHandler: serviceAuthenticationHandler,
      // securityContext: context,
      endpoints: endpoints,
    );
    endpoints.initializeEndpoints(_serviceServer!);

    await _serviceServer!.start();

    cluster = ClusterManager(_serviceServer!);
  }

  /// Registers a [FutureCall] with the [Serverpod] and associates it with
  /// the specified name.
  void registerFutureCall(FutureCall call, String name) {
    _futureCallManager.registerFutureCall(call, name);
  }

  /// Calls a [FutureCall] by its name after the specified delay, optionally
  /// passing a [SerializableEntity] object as parameter.
  Future<void> futureCallWithDelay(
    String callName,
    SerializableEntity? object,
    Duration delay, {
    String? identifier,
  }) async {
    assert(server.running,
        'Server is not running, call start() before using future calls');
    await _futureCallManager.scheduleFutureCall(
      callName,
      object,
      DateTime.now().toUtc().add(delay),
      serverId,
      identifier,
    );
  }

  /// Calls a [FutureCall] by its name at the specified time, optionally passing
  /// a [SerializableEntity] object as parameter.
  Future<void> futureCallAtTime(
    String callName,
    SerializableEntity? object,
    DateTime time, {
    String? identifier,
  }) async {
    assert(server.running,
        'Server is not running, call start() before using future calls');
    await _futureCallManager.scheduleFutureCall(
      callName,
      object,
      time,
      serverId,
      identifier,
    );
  }

  /// Cancels a [FutureCall] with the specified identifier. If no future call
  /// with the specified identifier is found, this call will have no effect.
  Future<void> cancelFutureCall(String identifier) async {
    await _futureCallManager.cancelFutureCall(identifier);
  }

  /// Retrieves a password for the given key. Passwords are loaded from the
  /// config/passwords.yaml file.
  String? getPassword(String key) {
    return _passwords[key];
  }

  /// Creates a new [InternalSession]. Used to access the database and do
  /// logging outside of sessions triggered by external events. If you are
  /// creating a [Session] you are responsible of calling the [close] method
  /// when you are done.
  Future<InternalSession> createSession({bool enableLogging = true}) async {
    var session = InternalSession(
      server: server,
      enableLogging: enableLogging,
    );
    return session;
  }

  /// Shuts down the Serverpod and all associated servers.
  Future<void> shutdown() async {
    if (redisController != null) {
      await redisController!.stop();
    }
    server.shutdown();
    _serviceServer?.shutdown();
    _futureCallManager.stop();
    _healthCheckManager.stop;
    exit(0);
  }

  /// Logs a message to the console if the logging command line argument is set
  /// to verbose.
  void logVerbose(String message) {
    if (commandLineArgs.loggingMode == ServerpodLoggingMode.verbose) {
      stdout.writeln(message);
    }
  }
}
