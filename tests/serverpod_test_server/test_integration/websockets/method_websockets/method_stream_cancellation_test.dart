import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/endpoints/method_streaming.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';

import '../websocket_extensions.dart';

void main() {
  late Serverpod server;

  setUpAll(() async {
    server = IntegrationTestServer.create();
    await server.startWithDatabase();
  });

  tearDownAll(() => server.shutdown(exitProcess: false));

  Future<_Connection> openConnection() async {
    final socket = await WebSocket.connect(
      Uri.parse(server.methodWebSocketUrl),
    );
    addTearDown(socket.tryClose);
    return _Connection(socket, server.serializationManager);
  }

  MethodStreamCancellationFixture registerFixture(
    String name, {
    bool holdCancellation = false,
  }) {
    final fixture = MethodStreamCancellationFixture(
      holdCancellation: holdCancellation,
    );
    MethodStreaming.streamCancellationFixtures[name] = fixture;
    addTearDown(() {
      if (!fixture.releaseCancellation.isCompleted) {
        fixture.releaseCancellation.complete();
      }
      MethodStreaming.streamCancellationFixtures.remove(name);
    });
    return fixture;
  }

  Future<_PausedStreamPair> openPausedStreamPair() async {
    final connection = await openConnection();
    final firstFixture = registerFixture('first');
    final secondFixture = registerFixture('second');
    final first = await connection.open('first');
    final second = await connection.open('second');
    connection.sendValue(first, 1);
    connection.sendValue(second, 1);
    await Future.wait([
      firstFixture.entered.future,
      secondFixture.entered.future,
    ]).timeout(const Duration(seconds: 5));
    return (
      connection: connection,
      first: first,
      second: second,
      firstFixture: firstFixture,
      secondFixture: secondFixture,
    );
  }

  group('Given two method streams with paused inputs on one socket,', () {
    late _PausedStreamPair streams;

    setUpAll(() async {
      streams = await openPausedStreamPair();
    });

    group(
      'when the input closes before the output,',
      () {
        late int firstSessionCloseCount;
        late bool secondProducerCancelled;
        late Object? secondValue;

        setUpAll(() async {
          final (:connection, :first, :second, :firstFixture, :secondFixture) =
              streams;
          connection.closeStream(first, parameter: 'input');
          connection.closeStream(first);
          await firstFixture.cancelled.future.timeout(
            const Duration(seconds: 2),
          );
          await firstFixture.sessionClosed.future.timeout(
            const Duration(seconds: 2),
          );
          final secondMessage = connection.receive<MethodStreamMessage>(
            (message) => message.connectionId == second,
          );
          secondFixture.output.add(2);
          secondValue = (await secondMessage).object;
          await connection.ping();
          firstSessionCloseCount = firstFixture.sessionCloseCount;
          secondProducerCancelled = secondFixture.cancelled.isCompleted;
        });

        test("then the first stream's session closes once.", () {
          expect(firstSessionCloseCount, 1);
        });

        test("then the second stream's producer stays active.", () {
          expect(secondProducerCancelled, isFalse);
        });

        test('then the second stream delivers another value.', () {
          expect(secondValue, 2);
        });
      },
    );
  });

  group('Given two method streams with paused inputs on one socket,', () {
    late _PausedStreamPair streams;

    setUpAll(() async {
      streams = await openPausedStreamPair();
    });

    group(
      'when the output closes before the input,',
      () {
        late int firstSessionCloseCount;
        late bool secondProducerCancelled;
        late Object? secondValue;

        setUpAll(() async {
          final (:connection, :first, :second, :firstFixture, :secondFixture) =
              streams;
          connection.closeStream(first);
          connection.closeStream(first, parameter: 'input');
          await firstFixture.cancelled.future.timeout(
            const Duration(seconds: 2),
          );
          await firstFixture.sessionClosed.future.timeout(
            const Duration(seconds: 2),
          );
          final secondMessage = connection.receive<MethodStreamMessage>(
            (message) => message.connectionId == second,
          );
          secondFixture.output.add(2);
          secondValue = (await secondMessage).object;
          await connection.ping();
          firstSessionCloseCount = firstFixture.sessionCloseCount;
          secondProducerCancelled = secondFixture.cancelled.isCompleted;
        });

        test("then the first stream's session closes once.", () {
          expect(firstSessionCloseCount, 1);
        });

        test("then the second stream's producer stays active.", () {
          expect(secondProducerCancelled, isFalse);
        });

        test('then the second stream delivers another value.', () {
          expect(secondValue, 2);
        });
      },
    );
  });

  group(
    'Given a producer whose cancellation is held beyond the close timeout,',
    () {
      late _Connection connection;
      late UuidValue first;
      late MethodStreamCancellationFixture fixture;

      setUpAll(() async {
        connection = await openConnection();
        fixture = registerFixture('first', holdCancellation: true);
        first = await connection.open('first');
        connection.sendValue(first, 1);
        await fixture.entered.future.timeout(const Duration(seconds: 5));
      });

      group(
        'when the output closes twice and cancellation is later released,',
        () {
          late bool respondedBeforeSessionClose;
          late bool releasedBeforeSessionClose;
          late int closesBeforeRelease;
          late int closesAfterRelease;

          setUpAll(() async {
            connection.closeStream(first);
            connection.closeStream(first);
            await fixture.cancelled.future.timeout(const Duration(seconds: 2));
            await connection.ping();
            respondedBeforeSessionClose = !fixture.sessionClosed.isCompleted;
            await fixture.sessionClosed.future.timeout(
              const Duration(seconds: 9),
            );
            releasedBeforeSessionClose =
                fixture.releaseCancellation.isCompleted;
            closesBeforeRelease = fixture.sessionCloseCount;
            fixture.releaseCancellation.complete();
            await fixture.output.close();
            closesAfterRelease = fixture.sessionCloseCount;
          });

          test('then socket commands continue while cancellation is held.', () {
            expect(respondedBeforeSessionClose, isTrue);
          });

          test(
            'then the timeout closes the session before releasing the producer.',
            () {
              expect(releasedBeforeSessionClose, isFalse);
            },
          );

          test('then the timeout closes the session once.', () {
            expect(closesBeforeRelease, 1);
          });

          test(
            'then repeated and late cancellation close the session only once.',
            () {
              expect(closesAfterRelease, 1);
            },
          );
        },
      );
    },
  );
}

