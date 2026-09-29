import 'package:serverpod/src/redis/controller.dart';
import 'package:test/test.dart';

import 'fake_redis_server.dart';

void main() {
  group('Given a Redis controller that is not reachable on localhost', () {
    late RedisController controller;

    setUp(() {
      controller = RedisController(
        host: '127.0.0.1',
        port: 1,
        requireSsl: false,
      );
    });

    tearDown(() {
      controller.stop();
    });

    test(
      'when starting with no handleError, '
      'then it completes with no error.',
      () async {
        await expectLater(controller.start(), completes);
      },
    );

    test(
      'when starting with handleError that absorbs failures, '
      'then handleError is invoked.',
      () async {
        var handleErrorInvoked = false;

        await controller.start(
          handleError: (e) {
            handleErrorInvoked = true;
            return true;
          },
        );

        expect(handleErrorInvoked, isTrue);
      },
    );

    test(
      'when starting with a short connectTimeout, '
      'then it does not wait the default timeout.',
      () async {
        final stopwatch = Stopwatch()..start();
        await expectLater(
          controller.start(connectTimeout: const Duration(milliseconds: 400)),
          completes,
        );
        expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
      },
    );

    test(
      'when getting the connection without a reachable Redis server, '
      'then null is returned.',
      () async {
        final connection = await controller.getConnection();
        expect(connection, isNull);
      },
    );
  });

  group(
    'Given a Redis controller that is not reachable on localhost and connectTimeout is short',
    () {
      late RedisController controller;

      setUp(() {
        controller = RedisController(
          host: '127.0.0.1',
          port: 1,
          requireSsl: false,
          connectTimeout: const Duration(milliseconds: 400),
        );
      });

      tearDown(() {
        controller.stop();
      });

      test(
        'when starting, '
        'then it does not wait the default timeout.',
        () async {
          final stopwatch = Stopwatch()..start();
          await expectLater(controller.start(), completes);
          expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
        },
      );
    },
  );

  group(
    'Given a Redis server that never answers AUTH and a short connectTimeout',
    () {
      late FakeRedisServer redis;
      late RedisController controller;

      setUp(() async {
        redis = await FakeRedisServer.start();
        redis.holdAuthentications = true;
        controller = RedisController(
          host: '127.0.0.1',
          port: redis.port,
          requireSsl: false,
          password: 'password',
          connectTimeout: const Duration(milliseconds: 400),
        );
      });

      tearDown(() async {
        await controller.stop();
        await redis.close();
      });

      test(
        'when pinging, '
        'then false is returned within the connect timeout.',
        () async {
          await expectLater(
            controller.ping().timeout(const Duration(seconds: 2)),
            completion(isFalse),
          );
        },
      );

      test(
        'when the server starts answering AUTH after a timed out connect, '
        'then the next ping reconnects.',
        () async {
          await controller.ping().timeout(const Duration(seconds: 2));

          redis.holdAuthentications = false;

          expect(await controller.ping(), isTrue);
        },
      );
    },
  );

  group(
    'Given a server that never completes the TLS handshake and a short connectTimeout',
    () {
      late FakeRedisServer server;
      late RedisController controller;

      setUp(() async {
        // The fake only replies to RESP commands, so it never answers the
        // TLS ClientHello.
        server = await FakeRedisServer.start();
        controller = RedisController(
          host: '127.0.0.1',
          port: server.port,
          requireSsl: true,
          connectTimeout: const Duration(milliseconds: 400),
        );
      });

      tearDown(() async {
        await controller.stop();
        await server.close();
      });

      test(
        'when pinging, '
        'then false is returned within the connect timeout.',
        () async {
          await expectLater(
            controller.ping().timeout(const Duration(seconds: 2)),
            completion(isFalse),
          );
        },
      );
    },
  );
}
