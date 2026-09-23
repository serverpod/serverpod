import 'dart:async';

import 'package:serverpod/src/redis/controller.dart';
import 'package:test/test.dart';

import 'fake_redis_server.dart';

void main() {
  late FakeRedisServer redis;
  late RedisController controller;

  setUp(() async {
    redis = await FakeRedisServer.start();
    controller = RedisController(
      host: '127.0.0.1',
      port: redis.port,
      requireSsl: false,
    );
    await controller.start();
  });

  tearDown(() async {
    await controller.stop();
    await redis.close();
  });

  group(
    'Given two listeners added during a pub/sub reconnect with confirmations withheld,',
    () {
      late Future<bool> firstSubscription;
      late Future<bool> secondSubscription;
      late Completer<String> secondMessage;

      setUp(() async {
        await controller.stop();
        controller = RedisController(
          host: '127.0.0.1',
          port: redis.port,
          requireSsl: false,
          password: 'password',
        );
        await controller.start();
        redis.holdConfirmations = true;
        var interrupted = controller.subscribe('before-drop', (_, _) {});
        await redis.nextCommand('SUBSCRIBE');
        await redis.dropPubSubConnections();
        await interrupted;
        redis.holdAuthentications = true;

        var authenticating = redis.nextCommand('AUTH');
        firstSubscription = controller.subscribe('first', (_, _) {});
        await authenticating;
        secondMessage = Completer<String>();
        secondSubscription = controller.subscribe('second', (_, message) {
          secondMessage.complete(message);
        });

        var resubscribing = redis.nextCommand('SUBSCRIBE');
        redis.releaseHeldAuthentications();
        await resubscribing;
      });

      test(
        'when Redis confirms the subscriptions, '
        'then both subscriptions report success.',
        () async {
          redis.releaseHeldConfirmations();

          expect(
            await Future.wait([firstSubscription, secondSubscription]),
            [true, true],
          );
        },
      );

      test(
        'when a message arrives on the second channel, '
        'then the second listener receives it.',
        () async {
          redis.releaseHeldConfirmations();
          await Future.wait([firstSubscription, secondSubscription]);

          redis.deliverMessage('second', 'after reconnect');

          await expectLater(
            secondMessage.future.timeout(const Duration(seconds: 2)),
            completion('after reconnect'),
          );
        },
      );

      test(
        'when publishing to the second channel, '
        'then publishing waits for its subscription confirmation.',
        () async {
          var published = false;
          var publishing = controller.publish('second', 'after reconnect');
          unawaited(publishing.then((_) => published = true));
          await pumpEventQueue();

          expect(published, isFalse);
          expect(
            redis.receivedCommands.map((command) => command.first),
            isNot(contains('PUBLISH')),
          );

          redis.releaseHeldConfirmations();
          await expectLater(publishing, completion(isTrue));
        },
      );
    },
  );

  test(
    'Given a pub/sub reconnect stalled on AUTH and a healthy command connection, '
    'when publishing to the channel waiting to subscribe, '
    'then the publish is released within the subscription wait limit.',
    () async {
      await controller.stop();
      controller = RedisController(
        host: '127.0.0.1',
        port: redis.port,
        requireSsl: false,
        password: 'password',
      );
      await controller.start();
      redis.holdConfirmations = true;
      var interrupted = controller.subscribe('before-drop', (_, _) {});
      await redis.nextCommand('SUBSCRIBE');
      await redis.dropPubSubConnections();
      await interrupted;
      redis.holdConfirmations = false;
      redis.holdAuthentications = true;

      var authenticating = redis.nextCommand('AUTH');
      var subscribing = controller.subscribe('channel', (_, _) {});
      await authenticating;
      // The command socket is still usable while AUTH is withheld on pub/sub.
      expect(await controller.ping(), isTrue);

      await expectLater(
        controller
            .publish('channel', 'during stalled auth')
            .timeout(const Duration(seconds: 12)),
        completion(isTrue),
      );
      expect(
        redis.receivedCommands,
        contains(equals(['PUBLISH', 'channel', 'during stalled auth'])),
      );

      redis.releaseHeldAuthentications();
      await expectLater(subscribing, completion(isTrue));
    },
  );

  test(
    'Given a Redis server that leaves a subscribe unconfirmed, '
    'when the confirmation times out, '
    'then keep-alive reconnects and restores message delivery.',
    () async {
      redis.holdConfirmations = true;
      var received = Completer<String>();
      var subscribing = controller.subscribe('channel', (_, message) {
        received.complete(message);
      });
      await redis.nextCommand('SUBSCRIBE');
      // Only the original socket is hung; a replacement can confirm normally.
      redis.holdConfirmations = false;
      var resubscribed = redis.nextCommand('SUBSCRIBE');

      expect(await subscribing, isFalse);
      await resubscribed.timeout(const Duration(seconds: 7));
      redis.deliverMessage('channel', 'after reconnect');

      await expectLater(
        received.future.timeout(const Duration(seconds: 2)),
        completion('after reconnect'),
      );
    },
  );

  test(
    'Given a Redis server that leaves an unsubscribe unconfirmed, '
    'when the confirmation times out, '
    'then keep-alive restores the remaining subscription.',
    () async {
      var received = Completer<String>();
      await controller.subscribe('remaining', (_, message) {
        received.complete(message);
      });
      await controller.subscribe('removed', (_, _) {});
      redis.holdConfirmations = true;
      var unsubscribing = controller.unsubscribe('removed');
      await redis.nextCommand('UNSUBSCRIBE');
      redis.holdConfirmations = false;
      var resubscribed = redis.nextCommand('SUBSCRIBE');

      expect(await unsubscribing, isFalse);
      await resubscribed.timeout(const Duration(seconds: 7));
      redis.deliverMessage('remaining', 'after reconnect');

      await expectLater(
        received.future.timeout(const Duration(seconds: 2)),
        completion('after reconnect'),
      );
    },
  );

  group('Given a Redis server that has not confirmed a subscription', () {
    test('when subscribing '
        'then the returned future does not complete', () async {
      redis.holdConfirmations = true;

      var completed = false;
      var subscribing = controller.subscribe('channel', (_, _) {});
      unawaited(subscribing.then((_) => completed = true));

      await redis.nextCommand('SUBSCRIBE');
      await pumpEventQueue();

      expect(
        completed,
        isFalse,
        reason:
            'subscribe must not complete before Redis confirms the '
            'subscription, otherwise a publish right after it can be dropped',
      );

      redis.releaseHeldConfirmations();
      await expectLater(subscribing, completion(isTrue));
    });

    test('when unsubscribing '
        'then the returned future does not complete', () async {
      await controller.subscribe('channel', (_, _) {});
      redis.holdConfirmations = true;

      var completed = false;
      var unsubscribing = controller.unsubscribe('channel');
      unawaited(unsubscribing.then((_) => completed = true));

      await redis.nextCommand('UNSUBSCRIBE');
      await pumpEventQueue();

      expect(completed, isFalse);

      redis.releaseHeldConfirmations();
      await expectLater(unsubscribing, completion(isTrue));
    });

    test('when the connection drops while waiting '
        'then subscribing reports failure', () async {
      redis.holdConfirmations = true;

      var subscribing = controller.subscribe('channel', (_, _) {});
      await redis.nextCommand('SUBSCRIBE');

      await redis.dropConnections();

      await expectLater(subscribing, completion(isFalse));
    });
  });

  group('Given a subscription that Redis has not confirmed yet', () {
    setUp(() => redis.holdConfirmations = true);

    test('when a message is published to the same channel '
        'then the publish waits for the confirmation', () async {
      // Deliberately not awaited: this is how MessageCentral registers
      // listeners, and the reason the wait cannot live at the call site.
      unawaited(controller.subscribe('channel', (_, _) {}));

      var published = false;
      var publishing = controller.publish('channel', 'a-message');
      unawaited(publishing.then((_) => published = true));

      await redis.nextCommand('SUBSCRIBE');
      await pumpEventQueue();

      expect(
        published,
        isFalse,
        reason:
            'the publish must not reach Redis before the subscription, '
            'or the server drops the message',
      );
      expect(
        redis.receivedCommands.map((command) => command.first),
        isNot(contains('PUBLISH')),
      );

      redis.releaseHeldConfirmations();
      await expectLater(publishing, completion(isTrue));
      expect(
        redis.receivedCommands.map((command) => command.first),
        contains('PUBLISH'),
      );
    });

    test('when a message is published to a different channel '
        'then the publish is not held up', () async {
      unawaited(controller.subscribe('channel', (_, _) {}));
      await redis.nextCommand('SUBSCRIBE');

      await expectLater(
        controller.publish('other-channel', 'a-message'),
        completion(isTrue),
      );
    });

    test('when the subscription never completes '
        'then the publish is released rather than deadlocked', () async {
      unawaited(controller.subscribe('channel', (_, _) {}));
      await redis.nextCommand('SUBSCRIBE');

      var publishing = controller.publish('channel', 'a-message');
      await redis.dropConnections();

      await expectLater(publishing, completes);
    });
  });

  group('Given a Redis server that confirms subscriptions', () {
    test('when subscribing '
        'then the confirmation is awaited before completing', () async {
      var subscribed = await controller.subscribe('channel', (_, _) {});

      expect(subscribed, isTrue);
    });

    test('when a message is delivered on the channel '
        'then the listener is notified', () async {
      var received = Completer<String>();
      await controller.subscribe('channel', (_, message) {
        received.complete(message);
      });

      redis.deliverMessage('channel', 'hello');

      await expectLater(received.future, completion('hello'));
    });
  });
}
