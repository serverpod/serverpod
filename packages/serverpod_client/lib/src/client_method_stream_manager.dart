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
  /// The WebSocket channel used to communicate with the server.
  /// If null, no connection is open.
  WebSocketChannel? _webSocket;

  /// Completer that is completed when the WebSocket listener is done.
  Completer _webSocketListenerCompleter = Completer()..complete();

  /// The host of the WebSocket server.
  final Uri _webSocketHost;

  /// Timer used to cancel the connection attempt if it takes too long.
  /// If null, no connection attempt is in progress.
  Timer? _connectionTimer;

  /// Completer that is completed when the handshake is complete.
  Completer _handshakeComplete = Completer();

  /// The timeout for the connection attempt.
  final Duration _connectionTimeout;

  /// The serialization manager used to serialize and deserialize messages.
  final SerializationManager _serializationManager;

  /// Lock used to synchronize access when establishing websocket connection.
  final Lock _lock = Lock();

  /// A map of all inbound streams. These are streams that received messages
  /// from the server.
  final Map<String, _InboundStreamContext> _inboundStreams = {};

  /// A map of all outbound streams. These are streams that send messages to
  /// the server.
  final Map<String, _OutboundStreamContext> _outboundStreams = {};

  /// Creates a new [ClientMethodStreamManager].
  ClientMethodStreamManager({
    required Duration connectionTimeout,
    required Uri webSocketHost,
    required SerializationManager serializationManager,
  }) : _webSocketHost = webSocketHost,
       _connectionTimeout = connectionTimeout,
       _serializationManager = serializationManager;

  /// Closes all open connections and streams
  ///
  /// If an error is provided, it will be added to all inbound streams.
  Future<void> closeAllConnections([Object? error]) async {
    await _lock.synchronized(() async {
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
    try {
      return await _openMethodStream(connectionDetails);
    } on OpenMethodStreamException catch (e) {
      final authKeyProvider = connectionDetails.authKeyProvider;

      // A first failure here with 401 can be due to an access token expiration.
      // We will retry only once in such case, and only if the `authKeyProvider`
      // exposes a `refreshAuthKey` method (like JWT).
      if (e.responseType == OpenMethodStreamResponseType.authenticationFailed &&
          authKeyProvider is RefresherClientAuthKeyProvider) {
        final refreshResult = await authKeyProvider.refreshAuthKey();
        if (refreshResult == RefreshAuthKeyResult.success) {
          return _openMethodStream(connectionDetails);
        }
      }
      rethrow;
    }
  }

  Future<void> _openMethodStream(
    MethodStreamConnectionDetails connectionDetails,
  ) async {
    if (_webSocket == null) await _connectSynchronized();

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

    var openCommand = OpenMethodStreamCommand.buildMessage(
      connectionId: connectionId,
      endpoint: connectionDetails.endpoint,
      method: connectionDetails.method,
      args: connectionDetails.args,
      inputStreams: parameterStreams,
      authentication: await connectionDetails.authKeyProvider?.authHeaderValue,
    );

    _addMessageToWebSocket(openCommand);
    var openResponse = await inboundStreamContext.openCompleter.future;

    if (openResponse != OpenMethodStreamResponseType.success) {
      _inboundStreams.remove(inboundStreamKey);
      _tryCloseConnection();
      throw OpenMethodStreamException(openResponse);
    }

    connectionDetails.outputController.onCancel = () async {
      _addMessageToWebSocket(
        CloseMethodStreamCommand.buildMessage(
          connectionId: connectionId,
          endpoint: connectionDetails.endpoint,
          method: connectionDetails.method,
          reason: CloseReason.done,
        ),
      );

      await _tryCloseInboundStream(
        endpoint: connectionDetails.endpoint,
        method: connectionDetails.method,
        connectionId: connectionId,
        reason: CloseReason.done,
      );
      _tryCloseConnection();
    };

    _buildOutboundStreams(
      streams: connectionDetails.parameterStreams,
      connectionId: connectionId,
      endpoint: connectionDetails.endpoint,
      method: connectionDetails.method,
    );
  }

  void _tryCloseConnection() {
    if (_inboundStreams.isEmpty && _outboundStreams.isEmpty) {
      closeAllConnections();
    }
  }

  /// Builds a unique key for a stream.
  String _buildStreamKey({
    required String endpoint,
    required String method,
    String? parameter,
    required UuidValue connectionId,
  }) =>
      '$connectionId:$endpoint:$method${parameter != null ? ':$parameter' : ''}';

  void _cancelConnectionTimer() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
  }

  /// Closes all streams and controllers.
  /// If an exception is provided, it will be added to the inbound stream
  /// controller.
  Future<void> _closeAllStreams([Object? exception]) async {
    var inputControllers = _inboundStreams.values
        .map((c) => c.controller)
        .toList();
    _inboundStreams.clear();

    // Remove onCancel callbacks to prevent controllers from
    // sending a close command to the server.
    for (var c in inputControllers) {
      c.onCancel = null;
    }

    if (exception != null) {
      for (var c in inputControllers) {
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

    // Remove the onCancel callback to prevent the controller from sending
    // a close message to the server.
    inboundStreamContext.controller.onCancel = null;

    if (reason == CloseReason.error) {
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
    if (inboundStreamContext == null) {
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

    inboundStreamContext.controller.addError(message.exception);
    await _closeControllers([inboundStreamContext.controller]);
  }

  Future<void> _listenToWebSocketStream(WebSocketChannel webSocket) async {
    _webSocketListenerCompleter = Completer();
    MethodStreamException closeException = const WebSocketClosedException();
    try {
      await for (String jsonData in webSocket.stream) {
        if (!_handshakeComplete.isCompleted) {
          _handshakeComplete.complete();
        }

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
      _cancelConnectionTimer();
      _webSocketListenerCompleter.complete();

      /// Close any still open streams with an exception.
      await closeAllConnections(closeException);
    }
  }

  Future<void> _connectSynchronized() async {
    await _lock.synchronized(() async {
      if (_webSocket != null) return;

      var webSocket = WebSocketChannel.connect(_webSocketHost);

      await webSocket.ready.onError((e, s) {
        throw WebSocketConnectException(e, s);
      });

      webSocket.sink.add(PingCommand.buildMessage());
      _connectionTimer = Timer(_connectionTimeout, () {
        if (!_handshakeComplete.isCompleted) {
          webSocket.sink.close();
          _handshakeComplete.completeError('');
        }
      });

      _handshakeComplete = Completer();
      unawaited(_listenToWebSocketStream(webSocket));

      await _handshakeComplete.future.catchError(
        (e, s) => throw ConnectionAttemptTimedOutException(),
      );
      _webSocket = webSocket;
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
}

class _InboundStreamContext {
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
