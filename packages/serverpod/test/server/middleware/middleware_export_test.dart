import 'package:relic/relic.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

/// Tests that middleware types are properly exported from the public API.
///
/// This test ensures that users can import and use middleware types
/// without needing to access internal implementation files.
void main() {
  group('Given public API exports', () {
    test('when importing serverpod then HttpMiddleware is accessible', () {
      // This test verifies that HttpMiddleware is exported and can be used
      // to create custom middleware implementations.

      // Should compile without errors - HttpMiddleware is accessible
      final middleware = _TestMiddleware();

      expect(middleware, isA<HttpMiddleware>());
    });

    test('when importing serverpod then NextFunction type is accessible', () {
      // NextFunction should be accessible for type annotations
      NextFunction createChain(NextFunction handler) {
        return handler;
      }

      // Should compile - NextFunction is exported
      final mockNext = (Request request) async => Response.ok();
      final result = createChain(mockNext);

      expect(result, isA<NextFunction>());
    });

    test('when implementing custom middleware then it works with ExperimentalFeatures',
        () {
      // Users should be able to create middleware using only public imports
      final customMiddleware = _CustomLoggingMiddleware();

      final features = ExperimentalFeatures(
        middleware: [customMiddleware],
      );

      expect(features.middleware, isNotNull);
      expect(features.middleware, hasLength(1));
      expect(features.middleware![0], isA<HttpMiddleware>());
      expect(features.middleware![0], same(customMiddleware));
    });

    test('when creating middleware chain then handle method works correctly',
        () async {
      // Verify the complete middleware interface works as expected
      final executionLog = <String>[];

      final middleware1 = _LoggingMiddleware('MW1', executionLog);
      final middleware2 = _LoggingMiddleware('MW2', executionLog);

      // Create a simple chain manually
      NextFunction finalHandler = (request) async {
        executionLog.add('CORE');
        return Response.ok(body: Body.fromString('Success'));
      };

      // Build chain: MW1 -> MW2 -> CORE
      // We need to wrap from inside out: start with CORE, wrap with MW2, then MW1
      NextFunction chain = finalHandler;
      for (var mw in [middleware2, middleware1]) {
        final next = chain;
        chain = (request) async => await mw.handle(request, next);
      }

      // Execute chain
      final request = Request(Method.get, Uri.parse('http://localhost/test'));
      final response = await chain(request);

      // Verify execution order
      expect(executionLog, ['MW1-before', 'MW2-before', 'CORE', 'MW2-after', 'MW1-after']);
      expect(response.statusCode, 200);
    });

    test('when middleware short-circuits then chain stops', () async {
      // Verify that middleware can stop the chain by not calling next
      final executionLog = <String>[];

      final middleware1 = _LoggingMiddleware('MW1', executionLog);
      final middleware2 = _ShortCircuitMiddleware(executionLog);
      final middleware3 = _LoggingMiddleware('MW3', executionLog);

      // Build chain: MW1 -> MW2 (short-circuit) -> MW3 -> CORE
      NextFunction finalHandler = (request) async {
        executionLog.add('CORE');
        return Response.ok();
      };

      // Build from inside out: CORE -> MW3 -> MW2 -> MW1
      NextFunction chain = finalHandler;
      for (var mw in [middleware3, middleware2, middleware1]) {
        final next = chain;
        chain = (request) async => await mw.handle(request, next);
      }

      final request = Request(Method.get, Uri.parse('http://localhost/test'));
      final response = await chain(request);

      // MW2 short-circuits, so MW3 and CORE should not execute
      expect(executionLog, ['MW1-before', 'SHORT-CIRCUIT', 'MW1-after']);
      expect(response.statusCode, 403);
    });

    test('when middleware modifies response then modifications are preserved',
        () async {
      // Verify that middleware can modify responses
      final headerMiddleware = _HeaderMiddleware();

      NextFunction finalHandler = (request) async {
        return Response.ok(body: Body.fromString('Original'));
      };

      final request = Request(Method.get, Uri.parse('http://localhost/test'));
      final response = await headerMiddleware.handle(request, finalHandler);

      expect(response.statusCode, 200);
      expect(response.headers['X-Custom-Header'], ['test-value']);
    });

    test('when multiple middleware lists created then types are consistent', () {
      // Ensure type consistency across multiple uses
      final list1 = <HttpMiddleware>[
        _TestMiddleware(),
        _TestMiddleware(),
      ];

      final list2 = <HttpMiddleware>[
        _CustomLoggingMiddleware(),
      ];

      final features1 = ExperimentalFeatures(middleware: list1);
      final features2 = ExperimentalFeatures(middleware: list2);

      expect(features1.middleware, hasLength(2));
      expect(features2.middleware, hasLength(1));

      // Both should have the same type
      expect(features1.middleware.runtimeType, features2.middleware.runtimeType);
    });
  });

  group('Given middleware error handling', () {
    test('when middleware throws exception then it propagates', () async {
      final errorMiddleware = _ErrorThrowingMiddleware();

      NextFunction finalHandler = (request) async => Response.ok();

      final request = Request(Method.get, Uri.parse('http://localhost/test'));

      expect(
        () => errorMiddleware.handle(request, finalHandler),
        throwsA(isA<Exception>()),
      );
    });

    test('when middleware catches error then chain continues', () async {
      final executionLog = <String>[];

      final catchingMiddleware = _ErrorCatchingMiddleware(executionLog);
      final throwingMiddleware = _ErrorThrowingMiddleware();

      // Build chain: Catching -> Throwing
      NextFunction chain = (request) => throwingMiddleware.handle(
            request,
            (r) async => Response.ok(),
          );

      final wrappedChain =
          (Request r) => catchingMiddleware.handle(r, (req) => chain(req));

      final request = Request(Method.get, Uri.parse('http://localhost/test'));
      final response = await wrappedChain(request);

      expect(executionLog, contains('ERROR-CAUGHT'));
      expect(response.statusCode, 500);
    });
  });

  group('Given real-world middleware patterns', () {
    test('when creating authentication middleware then it works correctly',
        () async {
      final authMiddleware = _ApiKeyAuthMiddleware('valid-key');

      NextFunction protectedHandler = (request) async {
        return Response.ok(body: Body.fromString('Protected resource'));
      };

      // Test with valid key
      final validRequest = Request(
        Method.get,
        Uri.parse('http://localhost/protected'),
        headers: Headers.build((h) => h['X-API-Key'] = ['valid-key']),
      );
      final validResponse =
          await authMiddleware.handle(validRequest, protectedHandler);
      expect(validResponse.statusCode, 200);

      // Test with invalid key
      final invalidRequest = Request(
        Method.get,
        Uri.parse('http://localhost/protected'),
        headers: Headers.build((h) => h['X-API-Key'] = ['invalid-key']),
      );
      final invalidResponse =
          await authMiddleware.handle(invalidRequest, protectedHandler);
      expect(invalidResponse.statusCode, 401);

      // Test with no key
      final noKeyRequest = Request(Method.get, Uri.parse('http://localhost/protected'));
      final noKeyResponse =
          await authMiddleware.handle(noKeyRequest, protectedHandler);
      expect(noKeyResponse.statusCode, 401);
    });

    test('when creating timing middleware then it measures duration', () async {
      final timings = <String, int>{};
      final timingMiddleware = _TimingMiddleware(timings);

      NextFunction slowHandler = (request) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Response.ok();
      };

      final request = Request(Method.get, Uri.parse('http://localhost/test'));
      await timingMiddleware.handle(request, slowHandler);

      expect(timings, contains('GET:/test'));
      expect(timings['GET:/test'], greaterThanOrEqualTo(10));
    });
  });
}

