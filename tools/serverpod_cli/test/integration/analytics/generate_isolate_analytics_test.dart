import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/isolated_analyzers.dart';
import 'package:test/test.dart';

import '../../test_util/analytics_helpers.dart';

void main() {
  group(
    'Given a feature-rich project and a worker-isolate analyzer, ',
    () {
      late GenerateAnalyticsFixture fixture;
      late IsolatedAnalyzers analyzers;
      late GenerateResult result;

      setUpAll(() async {
        fixture = await GenerateAnalyticsFixture.create();
        analyzers = await IsolatedAnalyzers.create(fixture.config);
        result = await analyzers.performGenerate(config: fixture.config);
      });

      tearDownAll(() async {
        await analyzers.close();
        fixture.dispose();
      });

      test(
        'when generation completes, '
        'then its feature analytics snapshot crosses the isolate boundary.',
        () {
          expect(result.success, isTrue);
          expect(
            result.protocolAnalyticsSnapshot?.featureCounts,
            containsPair('unique_field', 1),
          );
          expect(
            result.protocolAnalyticsSnapshot?.counts,
            containsPair('index_count', 5),
          );
        },
      );
    },
  );
}
