import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/cloud_storage/public_endpoint.dart';
import 'package:serverpod/src/config/version.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';
import 'package:serverpod/src/database/migrations/migration_manager.dart';
import 'package:serverpod/src/redis/controller.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/features.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_manager.dart';
import 'package:serverpod/src/server/health_check_manager.dart';
import 'package:serverpod/src/server/log_manager/log_manager.dart';
import 'package:serverpod/src/server/log_manager/log_settings.dart';
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

  late Session _internalSession;

  DateTime? _startedTime;

  /// The time the [Serverpod] was started.
  DateTime get startedTime {
    assert(_startedTime != null, 'Server has not been started');
    return _startedTime!;
  }

  /// The last created [Serverpod]. In most cases the [Serverpod] is a singleton
  /// object, although it may be possible to run multiple instances in the same
  /// program it's not recommended.
  static Serverpod get instance {
    if (_instance == null) {
      throw Exception('Serverpod has not been initialized. You need to create '
          'the Serverpod object before calling this method.');
    }
    return _instance!;
  }

  late String _runMode;

  /// The servers run mode as specified in [ServerpodRunMode].
  String get runMode => _runMode;

  /// The parsed runtime arguments passed to Serverpod at startup.
  late final CommandLineArgs commandLineArgs;

  /// The server configuration, as read from the config/ directory.
  late ServerpodConfig config;

  Map<String, String> _passwords = <String, String>{};

  late PasswordManager _passwordManager;

  /// Custom [AuthenticationHandler] used to authenticate users.
  final AuthenticationHandler? authenticationHandler;

  /// [HealthCheckHandler] for any custom health checks. This can be used to
  /// check remotely if all services the server is depending on is up and
  /// running.
  final HealthCheckHandler? healthCheckHandler;

  final ExperimentalApi _experimental;

  /// Access experimental features.
  ///
  /// Note: These features are experimental and may change or be removed
  /// in minor version releases.
  ExperimentalApi get experimental => _experimental;

  /// [SerializationManager] used to serialize [SerializableModel], both
  /// when sending data to a method in an [Endpoint], but also for caching, and
  /// [FutureCall]s.
  final SerializationManagerServer serializationManager;
  late SerializationManagerServer _internalSerializationManager;

  /// Definition of endpoints used by the server. This is typically generated.
  final EndpointDispatch endpoints;

  DatabasePoolManager? _databasePoolManager;

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
  Server get serviceServer {
    var service = _serviceServer;
    if (service == null) {
      throw StateError(
        'Insights server is disabled, supply a Insights configuration '
        'to enable this feature.',
      );
    }

    return service;
  }

  WebServer? _webServer;

  /// The web server managed by this [Serverpod].
  WebServer get webServer {
    var server = _webServer;
    if (server == null) {
      throw StateError(
        'Web server is disabled, supply a web server configuration '
        'to enable this feature.',
      );
    }
    return server;
  }

  late LogManager _logManager;

  /// The [LogManager] of the Serverpod, its typically only used internally
  /// by the Serverpod. Instead of using this object directly, call the log
  /// method on the current [Session].
  LogManager get logManager => _logManager;

  LogSettingsManager? _logSettingsManager;

  FutureCallManager? _futureCallManager;

  /// Cloud storages used by the serverpod. By default two storages are set up,
  /// if the database integration is enabled. The storages are named
  /// `public` and `private`. The default storages are using the database,
  /// which may not be ideal for larger scale applications. Consider replacing
  /// the storages with another service such as Google Cloud or Amazon S3,
  /// especially in production environments.
  final storage = <String, CloudStorage>{};

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

  internal.RuntimeSettings? _runtimeSettings;

  /// Serverpod runtime settings as read from the database.
  internal.RuntimeSettings get runtimeSettings => _runtimeSettings!;

  void _updateLogSettings(internal.RuntimeSettings settings) {
    _runtimeSettings = settings;
    _logSettingsManager = LogSettingsManager(settings);
    _logManager = LogManager(settings, serverId: serverId);
  }

  /// Updates the runtime settings and writes the new settings to the database.
  Future<void> updateRuntimeSettings(internal.RuntimeSettings settings) async {
    _updateLogSettings(settings);
    if (Features.enablePersistentLogging) {
      await _storeRuntimeSettings(settings);
    }
  }

  /// Reloads the runtime settings from the database.
  Future<void> reloadRuntimeSettings() async {
    if (!Features.enablePersistentLogging) {
      throw StateError(
        'Persistent logging is disabled, runtime settings are not stored in '
        'the database.',
      );
    }

    try {
      var settings =
          await internal.RuntimeSettings.db.findFirstRow(internalSession);
      if (settings != null) {
        _updateLogSettings(settings);
      }
    } catch (e, stackTrace) {
      const message = 'Failed to reload runtime settings.';
      _reportException(e, stackTrace, message: message);
      return;
    }
  }

  Future<void> _storeRuntimeSettings(internal.RuntimeSettings settings) async {
    try {
      var oldRuntimeSettings =
          await internal.RuntimeSettings.db.findFirstRow(internalSession);
      if (oldRuntimeSettings == null) {
        settings.id = null;
        settings = await internal.RuntimeSettings.db
            .insertRow(internalSession, settings);
      } else {
        settings.id = oldRuntimeSettings.id;
        await internal.RuntimeSettings.db.updateRow(internalSession, settings);
      }
    } catch (e, stackTrace) {
      _reportException(
        e,
        stackTrace,
        message: 'Failed to store runtime settings',
      );
    }
  }

  /// Currently not used.
  List<String>? whitelistedExternalCalls;

  /// Files that are allowed to be accessed through the [InsightsEndpoint].
  /// File paths are relative to the root directory of the server. Complete
  /// directories (including sub directories) can be whitelisted by adding a
  /// trailing slash.
  Set<String> filesWhitelistedForInsights = {
    'lib/src/generated/protocol.yaml',
  };

  HealthCheckManager? _healthCheckManager;

  /// HTTP headers used by all API responses. Defaults to allowing any
  /// cross origin resource sharing (CORS).
  final Map<String, dynamic> httpResponseHeaders;

  /// HTTP headers used for OPTIONS responses. These headers are sent in
  /// addition to the [httpResponseHeaders] when the request method is OPTIONS.
  final Map<String, dynamic> httpOptionsResponseHeaders;

  static const _defaultHttpResponseHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST',
  };

  static const _defaultHttpOptionsResponseHeaders = {
    'Access-Control-Allow-Headers':
        'Content-Type, Authorization, Accept, User-Agent, X-Requested-With',
  };

  /// Security context if the insights server is running over https.
  final SecurityContextConfig? _securityContextConfig;

  /// Creates a new Serverpod.
  ///
  /// ## Experimental features
  ///
  /// Features marked as experimental are new and
  /// the API and names may change from one minor release to another.
  Serverpod(
    List<String> args,
    this.serializationManager,
    this.endpoints, {
    ServerpodConfig? config,
    this.authenticationHandler,
    this.healthCheckHandler,
    this.httpResponseHeaders = _defaultHttpResponseHeaders,
    this.httpOptionsResponseHeaders = _defaultHttpOptionsResponseHeaders,
    SecurityContextConfig? securityContextConfig,
    ExperimentalFeatures? experimentalFeatures,
  })  : _securityContextConfig = securityContextConfig,
        _experimental = ExperimentalApi._(
          config: config,
          experimentalFeatures: experimentalFeatures,
        ) {
    _initializeServerpod(
      args,
      config: config,
      experimentalFeatures: experimentalFeatures,
    );
  }

  void _initializeServerpod(
    List<String> args, {
    ServerpodConfig? config,
    ExperimentalFeatures? experimentalFeatures,
  }) {
    stdout.writeln(
      'SERVERPOD version: $serverpodVersion, dart: ${Platform.version}, time: ${DateTime.now().toUtc()}',
    );

    // Read command line arguments.
    commandLineArgs = CommandLineArgs(args);
    stdout.writeln(commandLineArgs.toString());

    _runMode = commandLineArgs.runMode;
    // Load passwords
    _passwordManager = PasswordManager(runMode: runMode);
    _passwords = _passwordManager.loadPasswords();

    // Load config
    this.config = config ??
        ServerpodConfig.load(
          _runMode,
          commandLineArgs.serverId,
          _passwords,
        );

    logVerbose(this.config.toString());
    serverId = this.config.serverId;

    try {
      _innerInitializeServerpod();
    } catch (e, stackTrace) {
      _reportException(e, stackTrace,
          message: 'Error in Serverpod initialization');
      rethrow;
    }

    stdout.writeln('SERVERPOD initialized, time: ${DateTime.now().toUtc()}');
  }

  void _innerInitializeServerpod() {
    _instance = this;
    _internalSerializationManager = internal.Protocol();
    Features(config);

    // Create a temporary log manager with default settings, until we have
    // loaded settings from the database.
    _updateLogSettings(_defaultRuntimeSettings);

    // Setup database
    var databaseConfiguration = config.database;
    if (Features.enableDatabase && databaseConfiguration != null) {
      _databasePoolManager = DatabasePoolManager(
        serializationManager,
        databaseConfiguration,
      );

      // TODO: Remove this when we have a better way to handle this.
      // Tracked by issue: https://github.com/serverpod/serverpod/issues/2421
      // This is required because other operations in Serverpod assumes that the
      // database is connected when the Serverpod is created
      // (such as createSession(...)).
      _databasePoolManager?.start();
    }

    if (Features.enableDatabase) {
      storage.addAll({
        'public': DatabaseCloudStorage('public'),
        'private': DatabaseCloudStorage('private'),
      });
    }

    // Setup Redis
    var redis = config.redis;
    if (Features.enableRedis && redis != null) {
      redisController = RedisController(
        host: redis.host,
        port: redis.port,
        user: redis.user,
        password: redis.password,
      );
    }

    _caches = Caches(
      serializationManager,
      config,
      serverId,
      redisController,
    );

    var authHandler = authenticationHandler ?? defaultAuthenticationHandler;

    server = Server(
      serverpod: this,
      serverId: serverId,
      port: config.apiServer.port,
      serializationManager: serializationManager,
      databasePoolManager: _databasePoolManager,
      passwords: _passwords,
      runMode: _runMode,
      caches: caches,
      authenticationHandler: authHandler,
      whitelistedExternalCalls: whitelistedExternalCalls,
      endpoints: endpoints,
      httpResponseHeaders: httpResponseHeaders,
      httpOptionsResponseHeaders: httpOptionsResponseHeaders,
      securityContext: _securityContextConfig?.apiServer,
    );
    endpoints.initializeEndpoints(server);

    _internalSession = InternalSession(server: server, enableLogging: false);

    if (Features.enableFutureCalls) {
      _futureCallManager = FutureCallManager(
        server.serverpod.config.futureCall,
        serializationManager,
        diagnosticsService: ServerpodFutureCallDiagnosticsService(server),
        internalSession: internalSession,
        sessionProvider: (String futureCallName) => FutureCallSession(
          server: server,
          futureCallName: futureCallName,
        ),
        initializeFutureCall: (FutureCall futureCall, String name) {
          futureCall.initialize(
            server,
            name,
          );
        },
      );
    }

    if (Features.enableScheduledHealthChecks) {
      _healthCheckManager = HealthCheckManager(
        this,
        _onCompletedHealthChecks,
      );
    }

    if (Features.enableWebServer()) {
      _webServer = WebServer(
        serverpod: this,
        securityContext: _securityContextConfig?.webServer,
      );
    }
  }

  int _exitCode = 0;

  /// Starts the Serverpod and all [Server]s that it manages.
  ///
  /// If [runInGuardedZone] is set to true (the default),
  /// the start function will be executed inside `runZonedGuarded`.
  /// Any errors during the start up sequence will cause the process to exit.
  /// Any runtime errors will be in their own error zone and will not crash the server.
  ///
  /// If [runInGuardedZone] is set to false, the start function will be executed in the same error zone as the caller.
  /// An [ExitException] will be thrown if the start up sequence fails.
  Future<void> start({bool runInGuardedZone = true}) async {
    _startedTime = DateTime.now().toUtc();

    void onZoneError(Object error, StackTrace stackTrace) {
      if (error is ExitException) {
        if (error.message != '') {
          stderr.writeln(error.message);
        }
        exit(error.exitCode);
      }

      _exitCode = 1;
      _reportException(error, stackTrace,
          message: 'Internal server error. Zoned exception.');
    }

    if (runInGuardedZone) {
      await runZonedGuarded(() async {
        await _unguardedStart();
      }, onZoneError);
    } else {
      await _unguardedStart();
      if (_exitCode != 0) {
        throw ExitException(_exitCode);
      }
    }
  }

  Future<void> _unguardedStart() async {
    // Register cloud store endpoint if we're using the database cloud store
    var hasDatabaseStorage = storage.entries.any(
      (storage) => storage.value is DatabaseCloudStorage,
    );

    if (hasDatabaseStorage) {
      CloudStoragePublicEndpoint().register(this);
    }

    // It is important that we start the database pool manager before
    // attempting to connect to the database.
    _databasePoolManager?.start();

    if (Features.enableMigrations) {
      int? maxAttempts =
          commandLineArgs.role == ServerpodRole.maintenance ? 6 : null;
      try {
        await _connectToDatabase(
          session: internalSession,
          maxAttempts: maxAttempts,
        );
      } catch (e, stackTrace) {
        const message = 'Failed to connect to the database.';
        _reportException(e, stackTrace, message: message);
        throw ExitException(1, '$message: $e');
      }

      await _applyMigrations(
        applyRepairMigration: commandLineArgs.applyRepairMigration,
        applyMigrations: commandLineArgs.applyMigrations,
      );

      await _loadRuntimeSettings();
    } else if (commandLineArgs.applyMigrations ||
        commandLineArgs.applyRepairMigration) {
      stderr.writeln(
        'Migrations are disabled in this project, skipping applying migration(s).',
      );
      _exitCode = 1;
    }

    _updateLogSettings(_runtimeSettings ?? _defaultRuntimeSettings);

    // Connect to Redis
    if (Features.enableRedis) {
      logVerbose('Connecting to Redis.');
      await redisController?.start();
    } else {
      logVerbose('Redis is disabled, skipping.');
    }

    // Start servers.
    if (commandLineArgs.role == ServerpodRole.monolith ||
        commandLineArgs.role == ServerpodRole.serverless) {
      var serversStarted = true;

      ProcessSignal.sigint.watch().listen(_onInterruptSignal);
      if (!Platform.isWindows) {
        ProcessSignal.sigterm.watch().listen(_onShutdownSignal);
      }

      // Serverpod Insights.
      if (Features.enableInsights) {
        if (_isValidSecret(config.serviceSecret)) {
          serversStarted &= await _startInsightsServer();
        } else {
          stderr.write(
            'Invalid serviceSecret in password file, Insights server disabled.',
          );
        }
      }

      // Main API server.
      serversStarted &= await server.start();

      /// Web server.
      if (Features.enableWebServer(_webServer)) {
        logVerbose('Starting web server.');
        serversStarted &= await webServer.start();
      } else {
        logVerbose('Web server not configured, skipping.');
      }

      if (!serversStarted) {
        throw ExitException(
          1,
          'Failed to start the Serverpod servers, see logs for details.',
        );
      }

      logVerbose('All servers started.');
    }

    // Start maintenance tasks. If we are running in maintenance mode, we
    // will only run the maintenance tasks once. If we are applying migrations
    // no other maintenance tasks will be run.
    var appliedMigrations = (commandLineArgs.applyMigrations |
        commandLineArgs.applyRepairMigration);
    if (commandLineArgs.role == ServerpodRole.monolith ||
        (commandLineArgs.role == ServerpodRole.maintenance &&
            !appliedMigrations)) {
      logVerbose('Starting maintenance tasks.');

      // Start future calls
      _completedFutureCalls = _futureCallManager == null;
      if (!config.futureCallExecutionEnabled) {
        logVerbose('Future call execution is disabled.');
        _completedFutureCalls = true;
      } else if (commandLineArgs.role == ServerpodRole.maintenance) {
        unawaited(
          _futureCallManager
              ?.runScheduledFutureCalls()
              .whenComplete(_onCompletedFutureCalls),
        );
      } else {
        _futureCallManager?.start();
      }

      // Start health check manager
      _completedHealthChecks = _healthCheckManager == null;
      await _healthCheckManager?.start();
    }

    logVerbose('Serverpod start complete.');

    if (commandLineArgs.role == ServerpodRole.maintenance &&
        appliedMigrations) {
      logVerbose('Finished applying database migrations.');
      throw ExitException(_exitCode);
    }
  }

  Future<void> _applyMigrations({
    required bool applyRepairMigration,
    required bool applyMigrations,
  }) async {
    try {
      logVerbose('Initializing migration manager.');
      var migrationManager = MigrationManager(Directory.current);

      if (applyRepairMigration) {
        logVerbose('Applying database repair migration');
        var appliedRepairMigration =
            await migrationManager.applyRepairMigration(internalSession);
        if (appliedRepairMigration == null) {
          stderr.writeln('Failed to apply database repair migration.');
        } else {
          stdout.writeln(
              'Database repair migration "$appliedRepairMigration" applied.');
        }
      }

      if (applyMigrations) {
        logVerbose('Applying database migrations.');
        var migrationsApplied =
            await migrationManager.migrateToLatest(internalSession);

        if (migrationsApplied == null) {
          stdout.writeln('Latest database migration already applied.');
        } else {
          stdout.writeln(
              'Applied database migration${migrationsApplied.length > 1 ? 's' : ''}:');
          for (var migration in migrationsApplied) {
            stdout.writeln(' - $migration');
          }
        }
      }

      logVerbose('Verifying database integrity.');
      await MigrationManager.verifyDatabaseIntegrity(internalSession);
    } catch (e, stackTrace) {
      _exitCode = 1;
      const message = 'Failed to apply database migrations.';
      _reportException(e, stackTrace, message: message);
    }
  }

  Future<void> _loadRuntimeSettings() async {
    logVerbose('Loading runtime settings.');
    try {
      _runtimeSettings =
          await internal.RuntimeSettings.db.findFirstRow(internalSession);
    } catch (e, stackTrace) {
      _exitCode = 1;
      const message = 'Failed to load runtime settings.';
      _reportException(e, stackTrace, message: message);
    }

    if (_runtimeSettings == null) {
      logVerbose('Runtime settings not found, creating default settings.');
      try {
        _runtimeSettings = await RuntimeSettings.db
            .insertRow(internalSession, _defaultRuntimeSettings);
      } catch (e, stackTrace) {
        _exitCode = 1;
        const message = 'Failed to store runtime settings.';
        _reportException(e, stackTrace, message: message);
      }
    } else {
      logVerbose('Runtime settings loaded.');
    }
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
      // This will exit the process in maintenance mode (and only that mode) after future calls and health checks are done.
      throw ExitException(_exitCode);
    }
  }

  void _onShutdownSignal(ProcessSignal signal) {
    stdout.writeln('${signal.name} (${signal.signalNumber}) received'
        ', time: ${DateTime.now().toUtc()}');
    shutdown(exitProcess: true, signalNumber: signal.signalNumber);
  }

  bool _interruptSignalSent = false;

  void _onInterruptSignal(ProcessSignal signal) {
    stdout.writeln('${signal.name} (${signal.signalNumber}) received'
        ', time: ${DateTime.now().toUtc()}');

    if (_interruptSignalSent) {
      stdout
          .writeln('SERVERPOD immediate exit, time: ${DateTime.now().toUtc()}');
      exit(128 + signal.signalNumber);
    }

    _interruptSignalSent = true;
    shutdown(exitProcess: true, signalNumber: signal.signalNumber);
  }

  Future<bool> _startInsightsServer() async {
    var endpoints = internal.Endpoints();

    _serviceServer = Server(
      serverpod: this,
      serverId: serverId,
      port: config.insightsServer!.port,
      serializationManager: _internalSerializationManager,
      databasePoolManager: _databasePoolManager,
      passwords: _passwords,
      runMode: _runMode,
      name: 'Insights',
      caches: caches,
      authenticationHandler: serviceAuthenticationHandler,
      endpoints: endpoints,
      httpResponseHeaders: httpResponseHeaders,
      httpOptionsResponseHeaders: httpOptionsResponseHeaders,
      securityContext: _securityContextConfig?.insightsServer,
    );
    endpoints.initializeEndpoints(_serviceServer!);

    var success = await _serviceServer!.start();

    return success;
  }

  /// Registers a [FutureCall] with the [Serverpod] and associates it with
  /// the specified name.
  void registerFutureCall(FutureCall call, String name) {
    var futureCallManager = _futureCallManager;
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    _futureCallManager?.registerFutureCall(call, name);
  }

  /// Calls a [FutureCall] by its name after the specified delay, optionally
  /// passing a [SerializableModel] object as parameter.
  Future<void> futureCallWithDelay(
    String callName,
    SerializableModel? object,
    Duration delay, {
    String? identifier,
  }) async {
    assert(server.running,
        'Server is not running, call start() before using future calls');
    var futureCallManager = _futureCallManager;
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    await _futureCallManager?.scheduleFutureCall(
      callName,
      object,
      DateTime.now().toUtc().add(delay),
      serverId,
      identifier,
    );
  }

  /// Calls a [FutureCall] by its name at the specified time, optionally passing
  /// a [SerializableModel] object as parameter.
  Future<void> futureCallAtTime(
    String callName,
    SerializableModel? object,
    DateTime time, {
    String? identifier,
  }) async {
    var futureCallManager = _futureCallManager;
    assert(server.running,
        'Server is not running, call start() before using future calls');
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }

    await _futureCallManager?.scheduleFutureCall(
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
    var futureCallManager = _futureCallManager;
    if (futureCallManager == null) {
      throw StateError('Future calls are disabled.');
    }
    await _futureCallManager?.cancelFutureCall(identifier);
  }

  /// Retrieves a password for the given key. Passwords are loaded from the
  /// config/passwords.yaml file.
  String? getPassword(String key) {
    return _passwords[key];
  }

  /// Registers passwords to be loaded from the env variables.
  /// The password can be accessed with the [getPassword] method.
  /// The envName is the name of the environment variable that
  /// contains the password. The alias is the key used to access the
  /// the password with the [getPassword] method.
  /// The alias also maps to the name in the config/passwords.yaml file.
  /// This method may throw a [ArgumentError] if any Serverpod reserved passwords
  /// are used as aliases or environment variables.
  void loadCustomPasswords(
    List<({String envName, String alias})> envPasswords,
  ) {
    _passwords = _passwordManager.mergePasswords(
      envPasswords,
      _passwords,
      environment: Platform.environment,
    );
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
  /// If [exitProcess] is set to false, the process will not exit at the end of the shutdown.
  Future<void> shutdown({
    bool exitProcess = true,
    int? signalNumber,
  }) async {
    stdout.writeln(
        'SERVERPOD initiating shutdown, time: ${DateTime.now().toUtc()}');

    var futures = [
      _shutdownTestAuditor(),
      _internalSession.close(),
      redisController?.stop(),
      server.shutdown(),
      _webServer?.stop(),
      _serviceServer?.shutdown(),
      _futureCallManager?.stop(),
      _healthCheckManager?.stop(),
    ].nonNulls;

    Object? shutdownError;
    await futures.wait.onError((ParallelWaitError e, stackTrace) {
      shutdownError = e;
      var errors = e.errors;
      if (errors is Iterable<AsyncError?>) {
        for (var error in errors.nonNulls) {
          _reportException(
            error.error,
            error.stackTrace,
            message: 'Error in server shutdown',
          );
        }
      } else {
        _reportException(
          errors,
          stackTrace,
          message: 'Error in serverpod shutdown',
        );
      }
      return e.values;
    });

    try {
      // This needs to be closed last as it is used by the other services.
      await _databasePoolManager?.stop();
    } catch (e, stackTrace) {
      shutdownError = e;
      _reportException(
        e,
        stackTrace,
        message: 'Error in database pool manager shutdown',
      );
    }

    stdout.writeln(
        'SERVERPOD shutdown completed, time: ${DateTime.now().toUtc()}');

    if (exitProcess) {
      int conventionalExitCode = signalNumber != null ? 128 + signalNumber : 0;
      exit(shutdownError != null ? 1 : conventionalExitCode);
    }

    if (shutdownError != null) {
      throw shutdownError as Object;
    }
  }

  /// Logs a message to the console if the logging command line argument is set
  /// to verbose.
  void logVerbose(String message) {
    if (commandLineArgs.loggingMode == ServerpodLoggingMode.verbose) {
      stdout.writeln(message);
    }
  }

  void _reportException(
    Object e,
    StackTrace stackTrace, {
    String? message,
  }) {
    var now = DateTime.now().toUtc();
    if (message != null) {
      stderr.writeln('$now ERROR: $message');
    }
    stderr.writeln('$now ERROR: $e');
    stderr.writeln('$stackTrace');

    internalSubmitEvent(
      ExceptionEvent(e, stackTrace, message: message),
      space: OriginSpace.framework,
      context: DiagnosticEventContext(
        serverId: serverId,
        serverRunMode: runMode,
        serverName: '',
      ),
    );
  }

  /// Establishes a connection to the database. This method will retry
  /// connecting to the database until it succeeds.
  Future<Session> _connectToDatabase({
    required Session session,
    int? maxAttempts,
  }) async {
    bool printedDatabaseConnectionError = false;
    int attempts = 0;
    while (true) {
      attempts++;
      try {
        await session.db.testConnection();
        return session;
      } catch (e, stackTrace) {
        const message = 'Failed to connect to the database.';
        _reportException(e, stackTrace, message: message);

        stderr.writeln('Retrying to connect to the database in 10 seconds.');
        if (!printedDatabaseConnectionError) {
          stderr.writeln('Database configuration:');
          stderr.writeln(config.database.toString());
          printedDatabaseConnectionError = true;
        }

        if (maxAttempts != null && attempts >= maxAttempts) {
          throw TimeoutException(
            'Failed to connect to the database after $maxAttempts attempts.',
          );
        }

        await Future.delayed(const Duration(seconds: 10));
      }
    }
  }

  bool _isValidSecret(String? secret) {
    return secret != null && secret.isNotEmpty && secret.length > 20;
  }
}