// Test middleware implementations

class _TestMiddleware implements HttpMiddleware {
  @override
  Future<Response> handle(Request request, NextFunction next) async {
    return next(request);
  }
}

class _CustomLoggingMiddleware implements HttpMiddleware {
  @override
  Future<Response> handle(Request request, NextFunction next) async {
    // Simple pass-through middleware
    return next(request);
  }
}

class _LoggingMiddleware implements HttpMiddleware {
  final String name;
  final List<String> log;

  _LoggingMiddleware(this.name, this.log);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    log.add('$name-before');
    final response = await next(request);
    log.add('$name-after');
    return response;
  }
}

class _ShortCircuitMiddleware implements HttpMiddleware {
  final List<String> log;

  _ShortCircuitMiddleware(this.log);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    log.add('SHORT-CIRCUIT');
    // Don't call next - return early
    return Response.forbidden(body: Body.fromString('Forbidden'));
  }
}

class _HeaderMiddleware implements HttpMiddleware {
  @override
  Future<Response> handle(Request request, NextFunction next) async {
    final response = await next(request);

    return Response(
      response.statusCode,
      body: response.body,
      headers: response.headers.transform((h) {
        h['X-Custom-Header'] = ['test-value'];
      }),
    );
  }
}

class _ErrorThrowingMiddleware implements HttpMiddleware {
  @override
  Future<Response> handle(Request request, NextFunction next) async {
    throw Exception('Test error');
  }
}

class _ErrorCatchingMiddleware implements HttpMiddleware {
  final List<String> log;

  _ErrorCatchingMiddleware(this.log);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    try {
      return await next(request);
    } catch (e) {
      log.add('ERROR-CAUGHT');
      return Response.internalServerError(
        body: Body.fromString('Error caught'),
      );
    }
  }
}

class _ApiKeyAuthMiddleware implements HttpMiddleware {
  final String validApiKey;

  _ApiKeyAuthMiddleware(this.validApiKey);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    final apiKey = request.headers['X-API-Key']?.firstOrNull;

    if (apiKey != validApiKey) {
      return Response.unauthorized(
        body: Body.fromString('Invalid API key'),
      );
    }

    return next(request);
  }
}

class _TimingMiddleware implements HttpMiddleware {
  final Map<String, int> timings;

  _TimingMiddleware(this.timings);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    final stopwatch = Stopwatch()..start();
    final response = await next(request);
    stopwatch.stop();

    final key = '${request.method.name.toUpperCase()}:${request.requestedUri.path}';
    timings[key] = stopwatch.elapsedMilliseconds;

    return response;
  }
}
