import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/analytics_helpers.dart';
import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';

/// Writes a model file into the project's protocol directory.
void _model(Directory projectDir, String name, String yaml) {
  File(p.join(projectDir.path, 'lib', 'src', 'protocol', '$name.spy.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync(yaml);
}

void _endpoint(Directory projectDir, String name, String dart) {
  File(p.join(projectDir.path, 'lib', 'src', 'endpoints', '$name.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(dart);
}

void main() {
  group('Given a project generated with a broad set of model features, ', () {
    late Directory projectDir;
    late GeneratorConfig config;
    late RecordingAnalytics recording;
    late Map<String, dynamic> event;

    tearDownAll(() => projectDir.deleteIfExists(recursive: true));

    setUpAll(() async {
      projectDir = Directory.systemTemp.createTempSync('cli_analytics_gen_');
      await createTestEnvironment(projectDir);

      _model(projectDir, 'company', '''
class: Company
table: company
fields:
  name: String, unique
  employees: List<Employee>?, relation
  createdAt: DateTime, tail
indexes:
  company_name_idx:
    fields: name
    type: btree
''');

      _model(projectDir, 'employee', '''
class: Employee
table: employee
fields:
  name: String
  internalNote: String?, scope=serverOnly
  company: Company?, relation
  slot: int, unique(per=name)
''');

      _model(projectDir, 'document', '''
class: Document
table: document
managedMigration: false
fields:
  embedding: Vector(512)
  location: GeographyPoint
  tags: String
indexes:
  document_embedding_idx:
    fields: embedding
    type: hnsw
  document_location_idx:
    fields: location
    type: gist
''');

      _model(projectDir, 'reading', '''
class: Reading
immutable: true
fields:
  value: double
''');

      _model(projectDir, 'audit', '''
class: Audit
serverOnly: true
fields:
  note: String
''');

      _model(projectDir, 'shape', '''
class: Shape
sealed: true
fields:
  label: String
''');

      _model(projectDir, 'circle', '''
class: Circle
extends: Shape
fields:
  radius: double
''');

      _model(projectDir, 'not_found_exception', '''
exception: NotFoundException
sealed: true
fields:
  message: String
''');

      _model(projectDir, 'missing_exception', '''
exception: MissingException
extends: NotFoundException
fields:
  detail: String
''');

      _model(projectDir, 'status', '''
enum: Status
properties:
  code: int
values:
  - active:
      code: 1
  - archived:
      code: 2
''');

      _model(projectDir, 'plain_enum', '''
enum: Plain
values:
  - one
  - two
''');

      _endpoint(projectDir, 'example_endpoint', '''
import 'package:serverpod/serverpod.dart';

abstract class BaseEndpoint extends Endpoint {}

class ExampleEndpoint extends BaseEndpoint {
  Future<String> hello(Session session, String name) async => 'Hello \$name';

  Stream<int> ticks(Session session) async* {
    yield 1;
  }
}
''');

      config = buildTestServerConfig(projectDir);

      recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );

      final success = await performOneShotGenerate(config: config);
      expect(success, isTrue, reason: 'Generation must succeed.');

      event = recording.eventNamed('cli.generate');
    });

    tearDownAll(() => initializeCliAnalytics(CliAnalytics.disabled()));

    test(
      'when generation completes, '
      'then exactly one cli.generate event is sent.',
      () {
        expect(recording.events, ['cli.generate']);
        expect(event['generation_succeeded'], isTrue);
        expect(event['is_watch_mode'], isFalse);
        expect(event['oneshot_duration_ms'], isA<int>());
        expect(event.containsKey('incremental_run_count'), isFalse);
      },
    );

    test(
      'when inspecting counts of models, exceptions and enums, '
      'then each is counted under its own key.',
      () {
        final counts = event['counts'] as Map;

        expect(
          counts['model_count'],
          7,
          reason: 'Company/Employee/Document/Reading/Audit/Shape/Circle',
        );
        expect(
          counts['table_model_count'],
          3,
          reason: 'Company/Employee/Document',
        );
        expect(counts['exception_count'], 2);
        expect(counts['enum_count'], 2);
        expect(counts['endpoint_count'], 1, reason: 'The base is abstract.');
        expect(counts['endpoint_method_count'], 2);
      },
    );

    test(
      'when inspecting model keyword features, '
      'then all keyword tags are reported with their occurrence counts.',
      () {
        final features = event['features'] as List;
        final featureCounts = event['feature_counts'] as Map;

        expect(
          features,
          containsAll([
            'list_relation',
            'object_relation',
            'tail_field',
            'server_only_field',
            'unique_index',
            'unique_per_index',
            'index_btree',
            'table_model',
          ]),
        );

        expect(featureCounts['table_model'], 3);
        expect(featureCounts['tail_field'], 1);
        expect(
          featureCounts['server_only_field'],
          2,
          reason:
              'Employee.internalNote plus the field of the serverOnly Audit '
              'model, whose fields are server-only by inheritance.',
        );
        expect(featureCounts['unique_per_index'], 1);
        expect(featureCounts['list_relation'], 1);
        expect(featureCounts['object_relation'], 1);

        final relationTotal =
            (featureCounts['list_relation'] as int) +
            (featureCounts['object_relation'] as int) +
            (featureCounts['foreign_relation'] as int? ?? 0);
        expect(event['counts'], containsPair('relation_count', relationTotal));
      },
    );

    test(
      'when inspecting the counts for sealed and inheritance features, '
      'then the model and exception tags stay separate.',
      () {
        final features = event['features'] as List;
        final featureCounts = event['feature_counts'] as Map;

        expect(
          features,
          containsAll([
            'sealed_model',
            'model_inheritance',
            'sealed_exception',
            'exception_inheritance',
          ]),
        );
        expect(featureCounts['sealed_model'], 1, reason: 'Shape');
        expect(featureCounts['model_inheritance'], 1, reason: 'Circle');
        expect(
          featureCounts['sealed_exception'],
          1,
          reason: 'NotFoundException',
        );
        expect(featureCounts['exception_inheritance'], 1, reason: 'Missing');
      },
    );

    test(
      'when inspecting the counts for vector, geography and index features, '
      'then each is tagged and counted.',
      () {
        final features = event['features'] as List;
        final featureCounts = event['feature_counts'] as Map;

        expect(
          features,
          containsAll([
            'vector_field',
            'geography_field',
            'immutable_model',
            'server_only_model',
            'unmanaged_migration',
            'index_hnsw',
            'index_gist',
          ]),
        );
        expect(featureCounts['vector_field'], 1);
        expect(featureCounts['geography_field'], 1);
        expect(featureCounts['immutable_model'], 1);
        expect(featureCounts['server_only_model'], 1);
        expect(featureCounts['index_hnsw'], 1);
        expect(featureCounts['index_gist'], 1);

        expect(
          (event['counts'] as Map)['index_count'],
          featureCounts.entries
              .where((e) => (e.key as String).startsWith('index_'))
              .fold<int>(0, (sum, e) => sum + (e.value as int)),
        );
      },
    );

    test(
      'when inspecting the counts for enhanced enum features, '
      'then enhanced_enum is counted once.',
      () {
        expect(event['feature_counts'], containsPair('enhanced_enum', 1));
      },
    );

    test(
      'when inspecting the counts for endpoint features, '
      'then both endpoint inheritance and streaming tags are reported.',
      () {
        expect(
          event['features'],
          containsAll(['endpoint_inheritance', 'streaming_endpoint']),
        );
      },
    );

    test(
      'when inspecting the payload, '
      'then it carries no project path, model name or endpoint name.',
      () {
        final serialized = event.toString();

        for (final secret in [
          projectDir.path,
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

    test(
      'when calling generate a second time with no changes, '
      'then the staleness check skips it and no event is sent.',
      () async {
        recording.clear();

        final success = await performOneShotGenerate(config: config);

        expect(success, isTrue);
        expect(recording.events, isEmpty);
      },
    );

    test(
      'when changing a model and calling generate again, '
      'then the new counts are reported and the call counter advances.',
      () async {
        recording.clear();
        final previousCalls = event['num_generate_calls'] as int;

        _model(projectDir, 'invoice', '''
class: Invoice
table: invoice
fields:
  total: double
''');

        final success = await performOneShotGenerate(
          config: config,
          force: true,
        );
        expect(success, isTrue);

        final next = recording.eventNamed('cli.generate');
        expect((next['counts'] as Map)['model_count'], 8);
        expect((next['counts'] as Map)['table_model_count'], 4);
        expect(next['num_generate_calls'], greaterThan(previousCalls));
      },
    );
  });
}
