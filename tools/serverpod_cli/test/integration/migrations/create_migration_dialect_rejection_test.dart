import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/database/column_definition_builder.dart';
import '../../test_util/builders/database/database_definition_builder.dart';
import '../../test_util/builders/database/index_definition_builder.dart';
import '../../test_util/builders/database/table_definition_builder.dart';
import '../../test_util/builders/generator_config_builder.dart';

/// A model can declare database behavior that only some dialects can express,
/// and it reaches every dialect the project migrates to. Examples include a
/// null-not-distinct index or a non-ID serial column reaching SQLite.
///
/// These tests drive the real action against an on-disk project to lock that
/// hard dialect rejection returns a single top-level [CreateMigrationFailed],
/// leaves registries unchanged, and never reports [CreateMigrationCreated] for
/// computed-but-discarded artifacts.
void main() {
  const projectName = 'example_project';
  const moduleMigrationVersion = '00000000000000';
  const moduleName = 'auth';

  late Directory root;
  late Directory serverDirectory;
  late Directory moduleServerDirectory;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('create_migration_reject_');
    serverDirectory = Directory(
      path.join(root.path, '${projectName}_server'),
    )..createSync(recursive: true);

    File(path.join(serverDirectory.path, 'pubspec.yaml')).writeAsStringSync('''
name: ${projectName}_server
''');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  void writeClientTableModel({required bool nullsDistinct}) {
    var hostModelsDir = Directory(
      path.join(serverDirectory.path, 'lib', 'src', 'models'),
    )..createSync(recursive: true);
    File(path.join(hostModelsDir.path, 'example.yaml')).writeAsStringSync('''
class: Example
table: example
database: all
fields:
  name: String?
indexes:
  example_unique_idx:
    fields: name
    unique: true
    nulls_distinct: $nullsDistinct
''');
  }

  void writeClientTableModelWithSerial({required bool includeSerial}) {
    var hostModelsDir = Directory(
      path.join(serverDirectory.path, 'lib', 'src', 'models'),
    )..createSync(recursive: true);
    File(path.join(hostModelsDir.path, 'example.yaml')).writeAsStringSync('''
class: Example
table: example
database: all
fields:
  name: String${includeSerial ? '\n  syncVersion: int?, defaultPersist=serial' : ''}
''');
  }

  void writeSqliteServerAndClientModels({
    required bool serverNullsDistinct,
    bool includeClientDescription = false,
  }) {
    var hostModelsDir = Directory(
      path.join(serverDirectory.path, 'lib', 'src', 'models'),
    )..createSync(recursive: true);

    File(path.join(hostModelsDir.path, 'server_only.yaml')).writeAsStringSync(
      '''
class: ServerOnly
table: server_only
database: server
fields:
  name: String?
indexes:
  server_unique_idx:
    fields: name
    unique: true
    nulls_distinct: $serverNullsDistinct
''',
    );

    File(path.join(hostModelsDir.path, 'client_host.yaml')).writeAsStringSync(
      '''
class: ClientHost
table: client_host
database: all
fields:
  title: String${includeClientDescription ? '\n  description: String?' : ''}
''',
    );
  }

  GeneratorConfig buildConfig({
    DatabaseDialect databaseDialect = DatabaseDialect.postgres,
    List<ModuleConfig> modules = const [],
  }) => GeneratorConfigBuilder()
      .withName(projectName)
      .withModules(modules)
      .withDatabaseDialect(databaseDialect)
      .withServerPackageDirectoryPathParts(path.split(serverDirectory.path))
      .build();

  Directory serverMigrationsDirectory() =>
      MigrationConstants.migrationsBaseDirectory(serverDirectory);

  Directory clientMigrationsDirectory(GeneratorConfig config) =>
      MigrationConstants.clientMigrationsBaseDirectory(
        Directory(path.normalize(path.joinAll(config.clientPackagePathParts))),
      );

  File serverMigrationRegistryFile() => File(
    path.join(serverMigrationsDirectory().path, 'migration_registry.txt'),
  );

  File clientMigrationRegistryFile(GeneratorConfig config) => File(
    path.join(
      clientMigrationsDirectory(config).path,
      'migration_registry.dart',
    ),
  );

  String readServerRegistry() =>
      serverMigrationRegistryFile().readAsStringSync();

  String readClientRegistry(GeneratorConfig config) =>
      clientMigrationRegistryFile(config).readAsStringSync();

  List<String> listMigrationVersions(Directory migrationsDirectory) {
    if (!migrationsDirectory.existsSync()) {
      return [];
    }
    return migrationsDirectory
        .listSync()
        .whereType<Directory>()
        .map((directory) => path.basename(directory.path))
        .toList()
      ..sort();
  }

  group(
    'Given a client migration with a null-distinct index and a model changing it to null-not-distinct,',
    () {
      late GeneratorConfig config;
      late String serverRegistryBeforeRejection;
      late String clientRegistryBeforeRejection;
      late List<String> serverVersionsBeforeRejection;
      late List<String> clientVersionsBeforeRejection;

      setUp(() async {
        writeClientTableModel(nullsDistinct: true);
        config = buildConfig();
        await createMigrationAction(config: config);
        writeClientTableModel(nullsDistinct: false);
        serverRegistryBeforeRejection = readServerRegistry();
        clientRegistryBeforeRejection = readClientRegistry(config);
        serverVersionsBeforeRejection = listMigrationVersions(
          serverMigrationsDirectory(),
        );
        clientVersionsBeforeRejection = listMigrationVersions(
          clientMigrationsDirectory(config),
        );
      });

      test(
        'when creating a migration, '
        'then it fails at the top level and leaves registries unchanged.',
        () async {
          var result = await createMigrationAction(config: config);

          expect(result, isA<CreateMigrationFailed>());
          expect(
            (result as CreateMigrationFailed).message,
            'Unable to create migration for the "sqlite" database. The '
            'following is not supported by this database:\n'
            '  • Index "example_unique_idx" on table "example" treats null '
            'values as equal, which "sqlite" cannot express.',
          );
          expect(result.success, isFalse);
          expect(readServerRegistry(), serverRegistryBeforeRejection);
          expect(readClientRegistry(config), clientRegistryBeforeRejection);
          expect(
            listMigrationVersions(serverMigrationsDirectory()),
            serverVersionsBeforeRejection,
          );
          expect(
            listMigrationVersions(clientMigrationsDirectory(config)),
            clientVersionsBeforeRejection,
          );
        },
      );

      test(
        'when creating a migration with force, '
        'then it is still rejected and leaves registries unchanged.',
        () async {
          var result = await createMigrationAction(
            config: config,
            force: true,
          );

          expect(result, isA<CreateMigrationFailed>());
          expect(readServerRegistry(), serverRegistryBeforeRejection);
          expect(readClientRegistry(config), clientRegistryBeforeRejection);
        },
      );
    },
  );

  test(
    'Given a client database table with a null-distinct index, '
    'when creating a migration, '
    'then both the server and client migrations are created.',
    () async {
      writeClientTableModel(nullsDistinct: true);

      var result = await createMigrationAction(config: buildConfig());

      expect(result, isA<CreateMigrationServerClientCreated>());
      expect(result.success, isTrue);
    },
  );

  group(
    'Given a PostgreSQL server and SQLite client migration adding a non-ID serial column,',
    () {
      late GeneratorConfig config;
      late String serverRegistryBeforeRejection;
      late String clientRegistryBeforeRejection;
      late List<String> serverVersionsBeforeRejection;
      late List<String> clientVersionsBeforeRejection;

      setUp(() async {
        writeClientTableModelWithSerial(includeSerial: false);
        config = buildConfig();
        await createMigrationAction(config: config);
        writeClientTableModelWithSerial(includeSerial: true);
        serverRegistryBeforeRejection = readServerRegistry();
        clientRegistryBeforeRejection = readClientRegistry(config);
        serverVersionsBeforeRejection = listMigrationVersions(
          serverMigrationsDirectory(),
        );
        clientVersionsBeforeRejection = listMigrationVersions(
          clientMigrationsDirectory(config),
        );
      });

      test(
        'when creating a migration, '
        'then it rejects the SQLite migration and persists neither side.',
        () async {
          var result = await createMigrationAction(config: config);

          expect(result, isA<CreateMigrationFailed>());
          expect(
            (result as CreateMigrationFailed).message,
            'Unable to create migration for the "sqlite" database. The '
            'following is not supported by this database:\n'
            '  • Column "syncVersion" on table "example" uses "serial" as its '
            'default value, but "sqlite" only supports auto-increment on the '
            '"id" column.',
          );
          expect(result.success, isFalse);
          expect(readServerRegistry(), serverRegistryBeforeRejection);
          expect(readClientRegistry(config), clientRegistryBeforeRejection);
          expect(
            listMigrationVersions(serverMigrationsDirectory()),
            serverVersionsBeforeRejection,
          );
          expect(
            listMigrationVersions(clientMigrationsDirectory(config)),
            clientVersionsBeforeRejection,
          );
        },
      );
    },
  );

  group(
    'Given a SQLite server project with a server-only dialect rejection and a host client change in the same run,',
    () {
      late GeneratorConfig config;
      late String serverRegistryBeforeRejection;
      late String clientRegistryBeforeRejection;
      late List<String> serverVersionsBeforeRejection;
      late List<String> clientVersionsBeforeRejection;

      setUp(() async {
        writeSqliteServerAndClientModels(serverNullsDistinct: true);
        config = buildConfig(databaseDialect: DatabaseDialect.sqlite);
        await createMigrationAction(config: config);
        writeSqliteServerAndClientModels(
          serverNullsDistinct: false,
          includeClientDescription: true,
        );
        serverRegistryBeforeRejection = readServerRegistry();
        clientRegistryBeforeRejection = readClientRegistry(config);
        serverVersionsBeforeRejection = listMigrationVersions(
          serverMigrationsDirectory(),
        );
        clientVersionsBeforeRejection = listMigrationVersions(
          clientMigrationsDirectory(config),
        );
      });

      test(
        'when creating a migration, '
        'then it fails at the top level and suppresses the client-side change.',
        () async {
          var result = await createMigrationAction(config: config);

          expect(result, isA<CreateMigrationFailed>());
          expect(
            (result as CreateMigrationFailed).message,
            contains('server_unique_idx'),
          );
          expect(readServerRegistry(), serverRegistryBeforeRejection);
          expect(readClientRegistry(config), clientRegistryBeforeRejection);
          expect(
            listMigrationVersions(serverMigrationsDirectory()),
            serverVersionsBeforeRejection,
          );
          expect(
            listMigrationVersions(clientMigrationsDirectory(config)),
            clientVersionsBeforeRejection,
          );
        },
      );
    },
  );

  ModuleConfig writeModuleMigrationWithNullDistinctIndex({
    required bool nullsDistinct,
  }) {
    moduleServerDirectory = Directory(path.join(root.path, 'auth_server'));
    var moduleDefinition = DatabaseDefinitionBuilder()
        .withModuleName(moduleName)
        .withInstalledModules([
          DatabaseMigrationVersion(
            module: moduleName,
            version: moduleMigrationVersion,
          ),
        ])
        .withTable(
          TableDefinitionBuilder()
              .withName('serverpod_user_info')
              .withModule(moduleName)
              .withColumn(
                ColumnDefinitionBuilder()
                    .withName('email')
                    .withIsNullable(true)
                    .withDartType('String?')
                    .build(),
              )
              .withIndex(
                IndexDefinitionBuilder()
                    .withIndexName('user_email_unique_idx')
                    .withElements([
                      IndexElementDefinition(
                        type: IndexElementDefinitionType.column,
                        definition: 'email',
                      ),
                    ])
                    .withIsUnique(true)
                    .withNullsDistinct(nullsDistinct)
                    .build(),
              )
              .build(),
        )
        .build();

    _writeModuleMigrationFiles(
      moduleServerDirectory: moduleServerDirectory,
      databaseDefinition: moduleDefinition,
    );

    return ModuleConfig(
      type: PackageType.module,
      name: moduleName,
      nickname: moduleName,
      migrationVersions: [moduleMigrationVersion],
      serverPackageDirectoryPathParts: Uri.file(
        moduleServerDirectory.path,
      ).pathSegments,
    );
  }

  group(
    'Given a dependent module with stored migration artifacts merged into the host migration,',
    () {
      late GeneratorConfig config;
      late String serverRegistryBeforeRejection;
      late String clientRegistryBeforeRejection;
      late List<String> serverVersionsBeforeRejection;
      late List<String> clientVersionsBeforeRejection;

      setUp(() async {
        final moduleConfig = writeModuleMigrationWithNullDistinctIndex(
          nullsDistinct: true,
        );
        expect(moduleConfig.migrationVersions, isNotEmpty);
        expect(
          File(
            path.join(
              moduleServerDirectory.path,
              'migrations',
              moduleMigrationVersion,
              'definition.json',
            ),
          ).existsSync(),
          isTrue,
        );

        writeClientTableModel(nullsDistinct: true);
        config = buildConfig(modules: [moduleConfig]);
        await createMigrationAction(config: config);

        writeModuleMigrationWithNullDistinctIndex(nullsDistinct: false);
        writeClientTableModel(nullsDistinct: true);
        File(
          path.join(
            serverDirectory.path,
            'lib',
            'src',
            'models',
            'example.yaml',
          ),
        ).writeAsStringSync('''
class: Example
table: example
database: all
fields:
  name: String?
  nickname: String?
indexes:
  example_unique_idx:
    fields: name
    unique: true
    nulls_distinct: true
''');

        serverRegistryBeforeRejection = readServerRegistry();
        clientRegistryBeforeRejection = readClientRegistry(config);
        serverVersionsBeforeRejection = listMigrationVersions(
          serverMigrationsDirectory(),
        );
        clientVersionsBeforeRejection = listMigrationVersions(
          clientMigrationsDirectory(config),
        );
      });

      test(
        'when creating a migration, '
        'then it fails at the top level because of the module definition and leaves registries unchanged.',
        () async {
          var result = await createMigrationAction(config: config);

          expect(result, isA<CreateMigrationFailed>());
          expect(
            (result as CreateMigrationFailed).message,
            contains('user_email_unique_idx'),
          );
          expect(readServerRegistry(), serverRegistryBeforeRejection);
          expect(readClientRegistry(config), clientRegistryBeforeRejection);
          expect(
            listMigrationVersions(serverMigrationsDirectory()),
            serverVersionsBeforeRejection,
          );
          expect(
            listMigrationVersions(clientMigrationsDirectory(config)),
            clientVersionsBeforeRejection,
          );
        },
      );
    },
  );
}

