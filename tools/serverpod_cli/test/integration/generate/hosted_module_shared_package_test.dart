import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/config/serverpod_manifest.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/endpoint_validation_helpers.dart';

const _moduleName = 'hosted_module';
const _moduleServerPackage = '${_moduleName}_server';
const _moduleClientPackage = '${_moduleName}_client';
const _moduleSharedPackage = '${_moduleName}_shared';
const _moduleVersion = '1.0.0';
const _moduleMigrationVersion = '20260101000000000';
const _consumerMigrationVersion = '20260102000000000';
const _sharedModelName = 'HostedSharedModel';
const _sharedTableName = 'hosted_shared_model';

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  group(
    'Given a project using a module and its shared package from a flat hosted cache layout,',
    () {
      late Directory temporaryDirectory;
      late Directory serverDirectory;
      late Directory clientDirectory;
      late GeneratorConfig config;
      Analyzers? analyzers;

      setUpAll(() async {
        temporaryDirectory = Directory.systemTemp.createTempSync(
          'serverpod_hosted_module_shared_package_test_',
        );
        serverDirectory = Directory(
          path.join(temporaryDirectory.path, 'test_server'),
        );
        clientDirectory = Directory(
          path.join(temporaryDirectory.path, 'test_client'),
        );

        await _createProjectFixture(
          temporaryDirectory: temporaryDirectory,
          serverDirectory: serverDirectory,
          clientDirectory: clientDirectory,
        );

        config = await GeneratorConfig.load(
          serverRootDir: serverDirectory.path,
          interactive: false,
        );
        analyzers = await Analyzers.create(config);
      });

      tearDownAll(() async {
        await analyzers?.close();
        await temporaryDirectory.deleteIfExists(recursive: true);
      });

      group('when generating code and migrations,', () {
        late GenerateResult generateResult;
        late Map<String, dynamic> databaseDefinition;

        setUpAll(() async {
          generateResult = await analyzers!.performGenerate(config: config);

          await MigrationGenerator(
            directory: serverDirectory,
            projectName: config.name,
          ).createMigration(
            precomputedVersion: _consumerMigrationVersion,
            empty: true,
            force: true,
            config: config,
          );

          databaseDefinition =
              jsonDecode(
                    MigrationConstants.databaseDefinitionJSONPath(
                      serverDirectory,
                      _consumerMigrationVersion,
                    ).readAsStringSync(),
                  )
                  as Map<String, dynamic>;
        });

        test('then generation succeeds.', () {
          expect(generateResult.success, isTrue);
        });

        test(
          'then server code imports the module public library instead of the shared package internals.',
          () {
            var endpoints = File(
              path.join(
                serverDirectory.path,
                'lib',
                'src',
                'generated',
                'endpoints.dart',
              ),
            ).readAsStringSync();

            expect(
              endpoints,
              contains(
                "import 'package:$_moduleServerPackage/"
                "$_moduleServerPackage.dart'",
              ),
            );
            expect(
              endpoints,
              isNot(contains('package:$_moduleSharedPackage/')),
            );
          },
        );

        test(
          'then client code imports the module public library instead of the shared package internals.',
          () {
            var client = File(
              path.join(
                clientDirectory.path,
                'lib',
                'src',
                'protocol',
                'client.dart',
              ),
            ).readAsStringSync();

            expect(
              client,
              contains(
                "import 'package:$_moduleClientPackage/"
                "$_moduleClientPackage.dart'",
              ),
            );
            expect(
              client,
              isNot(contains('package:$_moduleSharedPackage/')),
            );
          },
        );

        test(
          'then the module shared table remains in definition.json.',
          () {
            var tables = databaseDefinition['tables'] as List<dynamic>;

            expect(
              tables,
              contains(
                isA<Map<String, dynamic>>().having(
                  (table) => table['name'],
                  'name',
                  _sharedTableName,
                ),
              ),
            );
          },
        );
      });
    },
  );
}

Future<void> _createProjectFixture({
  required Directory temporaryDirectory,
  required Directory serverDirectory,
  required Directory clientDirectory,
}) async {
  await createTestEnvironment(serverDirectory);

  var serverpodRoot = await resolveServerpodRoot();
  var hostedCacheDirectory = Directory(
    path.join(temporaryDirectory.path, 'hosted-cache'),
  );
  var moduleServerDirectory = Directory(
    path.join(
      hostedCacheDirectory.path,
      '$_moduleServerPackage-$_moduleVersion',
    ),
  );
  var moduleClientDirectory = Directory(
    path.join(
      hostedCacheDirectory.path,
      '$_moduleClientPackage-$_moduleVersion',
    ),
  );
  var moduleSharedDirectory = Directory(
    path.join(
      hostedCacheDirectory.path,
      '$_moduleSharedPackage-$_moduleVersion',
    ),
  );

  _writeModuleSharedPackage(moduleSharedDirectory, serverpodRoot);
  _writeModuleServerPackage(
    moduleServerDirectory,
    serverpodRoot,
  );
  _writeModuleClientPackage(
    moduleClientDirectory,
    serverpodRoot,
  );
  await _writeModuleMigration(moduleServerDirectory);
  _writeConsumerClientPackage(
    clientDirectory,
    moduleClientDirectory,
    serverpodRoot,
  );
  _writeConsumerServerPackage(
    serverDirectory,
    moduleServerDirectory,
  );

  var serverPubGet = await Process.run(
    'dart',
    ['pub', 'get'],
    workingDirectory: serverDirectory.path,
  );
  assert(
    serverPubGet.exitCode == 0,
    'Failed to add the hosted module dependency: ${serverPubGet.stderr}',
  );
}

