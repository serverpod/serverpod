import 'package:relic/relic.dart';
import 'package:relic/src/logger/logger.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';

void main() {
  late bool gotLog;

  setUp(() {
    gotLog = false;
  });

  void logger(
    String msg, {
    LoggerType type = LoggerType.info,
    StackTrace? stackTrace,
  }) {
    expect(gotLog, isFalse);
    gotLog = true;
    expect(type, LoggerType.info);
    expect(msg, contains(RequestMethod.get.value));
    expect(msg, contains('[200]'));
  }

  test(
      'Given a request with a synchronous response when logged then it logs the request',
      () async {
    var handler = const Pipeline()
        .addMiddleware(logRequests(logger: logger))
        .addHandler(syncHandler);

    await makeSimpleRequest(handler);
    expect(gotLog, isTrue);
  });

  test(
      'Given a request with an asynchronous response when logged then it logs the request',
      () async {
    var handler = const Pipeline()
        .addMiddleware(logRequests(logger: logger))
        .addHandler(asyncHandler);

    await makeSimpleRequest(handler);
    expect(gotLog, isTrue);
  });

  test(
    'Given a request with an asynchronous error response when logged then it logs the error',
    () {
      var handler = const Pipeline().addMiddleware(logRequests(
        logger: (
          msg, {
          LoggerType type = LoggerType.info,
          StackTrace? stackTrace,
        }) {
          expect(gotLog, isFalse);
          gotLog = true;
          expect(type, LoggerType.error);
          expect(msg, contains('\tGET\t/'));
          expect(msg, contains('oh no'));
        },
      )).addHandler(
        (request) {
          throw StateError('oh no');
        },
      );

      expect(makeSimpleRequest(handler), throwsA(isOhNoStateError));
    },
  );

  test("Given a HijackException when thrown then it doesn't log the exception",
      () {
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
