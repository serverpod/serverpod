import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_client/serverpod_client.dart'
    show
        ClientAuthKeyProvider,
        ConnectionAttemptTimedOutException,
        ConnectionClosedException,
        RefreshAuthKeyResult,
        RefresherClientAuthKeyProvider,
        ServerpodClientForbidden,
        ServerpodClientUnauthorized,
        WebSocketClosedException;
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart'
    show Client, ExceptionWithData;
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

const _deadline = Duration(seconds: 5);
const _shortOpenTimeout = Duration(seconds: 1);
const _socketCloseTimeout = Duration(seconds: 2);

void main() {
  late Serverpod server;

  setUpAll(() async {
    server = IntegrationTestServer.create(
      authenticationHandler: (session, token) async => switch (token) {
        'admin' => AuthenticationInfo('1', {Scope.admin}, authId: 'admin'),
        'member' => AuthenticationInfo('2', {}, authId: 'member'),
        _ => null,
      },
    );
    await server.startWithDatabase();
  });

  tearDownAll(() => server.shutdown(exitProcess: false));

  Future<_WebSocketRelay> openWire({
    bool Function(WebSocketMessage)? hold,
  }) async {
    final wire = await _WebSocketRelay.start(server, hold: hold);
    addTearDown(wire.close);
    return wire;
  }

  group('Given a relay that withholds pong frames,', () {
    late _WebSocketRelay wire;
    late Client client;

    setUpAll(() async {
      wire = await openWire(hold: (message) => message is PongCommand);
      client = _client(wire);
    });

    group(
      'when the client opens a stream on a fresh WebSocket,',
      () {
        late List<Object> values;
        late int opens;
        late int pings;

        setUpAll(() async {
          values = await _events(client.methodStreaming.intStreamFromValue(2));
          await wire.firstClosed;
          opens = wire.opens.length;
          pings = wire.sent.whereType<PingCommand>().length;
        });

        test('then the caller receives the complete result.', () {
          expect(values, [0, 1]);
        });

        test('then the client sends one open command.', () {
          expect(opens, 1);
        });

        test('then the client sends no startup ping.', () {
          expect(pings, 0);
        });
      },
    );
  });

  group('Given queued input and a client waiting for method acceptance,', () {
    late _WebSocketRelay wire;
    late _Input input;
    late Future<List<Object>> output;
    late _Frame acceptance;

    setUpAll(() async {
      wire = await openWire(
        hold: (message) => message is OpenMethodStreamResponse,
      );
      final client = _client(wire);
      input = _Input(42);
      output = _events(client.methodStreaming.intEchoStream(input.stream));
      acceptance = await wire.fromServer<OpenMethodStreamResponse>();
    });

    group('when the acceptance response reaches the client,', () {
      late bool subscribedEarly;
      late List<Object> values;

      setUpAll(() async {
        subscribedEarly = input.listened;
        acceptance.forward();
        values = await output;
      });

      test('then the client did not subscribe before acceptance.', () {
        expect(subscribedEarly, isFalse);
      });

      test('then the caller receives the echoed value and completion.', () {
        expect(values, [42]);
      });
    });
  });

  group('Given a streaming call whose acceptance response is withheld,', () {
    late _WebSocketRelay wire;
    late Future<List<Object>> output;

    setUpAll(() async {
      wire = await openWire(
        hold: (message) => message is OpenMethodStreamResponse,
      );
      final client = _client(wire, openTimeout: _shortOpenTimeout);
      output = _events(
        client.methodStreaming.intEchoStream(const Stream.empty()),
      );
      await wire.fromServer<OpenMethodStreamResponse>();
    });

    group('when the acceptance deadline expires,', () {
      late List<Object> events;
      late bool closed;

      setUpAll(() async {
        events = await output;
        closed = await wire.firstSocketClosesWithin(_socketCloseTimeout);
      });

      test('then the output reports one timeout and ends.', () {
        expect(events, [isA<ConnectionAttemptTimedOutException>()]);
      });

      test('then the unused socket closes.', () {
        expect(closed, isTrue);
      });
    });
  });

  group('Given a call waiting for acceptance on a WebSocket,', () {
    late _WebSocketRelay wire;
    late Client client;
    late Future<List<Object>> output;

    setUpAll(() async {
      wire = await openWire(
        hold: (message) =>
            message is OpenMethodStreamResponse &&
            message.method == 'intEchoStream',
      );
      client = _client(wire, openTimeout: const Duration(seconds: 10));
      output = _events(
        client.methodStreaming.intEchoStream(const Stream.empty()),
      );
      await wire.fromServer<OpenMethodStreamResponse>();
    });

    group('when the socket disconnects and the client makes another call,', () {
      late List<Object> failedEvents;
      late List<Object> newEvents;
      late int sockets;

      setUpAll(() async {
        await wire.connections.single.downstream.close();
        failedEvents = await output;
        newEvents = await _events(client.methodStreaming.intStreamFromValue(1));
        sockets = wire.connections.length;
      });

      test(
        'then the first output promptly reports the WebSocket error and ends.',
        () {
          expect(failedEvents, [isA<WebSocketClosedException>()]);
        },
      );

      test('then the next call receives its result.', () {
        expect(newEvents, [0]);
      });

      test('then the next call uses a fresh socket.', () {
        expect(sockets, 2);
      });
    });
  });

  group('Given two methods opening on one fresh WebSocket,', () {
    late _WebSocketRelay wire;
    late StreamController<int> input;
    late Future<List<Object>> stalled;
    late Future<List<Object>> accepted;

    setUpAll(() async {
      wire = await openWire(
        hold: (message) =>
            message is OpenMethodStreamResponse &&
            message.endpoint == 'authenticatedMethodStreaming',
      );
      final client = _client(
        wire,
        token: _Credentials('admin'),
        openTimeout: _shortOpenTimeout,
      );
      input = _inputController();
      stalled = _events(
        client.authenticatedMethodStreaming.intEchoStream(const Stream.empty()),
      );
      accepted = _events(client.methodStreaming.intEchoStream(input.stream));
      await wire.fromServer<OpenMethodStreamResponse>(
        (message) => message.endpoint == 'authenticatedMethodStreaming',
      );
      await wire.fromServer<OpenMethodStreamResponse>(
        (message) => message.endpoint == 'methodStreaming',
      );
    });

    group('when one acceptance response is withheld until its deadline,', () {
      late List<Object> stalledEvents;
      late List<Object> acceptedEvents;
      late bool socketRemainedOpen;
      late int sockets;

      setUpAll(() async {
        stalledEvents = await stalled;
        socketRemainedOpen = !wire.connections.single.closed.isCompleted;
        input.add(7);
        unawaited(input.close());
        acceptedEvents = await accepted;
        sockets = wire.connections.length;
      });

      test('then only the stalled call reports a timeout and ends.', () {
        expect(stalledEvents, [isA<ConnectionAttemptTimedOutException>()]);
      });

      test('then the accepted call can still exchange data.', () {
        expect(acceptedEvents, [7]);
      });

      test('then both calls used one socket.', () {
        expect(sockets, 1);
      });

      test('then the timeout left the socket open for the other call.', () {
        expect(socketRemainedOpen, isTrue);
      });
    });
  });

  group(
    'Given a signed-in user without the required scope and queued input,',
    () {
      late _WebSocketRelay wire;
      late Client client;
      late _Input input;

      setUpAll(() async {
        wire = await openWire();
        client = _client(wire, token: _Credentials('member'));
        input = _Input(3);
      });

      group('when the server denies authorization for the streaming call,', () {
        late List<Object> events;
        late bool subscribed;
        late List<MethodStreamMessage> sent;

        setUpAll(() async {
          events = await _events(
            client.authenticatedMethodStreaming.intEchoStream(input.stream),
          );
          await wire.firstClosed;
          subscribed = input.listened;
          sent = wire.sent.whereType<MethodStreamMessage>().toList();
        });

        test(
          'then the caller receives one forbidden error and the output ends.',
          () {
            expect(events, [isA<ServerpodClientForbidden>()]);
          },
        );

        test('then the client does not subscribe to the input.', () {
          expect(subscribed, isFalse);
        });

        test('then the client sends no input values.', () {
          expect(sent, isEmpty);
        });
      });
    },
  );

  group('Given a streaming endpoint that produces no values,', () {
    late Client client;

    setUpAll(() async {
      client = Client(server.apiUrl);
      addTearDown(client.close);
    });

    group(
      'when the client calls the endpoint and the server accepts and completes it,',
      () {
        late List<Object> events;

        setUpAll(() async {
          events = await _events(client.methodStreaming.intStreamFromValue(0));
        });

        test('then the output ends without values or errors.', () {
          expect(events, isEmpty);
        });
      },
    );
  });

  group(
    'Given a manager waiting for acceptance with a caller-owned output controller,',
    () {
      late Future<void> Function() closeConnections;
      late StreamController<int> output;
      late Future<Object?> openingFailure;
      late List<Object> errors;

      setUpAll(() async {
        final wire = await openWire(hold: (_) => true);
        // This test exercises the internal output ownership contract.
        // ignore: invalid_use_of_internal_member
        final manager = ClientMethodStreamManager(
          connectionTimeout: const Duration(seconds: 10),
          webSocketHost: wire.host.replace(scheme: 'ws', path: '/v1/websocket'),
          serializationManager: server.serializationManager,
        );
        closeConnections = manager.closeAllConnections;
        addTearDown(closeConnections);
        errors = [];
        output = StreamController<int>();
        output.stream.listen((_) {}, onError: errors.add);
        addTearDown(output.close);
        openingFailure = manager
            .openMethodStream(
              MethodStreamConnectionDetails(
                endpoint: 'methodStreaming',
                method: 'intStreamFromValue',
                args: {'value': 0},
                parameterStreams: {},
                authKeyProvider: null,
                outputController: output,
              ),
            )
            .then<Object?>((_) => null, onError: (Object error) => error)
            .timeout(_deadline);
        await wire.fromServer<OpenMethodStreamResponse>();
      });

      group('when the manager closes all connections,', () {
        late Object? failure;
        late List<Object> outputErrors;
        late bool outputClosed;

        setUpAll(() async {
          await closeConnections();
          failure = await openingFailure;
          outputErrors = List.of(errors);
          outputClosed = output.isClosed;
        });

        test('then the opening future receives the connection error.', () {
          expect(failure, isA<WebSocketClosedException>());
        });

        test('then the manager leaves error delivery to the caller.', () {
          expect(outputErrors, isEmpty);
        });

        test('then the output controller is still open for the caller.', () {
          expect(outputClosed, isFalse);
        });
      });
    },
  );

  group('Given a public streaming call waiting for acceptance,', () {
    late Client client;
    late Future<List<Object>> output;

    setUpAll(() async {
      final wire = await openWire(
        hold: (message) => message is OpenMethodStreamResponse,
      );
      client = _client(wire, openTimeout: const Duration(seconds: 10));
      output = _events(
        client.methodStreaming.intEchoStream(const Stream.empty()),
      );
      await wire.fromServer<OpenMethodStreamResponse>();
    });

    group('when the caller closes all streaming connections,', () {
      late List<Object> events;

      setUpAll(() async {
        await client.closeStreamingMethodConnections();
        events = await output;
      });

      test(
        'then the output promptly receives one connection error and ends.',
        () {
          expect(events, [isA<WebSocketClosedException>()]);
        },
      );
    });
  });

  group('Given a streaming call whose acceptance response is delayed,', () {
    late _WebSocketRelay wire;
    late Future<List<Object>> output;
    late _Frame close;

    setUpAll(() async {
      wire = await openWire(
        hold: (message) =>
            message is OpenMethodStreamResponse ||
            message is CloseMethodStreamCommand,
      );
      final client = _client(wire, openTimeout: const Duration(seconds: 10));
      output = _events(client.methodStreaming.outStreamThrowsException());
      await wire.fromServer<OpenMethodStreamResponse>();
      close = await wire.fromServer<CloseMethodStreamCommand>(
        (message) => message.parameter == null,
      );
    });

    group('when the server close arrives ahead of acceptance,', () {
      late List<Object> events;
      late bool closed;

      setUpAll(() async {
        close.forward();
        events = await output;
        closed = await wire.firstSocketClosesWithin(_socketCloseTimeout);
      });

      test(
        'then the caller receives one connection error before the deadline and the output ends.',
        () {
          expect(events, [isA<ConnectionClosedException>()]);
        },
      );

      test('then the unused socket closes.', () {
        expect(closed, isTrue);
      });
    });
  });

  group(
    'Given a streaming call whose acceptance and application exception are held,',
    () {
      late _WebSocketRelay wire;
      late Future<List<Object>> output;
      late _Frame exception;

      setUpAll(() async {
        wire = await openWire(
          hold: (message) =>
              message is OpenMethodStreamResponse ||
              message is MethodStreamSerializableException ||
              message is CloseMethodStreamCommand,
        );
        final client = _client(wire, openTimeout: const Duration(seconds: 10));
        output = _events(
          client.methodStreaming.outStreamThrowsSerializableException(),
        );
        await wire.fromServer<OpenMethodStreamResponse>();
        exception = await wire.fromServer<MethodStreamSerializableException>();
      });

      group('when the application exception arrives ahead of acceptance,', () {
        late List<Object> events;
        late bool closed;

        setUpAll(() async {
          exception.forward();
          events = await output;
          closed = await wire.firstSocketClosesWithin(_socketCloseTimeout);
        });

        test(
          'then the caller receives the serialized application exception once and the output ends.',
          () {
            expect(events, [isA<ExceptionWithData>()]);
          },
        );

        test('then the unused socket closes.', () {
          expect(closed, isTrue);
        });
      });
    },
  );

  group('Given a streaming call waiting for acceptance with queued input,', () {
    late _WebSocketRelay wire;
    late _Input input;
    late StreamSubscription<int> subscription;
    late OpenMethodStreamCommand open;

    setUpAll(() async {
      wire = await openWire(
        hold: (message) => message is OpenMethodStreamResponse,
      );
      final client = _client(wire);
      input = _Input(3);
      subscription = client.methodStreaming
          .intEchoStream(input.stream)
          .listen((_) {});
      addTearDown(subscription.cancel);
      await wire.fromServer<OpenMethodStreamResponse>();
      open = wire.opens.single;
    });

    group('when the caller cancels the output before acceptance,', () {
      late CloseMethodStreamCommand close;
      late bool closed;
      late bool subscribed;
      late List<MethodStreamMessage> sent;

      setUpAll(() async {
        await subscription.cancel();
        close = await wire.fromClient<CloseMethodStreamCommand>(
          (message) => message.connectionId == open.connectionId,
        );
        closed = await wire.firstSocketClosesWithin(_socketCloseTimeout);
        subscribed = input.listened;
        sent = wire.sent.whereType<MethodStreamMessage>().toList();
      });

      test('then the close command targets the cancelled method.', () {
        expect(close.connectionId, open.connectionId);
      });

      test('then the close command reports ordinary cancellation.', () {
        expect(close.reason, CloseReason.done);
      });

      test('then the unused socket closes.', () {
        expect(closed, isTrue);
      });

      test('then the client does not subscribe to the input.', () {
        expect(subscribed, isFalse);
      });

      test('then the client sends no input values.', () {
        expect(sent, isEmpty);
      });
    });
  });

  group('Given a credential provider that cannot return credentials,', () {
    late _WebSocketRelay wire;
    late Client client;
    late _DeferredCredentials credentials;

    setUpAll(() async {
      wire = await openWire();
      credentials = _DeferredCredentials();
      client = _client(wire, token: credentials);
    });

    group('when a method call encounters the credential error,', () {
      late StateError error;
      late List<Object> events;
      late int sockets;

      setUpAll(() async {
        error = StateError('Credentials unavailable');
        final output = _events(client.methodStreaming.intStreamFromValue(1));
        await credentials.requested.future.timeout(_deadline);
        credentials.result.completeError(error);
        events = await output;
        sockets = wire.connections.length;
      });

      test(
        'then the output reports the original credential error and ends.',
        () {
          expect(events, [same(error)]);
        },
      );

      test('then the client does not open a socket.', () {
        expect(sockets, 0);
      });
    });
  });

  group('Given a streaming call awaiting credentials with queued input,', () {
    late _WebSocketRelay wire;
    late Client client;
    late _DeferredCredentials credentials;
    late _Input input;
    late StreamSubscription<int> subscription;

    setUpAll(() async {
      wire = await openWire();
      credentials = _DeferredCredentials();
      client = _client(wire, token: credentials);
      input = _Input(42);
      subscription = client.methodStreaming
          .intEchoStream(input.stream)
          .listen((_) {});
      addTearDown(subscription.cancel);
      await credentials.requested.future.timeout(_deadline);
    });

    group(
      'when the caller cancels before the credentials arrive and then makes a new call,',
      () {
        late List<Object> values;
        late List<String> methods;
        late int sockets;
        late bool subscribed;

        setUpAll(() async {
          await subscription.cancel();
          credentials.result.complete('Bearer admin');
          values = await _events(client.methodStreaming.intStreamFromValue(1));
          await wire.firstClosed;
          methods = wire.methods;
          sockets = wire.connections.length;
          subscribed = input.listened;
        });

        test('then only the new call reaches the server.', () {
          expect(methods, ['intStreamFromValue']);
        });

        test('then only the new call opens a socket.', () {
          expect(sockets, 1);
        });

        test('then the cancelled input stays untouched.', () {
          expect(subscribed, isFalse);
        });

        test('then the new call receives its result.', () {
          expect(values, [0]);
        });
      },
    );
  });

  group('Given a streaming call with queued input waiting for credentials,', () {
    late _WebSocketRelay wire;
    late Client client;
    late _DeferredCredentials credentials;
    late _Input input;
    late Future<List<Object>> output;

    setUpAll(() async {
      wire = await openWire();
      credentials = _DeferredCredentials();
      client = _client(wire, token: credentials);
      input = _Input(42);
      output = _events(client.methodStreaming.intEchoStream(input.stream));
      await credentials.requested.future.timeout(_deadline);
    });

    group(
      'when all connections close before credentials arrive and the client makes a new call,',
      () {
        late List<Object> failedEvents;
        late List<Object> newEvents;
        late List<String> methods;
        late int socketsBeforeRelease;
        late bool subscribed;

        setUpAll(() async {
          await client.closeStreamingMethodConnections();
          failedEvents = await output;
          socketsBeforeRelease = wire.connections.length;
          credentials.result.complete('Bearer admin');
          newEvents = await _events(
            client.methodStreaming.intStreamFromValue(1),
          );
          await wire.firstClosed;
          methods = wire.methods;
          subscribed = input.listened;
        });

        test(
          'then the first output receives one connection error and ends before credentials arrive.',
          () {
            expect(failedEvents, [isA<WebSocketClosedException>()]);
          },
        );

        test('then no sockets were opened before credentials arrived.', () {
          expect(socketsBeforeRelease, 0);
        });

        test('then only the new call reaches the server.', () {
          expect(methods, ['intStreamFromValue']);
        });

        test('then the first input is never consumed.', () {
          expect(subscribed, isFalse);
        });

        test('then the new call receives its result.', () {
          expect(newEvents, [0]);
        });
      },
    );
  });

  group(
    'Given a rejected streaming call whose credential refresh is pending,',
    () {
      late _WebSocketRelay wire;
      late _RefreshingCredentials credentials;
      late Future<List<Object>> output;

      setUpAll(() async {
        wire = await openWire();
        credentials = _RefreshingCredentials();
        final client = _client(wire, token: credentials);
        output = _events(client.authenticatedMethodStreaming.simpleStream());
        await credentials.requested.future.timeout(_deadline);
      });

      group(
        'when the caller waits for the socket to close before completing refresh,',
        () {
          late bool closedBeforeRefresh;
          late List<Object> events;

          setUpAll(() async {
            closedBeforeRefresh = await wire.firstSocketClosesWithin(
              _socketCloseTimeout,
            );
            credentials.result.complete(RefreshAuthKeyResult.failedOther);
            events = await output;
          });

          test('then the client closes the unused socket during refresh.', () {
            expect(closedBeforeRefresh, isTrue);
          });

          test(
            'then the caller receives one unauthorized error and the output ends.',
            () {
              expect(events, [isA<ServerpodClientUnauthorized>()]);
            },
          );
        },
      );
    },
  );

  group(
    'Given a rejected streaming call with expired credentials and queued input,',
    () {
      late _WebSocketRelay wire;
      late _RefreshingCredentials credentials;
      late _Input input;
      late Future<List<Object>> output;

      setUpAll(() async {
        wire = await openWire(
          hold: (message) =>
              message is OpenMethodStreamResponse &&
              message.responseType == OpenMethodStreamResponseType.success,
        );
        credentials = _RefreshingCredentials();
        final client = _client(wire, token: credentials);
        input = _Input(42);
        output = _events(
          client.authenticatedMethodStreaming.intEchoStream(input.stream),
        );
        await credentials.requested.future.timeout(_deadline);
      });

      group('when refresh succeeds and the server accepts the retry,', () {
        late int refreshes;
        late List<String?> authHeaders;
        late bool subscribedEarly;
        late List<Object> values;

        setUpAll(() async {
          await wire.firstClosed;
          credentials.succeed();
          final response = await wire.fromServer<OpenMethodStreamResponse>(
            (message) =>
                message.responseType == OpenMethodStreamResponseType.success,
          );
          subscribedEarly = input.listened;
          response.forward();
          values = await output;
          authHeaders = wire.opens.map((open) => open.authentication).toList();
          refreshes = credentials.refreshes;
        });

        test('then the client refreshes credentials once.', () {
          expect(refreshes, 1);
        });

        test('then the retry uses the refreshed credentials.', () {
          expect(authHeaders, ['Bearer expired', 'Bearer admin']);
        });

        test(
          'then the client does not subscribe before the retry is accepted.',
          () {
            expect(subscribedEarly, isFalse);
          },
        );

        test('then the caller receives the echoed value and completion.', () {
          expect(values, [42]);
        });
      });
    },
  );

  group('Given a rejected streaming call awaiting credential refresh,', () {
    late _WebSocketRelay wire;
    late Client client;
    late _RefreshingCredentials credentials;
    late StreamSubscription<int> subscription;

    setUpAll(() async {
      wire = await openWire();
      credentials = _RefreshingCredentials();
      client = _client(wire, token: credentials);
      subscription = client.authenticatedMethodStreaming.simpleStream().listen(
        (_) {},
      );
      addTearDown(subscription.cancel);
      await credentials.requested.future.timeout(_deadline);
    });

    group(
      'when the caller cancels before refresh succeeds and then makes a new call,',
      () {
        late List<Object> values;
        late List<String> methods;
        late int refreshes;

        setUpAll(() async {
          await subscription.cancel();
          credentials.succeed();
          values = await _events(client.methodStreaming.intStreamFromValue(1));
          methods = wire.methods;
          refreshes = credentials.refreshes;
        });

        test('then the cancelled call is never retried.', () {
          expect(methods, ['simpleStream', 'intStreamFromValue']);
        });

        test('then there is only one refresh.', () {
          expect(refreshes, 1);
        });

        test('then the new call receives its result.', () {
          expect(values, [0]);
        });
      },
    );
  });

  group('Given a rejected streaming call with a pending refresh,', () {
    late _WebSocketRelay wire;
    late Client client;
    late _RefreshingCredentials credentials;
    late Future<List<Object>> output;

    setUpAll(() async {
      wire = await openWire();
      credentials = _RefreshingCredentials();
      client = _client(wire, token: credentials);
      output = _events(client.authenticatedMethodStreaming.simpleStream());
      await credentials.requested.future.timeout(_deadline);
    });

    group(
      'when the caller closes all connections before refresh succeeds and then makes a new call,',
      () {
        late List<Object> failedEvents;
        late List<Object> newEvents;
        late List<String> methods;

        setUpAll(() async {
          await client.closeStreamingMethodConnections();
          failedEvents = await output;
          credentials.succeed();
          newEvents = await _events(
            client.methodStreaming.intStreamFromValue(1),
          );
          methods = wire.methods;
        });

        test(
          'then the first output receives one connection error and ends before refresh completes.',
          () {
            expect(failedEvents, [isA<WebSocketClosedException>()]);
          },
        );

        test('then the first call is never retried.', () {
          expect(methods, ['simpleStream', 'intStreamFromValue']);
        });

        test('then the new call receives its result.', () {
          expect(newEvents, [0]);
        });
      },
    );
  });

  group('Given a timed-out method and an accepted peer on the same socket,', () {
    late _WebSocketRelay wire;
    late StreamController<int> peerInput;
    late Future<List<Object>> peerOutput;
    late _Input stalledInput;
    late List<Object> stalledEvents;
    late UuidValue stalledId;
    late CloseMethodStreamCommand timeoutClose;
    late _Frame acceptance;
    late _Frame data;

    setUpAll(() async {
      const stalledMethod = 'directOneIntReturnWithStreamInput';
      wire = await openWire(
        hold: (message) =>
            message is WebSocketMessageInfo &&
            (message as WebSocketMessageInfo).method == stalledMethod,
      );
      final client = _client(wire, openTimeout: _shortOpenTimeout);
      peerInput = _inputController();
      peerOutput = _events(
        client.methodStreaming.intEchoStream(peerInput.stream),
      );
      await wire.fromServer<OpenMethodStreamResponse>();
      stalledInput = _Input(42);
      // Keep the output stream observable after its startup error. The generated
      // endpoint exposes this single server result as a Future<int>.
      final stalled = _events(
        client.callStreamingServerEndpoint<Stream<int>, int>(
              'methodStreaming',
              stalledMethod,
              {},
              {'stream': stalledInput.stream},
            )
            as Stream<int>,
      );
      acceptance = await wire.fromServer<OpenMethodStreamResponse>(
        (message) => message.method == stalledMethod,
      );
      stalledId = (acceptance.message as OpenMethodStreamResponse).connectionId;
      data = await wire.fromServer<MethodStreamMessage>(
        (message) => message.connectionId == stalledId,
      );
      stalledEvents = await stalled;
      timeoutClose = await wire.fromClient<CloseMethodStreamCommand>(
        (message) => message.connectionId == stalledId,
      );
    });

    group(
      'when late acceptance and data are delivered for the timed-out method,',
      () {
        late CloseMethodStreamCommand lateDataClose;
        late bool listened;
        late List<Object> values;
        late bool socketRemainedOpen;
        late int sockets;

        setUpAll(() async {
          final checkpoint = wire.sent.length;
          acceptance.forward();
          data.forward();
          lateDataClose = await wire.fromClient<CloseMethodStreamCommand>(
            (message) => message.connectionId == stalledId,
            after: checkpoint,
          );
          listened = stalledInput.listened;
          socketRemainedOpen = !wire.connections.single.closed.isCompleted;
          peerInput.add(7);
          unawaited(peerInput.close());
          values = await peerOutput;
          sockets = wire.connections.length;
        });

        test('then the stalled output already ended with one timeout.', () {
          expect(stalledEvents, [isA<ConnectionAttemptTimedOutException>()]);
        });

        test('then the timeout sends an error close for that method.', () {
          expect(timeoutClose.reason, CloseReason.error);
        });

        test('then the client rejects the late data for that method.', () {
          expect(lateDataClose.reason, CloseReason.error);
        });

        test('then the timed-out input was never consumed.', () {
          expect(listened, isFalse);
        });

        test('then the peer still delivers its result.', () {
          expect(values, [7]);
        });

        test('then the peer keeps the original socket open.', () {
          expect(socketRemainedOpen, isTrue);
        });

        test('then both methods used one socket.', () {
          expect(sockets, 1);
        });
      },
    );
  });
}

