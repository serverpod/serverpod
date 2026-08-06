import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:test/test.dart';

void main() {
  group('Given runModeFromServerArgs', () {
    test(
      'when args are empty, '
      'then it returns development',
      () {
        expect(runModeFromServerArgs(const []), 'development');
      },
    );

    test(
      'when --mode is set, '
      'then it returns that value',
      () {
        expect(runModeFromServerArgs(const ['--mode', 'staging']), 'staging');
      },
    );

    test(
      'when -m short flag is set, '
      'then it returns that value',
      () {
        expect(runModeFromServerArgs(const ['-m', 'production']), 'production');
      },
    );

    test(
      'when --mode=value form is used, '
      'then it returns that value',
      () {
        expect(runModeFromServerArgs(const ['--mode=test']), 'test');
      },
    );

    test(
      'when args contain unrelated flags, '
      'then mode parsing still works',
      () {
        expect(
          runModeFromServerArgs(const [
            '--server-id',
            'foo',
            '--mode',
            'staging',
            '--apply-migrations',
          ]),
          'staging',
        );
      },
    );

    test(
      'when --mode is missing, '
      'then it falls back to development',
      () {
        expect(
          runModeFromServerArgs(const ['--server-id', 'foo']),
          'development',
        );
      },
    );

    test(
      'when args are malformed, '
      'then it falls back to development without throwing',
      () {
        expect(
          runModeFromServerArgs(const ['--mode']),
          'development',
        );
      },
    );
  });
}
