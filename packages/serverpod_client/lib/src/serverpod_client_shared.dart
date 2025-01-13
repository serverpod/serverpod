import 'dart:async';
import 'dart:convert';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'serverpod_client_shared_private.dart';

import 'serverpod_client_io.dart'
    if (dart.library.js) 'serverpod_client_browser.dart'
    if (dart.library.io) 'serverpod_client_io.dart';

/// A callback with no parameters or return value.
typedef VoidCallback = void Function();

/// Status of the streaming connection.
enum StreamingConnectionStatus {
  /// Streaming connection is live.
  connected,

  /// Streaming connection is connecting.
  connecting,

  /// Streaming connection is disconnected.
  disconnected,

  /// Streaming connection is waiting to make a new connection attempt.
  waitingToRetry,
}

/// Context for a method call.
class MethodCallContext {
  /// Name of the called endpoint.
  final String endpointName;

  /// Name of the called endpoint method.
  final String methodName;

  /// Arguments passed to the method.
  final Map<String, dynamic> arguments;

  /// Creates a new [MethodCallContext].
  const MethodCallContext({
    required this.endpointName,
    required this.methodName,
    required this.arguments,
  });
}

/// Defines the interface of the delegate that performs the actual request to the server
/// and returns the response data.
/// The delegate is used by [ServerpodClientShared] to perform the actual request.
/// It's overridden in different versions depending on if the dart:io library
/// is available.
abstract class ServerpodClientRequestDelegate {
  /// Performs the actual request to the server and returns the response data.
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
  });

  /// Closes the connection to the server.
  /// This delegate should not be used after calling this.
  void close();
}

/// Superclass with shared methods for handling communication with the server.
/// Is typically overridden by generated code to provide implementations of methods for calling the server.
abstract class ServerpodClientShared extends EndpointCaller {
  /// Full url to the Serverpod server. E.g. "https://example.com/"
  final String host;

  late final ServerpodClientRequestDelegate _requestDelegate;

  WebSocketChannel? _webSocket;

  Timer? _connectionTimer;

  final List<VoidCallback> _websocketConnectionStatusListeners = [];

  ClientMethodStreamManager? _clientMethodStreamManager;
  ClientMethodStreamManager get _methodStreamManager {
    var methodStreamManager = _clientMethodStreamManager;
    if (methodStreamManager == null) {
      methodStreamManager = ClientMethodStreamManager(
        connectionTimeout: streamingConnectionTimeout,
        webSocketHost: _webSocketHost.replace(path: '/v1/websocket'),
        serializationManager: serializationManager,
      );
      _clientMethodStreamManager = methodStreamManager;
    }

    return methodStreamManager;
  }

  // StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  late bool _disconnectWebSocketStreamOnLostInternetConnection;
  late bool _disconnectMethodStreamsOnLostInternetConnection;

  /// Full host name of the web socket endpoint.
  /// E.g. "wss://example.com/websocket"
  Uri get _webSocketHost {
    var uri = Uri.parse(host);
    if (uri.scheme == 'http') {
      uri = uri.replace(scheme: 'ws');
    } else if (uri.scheme == 'https') {
      uri = uri.replace(scheme: 'wss');
    }
    uri = uri.replace(path: '/websocket');
    return uri;
  }

  /// Full host name of the web socket endpoint.
  /// E.g. "wss://example.com/websocket"
  @Deprecated('This is only for internal use and may be removed in the future.')
  Future<String> get websocketHost async {
    return _webSocketHostWithAuth;
  }

  Future<String> get _webSocketHostWithAuth async {
    var uri = _webSocketHost;

    var auth = await authenticationKeyManager?.get();
    if (auth != null) {
      uri = uri.replace(
        queryParameters: {
          'auth': auth,
        },
      );
    }
    return uri.toString();
  }

  /// The [SerializationManager] used to serialize objects sent to the server.
  final SerializationManager serializationManager;

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

  /// Timeout when calling a server endpoint. If no response has been received, defaults to 20 seconds.
  Duration connectionTimeout;

  /// Callback when any call to the server fails or an exception is
  /// thrown.
  final void Function(
    MethodCallContext callContext,
    Object error,
    StackTrace stackTrace,
  )? onFailedCall;

  /// Callback when any call to the server succeeds.
  final void Function(MethodCallContext callContext)? onSucceededCall;

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
    if (connected) return;

    if (_disconnectMethodStreamsOnLostInternetConnection) {
      closeStreamingMethodConnections();
    }

