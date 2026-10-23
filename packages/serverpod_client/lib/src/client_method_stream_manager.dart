// ignore_for_file: avoid_print

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';
import 'package:serverpod_client/src/util/lock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Manages the connection to the server for method streams.
@internal
final class ClientMethodStreamManager {
  static const Duration _defaultPingInterval = Duration(seconds: 20);
  static const Duration _defaultIdleTimeout = Duration(seconds: 40);

  /// The WebSocket channel used to communicate with the server.
  /// If null, no connection is open.
  WebSocketChannel? _webSocket;

  /// Completer that is completed when the WebSocket listener is done.
  Completer _webSocketListenerCompleter = Completer()..complete();

  /// The host of the WebSocket server.
  final Uri _webSocketHost;

  /// Timer used to send periodic pings to the server.
  Timer? _pingTimer;

  /// Timer used to detect idle connections with no inbound messages.
  Timer? _idleTimeoutTimer;

  /// Timestamp of the last received message.
  DateTime? _lastMessageReceivedAt;

  final Duration _pingInterval;
  final Duration _idleTimeout;

  /// The timeout for the connection attempt.
  final Duration _connectionTimeout;

  /// The serialization manager used to serialize and deserialize messages.
  final SerializationManager _serializationManager;

  /// Optional connector used to override [WebSocketChannel.connect] in tests.
  final WebSocketChannel Function(Uri uri)? _webSocketConnector;

  /// Lock used to synchronize access when establishing websocket connection.
  final Lock _lock = Lock();

  /// A map of all inbound streams. These are streams that received messages
  /// from the server.
  final Map<String, _InboundStreamContext> _inboundStreams = {};

  /// A map of all outbound streams. These are streams that send messages to
  /// the server.
  final Map<String, _OutboundStreamContext> _outboundStreams = {};

  /// Opens that may still be awaiting credentials, an upgrade or acceptance.
  final _pendingOpens = <_MethodStreamOpenState>{};

  /// Creates a new [ClientMethodStreamManager].
  ClientMethodStreamManager({
    required Duration connectionTimeout,
    required Uri webSocketHost,
    required SerializationManager serializationManager,
    @visibleForTesting Duration? pingInterval,
    @visibleForTesting Duration? idleTimeout,
    @visibleForTesting WebSocketChannel Function(Uri uri)? webSocketConnector,
  }) : _webSocketHost = webSocketHost,
       _connectionTimeout = connectionTimeout,
       _serializationManager = serializationManager,
       _pingInterval = pingInterval ?? _defaultPingInterval,
       _idleTimeout = idleTimeout ?? _defaultIdleTimeout,
       _webSocketConnector = webSocketConnector;

  /// Closes all open connections and streams
  ///
  /// If an error is provided, it will be added to all inbound streams.
  Future<void> closeAllConnections([Object? error]) async {
    // Invalidate pre-connection work before waiting for socket cleanup. A late
    // credential or refresh result must not reopen a connection after shutdown.
    for (final opening in _pendingOpens.toList()) {
      opening.close(error);
    }
    await _lock.synchronized(() async {
      _cancelKeepAlive();
      var webSocket = _webSocket;
      _webSocket = null;
      await _closeAllStreams(error);
      await webSocket?.sink.close();
      await _webSocketListenerCompleter.future;
    });
  }

  /// Opens a method stream connection to the server.
  /// If no websocket connection is open, a new connection will be established.
  /// The connection will be closed when all streams are done.
  ///
  /// Throws an [OpenMethodStreamException] if the connection could not be
  /// established.
  ///
  /// Throws a [WebSocketConnectException] if the connection attempt fails.
  ///
  /// Throws a [ConnectionAttemptTimedOutException] if the connection attempt
  /// takes too long.
  Future<void> openMethodStream(
    MethodStreamConnectionDetails connectionDetails,
  ) async {
    final openState = _MethodStreamOpenState();
    _pendingOpens.add(openState);
    try {
      try {
        return await _openMethodStream(connectionDetails, openState);
      } on OpenMethodStreamException catch (e) {
        final authKeyProvider = connectionDetails.authKeyProvider;

        // Retry an expired access token once when the provider supports refresh.
        if (e.responseType ==
                OpenMethodStreamResponseType.authenticationFailed &&
            authKeyProvider is RefresherClientAuthKeyProvider) {
          openState.throwIfClosed();
          final refreshResult = await openState.wait(
            authKeyProvider.refreshAuthKey(),
          );
          if (refreshResult == RefreshAuthKeyResult.success) {
            return await _openMethodStream(connectionDetails, openState);
          }
        }
        rethrow;
      }
    } on _MethodStreamOpenCancelled {
      // The output listener cancelled before the method was sent.
      return;
    } finally {
      _pendingOpens.remove(openState);
      _tryCloseConnection();
    }
  }

