import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:pedantic/pedantic.dart';
import 'package:serverpod/src/server/password_manager.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../authentication/authentication_info.dart';
import '../authentication/serviceAuthentication.dart';
import '../cache/caches.dart';
import '../database/database_config.dart';
import '../database/database_connection.dart';
import '../generated/protocol.dart' as internal;
import '../generated/endpoints.dart' as internal;
import 'endpoint_dispatch.dart';
import 'future_call.dart';
import 'run_mode.dart';
import 'server.dart';
import 'session.dart';
import 'method_lookup.dart';

/// Performs a set of custom health checks on a [Serverpod].
typedef HealthCheckHandler = Future<List<internal.ServerHealthMetric>> Function(Serverpod pod);

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
  final SerializationManager serializationManager;
  late SerializationManager _internalSerializationManager;

  /// Definition of endpoints used by the server. This is typically generated.
  final EndpointDispatch endpoints;

  /// The database configuration.
  late DatabaseConfig databaseConfig;

  late Caches _caches;
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
    _storeRuntimeSettings(settings);
  }

  Future<void> _storeRuntimeSettings(internal.RuntimeSettings settings) async {
    try {
      var dbConn = DatabaseConnection(databaseConfig);

      var oldRuntimeSettings = await dbConn.findSingleRow(
          internal.tRuntimeSettings) as internal.RuntimeSettings?;
      if (oldRuntimeSettings == null) {
        settings.id = null;
        await dbConn.insert(settings);
      }

      settings.id = oldRuntimeSettings!.id;
      await dbConn.update(settings);
    }
    catch(e) {
      return;
    }
  }

  /// Reloads the runtime settings from the database.
  Future<void> reloadRuntimeSettings() async {
    try {
      var dbConn = DatabaseConnection(databaseConfig);

      var settings = await dbConn.findSingleRow(
          internal.tRuntimeSettings) as internal.RuntimeSettings?;
      if (settings != null)
        _runtimeSettings = settings;
    }
    catch(e) {
      return;
    }
  }

  /// Maps [Endpoint] methods to integer ids. Persistent through restarts and
  /// updates to the server, and consistent between servers in the same cluster.
  final MethodLookup methodLookup = MethodLookup('generated/protocol.yaml');

  /// Currently not used.
  List<String>? whitelistedExternalCalls;

  /// Creates a new Serverpod.
  Serverpod(List<String> args, this.serializationManager, this.endpoints, {this.authenticationHandler, this.healthCheckHandler}) {
    _internalSerializationManager = internal.Protocol();
    serializationManager.merge(_internalSerializationManager);

    // Read command line arguments
    try {
      final argParser = ArgParser()
        ..addOption('mode', abbr: 'm',
            allowed: [ServerpodRunMode.development, ServerpodRunMode.staging, ServerpodRunMode.production,],
            defaultsTo: ServerpodRunMode.development)
        ..addOption('server-id', abbr: 'i', defaultsTo: '0');
      var results = argParser.parse(args);
      _runMode = results['mode'];
      serverId = int.tryParse(results['server-id']) ?? 0;
    }
    catch(e) {
      print('Unknown run mode, defaulting to development');
      _runMode = ServerpodRunMode.development;
    }

    // Load config files
    print('Mode: $_runMode');

    // Load passwords
    _passwords = PasswordManager(runMode: runMode).loadPasswords() ?? {};

    // Load config
    config = ServerConfig(_runMode, serverId);
    if (_passwords['database'] != null)
      config.dbPass = _passwords['database'];
    if (_passwords['serviceSecret'] != null)
      config.serviceSecret = _passwords['serviceSecret'];

    // Print config
    print(config.toString());

    // Setup database
    databaseConfig = DatabaseConfig(serializationManager, config.dbHost!, config.dbPort!, config.dbName!, config.dbUser!, config.dbPass!);

    _caches = Caches(serializationManager, config, serverId);

    server = Server(
      serverpod: this,
      serverId: serverId,
      port: config.port ?? 8080,
      serializationManager: serializationManager,
      databaseConfig: databaseConfig,
      passwords: _passwords,
      runMode: _runMode,
      caches: caches,
      authenticationHandler: authenticationHandler,
      whitelistedExternalCalls: whitelistedExternalCalls,
      endpoints: endpoints,
    );
    endpoints.initializeEndpoints(server);
    endpoints.registerModules(this);

    _instance = this;
  }

  /// Starts the Serverpod and all [Server]s that it manages.
  Future<void> start() async {
    await runZonedGuarded(
      () async {
        // Runtime settings
        try {
          var dbConn = DatabaseConnection(databaseConfig);

          _runtimeSettings = await dbConn.findSingleRow(internal.tRuntimeSettings) as internal.RuntimeSettings?;
          if (_runtimeSettings == null) {
            // Store default settings
            _runtimeSettings = internal.RuntimeSettings(
              logAllCalls: false,
              logAllQueries: false,
              logSlowCalls: true,
              logSlowQueries: true,
              logFailedCalls: true,
              logFailedQueries: true,
              logMalformedCalls: false,
              logLevel: internal.LogLevel.warning.index,
              logServiceCalls: false,
              slowCallDuration: 1.0,
              slowQueryDuration: 1.0,
            );
            await dbConn.insert(_runtimeSettings!);
          }
        }
        catch(e, stackTrace) {
          stderr.writeln('${DateTime.now().toUtc()} Failed to connect to database.');
          stderr.writeln('$e');
          stderr.writeln('$stackTrace');
        }

        try {
          await methodLookup.load(DatabaseConnection(databaseConfig));
        }
        catch(e, stackTrace) {
          stderr.writeln('${DateTime.now().toUtc()} Internal server error. Failed to load method lookup.');
          stderr.writeln('$e');
          stderr.writeln('$stackTrace');
        }

        await _startServiceServer();

        await server.start();
      },
      (e, stackTrace) {
        // Last resort error handling
        stderr.writeln('${DateTime.now().toUtc()} Internal server error. Zoned exception.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');

        log('Zoned exception.', exception: e, stackTrace: stackTrace, level: internal.LogLevel.warning);
      }
    );
  }

  Future<void> _startServiceServer() async {

    var context = SecurityContext();
    context.useCertificateChain(sslCertificatePath(_runMode, serverId));
    context.usePrivateKey(sslPrivateKeyPath(_runMode, serverId));

    var endpoints = internal.Endpoints();

    _serviceServer = Server(
      serverpod: this,
      serverId: serverId,
      port: config.servicePort ?? 8081,
      serializationManager: _internalSerializationManager,
      databaseConfig: databaseConfig,
      passwords: _passwords,
      runMode: _runMode,
      name: 'Insights',
      caches: caches,
      authenticationHandler: serviceAuthenticationHandler,
      securityContext: context,
      endpoints: endpoints,
    );
    endpoints.initializeEndpoints(_serviceServer!);

    await _serviceServer!.start();
  }

  /// Registers a [FutureCall] with the [Serverpod] and associates it with
  /// the specified name.
  void registerFutureCall(FutureCall call, String name) {
    server.registerFutureCall(call, name);
  }

  /// Retrieves a password for the given key. Passwords are loaded from the
  /// config/passwords.yaml file.
  String? getPassword(String key) {
    return _passwords[key];
  }

  /// Logs a message in the database. The message is ignored if the [Serverpod]s
  /// [internal.LogLevel] is configured to be higher than the
  /// [internal.LogLevel] used in the log call. Default [internal.LogLevel] is
  /// [internal.LogLevel.info]. If the logging fails, the message is written to
  /// stdout. In [ServerpodRunMode.development] all messages are written to
  /// stdout.
  Future<void> log(String message, {internal.LogLevel? level, dynamic? exception, StackTrace? stackTrace}) async {
    var entry = internal.LogEntry(
      serverId: server.serverId,
      logLevel: (level ?? internal.LogLevel.info).index,
      message: message,
      time: DateTime.now(),
      exception: '$exception',
      stackTrace: '$stackTrace',
    );

    await _log(entry, null);
  }

  Future<void> _log(internal.LogEntry entry, int? sessionLogId) async {
    var serverLogLevel = (_runtimeSettings?.logLevel ?? 0);

    if (entry.logLevel >= serverLogLevel) {
      entry.sessionLogId = sessionLogId;

      bool success;

      try {
        var dbConn = DatabaseConnection(databaseConfig);
        success = await dbConn.insert(entry);
      }
      catch(e) {
        success = false;
      }
      if (!success)
        print('${DateTime.now().toUtc()} FAILED LOG ENTRY: $entry.message');
    }

    if (_runMode == ServerpodRunMode.development) {
      print('${internal.LogLevel.values[entry.logLevel].name.toUpperCase()}: ${entry.message}');
      if (entry.exception != null)
        print(entry.exception);
      if (entry.stackTrace != null)
        print(entry.stackTrace);
    }
  }

  /// Logs a [Session] after is has been completed.
  Future<int?> logSession(Session session, {int? authenticatedUserId, String? exception, StackTrace? stackTrace}) async {
    var duration = session.duration;

    if (_runMode == ServerpodRunMode.development) {
      if (session.type == SessionType.methodCall)
        print('METHOD CALL: ${session.methodCall!.endpointName}.${session.methodCall!.methodName} duration: ${duration.inMilliseconds}ms numQueries: ${session.queries.length} authenticatedUser: $authenticatedUserId');
      else if (session.type == SessionType.futureCall)
        print('FUTURE CALL: ${session.futureCall!.callName} duration: ${duration.inMilliseconds}ms numQueries: ${session.queries.length}');
      if (exception != null) {
        print('$exception');
        print('$stackTrace');
      }
    }

    var isSlow = duration > Duration(microseconds: (runtimeSettings.slowCallDuration * 1000000.0).toInt());

    if (runtimeSettings.logAllCalls ||
        runtimeSettings.logSlowCalls && isSlow ||
        runtimeSettings.logFailedCalls && exception != null
    ) {
      var sessionLogEntry = internal.SessionLogEntry(
        serverId: serverId,
        time: DateTime.now(),
        endpoint: session.methodCall?.endpointName,
        method: session.methodCall?.methodName,
        futureCall: session.futureCall?.callName,
        duration: duration.inMicroseconds / 1000000.0,
        numQueries: session.queries.length,
        slow: isSlow,
        error: exception,
        stackTrace: stackTrace?.toString(),
        authenticatedUserId: authenticatedUserId,
      );

      try {
        var dbConn = DatabaseConnection(databaseConfig);
        await dbConn.insert(sessionLogEntry);

        var sessionLogId = sessionLogEntry.id!;

        for (var logInfo in session.logs) {
          unawaited(_log(logInfo, sessionLogId));
        }

        for (var queryInfo in session.queries) {
          if (runtimeSettings.logAllQueries ||
              runtimeSettings.logSlowQueries && queryInfo.duration > runtimeSettings.slowQueryDuration ||
              runtimeSettings.logFailedQueries && queryInfo.exception != null
          ) {
            // Log query
            queryInfo.sessionLogId = sessionLogId;
            queryInfo.serverId = serverId;
            await dbConn.insert(queryInfo);
          }
        }

        return sessionLogId;
      }
      catch(e, logStackTrace) {
        stderr.writeln('${DateTime.now().toUtc()} FAILED TO LOG SESSION');
        if (session.methodCall != null)
          stderr.writeln('CALL: ${session.methodCall!.endpointName}.${session.methodCall!.methodName} duration: ${duration.inMilliseconds}ms numQueries: ${session.queries.length} authenticatedUser: $authenticatedUserId');
        stderr.writeln('CALL error: $exception');
        stderr.writeln('$logStackTrace');

        stderr.writeln('LOG ERRORS');
        stderr.writeln('$e');
        stderr.writeln('$logStackTrace');
        stderr.writeln('Current stacktrace:');
        stderr.writeln('${StackTrace.current}');

      }
    }

    return null;
  }

  /// Registers a module with the Serverpod. This is typically done from
  /// generated code.
  void registerModule(SerializationManager moduleProtocol, String name) {
    serializationManager.merge(moduleProtocol);
  }

  /// Shuts down the Serverpod and all associated servers.
  void shutdown() {
    server.shutdown();
    _serviceServer?.shutdown();
  }
}