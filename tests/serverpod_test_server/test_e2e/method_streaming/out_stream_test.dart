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
    var stream = client.methodStreaming.simpleStream();

    await expectLater(
      stream,
      emitsInOrder(List.generate(10, (index) => index++)),
    );
  });

  test(
      'Given a streaming method that returns a stream of integers based on the parameter when calling the method, then the expected integers are received.',
      () async {
    var value = 5;
    var stream = client.methodStreaming.intStreamFromValue(value);

    await expectLater(
      stream,
      emitsInOrder(List.generate(value, (index) => index++)),
    );
  });

  test(
      'Given a streaming method that throws an exception when calling the method, then stream is closed with a ConnectionClosedException.',
      () async {
    var stream = client.methodStreaming.outStreamThrowsException();

    await expectLater(
      stream,
      emitsError(isA<ConnectionClosedException>()),
    );
  });

  test(
      'Given a streaming method that throws a serializable exception when calling the method, then stream is closed with the Serializable exception thrown',
      () async {
    var stream = client.methodStreaming.outStreamThrowsSerializableException();

    await expectLater(
      stream,
      emitsError(isA<ExceptionWithData>()),
    );
  });

  test(
      'Given a streaming method that is not a generator that throws an exception before the stream is returned when calling the method, then stream is closed with ServerpodClientException.',
      () async {
    var stream = client.methodStreaming.exceptionThrownBeforeStreamReturn();

    await expectLater(
      stream,
      emitsError(isA<ConnectionClosedException>()),
    );
  });

  test(
      'Given a streaming method that is not a generator that throws an exception as its first message when calling method, then stream is closed with ServerpodClientException.',
      () async {
    var stream = client.methodStreaming.exceptionThrownInStreamReturn();

    await expectLater(
      stream,
      emitsError(isA<ConnectionClosedException>()),
    );
  });
}