  Future<void> _openMethodStream(
    MethodStreamConnectionDetails connectionDetails,
    _MethodStreamOpenState openState,
  ) async {
    // Resolve credentials before reserving a socket or sending the method.
    // Cancellation during credential lookup must not start a new method.
    connectionDetails.outputController.onCancel = openState.cancel;
    openState.throwIfClosed();
    final authentication = await openState.wait(
      connectionDetails.authKeyProvider?.authHeaderValue ??
          Future<String?>.value(),
    );

    if (_webSocket == null) {
      await openState.wait(_connectSynchronized(openState));
    }
    openState.throwIfClosed();
    final webSocket = _webSocket;
    if (webSocket == null) throw const WebSocketClosedException();

    var connectionId = const Uuid().v4obj();

    var inboundStreamKey = _buildStreamKey(
      connectionId: connectionId,
      endpoint: connectionDetails.endpoint,
      method: connectionDetails.method,
    );

    var parameterStreams = connectionDetails.parameterStreams.keys.toList();

    var inboundStreamContext = _InboundStreamContext(
      parameterStreams: parameterStreams,
      controller: connectionDetails.outputController,
    );

    _inboundStreams[inboundStreamKey] = inboundStreamContext;

    connectionDetails.outputController.onCancel = () async {
      openState.cancel();
      if (identical(_webSocket, webSocket)) {
        _addMessageToWebSocket(
          CloseMethodStreamCommand.buildMessage(
            connectionId: connectionId,
            endpoint: connectionDetails.endpoint,
            method: connectionDetails.method,
            reason: CloseReason.done,
          ),
        );
      }

      await _tryCloseInboundStream(
        endpoint: connectionDetails.endpoint,
        method: connectionDetails.method,
        connectionId: connectionId,
        reason: CloseReason.done,
      );
      _tryCloseConnection();
    };

    try {
      var openCommand = OpenMethodStreamCommand.buildMessage(
        connectionId: connectionId,
        endpoint: connectionDetails.endpoint,
        method: connectionDetails.method,
        args: connectionDetails.args,
        inputStreams: parameterStreams,
        authentication: authentication,
        authMode: connectionDetails.webAuthMode,
      );

      _addMessageToWebSocket(openCommand);
      final openResponse = await inboundStreamContext.openCompleter.future
          .timeout(
            _connectionTimeout,
            onTimeout: () => throw const ConnectionAttemptTimedOutException(),
          );

      if (openResponse != OpenMethodStreamResponseType.success) {
        throw OpenMethodStreamException(openResponse);
      }
      // An accepted method may already have finished or disconnected while
      // the opening caller was resuming. Its output owns that result.
      if (!identical(_inboundStreams[inboundStreamKey], inboundStreamContext) ||
          openState.isClosed) {
        return;
      }
    } catch (error) {
      _inboundStreams.remove(inboundStreamKey);
      // Keep observing cancellation while authentication is being refreshed.
      connectionDetails.outputController.onCancel = openState.cancel;
      try {
        if (error is ConnectionAttemptTimedOutException &&
            identical(_webSocket, webSocket)) {
          webSocket.sink.add(
            CloseMethodStreamCommand.buildMessage(
              connectionId: connectionId,
              endpoint: connectionDetails.endpoint,
              method: connectionDetails.method,
              reason: CloseReason.error,
            ),
          );
        }
      } on Object {
        // A socket that has already closed cannot receive cancellation.
        // Preserve the opening error while still releasing local resources.
      } finally {
        _tryCloseConnection();
      }
      rethrow;
    }

    _buildOutboundStreams(
      streams: connectionDetails.parameterStreams,
      connectionId: connectionId,
      endpoint: connectionDetails.endpoint,
      method: connectionDetails.method,
    );
  }

