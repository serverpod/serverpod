import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  group('Given client with onSucceededCall callback', () {
    test('when successfully calling endpoint then callback is called.',
        () async {
      var succeededCallsCount = 0;
      var client = Client(
        serverUrl,
        onSucceededCall: () {
          succeededCallsCount++;
        },
      );

      await client.simple.hello('test');
      expect(succeededCallsCount, greaterThan(0),
          reason: 'Callback was not called even if call succeeded.');
    });

    test('when endpoint call fails then callback is not called.', () async {
      var succeededCallsCount = 0;
      var client = Client(
        serverUrl,
        onSucceededCall: () {
          succeededCallsCount++;
        },
      );

      try {
        await client.failedCalls.failedCall();
      } catch (_) {}

      expect(succeededCallsCount, equals(0),
          reason: 'Callback was called even if call failed.');
    });
  });

  group('Given client with onFailedCall callback', () {
    test('when endpoint call fails then callback is called.', () async {
      var onFailedCallCount = 0;
      var client = Client(
        serverUrl,
        onFailedCall: (Object error) {
          onFailedCallCount++;
        },
      );

      try {
        await client.failedCalls.failedCall();
      } catch (_) {}

      expect(onFailedCallCount, greaterThan(0),
          reason: 'Callback was not called even if call succeeded.');
    });

    test('when successfully calling endpoint then callback is not called.',
        () async {
      var onFailedCallCount = 0;
      var client = Client(
        serverUrl,
        onFailedCall: (Object error) {
          onFailedCallCount++;
        },
      );

      await client.simple.hello('test');
      expect(onFailedCallCount, equals(0),
          reason: 'Callback was called even if call failed.');
    });
  });
}
