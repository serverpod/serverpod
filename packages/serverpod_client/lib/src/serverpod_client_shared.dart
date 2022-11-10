import 'dart:async';
import 'dart:convert';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A callback with no parameters or return value.
typedef VoidCallback = void Function();

/// Status of the streaming connection.
enum StreamingConnectionStatus {
  /// Streming connection is live.
  connected,

  /// Streaming connection is connecting.
  connecting,

  /// Streaming connection is disconnected.
  disconnected,

  /// Streaming connection is waiting to make a new connection attempt.
  waitingToRetry,
}

/// Superclass with shared methods for handling communication with the server.
/// It's overridden i two different versions depending on if the dart:io library
/// is available.
abstract class ServerpodClientShared extends EndpointCaller {
  /// Full url to the Serverpod server. E.g. "https://example.com/"
  final String host;

  WebSocketChannel? _webSocket;

  Timer? _connectionTimer;

  final List<VoidCallback> _websocketConnectionStatusListeners = [];

  // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _disconnectOnLostInternetConnection = false;

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

  /// Timeout when opening a web socket connection. If no message has been
  /// received within the timeout duration the socket will be closed.
  final Duration streamingConnectionTimeout;

  bool _firstMessageReceived = false;

  ConnectivityMonitor? _connectivityMonitor;

  /// Set a connectivity monitor to better manage streaming connections. You
  /// can find the FlutterConnectivityMonitor in the serverpod_flutter package.
  ConnectivityMonitor? get connectivityMonitor => _connectivityMonitor;

  set connectivityMonitor(ConnectivityMonitor? monitor) {
    _connectivityMonitor?.removeListener(_connectivityChanged);
    monitor?.addListener(_connectivityChanged);
    _connectivityMonitor = monitor;
  }

  void _connectivityChanged(bool connected) {
    if (!connected) {
      if (_disconnectOnLostInternetConnection && _webSocket != null) {
        closeStreamingConnection();
      }
    }
  }