// _shutdownTestAuditor is a stop-gap test approach to verify the robustness
// of the shutdown process.
// It is not intended to be used in production and it is not an encouraged pattern.
// The real solution is to enable dynamic service plugins for Serverpod,
// with which could plug in custom services for test scenarios without affecting
// production code like this.
Future<void>? _shutdownTestAuditor() {
  var testThrowerDelaySeconds = int.tryParse(
    Platform.environment['_SERVERPOD_SHUTDOWN_TEST_AUDITOR'] ?? '',
  );
  if (testThrowerDelaySeconds == null) {
    return null;
  }
  return Future(() {
    stderr.writeln('serverpod shutdown test auditor enabled');
    if (testThrowerDelaySeconds == 0) {
      throw Exception('serverpod shutdown test auditor throwing');
    } else {
      return Future.delayed(
        Duration(seconds: testThrowerDelaySeconds),
        () {
          throw Exception('serverpod shutdown test auditor throwing');
        },
      );
    }
  });
}

/// Experimental API for Serverpod.
///
/// Note: These features are experimental and may change or be removed
/// between minor version releases.
class ExperimentalApi {
  final DiagnosticEventHandler _eventDispatcher;

  ExperimentalApi._({
    ServerpodConfig? config,
    ExperimentalFeatures? experimentalFeatures,
  }) : _eventDispatcher = DiagnosticEventDispatcher(
          experimentalFeatures?.diagnosticEventHandlers ?? const [],
          timeout: config?.experimentalDiagnosticHandlerTimeout,
        );

