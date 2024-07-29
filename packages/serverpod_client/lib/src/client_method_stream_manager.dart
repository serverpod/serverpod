// ignore_for_file: avoid_print

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';
import 'package:serverpod_client/src/method_stream/method_stream_manager_exceptions.dart';
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

  final Map<String, _InboundStreamContext> _inboundStreams = {};

  ClientMethodStreamManager({
    required Duration connectionTimeout,
    required Uri webSocketHost,
    required SerializationManager serializationManager,
  })  : _webSocketHost = webSocketHost,
        _connectionTimeout = connectionTimeout,
        _serializationManager = serializationManager;

  void closeConnection() async {
    await _closeAllStreams();
    await _webSocket?.sink.close();
    _webSocket = null;
    _cancelConnectionTimer();
  }

  Future<void> openMethodStream(
    MethodStreamConnectionDetails connectionDetails,
  ) async {
    await _tryConnect();

    var connectionId = const Uuid().v4obj();

    var inboundStreamKey = _buildStreamKey(
      connectionId: connectionId,
      endpoint: connectionDetails.endpoint,
      method: connectionDetails.method,
    );
    var inboundStreamContext = _InboundStreamContext(
      controller: connectionDetails.outputController,
    );

    _inboundStreams[inboundStreamKey] = inboundStreamContext;

    var openCommand = OpenMethodStreamCommand.buildMessage(
      connectionId: connectionId,
      endpoint: connectionDetails.endpoint,
      method: connectionDetails.method,
      args: connectionDetails.args,
      inputStreams:
          connectionDetails.parameterStreams.keys.map((key) => key).toList(),
      authentication: await connectionDetails.authenticationProvider.call(),
    );

    _webSocket?.sink.add(openCommand);
    var openResponse = await inboundStreamContext.openCompleter.future;

    if (openResponse != OpenMethodStreamResponseType.success) {
      throw OpenMethodStreamException(openResponse);
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

  Future<void> _closeAllStreams() async {
    var inputControllers =
        _inboundStreams.values.map((c) => c.controller).toList();
    _inboundStreams.clear();

    await _closeControllers(inputControllers);
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

    await _closeControllers([inboundStreamContext.controller]);
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

  Future<void> _listenToWebSocketStream() async {
    var webSocket = _webSocket;
    if (webSocket == null) {
      return;
    }

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

  Future<void> _tryConnect() async {
    // TODO: Ensure this section is not run in parallel.
    if (_webSocket != null) {
      return;
    }

    var webSocket = WebSocketChannel.connect(_webSocketHost);
    _webSocket = webSocket;
    //  End of section that should not be run in parallel.

    await webSocket.ready.onError((e, s) {
      _webSocket = null;
      throw WebSocketConnectException(e, s);
    });

    webSocket.sink.add(PingCommand.buildMessage());
    _connectionTimer = Timer(_connectionTimeout, () {
      if (!_handshakeComplete.isCompleted) {
        _webSocket?.sink.close();
        _webSocket = null;
        _handshakeComplete.completeError('');
      }
    });

    _handshakeComplete = Completer();
    unawaited(_listenToWebSocketStream());

    await _handshakeComplete.future.onError(
      (e, s) => throw ConnectionAttemptTimedOutException(),
    );
  }
}

class _InboundStreamContext {
  final StreamController controller;
  final Completer<OpenMethodStreamResponseType> openCompleter =
      Completer<OpenMethodStreamResponseType>();

  _InboundStreamContext({
    required this.controller,
  });
}
