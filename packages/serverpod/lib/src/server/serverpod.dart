import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import '../cloud_storage/cloud_storage.dart';
import '../cloud_storage/database_cloud_storage.dart';
import '../cloud_storage/public_endpoint.dart';
import '../config/version.dart';
import '../redis/controller.dart';
import '../serialization/serialization_manager.dart';
import 'future_call_manager.dart';
import 'log_manager.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../authentication/authentication_info.dart';
import '../authentication/default_authentication_handler.dart';
import '../authentication/service_authentication.dart';
import '../cache/caches.dart';
import '../database/database_config.dart';
import '../generated/endpoints.dart' as internal;
import '../generated/protocol.dart' as internal;
import 'endpoint_dispatch.dart';
import 'future_call.dart';
import 'method_lookup.dart';
import 'run_mode.dart';
import 'server.dart';
import 'session.dart';

/// Performs a set of custom health checks on a [Serverpod].
typedef HealthCheckHandler = Future<List<internal.ServerHealthMetric>> Function(
    Serverpod pod);

/// The [Serverpod] handles all setup and manages the main [Server]. In addition
/// to the user managed server, it also runs a server for handling the
/// [DistributedCache] and other connections through the [InsightsEndpoint].
class Serverpod {
  static Serverpod? _instance;

  /// The last created [Serverpod]. In most cases the [Serverpod] is a singleton
  /// object, although it may be possible to run multiple instances in the same
  /// program it's not recommended.
  static Serverpod? get instance => _instance;

  late String _runMode;

  /// The servers run mode as specified in [ServerpodRunMode].
  String get runMode => _runMode;

  /// The server configuration, as read from the config/ directory.
  late ServerConfig config;
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
  late DatabaseConfig databaseConfig;

  /// Runs Serverpod with Redis enabled, true by default. If you disable Redis
  /// inter-server communication will be disabled, including messaging and
  /// global caching.
  final bool enableRedis;

  late Caches _caches;

  /// The Redis controller used by Serverpod.
  RedisController? redisController;

  /// Caches used by the server.
  Caches get caches => _caches;

  /// The id of this [Serverpod].
  int serverId = 0;

  /// The main server managed by this [Serverpod].
  late Server server;

  Server? _serviceServer;

  /// The service server managed by this [Serverpod].
  Server get serviceServer => _serviceServer!;

  internal.RuntimeSettings? _runtimeSettings;

