import 'package:serverpod_embedded_postgres/src/binary/binary_source.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given no explicit or environment-selected binary source, '
    'when the binary source is resolved, '
    'then download mode is selected.',
    () {
      expect(
        resolveBinarySource(environment: const {}),
        BinarySource.download,
      );
    },
  );

  test(
    'Given SERVERPOD_PG_SOURCE=auto, '
    'when the binary source is resolved, '
    'then auto mode is selected.',
    () {
      expect(
        resolveBinarySource(
          environment: {'SERVERPOD_PG_SOURCE': 'auto'},
        ),
        BinarySource.auto,
      );
    },
  );

  test(
    'Given SERVERPOD_PG_SOURCE=download, '
    'when the binary source is resolved, '
    'then download mode is selected.',
    () {
      expect(
        resolveBinarySource(
          environment: {'SERVERPOD_PG_SOURCE': 'download'},
        ),
        BinarySource.download,
      );
    },
  );

  test(
    'Given SERVERPOD_PG_SOURCE=build, '
    'when the binary source is resolved, '
    'then build mode is selected.',
    () {
      expect(
        resolveBinarySource(
          environment: {'SERVERPOD_PG_SOURCE': 'build'},
        ),
        BinarySource.build,
      );
    },
  );

  test(
    'Given an unrecognized SERVERPOD_PG_SOURCE value, '
    'when the binary source is resolved, '
    'then download mode is selected.',
    () {
      expect(
        resolveBinarySource(
          environment: const {'SERVERPOD_PG_SOURCE': 'invalid'},
        ),
        BinarySource.download,
      );
    },
  );

  test(
    'Given an explicit source that conflicts with SERVERPOD_PG_SOURCE, '
    'when the binary source is resolved, '
    'then the explicit source is selected.',
    () {
      expect(
        resolveBinarySource(
          explicit: BinarySource.auto,
          environment: const {'SERVERPOD_PG_SOURCE': 'build'},
        ),
        BinarySource.auto,
      );
    },
  );
}
