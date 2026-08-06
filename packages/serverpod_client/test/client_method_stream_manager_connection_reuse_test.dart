@OnPlatform({'browser': Skip('WebSocket tests are not supported in browser')})
library;

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'test_utils/method_stream_connection_details_builder.dart';

void main() {
  group('Given a connected method stream that the server closes,', () {
    late List<_FakeServerWebSocketChannel> channels;
    late ClientMethodStreamManager streamManager;

    setUp(() {
      channels = [];
      streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(seconds: 1),
        webSocketHost: Uri.parse('ws://localhost:0'),
        serializationManager: TestSerializationManager(),
        webSocketConnector: (_) {
          var channel = _FakeServerWebSocketChannel(
            closeDelay: const Duration(milliseconds: 20),
          );
          channels.add(channel);
          return channel;
        },
      );
    });

    Future<void> openAndAwaitServerClose() async {
      var firstStream = MethodStreamConnectionDetailsBuilder().build();
      var firstStreamDone = Completer<void>();
      firstStream.outputController.stream.listen(
        (_) {},
        onDone: firstStreamDone.complete,
      );
      await streamManager.openMethodStream(firstStream);

      var openCommand = channels.single.lastOpenCommand!;
      channels.single.receiveFromServer(
        CloseMethodStreamCommand.buildMessage(
          connectionId: openCommand.connectionId,
          endpoint: openCommand.endpoint,
          method: openCommand.method,
          reason: CloseReason.done,
        ),
      );
      await firstStreamDone.future;
    }

    Future<List<Object>> openSecondStream() async {
      var secondStream = MethodStreamConnectionDetailsBuilder().build();
      var secondStreamErrors = <Object>[];
      secondStream.outputController.stream.listen(
        (_) {},
        onError: secondStreamErrors.add,
      );
      await streamManager
          .openMethodStream(secondStream)
          .timeout(const Duration(seconds: 5));
      return secondStreamErrors;
    }

    test(
      'when a new method stream is opened immediately after the first closes, '
      'then the new stream opens cleanly.',
      () async {
        var asyncErrors = <Object>[];
        var zoneDone = Completer<void>();
        // The body's future must not be awaited: if it fails, the error is
        // routed to the zone handler and the future never completes.
        unawaited(
          runZonedGuarded(() async {
            try {
              await openAndAwaitServerClose();

              var secondStreamErrors = await openSecondStream();

              // Let the previous connection finish any pending teardown before
              // verifying that it did not affect the new stream.
              await Future<void>.delayed(const Duration(milliseconds: 100));
              expect(secondStreamErrors, isEmpty);

              await streamManager.closeAllConnections();
            } finally {
              zoneDone.complete();
            }
          }, (error, _) => asyncErrors.add(error)),
        );

        await zoneDone.future;
        expect(asyncErrors, isEmpty);
      },
    );

    test(
      'when a new method stream is opened while the unused websocket is still tearing down, '
      "then the new stream opens on a fresh connection that is unaffected by the old connection's cleanup.",
      () async {
        var asyncErrors = <Object>[];
        var zoneDone = Completer<void>();
        // The body's future must not be awaited: if it fails, the error is
        // routed to the zone handler and the future never completes.
        unawaited(
          runZonedGuarded(() async {
            try {
              await openAndAwaitServerClose();

              // Wait until the manager has started closing the now-unused
              // websocket, but before its listener has finished winding down.
              await channels.single.sinkClosed.future.timeout(
                const Duration(seconds: 5),
              );

              var secondStreamErrors = await openSecondStream();
              expect(channels, hasLength(2));

              await Future<void>.delayed(const Duration(milliseconds: 100));
              expect(secondStreamErrors, isEmpty);

              await streamManager.closeAllConnections();
            } finally {
              zoneDone.complete();
            }
          }, (error, _) => asyncErrors.add(error)),
        );

        await zoneDone.future;
        expect(asyncErrors, isEmpty);
      },
    );
  });
}

/// Acts as a minimal method-stream server: completes the ping handshake and
/// accepts every open command. Keeps its stream open for [closeDelay] after
/// the sink is closed, mimicking a websocket whose listener winds down
/// asynchronously.
class _FakeServerWebSocketChannel
    with StreamChannelMixin
    implements WebSocketChannel {
  _FakeServerWebSocketChannel({this.closeDelay = Duration.zero});

  final Duration closeDelay;

  /// Completes when the client closes its side of the connection.
  final sinkClosed = Completer<void>();

  /// The last open command received from the client.
  OpenMethodStreamCommand? lastOpenCommand;

  final _incoming = StreamController<String>();
  final _serializationManager = TestSerializationManager();

  /// Injects [message] as if the server had sent it.
  void receiveFromServer(String message) {
    if (!_incoming.isClosed) _incoming.add(message);
  }

  void _handleClientMessage(String data) {
    var message = WebSocketMessage.fromJsonString(data, _serializationManager);
    if (message is PingCommand) {
      receiveFromServer(PongCommand.buildMessage());
    } else if (message is OpenMethodStreamCommand) {
      lastOpenCommand = message;
      receiveFromServer(
        OpenMethodStreamResponse.buildMessage(
          connectionId: message.connectionId,
          endpoint: message.endpoint,
          method: message.method,
          responseType: OpenMethodStreamResponseType.success,
        ),
      );
    }
  }

  @override
  Stream get stream => _incoming.stream;

  @override
  late final WebSocketSink sink = _FakeServerWebSocketSink(this);

  @override
  Future<void> get ready => Future<void>.value();

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;
}

class _FakeServerWebSocketSink implements WebSocketSink {
  _FakeServerWebSocketSink(this._channel);

  final _FakeServerWebSocketChannel _channel;

  @override
  Future<void> get done => Future<void>.value();

  @override
  void add(data) => _channel._handleClientMessage(data as String);

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) => stream.drain();

  @override
  Future<void> close([int? closeCode, String? closeReason]) {
    if (!_channel.sinkClosed.isCompleted) {
      _channel.sinkClosed.complete();
    }
    Timer(_channel.closeDelay, () {
      if (!_channel._incoming.isClosed) {
        _channel._incoming.close();
      }
    });
    return Future<void>.value();
  }
}

class TestSerializationManager extends SerializationManager {}
