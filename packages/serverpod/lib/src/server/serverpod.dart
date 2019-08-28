import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:yaml/yaml.dart';

import '../authentication/authentication_info.dart';
import '../authentication/certificates.dart';
import '../authentication/serviceAuthentication.dart';
import '../cache/caches.dart';
import '../cache/endpoint.dart';
import '../database/database.dart';
import '../database/database_connection.dart';
import '../generated/protocol.dart' as internal;
import '../insights/endpoint.dart';
import 'config.dart';
import 'endpoint.dart';
import 'future_call.dart';
import 'runmode.dart';
import 'server.dart';
import 'session.dart';

typedef Future<List<internal.ServerHealthMetric>> HealthCheckHandler(Serverpod pod);

class Serverpod {
  String _runMode;
  ServerConfig config;
  Map<String, String> _passwords = <String, String>{};

  final AuthenticationHandler authenticationHandler;
  final HealthCheckHandler healthCheckHandler;
  
  final SerializationManager serializationManager;
  SerializationManager _internalSerializationManager;

  Database database;
  Caches _caches;
  Caches get caches => _caches;

  int serverId = 0;
  Server server;
  Server _serviceServer;

  internal.RuntimeSettings _runtimeSettings;
  internal.RuntimeSettings get runtimeSettings => _runtimeSettings;

  List<String> whitelistedExternalCalls;
  
  Serverpod(List<String> args, this.serializationManager, {this.authenticationHandler, this.healthCheckHandler}) {
    _internalSerializationManager = internal.Protocol();
    serializationManager.appendConstructors(_internalSerializationManager.constructors);

    // Read command line arguments
    try {
      final argParser = ArgParser()
        ..addOption('mode', abbr: 'm',
            allowed: [ServerpodRunMode.development, ServerpodRunMode.production, ServerpodRunMode.generate],
            defaultsTo: ServerpodRunMode.development)
        ..addOption('server-id', abbr: 'i', defaultsTo: '0');
      ArgResults results = argParser.parse(args);
      _runMode = results['mode'];
      serverId = int.tryParse(results['server-id']) ?? 0;
    }
    catch(e) {
      log(internal.LogLevel.warning, 'Unknown run mode, defaulting to development');
      _runMode = ServerpodRunMode.development;
    }

    // Load config file
    if (_runMode != ServerpodRunMode.generate) {
      log(internal.LogLevel.info, 'Mode: $_runMode');

      config = ServerConfig(_runMode, serverId);
      log(internal.LogLevel.info, config.toString());

      // Load passwords
      try {
        String passwordYaml = File('config/passwords.yaml').readAsStringSync();
        Map passwords = loadYaml(passwordYaml);
        _passwords = passwords.cast<String, String>();
      }
      catch(_) {
        _passwords = <String, String>{};
      }

      // Setup database
      if (config.dbConfigured) {
        database = Database(serializationManager, config.dbHost, config.dbPort, config.dbName, config.dbUser, config.dbPass);
      }

      _caches = Caches(serializationManager, config, serverId);
    }

    server = Server(
      serverpod: this,
      serverId: serverId,
      port: config?.port ?? 8080,
      serializationManager: serializationManager,
      database: database,
      passwords: _passwords,
      runMode: _runMode,
      caches: caches,
      authenticationHandler: authenticationHandler,
      whitelistedExternalCalls: whitelistedExternalCalls,
    );
  }

  void start() async {
    runZoned(
      () async{
        if (_runMode == ServerpodRunMode.generate) {
          for (Endpoint endpoint in server.endpoints.values) {
            endpoint.printDefinition();
          }
          return;
        }

        // Runtime settings
        try {
          if (database != null) {
            await database.initialize();
            DatabaseConnection dbConn = DatabaseConnection(database);
            await dbConn.connect();

            _runtimeSettings =
            await dbConn.findSingleRow(internal.tRuntimeSettings);
            if (_runtimeSettings == null) {
              // Store default settings
              _runtimeSettings = internal.RuntimeSettings(
                logAllCalls: false,
                logAllQueries: false,
                logSlowCalls: true,
                logSlowQueries: true,
                logFailedCalls: true,
                logMalformedCalls: false,
                logLevel: internal.LogLevel.warning.index,
                slowCallDuration: 1.0,
                slowQueryDuration: 1.0,
              );
              await dbConn.insert(_runtimeSettings);
            }

            await dbConn.disconnect();
          }
        }
        catch(e, stackTrace) {
          print('${DateTime.now()} Failed to connect to database: $e');
          print('$stackTrace');
        }

        await _startServiceServer();

        await server.start();
      },
      onError: (e, stackTrace) {
        // Last resort error handling
        print('${DateTime.now()} Serverpod zoned error: $e');
        print('$stackTrace');
      }
    );
  }

