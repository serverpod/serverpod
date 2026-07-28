import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/protocol_feature_analyzer.dart';
import 'package:serverpod_cli/src/analytics/server_config_features.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:test/test.dart';

import '../../test_util/analytics/generate_analytics_fixture.dart';
import '../../test_util/analytics_helpers.dart';

void main() {
  group(
    'Given a project generated with every non-SQLite, non-future-call tag, ',
    () {
      late GenerateAnalyticsFixture fixture;
      late RecordingAnalytics recording;
      late Map<String, dynamic> event;

      setUpAll(() async {
        fixture = await GenerateAnalyticsFixture.create();
        recording = RecordingAnalytics();
        initializeCliAnalytics(
          CliAnalytics(analytics: recording)..enabled = true,
        );

        final success = await performOneShotGenerate(config: fixture.config);
        expect(success, isTrue, reason: 'Generation must succeed.');

        event = recording.eventNamed('cli.generate');
      });

      tearDownAll(() {
        initializeCliAnalytics(CliAnalytics.disabled());
        fixture.dispose();
      });

      test(
        'when generation completes, '
        'then exactly one one-shot cli.generate event is sent.',
        () {
          expect(recording.events, ['cli.generate']);
          expect(event['generation_succeeded'], isTrue);
          expect(event['is_watch_mode'], isFalse);
          expect(event['oneshot_duration_ms'], isA<int>());
          expect(event.containsKey('incremental_run_count'), isFalse);
        },
      );

      test(
        'when inspecting the static feature vocabulary, '
        'then every fixture-owned tag is reported.',
        () {
          final actualStaticTags = (event['features'] as List)
              .whereType<String>()
              .where(protocolFeatureTags.contains)
              .toSet();

          expect(
            actualStaticTags,
            protocolFeatureTags.difference(const {'sqlite', 'future_call'}),
            reason:
                'SQLite and future calls are exercised by their dedicated '
                'generate integration tests.',
          );
        },
      );

      test(
        'when inspecting configuration features, '
        'then every server configuration tag is presence-only.',
        () {
          final features = (event['features'] as List).toSet();
          final featureCounts = event['feature_counts'] as Map;

          expect(features, containsAll(ServerConfigFeatures.availableTags));
          for (final tag in ServerConfigFeatures.availableTags) {
            expect(
              featureCounts,
              isNot(contains(tag)),
              reason: '$tag reports presence, not an occurrence count.',
            );
          }
        },
      );

      test(
        'when inspecting model and field features, '
        'then every tag carries its occurrence count.',
        () {
          final featureCounts = event['feature_counts'] as Map;

          expect(featureCounts['table_model'], 5);
          expect(featureCounts['shared_model'], 1);
          expect(featureCounts['shared_table_model'], 1);
          expect(featureCounts['sealed_model'], 1);
          expect(featureCounts['model_inheritance'], 1);
          expect(featureCounts['immutable_model'], 1);
          expect(featureCounts['server_only_model'], 1);
          expect(featureCounts['unmanaged_migration'], 1);
          expect(featureCounts['server_only_field'], 2);
          expect(featureCounts['tail_field'], 1);
          expect(featureCounts['vector_field'], 1);
          expect(featureCounts['geography_field'], 1);
          expect(
            featureCounts,
            isNot(contains('client_database')),
            reason: 'Client database support is a project-level presence flag.',
          );
        },
      );

      test(
        'when inspecting endpoint, exception and enum features, '
        'then every tag carries its occurrence count.',
        () {
          final featureCounts = event['feature_counts'] as Map;

          expect(featureCounts['endpoint_inheritance'], 1);
          expect(featureCounts['streaming_endpoint'], 1);
          expect(featureCounts['exception_model'], 2);
          expect(featureCounts['sealed_exception'], 1);
          expect(featureCounts['exception_inheritance'], 1);
          expect(featureCounts['enhanced_enum'], 1);
        },
      );

      test(
        'when inspecting relation and index features, '
        'then every tag and project total carries its occurrence count.',
        () {
          final featureCounts = event['feature_counts'] as Map;
          final counts = event['counts'] as Map;

          expect(featureCounts['list_relation'], 1);
          expect(featureCounts['object_relation'], 1);
          expect(featureCounts['foreign_relation'], 2);
          expect(counts['relation_count'], 4);

          expect(featureCounts['unique_field'], 1);
          expect(featureCounts['unique_index'], 3);
          expect(featureCounts['unique_per_index'], 1);
          expect(featureCounts['index_btree'], 3);
          expect(featureCounts['index_hnsw'], 1);
          expect(featureCounts['index_gist'], 1);
          expect(counts['index_count'], 5);
        },
      );

      test(
        'when inspecting project totals, '
        'then every count key is present with the generated value.',
        () {
          expect(event['counts'], {
            'model_count': 9,
            'table_model_count': 5,
            'shared_model_count': 1,
            'shared_table_model_count': 1,
            'endpoint_count': 1,
            'endpoint_method_count': 2,
            'enum_count': 2,
            'exception_count': 2,
            'relation_count': 4,
            'index_count': 5,
            'future_call_count': 0,
            'module_count': 0,
          });
        },
      );

      test(
        'when inspecting the payload, '
        'then it carries no project path or user-authored name.',
        () {
          final serialized = event.toString();

          for (final secret in [
            fixture.projectDir.path,
            'Company',
            'Employee',
            'NotFoundException',
            'ExampleEndpoint',
            'company_name_idx',
            'document_embedding_idx',
            'embedding',
          ]) {
            expect(
              serialized,
              isNot(contains(secret)),
              reason: '"$secret" must never leave the machine.',
            );
          }
        },
      );
    },
  );
}
