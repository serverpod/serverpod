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
import '../generated/protocol.dart' as internal;
import '../insights/endpoint.dart';
import 'config.dart';
import 'endpoint.dart';
import 'future_call.dart';
import 'runmode.dart';
import 'server.dart';
import 'session.dart';

class Serverpod {
  String _runMode;
  ServerConfig config;
  Map<String, String> _passwords = <String, String>{};

  final AuthenticationHandler authenticationHandler;
  
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
  
  Serverpod(List<String> args, this.serializationManager, {this.authenticationHandler}) {
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
      serverId: 0,
      port: config?.port ?? 8080,
      serializationManager: serializationManager,
      database: database,
      passwords: _passwords,
      runMode: _runMode,
      caches: caches,
      authenticationHandler: authenticationHandler,
    );
  }

  void start() async {
    if (_runMode == ServerpodRunMode.generate) {
      for (Endpoint endpoint in server.endpoints.values) {
        endpoint.printDefinition();
      }
      return;
    }

    // Connect to database
    if (database != null) {
      bool success = await database.connect();
      if (success) {
        log(internal.LogLevel.info, 'Connected to database');
      }
      else {
        log(internal.LogLevel.error, 'Failed to connect to database');
        database = null;
      }
    }

    // Runtime settings
    if (database != null) {
      _runtimeSettings = await database.findSingleRow(internal.tRuntimeSettings);
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
        await database.insert(_runtimeSettings);
      }
    }

    await _startServiceServer();

    await server.start();
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

  void log(internal.LogLevel level, String message, {StackTrace stackTrace, int callLogId}) async {
    if (database != null && level.index >= (_runtimeSettings?.logLevel ?? 0)) {
      var entry = internal.LogEntry(
        serverId: serverId,
        time: DateTime.now(),
        logLevel: level.index,
        message: message,
        stackTrace: stackTrace?.toString(),
        callLogId: callLogId,
      );

      bool success = await database.insert(entry);
      if (!success)
        print('FAILED DB LOG ${level.name.toLowerCase()}: $message');
    }

    if (_runMode == ServerpodRunMode.development) {
      print('${level.name.toUpperCase()}: $message');
      if (stackTrace != null)
        print(stackTrace.toString());
    }
  }

  Future<int> logCall(String endpoint, String method, Duration duration, List<QueryInfo> queries, List<LogInfo> sessionLog, String authenticatedUser, String exception, StackTrace stackTrace) async {
    if (_runMode == ServerpodRunMode.development) {
      print('CALL: $endpoint.$method duration: ${duration.inMilliseconds}ms numQueries: ${queries.length} authenticatedUser: $authenticatedUser');
      if (exception != null) {
        print('$exception');
        print('$stackTrace');
      }
    }

    var isSlow = duration > Duration(microseconds: (runtimeSettings.slowCallDuration * 1000000.0).toInt());

    if (_runtimeSettings.logAllQueries ||
        _runtimeSettings.logSlowQueries && isSlow ||
        _runtimeSettings.logFailedCalls && exception != null
    ) {
      var callLogEntry = internal.CallLogEntry(
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
      await database.insert(callLogEntry);

      int callLogId = callLogEntry.id;

      for (var logInfo in sessionLog) {
        if (logInfo.level.index >= _runtimeSettings.logLevel) {
          log(logInfo.level, logInfo.message, stackTrace: logInfo.stackTrace, callLogId: callLogId);
        }
      }

      for (var queryInfo in queries) {
        if (_runtimeSettings.logAllQueries ||
            _runtimeSettings.logSlowQueries && queryInfo.time > Duration(microseconds: (runtimeSettings.slowQueryDuration * 1000000.0).toInt())
        ) {
          // Log query
          var queryEntry = internal.QueryLogEntry(
            callLogId: callLogId,
            query: queryInfo.query,
            duration: queryInfo.time.inMicroseconds / 1000000.0,
            numRows: queryInfo.numRows,
          );
          await database.insert(queryEntry);
        }
      }

      return callLogId;
    }

    return null;
  }

  void shutdown() {
    server?.shutdown();
    _serviceServer?.shutdown();
    database?.disconnect();
  }
}