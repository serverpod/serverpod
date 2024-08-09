import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:serverpod_test_server/src/generated/types.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  const channelName = 'test_channel';

  late Session session;
  late Serverpod server;
  late MessageCentralAccess messageCentral;

  setUp(() async {
    server = IntegrationTestServer.create();
    await server.start();
    session = await server.createSession();
    messageCentral = session.messages;
  });

  tearDown(() async {
    await session.close();
    await server.shutdown(exitProcess: false);
  });

  group('Given listener on channel in message central', () {
    late Completer<SimpleData> messageReceivedCompleter;
    var listenerMethod = (message) {
      messageReceivedCompleter.complete(message as SimpleData);
    };

    setUp(() {
      messageReceivedCompleter = Completer<SimpleData>();
      messageCentral.addListener(channelName, listenerMethod);
    });

    tearDown(() {
      messageCentral.removeListener(channelName, listenerMethod);
    });

    test('when message is posted then listener is notified', () async {
      await messageCentral.postMessage(channelName, SimpleData(num: 42));

      await expectLater(messageReceivedCompleter.future, completes);
      var message = await messageReceivedCompleter.future;
      expect(message.num, 42);
    });
  });

  group('Given stream listening on channel in message central', () {
    late Completer<SimpleData> messageReceivedCompleter;
    late Completer streamErrorCompleter;
    late Stream<SimpleData> stream;
    late StreamSubscription<SimpleData> subscription;

    setUp(() {
      messageReceivedCompleter = Completer<SimpleData>();
      streamErrorCompleter = Completer<dynamic>();

      stream = messageCentral.createStream<SimpleData>(channelName);
      subscription = stream.listen((data) {
        messageReceivedCompleter.complete(data);
      }, onError: (error) {
        streamErrorCompleter.complete(error);
      });
    });

    tearDown(() async {
      await subscription.cancel();
    });

    test('when message is posted then message is delivered on stream',
        () async {
      await messageCentral.postMessage(channelName, SimpleData(num: 42));

      await expectLater(messageReceivedCompleter.future, completes);
      var message = await messageReceivedCompleter.future;
      expect(message.num, 42);
    });

    test(
        'when message of incompatible type is posted then stream error is delivered',
        () async {
      await messageCentral.postMessage(channelName, Types());

      await expectLater(streamErrorCompleter.future, completes);
      var error = await streamErrorCompleter.future;
      expect(error, isA<TypeError>());
    });
  });

  group('Given multiple streams listening to the same channel ', () {
    late Completer<SimpleData> messageReceivedCompleter1;
    late Completer<SimpleData> messageReceivedCompleter2;
    late StreamSubscription<SimpleData> subscription1;
    late StreamSubscription<SimpleData> subscription2;

    setUp(() {
      messageReceivedCompleter1 = Completer<SimpleData>();
      var stream1 = messageCentral.createStream<SimpleData>(channelName);
      subscription1 = stream1.listen((data) {
        messageReceivedCompleter1.complete(data);
      });

      messageReceivedCompleter2 = Completer<SimpleData>();
      var stream2 = messageCentral.createStream<SimpleData>(channelName);
      subscription2 = stream2.listen((data) {
        messageReceivedCompleter2.complete(data);
      });
    });

    tearDown(() async {
      await subscription1.cancel();
      await subscription2.cancel();
    });

    test('when message is posted then all streams receive the message',
        () async {
      await messageCentral.postMessage(channelName, SimpleData(num: 42));

      await expectLater(messageReceivedCompleter1.future, completes);
      var message1 = await messageReceivedCompleter1.future;
      expect(message1.num, 42);
      await expectLater(messageReceivedCompleter2.future, completes);
      var message2 = await messageReceivedCompleter2.future;
      expect(message2.num, 42);
    });

    test(
        'when one subscription is canceled then messages posted are still delivered to the other stream',
        () async {
      await subscription2.cancel();
      await messageCentral.postMessage(channelName, SimpleData(num: 42));

      await expectLater(messageReceivedCompleter1.future, completes);
      var message1 = await messageReceivedCompleter1.future;
      expect(message1.num, 42);
    });
  });
}
