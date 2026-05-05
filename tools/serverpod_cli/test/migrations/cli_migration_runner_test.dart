import 'package:serverpod_cli/src/migrations/cli_migration_runner.dart';
import 'package:test/test.dart';

void main() {
  group('Given isMissingNativeAssetError', () {
    test(
      'when called with the FFI resolver ArgumentError, '
      'then it returns true',
      () {
        final error = ArgumentError(
          // Verbatim from a real failure (Dart 3.11.5 + sqlite3_connection_pool).
          "Couldn't resolve native function 'pkg_sqlite3_connection_pool_open' "
          "in 'package:sqlite3_connection_pool/sqlite3_connection_pool.dart' : "
          'No available native assets.',
        );
        expect(isMissingNativeAssetError(error), isTrue);
      },
    );

    test(
      'when called with an unrelated ArgumentError, '
      'then it returns false',
      () {
        expect(isMissingNativeAssetError(ArgumentError('bad input')), isFalse);
      },
    );

    test(
      'when called with a non-ArgumentError, '
      'then it returns false',
      () {
        expect(
          isMissingNativeAssetError(StateError('No available native assets')),
          isFalse,
        );
      },
    );
  });

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
