import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

class TestError extends Error {
  @override
  String toString() {
    return 'TestError';
  }
}

void main() {
  withServerpod(
    'Given an existing session with session logging disabled',
    enableSessionLogging: false,
    serverpodLoggingMode: ServerpodLoggingMode.verbose,
    (sessionBuilder, endpoints) {
      late MockStdout record;

      setUp(() async {
        record = MockStdout();
      });

      test(
        'when closing session with error, the error should be logged and the session should be closed',
        () async {
          await IOOverrides.runZoned(
            () async {
              await sessionBuilder.build().close(error: TestError());
            },
            stdout: () => record,
          );

          expect(record.output, contains('TestError'));
        },
      );

      test(
        'when closing session with error and stackTrace, the error should be logged and the session should be closed',
        () async {
          await IOOverrides.runZoned(
            () async {
              await sessionBuilder.build().close(
                error: TestError(),
                stackTrace: StackTrace.fromString('TestStackTrace'),
              );
            },
            stdout: () => record,
          );

          expect(record.output, contains('TestError'));
          expect(record.output, contains('TestStackTrace'));
        },
      );
    },
  );
}
