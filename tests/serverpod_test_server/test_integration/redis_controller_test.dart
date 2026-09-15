@Tags(['redis'])
library;

import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

/// Asks Redis which of its channels currently have subscribers, over the
/// regular command connection rather than the pub/sub one.
///
/// This is the server's own view of the subscription, so it is the ground
/// truth for whether [RedisController.subscribe] waited long enough.
Future<List<String>> _serverSideSubscribers(
  RedisController controller,
  String channel,
) async {
  var connection = await controller.getConnection();
  var result = await connection?.send_object(['PUBSUB', 'CHANNELS', channel]);
  return (result as List?)?.cast<String>() ?? [];
}

void main() {
  late Session session;
  late RedisController controller;
  late String channel;

  setUpAll(() async {
    session = await IntegrationTestServer(withRedis: true).session();
    var redisController = session.serverpod.redisController;
    if (redisController == null) {
      throw StateError('Expected the test server to have a Redis controller');
    }

    controller = redisController;
    await controller.start();
  });

  setUp(() {
    channel = Uuid().v4();
  });

  group('Given a running Redis controller,', () {
    group('when subscribing to a channel,', () {
      late bool subscribed;

      setUp(() async {
        subscribed = await controller.subscribe(channel, (_, _) {});
      });

      tearDown(() async {
        await controller.unsubscribe(channel);
      });

      test('then the subscription is confirmed.', () {
        expect(subscribed, isTrue);
      });

      test('then Redis reports the channel as subscribed.', () async {
        expect(await _serverSideSubscribers(controller, channel), [channel]);
      });
    });

    group('when subscribing to the same channel twice,', () {
      late List<bool> subscribed;

      setUp(() async {
        subscribed = await Future.wait([
          controller.subscribe(channel, (_, _) {}),
          controller.subscribe(channel, (_, _) {}),
        ]).timeout(Duration(seconds: 10));
      });

      tearDown(() async {
        await controller.unsubscribe(channel);
      });

      test('then both subscriptions are confirmed.', () {
        expect(subscribed, [true, true]);
      });
    });
  });

  group('Given a channel subscribed on a running Redis controller,', () {
    late Completer<String> received;

    setUp(() async {
      received = Completer<String>();
      await controller.subscribe(channel, (_, message) {
        received.complete(message);
      });
    });

    tearDown(() async {
      await controller.unsubscribe(channel);
    });

    group('when a message is published to the channel,', () {
      setUp(() async {
        await controller.publish(channel, 'a-message');
      });

      test('then the message is delivered to the listener.', () async {
        await expectLater(
          received.future.timeout(Duration(seconds: 10)),
          completion('a-message'),
        );
      });
    });

    group('when unsubscribing from the channel,', () {
      late bool unsubscribed;

      setUp(() async {
        unsubscribed = await controller.unsubscribe(channel);
      });

      test('then the unsubscription is confirmed.', () {
        expect(unsubscribed, isTrue);
      });

      test('then Redis no longer reports the channel as subscribed.', () async {
        expect(await _serverSideSubscribers(controller, channel), isEmpty);
      });
    });
  });

  group('Given a stopped Redis controller,', () {
    setUp(() async {
      await controller.stop();
    });

    tearDown(() async {
      await controller.start();
    });

    group('when subscribing to a channel,', () {
      late bool subscribed;

      // The timeout turns a hanging subscription into a failure rather than a
      // suite that never finishes.
      setUp(() async {
        subscribed = await controller
            .subscribe(channel, (_, _) {})
            .timeout(Duration(seconds: 5));
      });

      test('then the subscription reports failure.', () {
        expect(subscribed, isFalse);
      });
    });
  });

  group('Given a Redis controller that was stopped and started again,', () {
    setUp(() async {
      await controller.stop();
      await controller.start();
    });

    group('when subscribing to a channel,', () {
      late bool subscribed;

      setUp(() async {
        subscribed = await controller.subscribe(channel, (_, _) {});
      });

      tearDown(() async {
        await controller.unsubscribe(channel);
      });

      test('then the subscription is confirmed.', () {
        expect(subscribed, isTrue);
      });

      test('then Redis reports the channel as subscribed.', () async {
        expect(await _serverSideSubscribers(controller, channel), [channel]);
      });
    });
  });
}
