import 'package:serverpod_open_metrics/src/metrics/metric.dart';
import 'package:serverpod_open_metrics/src/metrics/metric_registry.dart';
import 'package:serverpod_open_metrics/src/util/text_format.dart';
import 'package:test/test.dart';

void main() {
  group('OpenMetricsTextFormat', () {
    test('has correct content type', () {
      expect(
        OpenMetricsTextFormat.contentType,
        equals('text/plain; version=0.0.4; charset=utf-8'),
      );
    });

    test('formats simple counter', () {
      final registry = MetricRegistry();
      final counter = registry.counter('test_counter', help: 'A test counter');
      counter.inc(5);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP test_counter A test counter'));
      expect(output, contains('# TYPE test_counter counter'));
      expect(output, contains('test_counter 5'));
    });

    test('formats simple gauge', () {
      final registry = MetricRegistry();
      final gauge = registry.gauge('test_gauge', help: 'A test gauge');
      gauge.set(42);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP test_gauge A test gauge'));
      expect(output, contains('# TYPE test_gauge gauge'));
      expect(output, contains('test_gauge 42'));
    });

    test('formats histogram', () {
      final registry = MetricRegistry();
      final histogram = registry.histogram(
        'test_histogram',
        help: 'A test histogram',
        buckets: [1, 2, 5],
      );
      histogram.observe(1.5);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP test_histogram A test histogram'));
      expect(output, contains('# TYPE test_histogram histogram'));
      expect(output, contains('test_histogram_bucket{le="1.0"} 0'));
      expect(output, contains('test_histogram_bucket{le="2.0"} 1'));
      expect(output, contains('test_histogram_bucket{le="5.0"} 1'));
      expect(output, contains('test_histogram_bucket{le="+Inf"} 1'));
      expect(output, contains('test_histogram_sum 1.5'));
      expect(output, contains('test_histogram_count 1'));
    });

    test('formats labeled counter', () {
      final registry = MetricRegistry();
      final counter = registry.labeledCounter(
        'http_requests',
        help: 'HTTP requests',
        labelNames: ['method', 'status'],
      );

      counter.labels(['GET', '200']).inc(5);
      counter.labels(['POST', '201']).inc(3);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP http_requests HTTP requests'));
      expect(output, contains('# TYPE http_requests counter'));
      expect(
        output,
        contains('http_requests{method="GET",status="200"} 5'),
      );
      expect(
        output,
        contains('http_requests{method="POST",status="201"} 3'),
      );
    });

    test('formats multiple metrics', () {
      final registry = MetricRegistry();

      registry.counter('counter1', help: 'Counter 1').inc();
      registry.gauge('gauge1', help: 'Gauge 1').set(10);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP counter1 Counter 1'));
      expect(output, contains('# TYPE counter1 counter'));
      expect(output, contains('counter1 1'));

      expect(output, contains('# HELP gauge1 Gauge 1'));
      expect(output, contains('# TYPE gauge1 gauge'));
      expect(output, contains('gauge1 10'));
    });

    test('sorts metrics alphabetically', () {
      final registry = MetricRegistry();

      registry.counter('zebra', help: 'Z');
      registry.counter('alpha', help: 'A');
      registry.counter('bravo', help: 'B');

      final output = OpenMetricsTextFormat.format(registry);

      final alphaIndex = output.indexOf('# HELP alpha');
      final bravoIndex = output.indexOf('# HELP bravo');
      final zebraIndex = output.indexOf('# HELP zebra');

      expect(alphaIndex, lessThan(bravoIndex));
      expect(bravoIndex, lessThan(zebraIndex));
    });

    test('escapes backslash in help text', () {
      final registry = MetricRegistry();
      registry.counter('test', help: r'Contains \ backslash');

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains(r'# HELP test Contains \\ backslash'));
    });

    test('escapes newline in help text', () {
      final registry = MetricRegistry();
      registry.counter('test', help: 'Line 1\nLine 2');

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains(r'# HELP test Line 1\nLine 2'));
    });

    test('escapes backslash in label values', () {
      final registry = MetricRegistry();
      final counter = registry.labeledCounter(
        'test',
        help: 'Test',
        labelNames: ['path'],
      );

      counter.labels([r'C:\Windows']).inc();

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains(r'test{path="C:\\Windows"} 1'));
    });

    test('escapes double quote in label values', () {
      final registry = MetricRegistry();
      final counter = registry.labeledCounter(
        'test',
        help: 'Test',
        labelNames: ['message'],
      );

      counter.labels(['Say "hello"']).inc();

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains(r'test{message="Say \"hello\""} 1'));
    });

    test('escapes newline in label values', () {
      final registry = MetricRegistry();
      final counter = registry.labeledCounter(
        'test',
        help: 'Test',
        labelNames: ['text'],
      );

      counter.labels(['Line 1\nLine 2']).inc();

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains(r'test{text="Line 1\nLine 2"} 1'));
    });

    test('formats positive infinity', () {
      // Create a handcrafted sample with positive infinity
      // (metrics themselves reject infinity, but the formatter should handle it)
      final sample = MetricSample(
        name: 'test_metric',
        labels: {},
        value: double.infinity,
      );

      final output = OpenMetricsTextFormat.formatSamples([sample]);
      expect(output, equals('test_metric +Inf\n'));
    });

    test('formats negative infinity', () {
      final sample = MetricSample(
        name: 'test_metric',
        labels: {},
        value: double.negativeInfinity,
      );

      final output = OpenMetricsTextFormat.formatSamples([sample]);
      expect(output, equals('test_metric -Inf\n'));
    });

    test('formats NaN', () {
      final sample = MetricSample(
        name: 'test_metric',
        labels: {},
        value: double.nan,
      );

      final output = OpenMetricsTextFormat.formatSamples([sample]);
      expect(output, equals('test_metric NaN\n'));
    });

    test('formats floating point values', () {
      final registry = MetricRegistry();
      final gauge = registry.gauge('test', help: 'Test');
      gauge.set(3.14159);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('test 3.14159'));
    });

    test('formats zero', () {
      final registry = MetricRegistry();
      registry.counter('test', help: 'Test');

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('test 0'));
    });

    test('formats negative values', () {
      final registry = MetricRegistry();
      final gauge = registry.gauge('test', help: 'Test');
      gauge.set(-42);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('test -42'));
    });

    test('empty registry produces empty output', () {
      final registry = MetricRegistry();

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, equals(''));
    });

    test('handles metrics with no samples', () {
      final registry = MetricRegistry();
      registry.labeledCounter(
        'test',
        help: 'Test',
        labelNames: ['label'],
      );
      // Don't add any label values, so no samples

      final output = OpenMetricsTextFormat.format(registry);

      // Should have HELP and TYPE but no sample lines
      expect(output, contains('# HELP test Test'));
      expect(output, contains('# TYPE test counter'));
      expect(
        output.split('\n').where((final line) => line.startsWith('test{')),
        isEmpty,
      );
    });

    test('formats histogram with multiple observations', () {
      final registry = MetricRegistry();
      final histogram = registry.histogram(
        'request_duration',
        help: 'Request duration',
        buckets: [0.1, 0.5, 1.0],
      );

      histogram.observe(0.05);
      histogram.observe(0.3);
      histogram.observe(0.8);
      histogram.observe(2.0);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('request_duration_bucket{le="0.1"} 1'));
      expect(output, contains('request_duration_bucket{le="0.5"} 2'));
      expect(output, contains('request_duration_bucket{le="1.0"} 3'));
      expect(output, contains('request_duration_bucket{le="+Inf"} 4'));
      expect(output, contains('request_duration_sum 3.15'));
      expect(output, contains('request_duration_count 4'));
    });

    test('labeled histogram with multiple label combinations', () {
      final registry = MetricRegistry();
      final histogram = registry.labeledHistogram(
        'request_duration',
        help: 'Request duration',
        labelNames: ['method'],
        buckets: [1.0],
      );

      histogram.labels(['GET']).observe(0.5);
      histogram.labels(['POST']).observe(1.5);

      final output = OpenMetricsTextFormat.format(registry);

      expect(
        output,
        contains('request_duration_bucket{method="GET",le="1.0"} 1'),
      );
      expect(
        output,
        contains('request_duration_bucket{method="POST",le="1.0"} 0'),
      );
      expect(output, contains('request_duration_sum{method="GET"} 0.5'));
      expect(output, contains('request_duration_sum{method="POST"} 1.5'));
    });

    test('formatSamples works without registry', () {
      final registry = MetricRegistry();
      final counter = registry.counter('test', help: 'Test');
      counter.inc(5);

      final samples = registry.collectAll();
      final output = OpenMetricsTextFormat.formatSamples(samples);

      expect(output, contains('test 5'));
      // Should not contain HELP or TYPE metadata
      expect(output, isNot(contains('# HELP')));
      expect(output, isNot(contains('# TYPE')));
    });

    test('all lines end with newline', () {
      final registry = MetricRegistry();
      registry.counter('test', help: 'Test').inc();

      final output = OpenMetricsTextFormat.format(registry);

      // Split by newline and check no empty trailing elements except the last
      final lines = output.split('\n');
      for (var i = 0; i < lines.length - 1; i++) {
        expect(lines[i], isNotEmpty);
      }
      // Last element should be empty (output ends with \n)
      expect(lines.last, isEmpty);
    });

    test('handles metric names ending with _bucket', () {
      final registry = MetricRegistry();
      final gauge = registry.gauge('cache_bucket', help: 'Cache bucket count');
      gauge.set(5);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP cache_bucket Cache bucket count'));
      expect(output, contains('# TYPE cache_bucket gauge'));
      expect(output, contains('cache_bucket 5'));
    });

    test('handles metric names ending with _sum', () {
      final registry = MetricRegistry();
      final counter = registry.counter('total_sum', help: 'Total sum');
      counter.inc(10);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP total_sum Total sum'));
      expect(output, contains('# TYPE total_sum counter'));
      expect(output, contains('total_sum 10'));
    });

    test('handles metric names ending with _count', () {
      final registry = MetricRegistry();
      final gauge = registry.gauge('error_count', help: 'Error count');
      gauge.set(3);

      final output = OpenMetricsTextFormat.format(registry);

      expect(output, contains('# HELP error_count Error count'));
      expect(output, contains('# TYPE error_count gauge'));
      expect(output, contains('error_count 3'));
    });

    test('handles histogram and gauge with conflicting suffix names', () {
      final registry = MetricRegistry();

      // Create a histogram named 'request_duration'
      final histogram = registry.histogram(
        'request_duration',
        help: 'Request duration',
        buckets: [1.0],
      );
      histogram.observe(0.5);

      // Create a gauge that happens to end with _sum
      final gauge = registry.gauge('total_sum', help: 'Total sum');
      gauge.set(100);

      final output = OpenMetricsTextFormat.format(registry);
      final lines = output.split('\n');

      // Find histogram section
      final histogramTypeIndex = lines.indexWhere(
        (final line) => line == '# TYPE request_duration histogram',
      );
      expect(histogramTypeIndex, greaterThan(0));

      final histogramSectionEnd = lines.indexWhere(
        (final line) =>
            line.startsWith('# TYPE') && line != lines[histogramTypeIndex],
        histogramTypeIndex + 1,
      );
      final histogramEndIndex = histogramSectionEnd == -1
          ? lines.length
          : histogramSectionEnd;
      final histogramSection = lines
          .sublist(histogramTypeIndex, histogramEndIndex)
          .join('\n');

      // Verify all histogram samples are in the histogram section
      expect(histogramSection, contains('request_duration_bucket{le="1.0"} 1'));
      expect(histogramSection, contains('request_duration_sum 0.5'));
      expect(histogramSection, contains('request_duration_count 1'));

      // Find gauge section
      final gaugeTypeIndex = lines.indexWhere(
        (final line) => line == '# TYPE total_sum gauge',
      );
      expect(gaugeTypeIndex, greaterThan(0));

      final gaugeSectionEnd = lines.indexWhere(
        (final line) =>
            line.startsWith('# TYPE') && line != lines[gaugeTypeIndex],
        gaugeTypeIndex + 1,
      );
      final gaugeEndIndex = gaugeSectionEnd == -1
          ? lines.length
          : gaugeSectionEnd;
      final gaugeSection = lines
          .sublist(gaugeTypeIndex, gaugeEndIndex)
          .join('\n');

      // Verify gauge sample is in the gauge section
      expect(gaugeSection, contains('total_sum 100'));
    });

    test('correctly groups histogram samples with base metric', () {
      final registry = MetricRegistry();

      // Create histogram
      final histogram = registry.histogram(
        'http_requests',
        help: 'HTTP requests',
        buckets: [1.0, 5.0],
      );
      histogram.observe(2.0);

      final output = OpenMetricsTextFormat.format(registry);
      final lines = output.split('\n');

      // HELP/TYPE should only appear once
      final helpLines = lines
          .where((final l) => l.startsWith('# HELP http_requests'))
          .length;
      expect(helpLines, equals(1));

      // Find histogram section
      final histogramTypeIndex = lines.indexWhere(
        (final line) => line == '# TYPE http_requests histogram',
      );
      expect(histogramTypeIndex, greaterThan(0));

      final histogramSectionEnd = lines.indexWhere(
        (final line) => line.startsWith('# TYPE'),
        histogramTypeIndex + 1,
      );
      final histogramEndIndex = histogramSectionEnd == -1
          ? lines.length
          : histogramSectionEnd;
      final histogramSection = lines
          .sublist(histogramTypeIndex, histogramEndIndex)
          .join('\n');

      // All histogram samples should be within the histogram section
      expect(histogramSection, contains('http_requests_bucket{le="1.0"} 0'));
      expect(histogramSection, contains('http_requests_bucket{le="5.0"} 1'));
      expect(histogramSection, contains('http_requests_bucket{le="+Inf"} 1'));
      expect(histogramSection, contains('http_requests_sum 2'));
      expect(histogramSection, contains('http_requests_count 1'));
    });

    test(
      'metric with name that looks like histogram suffix but no base exists',
      () {
        final registry = MetricRegistry();

        // Create a counter with a name ending in _bucket, but no base metric exists
        final counter = registry.counter(
          'orphan_bucket',
          help: 'Orphan bucket',
        );
        counter.inc(7);

        final output = OpenMetricsTextFormat.format(registry);

        // Should be treated as a regular counter, not a histogram sample
        expect(output, contains('# HELP orphan_bucket Orphan bucket'));
        expect(output, contains('# TYPE orphan_bucket counter'));
        expect(output, contains('orphan_bucket 7'));
      },
    );

    test('histogram and gauge with conflicting names both export correctly', () {
      final registry = MetricRegistry();

      // Create a histogram named 'cache'
      final histogram = registry.histogram(
        'cache',
        help: 'Cache metrics',
        buckets: [1.0],
      );
      histogram.observe(0.5);

      // Create a gauge named 'cache_bucket' (exactly matches histogram suffix)
      final gauge = registry.gauge('cache_bucket', help: 'Cache bucket count');
      gauge.set(42);

      final output = OpenMetricsTextFormat.format(registry);
      final lines = output.split('\n');

      // Find the histogram section (starts with # TYPE cache histogram)
      final histogramTypeIndex = lines.indexWhere(
        (final line) => line == '# TYPE cache histogram',
      );
      expect(
        histogramTypeIndex,
        greaterThan(0),
        reason: 'Histogram TYPE not found',
      );

      // Find the gauge section (starts with # TYPE cache_bucket gauge)
      final gaugeTypeIndex = lines.indexWhere(
        (final line) => line == '# TYPE cache_bucket gauge',
      );
      expect(gaugeTypeIndex, greaterThan(0), reason: 'Gauge TYPE not found');

      // Verify histogram section contains all histogram samples
      // Find the next TYPE or end of file
      final histogramSectionEnd = lines.indexWhere(
        (final line) =>
            line.startsWith('# TYPE') && line != lines[histogramTypeIndex],
        histogramTypeIndex + 1,
      );
      final histogramEndIndex = histogramSectionEnd == -1
          ? lines.length
          : histogramSectionEnd;
      final histogramSection = lines
          .sublist(histogramTypeIndex, histogramEndIndex)
          .join('\n');

      expect(histogramSection, contains('cache_bucket{le="1.0"} 1'));
      expect(histogramSection, contains('cache_bucket{le="+Inf"} 1'));
      expect(histogramSection, contains('cache_sum 0.5'));
      expect(histogramSection, contains('cache_count 1'));

      // Verify gauge section contains only the gauge sample (no histogram buckets)
      final gaugeSectionEnd = lines.indexWhere(
        (final line) =>
            line.startsWith('# TYPE') && line != lines[gaugeTypeIndex],
        gaugeTypeIndex + 1,
      );
      final gaugeEndIndex = gaugeSectionEnd == -1
          ? lines.length
          : gaugeSectionEnd;
      final gaugeSection = lines
          .sublist(gaugeTypeIndex, gaugeEndIndex)
          .join('\n');

      expect(gaugeSection, contains('cache_bucket 42.0'));
      // Gauge section should NOT contain histogram bucket samples with labels
      expect(gaugeSection, isNot(contains('cache_bucket{le=')));
      expect(gaugeSection, isNot(contains('cache_sum')));
      expect(gaugeSection, isNot(contains('cache_count')));
    });

    group('OpenMetrics support', () {
      test('given Prometheus constant, then returns correct content type', () {
        expect(
          OpenMetricsTextFormat.prometheusContentType,
          equals('text/plain; version=0.0.4; charset=utf-8'),
        );
      });

      test('given OpenMetrics constant, then returns correct content type', () {
        expect(
          OpenMetricsTextFormat.openMetricsContentType,
          equals('application/openmetrics-text; version=1.0.0; charset=utf-8'),
        );
      });

      test(
        'given backward compatibility contentType, then points to Prometheus',
        () {
          expect(
            OpenMetricsTextFormat.contentType,
            equals(OpenMetricsTextFormat.prometheusContentType),
          );
        },
      );

      test(
        'given Prometheus format, when formatting metrics, then does not include EOF marker',
        () {
          final registry = MetricRegistry();
          final counter = registry.counter(
            'test_counter',
            help: 'A test counter',
          );
          counter.inc(5);

          final output = OpenMetricsTextFormat.format(
            registry,
            format: MetricsFormat.prometheus,
          );

          expect(output, isNot(contains('# EOF')));
          expect(output, endsWith('test_counter 5.0\n'));
        },
      );

      test(
        'given OpenMetrics format, when formatting metrics, then includes EOF marker',
        () {
          final registry = MetricRegistry();
          final counter = registry.counter(
            'test_counter',
            help: 'A test counter',
          );
          counter.inc(5);

          final output = OpenMetricsTextFormat.format(
            registry,
            format: MetricsFormat.openMetrics,
          );

          expect(output, contains('# EOF'));
          expect(output, endsWith('# EOF\n'));
        },
      );

      test(
        'given no format specified, when formatting metrics, then defaults to Prometheus without EOF',
        () {
          final registry = MetricRegistry();
          final counter = registry.counter(
            'test_counter',
            help: 'A test counter',
          );
          counter.inc();

          final output = OpenMetricsTextFormat.format(registry);

          expect(output, isNot(contains('# EOF')));
        },
      );

      test(
        'given OpenMetrics format with multiple metrics, when formatting, then includes single EOF at end',
        () {
          final registry = MetricRegistry();
          registry.counter('counter1', help: 'Counter 1').inc();
          registry.gauge('gauge1', help: 'Gauge 1').set(10);

          final output = OpenMetricsTextFormat.format(
            registry,
            format: MetricsFormat.openMetrics,
          );

          // Should have exactly one EOF marker at the end
          final eofCount = '# EOF'.allMatches(output).length;
          expect(eofCount, equals(1));
          expect(output, endsWith('# EOF\n'));
        },
      );

      test(
        'given empty registry with OpenMetrics format, when formatting, then returns only EOF',
        () {
          final registry = MetricRegistry();

          final output = OpenMetricsTextFormat.format(
            registry,
            format: MetricsFormat.openMetrics,
          );

          expect(output, equals('# EOF\n'));
        },
      );

      test(
        'given null Accept header, when negotiating format, then returns Prometheus',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(null);
          expect(format, equals(MetricsFormat.prometheus));
        },
      );

      test(
        'given empty Accept header, when negotiating format, then returns Prometheus',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat('');
          expect(format, equals(MetricsFormat.prometheus));
        },
      );

      test(
        'given text/plain Accept header, when negotiating format, then returns Prometheus',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat('text/plain');
          expect(format, equals(MetricsFormat.prometheus));
        },
      );

      test(
        'given application/openmetrics-text Accept header, when negotiating format, then returns OpenMetrics',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(
            'application/openmetrics-text',
          );
          expect(format, equals(MetricsFormat.openMetrics));
        },
      );

      test(
        'given OpenMetrics Accept header with version, when negotiating format, then returns OpenMetrics',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(
            'application/openmetrics-text; version=1.0.0',
          );
          expect(format, equals(MetricsFormat.openMetrics));
        },
      );

      test(
        'given OpenMetrics Accept header with full parameters, when negotiating format, then returns OpenMetrics',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(
            'application/openmetrics-text; version=1.0.0; charset=utf-8',
          );
          expect(format, equals(MetricsFormat.openMetrics));
        },
      );

      test(
        'given uppercase OpenMetrics Accept header, when negotiating format, then returns OpenMetrics',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(
            'APPLICATION/OPENMETRICS-TEXT',
          );
          expect(format, equals(MetricsFormat.openMetrics));
        },
      );

      test(
        'given multiple Accept values with OpenMetrics, when negotiating format, then returns OpenMetrics',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(
            'text/plain; q=0.5, application/openmetrics-text',
          );
          expect(format, equals(MetricsFormat.openMetrics));
        },
      );

      test(
        'given OpenMetrics listed first in Accept header, when negotiating format, then prefers OpenMetrics',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(
            'application/openmetrics-text, text/plain',
          );
          expect(format, equals(MetricsFormat.openMetrics));
        },
      );

      test(
        'given unknown media types in Accept header, when negotiating format, then returns Prometheus',
        () {
          final format = OpenMetricsTextFormat.negotiateFormat(
            'application/json, text/html',
          );
          expect(format, equals(MetricsFormat.prometheus));
        },
      );

      test(
        'given Prometheus format enum, when getting content type, then returns Prometheus content type',
        () {
          final contentType = OpenMetricsTextFormat.getContentType(
            MetricsFormat.prometheus,
          );
          expect(
            contentType,
            equals(OpenMetricsTextFormat.prometheusContentType),
          );
        },
      );

      test(
        'given OpenMetrics format enum, when getting content type, then returns OpenMetrics content type',
        () {
          final contentType = OpenMetricsTextFormat.getContentType(
            MetricsFormat.openMetrics,
          );
          expect(
            contentType,
            equals(OpenMetricsTextFormat.openMetricsContentType),
          );
        },
      );
    });
  });
}
