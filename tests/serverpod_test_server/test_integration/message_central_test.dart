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

  test(
      'Given no listeners on channel '
      'when a message is posted to channel '
      'then true is returned.', () async {
    final result = await messageCentral.postMessage(
      channelName,
      SimpleData(num: 42),
    );
    expect(result, isTrue);
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

    test('when message is posted then it returns true', () async {
      final result = await messageCentral.postMessage(
        channelName,
        SimpleData(num: 42),
      );
      expect(result, isTrue);
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
    late Completer streamDoneCompleter;
    late Completer streamErrorCompleter;
    late Stream<SimpleData> stream;
    late StreamSubscription<SimpleData> subscription;

    setUp(() {
      messageReceivedCompleter = Completer<SimpleData>();
      streamDoneCompleter = Completer();
      streamErrorCompleter = Completer<dynamic>();

      stream = messageCentral.createStream<SimpleData>(channelName);
      subscription = stream.listen((data) {
        messageReceivedCompleter.complete(data);
      }, onDone: () {
        streamDoneCompleter.complete();
      }, onError: (error) {
        streamErrorCompleter.complete(error);
      });
    });

    tearDown(() async {
      await subscription.cancel();
    });

    test('when message is posted then it returns true', () async {
      final result = await messageCentral.postMessage(
        channelName,
        SimpleData(num: 42),
      );
      expect(result, isTrue);
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

    test('when session is closed then stream is closed', () async {
      await session.close();

      await expectLater(streamDoneCompleter.future, completes);
    });
  });

  group('Given multiple streams listening to the same channel ', () {
    late Completer<SimpleData> messageReceivedCompleter1;
    late Completer<SimpleData> messageReceivedCompleter2;
    late StreamSubscription<SimpleData> subscription1;
    late StreamSubscription<SimpleData> subscription2;
    late Completer stream1DoneCompleter;
    late Completer stream2DoneCompleter;

    setUp(() {
      messageReceivedCompleter1 = Completer<SimpleData>();
      stream1DoneCompleter = Completer();
      var stream1 = messageCentral.createStream<SimpleData>(channelName);
      subscription1 = stream1.listen((data) {
        messageReceivedCompleter1.complete(data);
      }, onDone: () {
        stream1DoneCompleter.complete();
      });

      messageReceivedCompleter2 = Completer<SimpleData>();
      stream2DoneCompleter = Completer();
      var stream2 = messageCentral.createStream<SimpleData>(channelName);
      subscription2 = stream2.listen((data) {
        messageReceivedCompleter2.complete(data);
      }, onDone: () {
        stream2DoneCompleter.complete();
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

    test('when session is closed then all streams are done', () async {
      await session.close();

      await expectLater(stream1DoneCompleter.future, completes);
      await expectLater(stream2DoneCompleter.future, completes);
    });
  });
}
