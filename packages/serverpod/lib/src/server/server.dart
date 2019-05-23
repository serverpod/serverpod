import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'endpoint.dart';
import 'future_call.dart';
import 'future_call_manager.dart';
import 'runmode.dart';
import 'serverpod.dart';
import '../authentication/authentication_info.dart';
import '../cache/caches.dart';
import '../database/database.dart';

class Server {
  final _endpoints = <String, Endpoint>{};

  final Serverpod serverpod;
  final int serverId;
  final int port;
  final String runMode;
  Database database;
  final SerializationManager serializationManager;
  final AuthenticationHandler authenticationHandler;
  final Caches caches;

  bool _running = false;
  bool get running => _running;

  FutureCallManager _futureCallManager;

  Server({
    this.serverpod,
    @required this.serverId,
    @required this.port,
    @required this.serializationManager,
    this.database,
    Map<String, String> passwords,
    @required this.runMode,
    Caches caches,
    this.authenticationHandler,
  }) :
    this.caches = caches ?? Caches(serializationManager)
  {
    if (runMode != ServerpodRunMode.generate) {
      // Setup future calls
      _futureCallManager = FutureCallManager(this, serializationManager);
    }
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
    if (runMode == ServerpodRunMode.generate) {
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

    HttpServer.bind(InternetAddress.anyIPv6, port).then((HttpServer server) {
      server.listen((HttpRequest request) {
        _handleRequest(request);
      });
    });

    // Start future calls
    _futureCallManager?.start();

    _running = true;
    print('\nServerpod listening on port ${port}');
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
  }

  Future _handleUriCall(Uri uri) async {
    String endpointName = uri.path.substring(1);
    Endpoint endpoint = _endpoints[endpointName];

    if (endpoint == null)
      return ResultInvalidParams('Endpoint $endpointName does not exist in $uri');

    return endpoint.handleUriCall(uri);
  }

  void logWarning(String warning) {
    if (serverpod != null)
      serverpod.logWarning(warning);
    else
      print('WARNING: $warning');
  }
}