  /// Application method for submitting a diagnostic event
  /// to registered event handlers.
  /// They will execute asynchrously.
  ///
  /// This method is for application (user space) use.
  void submitDiagnosticEvent(
    DiagnosticEvent event, {
    required Session session,
  }) {
    return _eventDispatcher.handleEvent(
      event,
      space: OriginSpace.application,
      context: contextFromSession(session),
    );
  }
}

/// Exception used to signal a
class ExitException implements Exception {
  /// Creates an instance of [ExitException].
  ExitException(this.exitCode, [this.message = '']);

  /// The error message
  final String message;

  /// The exit code
  final int exitCode;
}

/// Internal methods used by the Serverpod. These methods are not intended to
/// be exposed to end users.
extension ServerpodInternalMethods on Serverpod {
  /// Retrieve the log settings manager
  LogSettingsManager get logSettingsManager => _logSettingsManager!;

  /// Retrieve the global internal session used by the Serverpod.
  /// Logging is turned off.
  Session get internalSession => _internalSession;

  /// Submits an event to registered event handlers.
  /// They will execute asynchrously.
  /// This method is for internal framework use only.
  void internalSubmitEvent(
    DiagnosticEvent event, {
    required OriginSpace space,
    required DiagnosticEventContext context,
  }) {
    return _experimental._eventDispatcher.handleEvent(
      event,
      space: space,
      context: context,
    );
  }
}
