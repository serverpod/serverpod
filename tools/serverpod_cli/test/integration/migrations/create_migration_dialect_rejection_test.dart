import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/migrations/create_migration_action.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';

/// A model can declare an index that only some dialects can express, and it
/// reaches every dialect the project migrates to. `nulls_distinct: false` is
/// one such index: PostgreSQL has `NULLS NOT DISTINCT`, SQLite has no
/// equivalent and the constraint cannot be dropped without widening the index.
///
/// These tests drive the real action against an on-disk project to lock that
/// this reports as a normal migration failure naming the offending index,
/// rather than as an internal error.
void main() {
  const projectName = 'example_project';

  late Directory root;
  late Directory serverDirectory;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('create_migration_reject_');
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

  /// Writes a host table model that also lives on the client, so the action
  /// generates a SQLite client migration next to the PostgreSQL server one.
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

  GeneratorConfig buildConfig() => GeneratorConfigBuilder()
      .withName(projectName)
      .withModules([])
      .withServerPackageDirectoryPathParts(path.split(serverDirectory.path))
      .build();

  group(
    'Given a client migration with a null-distinct index and a model changing it to null-not-distinct,',
    () {
      setUp(() async {
        writeClientTableModel(nullsDistinct: true);
        await createMigrationAction(config: buildConfig());
        writeClientTableModel(nullsDistinct: false);
      });

      test(
        'when creating a migration, '
        'then the client migration fails naming the offending index.',
        () async {
          var result = await createMigrationAction(config: buildConfig());

          var clientResult =
              (result as CreateMigrationServerClientCreated).clientResult;

          expect(clientResult, isA<CreateMigrationFailed>());
          expect(
            (clientResult as CreateMigrationFailed).message,
            'Unable to create migration for the "sqlite" database. The '
            'following is not supported by this database:\n'
            '  • Index "example_unique_idx" on table "example" treats null '
            'values as equal, which "sqlite" cannot express.',
          );
          expect(result.success, isFalse);
        },
      );

      test(
        'when creating a migration with force, '
        'then it is still rejected since force cannot widen the index.',
        () async {
          var result = await createMigrationAction(
            config: buildConfig(),
            force: true,
          );

          var clientResult =
              (result as CreateMigrationServerClientCreated).clientResult;

          expect(clientResult, isA<CreateMigrationFailed>());
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
}
