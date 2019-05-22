import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'config.dart';
import 'endpoint.dart';
import 'future_call.dart';
import 'future_call_manager.dart';
import '../authentication/authentication_info.dart';
import '../cache/caches.dart';
import '../database/database.dart';
import '../generated/protocol.dart' as private;

class ServerRunMode {
  static final development = 'development';
  static final production = 'production';
  static final generate = 'generate';
}

class Server {
  final _endpoints = <String, Endpoint>{};
  String _runningMode;
  bool _running = false;
  bool get running => _running;

  ServerConfig config;
  Database database;
  final SerializationManager serializationManager;
  SerializationManager _privateSerializationManager;
  FutureCallManager _futureCallManager;
  Map<String, String> _passwords = <String, String>{};

  final AuthenticationHandler authenticationHandler;

  Caches _caches;
  Caches get caches => _caches;

  Server(List<String> args, this.serializationManager, {this.authenticationHandler, Caches caches}) {
    _privateSerializationManager = private.Protocol();
    serializationManager.appendConstructors(_privateSerializationManager.constructors);

    // Read command line arguments
    try {
      final argParser = ArgParser()
        ..addOption('mode', abbr: 'm',
            allowed: [ServerRunMode.development, ServerRunMode.production, ServerRunMode.generate],
            defaultsTo: ServerRunMode.development);
      ArgResults results = argParser.parse(args);
      _runningMode = results['mode'];
    }
    catch(e) {
      logWarning('Unknown run mode, defaulting to development');
      _runningMode = ServerRunMode.development;
    }

    // Load config file
    if (_runningMode != ServerRunMode.generate) {
      print('Mode: $_runningMode');

      config = ServerConfig('config/$_runningMode.yaml');
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

      // Setup future calls
      _futureCallManager = FutureCallManager(this, serializationManager);

      // Setup caches
      _caches = caches ?? Caches(serializationManager);
    }
  }

  int get serverId => 0;

  String getPassword(String key) {
    return _passwords[key];
  }

  void addEndpoint(Endpoint endpoint, String name) {
    if (_endpoints.containsKey(name))
      logWarning('Added endpoint with duplicate name ($name)');

    endpoint.initialize(this, name);
    _endpoints[name] = endpoint;
  }

  void addFutureCall(FutureCall call, String name) {
    if (_futureCallManager != null)
      _futureCallManager.addFutureCall(call, name);
  }

  void callWithDelay(String callName, SerializableEntity object, Duration delay) {
    assert(_running, 'Server is not running, call start() before using future calls');
    _futureCallManager.scheduleFutureCall(callName, object, DateTime.now().add(delay), serverId);
  }

  void start() async {
    if (_runningMode == ServerRunMode.generate) {
      for (Endpoint endpoint in _endpoints.values) {
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

    HttpServer.bind(InternetAddress.anyIPv6, config.port).then((HttpServer server) {
      server.listen((HttpRequest request) {
        _handleRequest(request);
      });
    });

    // Start future calls
    _futureCallManager?.start();

    _running = true;
    print('\nServerpod listening on port ${config.port}');
  }

  Future<Null> _handleRequest(HttpRequest request) async {
    final uri = request.requestedUri;

    var result = await _handleUriCall(uri);

    if (result is ResultInvalidParams) {
      print('Invalid params: $result');
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }
    else {
      String serializedEntity = serializationManager.serializeEntity(result);
      request.response.write(serializedEntity);
      request.response.close();
      return;
    }

    // request.response.close();
  }

  Future _handleUriCall(Uri uri) async {
    String endpointName = uri.path.substring(1);
    Endpoint endpoint = _endpoints[endpointName];

    if (endpoint == null)
      return ResultInvalidParams('Endpoint $endpointName does not exist in $uri');

    return endpoint.handleUriCall(uri);
  }

  void logWarning(String warning) {
    print('WARNING: $warning');
  }
}