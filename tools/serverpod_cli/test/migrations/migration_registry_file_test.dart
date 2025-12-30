import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry_file.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  group('MigrationRegistryFile', () {
    late String filePath;
    const m1 = '20251228100000000';
    const m2 = '20251228100000001';
    const m3 = '20251228100000002';

    setUp(() {
      filePath = path.join(d.sandbox, 'migration_registry.txt');
    });

    test(
      'Given a file path when creating MigrationRegistryFile then file property is correctly initialized',
      () {
        final registryFile = MigrationRegistryFile(filePath);
        expect(registryFile.path, equals(filePath));
        expect(registryFile.file.path, equals(filePath));
      },
    );

    group('migrations', () {
      test(
        'Given a registry with valid migrations when getting migrations then they are correctly parsed',
        () {
          File(filePath).writeAsStringSync('$m1\n$m2\n');
          final registryFile = MigrationRegistryFile(filePath);

          expect(registryFile.migrations, equals([m1, m2]));
        },
      );

      test(
        'Given a registry with comments when getting migrations then comments are ignored',
        () {
          File(filePath).writeAsStringSync('''
### Comment
$m1
# Another comment
$m2
''');
          final registryFile = MigrationRegistryFile(filePath);

          expect(registryFile.migrations, equals([m1, m2]));
        },
      );

      test(
        'Given a registry with conflict markers when getting migrations then markers are ignored',
        () {
          File(filePath).writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
>>>>>>> feature-branch
''');
          final registryFile = MigrationRegistryFile(filePath);

          expect(registryFile.migrations, equals([m1, m2, m3]));
        },
      );
    });

    group('hasMergeConflict', () {
      test(
        'Given a file with conflict markers when checking merge conflict then true is returned',
        () {
          File(filePath).writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
>>>>>>> feature-branch
''');
          final registryFile = MigrationRegistryFile(filePath);

          expect(registryFile.hasMergeConflict, isTrue);
        },
      );

      test(
        'Given a file without conflict markers when checking merge conflict then false is returned',
        () {
          File(filePath).writeAsStringSync('$m1\n$m2\n');
          final registryFile = MigrationRegistryFile(filePath);

          expect(registryFile.hasMergeConflict, isFalse);
        },
      );

      test(
        'Given a file with partial conflict markers when checking merge conflict then false is returned',
        () {
          File(filePath).writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
''');
          final registryFile = MigrationRegistryFile(filePath);

          expect(registryFile.hasMergeConflict, isFalse);
        },
      );
    });

    group('extractMigrations', () {
      test(
        'Given a file without conflicts when extracting migrations then all migrations are returned as common',
        () {
          File(filePath).writeAsStringSync('$m1\n$m2\n');
          final registryFile = MigrationRegistryFile(filePath);

          final result = registryFile.extractMigrations();
          expect(result.common, equals([m1, m2]));
          expect(result.local, isEmpty);
          expect(result.incoming, isEmpty);
        },
      );

      test(
        'Given a file with conflicts when extracting migrations then they are correctly partitioned',
        () {
          File(filePath).writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
=======
$m3
>>>>>>> feature-branch
''');
          final registryFile = MigrationRegistryFile(filePath);

          final result = registryFile.extractMigrations();
          expect(result.common, equals([m1]));
          expect(result.local, equals([m2]));
          expect(result.incoming, equals([m3]));
        },
      );

      test(
        'Given a file with multiple migrations in sections when extracting then they are correctly parsed',
        () {
          File(filePath).writeAsStringSync('''
$m1
<<<<<<< HEAD
$m2
$m3
=======
$m3
$m2
>>>>>>> feature-branch
''');
          final registryFile = MigrationRegistryFile(filePath);

          final result = registryFile.extractMigrations();
          expect(result.common, equals([m1]));
          expect(result.local, equals([m2, m3]));
          expect(result.incoming, equals([m3, m2]));
        },
      );
    });

    test(
      'Given a list of migrations when calling update then file is written with correct content',
      () async {
        final registryFile = MigrationRegistryFile(filePath);
        final migrations = [m1, m2];

        await registryFile.update(migrations);

        final content = File(filePath).readAsStringSync();
        expect(content, contains('### AUTOMATICALLY GENERATED DO NOT MODIFY'));
        expect(content, contains('$m1\n$m2\n'));
      },
    );
  });
}
