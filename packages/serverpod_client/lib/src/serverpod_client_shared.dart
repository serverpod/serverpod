import 'dart:async';
import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'auth_key_manager.dart';
import 'serverpod_client_exception.dart';

/// Method called when errors occur in communication with the server.
typedef ServerpodClientErrorCallback = void Function(
    dynamic e, StackTrace stackTrace);

/// A callback with no parameters or return value.
typedef VoidCallback = void Function();

/// Superclass with shared methods for handling communication with the server.
/// It's overridden i two different versions depending on if the dart:io library
/// is available.
abstract class ServerpodClientShared extends EndpointCaller {
  /// Full host name of the Serverpod server. E.g. "https://example.com/"
  final String host;

  WebSocketChannel? _webSocket;

  final List<VoidCallback> _websocketConnectionStatusListeners = [];

  /// Full host name of the web socket endpoint.
  /// E.g. "wss://example.com/websocket"
  Future<String> get websocketHost async {
    var uri = Uri.parse(host);
    if (uri.scheme == 'http') {
      uri = uri.replace(scheme: 'ws');
    } else if (uri.scheme == 'https') {
      uri = uri.replace(scheme: 'wss');
    }
    uri = uri.replace(path: '/websocket');

    if (authenticationKeyManager != null) {
      var auth = await authenticationKeyManager!.get();
      if (auth != null) {
        uri = uri.replace(
          queryParameters: {
            'auth': auth,
          },
        );
      }
    }
    return uri.toString();
  }

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
    if (_consolidatedEndpointRefLookupCache != null) {
      return _consolidatedEndpointRefLookupCache!;
    }

    _consolidatedEndpointRefLookupCache = {};
    _consolidatedEndpointRefLookupCache!.addAll(endpointRefLookup);
    for (var module in moduleLookup.values) {
      _consolidatedEndpointRefLookupCache!.addAll(module.endpointRefLookup);
    }

    return _consolidatedEndpointRefLookupCache!;
  }

  /// Creates a new ServerpodClient.
  ServerpodClientShared(
    this.host,
    this.serializationManager, {
    dynamic context,
    this.errorHandler,
    this.authenticationKeyManager,
    this.logFailedCalls = true,
  }) {
    assert(host.endsWith('/'),
        'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'),
        'host must include protocol, eg: https://example.com/');
  }

  /// Registers a module with the client. This is typically done from
  /// generated code.
  void registerModuleProtocol(SerializationManager protocol) {
    serializationManager.merge(protocol);
  }

  /// Handles a message received from the WebSocket stream. Typically, this
  /// method shouldn't be called directly.
  void _handleRawWebSocketMessage(String message) {
    Map data = jsonDecode(message);
    String endpoint = data['endpoint'];
    Map objectData = data['object'];
    var entity = serializationManager
        .createEntityFromSerialization(objectData.cast<String, dynamic>());
    if (entity == null) {
      throw const ServerpodClientException('serializable entity is null', 0);
    }

    var endpointRef = _consolidatedEndpointRefLookup[endpoint];
    if (endpointRef == null) {
      throw ServerpodClientException('Endpoint $endpoint was not found', 0);
    }
    endpointRef._streamController.sink.add(entity);
  }

  /// Sends a message to the servers WebSocket stream. Typically, this method
  /// shouldn't be called directly, instead use [sendToStream].
  Future<void> _sendRawWebSocketMessage(String message) async {
    if (_webSocket == null) {
      throw const ServerpodClientException('WebSocket is not connected', 0);
    }
    _webSocket!.sink.add(message);
  }

  Future<void> _sendSerializableObjectToStream(
      String endpoint, SerializableEntity message) async {
    var objectData = message.serialize();
    var data = {
      'endpoint': endpoint,
      'object': objectData,
    };

    var serialization = jsonEncode(data);
    await _sendRawWebSocketMessage(serialization);
  }

  /// Closes all open connections to the server.
  void close() {
    _webSocket?.sink.close();
    _webSocket = null;
  }

  /// Open up a web socket connection to the server.
  Future<void> connectWebSocket() async {
    if (_webSocket != null) return;

    try {
      final host = await websocketHost;
      _webSocket = WebSocketChannel.connect(Uri.parse(host));
      unawaited(_listenToWebSocketStream());
    } catch (e) {
      _webSocket = null;
    }
    _notifyWebSocketConnectionStatusListeners();
  }

  /// Closes the current web socket connection (if open), then connects again.
  Future<void> reconnectWebSocket() async {
    if (_webSocket == null) return;

    await _webSocket?.sink.close();
    _webSocket = null;
    await connectWebSocket();
  }

  Future<void> _listenToWebSocketStream() async {
    if (_webSocket == null) return;

    try {
      await for (String message in _webSocket!.stream) {
        _handleRawWebSocketMessage(message);
      }
      _webSocket = null;
    } catch (e) {
      _webSocket = null;
    }
    _notifyWebSocketConnectionStatusListeners();
  }

  /// Adds a callback for when the [isWebSocketConnected] property is
  /// changed.
  void addWebSocketConnectionStatusListener(VoidCallback listener) {
    _websocketConnectionStatusListeners.add(listener);
  }

  /// Removes a connection status listener.
  void removeWebSocketConnectionStatusListener(VoidCallback listener) {
    _websocketConnectionStatusListeners.remove(listener);
  }

  void _notifyWebSocketConnectionStatusListeners() {
    for (var listener in _websocketConnectionStatusListeners) {
      listener();
    }
  }

  /// Returns true if the web socket is connected.
  bool get isWebSocketConnected {
    return _webSocket != null;
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
  Future<dynamic> callServerEndpoint(String endpoint, String method,
      String returnTypeName, Map<String, dynamic> args) {
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
  Future<dynamic> callServerEndpoint(String endpoint, String method,
      String returnTypeName, Map<String, dynamic> args);
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
    if (caller is ServerpodClientShared) {
      client = caller as ServerpodClientShared;
    } else if (caller is ModuleEndpointCaller) {
      client = (caller as ModuleEndpointCaller).client;
    }
  }

  /// The name of the endpoint this reference is connected to.
  String get name;

  /// The stream controller handles the stream of [SerializableEntity] sent
  /// from the server endpoint to the client, if it supports streaming.
  var _streamController = StreamController<SerializableEntity>();

  /// Stream of messages sent from an endpoint that supports streaming.
  Stream<SerializableEntity> get stream => _streamController.stream;

  /// Sends a message to the endpoint's stream.
  Future<void> sendStreamMessage(SerializableEntity message) async {
    return client._sendSerializableObjectToStream(name, message);
  }

  /// Resets web socket stream, so it's possible to re-listen to endpoint
  /// streams.
  void resetStream() {
    _streamController = StreamController<SerializableEntity>();
  }
}
