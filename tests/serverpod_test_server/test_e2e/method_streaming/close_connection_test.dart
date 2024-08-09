import 'dart:async';

import 'package:serverpod_client/src/method_stream/method_stream_manager_exceptions.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );

  tearDown(() async =>
      await client.closeStreamingMethodConnections(exception: null));

  test(
      'Given open streaming method connection when close method streams is called then connection is closed with exception.',
      () async {
    var messageReceived = Completer();
    var streamErrorCompleter = Completer<Object>();
    var inputStream = StreamController<int>();
    var stream = client.methodStreaming.intEchoStream(inputStream.stream);

    stream.listen((event) {
      messageReceived.complete();
    }, onError: (e, s) {
      streamErrorCompleter.complete(e);
    });
    inputStream.sink.add(42);
    await messageReceived.future;

    await client.closeStreamingMethodConnections();
    await expectLater(streamErrorCompleter.future, completes);
    var error = await streamErrorCompleter.future;
    expect(error, isA<WebSocketClosedException>());
  });

  test(
      'Given a streaming connection that was closed when establishing a new streaming connection then messages can be successfully transmitted.',
      () async {
    {
      var firstConnectionEstablished = Completer();
      var firstInputStream = StreamController<int>();
      var firstStream =
          client.methodStreaming.intEchoStream(firstInputStream.stream);

      firstStream.listen((event) {
        firstConnectionEstablished.complete();
      });
      firstInputStream.sink.add(42);
      await expectLater(firstConnectionEstablished.future, completes);
      await client.closeStreamingMethodConnections(exception: null);
    }

    {
      var secondConnectionEstablished = Completer();
      var secondInputStream = StreamController<int>();
      var secondStream =
          client.methodStreaming.intEchoStream(secondInputStream.stream);

      secondStream.listen((event) {
        secondConnectionEstablished.complete();
      });
      secondInputStream.sink.add(42);
      await expectLater(secondConnectionEstablished.future, completes);
    }
  });

  test(
      'Given an input stream that continuously sends data to the server when closing all method streams then the method stream is successfully closed.',
      () async {
    var stream = client.methodStreaming.intEchoStream(
      Stream.periodic(Duration(microseconds: 1), (i) => i),
    );

    var streamComplete = Completer();
    stream.listen((event) {
      if (event == 10) {
        client.closeStreamingMethodConnections(exception: null);
      }
    }, onDone: () {
      streamComplete.complete();
    });

    await expectLater(streamComplete.future, completes);
  });
}
