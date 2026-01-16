import 'package:serverpod_open_metrics_server/src/metrics/counter.dart';
import 'package:serverpod_open_metrics_server/src/metrics/metric_registry.dart';
import 'package:test/test.dart';

void main() {
  group('MetricRegistry', () {
    test('starts empty', () {
      final registry = MetricRegistry();
      expect(registry.metrics, isEmpty);
    });

    test('registers a counter', () {
      final registry = MetricRegistry();
      final counter = registry.counter('test_counter', help: 'Test counter');

      expect(counter.name, equals('test_counter'));
      expect(registry.metrics, hasLength(1));
      expect(registry.getMetric('test_counter'), same(counter));
    });

    test('registers a labeled counter', () {
      final registry = MetricRegistry();
      final counter = registry.labeledCounter(
        'test_counter',
        help: 'Test counter',
        labelNames: ['method'],
      );

      expect(counter.name, equals('test_counter'));
      expect(registry.metrics, hasLength(1));
    });

    test('registers a gauge', () {
      final registry = MetricRegistry();
      final gauge = registry.gauge('test_gauge', help: 'Test gauge');

      expect(gauge.name, equals('test_gauge'));
      expect(registry.metrics, hasLength(1));
      expect(registry.getMetric('test_gauge'), same(gauge));
    });

    test('registers a labeled gauge', () {
      final registry = MetricRegistry();
      final gauge = registry.labeledGauge(
        'test_gauge',
        help: 'Test gauge',
        labelNames: ['service'],
      );

      expect(gauge.name, equals('test_gauge'));
      expect(registry.metrics, hasLength(1));
    });

    test('registers a histogram', () {
      final registry = MetricRegistry();
      final histogram = registry.histogram(
        'test_histogram',
        help: 'Test histogram',
      );

      expect(histogram.name, equals('test_histogram'));
      expect(registry.metrics, hasLength(1));
      expect(registry.getMetric('test_histogram'), same(histogram));
    });

    test('registers a labeled histogram', () {
      final registry = MetricRegistry();
      final histogram = registry.labeledHistogram(
        'test_histogram',
        help: 'Test histogram',
        labelNames: ['method'],
      );

      expect(histogram.name, equals('test_histogram'));
      expect(registry.metrics, hasLength(1));
    });

    test('registers multiple metrics', () {
      final registry = MetricRegistry();

      registry.counter('counter1', help: 'Counter 1');
      registry.gauge('gauge1', help: 'Gauge 1');
      registry.histogram('histogram1', help: 'Histogram 1');

      expect(registry.metrics, hasLength(3));
    });

    test('throws on duplicate metric name', () {
      final registry = MetricRegistry();
      registry.counter('duplicate', help: 'First');

      expect(
        () => registry.counter('duplicate', help: 'Second'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on duplicate metric name across types', () {
      final registry = MetricRegistry();
      registry.counter('metric', help: 'Counter');

      expect(
        () => registry.gauge('metric', help: 'Gauge'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('allows manual registration', () {
      final registry = MetricRegistry();
      final counter = Counter(name: 'manual_counter', help: 'Manual');

      registry.register(counter);

      expect(registry.metrics, hasLength(1));
      expect(registry.getMetric('manual_counter'), same(counter));
    });

    test('throws on manual registration of duplicate', () {
      final registry = MetricRegistry();
      final counter1 = Counter(name: 'counter', help: 'First');
      final counter2 = Counter(name: 'counter', help: 'Second');

      registry.register(counter1);

      expect(
        () => registry.register(counter2),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('unregisters a metric', () {
      final registry = MetricRegistry();
      registry.counter('test', help: 'Test');

      final removed = registry.unregister('test');

      expect(removed, isTrue);
      expect(registry.metrics, isEmpty);
      expect(registry.getMetric('test'), isNull);
    });

    test('unregister returns false for non-existent metric', () {
      final registry = MetricRegistry();

      final removed = registry.unregister('non_existent');

      expect(removed, isFalse);
    });

    test('clears all metrics', () {
      final registry = MetricRegistry();
      registry.counter('counter', help: 'Counter');
      registry.gauge('gauge', help: 'Gauge');
      registry.histogram('histogram', help: 'Histogram');

      registry.clear();

      expect(registry.metrics, isEmpty);
    });

    test('getMetric returns null for non-existent metric', () {
      final registry = MetricRegistry();

      expect(registry.getMetric('non_existent'), isNull);
    });

    test('metrics list is unmodifiable', () {
      final registry = MetricRegistry();
      registry.counter('test', help: 'Test');

      expect(
        () => registry.metrics.clear(),
        throwsUnsupportedError,
      );
    });

    test('collectAll returns samples from all metrics', () {
      final registry = MetricRegistry();

      final counter = registry.counter('test_counter', help: 'Counter');
      final gauge = registry.gauge('test_gauge', help: 'Gauge');

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
    });

    test('collectAll includes histogram samples', () {
      final registry = MetricRegistry();

      final histogram = registry.histogram(
        'test_histogram',
        help: 'Histogram',
        buckets: [1, 2, 5],
      );

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
    });

    test('collectAll works with labeled metrics', () {
      final registry = MetricRegistry();

      final counter = registry.labeledCounter(
        'test_counter',
        help: 'Counter',
        labelNames: ['method'],
      );

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
    });

    test('collectAll returns empty list when no metrics', () {
      final registry = MetricRegistry();

      final samples = registry.collectAll();

      expect(samples, isEmpty);
    });

    test('passes custom buckets to histogram', () {
      final registry = MetricRegistry();
      final customBuckets = [0.1, 0.5, 1.0];

      final histogram = registry.histogram(
        'test_histogram',
        help: 'Histogram',
        buckets: customBuckets,
      );

      expect(histogram.buckets, equals(customBuckets));
    });

    test('passes max cardinality to labeled metrics', () {
      final registry = MetricRegistry();

      final counter = registry.labeledCounter(
        'test_counter',
        help: 'Counter',
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
  });
}
