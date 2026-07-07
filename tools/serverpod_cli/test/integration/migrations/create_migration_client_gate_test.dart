import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';

/// `createMigrationAction` only generates a client migration when the host
/// project owns client-side database tables. Shared-package and module tables
/// are merged into the client schema but do not, on their own, enable a client
/// migration. These tests drive the real action against on-disk projects to
/// lock that: a project whose only client tables come from a shared package
/// produces no client migration, while a host client table does.
void main() {
  const projectName = 'example_project';

  late Directory root;
  late Directory serverDirectory;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('create_migration_gate_');
    serverDirectory = Directory(
      path.join(root.path, '${projectName}_server'),
    )..createSync(recursive: true);

    // getProjectName reads the server pubspec; the name must end in `_server`.
    File(path.join(serverDirectory.path, 'pubspec.yaml')).writeAsStringSync('''
name: ${projectName}_server
''');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  void writeSharedTableModel() {
    var sharedModelsDir = Directory(
      path.join(
        serverDirectory.path,
        'packages',
        'shared',
        'lib',
        'src',
        'models',
      ),
    )..createSync(recursive: true);
    File(
      path.join(sharedModelsDir.path, 'shared_table_record.yaml'),
    ).writeAsStringSync('''
class: SharedTableRecord
table: shared_table_record
database: all
fields:
  name: String
''');
  }

  void writeHostClientTableModel() {
    var hostModelsDir = Directory(
      path.join(serverDirectory.path, 'lib', 'src', 'models'),
    )..createSync(recursive: true);
    File(
      path.join(hostModelsDir.path, 'example.yaml'),
    ).writeAsStringSync('''
class: Example
table: example
database: all
fields:
  name: String
''');
  }

  // A dependent module that ships a client table, defined in its own package.
  // An empty `migrationVersions` keeps the module out of the migration-version
  // loader (no module migration artifacts needed on disk) while its model is
  // still discovered and loaded under the module alias.
  ModuleConfig writeModuleClientTableModel() {
    var moduleServerDirectory = Directory(
      path.join(root.path, 'auth_server'),
    );
    var moduleModelsDir = Directory(
      path.join(moduleServerDirectory.path, 'lib', 'src', 'models'),
    )..createSync(recursive: true);
    File(
      path.join(moduleModelsDir.path, 'user_info.yaml'),
    ).writeAsStringSync('''
class: UserInfo
table: serverpod_user_info
database: all
fields:
  name: String
''');

    return ModuleConfig(
      type: PackageType.module,
      name: 'auth',
      nickname: 'auth',
      migrationVersions: [],
      serverPackageDirectoryPathParts: path.split(moduleServerDirectory.path),
    );
  }

  var config = GeneratorConfigBuilder()
      .withName(projectName)
      .withSharedModelsSourcePathsParts({
        'shared': ['packages', 'shared'],
      })
      .withModules([]);

  Directory clientMigrationsDirectory(GeneratorConfig config) =>
      MigrationConstants.clientMigrationsBaseDirectory(
        Directory(path.normalize(path.joinAll(config.clientPackagePathParts))),
      );

  test(
    'Given a project whose only client database table comes from a shared package, '
    'when creating a migration,'
    'then no client migration is generated.',
    () async {
      writeSharedTableModel();

      var builtConfig = config
          .withServerPackageDirectoryPathParts(
            path.split(serverDirectory.path),
          )
          .build();

      var result = await createMigrationAction(config: builtConfig);

      expect(
        result,
        isA<CreateMigrationCreated>(),
        reason:
            'the server migration is created (proving the shared table was '
            'processed) as a server-only result, not a server + client one',
      );
      expect(
        result,
        isNot(isA<CreateMigrationServerClientCreated>()),
        reason:
            'no client migration should be produced alongside the server '
            'migration',
      );
      expect(
        clientMigrationsDirectory(builtConfig).existsSync(),
        isFalse,
        reason: 'no client migration directory should be written',
      );
    },
  );

  test(
    'Given a project with a host client database table, '
    'when creating a migration,'
    'then a client migration is generated.',
    () async {
      writeHostClientTableModel();

      var builtConfig = config
          .withServerPackageDirectoryPathParts(
            path.split(serverDirectory.path),
          )
          .build();

      var result = await createMigrationAction(config: builtConfig);

      expect(
        result,
        isA<CreateMigrationServerClientCreated>(),
        reason:
            'a host client table should produce both a server and a '
            'client migration',
      );

      var clientMigrations = clientMigrationsDirectory(builtConfig);
      expect(
        clientMigrations.existsSync(),
        isTrue,
        reason: 'a client migration directory should be written',
      );
      expect(
        clientMigrations.listSync().whereType<Directory>(),
        isNotEmpty,
        reason: 'a client migration version directory should be written',
      );
    },
  );

  test(
    'Given a project whose only client database table comes from a module dependency, '
    'when creating a migration,'
    'then no client migration is generated.',
    () async {
      var moduleConfig = writeModuleClientTableModel();

      var builtConfig = GeneratorConfigBuilder()
          .withName(projectName)
          .withModules([moduleConfig])
          .withServerPackageDirectoryPathParts(
            path.split(serverDirectory.path),
          )
          .build();

      var result = await createMigrationAction(config: builtConfig);

      // A module owns and migrates its own tables, so a project whose only
      // client table comes from a module has nothing of its own to migrate:
      // neither a server nor a client migration is produced.
      expect(
        result,
        isA<CreateMigrationNoChanges>(),
        reason: 'a module-owned client table gives the host nothing to migrate',
      );
      expect(
        result,
        isNot(isA<CreateMigrationServerClientCreated>()),
        reason:
            'no client migration should be produced for module client '
            'tables',
      );
      expect(
        clientMigrationsDirectory(builtConfig).existsSync(),
        isFalse,
        reason: 'no client migration directory should be written',
      );
    },
  );
}
