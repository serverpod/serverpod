import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a migration version name with no tag, '
    'when creating a version name, '
    'then it returns a timestamp-based version name.',
    () {
      final versionName = MigrationGenerator.createVersionName(null);

      expect(versionName, matches(RegExp(r'^\d{17}$')));
    },
  );

  test(
    'Given a migration version name with a tag containing spaces, '
    'when creating a version name, '
    'then the tag is included with the spaces.',
    () {
      const tag = 'foo bar';
      final versionName = MigrationGenerator.createVersionName(tag);

      final tagPart = versionName.split('-').last;
      expect(tagPart, 'foo bar');
    },
  );

  test(
    'Given a migration version name with a tag containing dots, '
    'when creating a version name, '
    'then the dots are preserved.',
    () {
      const tag = 'foo..bar';
      final versionName = MigrationGenerator.createVersionName(tag);

      final tagPart = versionName.split('-').last;
      expect(tagPart, 'foo..bar');
    },
  );

  test(
    'Given a migration version name with a tag containing path separators, '
    'when creating a version name, '
    'then a FormatException is thrown.',
    () {
      expect(
        () => MigrationGenerator.createVersionName('foo/bar'),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test(
    'Given a migration version name with a tag containing unsupported path characters, '
    'when creating a version name, '
    'then a FormatException is thrown.',
    () {
      expect(
        () => MigrationGenerator.createVersionName(r'foo*bar:"<>|'),
        throwsA(isA<FormatException>()),
      );
    },
  );
}
