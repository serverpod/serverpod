import 'package:serverpod_cli/src/migrations/generator.dart';
import 'package:test/test.dart';

void main() {
  group('Given MigrationGenerator.createVersionName', () {
    test('when tag is omitted, then it returns a timestamp version name', () {
      final versionName = MigrationGenerator.createVersionName(null);

      expect(versionName, matches(RegExp(r'^\d{17}$')));
    });

    test('when tag contains unsafe characters, then it is sanitized', () {
      final versionName = MigrationGenerator.createVersionName(
        'foo..bar/baz\\qux:\'"*?<>|',
      );

      expect(versionName, matches(RegExp(r'^\d{17}-foo_bar_baz_qux_$')));
    });

    test('when tag has repeated invalid characters, then they collapse', () {
      final versionName = MigrationGenerator.createVersionName('foo..bar');

      expect(versionName, matches(RegExp(r'^\d{17}-foo_bar$')));
    });
  });
}
