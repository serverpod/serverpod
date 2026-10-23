@OnPlatform({'browser': Skip('WebSocket tests are not supported in browser')})
library;

import 'dart:async';
import 'dart:io';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';
import 'package:test/test.dart';

import '../test_utils/test_auth_key_providers.dart';

void main() {
  late _Server server;
  late ClientMethodStreamManager manager;

  setUp(() async {
    server = await _Server.start();
    manager = ClientMethodStreamManager(
      connectionTimeout: const Duration(seconds: 1),
      webSocketHost: server.uri,
      serializationManager: _Serialization(),
    );
  });

  tearDown(() async {
    await manager.closeAllConnections();
    await server.close();
  });

  test(
    'Given a server that answers method opens but ignores ping, '
    'when a fresh stream opens, '
    'then it opens without a separate ping handshake.',
    () async {
      final call = _call();
      final opened = manager.openMethodStream(call);

      final request = await server.nextOpen.future;
      server.accept(request);
      await opened;
      final commands = List.of(server.messages);

      expect(commands.whereType<OpenMethodStreamCommand>(), hasLength(1));
      expect(commands.whereType<PingCommand>(), isEmpty);
    },
  );

  test(
    'Given queued input and a server withholding method acceptance, '
    'when the method is accepted, '
    'then input starts only after acceptance.',
    () async {
      final input = StreamController<int>()..add(42);
      final call = _call(input: input.stream);
      final opened = manager.openMethodStream(call);

      final request = await server.nextOpen.future;
      final before = List.of(server.messages);
      server.accept(request);
      await opened;
      final received = await server.nextData.future;
      await input.close();

      expect(before.whereType<MethodStreamMessage>(), isEmpty);
      expect(received.object, 42);
    },
  );

  test(
    'Given a server withholding method acceptance, '
    'when the opening deadline expires, '
    'then opening fails and its unused socket closes.',
    () async {
      final failure = _errorOf(manager.openMethodStream(_call()));

      await server.nextOpen.future;
      final error = await failure;
      await server.firstClosed.future.timeout(const Duration(seconds: 2));

      expect(error, isA<ConnectionAttemptTimedOutException>());
      expect(server.messages.whereType<PingCommand>(), isEmpty);
    },
  );

  test(
    'Given a server closing before method acceptance, '
    'when the socket closes, '
    'then opening fails promptly and another call can connect.',
    () async {
      final failure = _errorOf(manager.openMethodStream(_call()));
      final request = await server.nextOpen.future;

      await request.socket.close();
      final error = await failure;
      server.nextOpen = Completer<_Open>();
      final next = manager.openMethodStream(_call());
      final nextRequest = await server.nextOpen.future;
      server.accept(nextRequest);
      await next;

      expect(error, isA<WebSocketClosedException>());
      expect(server.connections, 2);
    },
  );

  test(
    'Given two methods opening on the same fresh socket, '
    'when one times out and the other is accepted, '
    'then the accepted method stays usable.',
    () async {
      final input = StreamController<int>();
      final stalled = _errorOf(
        manager.openMethodStream(_call(method: 'stalled')),
      );
      final ready = manager.openMethodStream(_call(input: input.stream));

      await server.twoOpens.future;
      final accepted = server.opens.singleWhere(
        (r) => r.command.method == 'stream',
      );
      server.accept(accepted);
      await ready;
      final error = await stalled;
      input.add(7);
      final received = await server.nextData.future;
      await input.close();

      expect(error, isA<ConnectionAttemptTimedOutException>());
      expect(received.object, 7);
      expect(server.connections, 1);
      expect(server.firstClosed.isCompleted, isFalse);
    },
  );

  test(
    'Given queued input for a method rejected by the server, '
    'when its opening response denies authorization, '
    'then opening fails without consuming the input.',
    () async {
      var listened = false;
      final input = StreamController<int>(onListen: () => listened = true)
        ..add(3);
      final failure = _errorOf(
        manager.openMethodStream(_call(input: input.stream)),
      );

      final request = await server.nextOpen.future;
      server.respond(
        request,
        OpenMethodStreamResponseType.authorizationDeclined,
      );
      final error = await failure;
      final wasListened = listened;
      // Consume the unused test input so its controller can close.
      final drained = input.stream.drain<void>();
      await input.close();
      await drained;

      expect(error, isA<OpenMethodStreamException>());
      expect(wasListened, isFalse);
      expect(server.messages.whereType<MethodStreamMessage>(), isEmpty);
    },
  );
  test(
    'Given a method that the server accepts and immediately completes, '
    'when the opening call resumes, '
    'then opening succeeds and the output finishes without an error.',
    () async {
      final output = StreamController<int>();
      final values = output.stream.toList();
      final opened = manager.openMethodStream(_call(output: output));
      final request = await server.nextOpen.future;

      server.accept(request);
      request.socket.add(
        CloseMethodStreamCommand.buildMessage(
          connectionId: request.command.connectionId,
          endpoint: request.command.endpoint,
          method: request.command.method,
          reason: CloseReason.done,
        ),
      );
      await opened;
      final result = await values;

      expect(result, isEmpty);
    },
  );

  test(
    'Given a method awaiting acceptance, '
    'when all connections are closed, '
    'then opening fails and its caller retains ownership of the output.',
    () async {
      final errors = <Object>[];
      final output = StreamController<int>();
      output.stream.listen((_) {}, onError: errors.add);
      final failure = _errorOf(manager.openMethodStream(_call(output: output)));
      await server.nextOpen.future;

      await manager.closeAllConnections();
      final error = await failure;
      final outputClosed = output.isClosed;
      await output.close();

      expect(error, isA<WebSocketClosedException>());
      expect(errors, isEmpty);
      expect(outputClosed, isFalse);
    },
  );

  test(
    'Given a method awaiting acceptance, '
    'when the server closes the method, '
    'then opening fails without waiting for its deadline.',
    () async {
      final failure = _errorOf(manager.openMethodStream(_call()));
      final request = await server.nextOpen.future;

      request.socket.add(
        CloseMethodStreamCommand.buildMessage(
          connectionId: request.command.connectionId,
          endpoint: request.command.endpoint,
          method: request.command.method,
          reason: CloseReason.error,
        ),
      );
      final error = await failure;
      await server.firstClosed.future;

      expect(error, isA<ConnectionClosedException>());
    },
  );

  test(
    'Given a method awaiting acceptance with queued input, '
    'when its output subscription is cancelled, '
    'then opening stops without consuming the input.',
    () async {
      var listened = false;
      final input = StreamController<int>(onListen: () => listened = true)
        ..add(3);
      final output = StreamController<int>();
      final subscription = output.stream.listen((_) {});
      final failure = _errorOf(
        manager.openMethodStream(_call(input: input.stream, output: output)),
      );
      await server.nextOpen.future;

      await subscription.cancel();
      final error = await failure;
      final wasListened = listened;
      await server.firstClosed.future;
      final drained = input.stream.drain<void>();
      await input.close();
      await drained;

      expect(error, isA<ConnectionClosedException>());
      expect(wasListened, isFalse);
      expect(server.messages.whereType<MethodStreamMessage>(), isEmpty);
    },
  );

  test(
    'Given a failing credential provider, '
    'when a method is opened, '
    'then the credential error propagates without reserving a socket.',
    () async {
      final expected = StateError('Credentials unavailable');
      final provider = _DeferredAuthKeyProvider();
      final failure = _errorOf(
        manager.openMethodStream(_call(authKeyProvider: provider)),
      );

      provider.value.completeError(expected);
      final error = await failure;

      expect(error, same(expected));
      expect(server.connections, 0);
    },
  );

  test(
    'Given a pending credential lookup, '
    'when the output is cancelled before credentials arrive, '
    'then no socket is opened after the lookup completes.',
    () async {
      final provider = _DeferredAuthKeyProvider();
      final output = StreamController<int>();
      final subscription = output.stream.listen((_) {});
      final opened = manager.openMethodStream(
        _call(authKeyProvider: provider, output: output),
      );

      await subscription.cancel();
      provider.value.complete('Bearer test');
      await opened;

      expect(server.connections, 0);
    },
  );

  test(
    'Given expired credentials and queued input, '
    'when authentication refresh succeeds, '
    'then only the accepted retry consumes input and no startup ping is sent.',
    () async {
      final provider = TestRefresherAuthKeyProvider()..setAuthKey('expired');
      provider.setRefresh(() {
        provider.setAuthKey('refreshed');
        return RefreshAuthKeyResult.success;
      });
      final input = StreamController<int>()..add(42);
      final opened = manager.openMethodStream(
        _call(authKeyProvider: provider, input: input.stream),
      );
      final first = await server.nextOpen.future;
      server.nextOpen = Completer<_Open>();

      server.respond(first, OpenMethodStreamResponseType.authenticationFailed);
      final retry = await server.nextOpen.future;
      final before = List.of(server.messages);
      server.accept(retry);
      await opened;
      final value = await server.nextData.future;
      await input.close();

      expect(provider.refreshCallCount, 1);
      expect(retry.command.authentication, 'Bearer refreshed');
      expect(before.whereType<MethodStreamMessage>(), isEmpty);
      expect(value.object, 42);
      expect(server.messages.whereType<PingCommand>(), isEmpty);
    },
  );

  test(
    'Given a method awaiting acceptance and an application exception, '
    'when the server sends that exception, '
    'then opening fails with the exception and releases the socket.',
    () async {
      final failure = _errorOf(manager.openMethodStream(_call()));
      final request = await server.nextOpen.future;

      request.socket.add(
        MethodStreamSerializableException.buildMessage(
          connectionId: request.command.connectionId,
          endpoint: request.command.endpoint,
          method: request.command.method,
          object: _TestException(),
          serializationManager: _Serialization(),
        ),
      );
      final error = await failure;
      await server.firstClosed.future;

      expect(error, isA<_TestException>());
    },
  );

  test(
    'Given an accepted method on a reusable socket, '
    'when a second method receives no acceptance response, '
    'then the second open times out while the first remains usable.',
    () async {
      final input = StreamController<int>();
      final peer = manager.openMethodStream(_call(input: input.stream));
      server.accept(await server.nextOpen.future);
      await peer;
      server.nextOpen = Completer<_Open>();

      final failure = _errorOf(
        manager.openMethodStream(_call(method: 'stalled')),
      );
      final request = await server.nextOpen.future;
      final error = await failure;
      final close = await server.nextClose.future;
      input.add(8);
      final value = await server.nextData.future;
      await input.close();

      expect(error, isA<ConnectionAttemptTimedOutException>());
      expect(close.connectionId, request.command.connectionId);
      expect(close.reason, CloseReason.error);
      expect(value.object, 8);
      expect(server.connections, 1);
      expect(server.firstClosed.isCompleted, isFalse);
    },
  );

  test(
    'Given authentication refresh waiting for credentials, '
    'when the output is cancelled before refresh completes, '
    'then the method is not retried.',
    () async {
      final provider = TestRefresherAuthKeyProvider()..setAuthKey('expired');
      final refreshing = Completer<void>();
      final refreshed = Completer<RefreshAuthKeyResult>();
      provider.setRefresh(() {
        refreshing.complete();
        return refreshed.future;
      });
      final output = StreamController<int>();
      final subscription = output.stream.listen((_) {});
      final opened = manager.openMethodStream(
        _call(authKeyProvider: provider, output: output),
      );
      final first = await server.nextOpen.future;
      server.respond(first, OpenMethodStreamResponseType.authenticationFailed);
      await refreshing.future;

      await subscription.cancel();
      refreshed.complete(RefreshAuthKeyResult.success);
      await opened;

      expect(server.opens, hasLength(1));
      expect(provider.refreshCallCount, 1);
    },
  );

  group(
    'Given a timed-out method and an accepted peer on the same socket,',
    () {
      late _Open expired;
      late StreamController<int> unusedInput;
      late StreamController<int> peerInput;
      late bool inputListened;

      setUp(() async {
        inputListened = false;
        unusedInput = StreamController<int>(
          onListen: () => inputListened = true,
        );
        peerInput = StreamController<int>();
        final stalled = _errorOf(
          manager.openMethodStream(
            _call(method: 'expired', input: unusedInput.stream),
          ),
        );
        final peer = manager.openMethodStream(_call(input: peerInput.stream));
        await server.twoOpens.future;
        expired = server.opens.singleWhere(
          (r) => r.command.method == 'expired',
        );
        server.accept(
          server.opens.singleWhere((r) => r.command.method == 'stream'),
        );
        await peer;
        await stalled;
        await server.nextClose.future;
        server.nextClose = Completer<CloseMethodStreamCommand>();
      });

      tearDown(() async {
        final drained = unusedInput.stream.drain<void>();
        await unusedInput.close();
        await drained;
        await peerInput.close();
      });

      test(
        'when late acceptance and data arrive for the expired method, '
        'then the expired method stays closed and the peer remains usable.',
        () async {
          server.accept(expired);
          expired.socket.add(
            MethodStreamMessage.buildMessage(
              connectionId: expired.command.connectionId,
              endpoint: expired.command.endpoint,
              method: expired.command.method,
              object: 9,
              serializationManager: _Serialization(),
            ),
          );
          final close = await server.nextClose.future;
          peerInput.add(7);
          final value = await server.nextData.future;

          expect(close.connectionId, expired.command.connectionId);
          expect(close.reason, CloseReason.error);
          expect(inputListened, isFalse);
          expect(value.object, 7);
          expect(server.connections, 1);
          expect(server.firstClosed.isCompleted, isFalse);
        },
      );
    },
  );
}

