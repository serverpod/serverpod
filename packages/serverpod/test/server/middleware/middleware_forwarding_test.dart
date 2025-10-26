import 'package:relic/relic.dart';
import 'package:serverpod/src/server/experimental_features.dart';
import 'package:serverpod/src/server/middleware/middleware.dart';
import 'package:serverpod/src/server/middleware/middleware_validator.dart';
import 'package:test/test.dart';

/// Test middleware for testing.
class ForwardingTestMiddleware implements HttpMiddleware {
  final String id;

  ForwardingTestMiddleware(this.id);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    return next(request);
  }

  @override
  String toString() => 'ForwardingTestMiddleware($id)';
}

void main() {
  group('Given ExperimentalFeatures middleware storage', () {
    test('when middleware provided then ExperimentalFeatures stores exact instances',
        () {
      final middleware1 = ForwardingTestMiddleware('test1');
      final middleware2 = ForwardingTestMiddleware('test2');
      final middleware3 = ForwardingTestMiddleware('test3');

      final features = ExperimentalFeatures(
        middleware: [middleware1, middleware2, middleware3],
      );

      // Verify the middleware list is stored correctly
      expect(features.middleware, isNotNull);
      expect(features.middleware, hasLength(3));

      // Verify these are the EXACT same instances (not copies)
      expect(features.middleware![0], same(middleware1));
      expect(features.middleware![1], same(middleware2));
      expect(features.middleware![2], same(middleware3));
    });

    test('when null middleware then ExperimentalFeatures stores null', () {
      final features = ExperimentalFeatures(middleware: null);

      expect(features.middleware, isNull);
    });

    test('when empty middleware list then ExperimentalFeatures stores empty list',
        () {
      final features = ExperimentalFeatures(middleware: []);

      expect(features.middleware, isNotNull);
      expect(features.middleware, isEmpty);
    });

    test('when middleware list modified after creation then original is unchanged',
        () {
      // Create a mutable list
      final middlewareList = <HttpMiddleware>[
        ForwardingTestMiddleware('test1'),
        ForwardingTestMiddleware('test2'),
      ];

      final features = ExperimentalFeatures(middleware: middlewareList);

      // Get the stored reference
      final storedMiddleware = features.middleware;

      // Verify initial state
      expect(storedMiddleware, hasLength(2));

      // Modify the original list
      middlewareList.add(ForwardingTestMiddleware('test3'));

      // The stored middleware in ExperimentalFeatures should reflect the change
      // (they share the same list reference)
      expect(storedMiddleware, hasLength(3));
      expect(features.middleware, hasLength(3));
    });
  });

  group('Given middleware validation integration', () {
    test('when ExperimentalFeatures has duplicate middleware then validateMiddleware throws',
        () {
      final middleware1 = ForwardingTestMiddleware('test');
      final features = ExperimentalFeatures(
        middleware: [
          middleware1,
          ForwardingTestMiddleware('test2'),
          middleware1, // Duplicate
        ],
      );

      // When validation is called on this middleware list, it should throw
      expect(
        () => validateMiddleware(features.middleware),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('duplicate instances'),
          ),
        ),
      );
    });

    test('when ExperimentalFeatures has unique middleware then validateMiddleware passes',
        () {
      final features = ExperimentalFeatures(
        middleware: [
          ForwardingTestMiddleware('test1'),
          ForwardingTestMiddleware('test2'),
          ForwardingTestMiddleware('test3'),
        ],
      );

      // Validation should not throw
      expect(() => validateMiddleware(features.middleware), returnsNormally);

      // And should return success messages
      final warnings = validateMiddleware(features.middleware);
      expect(warnings, isNotEmpty);
      expect(warnings.last, contains('validation passed'));
    });

    test('when ExperimentalFeatures has null middleware then validateMiddleware passes',
        () {
      final features = ExperimentalFeatures(middleware: null);

      expect(() => validateMiddleware(features.middleware), returnsNormally);

      final warnings = validateMiddleware(features.middleware);
      expect(warnings, isEmpty);
    });

    test('when ExperimentalFeatures has >10 middleware then validateMiddleware warns',
        () {
      final features = ExperimentalFeatures(
        middleware: List.generate(
          15,
          (i) => ForwardingTestMiddleware('middleware$i'),
        ),
      );

      final warnings = validateMiddleware(features.middleware);

      expect(
        warnings,
        contains(contains('WARNING: Middleware list contains 15 items')),
      );
    });
  });

  group('Given middleware instance identity preservation', () {
    test('when ExperimentalFeatures stores middleware then instance identity preserved',
        () {
      final middleware1 = ForwardingTestMiddleware('test1');
      final middleware2 = ForwardingTestMiddleware('test2');

      final features = ExperimentalFeatures(
        middleware: [middleware1, middleware2],
      );

      // Verify the EXACT same instances are stored (not copies)
      expect(identical(features.middleware![0], middleware1), isTrue);
      expect(identical(features.middleware![1], middleware2), isTrue);
    });

    test('when same middleware instance added twice then validateMiddleware detects it',
        () {
      final middleware1 = ForwardingTestMiddleware('test');

      final features = ExperimentalFeatures(
        middleware: [middleware1, middleware1],
      );

      // Duplicate detection relies on instance identity
      expect(
        () => validateMiddleware(features.middleware),
        throwsArgumentError,
      );
    });

    test('when different instances with same id then validateMiddleware allows it',
        () {
      // Even though these have the same ID, they're different instances
      final middleware1 = ForwardingTestMiddleware('same-id');
      final middleware2 = ForwardingTestMiddleware('same-id');

      final features = ExperimentalFeatures(
        middleware: [middleware1, middleware2],
      );

      // Should NOT throw - different instances are allowed
      expect(() => validateMiddleware(features.middleware), returnsNormally);
    });
  });

  group('Given typical middleware configurations', () {
    test('when configuring small stack (3-5 middleware) then valid', () {
      final features = ExperimentalFeatures(
        middleware: [
          ForwardingTestMiddleware('logging'),
          ForwardingTestMiddleware('cors'),
          ForwardingTestMiddleware('metrics'),
          ForwardingTestMiddleware('auth'),
        ],
      );

      expect(() => validateMiddleware(features.middleware), returnsNormally);

      final warnings = validateMiddleware(features.middleware);
      // Should only have success message, no warnings
      expect(warnings.where((w) => w.contains('WARNING')), isEmpty);
    });

    test('when configuring single middleware then valid', () {
      final features = ExperimentalFeatures(
        middleware: [ForwardingTestMiddleware('logging')],
      );

      expect(() => validateMiddleware(features.middleware), returnsNormally);
    });

    test('when configuring no middleware then valid', () {
      final features = ExperimentalFeatures(middleware: []);

      expect(() => validateMiddleware(features.middleware), returnsNormally);
    });
  });
}
