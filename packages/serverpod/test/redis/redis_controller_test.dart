import 'package:serverpod/src/redis/controller.dart';
import 'package:test/test.dart';

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
}