MethodStreamConnectionDetails _call({
  Stream<int>? input,
  String method = 'stream',
  ClientAuthKeyProvider? authKeyProvider,
  StreamController<int>? output,
}) {
  if (output == null) {
    output = StreamController<int>();
    output.stream.listen((_) {}, onError: (Object _) {});
  }
  addTearDown(output.close);
  return MethodStreamConnectionDetails(
    endpoint: 'example',
    method: method,
    args: {},
    authKeyProvider: authKeyProvider,
    parameterStreams: {'events': ?input},
    outputController: output,
  );
}

Future<Object?> _errorOf(Future<void> future) async {
  try {
    await future;
    return null;
  } on Object catch (error) {
    return error;
  }
}

class _Open {
  _Open(this.socket, this.command);

  final WebSocket socket;
  final OpenMethodStreamCommand command;
}

class _Server {
  _Server(this.server) {
    server.listen((request) async {
      final socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      socket.listen(
        (data) {
          final message = WebSocketMessage.fromJsonString(
            data as String,
            _Serialization(),
          );
          messages.add(message);
          if (message is OpenMethodStreamCommand) {
            final request = _Open(socket, message);
            opens.add(request);
            if (!nextOpen.isCompleted) nextOpen.complete(request);
            if (opens.length == 2) twoOpens.complete();
          } else if (message is CloseMethodStreamCommand &&
              !nextClose.isCompleted) {
            nextClose.complete(message);
          } else if (message is MethodStreamMessage && !nextData.isCompleted) {
            nextData.complete(message);
          }
        },
        onDone: () {
          if (!firstClosed.isCompleted) firstClosed.complete();
        },
      );
    });
  }

