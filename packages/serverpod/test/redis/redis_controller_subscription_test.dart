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