Client _client(
  _WebSocketRelay wire, {
  ClientAuthKeyProvider? token,
  Duration openTimeout = _deadline,
}) {
  final client = Client(
    wire.host.toString(),
    streamingConnectionTimeout: openTimeout,
  )..authKeyProvider = token;
  addTearDown(() async {
    await client.closeStreamingMethodConnections();
    client.close();
  });
  return client;
}

Future<List<Object>> _events(Stream<int> output) => output
    .transform(
      StreamTransformer<int, Object>.fromHandlers(
        handleError: (error, _, sink) => sink.add(error),
      ),
    )
    .toList()
    .timeout(_deadline);

StreamController<int> _inputController() {
  final input = StreamController<int>();
  addTearDown(() => unawaited(input.close()));
  return input;
}

class _Input {
  _Input(this.value);

  final int value;
  bool listened = false;

  late final stream = Stream<int>.multi((controller) {
    listened = true;
    controller.add(value);
    controller.close();
  });
}

class _Credentials implements ClientAuthKeyProvider {
  _Credentials(this.token);

  String token;

  @override
  Future<String?> get authHeaderValue async => 'Bearer $token';
}

class _DeferredCredentials implements ClientAuthKeyProvider {
  final requested = Completer<void>();
  final result = Completer<String?>();