  /// Creates a new ServerpodClient.
  ServerpodClientShared(
    this.host,
    this.serializationManager, {
    dynamic context,
    this.authenticationKeyManager,
    this.logFailedCalls = true,
    this.streamingConnectionTimeout = const Duration(seconds: 5),
  }) {
    assert(host.endsWith('/'),
        'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'),
        'host must include protocol, eg: https://example.com/');
  }

  /// Handles a message received from the WebSocket stream. Typically, this
  /// method shouldn't be called directly.
  void _handleRawWebSocketMessage(String message) {
    Map data = jsonDecode(message);

    String? command = data['command'];
    if (command != null) {
      if (command == 'pong') {
        // Do nothing.
      }
      return;
    }

    String endpoint = data['endpoint'];
    Map<String, dynamic> objectData = data['object'];
    var entity = serializationManager.deserializeByClassName(objectData);
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
    var data = {
      'endpoint': endpoint,
      'object': {
        'className': serializationManager.getClassNameForObject(message),
        'data': message,
      },
    };

    var serialization = SerializationManager.serialize(data);
    await _sendRawWebSocketMessage(serialization);
  }

  Future<void> _sendControlCommandToStream(
    String command, [
    Map<String, dynamic> args = const {},
  ]) async {
    var data = {'command': command, 'args': args};
    var serialization = SerializationManager.serialize(data);
    await _sendRawWebSocketMessage(serialization);
  }

  /// Closes all open connections to the server.
  void close() {
    closeStreamingConnection();
  }

  void _cancelConnectionTimer() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
  }

  /// Open a streaming connection to the server.
  @Deprecated('Renamed to openStreamingConnection')
  Future<void> connectWebSocket() async {
    await openStreamingConnection();
  }

  /// Open a streaming connection to the server.
  Future<void> openStreamingConnection({
    bool disconnectOnLostInternetConnection = true,
  }) async {
    if (_webSocket != null) return;
    if (disconnectOnLostInternetConnection) {
      assert(
        _connectivityMonitor != null,
        'To enable automatic disconnect on lost internet connection, you need to set the connectivityMonitor propery.',
      );
    }
    _disconnectOnLostInternetConnection = disconnectOnLostInternetConnection;

    try {
      // Connect to the server.
      _firstMessageReceived = false;
      var host = await websocketHost;
      _webSocket = WebSocketChannel.connect(Uri.parse(host));

      // We are sending the ping message to the server, so that we are
      // guaranteed to get a first message in return. This will verify that we
      // have an open connection to the server.
      await _sendControlCommandToStream('ping');
      unawaited(_listenToWebSocketStream());

      // Time out and close the connection if we haven't got a pong response
      // within the timeout period.
      _connectionTimer = Timer(streamingConnectionTimeout, () async {
        if (!_firstMessageReceived) {
          await _webSocket?.sink.close();
          _webSocket = null;
          _cancelConnectionTimer();
          _notifyWebSocketConnectionStatusListeners();
        }
      });
    } catch (e) {
      _webSocket = null;
      _cancelConnectionTimer();
      rethrow;
    }

    // If everything is going according to plan, we are now connected to the
    // server.
    _notifyWebSocketConnectionStatusListeners();
  }

  /// Closes the streaming connection if it is open.
  Future<void> closeStreamingConnection() async {
    await _webSocket?.sink.close();
    _webSocket = null;
    _cancelConnectionTimer();

    // Hack for dart:io version of websocket to get time to close the stream
    // in _listenToWebSocket
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Closes the current web socket connection (if open), then connects again.
  @Deprecated('Use closeStreamingConnection / openStreamingConnection instead.')
  Future<void> reconnectWebSocket() async {
    if (_webSocket == null) return;

    await _webSocket?.sink.close();
    _webSocket = null;
    _cancelConnectionTimer();

    await openStreamingConnection();
  }

  Future<void> _listenToWebSocketStream() async {
    if (_webSocket == null) return;

    try {
      await for (String message in _webSocket!.stream) {
        _handleRawWebSocketMessage(message);
        if (!_firstMessageReceived) {
          _firstMessageReceived = true;
          _notifyWebSocketConnectionStatusListeners();
        }
      }
      _webSocket = null;
      _cancelConnectionTimer();
    } catch (e) {
      _webSocket = null;
      _cancelConnectionTimer();
    }
    _notifyWebSocketConnectionStatusListeners();
  }

  /// Adds a callback for when the [isWebSocketConnected] property is
  /// changed.
  @Deprecated('Use addStreamingConnectionStatusListener instead.')
  void addWebSocketConnectionStatusListener(VoidCallback listener) {
    addStreamingConnectionStatusListener(listener);
  }

  /// Removes a connection status listener.
  @Deprecated('Use removeStreamingConnectionStatusListener instead.')
  void removeWebSocketConnectionStatusListener(VoidCallback listener) {
    removeStreamingConnectionStatusListener(listener);
  }

  /// Adds a callback for when the [streamingConnectionStatus] property is
  /// changed.
  void addStreamingConnectionStatusListener(VoidCallback listener) {
    _websocketConnectionStatusListeners.add(listener);
  }

  /// Removes a connection status listener.
  void removeStreamingConnectionStatusListener(VoidCallback listener) {
    _websocketConnectionStatusListeners.remove(listener);
  }

  void _notifyWebSocketConnectionStatusListeners() {
    for (var listener in _websocketConnectionStatusListeners) {
      listener();
    }
  }

  /// Returns true if the web socket is connected.
  @Deprecated('Use streamingConnectionStatus instead.')
  bool get isWebSocketConnected {
    return _webSocket != null;
  }

  /// Returns the current status of the streaming connection. It can be one of
  /// connected, connecting, or disconnected. Use the
  /// [StreamingConnectionHandler] if you want to automatically reconnect if
  /// the connection is lost.
  StreamingConnectionStatus get streamingConnectionStatus {
    if (_webSocket != null && _firstMessageReceived) {
      return StreamingConnectionStatus.connected;
    } else if (_webSocket != null) {
      return StreamingConnectionStatus.connecting;
    } else {
      return StreamingConnectionStatus.disconnected;
    }
  }

  /// Updates the authentication key if the streaming connection is open.
  Future<void> updateStreamingConnectionAuthenticationKey(
    String? authKey,
  ) async {
    if (streamingConnectionStatus == StreamingConnectionStatus.disconnected) {
      return;
    }
    await _sendControlCommandToStream('auth', {'key': authKey});
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
  Future<T> callServerEndpoint<T>(
      String endpoint, String method, Map<String, dynamic> args) {
    return client.callServerEndpoint<T>(endpoint, method, args);
  }
}

/// Super class for all classes that can call a server endpoint.
abstract class EndpointCaller {
  /// Looks up an [EndpointRef] by its name. This method is typically only
  /// used internally and overridden by generated code.
  Map<String, EndpointRef> get endpointRefLookup;

  /// Calls a server endpoint method by its name, passing arguments in a map.
  /// Typically, this method is called by generated code.
  Future<T> callServerEndpoint<T>(
      String endpoint, String method, Map<String, dynamic> args);
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
    try {
      if (!_streamController.isClosed) {
        _streamController.close();
      }
    } catch (e) {
      // Just in case, an issue happens when closing the stream.
    }
    _streamController = StreamController<SerializableEntity>();
  }
}
