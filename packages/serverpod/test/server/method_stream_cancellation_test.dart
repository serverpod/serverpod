import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

void main() {
  late Serverpod pod;
  late _Endpoints endpoints;
  late _Connection connection;

  setUp(() async {
    endpoints = _Endpoints();
    pod = Serverpod(
      [],
      internal.Protocol(),
      endpoints,
      config: ServerpodConfig(
        apiServer: ServerConfig(
          port: 0,
          publicHost: 'localhost',
          publicPort: 0,
          publicScheme: 'http',
        ),
        sessionLogs: SessionLogConfig(
          persistentEnabled: false,
          consoleEnabled: false,
          cleanupInterval: null,
          retentionPeriod: null,
          retentionCount: null,
        ),
      ),
    );
    await pod.start(runInGuardedZone: false);
    connection = _Connection(
      await WebSocket.connect('ws://127.0.0.1:${pod.server.port}/v1/websocket'),
      pod.serializationManager,
    );
  });

  tearDown(() async {
    for (final state in endpoints.states.values) {
      if (!state.releaseCancellation.isCompleted) {
        state.releaseCancellation.complete();
      }
    }
    await connection.socket.close();
    await pod.shutdown(exitProcess: false);
  });

  group('Given two method streams with paused inputs on one socket,', () {
    late UuidValue first;
    late UuidValue second;

    setUp(() async {
      first = await connection.open('first');
      second = await connection.open('second');
      connection.sendValue(first, 1);
      connection.sendValue(second, 1);
      await Future.wait(
        endpoints.states.values.map((state) => state.entered.future),
      );
    });

    test(
      'when the input closes before the output, '
      'then cancellation releases the input promptly and the other stream works.',
      () async {
        connection.closeStream(first, parameter: 'input');
        connection.closeStream(first);
        await endpoints.states['first']!.cancelled.future.timeout(
          const Duration(seconds: 2),
        );
        await endpoints.states['first']!.sessionClosed.future.timeout(
          const Duration(seconds: 2),
        );
        endpoints.states['second']!.output.add(2);
        await connection.secondValue.future.timeout(const Duration(seconds: 2));
        await connection.ping();

        expect(endpoints.states['first']!.sessionCloseCount, 1);
        expect(endpoints.states['second']!.cancelled.isCompleted, isFalse);
        expect(connection.secondValue.future, completion(2));
      },
    );

    test(
      'when the output closes before the input, '
      'then cancellation releases the input promptly and the other stream works.',
      () async {
        connection.closeStream(first);
        connection.closeStream(first, parameter: 'input');
        await endpoints.states['first']!.cancelled.future.timeout(
          const Duration(seconds: 2),
        );
        await endpoints.states['first']!.sessionClosed.future.timeout(
          const Duration(seconds: 2),
        );
        endpoints.states['second']!.output.add(2);
        await connection.secondValue.future.timeout(const Duration(seconds: 2));
        await connection.ping();

        expect(endpoints.states['first']!.sessionCloseCount, 1);
        expect(endpoints.states['second']!.cancelled.isCompleted, isFalse);
        expect(connection.secondValue.future, completion(2));
      },
    );
  });

  group(
    'Given a producer whose cancellation is held beyond the close timeout,',
    () {
      late UuidValue first;
      late _StreamState state;

      setUp(() async {
        state = _StreamState()..holdCancellation = true;
        endpoints.states['first'] = state;
        first = await connection.open('first');
        connection.sendValue(first, 1);
        await state.entered.future;
      });

      group(
        'when the output closes twice and cancellation is later released,',
        () {
          late bool releasedBeforeSessionClose;
          late int closesBeforeRelease;

          setUp(() async {
            connection.closeStream(first);
            connection.closeStream(first);
            await state.cancelled.future.timeout(const Duration(seconds: 2));
            await connection.ping();
            await state.sessionClosed.future.timeout(
              const Duration(seconds: 9),
            );
            releasedBeforeSessionClose = state.releaseCancellation.isCompleted;
            closesBeforeRelease = state.sessionCloseCount;
            state.releaseCancellation.complete();
            await state.output.close();
          });

          test('then socket commands continue while cancellation is held.', () {
            expect(connection.pong.isCompleted, isTrue);
          });

          test(
            'then the timeout closes the session before releasing the producer.',
            () {
              expect(releasedBeforeSessionClose, isFalse);
              expect(closesBeforeRelease, 1);
            },
          );

          test(
            'then repeated and late cancellation close the session only once.',
            () {
              expect(state.sessionCloseCount, 1);
            },
          );
        },
      );
    },
  );
}