  void _tryCloseConnection() {
    if (_inboundStreams.isEmpty &&
        _outboundStreams.isEmpty &&
        !_pendingOpens.any((opening) => !opening.isClosed)) {
      unawaited(_closeConnectionIfUnused());
    }
  }

  /// Closes the websocket connection if no streams are using it.
  ///
  /// The emptiness check is repeated once the lock is acquired, since a new
  /// method stream may have been opened while this cleanup was waiting for
  /// the lock. In that case the connection must be kept open.
  Future<void> _closeConnectionIfUnused() async {
    await _lock.synchronized(() async {
      if (_inboundStreams.isNotEmpty ||
          _outboundStreams.isNotEmpty ||
          _pendingOpens.any((opening) => !opening.isClosed)) {
        return;
      }
      _cancelKeepAlive();
      var webSocket = _webSocket;
      _webSocket = null;
      await webSocket?.sink.close();
      await _webSocketListenerCompleter.future;
    });
  }

  /// Builds a unique key for a stream.
  String _buildStreamKey({
    required String endpoint,
    required String method,
    String? parameter,
    required UuidValue connectionId,
  }) =>
      '$connectionId:$endpoint:$method${parameter != null ? ':$parameter' : ''}';

  void _cancelKeepAlive() {
    _pingTimer?.cancel();
    _pingTimer = null;
    _idleTimeoutTimer?.cancel();
    _idleTimeoutTimer = null;
    _lastMessageReceivedAt = null;
  }

  /// Closes all streams and controllers.
  /// If an exception is provided, it will be added to the inbound stream
  /// controller.
  Future<void> _closeAllStreams([Object? exception]) async {
    final contexts = _inboundStreams.values.toList();
    _inboundStreams.clear();
    final inputControllers = <StreamController>[];
    for (final context in contexts) {
      if (context.opened) {
        inputControllers.add(context.controller);
      } else if (!context.openCompleter.isCompleted) {
        // Before acceptance, the opening caller owns error delivery.
        context.openCompleter.completeError(
          exception ?? const WebSocketClosedException(),
        );
      }
    }

    // Remove onCancel callbacks to prevent controllers from
    // sending a close command to the server.
    for (var c in inputControllers) {
      c.onCancel = null;
    }

    if (exception != null) {
      for (var c in inputControllers) {
        if (c.isClosed) continue;
        c.addError(exception);
      }
    }

    var outboundStreamSubscriptions = _outboundStreams.values
        .map((c) => c.subscription)
        .toList();
    _outboundStreams.clear();

    var closeSubscriptionsFutures = outboundStreamSubscriptions.map(
      (s) => s.cancel(),
    );

    await Future.wait([
      ...closeSubscriptionsFutures,
      _closeControllers(inputControllers),
    ]);
  }

  void _buildOutboundStreams({
    required Map<String, Stream<dynamic>> streams,
    required UuidValue connectionId,
    required String endpoint,
    required String method,
  }) {
    for (var MapEntry(key: streamName, value: stream) in streams.entries) {
      var streamKey = _buildStreamKey(
        connectionId: connectionId,
        endpoint: endpoint,
        method: method,
        parameter: streamName,
      );

      var subscription = stream.listen(
        (event) {
          var message = MethodStreamMessage.buildMessage(
            endpoint: endpoint,
            method: method,
            parameter: streamName,
            connectionId: connectionId,
            object: event,
            serializationManager: _serializationManager,
          );
          _addMessageToWebSocket(message);
        },
        onDone: () {
          var closeMessage = CloseMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            connectionId: connectionId,
            parameter: streamName,
            reason: CloseReason.done,
          );

          _addMessageToWebSocket(closeMessage);
          _outboundStreams.remove(streamKey);
        },
        onError: (e, stackTrace) async {
          if (e is SerializableException) {
            var message = MethodStreamSerializableException.buildMessage(
              endpoint: endpoint,
              method: method,
              parameter: streamName,
              connectionId: connectionId,
              object: e,
              serializationManager: _serializationManager,
            );
            _addMessageToWebSocket(message);
          }

          var closeMessage = CloseMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            connectionId: connectionId,
            parameter: streamName,
            reason: CloseReason.error,
          );

          _addMessageToWebSocket(closeMessage);
          _outboundStreams.remove(streamKey);
        },
        // Cancel on error prevents the stream from continuing after an exception
        // has been thrown. This is important since we want to close the stream
        // when an exception is thrown and handle the complete shutdown in the
        // onError callback.
        cancelOnError: true,
      );