typedef _PausedStreamPair = ({
  _Connection connection,
  UuidValue first,
  UuidValue second,
  MethodStreamCancellationFixture firstFixture,
  MethodStreamCancellationFixture secondFixture,
});

class _Connection {
  _Connection(this.socket, this.serializationManager);

  final WebSocket socket;
  final SerializationManager serializationManager;
  late final Stream<WebSocketMessage> _messages = socket.textEvents
      .map(
        (text) => WebSocketMessage.fromJsonString(text, serializationManager),
      )
      .asBroadcastStream();

  Future<T> receive<T extends WebSocketMessage>(
    bool Function(T) matches, {
    Duration timeout = const Duration(seconds: 2),
  }) => _messages
      .where((message) => message is T)
      .cast<T>()
      .firstWhere(matches)
      .timeout(timeout);

  Future<UuidValue> open(String name) async {
    final id = const Uuid().v4obj();
    final response = receive<OpenMethodStreamResponse>(
      (message) => message.connectionId == id,
      timeout: const Duration(seconds: 5),
    );
    socket.sendText(
      OpenMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'streamWithPausedInput',
        args: {'name': name},
        connectionId: id,
        inputStreams: ['input'],
      ),
    );
    final result = (await response).responseType;
    if (result != OpenMethodStreamResponseType.success) {
      throw StateError('Opening stream failed: $result');
    }
    return id;
  }

  void sendValue(UuidValue id, int value) {
    socket.sendText(
      MethodStreamMessage.buildMessage(
        endpoint: 'methodStreaming',
        method: 'streamWithPausedInput',
        parameter: 'input',
        connectionId: id,
        object: value,
        serializationManager: serializationManager,
      ),
    );
  }

  void closeStream(UuidValue id, {String? parameter}) {
    socket.sendText(
      CloseMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'streamWithPausedInput',
        parameter: parameter,
        connectionId: id,
        reason: CloseReason.done,
      ),
    );
  }

  Future<void> ping() async {
    final pong = receive<PongCommand>((_) => true);
    socket.sendText(PingCommand.buildMessage());
    await pong;
  }
}
