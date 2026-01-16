import 'package:serverpod_open_metrics/src/metrics/gauge.dart';
import 'package:serverpod_open_metrics/src/metrics/metric.dart';
import 'package:test/test.dart';

void main() {
  group('Gauge', () {
    test(
      'given a new gauge, when checking value, then it is zero',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(gauge.value, equals(0));
      },
    );

    test(
      'given a new gauge, when incrementing without amount, then it increments by 1',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        gauge.inc();
        expect(gauge.value, equals(1));
      },
    );

    test(
      'given a new gauge, when incrementing by custom amounts, then it accumulates correctly',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        gauge.inc(5);
        expect(gauge.value, equals(5));
        gauge.inc(3);
        expect(gauge.value, equals(8));
      },
    );

    test(
      'given a gauge with value 10, when decrementing without amount, then it decrements by 1',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        gauge.set(10);
        gauge.dec();
        expect(gauge.value, equals(9));
      },
    );

    test(
      'given a gauge with value 10, when decrementing by custom amounts, then it decreases correctly',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        gauge.set(10);
        gauge.dec(3);
        expect(gauge.value, equals(7));
        gauge.dec(2);
        expect(gauge.value, equals(5));
      },
    );

    test(
      'given a gauge, when setting to specific values, then it reflects the latest value',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        gauge.set(42);
        expect(gauge.value, equals(42));
        gauge.set(100);
        expect(gauge.value, equals(100));
      },
    );

    test(
      'given a gauge, when setting to negative and decrementing, then it goes below zero',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        gauge.set(-5);
        expect(gauge.value, equals(-5));
        gauge.dec(3);
        expect(gauge.value, equals(-8));
      },
    );

    test(
      'given a gauge, when incrementing by NaN, then it throws ArgumentError',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(
          () => gauge.inc(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a gauge, when incrementing by infinity, then it throws ArgumentError',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(
          () => gauge.inc(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a gauge, when decrementing by NaN, then it throws ArgumentError',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(
          () => gauge.dec(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a gauge, when decrementing by infinity, then it throws ArgumentError',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(
          () => gauge.dec(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a gauge, when setting to NaN, then it throws ArgumentError',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(
          () => gauge.set(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a gauge, when setting to infinity, then it throws ArgumentError',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(
          () => gauge.set(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a gauge, when setting to current time, then value is a reasonable Unix timestamp',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        final beforeMs = DateTime.now().millisecondsSinceEpoch;
        gauge.setToCurrentTime();
        final afterMs = DateTime.now().millisecondsSinceEpoch;

        final beforeSec = beforeMs / 1000;
        final afterSec = afterMs / 1000;

        expect(gauge.value, greaterThanOrEqualTo(beforeSec));
        expect(gauge.value, lessThanOrEqualTo(afterSec));
      },
    );

    test(
      'given a gauge, when checking type, then it is MetricType.gauge',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        expect(gauge.type, equals(MetricType.gauge));
      },
    );

    test(
      'given a gauge with value, when collecting samples, then it returns one sample with correct name and value',
      () {
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        gauge.set(42);

        final samples = gauge.collect();
        expect(samples, hasLength(1));
        expect(samples[0].name, equals('test_gauge'));
        expect(samples[0].value, equals(42));
        expect(samples[0].labels, isEmpty);
      },
    );

    test(
      'given an invalid metric name, when creating gauge, then it throws ArgumentError',
      () {
        expect(
          () => Gauge(name: '', help: 'Test'),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => Gauge(name: '123invalid', help: 'Test'),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });

  group('LabeledGauge', () {
    test(
      'given a labeled gauge, when setting children with different labels, then each child tracks independently',
      () {
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: ['service', 'instance'],
        );

        gauge.labels(['api', 'server1']).set(10);
        gauge.labels(['db', 'server2']).set(5);

        expect(gauge.labels(['api', 'server1']).value, equals(10));
        expect(gauge.labels(['db', 'server2']).value, equals(5));
      },
    );

    test(
      'given a labeled gauge, when accessing the same labels twice, then it returns the same child instance',
      () {
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: ['label'],
        );

        final child1 = gauge.labels(['value']);
        final child2 = gauge.labels(['value']);

        expect(identical(child1, child2), isTrue);
      },
    );

    test(
      'given a labeled gauge with two label names, when providing wrong number of label values, then it throws ArgumentError',
      () {
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: ['label1', 'label2'],
        );

        expect(
          () => gauge.labels(['value1']),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a labeled gauge at max cardinality, when creating a new label combination, then it throws StateError',
      () {
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
      },
    );

    test(
      'given a labeled gauge with a child, when removing that child and re-accessing, then it starts at zero',
      () {
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: ['label'],
        );

        gauge.labels(['value']).set(42);
        gauge.remove(['value']);

        expect(gauge.labels(['value']).value, equals(0));
      },
    );

    test(
      'given a labeled gauge with children, when clearing all, then all children reset to zero',
      () {
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
      },
    );

    test(
      'given a labeled gauge with multiple children, when collecting samples, then it returns one sample per child with correct labels',
      () {
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
      },
    );

    test(
      'given a labeled gauge with samples, when modifying collected label maps, then it throws UnsupportedError',
      () {
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
      },
    );

    test(
      'given a labeled gauge created with a mutable list, when mutating the original list, then the gauge is unaffected',
      () {
        final labelNames = ['service', 'instance'];
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: labelNames,
        );

        gauge.labels(['api', 'server1']).set(10);

        labelNames.add('extra');
        labelNames.clear();

        gauge.labels(['db', 'server2']).set(5);

        expect(gauge.labelNames, equals(['service', 'instance']));

        final samples = gauge.collect();
        expect(samples, hasLength(2));
      },
    );

    test(
      'given a labeled gauge, when modifying labelNames getter, then it throws UnsupportedError',
      () {
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: ['label'],
        );

        expect(
          () => gauge.labelNames.add('extra'),
          throwsUnsupportedError,
        );
      },
    );

    test(
      'given label values containing null character, when accessing different combinations, then they are treated as distinct',
      () {
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: ['label1', 'label2'],
        );

        gauge.labels(['a', 'b\x00c']).set(10);
        gauge.labels(['a\x00b', 'c']).set(20);

        expect(gauge.labels(['a', 'b\x00c']).value, equals(10));
        expect(gauge.labels(['a\x00b', 'c']).value, equals(20));

        final samples = gauge.collect();
        expect(samples, hasLength(2));
      },
    );
  });
}
