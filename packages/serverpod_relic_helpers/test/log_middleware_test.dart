// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:serverpod_relic_helpers/serverpod_relic_helpers.dart';
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
    expect(msg, contains('GET'));
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
