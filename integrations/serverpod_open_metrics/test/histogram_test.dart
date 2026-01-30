import 'package:serverpod_open_metrics/src/metrics/histogram.dart';
import 'package:serverpod_open_metrics/src/metrics/metric.dart';
import 'package:test/test.dart';

void main() {
  group('Histogram', () {
    test('starts with zero observations', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5, 10],
      );
      expect(histogram.count, equals(0));
      expect(histogram.sum, equals(0));
    });

    test('observes values and updates sum and count', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5, 10],
      );

      histogram.observe(1.5);
      expect(histogram.count, equals(1));
      expect(histogram.sum, equals(1.5));

      histogram.observe(3.0);
      expect(histogram.count, equals(2));
      expect(histogram.sum, equals(4.5));
    });

    test('places observations in correct buckets', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5, 10],
      );

      histogram.observe(0.5); // Bucket 1
      histogram.observe(1.5); // Bucket 2
      histogram.observe(3.0); // Bucket 5
      histogram.observe(7.0); // Bucket 10
      histogram.observe(15.0); // Beyond all buckets

      final samples = histogram.collect();

      // Find bucket samples (cumulative)
      final bucket1 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '1.0',
      );
      expect(bucket1.value, equals(1)); // 0.5

      final bucket2 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '2.0',
      );
      expect(bucket2.value, equals(2)); // 0.5, 1.5

      final bucket5 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '5.0',
      );
      expect(bucket5.value, equals(3)); // 0.5, 1.5, 3.0

      final bucket10 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '10.0',
      );
      expect(bucket10.value, equals(4)); // 0.5, 1.5, 3.0, 7.0

      final bucketInf = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '+Inf',
      );
      expect(bucketInf.value, equals(5)); // All observations
    });

    test('emits correct sample types', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5],
      );

      histogram.observe(1.5);

      final samples = histogram.collect();

      // Should have: 3 buckets + 1 +Inf + 1 sum + 1 count = 6 samples
      expect(samples, hasLength(6));

      // Check bucket samples
      expect(
        samples.where((final s) => s.name == 'test_histogram_bucket').length,
        equals(4), // 3 buckets + +Inf
      );

      // Check sum sample
      final sumSample = samples.firstWhere(
        (final s) => s.name == 'test_histogram_sum',
      );
      expect(sumSample.value, equals(1.5));
      expect(sumSample.labels, isEmpty);

      // Check count sample
      final countSample = samples.firstWhere(
        (final s) => s.name == 'test_histogram_count',
      );
      expect(countSample.value, equals(1));
      expect(countSample.labels, isEmpty);
    });

    test('handles values at bucket boundaries', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5],
      );

      histogram.observe(1.0); // Exactly at boundary
      histogram.observe(2.0); // Exactly at boundary

      final samples = histogram.collect();

      final bucket1 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '1.0',
      );
      expect(bucket1.value, equals(1)); // 1.0 goes into bucket 1

      final bucket2 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '2.0',
      );
      expect(bucket2.value, equals(2)); // 1.0, 2.0 (cumulative)
    });

    test('uses default buckets when not specified', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
      );

      expect(histogram.buckets, equals(Histogram.defaultBuckets));
    });

    test('throws on NaN observation', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5],
      );

      expect(
        () => histogram.observe(double.nan),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on infinity observation', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5],
      );

      expect(
        () => histogram.observe(double.infinity),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => histogram.observe(double.negativeInfinity),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on empty buckets', () {
      expect(
        () => Histogram(
          name: 'test_histogram',
          help: 'Test histogram',
          buckets: [],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on unsorted buckets', () {
      expect(
        () => Histogram(
          name: 'test_histogram',
          help: 'Test histogram',
          buckets: [5, 2, 10, 1],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws on duplicate buckets', () {
      expect(
        () => Histogram(
          name: 'test_histogram',
          help: 'Test histogram',
          buckets: [1, 2, 2, 5],
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('resets all data', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5],
      );

      histogram.observe(1.5);
      histogram.observe(3.0);

      histogram.reset();

      expect(histogram.count, equals(0));
      expect(histogram.sum, equals(0));

      final samples = histogram.collect();
      final bucketSamples = samples.where(
        (final s) => s.name.endsWith('_bucket'),
      );
      for (final sample in bucketSamples) {
        expect(sample.value, equals(0));
      }
    });

    test('has correct type', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1, 2, 5],
      );
      expect(histogram.type, equals(MetricType.histogram));
    });

    test('handles negative values', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [-5, -2, 0, 2, 5],
      );

      histogram.observe(-3);
      histogram.observe(1);

      expect(histogram.count, equals(2));
      expect(histogram.sum, equals(-2));

      final samples = histogram.collect();

      final bucketMinus2 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '-2.0',
      );
      expect(bucketMinus2.value, equals(1)); // -3

      final bucket2 = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '2.0',
      );
      expect(bucket2.value, equals(2)); // -3, 1 (cumulative)
    });

    test('handles many observations efficiently', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [0.1, 0.5, 1.0, 2.0, 5.0],
      );

      // Observe 1000 values
      for (var i = 0; i < 1000; i++) {
        histogram.observe(i / 200); // 0 to 5
      }

      expect(histogram.count, equals(1000));

      final samples = histogram.collect();
      final bucketInf = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '+Inf',
      );
      expect(bucketInf.value, equals(1000));
    });

    test('protects against external bucket list mutations', () {
      final buckets = [1.0, 2.0, 5.0];
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: buckets,
      );

      histogram.observe(1.5);

      // Mutate the original list
      buckets.add(10.0);
      buckets.sort((final a, final b) => b.compareTo(a)); // Reverse sort

      // Histogram should still work correctly with original buckets
      histogram.observe(3.0);

      expect(histogram.buckets, equals([1.0, 2.0, 5.0]));
      expect(histogram.count, equals(2));

      final samples = histogram.collect();
      // Should still have 3 buckets + +Inf, not affected by external mutation
      final bucketSamples = samples.where(
        (final s) => s.name.endsWith('_bucket'),
      );
      expect(bucketSamples.length, equals(4)); // 3 buckets + +Inf
    });

    test('bucket list is immutable', () {
      final histogram = Histogram(
        name: 'test_histogram',
        help: 'Test histogram',
        buckets: [1.0, 2.0, 5.0],
      );

      expect(
        () => histogram.buckets.add(10.0),
        throwsUnsupportedError,
      );
    });
  });

  group('LabeledHistogram', () {
    test('creates children with labels', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['method', 'status'],
        buckets: [1, 2, 5],
      );

      histogram.labels(['GET', '200']).observe(1.5);
      histogram.labels(['POST', '201']).observe(3.0);

      expect(histogram.labels(['GET', '200']).count, equals(1));
      expect(histogram.labels(['POST', '201']).count, equals(1));
    });

    test('reuses same child for same labels', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label'],
        buckets: [1, 2, 5],
      );

      final child1 = histogram.labels(['value']);
      final child2 = histogram.labels(['value']);

      expect(identical(child1, child2), isTrue);
    });

    test('shares bucket configuration across children', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label'],
        buckets: [1, 2, 5],
      );

      final child1 = histogram.labels(['value1']);
      final child2 = histogram.labels(['value2']);

      expect(child1.buckets, equals([1, 2, 5]));
      expect(child2.buckets, equals([1, 2, 5]));
    });

    test('throws on label count mismatch', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label1', 'label2'],
        buckets: [1, 2, 5],
      );

      expect(
        () => histogram.labels(['value1']),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('enforces cardinality limit', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label'],
        buckets: [1, 2, 5],
        maxCardinality: 2,
      );

      histogram.labels(['value1']).observe(1);
      histogram.labels(['value2']).observe(2);

      expect(
        () => histogram.labels(['value3']).observe(3),
        throwsA(isA<StateError>()),
      );
    });

    test('removes children', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label'],
        buckets: [1, 2, 5],
      );

      histogram.labels(['value']).observe(3);
      histogram.remove(['value']);

      expect(histogram.labels(['value']).count, equals(0));
    });

    test('clears all children', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label'],
        buckets: [1, 2, 5],
      );

      histogram.labels(['value1']).observe(1);
      histogram.labels(['value2']).observe(2);

      histogram.clear();

      expect(histogram.labels(['value1']).count, equals(0));
      expect(histogram.labels(['value2']).count, equals(0));
    });

    test('collects samples from all children with labels', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['method'],
        buckets: [1, 2, 5],
      );

      histogram.labels(['GET']).observe(1.5);
      histogram.labels(['POST']).observe(3.0);

      final samples = histogram.collect();

      // Each child emits: 3 buckets + +Inf + sum + count = 6 samples
      // 2 children = 12 samples total
      expect(samples, hasLength(12));

      // Check GET samples
      final getSamples = samples.where(
        (final s) => s.labels['method'] == 'GET',
      );
      expect(getSamples, hasLength(6));

      final getSum = getSamples.firstWhere(
        (final s) => s.name.endsWith('_sum'),
      );
      expect(getSum.value, equals(1.5));

      // Check POST samples
      final postSamples = samples.where(
        (final s) => s.labels['method'] == 'POST',
      );
      expect(postSamples, hasLength(6));

      final postSum = postSamples.firstWhere(
        (final s) => s.name.endsWith('_sum'),
      );
      expect(postSum.value, equals(3.0));
    });

    test('label maps are immutable', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label'],
        buckets: [1, 2, 5],
      );

      histogram.labels(['value']).observe(1.5);

      final samples = histogram.collect();
      final sampleWithLabel = samples.firstWhere(
        (final s) => s.labels.containsKey('label'),
      );

      expect(
        () => sampleWithLabel.labels['label'] = 'modified',
        throwsUnsupportedError,
      );
    });

    test('bucket labels are correctly merged with custom labels', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['method'],
        buckets: [1, 2],
      );

      histogram.labels(['GET']).observe(1.5);

      final samples = histogram.collect();
      final bucketSample = samples.firstWhere(
        (final s) => s.name.endsWith('_bucket') && s.labels['le'] == '2.0',
      );

      // Should have both method label and le label
      expect(bucketSample.labels['method'], equals('GET'));
      expect(bucketSample.labels['le'], equals('2.0'));
    });

    test('protects against external bucket list mutations', () {
      final buckets = [1.0, 2.0, 5.0];
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['method'],
        buckets: buckets,
      );

      histogram.labels(['GET']).observe(1.5);

      // Mutate the original list
      buckets.add(10.0);
      buckets.clear();

      // Histogram should still work correctly with original buckets
      histogram.labels(['GET']).observe(3.0);

      expect(histogram.buckets, equals([1.0, 2.0, 5.0]));
      expect(histogram.labels(['GET']).count, equals(2));
    });

    test('bucket list is immutable', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['method'],
        buckets: [1.0, 2.0, 5.0],
      );

      expect(
        () => histogram.buckets.add(10.0),
        throwsUnsupportedError,
      );
    });

    test('protects against external labelNames list mutations', () {
      final labelNames = ['method', 'status'];
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: labelNames,
        buckets: [1.0, 2.0, 5.0],
      );

      histogram.labels(['GET', '200']).observe(1.5);

      // Mutate the original list
      labelNames.add('extra');
      labelNames.clear();

      // Histogram should still work with original label names
      histogram.labels(['POST', '201']).observe(3.0);

      expect(histogram.labelNames, equals(['method', 'status']));

      final samples = histogram.collect();
      // Each child emits 6 samples (3 buckets + +Inf + sum + count)
      expect(samples, hasLength(12));
    });

    test('labelNames list is immutable', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['method'],
        buckets: [1.0, 2.0, 5.0],
      );

      expect(
        () => histogram.labelNames.add('extra'),
        throwsUnsupportedError,
      );
    });

    test('handles label values containing null character', () {
      final histogram = LabeledHistogram(
        name: 'test_histogram',
        help: 'Test histogram',
        labelNames: ['label1', 'label2'],
        buckets: [1.0, 5.0],
      );

      // These should be treated as distinct label combinations
      // The '\x00' in string literals is the actual null character (0x00)
      histogram.labels(['a', 'b\x00c']).observe(0.5);
      histogram.labels(['a\x00b', 'c']).observe(3.0);

      expect(histogram.labels(['a', 'b\x00c']).count, equals(1));
      expect(histogram.labels(['a\x00b', 'c']).count, equals(1));

      final samples = histogram.collect();
      // Each histogram emits 5 samples (2 buckets + +Inf bucket + sum + count)
      // So 2 distinct histograms = 10 samples
      expect(samples, hasLength(10));
    });
  });
}
