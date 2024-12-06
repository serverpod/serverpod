// ignore_for_file: only_throw_errors

import 'dart:async';

import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';

void main() {
  test(
      'Given a middleware with null handlers when a request is processed then it forwards the request and response',
      () async {
    var handler = const Pipeline()
        .addMiddleware(createMiddleware())
        .addHandler((request) {
      return syncHandler(
        request,
        headers: Headers.request(
          from: FromHeader(emails: ['innerHandler']),
        ),
      );
    });

    final response = await makeSimpleRequest(handler);
    expect(response.headers.from?.emails, contains('innerHandler'));
  });

  group('Given a requestHandler', () {
    test(
        'when sync null response is returned then it forwards to inner handler',
        () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(requestHandler: (request) => null))
          .addHandler(syncHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.custom['from'], isNull);
    });

    test(
        'when async null response is returned then it forwards to inner handler',
        () async {
      var handler = const Pipeline()
          .addMiddleware(
              createMiddleware(requestHandler: (request) => Future.value(null)))
          .addHandler(syncHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from, isNull);
    });

    test('when sync response is returned then it is used', () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => _middlewareResponse))
          .addHandler(_failHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });

    test('when async response is returned then it is used', () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => Future.value(_middlewareResponse)))
          .addHandler(_failHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });

    group('Given a responseHandler', () {
      test('when sync result is returned then responseHandler is not called',
          () async {
        var middleware = createMiddleware(
            requestHandler: (request) => _middlewareResponse,
            responseHandler: (response) => fail('should not be called'));

        var handler =
            const Pipeline().addMiddleware(middleware).addHandler(syncHandler);

        final response = await makeSimpleRequest(handler);
        expect(response.headers.from?.emails, contains('middleware'));
      });

      test('when async result is returned then responseHandler is not called',
          () async {
        var middleware = createMiddleware(
            requestHandler: (request) => Future.value(_middlewareResponse),
            responseHandler: (response) => fail('should not be called'));
        var handler =
            const Pipeline().addMiddleware(middleware).addHandler(syncHandler);

        final response = await makeSimpleRequest(handler);
        expect(response.headers.from?.emails, contains('middleware'));
      });
    });
  });

  group('Given a responseHandler', () {
    test(
        'when innerHandler sync response is seen then replaced value continues',
        () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(responseHandler: (response) {
        expect(response.headers.from?.emails, contains('handler'));
        return _middlewareResponse;
      })).addHandler((request) {
        return syncHandler(
          request,
          headers: Headers.response(
            from: FromHeader(emails: ['handler']),
          ),
        );
      });

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });

    test('when innerHandler async response is seen then async value continues',
        () async {
      var handler = const Pipeline().addMiddleware(
        createMiddleware(
          responseHandler: (response) {
            expect(response.headers.from?.emails, contains('handler'));
            return Future.value(_middlewareResponse);
          },
        ),
      ).addHandler((request) {
        return Future(
          () => syncHandler(
            request,
            headers: Headers.response(
              from: FromHeader(emails: ['handler']),
            ),
          ),
        );
      });

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });
  });

  group('Given error handling', () {
    test('when sync error is thrown by requestHandler then it bubbles down',
        () {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => throw 'middleware error'))
          .addHandler(_failHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test('when async error is thrown by requestHandler then it bubbles down',
        () {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => Future.error('middleware error')))
          .addHandler(_failHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test('when throw from responseHandler then it does not hit error handler',
        () {
      var middleware = createMiddleware(
          responseHandler: (response) {
            throw 'middleware error';
          },
          errorHandler: (e, s) => fail('should never get here'));

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler(syncHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test('when requestHandler throw then it does not hit errorHandlers', () {
      var middleware = createMiddleware(
          requestHandler: (request) {
            throw 'middleware error';
          },
          errorHandler: (e, s) => fail('should never get here'));

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler(syncHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test(
        'when inner handler throws then it is caught by errorHandler with response',
        () async {
      var middleware = createMiddleware(errorHandler: (error, stack) {
        expect(error, 'bad handler');
        return _middlewareResponse;
      });

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler((request) {
        throw 'bad handler';
      });

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });

    test(
        'when inner handler throws then it is caught by errorHandler and rethrown',
        () {
      var middleware = createMiddleware(errorHandler: (Object error, stack) {
        expect(error, 'bad handler');
        throw error;
      });

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler((request) {
        throw 'bad handler';
      });

      expect(makeSimpleRequest(handler), throwsA('bad handler'));
    });

    test(
        'when error is thrown by inner handler without a middleware errorHandler then it is rethrown',
        () {
      var middleware = createMiddleware();

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler((request) {
        throw 'bad handler';
      });

      expect(makeSimpleRequest(handler), throwsA('bad handler'));
    });

    test("when HijackException is thrown then it doesn't handle it", () {
      var middleware = createMiddleware(errorHandler: (error, stack) {
        fail("error handler shouldn't be called");
      });

      var handler = const Pipeline()
          .addMiddleware(middleware)
          .addHandler((request) => throw const HijackException());

      expect(makeSimpleRequest(handler), throwsHijackException);
    });
  });
}

Response _failHandler(Request request) => fail('should never get here');

final Response _middlewareResponse = Response.ok(
  body: Body.fromString('middleware content'),
  headers: Headers.response(
    from: FromHeader(emails: ['middleware']),
  ),
);
