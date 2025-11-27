// Add tests for when passing an input parameter to the stream.
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
    'Given an integer stream when calling a streaming method that echoes input stream then values are returned from the server.',
    () async {
      var streamComplete = Completer();
      var numberGenerator = List.generate(10, (index) => index++);
      var inputStream = Stream<int>.fromIterable(numberGenerator);
      var stream = client.methodStreaming.intEchoStream(inputStream);

      var received = <int>[];
      stream.listen(
        (event) {
          received.add(event);
        },
        onDone: () {
          streamComplete.complete();
        },
      );

      await streamComplete.future;
      expect(received, numberGenerator);
    },
  );

  test(
    'Given a stream with mixed value types when calling a streaming method that echoes input stream then values are returned from the server.',
    () async {
      var streamComplete = Completer();
      var simpleData = SimpleData(num: 42);
      var mixedValues = [1, 'two', simpleData];
      var inputStream = Stream<dynamic>.fromIterable(mixedValues);
      var stream = client.methodStreaming.dynamicEchoStream(inputStream);

      var received = [];
      stream.listen(
        (event) {
          received.add(event);
        },
        onDone: () {
          streamComplete.complete();
        },
      );

      await streamComplete.future;
      expect(received, hasLength(3));
      expect(received[0], mixedValues[0]);
      expect(received[1], mixedValues[1]);
      expect(
        received[2],
        isA<SimpleData>().having((s) => s.num, 'num', simpleData.num),
      );
    },
  );

  test(
    'Given a stream with nullable integer values when calling a streaming method that echoes input stream then values are echoed from the server.',
    () async {
      var streamComplete = Completer();
      var numberGenerator = List.generate(10, (index) {
        index++;
        if (index % 2 == 0) {
          return null;
        }
        return index;
      });
      var inputStream = Stream<int?>.fromIterable(numberGenerator);
      var stream = client.methodStreaming.nullableIntEchoStream(inputStream);

      var received = <int?>[];
      stream.listen(
        (event) {
          received.add(event);
        },
        onDone: () {
          streamComplete.complete();
        },
      );

      await streamComplete.future;
      expect(received, numberGenerator);
    },
  );

  test(
    'Given multiple integer streams when calling a streaming method that echoes multiple input streams then values are echoed from the server.',
    () async {
      var streamComplete = Completer();
      var sequence = List.generate(4, (index) => index++);
      var inputStream1 = StreamController<int>();
      var inputStream2 = StreamController<int>();
      var stream = client.methodStreaming.multipleIntEchoStreams(
        inputStream1.stream,
        inputStream2.stream,
      );
      var valueEchoed = Completer();
      var received = <int>[];
      stream.listen(
        (event) {
          received.add(event);
          valueEchoed.complete();
        },
        onDone: () {
          streamComplete.complete();
        },
      );

      for (var i in sequence) {
        if (i % 2 == 0)
          inputStream1.add(i);
        else
          inputStream2.add(i);
        await valueEchoed.future;
        valueEchoed = Completer();
      }

      await inputStream1.close();
      await inputStream2.close();
      await streamComplete.future;
      expect(received, sequence);
    },
  );

  test(
    'Given multiple integer streams when one stream is finished when calling a streaming method that echoes multiple input streams then values are still echoed from open stream.',
    () async {
      var streamComplete = Completer();
      var sequence = List.generate(4, (index) => index++);
      var inputStream1 = StreamController<int>();
      var inputStream2 = StreamController<int>();
      var stream = client.methodStreaming.multipleIntEchoStreams(
        inputStream1.stream,
        inputStream2.stream,
      );
      var received = <int>[];
      stream.listen(
        (event) {
          received.add(event);
        },
        onDone: () {
          streamComplete.complete();
        },
      );

      await inputStream1.close();
      await inputStream2.addStream(Stream.fromIterable(sequence));
      await inputStream2.close();

      await streamComplete.future;
      expect(received, sequence);
    },
  );

  test(
    'Given an input stream that throws an exception when calling a streaming method that returns true if exception is thrown on input stream then server responds with true,',
    () async {
      var inputStream = StreamController<int>();
      var responseFuture = client.methodStreaming.didInputStreamHaveError(
        inputStream.stream,
      );

      inputStream.addError(Exception('This is an exception'));
      inputStream.close();

      expect(await responseFuture, true);
    },
  );

  test(
    'Given an input stream that throws a serializable exception when calling a streaming method that returns true if exception is thrown on input stream then server responds with true,',
    () async {
      var inputStream = StreamController<int>();
      var responseFuture = client.methodStreaming
          .didInputStreamHaveSerializableExceptionError(inputStream.stream);

      inputStream.addError(
        ExceptionWithData(
          message: 'Throwing an exception',
          creationDate: DateTime.now(),
          errorFields: [
            'first line error',
            'second line error',
          ],
          someNullableField: 1,
        ),
      );
      inputStream.close();

      expect(await responseFuture, true);
    },
  );
}
