import 'dart:io';

import 'package:args/args.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:yaml/yaml.dart';

import '../authentication/authentication_info.dart';
import '../cache/caches.dart';
import '../cache/endpoint.dart';
import '../database/database.dart';
import '../generated/protocol.dart' as internal;
import 'config.dart';
import 'endpoint.dart';
import 'future_call.dart';
import 'runmode.dart';
import 'server.dart';

class Serverpod {
  String _runMode;
  ServerConfig config;
  Map<String, String> _passwords = <String, String>{};

  final AuthenticationHandler authenticationHandler;
  
  final SerializationManager serializationManager;
  SerializationManager _internalSerializationManager;

  Database database;

  int serverId = 0;
  Server server;
  Server _serviceServer;
  
  Serverpod(List<String> args, this.serializationManager, {this.authenticationHandler, Caches caches}) {
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

      config = ServerConfig('config/$_runMode.yaml', serverId);
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

    await _startServiceServer();

    await server.start();
  }

  Future<Null> _startServiceServer() async {
    _serviceServer = Server(
      serverpod: this,
      serverId: serverId,
      port: config?.servicePort ?? 8081,
      serializationManager: _internalSerializationManager,
      database: database,
      passwords: _passwords,
      runMode: _runMode,
      name: 'Insights',
    );
    
    _serviceServer.addEndpoint(CacheEndpoint(100, _internalSerializationManager), endpointNameCache);
    
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

  void log(internal.LogLevel level, String message, {StackTrace stackTrace}) {
    if (database != null) {
      var entry = internal.LogEntry(
        serverId: serverId,
        time: DateTime.now(),
        logLevel: level.index,
        message: message,
        stackTrace: stackTrace.toString(),
      );

      database.insert(entry);
    }

    print('${level.name.toUpperCase()}: $message');
    if (stackTrace != null)
      print(stackTrace.toString());
  }
}