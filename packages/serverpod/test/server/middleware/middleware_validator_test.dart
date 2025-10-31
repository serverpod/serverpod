import 'package:relic/relic.dart';
import 'package:serverpod/src/server/middleware/middleware_validator.dart';
import 'package:test/test.dart';

void main() {
  group('MiddlewareValidator', () {
    // Helper to create a simple middleware
    Middleware createDummyMiddleware() {
      return (Handler innerHandler) {
        return (RequestContext ctx) async {
          return await innerHandler(ctx);
        };
      };
    }

    group('validate', () {
      test('accepts empty middleware list without warnings', () {
        var warningCalled = false;
        MiddlewareValidator.validate(
          [],
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });

      test('accepts small middleware list (< 10 items) without warnings', () {
        final middleware = List.generate(5, (_) => createDummyMiddleware());
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });

      test('accepts exactly 10 middleware items without warnings', () {
        final middleware = List.generate(10, (_) => createDummyMiddleware());
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });

      test('warns for large middleware list (> 10 items)', () {
        final middleware = List.generate(12, (_) => createDummyMiddleware());
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isTrue);
      });

      test('warns for very large middleware list (20 items)', () {
        final middleware = List.generate(20, (_) => createDummyMiddleware());
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isTrue);
      });

      test('accepts single middleware without warnings', () {
        final middleware = [createDummyMiddleware()];
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });

      test('recommended max constant is 10', () {
        expect(MiddlewareValidator.recommendedMaxMiddleware, equals(10));
      });

      test('calls logWarning callback when middleware list is too large', () {
        final middleware = List.generate(12, (_) => createDummyMiddleware());
        String? warningMessage;

        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) {
            warningMessage = message;
          },
        );

        expect(warningMessage, isNotNull);
        expect(warningMessage, contains('Large middleware list detected'));
        expect(warningMessage, contains('12 middleware registered'));
      });

      test('does not call logWarning callback when list is acceptable', () {
        final middleware = List.generate(5, (_) => createDummyMiddleware());
        var warningCalled = false;

        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) {
            warningCalled = true;
          },
        );

        expect(warningCalled, isFalse);
      });
    });

    group('duplicate detection limitation', () {
      test('cannot detect duplicate middleware functions (by design)', () {
        // This test documents the limitation that duplicate middleware
        // cannot be detected because middleware are functions compared by reference
        final middleware1 = createDummyMiddleware();
        final middleware2 = createDummyMiddleware();

        // These are different references even if functionally identical
        expect(identical(middleware1, middleware2), isFalse);

        // Validator will accept this list without warnings even though both middleware
        // do the same thing - this is expected behavior
        var warningCalled = false;
        MiddlewareValidator.validate(
          [middleware1, middleware2],
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });

      test('same middleware instance registered twice is not detected', () {
        final middleware = createDummyMiddleware();

        // Same instance registered twice - these ARE identical
        expect(identical(middleware, middleware), isTrue);

        // However, the validator doesn't check for this because:
        // 1. It's rare in practice (most middleware are created inline)
        // 2. There may be valid use cases for running same middleware twice
        // 3. The performance impact check (>10 items) is more important
        var warningCalled = false;
        MiddlewareValidator.validate(
          [middleware, middleware],
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });
    });

    group('edge cases', () {
      test('warns for middleware list with exactly threshold + 1 items', () {
        const threshold = MiddlewareValidator.recommendedMaxMiddleware;
        final middleware = List.generate(threshold + 1, (_) => createDummyMiddleware());
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isTrue);
      });

      test('accepts middleware list with exactly threshold items', () {
        const threshold = MiddlewareValidator.recommendedMaxMiddleware;
        final middleware = List.generate(threshold, (_) => createDummyMiddleware());
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });

      test('accepts middleware list with threshold - 1 items', () {
        const threshold = MiddlewareValidator.recommendedMaxMiddleware;
        final middleware = List.generate(threshold - 1, (_) => createDummyMiddleware());
        var warningCalled = false;
        MiddlewareValidator.validate(
          middleware,
          logWarning: (message) => warningCalled = true,
        );
        expect(warningCalled, isFalse);
      });
    });
  });
}
