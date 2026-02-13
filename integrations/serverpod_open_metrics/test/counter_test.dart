import 'package:serverpod_open_metrics/src/metrics/counter.dart';
import 'package:serverpod_open_metrics/src/metrics/metric.dart';
import 'package:test/test.dart';

void main() {
  group('Counter', () {
    test(
      'given a new counter, when checking value, then it is zero',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        expect(counter.value, equals(0));
      },
    );

    test(
      'given a new counter, when incrementing without amount, then it increments by 1',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        counter.inc();
        expect(counter.value, equals(1));
      },
    );

    test(
      'given a new counter, when incrementing by custom amounts, then it accumulates correctly',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        counter.inc(5);
        expect(counter.value, equals(5));
        counter.inc(3);
        expect(counter.value, equals(8));
      },
    );

    test(
      'given a counter, when incrementing by negative amount, then it throws ArgumentError',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        expect(
          () => counter.inc(-1),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a counter, when incrementing by NaN, then it throws ArgumentError',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        expect(
          () => counter.inc(double.nan),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a counter, when incrementing by infinity, then it throws ArgumentError',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        expect(
          () => counter.inc(double.infinity),
          throwsA(isA<ArgumentError>()),
        );
        expect(
          () => counter.inc(double.negativeInfinity),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'given a counter, when checking type, then it is MetricType.counter',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        expect(counter.type, equals(MetricType.counter));
      },
    );

    test(
      'given a counter with value, when collecting samples, then it returns one sample with correct name and value',
      () {
        final counter = Counter(name: 'test_counter', help: 'Test counter');
        counter.inc(5);

        final samples = counter.collect();
        expect(samples, hasLength(1));
        expect(samples[0].name, equals('test_counter'));
        expect(samples[0].value, equals(5));
        expect(samples[0].labels, isEmpty);
      },
    );

    test(
      'given an invalid metric name, when creating counter, then it throws ArgumentError',
      () {
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
      },
    );

    test(
      'given a valid metric name, when creating counter, then it succeeds',
      () {
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
      },
    );
  });

  group('LabeledCounter', () {
    test(
      'given a labeled counter, when incrementing children with different labels, then each child tracks independently',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method', 'status'],
        );

        counter.labels(['GET', '200']).inc();
        counter.labels(['POST', '201']).inc(2);

        expect(counter.labels(['GET', '200']).value, equals(1));
        expect(counter.labels(['POST', '201']).value, equals(2));
      },
    );

    test(
      'given a labeled counter, when accessing the same labels twice, then it returns the same child instance',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method'],
        );

        final child1 = counter.labels(['GET']);
        final child2 = counter.labels(['GET']);

        expect(identical(child1, child2), isTrue);
      },
    );

    test(
      'given a labeled counter, when accessing different labels, then it returns different child instances',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method'],
        );

        final child1 = counter.labels(['GET']);
        final child2 = counter.labels(['POST']);

        expect(identical(child1, child2), isFalse);
      },
    );

    test(
      'given a labeled counter with two label names, when providing wrong number of label values, then it throws ArgumentError',
      () {
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
      },
    );

    test(
      'given invalid label names, when creating labeled counter, then it throws ArgumentError',
      () {
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
      },
    );

    test(
      'given a labeled counter at max cardinality, when creating a new label combination, then it throws StateError',
      () {
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
      },
    );

    test(
      'given a labeled counter with a child, when removing that child and re-accessing, then it starts at zero',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method'],
        );

        counter.labels(['GET']).inc(5);
        expect(counter.labels(['GET']).value, equals(5));

        counter.remove(['GET']);

        expect(counter.labels(['GET']).value, equals(0));
      },
    );

    test(
      'given a labeled counter with children, when clearing all, then all children reset to zero',
      () {
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
      },
    );

    test(
      'given a labeled counter with multiple children, when collecting samples, then it returns one sample per child with correct labels',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method', 'status'],
        );

        counter.labels(['GET', '200']).inc(5);
        counter.labels(['POST', '201']).inc(3);

        final samples = counter.collect();
        expect(samples, hasLength(2));

        final sample1 = samples.firstWhere(
          (final s) =>
              s.labels['method'] == 'GET' && s.labels['status'] == '200',
        );
        expect(sample1.value, equals(5));

        final sample2 = samples.firstWhere(
          (final s) =>
              s.labels['method'] == 'POST' && s.labels['status'] == '201',
        );
        expect(sample2.value, equals(3));
      },
    );

    test(
      'given a labeled counter with no children, when collecting samples, then it returns empty list',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method'],
        );

        final samples = counter.collect();
        expect(samples, isEmpty);
      },
    );

    test(
      'given a labeled counter with samples, when modifying collected label maps, then it throws UnsupportedError',
      () {
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
      },
    );

    test(
      'given a labeled counter created with a mutable list, when mutating the original list, then the counter is unaffected',
      () {
        final labelNames = ['method', 'status'];
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: labelNames,
        );

        counter.labels(['GET', '200']).inc();

        labelNames.add('extra');
        labelNames.clear();

        counter.labels(['POST', '201']).inc();

        expect(counter.labelNames, equals(['method', 'status']));

        final samples = counter.collect();
        expect(samples, hasLength(2));
      },
    );

    test(
      'given a labeled counter, when modifying labelNames getter, then it throws UnsupportedError',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method'],
        );

        expect(
          () => counter.labelNames.add('extra'),
          throwsUnsupportedError,
        );
      },
    );

    test(
      'given label values containing null character, when accessing different combinations, then they are treated as distinct',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['label1', 'label2'],
        );

        counter.labels(['a', 'b\x00c']).inc();
        counter.labels(['a\x00b', 'c']).inc(2);

        expect(counter.labels(['a', 'b\x00c']).value, equals(1));
        expect(counter.labels(['a\x00b', 'c']).value, equals(2));

        final samples = counter.collect();
        expect(samples, hasLength(2));
      },
    );

    test(
      'given label values with special characters, when accessing different combinations, then they are treated as distinct',
      () {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['path'],
        );

        counter.labels(['/api/\x00/users']).inc();
        counter.labels(['/api/users']).inc(2);

        expect(counter.labels(['/api/\x00/users']).value, equals(1));
        expect(counter.labels(['/api/users']).value, equals(2));
      },
    );
  });

  group('LabeledCounter - concurrency safety', () {
    test(
      'given a labeled counter with max cardinality 100, when creating 150 labels concurrently, then at most 101 succeed',
      () async {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['id'],
          maxCardinality: 100,
        );

        final futures = List.generate(150, (final i) {
          return Future(() {
            try {
              counter.labels(['id_$i']).inc();
              return true;
            } on StateError catch (e) {
              expect(e.message, contains('Maximum cardinality'));
              return false;
            }
          });
        });

        final results = await Future.wait(futures);
        final successCount = results.where((final r) => r).length;

        expect(
          successCount,
          inInclusiveRange(100, 101),
          reason:
              'Should create 100-101 labels due to defensive cardinality check',
        );

        for (var i = 0; i < successCount; i++) {
          final labeledCounter = counter.labels(['id_$i']);
          expect(
            labeledCounter.value,
            greaterThanOrEqualTo(1),
            reason: 'Created labels should be usable',
          );
        }
      },
    );

    test(
      'given a labeled counter, when incrementing the same label 100 times concurrently, then all increments are counted',
      () async {
        final counter = LabeledCounter(
          name: 'test_counter',
          help: 'Test counter',
          labelNames: ['method'],
        );

        final futures = List.generate(100, (final i) {
          return Future(() {
            counter.labels(['GET']).inc();
          });
        });

        await Future.wait(futures);

        final value = counter.labels(['GET']).value;
        expect(
          value,
          equals(100),
          reason: 'All concurrent increments should be counted',
        );
      },
    );
  });
}