  @override
  Future<String?> get authHeaderValue {
    if (!requested.isCompleted) requested.complete();
    return result.future;
  }
}

class _RefreshingCredentials extends _Credentials
    implements RefresherClientAuthKeyProvider {
  _RefreshingCredentials() : super('expired');

  final requested = Completer<void>();
  final result = Completer<RefreshAuthKeyResult>();
  int refreshes = 0;

  @override
  Future<RefreshAuthKeyResult> refreshAuthKey({bool force = false}) {
    refreshes++;
    if (!requested.isCompleted) requested.complete();
    return result.future;
  }

  void succeed() {
    token = 'admin';
    result.complete(RefreshAuthKeyResult.success);
  }
}

/// Forwards real frames between the generated client and Serverpod. Tests can
/// retain server frames and deliver them later to control their arrival order.
class _WebSocketRelay {
  _WebSocketRelay(this._http, this._server, this._hold) {
    _http.listen(_relay);
  }

  static Future<_WebSocketRelay> start(
    Serverpod server, {
    bool Function(WebSocketMessage)? hold,
  }) async {
    return _WebSocketRelay(
      await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
      server,
      hold,
    );
  }

  final HttpServer _http;
  final Serverpod _server;
  final bool Function(WebSocketMessage)? _hold;
  final connections = <_SocketPair>[];
  final sent = <WebSocketMessage>[];
  final _received = <_Frame>[];
  final _clientFrames = StreamController<WebSocketMessage>.broadcast();
  final _serverFrames = StreamController<_Frame>.broadcast();
  final _firstClosed = Completer<void>();

