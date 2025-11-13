import 'package:serverpod_auth_client/serverpod_auth_client.dart' show UserInfo;
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
    },
  );

  test(
    'Given a streaming method that returns a stream of integers based on the parameter when calling the method, then the expected integers are received.',
    () async {
      var value = 5;
      var stream = client.methodStreaming.intStreamFromValue(value);

      await expectLater(
        stream,
        emitsInOrder(List.generate(value, (index) => index++)),
      );
    },
  );

  test(
    'Given a streaming method that throws an exception when calling the method, then stream is closed with a ConnectionClosedException.',
    () async {
      var stream = client.methodStreaming.outStreamThrowsException();

      await expectLater(
        stream,
        emitsError(isA<ConnectionClosedException>()),
      );
    },
  );

  test(
    'Given a streaming method that throws a serializable exception when calling the method, then stream is closed with the Serializable exception thrown',
    () async {
      var stream = client.methodStreaming
          .outStreamThrowsSerializableException();

      await expectLater(
        stream,
        emitsError(isA<ExceptionWithData>()),
      );
    },
  );

  test(
    'Given a streaming method that is not a generator that throws an exception before the stream is returned when calling the method, then stream is closed with ServerpodClientException.',
    () async {
      var stream = client.methodStreaming.exceptionThrownBeforeStreamReturn();

      await expectLater(
        stream,
        emitsError(isA<ConnectionClosedException>()),
      );
    },
  );

  test(
    'Given a streaming method that is not a generator that throws an exception as its first message when calling method, then stream is closed with ServerpodClientException.',
    () async {
      var stream = client.methodStreaming.exceptionThrownInStreamReturn();

      await expectLater(
        stream,
        emitsError(isA<ConnectionClosedException>()),
      );
    },
  );

  test(
    'Given a streaming method that echoes a stream of lists of integers, when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming.simpleListInOutIntStream(
        Stream.fromIterable([
          [1, 2, 3],
          [4, 5, 6],
        ]),
      );

      expect(
        response,
        emitsInOrder([
          [1, 2, 3],
          [4, 5, 6],
        ]),
      );
    },
  );

  test(
    'Given a streaming method that echoes a stream of nullable lists of data objects, when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming
          .simpleNullableListInOutNullableDataStream(
            Stream.fromIterable([
              [SimpleData(num: 1), SimpleData(num: 2)],
              null,
              [SimpleData(num: 3), SimpleData(num: 4)],
            ]),
          );

      expect(
        response,
        emitsInOrder([
          [
            isA<SimpleData>().having((s) => s.num, 'num', 1),
            isA<SimpleData>().having((s) => s.num, 'num', 2),
          ],
          isNull,
          [
            isA<SimpleData>().having((s) => s.num, 'num', 3),
            isA<SimpleData>().having((s) => s.num, 'num', 4),
          ],
        ]),
      );
    },
  );

  test(
    'Given a streaming method that echoes a stream lists of nullable data objects, when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming.simpleListInOutNullableDataStream(
        Stream.fromIterable([
          [SimpleData(num: 1), null, SimpleData(num: 2)],
          [null, SimpleData(num: 3), null, SimpleData(num: 4), null],
        ]),
      );

      expect(
        response,
        emitsInOrder([
          [
            isA<SimpleData>().having((s) => s.num, 'num', 1),
            isNull,
            isA<SimpleData>().having((s) => s.num, 'num', 2),
          ],
          [
            isNull,
            isA<SimpleData>().having((s) => s.num, 'num', 3),
            isNull,
            isA<SimpleData>().having((s) => s.num, 'num', 4),
            isNull,
          ],
        ]),
      );
    },
  );

  test(
    'Given a streaming method that echoes a stream lists of `UserInfo` objects (type from another module), when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming
          .simpleListInOutOtherModuleTypeStream(
            Stream.fromIterable([
              [
                UserInfo(
                  userIdentifier: 'my_user',
                  created: DateTime.utc(2025),
                  scopeNames: [],
                  blocked: false,
                ),
              ],
            ]),
          );

      expect(
        response,
        emitsInOrder([
          [
            isA<UserInfo>().having(
              (s) => s.userIdentifier,
              'userIdentifier',
              'my_user',
            ),
          ],
        ]),
      );
    },
  );

  test(
    'Given a streaming method that echoes a stream of lists of data objects, when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming.simpleListInOutDataStream(
        Stream.fromIterable([
          [SimpleData(num: 1), SimpleData(num: 2)],
          [SimpleData(num: 3), SimpleData(num: 4)],
        ]),
      );

      expect(
        response,
        emitsInOrder([
          [
            isA<SimpleData>().having((s) => s.num, 'num', 1),
            isA<SimpleData>().having((s) => s.num, 'num', 2),
          ],
          [
            isA<SimpleData>().having((s) => s.num, 'num', 3),
            isA<SimpleData>().having((s) => s.num, 'num', 4),
          ],
        ]),
      );
    },
  );

  test(
    'Given a streaming method that echoes a stream of sets of integers, when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming.simpleSetInOutIntStream(
        Stream.fromIterable([
          {1, 2, 3},
          {4, 5, 6},
        ]),
      );

      expect(
        response,
        emitsInOrder([
          {1, 2, 3},
          {4, 5, 6},
        ]),
      );
    },
  );

  test(
    'Given a streaming method that echoes a stream of sets of data objects, when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming.simpleSetInOutDataStream(
        Stream.fromIterable([
          {SimpleData(num: 1), SimpleData(num: 2)},
          {SimpleData(num: 3), SimpleData(num: 4)},
        ]),
      );

      expect(
        response,
        emitsInOrder([
          {
            isA<SimpleData>().having((s) => s.num, 'num', 1),
            isA<SimpleData>().having((s) => s.num, 'num', 2),
          },
          {
            isA<SimpleData>().having((s) => s.num, 'num', 3),
            isA<SimpleData>().having((s) => s.num, 'num', 4),
          },
        ]),
      );
    },
  );

  test(
    'Given a streaming method that echoes a flattened stream of sets of data objects, when calling the method, then the input values are returned.',
    () async {
      var response = client.methodStreaming.nestedSetInListInOutDataStream(
        Stream.fromIterable([
          [
            {SimpleData(num: 1), SimpleData(num: 2)},
          ],
          [
            {SimpleData(num: 3)},
            {SimpleData(num: 4)},
          ],
        ]),
      );

      expect(
        response,
        emitsInOrder([
          {
            isA<SimpleData>().having((s) => s.num, 'num', 1),
            isA<SimpleData>().having((s) => s.num, 'num', 2),
          },
          {
            isA<SimpleData>().having((s) => s.num, 'num', 3),
          },
          {
            isA<SimpleData>().having((s) => s.num, 'num', 4),
          },
        ]),
      );
    },
  );
}
