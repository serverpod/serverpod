import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_key_manager.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(
    serverUrl,
    authenticationKeyManager: TestAuthKeyManager(),
  );

  test(
      'Given a streaming method that returns a stream of integers, when calling the method, then the expected integers are received.',
      () async {
    var streamComplete = Completer();
    var stream = client.methodStreaming.simpleStream();
    var received = <int>[];
    stream.listen((event) {
      received.add(event);
    }, onDone: () {
      streamComplete.complete();
    });

    await streamComplete.future;
    expect(received, List.generate(10, (index) => index++));
  });

  test(
      'Given a streaming method that returns a stream of integers based on the parameter when calling the method, then the expected integers are received.',
      () async {
    var streamComplete = Completer();
    var stream = client.methodStreaming.intStreamFromValue(5);
    var received = <int>[];
    stream.listen((event) {
      received.add(event);
    }, onDone: () {
      streamComplete.complete();
    });

    await streamComplete.future;
    expect(received, List.generate(5, (index) => index++));
  });

  test(
      'Given a streaming method that throws an exception when calling the method, then stream is closed ServerpodClientException.',
      () async {
    var streamComplete = Completer<dynamic>();
    var stream = client.methodStreaming.outStreamThrowsException();
    stream.listen((event) {
      // Do nothing
    }, onError: (error) {
      streamComplete.complete(error);
    });

    await expectLater(
      await streamComplete.future,
      isA<ConnectionClosedException>(),
    );
  });

  test(
      'Given a streaming method that throws a serializable exception when calling the method, then stream is closed with the Serializable exception thrown',
      () async {
    var streamComplete = Completer<dynamic>();
    var stream = client.methodStreaming.outStreamThrowsSerializableException();
    stream.listen((event) {
      // Do nothing
    }, onError: (error) {
      streamComplete.complete(error);
    });

    await expectLater(
      await streamComplete.future,
      isA<ExceptionWithData>(),
    );
  });

  test(
      'Given a streaming method that is not a generator that throws an exception before the stream is returned, then stream is closed with ServerpodClientException.',
      () async {
    var streamComplete = Completer<dynamic>();
    var stream = client.methodStreaming.exceptionThrownBeforeStreamReturn();
    stream.listen((event) {
      // Do nothing
    }, onError: (error) {
      streamComplete.complete(error);
    });

    await expectLater(
      await streamComplete.future,
      isA<ConnectionClosedException>(),
    );
  });

  test(
      'Given a streaming method that is not a generator that throws an exception as its first message when calling method, then stream is closed with ServerpodClientException.',
      () async {
    var streamComplete = Completer<dynamic>();
    var stream = client.methodStreaming.exceptionThrownInStreamReturn();
    stream.listen((event) {
      // Do nothing
    }, onError: (error) {
      streamComplete.complete(error);
    });

    await expectLater(
      await streamComplete.future,
      isA<ConnectionClosedException>(),
    );
  });
}
