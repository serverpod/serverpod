import 'package:serverpod_open_metrics/src/metrics/gauge.dart';
import 'package:serverpod_open_metrics/src/metrics/metric.dart';
import 'package:test/test.dart';

void main() {
  group('Gauge', () {
    test('starts at zero', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(gauge.value, equals(0));
    });

    test('increments by 1 by default', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.inc();
      expect(gauge.value, equals(1));
    });

    test('increments by custom amount', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.inc(5);
      expect(gauge.value, equals(5));
      gauge.inc(3);
      expect(gauge.value, equals(8));
    });

    test('decrements by 1 by default', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.set(10);
      gauge.dec();
      expect(gauge.value, equals(9));
    });

    test('decrements by custom amount', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.set(10);
      gauge.dec(3);
      expect(gauge.value, equals(7));
      gauge.dec(2);
      expect(gauge.value, equals(5));
    });

    test('sets to specific value', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.set(42);
      expect(gauge.value, equals(42));
      gauge.set(100);
      expect(gauge.value, equals(100));
    });

    test('can go negative', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.set(-5);
      expect(gauge.value, equals(-5));
      gauge.dec(3);
      expect(gauge.value, equals(-8));
    });

    test('throws on NaN increment', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(
        () => gauge.inc(double.nan),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on infinity increment', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(
        () => gauge.inc(double.infinity),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on NaN decrement', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(
        () => gauge.dec(double.nan),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on infinity decrement', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(
        () => gauge.dec(double.infinity),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on NaN set', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(
        () => gauge.set(double.nan),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on infinity set', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(
        () => gauge.set(double.infinity),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('sets to current time', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      final beforeMs = DateTime.now().millisecondsSinceEpoch;
      gauge.setToCurrentTime();
      final afterMs = DateTime.now().millisecondsSinceEpoch;

      final beforeSec = beforeMs / 1000;
      final afterSec = afterMs / 1000;

      expect(gauge.value, greaterThanOrEqualTo(beforeSec));
      expect(gauge.value, lessThanOrEqualTo(afterSec));
    });

    test('resets to zero', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.set(42);
      gauge.reset();
      expect(gauge.value, equals(0));
    });

    test('has correct type', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      expect(gauge.type, equals(MetricType.gauge));
    });

    test('collects samples', () {
      final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
      gauge.set(42);

      final samples = gauge.collect();
      expect(samples, hasLength(1));
      expect(samples[0].name, equals('test_gauge'));
      expect(samples[0].value, equals(42));
      expect(samples[0].labels, isEmpty);
    });

    test('throws on invalid metric name', () {
      expect(
        () => Gauge(name: '', help: 'Test'),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => Gauge(name: '123invalid', help: 'Test'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('LabeledGauge', () {
    test('creates children with labels', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['service', 'instance'],
      );

      gauge.labels(['api', 'server1']).set(10);
      gauge.labels(['db', 'server2']).set(5);

      expect(gauge.labels(['api', 'server1']).value, equals(10));
      expect(gauge.labels(['db', 'server2']).value, equals(5));
    });

    test('reuses same child for same labels', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label'],
      );

      final child1 = gauge.labels(['value']);
      final child2 = gauge.labels(['value']);

      expect(identical(child1, child2), isTrue);
    });

    test('throws on label count mismatch', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label1', 'label2'],
      );

      expect(
        () => gauge.labels(['value1']),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('enforces cardinality limit', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label'],
        maxCardinality: 2,
      );

      gauge.labels(['value1']).inc();
      gauge.labels(['value2']).inc();

      expect(
        () => gauge.labels(['value3']).inc(),
        throwsA(isA<StateError>()),
      );
    });

    test('removes children', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label'],
      );

      gauge.labels(['value']).set(42);
      gauge.remove(['value']);

      expect(gauge.labels(['value']).value, equals(0));
    });

    test('clears all children', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label'],
      );

      gauge.labels(['value1']).set(10);
      gauge.labels(['value2']).set(20);

      gauge.clear();

      expect(gauge.labels(['value1']).value, equals(0));
      expect(gauge.labels(['value2']).value, equals(0));
    });

    test('collects samples from all children', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['service'],
      );

      gauge.labels(['api']).set(10);
      gauge.labels(['db']).set(5);

      final samples = gauge.collect();
      expect(samples, hasLength(2));

      final sample1 = samples.firstWhere(
        (final s) => s.labels['service'] == 'api',
      );
      expect(sample1.value, equals(10));

      final sample2 = samples.firstWhere(
        (final s) => s.labels['service'] == 'db',
      );
      expect(sample2.value, equals(5));
    });

    test('label maps are immutable', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label'],
      );

      gauge.labels(['value']).set(42);

      final samples = gauge.collect();
      expect(
        () => samples[0].labels['label'] = 'modified',
        throwsUnsupportedError,
      );
    });

    test('protects against external labelNames list mutations', () {
      final labelNames = ['service', 'instance'];
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: labelNames,
      );

      gauge.labels(['api', 'server1']).set(10);

      // Mutate the original list
      labelNames.add('extra');
      labelNames.clear();

      // Gauge should still work with original label names
      gauge.labels(['db', 'server2']).set(5);

      expect(gauge.labelNames, equals(['service', 'instance']));

      final samples = gauge.collect();
      expect(samples, hasLength(2));
    });

    test('labelNames list is immutable', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label'],
      );

      expect(
        () => gauge.labelNames.add('extra'),
        throwsUnsupportedError,
      );
    });

    test('handles label values containing null character', () {
      final gauge = LabeledGauge(
        name: 'test_gauge',
        help: 'Test gauge',
        labelNames: ['label1', 'label2'],
      );

      // These should be treated as distinct label combinations
      gauge.labels(['a', 'b\x00c']).set(10);
      gauge.labels(['a\x00b', 'c']).set(20);

      expect(gauge.labels(['a', 'b\x00c']).value, equals(10));
      expect(gauge.labels(['a\x00b', 'c']).value, equals(20));

      final samples = gauge.collect();
      expect(samples, hasLength(2));
    });
  });
}
