// ignore_for_file: only_throw_errors

import 'dart:async';

import 'package:relic/relic.dart';
import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  test('forwards the request and response if both handlers are null', () async {
    var handler = const Pipeline()
        .addMiddleware(createMiddleware())
        .addHandler((request) {
      return syncHandler(
        request,
        headers: Headers.request(
          from: FromHeader(['innerHandler']),
        ),
      );
    });

    final response = await makeSimpleRequest(handler);
    expect(response.headers.from?.emails, contains('innerHandler'));
  });

  group('requestHandler', () {
    test('sync null response forwards to inner handler', () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(requestHandler: (request) => null))
          .addHandler(syncHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.custom['from'], isNull);
    });

    test('async null response forwards to inner handler', () async {
      var handler = const Pipeline()
          .addMiddleware(
              createMiddleware(requestHandler: (request) => Future.value(null)))
          .addHandler(syncHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from, isNull);
    });

    test('sync response is returned', () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => _middlewareResponse))
          .addHandler(_failHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });

    test('async response is returned', () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => Future.value(_middlewareResponse)))
          .addHandler(_failHandler);

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });

    group('with responseHandler', () {
      test('with sync result, responseHandler is not called', () async {
        var middleware = createMiddleware(
            requestHandler: (request) => _middlewareResponse,
            responseHandler: (response) => fail('should not be called'));

        var handler =
            const Pipeline().addMiddleware(middleware).addHandler(syncHandler);

        final response = await makeSimpleRequest(handler);
        expect(response.headers.from?.emails, contains('middleware'));
      });

      test('with async result, responseHandler is not called', () async {
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

  group('responseHandler', () {
    test('innerHandler sync response is seen, replaced value continues',
        () async {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(responseHandler: (response) {
        expect(response.headers.from?.emails, contains('handler'));
        return _middlewareResponse;
      })).addHandler((request) {
        return syncHandler(
          request,
          headers: Headers.response(from: FromHeader(['handler'])),
        );
      });

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });

    test('innerHandler async response is seen, async value continues',
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
              from: FromHeader(['handler']),
            ),
          ),
        );
      });

      final response = await makeSimpleRequest(handler);
      expect(response.headers.from?.emails, contains('middleware'));
    });
  });

  group('error handling', () {
    test('sync error thrown by requestHandler bubbles down', () {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => throw 'middleware error'))
          .addHandler(_failHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test('async error thrown by requestHandler bubbles down', () {
      var handler = const Pipeline()
          .addMiddleware(createMiddleware(
              requestHandler: (request) => Future.error('middleware error')))
          .addHandler(_failHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test('throw from responseHandler does not hit error handler', () {
      var middleware = createMiddleware(
          responseHandler: (response) {
            throw 'middleware error';
          },
          errorHandler: (e, s) => fail('should never get here'));

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler(syncHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test('requestHandler throw does not hit errorHandlers', () {
      var middleware = createMiddleware(
          requestHandler: (request) {
            throw 'middleware error';
          },
          errorHandler: (e, s) => fail('should never get here'));

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler(syncHandler);

      expect(makeSimpleRequest(handler), throwsA('middleware error'));
    });

    test('inner handler throws, is caught by errorHandler with response',
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

    test('inner handler throws, is caught by errorHandler and rethrown', () {
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
        'error thrown by inner handler without a middleware errorHandler is '
        'rethrown', () {
      var middleware = createMiddleware();

      var handler =
          const Pipeline().addMiddleware(middleware).addHandler((request) {
        throw 'bad handler';
      });

      expect(makeSimpleRequest(handler), throwsA('bad handler'));
    });

    test("doesn't handle HijackException", () {
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
  headers: Headers.response(from: FromHeader(['middleware'])),
);