      _outboundStreams[streamKey] = _OutboundStreamContext(
        subscription: subscription,
      );
    }
  }

  Future<void> _closeControllers(Iterable<StreamController> controllers) async {
    List<Future<void>> futures = [];
    // Close all controllers that have listeners.
    // If close is called on a controller that has no listeners, it will
    // return a future that never complete.
    var controllersToClose = controllers.where(
      (c) => c.hasListener && !c.isClosed,
    );

    for (var controller in controllersToClose) {
      // Paused streams will never process the close event and
      // will never complete. Therefore we need to add a timeout to complete
      // the future.
      futures.add(
        controller.close().timeout(
          const Duration(seconds: 6),
          onTimeout: () async => await controller.onCancel?.call(),
        ),
      );
    }

    await Future.wait(futures);
  }

  Future<void> _dispatchCloseMethodStreamCommand(
    CloseMethodStreamCommand message,
  ) async {
    if (message.parameter == null) {
      await _tryCloseInboundStream(
        endpoint: message.endpoint,
        method: message.method,
        connectionId: message.connectionId,
        reason: message.reason,
      );
    } else {
      await _tryCloseOutboundStream(message);
    }

    _tryCloseConnection();
  }

  Future<void> _tryCloseInboundStream({
    required String endpoint,
    required String method,
    required UuidValue connectionId,
    required CloseReason reason,
  }) async {
    var inboundStreamKey = _buildStreamKey(
      connectionId: connectionId,
      endpoint: endpoint,
      method: method,
    );

    var inboundStreamContext = _inboundStreams.remove(inboundStreamKey);
    if (inboundStreamContext == null) {
      return;
    }

    if (!inboundStreamContext.opened) {
      if (!inboundStreamContext.openCompleter.isCompleted) {
        inboundStreamContext.openCompleter.completeError(
          const ConnectionClosedException(),
        );
      }
      return;
    }

    // Remove the onCancel callback to prevent the controller from sending
    // a close message to the server.
    inboundStreamContext.controller.onCancel = null;

    if (reason == CloseReason.error &&
        !inboundStreamContext.controller.isClosed) {
      inboundStreamContext.controller.addError(
        const ConnectionClosedException(),
      );
    }

    var cancelSubscriptionFutures = <Future>[];
    for (var parameter in inboundStreamContext.parameterStreams) {
      var parameterStreamKey = _buildStreamKey(
        connectionId: connectionId,
        endpoint: endpoint,
        method: method,
        parameter: parameter,
      );

      var outboundStreamContext = _outboundStreams.remove(parameterStreamKey);
      if (outboundStreamContext == null) {
        continue;
      }

      cancelSubscriptionFutures.add(
        outboundStreamContext.subscription.cancel(),
      );
    }

    await Future.wait(
      [
        ...cancelSubscriptionFutures,
        _closeControllers([inboundStreamContext.controller]),
      ],
    );
  }

  Future<void> _tryCloseOutboundStream(
    CloseMethodStreamCommand message,
  ) async {
    var outboundStreamKey = _buildStreamKey(
      connectionId: message.connectionId,
      endpoint: message.endpoint,
      method: message.method,
      parameter: message.parameter,
    );

    var outboundStreamContext = _outboundStreams.remove(outboundStreamKey);
    if (outboundStreamContext == null) {
      return;
    }

    await outboundStreamContext.subscription.cancel();
  }

  bool _dispatchMessage(MethodStreamMessage message) {
    var inboundStreamKey = _buildStreamKey(
      connectionId: message.connectionId,
      endpoint: message.endpoint,
      method: message.method,
    );

    var inboundStreamContext = _inboundStreams[inboundStreamKey];
    if (inboundStreamContext == null ||
        inboundStreamContext.controller.isClosed) {
      return false;
    }

    inboundStreamContext.controller.add(message.object);
    return true;
  }

  void _dispatchMethodStreamResponse(OpenMethodStreamResponse message) {
    var inboundStreamKey = _buildStreamKey(
      connectionId: message.connectionId,
      endpoint: message.endpoint,
      method: message.method,
    );
    var inboundStreamContext = _inboundStreams[inboundStreamKey];
    if (inboundStreamContext == null) return;

    if (inboundStreamContext.openCompleter.isCompleted) return;

    // Record acceptance before completing the future: a close or disconnect
    // can follow immediately, before the opening caller resumes.
    inboundStreamContext.opened =
        message.responseType == OpenMethodStreamResponseType.success;
    inboundStreamContext.openCompleter.complete(message.responseType);
  }

  Future<void> _dispatchSerializableException(
    MethodStreamSerializableException message,
  ) async {
    var inboundStreamKey = _buildStreamKey(
      connectionId: message.connectionId,
      endpoint: message.endpoint,
      method: message.method,
    );

    var inboundStreamContext = _inboundStreams.remove(inboundStreamKey);
    if (inboundStreamContext == null) {
      return;
    }

    if (!inboundStreamContext.opened) {
      if (!inboundStreamContext.openCompleter.isCompleted) {
        inboundStreamContext.openCompleter.completeError(message.exception);
      }
      return;
    }

    if (!inboundStreamContext.controller.isClosed) {
      inboundStreamContext.controller.addError(message.exception);
    }
    await _closeControllers([inboundStreamContext.controller]);
  }

  Future<void> _listenToWebSocketStream(WebSocketChannel webSocket) async {
    final webSocketListenerCompleter = Completer();
    _webSocketListenerCompleter = webSocketListenerCompleter;
    MethodStreamException closeException = const WebSocketClosedException();
    try {
      await for (String jsonData in webSocket.stream) {
        _resetIdleTimeout();

        WebSocketMessage message;
        try {
          message = WebSocketMessage.fromJsonString(
            jsonData,
            _serializationManager,
          );
        } on UnknownMessageException catch (_) {
          _addMessageToWebSocket(BadRequestMessage.buildMessage(jsonData));
          rethrow;
        }

        switch (message) {
          case OpenMethodStreamResponse():
            _dispatchMethodStreamResponse(message);
          case OpenMethodStreamCommand():
            // Ignore
            break;
          case CloseMethodStreamCommand():
            unawaited(_dispatchCloseMethodStreamCommand(message));
            break;
          case PingCommand():
            _addMessageToWebSocket(PongCommand.buildMessage());
            break;
          case PongCommand():
            // Ignore
            break;
          case MethodStreamSerializableException():
            unawaited(_dispatchSerializableException(message));
            break;
          case MethodStreamMessage():
            var success = _dispatchMessage(message);
            if (success) break;

            _addMessageToWebSocket(
              CloseMethodStreamCommand.buildMessage(
                connectionId: message.connectionId,
                endpoint: message.endpoint,
                method: message.method,
                reason: CloseReason.error,
              ),
            );
            break;
          case BadRequestMessage():
            throw Exception(
              'Bad request message: $jsonData, closing connection',
            );
        }
      }
    } catch (e, s) {
      closeException = WebSocketListenException(e, s);

      /// Attempt to send close message to server if connection is still open.
      await webSocket.sink.close();
    } finally {
      if (!webSocketListenerCompleter.isCompleted) {
        webSocketListenerCompleter.complete();
      }

      /// Close any still open streams with an exception.
      await _cleanUpClosedConnection(webSocket, closeException);
    }
  }

  /// Cleans up after [webSocket]'s listener has stopped.
  ///
  /// If a new connection has already replaced [webSocket], the manager state
  /// (timers, streams and the current websocket) belongs to the new connection
  /// and must not be touched. Any streams that belonged to [webSocket] were
  /// already removed when it was torn down.
  Future<void> _cleanUpClosedConnection(
    WebSocketChannel webSocket,
    Object error,
  ) async {
    await _lock.synchronized(() async {
      if (_webSocket != null && !identical(_webSocket, webSocket)) return;
      _cancelKeepAlive();
      _webSocket = null;
      await _closeAllStreams(error);
      await webSocket.sink.close();
    });
  }

  Future<void> _connectSynchronized(_MethodStreamOpenState openState) async {
    await _lock.synchronized(() async {
      openState.throwIfClosed();
      if (_webSocket != null) return;

      var webSocket =
          _webSocketConnector?.call(_webSocketHost) ??
          WebSocketChannel.connect(_webSocketHost);

      await webSocket.ready
          .onError((e, s) => throw WebSocketConnectException(e, s))
          .timeout(
            _connectionTimeout,
            onTimeout: () {
              // Not awaited: the close future never completes before `ready`.
              unawaited(webSocket.sink.close());
              throw const ConnectionAttemptTimedOutException();
            },
          );

      // Method acceptance confirms liveness and authorization. A separate
      // startup ping would add a round trip before that request can be sent.
      _webSocket = webSocket;
      unawaited(_listenToWebSocketStream(webSocket));
      _startKeepAlive();
    });
  }

  void _addMessageToWebSocket(String message) {
    var webSocket = _webSocket;
    if (webSocket == null) {
      throw StateError(
        'Message posted when web socket connection is closed: $message',
      );
    }

    webSocket.sink.add(message);
  }

  void _startKeepAlive() {
    _pingTimer?.cancel();
    _idleTimeoutTimer?.cancel();
    _lastMessageReceivedAt = DateTime.now();

    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_webSocket == null) return;
      _addMessageToWebSocket(PingCommand.buildMessage());
    });

    _idleTimeoutTimer = Timer(_idleTimeout, _handleIdleTimeout);
  }

  void _resetIdleTimeout() {
    _lastMessageReceivedAt = DateTime.now();
    _idleTimeoutTimer?.cancel();
    _idleTimeoutTimer = Timer(_idleTimeout, _handleIdleTimeout);
  }

  void _handleIdleTimeout() {
    var lastMessageReceivedAt = _lastMessageReceivedAt;
    if (lastMessageReceivedAt == null) return;
    var elapsed = DateTime.now().difference(lastMessageReceivedAt);
    if (elapsed < _idleTimeout) {
      var remaining = _idleTimeout - elapsed;
      _idleTimeoutTimer?.cancel();
      _idleTimeoutTimer = Timer(remaining, _handleIdleTimeout);
      return;
    }

    unawaited(
      closeAllConnections(
        const MethodStreamIdleTimeoutException(),
      ),
    );
  }
}

class _MethodStreamOpenState {
  final _closed = Completer<void>();
  Object? _closeError;

  bool get isClosed => _closed.isCompleted;

  void cancel() => close(const _MethodStreamOpenCancelled());

  void close([Object? error]) {
    if (isClosed) return;
    _closeError = error ?? const WebSocketClosedException();
    _closed.complete();
  }

  void throwIfClosed() {
    if (isClosed) throw _closeError!;
  }

  Future<T> wait<T>(Future<T> operation) async {
    final result = await Future.any([
      operation,
      _closed.future.then<T>((_) => throw _closeError!),
    ]);
    // Closure may race with an operation whose result was already queued.
    throwIfClosed();
    return result;
  }
}

class _MethodStreamOpenCancelled implements Exception {
  const _MethodStreamOpenCancelled();
}

class _InboundStreamContext {
  bool opened = false;
  final StreamController controller;
  final List<String> parameterStreams;
  final Completer<OpenMethodStreamResponseType> openCompleter =
      Completer<OpenMethodStreamResponseType>();

  _InboundStreamContext({
    required this.controller,
    required this.parameterStreams,
  });
}

class _OutboundStreamContext {
  final StreamSubscription subscription;

  _OutboundStreamContext({required this.subscription});
}
