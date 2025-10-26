import 'package:relic/relic.dart';
import 'package:serverpod/src/server/middleware/middleware.dart';
import 'package:serverpod/src/server/middleware/middleware_validator.dart';
import 'package:test/test.dart';

/// Test middleware implementation for testing validation.
class TestMiddleware implements HttpMiddleware {
  final String id;

  TestMiddleware(this.id);

  @override
  Future<Response> handle(Request request, NextFunction next) async {
    return next(request);
  }

  @override
  String toString() => 'TestMiddleware($id)';
}

void main() {
  group('Given validateMiddleware function', () {
    group('when validating duplicate middleware', () {
      test('then throws ArgumentError', () {
        final middleware1 = TestMiddleware('test');
        final middlewareWithDuplicates = [
          middleware1,
          TestMiddleware('test2'),
          middleware1, // Duplicate!
        ];

        expect(
          () => validateMiddleware(middlewareWithDuplicates),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('duplicate instances'),
            ),
          ),
        );
      });

      test('then error message mentions duplicate count', () {
        final middleware1 = TestMiddleware('test');
        final middlewareWithDuplicates = [
          middleware1,
          middleware1,
          middleware1,
        ];

        expect(
          () => validateMiddleware(middlewareWithDuplicates),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Found 2 duplicate(s)'),
            ),
          ),
        );
      });

      test('then error message is descriptive and actionable', () {
        final middleware1 = TestMiddleware('test');
        final middlewareWithDuplicates = [middleware1, middleware1];

        expect(
          () => validateMiddleware(middlewareWithDuplicates),
          throwsA(
            isA<ArgumentError>()
                .having(
                  (e) => e.message,
                  'message',
                  contains('same middleware object'),
                )
                .having(
                  (e) => e.message,
                  'message',
                  contains('configuration error'),
                ),
          ),
        );
      });
    });

    group('when validating unique middleware', () {
      test('then returns success message', () {
        final middleware = [
          TestMiddleware('test1'),
          TestMiddleware('test2'),
          TestMiddleware('test3'),
        ];

        final warnings = validateMiddleware(middleware);

        expect(
          warnings,
          contains(contains('Middleware validation passed: 3 middleware')),
        );
      });

      test('then does not throw', () {
        final middleware = [
          TestMiddleware('test1'),
          TestMiddleware('test2'),
        ];

        expect(() => validateMiddleware(middleware), returnsNormally);
      });

      test('with single middleware then returns success', () {
        final middleware = [TestMiddleware('test')];

        final warnings = validateMiddleware(middleware);

        expect(
          warnings,
          contains(contains('Middleware validation passed: 1 middleware')),
        );
      });
    });

    group('when validating null or empty middleware', () {
      test('with null then returns empty warnings', () {
        final warnings = validateMiddleware(null);

        expect(warnings, isEmpty);
      });

      test('with empty list then returns empty warnings', () {
        final warnings = validateMiddleware([]);

        expect(warnings, isEmpty);
      });

      test('with null then does not throw', () {
        expect(() => validateMiddleware(null), returnsNormally);
      });
    });

    group('when validating large middleware list', () {
      test('with >10 items then returns warning', () {
        final largeList = List.generate(
          15,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(largeList);

        expect(
          warnings,
          contains(
            contains('WARNING: Middleware list contains 15 items'),
          ),
        );
      });

      test('with >10 items then warning mentions latency', () {
        final largeList = List.generate(
          12,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(largeList);

        expect(
          warnings,
          contains(contains('adds latency')),
        );
      });

      test('with >10 items then warning suggests consolidation', () {
        final largeList = List.generate(
          11,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(largeList);

        expect(
          warnings,
          contains(contains('consolidating')),
        );
      });

      test('with <=10 items then no warning about size', () {
        final normalList = List.generate(
          10,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(normalList);

        expect(
          warnings.where((w) => w.contains('WARNING')),
          isEmpty,
        );
      });

      test('with 5 items then only success message', () {
        final normalList = List.generate(
          5,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(normalList);

        expect(warnings, hasLength(1));
        expect(warnings[0], contains('Middleware validation passed'));
      });
    });

    group('when validating edge cases', () {
      test('with exactly 10 items then no size warning', () {
        final thresholdList = List.generate(
          10,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(thresholdList);

        expect(
          warnings.where((w) => w.contains('WARNING')),
          isEmpty,
        );
      });

      test('with exactly 11 items then shows size warning', () {
        final justOverList = List.generate(
          11,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(justOverList);

        expect(
          warnings.where((w) => w.contains('WARNING')),
          isNotEmpty,
        );
      });

      test('with multiple duplicates of same instance then counts all', () {
        final middleware1 = TestMiddleware('test');
        final multiDup = [
          middleware1,
          middleware1,
          middleware1,
          middleware1,
        ];

        expect(
          () => validateMiddleware(multiDup),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Found 3 duplicate(s)'),
            ),
          ),
        );
      });

      test('with different instances but same id then passes', () {
        // Different instances with same ID are valid
        final middleware = [
          TestMiddleware('same-id'),
          TestMiddleware('same-id'),
          TestMiddleware('same-id'),
        ];

        expect(() => validateMiddleware(middleware), returnsNormally);
      });
    });

    group('when validation returns warnings', () {
      test('then warnings list is never null', () {
        final warnings1 = validateMiddleware(null);
        final warnings2 = validateMiddleware([]);
        final warnings3 = validateMiddleware([TestMiddleware('test')]);

        expect(warnings1, isNotNull);
        expect(warnings2, isNotNull);
        expect(warnings3, isNotNull);
      });

      test('with valid middleware then returns at least success message', () {
        final middleware = [TestMiddleware('test')];

        final warnings = validateMiddleware(middleware);

        expect(warnings, isNotEmpty);
        expect(warnings.last, contains('validation passed'));
      });

      test('with large list then returns warning plus success', () {
        final largeList = List.generate(
          15,
          (i) => TestMiddleware('middleware$i'),
        );

        final warnings = validateMiddleware(largeList);

        expect(warnings, hasLength(2));
        expect(warnings[0], contains('WARNING'));
        expect(warnings[1], contains('validation passed'));
      });
    });
  });
}
