import 'dart:io';

import 'package:args/args.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:yaml/yaml.dart';

import '../authentication/authentication_info.dart';
import '../cache/caches.dart';
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

  Server server;
  
  Serverpod(List<String> args, this.serializationManager, {this.authenticationHandler, Caches caches}) {
    _internalSerializationManager = internal.Protocol();
    serializationManager.appendConstructors(_internalSerializationManager.constructors);

    // Read command line arguments
    try {
      final argParser = ArgParser()
        ..addOption('mode', abbr: 'm',
            allowed: [ServerpodRunMode.development, ServerpodRunMode.production, ServerpodRunMode.generate],
            defaultsTo: ServerpodRunMode.development);
      ArgResults results = argParser.parse(args);
      _runMode = results['mode'];
    }
    catch(e) {
      logWarning('Unknown run mode, defaulting to development');
      _runMode = ServerpodRunMode.development;
    }

    // Load config file
    if (_runMode != ServerpodRunMode.generate) {
      print('Mode: $_runMode');

      config = ServerConfig('config/$_runMode.yaml');
      print(config);

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
      port: config.port,
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
        print('Connected to database');
      }
      else {
        print('Failed to connect to database');
        database = null;
      }
    }

    await server.start();
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

  void logWarning(String warning) {
    print('WARNING: $warning');
  }
}