    if (_disconnectWebSocketStreamOnLostInternetConnection &&
        _webSocket != null) {
      closeStreamingConnection();
    }
  }

  /// Creates a new ServerpodClientShared.
  ServerpodClientShared(
    this.host,
    this.serializationManager, {
    dynamic securityContext,
    required this.authenticationKeyManager,
    required Duration? streamingConnectionTimeout,
    required Duration? connectionTimeout,
    this.onFailedCall,
    this.onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  })  : connectionTimeout = connectionTimeout ?? const Duration(seconds: 20),
        streamingConnectionTimeout =
            streamingConnectionTimeout ?? const Duration(seconds: 5) {
    assert(host.endsWith('/'),
        'host must end with a slash, eg: https://example.com/');
    assert(host.startsWith('http://') || host.startsWith('https://'),
        'host must include protocol, eg: https://example.com/');
    _requestDelegate = ServerpodClientRequestDelegateImpl(
      connectionTimeout: this.connectionTimeout,
      serializationManager: serializationManager,
      securityContext: securityContext,
    );
    disconnectStreamsOnLostInternetConnection ??= false;
    _disconnectMethodStreamsOnLostInternetConnection =
        disconnectStreamsOnLostInternetConnection;
    _disconnectWebSocketStreamOnLostInternetConnection =
        disconnectStreamsOnLostInternetConnection;
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
    var model = serializationManager.deserializeByClassName(objectData);
    if (model == null) {
      throw const ServerpodClientException('serializable model is null', 0);
    }

    var endpointRef = _consolidatedEndpointRefLookup[endpoint];
    if (endpointRef == null) {
      throw ServerpodClientException('Endpoint $endpoint was not found', 0);
    }
    endpointRef._streamController.sink.add(model);
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
      String endpoint, SerializableModel message) async {
    var data = {
      'endpoint': endpoint,
      'object': {
        'className': serializationManager.getClassNameForObject(message),
        'data': message,
      },
    };

    var serialization = SerializationManager.encode(data);
    await _sendRawWebSocketMessage(serialization);
  }

  Future<void> _sendControlCommandToStream(
    String command, [
    Map<String, dynamic> args = const {},
  ]) async {
    var data = {'command': command, 'args': args};
    var serialization = SerializationManager.encode(data);
    await _sendRawWebSocketMessage(serialization);
  }

  /// Closes all open connections to the server.
  void close() {
    _requestDelegate.close();
    closeStreamingConnection();
    closeStreamingMethodConnections();
  }

  void _cancelConnectionTimer() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
  }

  /// Open a streaming connection to the server.
  Future<void> openStreamingConnection({
    bool disconnectOnLostInternetConnection = true,
  }) async {
    if (_webSocket != null) return;
    if (disconnectOnLostInternetConnection) {
      assert(
        _connectivityMonitor != null,
        'To enable automatic disconnect on lost internet connection, you need to set the connectivityMonitor property.',
      );
    }
    _disconnectWebSocketStreamOnLostInternetConnection =
        disconnectOnLostInternetConnection;

    try {
      // Connect to the server.
      _firstMessageReceived = false;
      var host = await _webSocketHostWithAuth;
      _webSocket = WebSocketChannel.connect(Uri.parse(host));
      await _webSocket?.ready;

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
      // ignore: avoid_print
      print('Failed to open streaming connection: $e');
      _webSocket = null;
      _cancelConnectionTimer();
      rethrow;
    }

    // If everything is going according to plan, we are now connected to the
    // server.
    _notifyWebSocketConnectionStatusListeners();
  }

  /// Closes all open streaming method connections.
  ///
  /// [exception] is an optional exception that will be thrown to all
  /// listeners of open streams.
  ///
  /// If [exception] is not provided, a [WebSocketClosedException] will be
  /// thrown.
  Future<void> closeStreamingMethodConnections({
    Object? exception = const WebSocketClosedException(),
  }) async {
    await _methodStreamManager.closeAllConnections(exception);
  }

  /// Closes the streaming connection if it is open.
  Future<void> closeStreamingConnection() async {
    await _webSocket?.sink.close();
    _webSocket = null;
    _cancelConnectionTimer();

    // Notify listeners that websocket has been closed
    _notifyWebSocketConnectionStatusListeners();

    // Hack for dart:io version of websocket to get time to close the stream
    // in _listenToWebSocket
    await Future.delayed(const Duration(milliseconds: 100));
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
      // ignore: avoid_print
      print('Error while listening to websocket stream: $e');
      _webSocket = null;
      _cancelConnectionTimer();
    }
    _notifyWebSocketConnectionStatusListeners();
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

  /// The previous streaming connection status (used to detect changes in
  /// connection status, so that listeners can be notified)
  StreamingConnectionStatus? _prevStreamingConnectionStatus;

  /// Checks if the streaming connection status has changed, and if so,
  /// notifies listeners.
  void _notifyWebSocketConnectionStatusListeners() {
    var currStreamingConnectionStatus = streamingConnectionStatus;
    if (currStreamingConnectionStatus == _prevStreamingConnectionStatus) return;

    _prevStreamingConnectionStatus = currStreamingConnectionStatus;
    for (var listener in _websocketConnectionStatusListeners) {
      listener();
    }
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
  /// Note, the provided key will be converted/wrapped as a proper authentication header value
  /// when sent to the server.
  Future<void> updateStreamingConnectionAuthenticationKey(
    String? authKey,
  ) async {
    if (streamingConnectionStatus == StreamingConnectionStatus.disconnected) {
      return;
    }
    var authValue = await authenticationKeyManager?.toHeaderValue(authKey);
    await _sendControlCommandToStream('auth', {'key': authValue});
  }

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
  ) async {
    var callContext = MethodCallContext(
      endpointName: endpoint,
      methodName: method,
      arguments: args,
    );

    try {
      var authenticationValue =
          await authenticationKeyManager?.getHeaderValue();
      var body = formatArgs(args, method);
      var url = Uri.parse('$host$endpoint');

      var data = await _requestDelegate.serverRequest(
        url,
        body: body,
        authenticationValue: authenticationValue,
      );

      T result;
      if (T == getType<void>()) {
        result = returnVoid() as T;
      } else {
        result = parseData<T>(data, T, serializationManager);
      }

      onSucceededCall?.call(callContext);
      return result;
    } catch (e, s) {
      onFailedCall?.call(callContext, e, s);

      rethrow;
    }
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams,
  ) {
    var connectionDetails = MethodStreamConnectionDetails(
      endpoint: endpoint,
      method: method,
      args: args,
      parameterStreams: streams,
      outputController: StreamController<G>(),
      authenticationProvider: () async =>
          authenticationKeyManager?.getHeaderValue(),
    );

    _methodStreamManager.openMethodStream(connectionDetails).catchError((e, _) {
      Object error;
      if (e is OpenMethodStreamException) {
        error = switch (e.responseType) {
          OpenMethodStreamResponseType.endpointNotFound =>
            ServerpodClientNotFound(),
          OpenMethodStreamResponseType.authenticationFailed =>
            ServerpodClientUnauthorized(),
          OpenMethodStreamResponseType.authorizationDeclined =>
            ServerpodClientForbidden(),
          OpenMethodStreamResponseType.invalidArguments =>
            ServerpodClientBadRequest(),
          OpenMethodStreamResponseType.success =>
            ServerpodClientException('Unknown error, data: $e', -1),
        };
      } else {
        error = e;
      }

      connectionDetails.outputController.addError(error);
      connectionDetails.outputController.close();
    });
    if (T == Stream<G>) {
      return connectionDetails.outputController.stream;
    } else if ((T == Future<G>) && G == getType<void>()) {
      var result = Completer<void>();
      // Listen to stream so that close can be called when method has returned.
      connectionDetails.outputController.stream.listen(
        (e) {},
        onError: ((e, _) => result.completeError(e)),
        onDone: () => result.complete(),
        cancelOnError: true,
      );
      return result.future;
    } else if (T == Future<G>) {
      var result = Completer<G>();
      connectionDetails.outputController.stream.first.then((e) {
        result.complete(e);
      }, onError: (e, _) {
        result.completeError(e);
      });
      return result.future;
    } else {
      throw UnsupportedError('Unsupported type $T');
    }
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

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams,
  ) {
    return client.callStreamingServerEndpoint<T, G>(
      endpoint,
      method,
      args,
      streams,
    );
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

  /// Calls a server endpoint method that supports streaming. The [streams]
  /// parameter is a map of stream names to stream objects. The method will
  /// listen to the streams and send the data to the server.
  /// Typically, this method is called by generated code.
  ///
  /// [T] is the type of the return value of the endpoint stream. This is either
  /// a [Stream] or a [Future].
  ///
  /// [G] is the generic of [T], such as T<G>.
  ///
  /// If [T] is not a [Stream] or a [Future], the method will throw an exception.
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams,
  );
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

  /// The stream controller handles the stream of [SerializableModel] sent
  /// from the server endpoint to the client, if it supports streaming.
  var _streamController = StreamController<SerializableModel>();

  /// Stream of messages sent from an endpoint that supports streaming.
  Stream<SerializableModel> get stream => _streamController.stream;

  /// Sends a message to the endpoint's stream.
  Future<void> sendStreamMessage(SerializableModel message) async {
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
    _streamController = StreamController<SerializableModel>();
  }
}
