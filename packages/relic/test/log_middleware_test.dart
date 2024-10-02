import 'package:relic/relic.dart';
import 'package:relic/src/method/method.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  late bool gotLog;

  setUp(() {
    gotLog = false;
  });

  void logger(String msg, bool isError) {
    expect(gotLog, isFalse);
    gotLog = true;
    expect(isError, isFalse);
    expect(msg, contains(Method.get.value));
    expect(msg, contains('[200]'));
  }

  test('logs a request with a synchronous response', () async {
    var handler = const Pipeline()
        .addMiddleware(logRequests(logger: logger))
        .addHandler(syncHandler);

    await makeSimpleRequest(handler);
    expect(gotLog, isTrue);
  });

  test('logs a request with an asynchronous response', () async {
    var handler = const Pipeline()
        .addMiddleware(logRequests(logger: logger))
        .addHandler(asyncHandler);

    await makeSimpleRequest(handler);
    expect(gotLog, isTrue);
  });

  test('logs a request with an asynchronous error response', () {
    var handler =
        const Pipeline().addMiddleware(logRequests(logger: (msg, isError) {
      expect(gotLog, isFalse);
      gotLog = true;
      expect(isError, isTrue);
      expect(msg, contains('\tGET\t/'));
      expect(msg, contains('oh no'));
    })).addHandler((request) {
      throw StateError('oh no');
    });

    expect(makeSimpleRequest(handler), throwsA(isOhNoStateError));
  });

  test("doesn't log a HijackException", () {
    var handler = const Pipeline()
        .addMiddleware(logRequests(logger: logger))
        .addHandler((request) => throw const HijackException());

    expect(
        makeSimpleRequest(handler).whenComplete(() {
          expect(gotLog, isFalse);
        }),
        throwsHijackException);
  });
}
