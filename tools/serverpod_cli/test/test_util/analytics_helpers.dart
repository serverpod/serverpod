import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import 'builders/generator_config_builder.dart';
import 'endpoint_validation_helpers.dart';

GeneratorConfig buildAnalyticsTestConfig(String serverDir) {
  return GeneratorConfig(
    name: 'myapp',
    type: PackageType.server,
    serverPackage: 'myapp_server',
    dartClientPackage: 'myapp_client',
    dartClientDependsOnServiceClient: true,
    serverPackageDirectoryPathParts: p.split(serverDir),
    sharedModelsSourcePathsParts: const {},
    relativeDartClientPackagePathParts: const ['..', 'myapp_client'],
    modules: const [],
    extraClasses: const [],
    enabledFeatures: const [ServerpodFeature.database],
    databaseDialect: DatabaseDialect.postgres,
  );
}

/// Captures the events a [CliAnalytics] would have sent to PostHog.
///
/// Install with `initializeCliAnalytics(CliAnalytics(analytics: recording)
/// ..enabled = true)` so tests assert on the payload a real command produced,
/// rather than on hand-built inputs.
class RecordingAnalytics extends Analytics {
  final events = <String>[];
  final properties = <Map<String, dynamic>>[];

  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {
    events.add(event);
    this.properties.add(properties);
  }

  void clear() {
    events.clear();
    properties.clear();
  }

  /// The single payload recorded for [event]. Fails the test when the event was
  /// not sent exactly once, so a silently dropped event cannot pass as an
  /// empty assertion.
  Map<String, dynamic> eventNamed(String event) {
    final matches = [
      for (var i = 0; i < events.length; i++)
        if (events[i] == event) properties[i],
    ];

    expect(
      matches,
      hasLength(1),
      reason: 'Expected exactly one "$event"; recorded: $events',
    );
    return matches.single;
  }
}

class GenerateAnalyticsFixture {
  GenerateAnalyticsFixture._({
    required this.projectDir,
    required this.config,
  });

  final Directory projectDir;
  final GeneratorConfig config;

  static Future<GenerateAnalyticsFixture> create() async {
    final projectDir = Directory.systemTemp.createTempSync(
      'cli_analytics_gen_',
    );
    await createTestEnvironment(projectDir);

    _writeDevelopmentConfig(projectDir);
    _writeProtocolModels(projectDir);
    _writeSharedModel(projectDir);
    _writeEndpoint(projectDir);

    return GenerateAnalyticsFixture._(
      projectDir: projectDir,
      config: buildTestServerConfig(
        projectDir,
        sharedModelsSourcePathsParts: const {
          'shared': ['packages', 'shared'],
        },
      ),
    );
  }

  void dispose() => projectDir.deleteIfExists(recursive: true);
}

void _writeDevelopmentConfig(Directory projectDir) {
  File(p.join(projectDir.path, 'config', 'development.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
database:
  host: localhost
  port: 5432
  name: test
  user: test
  dataPath: .serverpod/development/pgdata
redis:
  enabled: true
webServer: {}
insightsServer: {}
futureCallExecutionEnabled: false
''');
}

void _writeProtocolModels(Directory projectDir) {
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
    unique: true
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

  _model(projectDir, 'offline_note', '''
class: OfflineNote
table: offline_note
database: all
fields:
  text: String
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
}

void _writeSharedModel(Directory projectDir) {
  File(
      p.join(
        projectDir.path,
        'packages',
        'shared',
        'lib',
        'src',
        'models',
        'shared_record.yaml',
      ),
    )
    ..createSync(recursive: true)
    ..writeAsStringSync('''
class: SharedRecord
table: shared_record
database: all
fields:
  value: String
''');
}

void _writeEndpoint(Directory projectDir) {
  File(
      p.join(
        projectDir.path,
        'lib',
        'src',
        'endpoints',
        'example_endpoint.dart',
      ),
    )
    ..createSync(recursive: true)
    ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

abstract class BaseEndpoint extends Endpoint {}

class ExampleEndpoint extends BaseEndpoint {
  Future<String> hello(Session session, String name) async => 'Hello \$name';

  Stream<int> ticks(Session session) async* {
    yield 1;
  }
}
''');
}

void _model(Directory projectDir, String name, String yaml) {
  File(p.join(projectDir.path, 'lib', 'src', 'protocol', '$name.spy.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync(yaml);
}
