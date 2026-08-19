import 'package:serverpod_cli/src/analytics/payload_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given allowlisted project-creation analytics properties, '
    'when building the payload, '
    'then the properties and anonymous project identifiers are included.',
    () {
      final payload = AnalyticsPayloadBuilder.build(
        event: 'cli.project_created',
        projectId: '00000000-0000-4000-8000-000000000001',
        checkoutId: '00000000-0000-4000-8000-000000000002',
        properties: {
          'method': 'create',
          'template': 'fullstack',
          'with_flutter': true,
          'with_docker': true,
          'with_auth': true,
          'with_database': true,
          'database_dialect': 'postgres',
          'with_redis': true,
          'with_website': false,
          'with_webapp': true,
          'ides': ['claude'],
          'force': false,
        },
      );

      expect(payload['method'], 'create');
      expect(payload['template'], 'fullstack');
      expect(payload['with_flutter'], isTrue);
      expect(payload['database_dialect'], 'postgres');
      expect(payload['ides'], ['claude']);
      expect(
        payload[r'$groups'],
        {'project': '00000000-0000-4000-8000-000000000001'},
      );
      expect(payload['checkout_id'], '00000000-0000-4000-8000-000000000002');
      expect(
        payload['schema_version'],
        AnalyticsPayloadBuilder.schemaVersion,
      );
    },
  );

  test(
    'Given analytics properties for server and client migrations, '
    'when building the payload, '
    'then both migrations are reported as created.',
    () {
      final payload = AnalyticsPayloadBuilder.build(
        event: 'cli.migration_created',
        projectId: '00000000-0000-4000-8000-000000000001',
        checkoutId: '00000000-0000-4000-8000-000000000002',
        properties: {
          'server_migration_created': true,
          'client_migration_created': true,
          'server_migration_count': 2,
          'client_migration_count': 1,
          'days_since_first_migration': 5,
          'average_interval_days': 2.5,
          'is_repair_migration': false,
        },
      );

      expect(payload['server_migration_created'], isTrue);
      expect(payload['client_migration_created'], isTrue);
      expect(payload['server_migration_count'], 2);
      expect(payload['client_migration_count'], 1);
    },
  );

  test(
    'Given generation analytics properties with one-shot timing, '
    'when building the payload, '
    'then incremental timing properties are omitted.',
    () {
      final payload = AnalyticsPayloadBuilder.build(
        event: 'cli.generate',
        projectId: '00000000-0000-4000-8000-000000000001',
        checkoutId: '00000000-0000-4000-8000-000000000002',
        properties: {
          'features': ['postgres', 'index_hnsw'],
          'feature_counts': {'index_hnsw': 2},
          'serverpod_modules': ['serverpod_auth'],
          'counts': {'model_count': 1},
          'num_generate_calls': 2,
          'project_age_days': 3,
          'is_watch_mode': false,
          'generation_succeeded': true,
          'oneshot_duration_ms': 120,
          'incremental_avg_duration_ms': null,
          'incremental_run_count': null,
        },
      );

      expect(payload['oneshot_duration_ms'], 120);
      expect(payload.containsKey('incremental_avg_duration_ms'), isFalse);
      expect(payload['counts'], containsPair('endpoint_count', 0));
      expect(
        payload['features'],
        contains('index_hnsw'),
        reason: 'Index types are accepted by shape, not by a copied list.',
      );
      expect(payload['feature_counts'], containsPair('index_hnsw', 2));
    },
  );

  test(
    'Given project-creation analytics properties with an invalid method, '
    'when building the payload, '
    'then an ArgumentError is thrown.',
    () {
      expect(
        () => AnalyticsPayloadBuilder.build(
          event: 'cli.project_created',
          projectId: '00000000-0000-4000-8000-000000000001',
          checkoutId: '00000000-0000-4000-8000-000000000002',
          properties: {
            'method': 'upgrade',
            'template': 'server',
            'with_flutter': true,
            'with_docker': true,
            'with_auth': true,
            'with_database': true,
            'database_dialect': 'postgres',
            'with_redis': false,
            'with_website': false,
            'with_webapp': false,
            'ides': <String>[],
            'force': false,
          },
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given generation analytics properties with an unrecognized feature, '
    'when building the payload, '
    'then an ArgumentError is thrown.',
    () {
      expect(
        () => AnalyticsPayloadBuilder.build(
          event: 'cli.generate',
          projectId: '00000000-0000-4000-8000-000000000001',
          checkoutId: '00000000-0000-4000-8000-000000000002',
          properties: {
            'features': ['raw_endpoint_name'],
            'feature_counts': <String, int>{},
            'serverpod_modules': ['serverpod_auth'],
            'counts': {'model_count': 1},
            'num_generate_calls': 2,
            'project_age_days': 3,
            'is_watch_mode': false,
            'generation_succeeded': true,
            'oneshot_duration_ms': 120,
            'incremental_avg_duration_ms': null,
            'incremental_run_count': null,
          },
        ),
        throwsArgumentError,
      );
    },
  );

  test(
    'Given generation analytics properties with an unrecognized Serverpod module, '
    'when building the payload, '
    'then an ArgumentError is thrown.',
    () {
      expect(
        () => AnalyticsPayloadBuilder.build(
          event: 'cli.generate',
          projectId: '00000000-0000-4000-8000-000000000001',
          checkoutId: '00000000-0000-4000-8000-000000000002',
          properties: {
            'features': ['postgres'],
            'feature_counts': <String, int>{},
            'serverpod_modules': ['my_custom_module'],
            'counts': {'model_count': 1},
            'num_generate_calls': 2,
            'project_age_days': 3,
            'is_watch_mode': false,
            'generation_succeeded': true,
            'oneshot_duration_ms': 120,
            'incremental_avg_duration_ms': null,
            'incremental_run_count': null,
          },
        ),
        throwsArgumentError,
      );
    },
  );
}