  Future<Null> _startServiceServer() async {

    var context = SecurityContext();
    context.useCertificateChain(sslCertificatePath(_runMode, serverId));
    context.usePrivateKey(sslPrivateKeyPath(_runMode, serverId));

    _serviceServer = Server(
      serverpod: this,
      serverId: serverId,
      port: config?.servicePort ?? 8081,
      serializationManager: _internalSerializationManager,
      database: database,
      passwords: _passwords,
      runMode: _runMode,
      name: 'Insights',
      caches: caches,
      authenticationHandler: serviceAuthenticationHandler,
      securityContext: context,
    );
    
    _serviceServer.addEndpoint(CacheEndpoint(100, _internalSerializationManager, caches.distributed), endpointNameCache);
    _serviceServer.addEndpoint(CacheEndpoint(100, _internalSerializationManager, caches.distributedPrio), endpointNameCachePrio);
    _serviceServer.addEndpoint(InsightsEndpoint(this), endpointNameInsights);
    
    await _serviceServer.start();
  }

  void addEndpoint(Endpoint endpoint, String name) {
    server.addEndpoint(endpoint, name);
  }

  void addFutureCall(FutureCall call, String name) {
    server.addFutureCall(call, name);
  }

  String getPassword(String key) {
    return _passwords[key];
  }

  void log(internal.LogLevel level, String message, {StackTrace stackTrace, int sessionLogId}) async {
    int serverLogLevel = (_runtimeSettings?.logLevel ?? 0);

    if (database != null && level.index >= serverLogLevel) {
      var entry = internal.LogEntry(
        serverId: serverId,
        time: DateTime.now(),
        logLevel: level.index,
        message: message,
        stackTrace: stackTrace?.toString(),
        sessionLogId: sessionLogId,
      );

      bool success;

      try {
        DatabaseConnection dbConn = DatabaseConnection(database);
        await dbConn.connect();
        success = await dbConn.insert(entry);
        await dbConn.disconnect();
      }
      catch(e, stackTrace) {
        success = false;
      }
      if (!success)
        print('${DateTime.now()} FAILED DB LOG ${level.name.toLowerCase()}: $message');
    }

    if (_runMode == ServerpodRunMode.development) {
      print('${level.name.toUpperCase()}: $message');
      if (stackTrace != null)
        print(stackTrace.toString());
    }
  }

  Future<int> logSession(String endpoint, String method, Duration duration, List<QueryInfo> queries, List<LogInfo> sessionLog, String authenticatedUser, String exception, StackTrace stackTrace) async {
    if (_runMode == ServerpodRunMode.development) {
      print('CALL: $endpoint.$method duration: ${duration.inMilliseconds}ms numQueries: ${queries.length} authenticatedUser: $authenticatedUser');
      if (exception != null) {
        print('$exception');
        print('$stackTrace');
      }
    }

    var isSlow = duration > Duration(microseconds: (runtimeSettings.slowCallDuration * 1000000.0).toInt());

    if (_runtimeSettings.logAllCalls ||
        _runtimeSettings.logSlowCalls && isSlow ||
        _runtimeSettings.logFailedCalls && exception != null
    ) {
      var sessionLogEntry = internal.SessionLogEntry(
        serverId: serverId,
        time: DateTime.now(),
        endpoint: endpoint,
        method: method,
        duration: duration.inMicroseconds / 1000000.0,
        numQueries: queries.length,
        slow: isSlow,
        error: exception,
        stackTrace: stackTrace?.toString(),
        authenticatedUser: authenticatedUser,
      );

      try {
        DatabaseConnection dbConn = DatabaseConnection(database);
        await dbConn.connect();
        await dbConn.insert(sessionLogEntry);

        int sessionLogId = sessionLogEntry.id;

        for (var logInfo in sessionLog) {
          if (logInfo.level.index >= _runtimeSettings.logLevel) {
            log(logInfo.level, logInfo.message, stackTrace: logInfo.stackTrace,
                sessionLogId: sessionLogId);
          }
        }

        for (var queryInfo in queries) {
          if (_runtimeSettings.logAllQueries ||
              _runtimeSettings.logSlowQueries && queryInfo.time > Duration(
                  microseconds: (runtimeSettings.slowQueryDuration * 1000000.0)
                      .toInt())
          ) {
            // Log query
            var queryEntry = internal.QueryLogEntry(
              sessionLogId: sessionLogId,
              query: queryInfo.query,
              duration: queryInfo.time.inMicroseconds / 1000000.0,
              numRows: queryInfo.numRows,
            );
            await dbConn.insert(queryEntry);
          }
        }

        dbConn.disconnect();

        return sessionLogId;
      }
      catch(e, stackTrace) {
        print('${DateTime.now()} Failed to log session: $e');
        print('$stackTrace');
      }
    }

    return null;
  }

  void shutdown() {
    server?.shutdown();
    _serviceServer?.shutdown();
  }
}