  Uri get host =>
      Uri(scheme: 'http', host: '127.0.0.1', port: _http.port, path: '/');
  Future<void> get firstClosed => _firstClosed.future.timeout(_deadline);

  Future<bool> firstSocketClosesWithin(Duration timeout) => _firstClosed.future
      .then((_) => true)
      .timeout(timeout, onTimeout: () => false);

  Iterable<OpenMethodStreamCommand> get opens =>
      sent.whereType<OpenMethodStreamCommand>();
  List<String> get methods => opens.map((open) => open.method).toList();

  Future<void> _relay(HttpRequest request) async {
    final upstream = await WebSocket.connect(_server.methodWebSocketUrl);
    final downstream = await WebSocketTransformer.upgrade(request);
    final pair = _SocketPair(upstream, downstream);
    connections.add(pair);
    downstream.listen(
      (text) {
        final frame = _decode(text);
        sent.add(frame);
        _clientFrames.add(frame);
        if (upstream.readyState == WebSocket.open) upstream.add(text);
      },
      onDone: () {
        pair.closed.complete();
        if (!_firstClosed.isCompleted) _firstClosed.complete();
        unawaited(upstream.close());
      },
    );
    upstream.listen((text) {
      final frame = _Frame(_decode(text), downstream, text as String);
      _received.add(frame);
      _serverFrames.add(frame);
      if (_hold?.call(frame.message) != true) frame.forward();
    }, onDone: () => unawaited(downstream.close()));
  }