  /// Serverpod runtime settings as read from the database.
  internal.RuntimeSettings get runtimeSettings => _runtimeSettings!;
  set runtimeSettings(internal.RuntimeSettings settings) {
    _runtimeSettings = settings;
    _logManager = LogManager(settings);
    _storeRuntimeSettings(settings);
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
  final Map<String, CloudStorage> storage = <String, CloudStorage>{
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
        logLevel: internal.LogLevel.warning.index,
        slowSessionDuration: 1.0,
        slowQueryDuration: 1.0,
      ),
      logMalformedCalls: false,
      logServiceCalls: false,
      logSettingsOverrides: <internal.LogSettingsOverride>[],
    );
  }

  Future<void> _storeRuntimeSettings(internal.RuntimeSettings settings) async {
    InternalSession session = await createSession();
    try {
      internal.RuntimeSettings? oldRuntimeSettings =
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
    await session.close(logSession: false);
  }

  /// Reloads the runtime settings from the database.
  Future<void> reloadRuntimeSettings() async {
    InternalSession session = await createSession();
    try {
      internal.RuntimeSettings? settings =
          await session.db.findSingleRow<internal.RuntimeSettings>();
      if (settings != null) {
        _runtimeSettings = settings;
        _logManager = LogManager(settings);
      }
      await session.close(logSession: false);
    } catch (e, stackTrace) {
      await session.close(error: e, stackTrace: stackTrace);
      return;
    }
  }

  /// Maps [Endpoint] methods to integer ids. Persistent through restarts and
  /// updates to the server, and consistent between servers in the same cluster.
  final MethodLookup methodLookup = MethodLookup('generated/protocol.yaml');

  /// Currently not used.
  List<String>? whitelistedExternalCalls;

  /// Creates a new Serverpod.
  Serverpod(
    List<String> args,
    this.serializationManager,
    this.endpoints, {
    this.authenticationHandler,
    this.healthCheckHandler,
    this.enableRedis = true,
  }) {
    _internalSerializationManager = internal.Protocol();
    serializationManager.merge(_internalSerializationManager);

    // Create a temporary log manager with default settings, until we have loaded settings from the database.
    _logManager = LogManager(_defaultRuntimeSettings);

    // Read command line arguments
    try {
      ArgParser argParser = ArgParser()
        ..addOption('mode',
            abbr: 'm',
            allowed: <String>[
              ServerpodRunMode.development,
              ServerpodRunMode.staging,
              ServerpodRunMode.production,
            ],
            defaultsTo: ServerpodRunMode.development)
        ..addOption('server-id', abbr: 'i', defaultsTo: '0');
      ArgResults results = argParser.parse(args);
      _runMode = results['mode'];
      serverId = int.tryParse(results['server-id']) ?? 0;
    } catch (e) {
      stdout.writeln('Unknown run mode, defaulting to development');
      _runMode = ServerpodRunMode.development;
    }

    // Load passwords
    _passwords = PasswordManager(runMode: runMode).loadPasswords() ?? <String, String>{};

    // Load config
    config = ServerConfig(_runMode, serverId, _passwords);

    // Setup database
    databaseConfig = DatabaseConfig(
      serializationManager,
      config.dbHost,
      config.dbPort,
      config.dbName,
      config.dbUser,
      config.dbPass,
    );

    // Setup Redis
    if (enableRedis) {
      redisController = RedisController(
        host: config.redisHost,
        port: config.redisPort,
        user: config.redisUser,
        password: config.redisPassword,
      );
    }

    _caches = Caches(serializationManager, config, serverId, redisController);

    server = Server(
      serverpod: this,
      serverId: serverId,
      port: config.port,
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
    endpoints.registerModules(this);

    // Setup future calls
    _futureCallManager = FutureCallManager(server, serializationManager);

    _instance = this;

    // TODO: Print version
    stdout.writeln('SERVERPOD version: $serverpodVersion mode: $_runMode');
  }

  /// Starts the Serverpod and all [Server]s that it manages.
  Future<void> start() async {
    await runZonedGuarded(() async {
      // Register cloud store endpoint if we're using the database cloud store
      if (storage['public'] is DatabaseCloudStorage ||
          storage['private'] is DatabaseCloudStorage) {
        CloudStoragePublicEndpoint().register(this);
      }

      // Runtime settings
      InternalSession session = await createSession();
      try {
        _runtimeSettings =
            await session.db.findSingleRow<internal.RuntimeSettings>();
        if (_runtimeSettings == null) {
          // Store default settings
          _runtimeSettings = _defaultRuntimeSettings;
          await session.db.insert(_runtimeSettings!);
        }
        _logManager = LogManager(_runtimeSettings!);
      } catch (e, stackTrace) {
        stderr.writeln(
            '${DateTime.now().toUtc()} Failed to connect to database.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      }

      try {
        await methodLookup.load(session);
      } catch (e, stackTrace) {
        stderr.writeln(
            '${DateTime.now().toUtc()} Internal server error. Failed to load method lookup.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
      }

      await session.close(logSession: false);

      // Connect to Redis
      if (redisController != null) {
        await redisController!.start();
      }

      // Start servers
      await _startServiceServer();

      await server.start();

      // Start future calls
      _futureCallManager.start();
    }, (Object e, StackTrace stackTrace) {
      // Last resort error handling
      // TODO: Log to database?
      stderr.writeln(
          '${DateTime.now().toUtc()} Internal server error. Zoned exception.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
    });
  }

  Future<void> _startServiceServer() async {
    // TODO: Add support for https on service server.
    // var context = SecurityContext();
    // context.useCertificateChain(sslCertificatePath(_runMode, serverId));
    // context.usePrivateKey(sslPrivateKeyPath(_runMode, serverId));

    internal.Endpoints endpoints = internal.Endpoints();

    _serviceServer = Server(
      serverpod: this,
      serverId: serverId,
      port: config.servicePort,
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
  Future<InternalSession> createSession() async {
    InternalSession session = InternalSession(server: server);
    return session;
  }

  /// Registers a module with the Serverpod. This is typically done from
  /// generated code.
  void registerModule(SerializationManager moduleProtocol, String name) {
    serializationManager.merge(moduleProtocol);
  }

  /// Shuts down the Serverpod and all associated servers.
  Future<void> shutdown() async {
    if (redisController != null) {
      await redisController!.stop();
    }
    server.shutdown();
    _serviceServer?.shutdown();
    _futureCallManager.stop();
    exit(0);
  }
}