class _Connection {
  _Connection(this.socket, this.serializationManager) {
    socket.listen((dynamic data) {
      final message = WebSocketMessage.fromJsonString(
        data as String,
        serializationManager,
      );
      if (message is OpenMethodStreamResponse) {
        opened[message.connectionId]!.complete(message.responseType);
      } else if (message is PongCommand && !pong.isCompleted) {
        pong.complete();
      } else if (message is MethodStreamMessage &&
          message.object == 2 &&
          !secondValue.isCompleted) {
        secondValue.complete(message.object as int);
      }
    });
  }

  final WebSocket socket;
  final SerializationManager serializationManager;
  final opened = <UuidValue, Completer<OpenMethodStreamResponseType>>{};
  final pong = Completer<void>();
  final secondValue = Completer<int>();

  Future<UuidValue> open(String name) async {
    final id = const Uuid().v4obj();
    final response = Completer<OpenMethodStreamResponseType>();
    opened[id] = response;
    socket.add(
      OpenMethodStreamCommand.buildMessage(
        endpoint: 'cancellation',
        method: 'stream',
        args: {'name': name},
        connectionId: id,
        inputStreams: ['input'],
      ),
    );
    final result = await response.future.timeout(const Duration(seconds: 5));
    if (result != OpenMethodStreamResponseType.success) {
      throw StateError('Opening stream failed: $result');
    }
    return id;
  }

  void sendValue(UuidValue id, int value) {
    socket.add(
      MethodStreamMessage.buildMessage(
        endpoint: 'cancellation',
        method: 'stream',
        parameter: 'input',
        connectionId: id,
        object: value,
        serializationManager: serializationManager,
      ),
    );
  }

  void closeStream(UuidValue id, {String? parameter}) {
    socket.add(
      CloseMethodStreamCommand.buildMessage(
        endpoint: 'cancellation',
        method: 'stream',
        parameter: parameter,
        connectionId: id,
        reason: CloseReason.done,
      ),
    );
  }

  Future<void> ping() async {
    socket.add(PingCommand.buildMessage());
    await pong.future.timeout(const Duration(seconds: 2));
  }
}

class _StreamState {
  final entered = Completer<void>();
  final cancelled = Completer<void>();
  final sessionClosed = Completer<void>();
  final releaseCancellation = Completer<void>();
  bool holdCancellation = false;
  int sessionCloseCount = 0;
  late StreamController<int> output;

  Stream<int> stream(Stream<int> input) {
    final iterator = StreamIterator(input);
    output = StreamController<int>(
      onListen: () async {
        await iterator.moveNext();
        entered.complete();
      },
      onCancel: () async {
        cancelled.complete();
        await iterator.cancel();
        if (holdCancellation) await releaseCancellation.future;
      },
    );
    return output.stream;
  }
}

class _Endpoint extends Endpoint {}

class _Endpoints extends EndpointDispatch {
  final states = <String, _StreamState>{};

  @override
  void initializeEndpoints(Server server) {
    final endpoint = _Endpoint()..initialize(server, 'cancellation', null);
    connectors['cancellation'] = EndpointConnector(
      name: 'cancellation',
      endpoint: endpoint,
      methodConnectors: {
        'stream': MethodStreamConnector(
          name: 'stream',
          params: {
            'name': ParameterDescription(
              name: 'name',
              type: getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {
            'input': StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            ),
          },
          returnType: MethodStreamReturnType.streamType,
          call: (session, params, streams) {
            final state = states.putIfAbsent(
              params['name'] as String,
              _StreamState.new,
            );
            session.addWillCloseListener((_) {
              state.sessionCloseCount++;
              if (!state.sessionClosed.isCompleted) {
                state.sessionClosed.complete();
              }
            });
            return state.stream(streams['input']!.cast<int>());
          },
        ),
      },
    );
  }
}