void _writeModuleMigrationFiles({
  required Directory moduleServerDirectory,
  required DatabaseDefinition databaseDefinition,
}) {
  var migrationDir = Directory(
    path.join(
      moduleServerDirectory.path,
      'migrations',
      '00000000000000',
    ),
  );
  migrationDir.createSync(recursive: true);

  var migration = DatabaseMigration(
    actions: [],
    warnings: [],
    migrationApiVersion: 1,
  );

  final encoded = SerializationManager.encode(
    databaseDefinition,
    formatted: true,
  );
  File(
    path.join(migrationDir.path, 'definition_project.json'),
  ).writeAsStringSync(encoded);
  File(
    path.join(migrationDir.path, 'definition.json'),
  ).writeAsStringSync(encoded);
  File(path.join(migrationDir.path, 'migration.json')).writeAsStringSync(
    SerializationManager.encode(migration, formatted: true),
  );
  File(
    path.join(migrationDir.path, 'definition.sql'),
  ).writeAsStringSync('-- module definition');
  File(
    path.join(migrationDir.path, 'migration.sql'),
  ).writeAsStringSync('-- module migration');
  File(
    path.join(
      moduleServerDirectory.path,
      'migrations',
      'migration_registry.txt',
    ),
  ).writeAsStringSync('00000000000000\n');
}
