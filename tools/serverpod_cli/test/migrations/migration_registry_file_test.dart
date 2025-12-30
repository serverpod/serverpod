import 'dart:io';
import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/migrations/migration_registry_file.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/mock_log.dart';

void main() {
  group('MigrationRegistryFile', () {
    late String filePath;
    late MockLogger testLogger;

    const m1 = '20251228100000000';
    const m2 = '20251228100000001';
    const m3 = '20251228100000002';

    setUp(() {
      testLogger = MockLogger();
      initializeLoggerWith(testLogger);
      filePath = path.join(d.sandbox, 'migration_registry.txt');
    });

    tearDown(() {
      resetLogger();
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

      test(
        'Given a file with malformed start marker when extracting migrations then an ExitException is thrown and error is logged',
        () {
          // Both markers are present, but more than 2 parts are created by split (e.g. multiple start markers)
          File(filePath).writeAsStringSync('''
<<<<<<< HEAD
part1
<<<<<<< HEAD
part2
=======
part3
>>>>>>> end
''');
          final registryFile = MigrationRegistryFile(filePath);

          expect(
            () => registryFile.extractMigrations(),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains(
              'FormatException: Malformed merge conflict: invalid start marker',
            ),
          );
        },
      );

      test(
        'Given a file with malformed middle marker when extracting migrations then an ExitException is thrown and error is logged',
        () {
          File(filePath).writeAsStringSync('''
<<<<<<< HEAD
part1
=======
part2
=======
part3
>>>>>>> end
''');
          final registryFile = MigrationRegistryFile(filePath);

          expect(
            () => registryFile.extractMigrations(),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains(
              'FormatException: Malformed merge conflict: invalid middle marker',
            ),
          );
        },
      );

      test(
        'Given a file with malformed end marker when extracting migrations then an ExitException is thrown and error is logged',
        () {
          File(filePath).writeAsStringSync('''
<<<<<<< HEAD
part1
=======
part2
>>>>>>> end
>>>>>>> end
''');
          final registryFile = MigrationRegistryFile(filePath);

          expect(
            () => registryFile.extractMigrations(),
            throwsA(isA<ExitException>()),
          );
          expect(
            testLogger.output.errorMessages,
            contains(
              'FormatException: Malformed merge conflict: invalid end marker',
            ),
          );
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