void _writeModuleSharedPackage(
  Directory directory,
  String serverpodRoot,
) {
  File(path.join(directory.path, 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
name: $_moduleSharedPackage

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  serverpod_serialization:
    path: $serverpodRoot/packages/serverpod_serialization
''');

  File(path.join(directory.path, 'lib', '$_moduleSharedPackage.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync("export 'src/generated/hosted_shared_model.dart';\n");

  File(
      path.join(
        directory.path,
        'lib',
        'src',
        'generated',
        'hosted_shared_model.dart',
      ),
    )
    ..createSync(recursive: true)
    ..writeAsStringSync('''
class $_sharedModelName {
  $_sharedModelName({required this.name});

  final String name;
}
''');

  File(
      path.join(
        directory.path,
        'lib',
        'src',
        'models',
        'hosted_shared_model.spy.yaml',
      ),
    )
    ..createSync(recursive: true)
    ..writeAsStringSync('''
class: $_sharedModelName
table: $_sharedTableName
database: all
fields:
  name: String
''');
}

void _writeModuleServerPackage(
  Directory directory,
  String serverpodRoot,
) {
  File(path.join(directory.path, 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
name: $_moduleServerPackage

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  serverpod:
    path: $serverpodRoot/packages/serverpod
  $_moduleSharedPackage:
    path: ../$_moduleSharedPackage-$_moduleVersion
''');

  File(path.join(directory.path, 'config', 'generator.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
type: module
nickname: hosted
client_package_path: ../$_moduleClientPackage
# This is the source-package layout. It deliberately does not resolve from
# this versioned hosted-cache directory.
shared_packages:
  - ../$_moduleSharedPackage
''');

  File(path.join(directory.path, 'lib', '$_moduleServerPackage.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(
      "export 'package:$_moduleSharedPackage/$_moduleSharedPackage.dart';\n",
    );

  File(
      path.join(
        directory.path,
        'lib',
        'src',
        'generated',
        ServerpodManifest.fileName,
      ),
    )
    ..createSync(recursive: true)
    ..writeAsStringSync(
      ServerpodManifest(
        sharedPackages: const [_moduleSharedPackage],
      ).toYaml(),
    );
}

void _writeModuleClientPackage(
  Directory directory,
  String serverpodRoot,
) {
  File(path.join(directory.path, 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
name: $_moduleClientPackage

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  serverpod_client:
    path: $serverpodRoot/packages/serverpod_client
  $_moduleSharedPackage:
    path: ../$_moduleSharedPackage-$_moduleVersion
''');

  File(path.join(directory.path, 'lib', '$_moduleClientPackage.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync(
      "export 'package:$_moduleSharedPackage/$_moduleSharedPackage.dart';\n",
    );
}

void _writeConsumerClientPackage(
  Directory directory,
  Directory moduleClientDirectory,
  String serverpodRoot,
) {
  File(path.join(directory.path, 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
name: test_client

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  serverpod_client:
    path: $serverpodRoot/packages/serverpod_client
  $_moduleClientPackage:
    path: ${moduleClientDirectory.path}
''');

  File(path.join(directory.path, 'lib', 'test_client.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync("export 'src/protocol/protocol.dart';\n");
}

void _writeConsumerServerPackage(
  Directory directory,
  Directory moduleServerDirectory,
) {
  var pubspecFile = File(path.join(directory.path, 'pubspec.yaml'));
  pubspecFile.writeAsStringSync(
    pubspecFile.readAsStringSync().replaceFirst(
      'dependencies:\n',
      'dependencies:\n'
          '  $_moduleServerPackage:\n'
          '    path: ${moduleServerDirectory.path}\n',
    ),
  );

  File(path.join(directory.path, 'config', 'generator.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
type: server
client_package_path: ../test_client
''');

  File(
      path.join(
        directory.path,
        'lib',
        'src',
        'endpoints',
        'hosted_module_endpoint.dart',
      ),
    )
    ..createSync(recursive: true)
    ..writeAsStringSync('''
import 'package:$_moduleServerPackage/$_moduleServerPackage.dart';
import 'package:serverpod/serverpod.dart';

class HostedModuleEndpoint extends Endpoint {
  Future<$_sharedModelName> echo(
    Session session,
    $_sharedModelName model,
  ) async {
    return model;
  }
}
''');
}

Future<void> _writeModuleMigration(Directory moduleServerDirectory) async {
  var definition = DatabaseDefinition(
    schemaVersion: currentSchemaVersion,
    moduleName: _moduleName,
    tables: [
      TableDefinition(
        name: _sharedTableName,
        dartName: _sharedModelName,
        module: _moduleName,
        schema: 'public',
        columns: [
          ColumnDefinition(
            name: 'id',
            fieldName: 'id',
            columnType: ColumnType.bigint,
            isNullable: false,
            dartType: 'int?',
          ),
          ColumnDefinition(
            name: 'name',
            fieldName: 'name',
            columnType: ColumnType.text,
            isNullable: false,
            dartType: 'String',
          ),
        ],
        foreignKeys: [],
        indexes: [],
        managed: true,
      ),
    ],
    installedModules: [],
    migrationApiVersion: DatabaseConstants.migrationApiVersion,
  );

  await FileSystemMigrationArtifactStore(
    projectDirectory: moduleServerDirectory,
  ).writeVersion(
    MigrationVersionArtifacts(
      version: _moduleMigrationVersion,
      definitionSql: '',
      migrationSql: '',
      definition: definition,
      projectDefinition: definition,
      migration: DatabaseMigration(
        actions: [],
        warnings: [],
        migrationApiVersion: DatabaseConstants.migrationApiVersion,
      ),
    ),
  );
}
