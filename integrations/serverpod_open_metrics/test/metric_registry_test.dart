import 'package:serverpod_open_metrics/src/metrics/counter.dart';
import 'package:serverpod_open_metrics/src/metrics/gauge.dart';
import 'package:serverpod_open_metrics/src/metrics/histogram.dart';
import 'package:serverpod_open_metrics/src/metrics/metric_registry.dart';
import 'package:test/test.dart';

void main() {
  group('MetricRegistry', () {
    test(
      'given a configured global registry, when accessing instance, then it returns the configured instance',
      () {
        final registry = MetricRegistry();

        MetricRegistry.set(registry: registry);

        expect(MetricRegistry.instance, same(registry));
      },
    );

    test(
      'given multiple set calls, when accessing instance, then it returns the most recent registry',
      () {
        final firstRegistry = MetricRegistry();
        final secondRegistry = MetricRegistry();

        MetricRegistry.set(registry: firstRegistry);
        MetricRegistry.set(registry: secondRegistry);

        expect(MetricRegistry.instance, same(secondRegistry));
        expect(MetricRegistry.instance, isNot(same(firstRegistry)));
      },
    );

    test(
      'given set called without parameters, when accessing instance, then it creates a registry',
      () {
        MetricRegistry.set();

        expect(MetricRegistry.instance, isA<MetricRegistry>());
      },
    );

    test('given a new registry, when accessing metrics, then it is empty', () {
      final registry = MetricRegistry();
      expect(registry.metrics, isEmpty);
    });

    test(
      'given a registry, when registering a counter, then it is retrievable by name',
      () {
        final registry = MetricRegistry();
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        registry.register(counter);

        expect(counter.name, equals('test_counter'));
        expect(registry.metrics, hasLength(1));
        expect(registry.getMetric('test_counter'), same(counter));
      },
    );

    test(
      'given a registry, when registering a labeled counter, then it is stored with correct name',
      () {
        final registry = MetricRegistry();
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method'],
        );
        registry.register(counter);

        expect(counter.name, equals('test_counter'));
        expect(registry.metrics, hasLength(1));
      },
    );

    test(
      'given a registry, when registering a gauge, then it is retrievable by name',
      () {
        final registry = MetricRegistry();
        final gauge = Gauge(name: 'test_gauge', help: 'Test gauge');
        registry.register(gauge);

        expect(gauge.name, equals('test_gauge'));
        expect(registry.metrics, hasLength(1));
        expect(registry.getMetric('test_gauge'), same(gauge));
      },
    );

    test(
      'given a registry, when registering a labeled gauge, then it is stored with correct name',
      () {
        final registry = MetricRegistry();
        final gauge = LabeledGauge(
          name: 'test_gauge',
          help: 'Test gauge',
          labelNames: ['service'],
        );
        registry.register(gauge);

        expect(gauge.name, equals('test_gauge'));
        expect(registry.metrics, hasLength(1));
      },
    );

    test(
      'given a registry, when registering a histogram, then it is retrievable by name',
      () {
        final registry = MetricRegistry();
        final histogram = Histogram(
          name: 'test_histogram',
          help: 'Test histogram',
        );
        registry.register(histogram);

        expect(histogram.name, equals('test_histogram'));
        expect(registry.metrics, hasLength(1));
        expect(registry.getMetric('test_histogram'), same(histogram));
      },
    );

    test(
      'given a registry, when registering a labeled histogram, then it is stored with correct name',
      () {
        final registry = MetricRegistry();
        final histogram = LabeledHistogram(
          name: 'test_histogram',
          help: 'Test histogram',
          labelNames: ['method'],
        );
        registry.register(histogram);

        expect(histogram.name, equals('test_histogram'));
        expect(registry.metrics, hasLength(1));
      },
    );

    test(
      'given a registry, when registering multiple metrics of different types, then all are stored',
      () {
        final registry = MetricRegistry();

        registry.register(Counter(name: 'counter1', help: 'Counter 1'));
        registry.register(Gauge(name: 'gauge1', help: 'Gauge 1'));
        registry.register(Histogram(name: 'histogram1', help: 'Histogram 1'));

        expect(registry.metrics, hasLength(3));
      },
    );

    test(
      'given a registry with an existing metric, when registering a counter with the same name, then it throws an ArgumentError',
      () {
        final registry = MetricRegistry();
        registry.register(Counter(name: 'duplicate', help: 'First'));

        expect(
          () => registry.register(Counter(name: 'duplicate', help: 'Second')),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a registry with an existing counter, when registering a gauge with the same name, then it throws an ArgumentError',
      () {
        final registry = MetricRegistry();
        registry.register(Counter(name: 'metric', help: 'Counter'));

        expect(
          () => registry.register(Gauge(name: 'metric', help: 'Gauge')),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a registry with a registered metric, when unregistering it, then it is removed',
      () {
        final registry = MetricRegistry();
        registry.register(Counter(name: 'test', help: 'Test'));

        final removed = registry.unregister('test');

        expect(removed, isTrue);
        expect(registry.metrics, isEmpty);
        expect(registry.getMetric('test'), isNull);
      },
    );

    test(
      'given a registry, when unregistering a non-existent metric, then it returns false',
      () {
        final registry = MetricRegistry();

        final removed = registry.unregister('non_existent');

        expect(removed, isFalse);
      },
    );

    test(
      'given a registry with multiple metrics, when clearing all, then it is empty',
      () {
        final registry = MetricRegistry();
        registry.register(Counter(name: 'counter', help: 'Counter'));
        registry.register(Gauge(name: 'gauge', help: 'Gauge'));
        registry.register(Histogram(name: 'histogram', help: 'Histogram'));

        registry.clear();

        expect(registry.metrics, isEmpty);
      },
    );

    test(
      'given a registry, when getting a non-existent metric, then it returns null',
      () {
        final registry = MetricRegistry();

        expect(registry.getMetric('non_existent'), isNull);
      },
    );

    test(
      'given a registry with a metric, when modifying the metrics list directly, then it throws an UnsupportedError',
      () {
        final registry = MetricRegistry();
        registry.register(Counter(name: 'test', help: 'Test'));

        expect(
          () => registry.metrics.clear(),
          throwsUnsupportedError,
        );
      },
    );

    test(
      'given a registry with a counter and gauge with values, when collecting all samples, then it returns samples from all metrics',
      () {
        final registry = MetricRegistry();

        final counter = Counter(name: 'test_counter', help: 'Counter');
        registry.register(counter);
        final gauge = Gauge(name: 'test_gauge', help: 'Gauge');
        registry.register(gauge);

        counter.inc(5);
        gauge.set(10);

        final samples = registry.collectAll();

        expect(samples, hasLength(2));

        final counterSample = samples.firstWhere(
          (final s) => s.name == 'test_counter',
        );
        expect(counterSample.value, equals(5));

        final gaugeSample = samples.firstWhere(
          (final s) => s.name == 'test_gauge',
        );
        expect(gaugeSample.value, equals(10));
      },
    );

    test(
      'given a registry with a histogram with observations, when collecting all samples, then it includes bucket sum and count samples',
      () {
        final registry = MetricRegistry();

        final histogram = Histogram(
          name: 'test_histogram',
          help: 'Histogram',
          buckets: [1, 2, 5],
        );
        registry.register(histogram);

        histogram.observe(1.5);

        final samples = registry.collectAll();

        // Histogram emits: 3 buckets + +Inf + sum + count = 6 samples
        expect(samples, hasLength(6));

        expect(
          samples.where((final s) => s.name == 'test_histogram_bucket').length,
          equals(4),
        );
        expect(
          samples.where((final s) => s.name == 'test_histogram_sum').length,
          equals(1),
        );
        expect(
          samples.where((final s) => s.name == 'test_histogram_count').length,
          equals(1),
        );
      },
    );

    test(
      'given a registry with a labeled counter with multiple label values, when collecting all samples, then it returns samples for each label combination',
      () {
        final registry = MetricRegistry();

        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Counter',
          labelNames: ['method'],
        );
        registry.register(counter);

        counter.labels(['GET']).inc();
        counter.labels(['POST']).inc(2);

        final samples = registry.collectAll();

        expect(samples, hasLength(2));

        final getSample = samples.firstWhere(
          (final s) => s.labels['method'] == 'GET',
        );
        expect(getSample.value, equals(1));

        final postSample = samples.firstWhere(
          (final s) => s.labels['method'] == 'POST',
        );
        expect(postSample.value, equals(2));
      },
    );

    test(
      'given an empty registry, when collecting all samples, then it returns an empty list',
      () {
        final registry = MetricRegistry();

        final samples = registry.collectAll();

        expect(samples, isEmpty);
      },
    );

    test(
      'given a registry, when registering a histogram with custom buckets, then the histogram uses those buckets',
      () {
        final registry = MetricRegistry();
        final customBuckets = [0.1, 0.5, 1.0];

        final histogram = Histogram(
          name: 'test_histogram',
          help: 'Histogram',
          buckets: customBuckets,
        );
        registry.register(histogram);

        expect(histogram.buckets, equals(customBuckets));
      },
    );

    test(
      'given a registry with a labeled counter with max cardinality, when exceeding max cardinality, then it throws a StateError',
      () {
        final registry = MetricRegistry();

        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Counter',
          labelNames: ['label'],
          maxCardinality: 2,
        );
        registry.register(counter);

        counter.labels(['value1']).inc();
        counter.labels(['value2']).inc();

        expect(
          () => counter.labels(['value3']).inc(),
          throwsA(isA<StateError>()),
        );
      },
    );
  });
}
