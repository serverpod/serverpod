import 'package:serverpod_cli/src/analytics/payload_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Given a cli.project_created payload, ', () {
    test('when properties are allowlisted, then they are included.', () {
      final payload = AnalyticsPayloadBuilder.build(
        event: 'cli.project_created',
        projectId: '00000000-0000-4000-8000-000000000001',
        checkoutId: '00000000-0000-4000-8000-000000000002',
        properties: {
          'method': 'create',
          'template': 'server',
          'with_flutter': true,
          'with_docker': true,
          'with_auth': true,
          'with_database': true,
          'force': false,
        },
      );

      expect(payload['method'], 'create');
      expect(payload['template'], 'server');
      expect(payload['with_flutter'], isTrue);
      expect(
        payload[r'$groups'],
        {'project': '00000000-0000-4000-8000-000000000001'},
      );
      expect(payload['checkout_id'], '00000000-0000-4000-8000-000000000002');
      expect(payload['schema_version'], AnalyticsPayloadBuilder.schemaVersion);
    });

    test('when method is invalid, then it throws.', () {
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
            'force': false,
          },
        ),
        throwsArgumentError,
      );
    });
  });

  group('Given a cli.generate payload, ', () {
    test(
      'when one-shot timing is provided, '
      'then incremental fields are omitted.',
      () {
        final payload = AnalyticsPayloadBuilder.build(
          event: 'cli.generate',
          projectId: '00000000-0000-4000-8000-000000000001',
          checkoutId: '00000000-0000-4000-8000-000000000002',
          properties: {
            'features': ['postgres'],
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
      },
    );

    test(
      'when a feature is not allowlisted, then it throws.',
      () {
        expect(
          () => AnalyticsPayloadBuilder.build(
            event: 'cli.generate',
            projectId: '00000000-0000-4000-8000-000000000001',
            checkoutId: '00000000-0000-4000-8000-000000000002',
            properties: {
              'features': ['raw_endpoint_name'],
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
      'when a Serverpod module is not allowlisted, then it throws.',
      () {
        expect(
          () => AnalyticsPayloadBuilder.build(
            event: 'cli.generate',
            projectId: '00000000-0000-4000-8000-000000000001',
            checkoutId: '00000000-0000-4000-8000-000000000002',
            properties: {
              'features': ['postgres'],
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
  });

  group('Given a cli.migration_created payload, ', () {
    test('when both sides are created, then both flags are true.', () {
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
    });
  });
}