  WebSocketMessage _decode(dynamic text) => WebSocketMessage.fromJsonString(
    text as String,
    _server.serializationManager,
  );

  Future<_Frame> fromServer<T extends WebSocketMessage>([
    bool Function(T)? where,
  ]) async {
    bool matches(_Frame frame) {
      final message = frame.message;
      return message is T && (where == null || where(message));
    }

    for (final frame in _received) {
      if (matches(frame)) return frame;
    }
    return _serverFrames.stream.firstWhere(matches).timeout(_deadline);
  }

  Future<T> fromClient<T extends WebSocketMessage>(
    bool Function(T) matches, {
    int after = 0,
  }) async {
    for (final message in sent.skip(after).whereType<T>()) {
      if (matches(message)) return message;
    }
    return _clientFrames.stream
        .where((message) => message is T)
        .cast<T>()
        .firstWhere(matches)
        .timeout(_deadline);
  }

  Future<void> close() async {
    await Future.wait([
      for (final socket in connections) ...[
        socket.downstream.close(),
        socket.upstream.close(),
      ],
    ]);
    await _http.close(force: true);
    await _clientFrames.close();
    await _serverFrames.close();
  }
}

class _SocketPair {
  _SocketPair(this.upstream, this.downstream);

  final WebSocket upstream;
  final WebSocket downstream;
  final closed = Completer<void>();
}

class _Frame {
  _Frame(this.message, this._socket, this._text);

  final WebSocketMessage message;
  final WebSocket _socket;
  final String _text;

  void forward() {
    if (_socket.readyState == WebSocket.open) _socket.add(_text);
  }
}
