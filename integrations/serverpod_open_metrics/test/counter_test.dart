import 'package:serverpod_open_metrics/src/metrics/counter.dart';
import 'package:serverpod_open_metrics/src/metrics/metric.dart';
import 'package:test/test.dart';

void main() {
  group('Counter', () {
    test('starts at zero', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      expect(counter.value, equals(0));
    });

    test('increments by 1 by default', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      counter.inc();
      expect(counter.value, equals(1));
    });

    test('increments by custom amount', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      counter.inc(5);
      expect(counter.value, equals(5));
      counter.inc(3);
      expect(counter.value, equals(8));
    });

    test('throws on negative increment', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      expect(
        () => counter.inc(-1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on NaN increment', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      expect(
        () => counter.inc(double.nan),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on infinity increment', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      expect(
        () => counter.inc(double.infinity),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => counter.inc(double.negativeInfinity),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('resets to zero', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      counter.inc(10);
      counter.reset();
      expect(counter.value, equals(0));
    });

    test('has correct type', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      expect(counter.type, equals(MetricType.counter));
    });

    test('collects samples', () {
      final counter = Counter(name: 'test_counter', help: 'Test counter');
      counter.inc(5);

      final samples = counter.collect();
      expect(samples, hasLength(1));
      expect(samples[0].name, equals('test_counter'));
      expect(samples[0].value, equals(5));
      expect(samples[0].labels, isEmpty);
    });

    test('throws on invalid metric name', () {
      expect(
        () => Counter(name: '', help: 'Test'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => Counter(name: '123invalid', help: 'Test'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => Counter(name: 'invalid-name', help: 'Test'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('accepts valid metric names', () {
      expect(
        () => Counter(name: 'valid_name', help: 'Test'),
        returnsNormally,
      );
      expect(
        () => Counter(name: 'Valid_Name_123', help: 'Test'),
        returnsNormally,
      );
      expect(
        () => Counter(name: 'metric:name', help: 'Test'),
        returnsNormally,
      );
    });
  });

  group('LabeledCounter', () {
    test('creates children with labels', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method', 'status'],
      );

      counter.labels(['GET', '200']).inc();
      counter.labels(['POST', '201']).inc(2);

      expect(counter.labels(['GET', '200']).value, equals(1));
      expect(counter.labels(['POST', '201']).value, equals(2));
    });

    test('reuses same child for same labels', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      final child1 = counter.labels(['GET']);
      final child2 = counter.labels(['GET']);

      expect(identical(child1, child2), isTrue);
    });

    test('creates different children for different labels', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      final child1 = counter.labels(['GET']);
      final child2 = counter.labels(['POST']);

      expect(identical(child1, child2), isFalse);
    });

    test('throws on label count mismatch', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method', 'status'],
      );

      expect(
        () => counter.labels(['GET']),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => counter.labels(['GET', '200', 'extra']),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on invalid label names', () {
      expect(
        () => LabeledCounter(
          name: 'test',
          help: 'Test',
          labelNames: [''],
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => LabeledCounter(
          name: 'test',
          help: 'Test',
          labelNames: ['__reserved'],
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => LabeledCounter(
          name: 'test',
          help: 'Test',
          labelNames: ['invalid-name'],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('enforces cardinality limit', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['label'],
        maxCardinality: 2,
      );

      counter.labels(['value1']).inc();
      counter.labels(['value2']).inc();

      expect(
        () => counter.labels(['value3']).inc(),
        throwsA(isA<StateError>()),
      );
    });

    test('removes children', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      counter.labels(['GET']).inc(5);
      expect(counter.labels(['GET']).value, equals(5));

      counter.remove(['GET']);

      // After removal, accessing creates a new child at 0
      expect(counter.labels(['GET']).value, equals(0));
    });

    test('clears all children', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      counter.labels(['GET']).inc(5);
      counter.labels(['POST']).inc(3);

      counter.clear();

      expect(counter.labels(['GET']).value, equals(0));
      expect(counter.labels(['POST']).value, equals(0));
    });

    test('collects samples from all children', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method', 'status'],
      );

      counter.labels(['GET', '200']).inc(5);
      counter.labels(['POST', '201']).inc(3);

      final samples = counter.collect();
      expect(samples, hasLength(2));

      // Check that both label combinations are present
      final sample1 = samples.firstWhere(
        (final s) => s.labels['method'] == 'GET' && s.labels['status'] == '200',
      );
      expect(sample1.value, equals(5));

      final sample2 = samples.firstWhere(
        (final s) =>
            s.labels['method'] == 'POST' && s.labels['status'] == '201',
      );
      expect(sample2.value, equals(3));
    });

    test('collects empty samples if no children', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      final samples = counter.collect();
      expect(samples, isEmpty);
    });

    test('label maps are immutable', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      counter.labels(['GET']).inc();

      final samples = counter.collect();
      expect(
        () => samples[0].labels['method'] = 'POST',
        throwsUnsupportedError,
      );
    });

    test('protects against external labelNames list mutations', () {
      final labelNames = ['method', 'status'];
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: labelNames,
      );

      counter.labels(['GET', '200']).inc();

      // Mutate the original list
      labelNames.add('extra');
      labelNames.clear();

      // Counter should still work with original label names
      counter.labels(['POST', '201']).inc();

      expect(counter.labelNames, equals(['method', 'status']));

      final samples = counter.collect();
      expect(samples, hasLength(2));
    });

    test('labelNames list is immutable', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      expect(
        () => counter.labelNames.add('extra'),
        throwsUnsupportedError,
      );
    });

    test('handles label values containing null character', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['label1', 'label2'],
      );

      // These should be treated as distinct label combinations
      counter.labels(['a', 'b\x00c']).inc();
      counter.labels(['a\x00b', 'c']).inc(2);

      expect(counter.labels(['a', 'b\x00c']).value, equals(1));
      expect(counter.labels(['a\x00b', 'c']).value, equals(2));

      final samples = counter.collect();
      expect(samples, hasLength(2));
    });

    test('handles label values with special characters', () {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['path'],
      );

      counter.labels(['/api/\x00/users']).inc();
      counter.labels(['/api/users']).inc(2);

      expect(counter.labels(['/api/\x00/users']).value, equals(1));
      expect(counter.labels(['/api/users']).value, equals(2));
    });
  });

  group('LabeledCounter - Concurrency Safety', () {
    test('handles concurrent label creation safely', () async {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['id'],
        maxCardinality: 100,
      );

      // Concurrently create 150 unique labels
      final futures = List.generate(150, (final i) {
        return Future(() {
          try {
            counter.labels(['id_$i']).inc();
            return true;
          } on StateError catch (e) {
            // Expected to fail for some due to cardinality limit
            expect(e.message, contains('Maximum cardinality'));
            return false;
          }
        });
      });

      final results = await Future.wait(futures);
      final successCount = results.where((final r) => r).length;

      // Should have created exactly 100 labels (or 101 in edge case due to TOCTOU)
      // Our fix prevents unbounded growth while allowing one extra in race condition
      expect(
        successCount,
        inInclusiveRange(100, 101),
        reason:
            'Should create 100-101 labels due to defensive cardinality check',
      );

      // Verify the successful labels can be used
      for (var i = 0; i < successCount; i++) {
        final labeledCounter = counter.labels(['id_$i']);
        expect(
          labeledCounter.value,
          greaterThanOrEqualTo(1),
          reason: 'Created labels should be usable',
        );
      }
    });

    test('handles concurrent increments to same label safely', () async {
      final counter = LabeledCounter(
        name: 'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      // Concurrently increment the same label 100 times
      final futures = List.generate(100, (final i) {
        return Future(() {
          counter.labels(['GET']).inc();
        });
      });

      await Future.wait(futures);

      // In single-isolate Dart, simple increments are atomic enough
      // All 100 increments should be counted
      final value = counter.labels(['GET']).value;
      expect(
        value,
        equals(100),
        reason: 'All concurrent increments should be counted',
      );
    });
  });
}
