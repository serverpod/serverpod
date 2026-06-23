@OnPlatform({'browser': Skip('WebSocket tests are not supported in browser')})
library;

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'test_utils/method_stream_connection_details_builder.dart';

class TestSerializationManager extends SerializationManager {}

void main() {
  group(
    'Given a websocket connection whose stream closes asynchronously,',
    () {
      late final streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 10),
        webSocketHost: Uri.parse('ws://localhost:0'),
        serializationManager: TestSerializationManager(),
        webSocketConnector: (_) => _DelayedCloseWebSocketChannel(),
      );

      test(
        'when a second connection attempt starts before the first listener shuts down, '
        'then overlapping listener teardown does not throw a StateError.',
        () async {
          final asyncErrors = <Object>[];
          await runZonedGuarded(() async {
            final firstConnection = streamManager.openMethodStream(
              MethodStreamConnectionDetailsBuilder().build(),
            );
            final secondConnection = streamManager.openMethodStream(
              MethodStreamConnectionDetailsBuilder().build(),
            );

            await expectLater(
              firstConnection,
              throwsA(isA<ConnectionAttemptTimedOutException>()),
            );
            await expectLater(
              secondConnection,
              throwsA(isA<ConnectionAttemptTimedOutException>()),
            );

            await Future<void>.delayed(const Duration(milliseconds: 200));
          }, (error, _) => asyncErrors.add(error));

          expect(asyncErrors.whereType<StateError>(), isEmpty);
        },
      );
    },
  );
}

/// Keeps [stream] open briefly after [sink.close] to overlap listeners.
class _DelayedCloseWebSocketChannel
    with StreamChannelMixin
    implements WebSocketChannel {
  final _incoming = StreamController<String>();

  @override
  Stream get stream => _incoming.stream;

  @override
  late final WebSocketSink sink = _DelayedCloseWebSocketSink(_incoming);

  @override
  Future<void> get ready => Future<void>.value();

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;
}

class _DelayedCloseWebSocketSink implements WebSocketSink {
  _DelayedCloseWebSocketSink(this._incoming);

  final StreamController<String> _incoming;

  @override
  Future<void> get done => Future<void>.value();

  @override
  void add(data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<dynamic> stream) => stream.drain();

  @override
  Future<void> close([int? closeCode, String? closeReason]) {
    Timer(const Duration(milliseconds: 50), () {
      if (!_incoming.isClosed) {
        _incoming.close();
      }
    });
    return Future<void>.value();
  }
}
