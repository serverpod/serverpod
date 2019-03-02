import 'dart:io';

import 'package:args/args.dart';

import 'config.dart';
import 'endpoint.dart';
import 'protocol.dart';
import '../database/database.dart';


class Server {
  final _endpoints = <String,Endpoint>{};
  String _runningMode;

  ServerConfig config;
  Database database;
  final SerializationManager serializationManager = SerializationManager();

  Server(List<String> args) {
    // Read command line arguments
    try {
      final argParser = ArgParser()
        ..addOption('mode', abbr: 'm',
            allowed: ['development', 'production'],
            defaultsTo: 'development');
      ArgResults results = argParser.parse(args);
      _runningMode = results['mode'];
    }
    catch(e) {
      logWarning('Unknown run mode, defaulting to development');
      _runningMode = 'development';
    }
    print('Mode: $_runningMode');

    // Load config file
    config = ServerConfig('config/$_runningMode.yaml');
    print(config);

    // Setup database
    if (config.dbConfigured) {
      database = Database(serializationManager, config.dbHost, config.dbPort, config.dbName, config.dbUser, config.dbPass);
    }

    // Load serializable class definitions
    bool success = serializationManager.loadSerializableClassDefinitions();
    if (success) {
      print('Loaded serializable class definitions');
    }
    else {
      print('Failed load serializable class definitions');
      database = null;
    }
  }

  void addEndpoint(Endpoint endpoint) {
    if (_endpoints.containsKey(endpoint.name)) {
      logWarning('Added endpoint with duplicate name (${endpoint.name})');
    }

    _endpoints[endpoint.name] = endpoint;
  }

  void start() async {
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

    print('\nServerpod listening on port ${config.port}');
  }

  Future<Null> _handleRequest(HttpRequest request) async {
    final uri = request.requestedUri;
    print('request: $uri');

    Result result = await _handleUriCall(uri);

    if (result is ResultInvalidParams) {
      print('Invalid params: $result');
      request.response.statusCode = HttpStatus.badRequest;
      request.response.close();
      return;
    }
    else if (result is ResultSuccess) {
      request.response.write(result.formatData());
      request.response.close();
      return;
    }

    request.response.close();
  }

  Future<Result> _handleUriCall(Uri uri) async {
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