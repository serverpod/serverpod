// ignore_for_file: avoid_print

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';
import 'package:serverpod_client/src/method_stream/method_stream_manager_exceptions.dart';
import 'package:serverpod_client/src/util/lock.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Manages the connection to the server for method streams.
@internal
final class ClientMethodStreamManager {
  WebSocketChannel? _webSocket;
  final Uri _webSocketHost;
  Timer? _connectionTimer;
  Completer _handshakeComplete = Completer();
  final Duration _connectionTimeout;
  final SerializationManager _serializationManager;

  final Lock _lock = Lock();

  final Map<String, _InboundStreamContext> _inboundStreams = {};
  final Map<String, _OutboundStreamContext> _outboundStreams = {};

  ClientMethodStreamManager({
    required Duration connectionTimeout,
    required Uri webSocketHost,
    required SerializationManager serializationManager,
  })  : _webSocketHost = webSocketHost,
        _connectionTimeout = connectionTimeout,
        _serializationManager = serializationManager;

  void closeConnection() async {
    await _lock.synchronized(() async {
      await _closeAllStreams();
      await _webSocket?.sink.close();
      _webSocket = null;
      _cancelConnectionTimer();
    });
  }

  Future<void> openMethodStream(
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
      authentication: await connectionDetails.authenticationProvider.call(),
    );

    _webSocket?.sink.add(openCommand);
    var openResponse = await inboundStreamContext.openCompleter.future;

    if (openResponse != OpenMethodStreamResponseType.success) {
      throw OpenMethodStreamException(openResponse);
    }

    _buildOutboundStreams(
      streams: connectionDetails.parameterStreams,
      connectionId: connectionId,
      endpoint: connectionDetails.endpoint,
      method: connectionDetails.method,
    );
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

  Future<void> _closeAllStreams() async {
    var inputControllers =
        _inboundStreams.values.map((c) => c.controller).toList();
    _inboundStreams.clear();

    var outboundStreamSubscriptions =
        _outboundStreams.values.map((c) => c.subscription).toList();

    var closeSubscriptionsFutures =
        outboundStreamSubscriptions.map((s) => s.cancel());

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
          _webSocket?.sink.add(message);
        },
        onDone: () {
          var closeMessage = CloseMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            connectionId: connectionId,
            parameter: streamName,
            reason: CloseReason.done,
          );

          _webSocket?.sink.add(closeMessage);
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
            _webSocket?.sink.add(message);
          }

          var closeMessage = CloseMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: method,
            connectionId: connectionId,
            parameter: streamName,
            reason: CloseReason.error,
          );

          _webSocket?.sink.add(closeMessage);
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
    var controllersToClose =
        controllers.where((c) => c.hasListener && !c.isClosed);

    for (var controller in controllersToClose) {
      // Paused streams will never process the close event and
      // will never complete. Therefore we need add a timeout to complete the
      // future.
      futures.add(controller.close().timeout(
            const Duration(seconds: 6),
            onTimeout: () async => await controller.onCancel?.call(),
          ));
    }

    await Future.wait(futures);
  }

  Future<void> _dispatchCloseMethodStreamCommand(
    CloseMethodStreamCommand message,
  ) async {
    if (message.parameter == null) {
      await _tryCloseInboundStream(message);
    } else {
      await _tryCloseOutboundStream(message);
    }
  }

  Future<void> _tryCloseInboundStream(
    CloseMethodStreamCommand message,
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

    if (message.reason == CloseReason.error) {
      inboundStreamContext.controller.addError(
        const ServerpodClientException(
          'Stream closed with error reason',
          -1,
        ),
      );
    }

    var cancelSubscriptionFutures = <Future>[];
    for (var parameter in inboundStreamContext.parameterStreams) {
      var parameterStreamKey = _buildStreamKey(
        connectionId: message.connectionId,
        endpoint: message.endpoint,
        method: message.method,
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
        _closeControllers([inboundStreamContext.controller])
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
          _webSocket?.sink.add(BadRequestMessage.buildMessage(jsonData));
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
            _webSocket?.sink.add(PongCommand.buildMessage());
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

            _webSocket?.sink.add(
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
                'Bad request message: $jsonData, closing connection');
        }
      }
    } catch (e, s) {
      throw WebSocketListenException(e, s);
    } finally {
      closeConnection();
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

      await _handshakeComplete.future
          .catchError((e, s) => throw ConnectionAttemptTimedOutException());
      _webSocket = webSocket;
    });
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