  static Future<_Server> start() async =>
      _Server(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));

  final HttpServer server;
  final sockets = <WebSocket>[];
  final messages = <WebSocketMessage>[];
  final opens = <_Open>[];
  Completer<_Open> nextOpen = Completer<_Open>();
  final twoOpens = Completer<void>();
  final nextData = Completer<MethodStreamMessage>();
  var nextClose = Completer<CloseMethodStreamCommand>();
  final firstClosed = Completer<void>();

  int get connections => sockets.length;

  Uri get uri => Uri.parse('ws://127.0.0.1:${server.port}');

  void accept(_Open request) =>
      respond(request, OpenMethodStreamResponseType.success);

  void respond(_Open request, OpenMethodStreamResponseType type) {
    request.socket.add(
      OpenMethodStreamResponse.buildMessage(
        connectionId: request.command.connectionId,
        endpoint: request.command.endpoint,
        method: request.command.method,
        responseType: type,
      ),
    );
  }

  Future<void> close() async {
    await Future.wait(sockets.map((socket) => socket.close()));
    await server.close(force: true);
  }
}

class _Serialization extends SerializationManager {
  @override
  String? getClassNameForObject(Object? data) {
    if (data is _TestException) return 'TestException';
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'TestException') return _TestException();
    return super.deserializeByClassName(data);
  }
}

class _TestException extends SerializableException {}

class _DeferredAuthKeyProvider implements ClientAuthKeyProvider {
  final value = Completer<String?>();

  @override
  Future<String?> get authHeaderValue => value.future;
}
