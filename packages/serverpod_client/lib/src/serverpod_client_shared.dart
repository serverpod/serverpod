import 'dart:async';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'auth_key_manager.dart';
import 'serverpod_client_exception.dart';

/// Method called when errors occur in communication with the server.
typedef ServerpodClientErrorCallback = void Function(dynamic e, StackTrace stackTrace);

/// Superclass with shared methods for handling communication with the server.
/// It's overridden i two different versions depending on if the dart:io library
/// is available.
abstract class ServerpodClientShared extends EndpointCaller {
  /// Full host name of the Serverpod server. E.g. "https://example.com/"
  final String host;

  /// The [SerializationManager] used to serialize objects sent to the server.
  final SerializationManager serializationManager;

  /// If true, the client will log any failed calls to stdout.
  final bool logFailedCalls;

  /// Optional [AuthenticationKeyManager] if the client needs to sign the user
  /// in.
  final AuthenticationKeyManager? authenticationKeyManager;

  /// Optional error handler. If the errorHandler is used, exceptions will not
  /// be thrown when a call to the server fails, instead the errorHandler will
  /// be called.
  ServerpodClientErrorCallback? errorHandler;

  /// Looks up module callers by their name. Overridden by generated code.
  Map<String, ModuleEndpointCaller> get moduleLookup;

  Map<String, EndpointRef>? _consolidatedEndpointRefLookupCache;
  Map<String, EndpointRef> get _consolidatedEndpointRefLookup {
    if (_consolidatedEndpointRefLookupCache != null)
      return _consolidatedEndpointRefLookupCache!;

    _consolidatedEndpointRefLookupCache = {};
    _consolidatedEndpointRefLookupCache!.addAll(endpointRefLookup);
    for (var module in moduleLookup.values) {
      _consolidatedEndpointRefLookupCache!.addAll(module.endpointRefLookup);
    }

    return _consolidatedEndpointRefLookupCache!;
  }

  /// Creates a new ServerpodClient.
  ServerpodClientShared(this.host, this.serializationManager, {
    dynamic context,
    this.errorHandler,
    this.authenticationKeyManager,
    this.logFailedCalls=true,
  }){
    assert(host.endsWith('/'), 'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'), 'host must include protocol, eg: https://example.com/');
  }

  /// Registers a module with the client. This is typically done from
  /// generated code.
  void registerModuleProtocol(SerializationManager protocol) {
    serializationManager.merge(protocol);
  }

  /// Handles a message received from the WebSocket stream. Typically, this
  /// method shouldn't be called directly.
  void handleRawWebSocketMessage(String message) {
    Map data = jsonDecode(message);
    String endpoint = data['endpoint'];
    Map objectData = data['object'];
    var entity = serializationManager.createEntityFromSerialization(objectData.cast<String, dynamic>());
    if (entity == null) {
      throw ServerpodClientException('serializable entity is null', 0);
    }

    var endpointRef = _consolidatedEndpointRefLookup[endpoint];
    if (endpointRef == null) {
      throw ServerpodClientException('Endpoint $endpoint was not found', 0);
    }
    endpointRef._streamController.sink.add(entity);
  }

  /// Sends a message to the servers WebSocket stream. Typically, this method
  /// shouldn't be called directly, instead use [sendToStream].
  Future<void> sendRawWebSocketMessage(String message);

  Future<void> _sendSerializableObjectToStream(String endpoint, SerializableEntity message) async {
    var objectData = message.serialize();
    var data = {
      'endpoint': endpoint,
      'object': objectData,
    };

    var serialization = jsonEncode(data);
    await sendRawWebSocketMessage(serialization);
  }
}

/// This class is used to connect modules with the client. Overridden by
/// generated code.
abstract class ModuleEndpointCaller extends EndpointCaller {
  /// Reference to the client.
  final ServerpodClientShared client;

  /// Creates a new [ModuleEndpointCaller].
  ModuleEndpointCaller(this.client);

  @override
  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args) {
    return client.callServerEndpoint(endpoint, method, returnTypeName, args);
  }
}

/// Super class for all classes that can call a server endpoint.
abstract class EndpointCaller {
  /// Looks up an [EndpointRef] by its name. This method is typically only
  /// used internally and overridden by generated code.
  Map<String, EndpointRef> get endpointRefLookup;

  /// Calls a server endpoint method by its name, passing arguments in a map.
  /// Typically, this method is called by generated code.
  Future<dynamic> callServerEndpoint(String endpoint, String method, String returnTypeName, Map<String, dynamic> args);
}

/// This class connects endpoints on the server with the client, it also
/// hooks up streams with the endpoint. Overridden by generated code.
abstract class EndpointRef {
  /// Holds a reference to the caller class.
  final EndpointCaller caller;

  /// Reference to the client.
  late final ServerpodClientShared client;

  /// Creates a new [EndpointRef].
  EndpointRef(this.caller) {
    if (caller is ServerpodClientShared)
      client = caller as ServerpodClientShared;
    else if (caller is ModuleEndpointCaller)
      client = (caller as ModuleEndpointCaller).client;
  }

  /// The name of the endpoint this reference is connected to.
  String get name;

  /// The stream controller handles the stream of [SerializableEntity] sent
  /// from the server endpoint to the client, if it supports streaming.
  final _streamController = StreamController<SerializableEntity>();

  /// Stream of messages sent from an endpoint that supports streaming.
  Stream<SerializableEntity> get stream => _streamController.stream;

  /// Sends a message to the endpoint's stream.
  Future<void> sendToStream(SerializableEntity message) async {
    return client._sendSerializableObjectToStream(name, message);
  }
}