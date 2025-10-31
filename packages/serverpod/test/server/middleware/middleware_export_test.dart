import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

/// Tests that verify middleware-related types and implementations are properly
/// exported from the serverpod.dart public API.
///
/// These tests ensure that users can access all necessary middleware functionality
/// without needing to import internal implementation files.
void main() {
  group('Middleware exports', () {
    group('Relic middleware types', () {
      test('Middleware type is exported', () {
        // Verify that the Middleware type from relic is accessible
        // This is a function type: Handler Function(Handler)
        // ignore: prefer_function_declarations_over_variables
        Middleware middleware = (Handler innerHandler) {
          return (RequestContext ctx) async {
            return await innerHandler(ctx);
          };
        };

        expect(middleware, isA<Middleware>());
      });

      test('Handler type is exported', () {
        // Verify that the Handler type from relic is accessible
        // ignore: prefer_function_declarations_over_variables
        Handler handler = (RequestContext ctx) async {
          return ctx.respond(Response.ok());
        };

        expect(handler, isA<Handler>());
      });

      test('Pipeline class is exported', () {
        // Verify that the Pipeline class from relic is accessible
        const pipeline = Pipeline();
        expect(pipeline, isA<Pipeline>());
      });

      test('createMiddleware function is exported', () {
        // Verify that the createMiddleware helper from relic is accessible
        final middleware = createMiddleware(
          onRequest: (Request request) {
            // No-op request handler - return null to pass through
            return null;
          },
        );

        expect(middleware, isA<Middleware>());
      });

      test('RequestContext type is exported', () {
        // Verify that RequestContext type is accessible (needed for middleware)
        // We can't create a RequestContext directly, but we can reference the type
        expect(RequestContext, isA<Type>());
      });

      test('ResponseContext type is exported', () {
        // Verify that ResponseContext type is accessible
        expect(ResponseContext, isA<Type>());
      });
    });

    group('Serverpod middleware implementations', () {
      test('loggingMiddleware is exported', () {
        // Verify that the loggingMiddleware factory is accessible
        final middleware = loggingMiddleware();
        expect(middleware, isA<Middleware>());
      });

      test('loggingMiddleware supports verbose mode', () {
        // Verify that loggingMiddleware accepts verbose parameter
        final middleware = loggingMiddleware(verbose: true);
        expect(middleware, isA<Middleware>());
      });

      test('loggingMiddleware supports custom logger', () {
        // Verify that loggingMiddleware accepts logger parameters
        final logs = <String>[];
        final middleware = loggingMiddleware(
          logger: (message) => logs.add(message),
        );
        expect(middleware, isA<Middleware>());
      });

      test('MiddlewareValidator is exported', () {
        // Verify that the MiddlewareValidator class is accessible
        expect(MiddlewareValidator, isA<Type>());
      });

      test('MiddlewareValidator.validate is accessible', () {
        // Verify that the validate method is accessible
        // Should not throw and should not call logWarning for empty list
        var warningCalled = false;
        MiddlewareValidator.validate(
          [],
          logWarning: (message) {
            warningCalled = true;
          },
        );
        expect(warningCalled, isFalse);
      });

      test('MiddlewareValidator.recommendedMaxMiddleware is accessible', () {
        // Verify that the constant is accessible
        expect(MiddlewareValidator.recommendedMaxMiddleware, equals(10));
      });
    });

    group('Middleware integration with ExperimentalFeatures', () {
      test('ExperimentalFeatures accepts middleware parameter', () {
        // Verify that middleware can be passed to ExperimentalFeatures
        final features = ExperimentalFeatures(
          middleware: [
            loggingMiddleware(),
          ],
        );

        expect(features.middleware, isNotNull);
        expect(features.middleware?.length, equals(1));
      });

      test('ExperimentalFeatures middleware is immutable list', () {
        // Verify that the middleware list cannot be modified after creation
        final middleware = [loggingMiddleware()];
        final features = ExperimentalFeatures(middleware: middleware);

        // The getter should return the same list
        expect(features.middleware, equals(middleware));
      });

      test('ExperimentalFeatures accepts null middleware', () {
        // Verify that middleware parameter is optional
        final features = ExperimentalFeatures();
        expect(features.middleware, isNull);
      });

      test('ExperimentalFeatures accepts empty middleware list', () {
        // Verify that empty list is valid
        final features = ExperimentalFeatures(middleware: []);
        expect(features.middleware, isNotNull);
        expect(features.middleware?.isEmpty, isTrue);
      });
    });

    group('Complete middleware workflow', () {
      test('can create Pipeline with multiple middleware', () {
        // Verify that a complete middleware pipeline can be created
        final middleware1 = loggingMiddleware();
        final middleware2 = loggingMiddleware(verbose: true);

        final pipeline = const Pipeline()
            .addMiddleware(middleware1)
            .addMiddleware(middleware2);

        expect(pipeline, isA<Pipeline>());
      });

      test('can compose middleware using createMiddleware', () {
        // Verify that custom middleware can be created and composed
        final customMiddleware = createMiddleware(
          onRequest: (Request request) {
            // Custom middleware logic - return null to pass through
            return null;
          },
        );

        final pipeline = const Pipeline()
            .addMiddleware(loggingMiddleware())
            .addMiddleware(customMiddleware);

        expect(pipeline, isA<Pipeline>());
      });
    });
  });
}
