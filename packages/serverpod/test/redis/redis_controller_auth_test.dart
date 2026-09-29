import 'dart:async';

import 'package:serverpod/src/redis/controller.dart';
import 'package:test/test.dart';

import 'fake_redis_server.dart';

const _bound = Duration(seconds: 2);
const _authTimeout = Duration(milliseconds: 150);

void main() {
  late FakeRedisServer redis;
  late RedisController controller;

  RedisController create({
    String? user,
    String? password = 'synthetic-password',
    Duration timeout = _authTimeout,
  }) => RedisController(
    host: '127.0.0.1',
    port: redis.port,
    requireSsl: false,
    user: user,
    password: password,
    connectTimeout: timeout,
  );

  setUp(() async {
    redis = await FakeRedisServer.start();
    controller = create();
  });

  tearDown(() async {
    // Release a baseline implementation still waiting for AUTH after a failed
    // assertion, before stopping it. This is not evidence of product cleanup.
    redis.holdAuthentications = false;
    redis.releaseHeldAuthentications();
    await pumpEventQueue();
    await controller.stop().timeout(_bound);
    await redis.close().timeout(_bound);
  });

  for (var user in <String?>[null, 'synthetic-user']) {
    test('AUTH ${user ?? 'password only'} succeeds and PING works', () async {
      controller = create(user: user);
      var authentication = redis.nextAuthentication;
      var ping = controller.ping();
      var attempt = await authentication.timeout(_bound);
      expect(attempt.arguments, [
        'AUTH',
        ?user,
        'synthetic-password',
      ]);
      expect(await ping.timeout(_bound), isTrue);
    });

    test(
      'Stalled AUTH ${user ?? 'password only'} closes and permits retry',
      () async {
        controller = create(user: user);
        redis.holdAuthentications = true;
        var authentication = redis.nextAuthentication;
        var ping = controller.ping();
        var attempt = await authentication.timeout(_bound);
        // Existing concurrent-call semantics: no second connection is opened.
        expect(await controller.ping().timeout(_bound), isFalse);
        expect(await controller.getConnection().timeout(_bound), isNull);
        expect(redis.connections, hasLength(1));

        expect(await ping.timeout(_bound), isFalse);
        await attempt.connection.peerEof.timeout(_bound);
        expect(attempt.connection.socketErrors, isEmpty);

        redis.holdAuthentications = false;
        var retryAuthentication = redis.nextAuthentication;
        var retry = controller.ping();
        var next = await retryAuthentication.timeout(_bound);
        expect(next.connection.id, isNot(attempt.connection.id));
        expect(await retry.timeout(_bound), isTrue);
        expect(redis.connections, hasLength(2));
      },
    );
  }

  test('No password skips AUTH and PING works', () async {
    controller = create(password: null);
    expect(await controller.ping().timeout(_bound), isTrue);
    expect(redis.receivedCommands, [
      equals(['PING']),
    ]);
  });

  test('AUTH rejection releases its connection and permits retry', () async {
    redis.authenticationReply = '-WRONGPASS synthetic rejection\r\n';
    var authentication = redis.nextAuthentication;
    expect(await controller.ping().timeout(_bound), isFalse);
    await (await authentication).connection.peerEof.timeout(_bound);
    redis.authenticationReply = '+OK\r\n';
    expect(await controller.ping().timeout(_bound), isTrue);
  });

  test(
    'Redis rejection retains the existing Exception-only callback behavior',
    () async {
      redis.authenticationReply = '-WRONGPASS synthetic rejection\r\n';
      var callbacks = 0;
      var authentication = redis.nextAuthentication;
      await controller
          .start(
            handleError: (_) {
              callbacks++;
              return true;
            },
          )
          .timeout(_bound);
      await (await authentication).connection.peerEof.timeout(_bound);
      // The Redis dependency's RedisError does not implement Exception.
      expect(callbacks, 0);
      expect(redis.connections, hasLength(1));
    },
  );

  test(
    'start override also bounds pub/sub AUTH and keep-alive can recover',
    () async {
      controller = create(timeout: const Duration(seconds: 10));
      redis.holdAuthentications = true;
      var commandAuthentication = redis.nextAuthentication;
      var starting = controller.start(connectTimeout: _authTimeout);
      var command = await commandAuthentication.timeout(_bound);
      var pubSubAuthentication = redis.nextAuthentication;
      command.reply('+OK\r\n');
      var pubSub = await pubSubAuthentication.timeout(_bound);
      var recoveryAuthentication = redis.nextAuthentication;
      await starting.timeout(_bound);
      await pubSub.connection.peerEof.timeout(_bound);
      var recovery = await recoveryAuthentication.timeout(_bound);
      expect(recovery.connection.id, isNot(pubSub.connection.id));
      redis.holdAuthentications = false;
      // Reply only to the recovery socket: the successful command AUTH was also
      // held by the fixture and must not receive a second unsolicited response.
      recovery.reply('+OK\r\n');
      expect(
        await controller.subscribe('recovered', (_, _) {}).timeout(_bound),
        isTrue,
      );
      expect(await controller.ping().timeout(_bound), isTrue);
    },
  );

  test('Non-OK AUTH response releases its connection', () async {
    redis.authenticationReply = '+DENIED\r\n';
    var authentication = redis.nextAuthentication;
    expect(await controller.ping().timeout(_bound), isFalse);
    await (await authentication).connection.peerEof.timeout(_bound);
  });

  test(
    'Timeout reaches start error callback and callback exceptions do not lock retries',
    () async {
      redis.holdAuthentications = true;
      var authentication = redis.nextAuthentication;
      var callbackError = StateError('synthetic callback failure');
      var starting = controller.start(
        handleError: (error) {
          expect(error, isA<TimeoutException>());
          throw callbackError;
        },
      );
      var check = expectLater(
        starting.timeout(_bound),
        throwsA(same(callbackError)),
      );
      var attempt = await authentication.timeout(_bound);
      await check;
      await attempt.connection.peerEof.timeout(_bound);
      redis.holdAuthentications = false;
      expect(await controller.ping().timeout(_bound), isTrue);
    },
  );

  test('start override applies only to that attempt', () async {
    controller = create(timeout: const Duration(milliseconds: 600));
    redis.holdAuthentications = true;
    var authentication = redis.nextAuthentication;
    var errors = <Exception>[];
    var starting = controller.start(
      connectTimeout: _authTimeout,
      handleError: (error) {
        errors.add(error);
        return true;
      },
    );
    var attempt = await authentication.timeout(_bound);
    await starting.timeout(_bound);
    expect(errors, hasLength(1));
    expect((errors.single as TimeoutException).duration, _authTimeout);
    await attempt.connection.peerEof.timeout(_bound);

    var nextAuthentication = redis.nextAuthentication;
    var laterErrors = <Exception>[];
    await controller
        .start(
          handleError: (error) {
            laterErrors.add(error);
            return true;
          },
        )
        .timeout(_bound);
    var next = await nextAuthentication.timeout(_bound);
    expect(next.connection.id, isNot(attempt.connection.id));
    expect(
      (laterErrors.single as TimeoutException).duration,
      const Duration(milliseconds: 600),
    );
    await next.connection.peerEof.timeout(_bound);
    redis.holdAuthentications = false;
    expect(await controller.ping().timeout(_bound), isTrue);
  });

  for (var response in ['+OK\r\n', '-ERR late synthetic error\r\n']) {
    test(
      'Late AUTH ${response.startsWith('+') ? 'success' : 'error'} does not resurrect a timed-out connection',
      () async {
        redis.holdAuthentications = true;
        var authentication = redis.nextAuthentication;
        var ping = controller.ping();
        var attempt = await authentication.timeout(_bound);
        expect(await ping.timeout(_bound), isFalse);
        // The peer attempts a late reply; delivery is not assumed after close.
        attempt.reply(response);
        await attempt.connection.peerEof.timeout(_bound);
        await pumpEventQueue();
        expect(redis.receivedCommands.map((c) => c.first), ['AUTH']);
        redis.holdAuthentications = false;
        expect(await controller.ping().timeout(_bound), isTrue);
        expect(redis.connections, hasLength(2));
      },
    );
  }

  test(
    'Pub/sub AUTH timeout releases the shared attempt and recovers delivery',
    () async {
      // Establish command traffic independently, then stall only pub/sub AUTH.
      expect(await controller.ping().timeout(_bound), isTrue);
      redis.holdAuthentications = true;
      var authentication = redis.nextAuthentication;
      var first = controller.subscribe('first', (_, _) {});
      var attempt = await authentication.timeout(_bound);
      var second = controller.subscribe('second', (_, _) {});
      expect(await controller.ping().timeout(_bound), isTrue);
      expect(await Future.wait([first, second]).timeout(_bound), [
        false,
        false,
      ]);
      await attempt.connection.peerEof.timeout(_bound);
      expect(redis.connections, hasLength(2));

      redis.holdAuthentications = false;
      var message = Completer<String>();
      expect(
        await controller
            .subscribe('second', (_, data) {
              message.complete(data);
            })
            .timeout(_bound),
        isTrue,
      );
      redis.deliverMessage('second', 'recovered');
      expect(await message.future.timeout(_bound), 'recovered');
      expect(redis.connections, hasLength(3));
    },
  );
}
