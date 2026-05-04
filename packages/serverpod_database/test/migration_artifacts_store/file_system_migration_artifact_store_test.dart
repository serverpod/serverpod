import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  group('FileSystemMigrationArtifactStore.listVersions', () {
    late Directory projectRoot;

    setUp(() async {
      projectRoot = await Directory.systemTemp.createTemp(
        'serverpod_migration_store_test_',
      );
    });

    tearDown(() async {
      if (await projectRoot.exists()) {
        await projectRoot.delete(recursive: true);
      }
    });

    test(
      'removes trailing migration version directories that contain no files',
      () async {
        final migrationsDir = Directory(
          path.join(projectRoot.path, 'migrations'),
        );
        await migrationsDir.create(recursive: true);

        final first = Directory(
          path.join(migrationsDir.path, '10000000000000'),
        );
        await first.create();
        await File(path.join(first.path, 'gitkeep')).writeAsString('');

        final second = Directory(
          path.join(migrationsDir.path, '20000000000000'),
        );
        await second.create();

        final store = FileSystemMigrationArtifactStore(
          projectDirectory: projectRoot,
        );

        final versions = await store.listVersions();

        expect(versions, ['10000000000000']);
        expect(await second.exists(), isFalse);
      },
    );

    test(
      'rewrites migration_registry.txt when trailing empty directories are pruned',
      () async {
        final migrationsDir = Directory(
          path.join(projectRoot.path, 'migrations'),
        );
        await migrationsDir.create(recursive: true);

        final first = Directory(
          path.join(migrationsDir.path, '10000000000000'),
        );
        await first.create();
        await File(path.join(first.path, 'gitkeep')).writeAsString('');

        final second = Directory(
          path.join(migrationsDir.path, '20000000000000'),
        );
        await second.create();

        final store = FileSystemMigrationArtifactStore(
          projectDirectory: projectRoot,
        );

        await store.writeVersionRegistry([
          '10000000000000',
          '20000000000000',
        ]);

        await store.listVersions();

        final registryBody = await File(
          path.join(migrationsDir.path, 'migration_registry.txt'),
        ).readAsString();
        expect(registryBody, contains('10000000000000'));
        expect(registryBody, isNot(contains('20000000000000')));
      },
    );

    test(
      'does not remove a trailing directory that contains any file',
      () async {
        final migrationsDir = Directory(
          path.join(projectRoot.path, 'migrations'),
        );
        await migrationsDir.create(recursive: true);

        final first = Directory(
          path.join(migrationsDir.path, '10000000000000'),
        );
        await first.create();
        await File(path.join(first.path, 'gitkeep')).writeAsString('');

        final second = Directory(
          path.join(migrationsDir.path, '20000000000000'),
        );
        await second.create();
        await File(path.join(second.path, 'gitkeep')).writeAsString('');

        final store = FileSystemMigrationArtifactStore(
          projectDirectory: projectRoot,
        );

        final versions = await store.listVersions();

        expect(versions, ['10000000000000', '20000000000000']);
        expect(await second.exists(), isTrue);
      },
    );
  });
}
