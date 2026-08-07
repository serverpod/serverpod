import 'package:cli_tools/cli_tools.dart' as cli;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log.dart' as shared;
// Imported with `show` because the barrel also exposes the global `log`, which
// would be ambiguous against the CLI logger singleton of the same name.
import 'package:serverpod_shared/log_io.dart' show LogLevel, TestLogWriter;
import 'package:test/test.dart';

/// Writes [message] the way a package shared with the server does, and waits
/// for it to travel through the global chain into the CLI logger.
Future<void> _logGlobally(
  void Function(shared.Log log) write,
) async {
  write(shared.log);
  await shared.log.flush();
  await log.flush();
}

void main() {
  late TestLogWriter writer;

  tearDown(closeLogger);

  group('Given a CLI logger is installed,', () {
    setUp(() {
      writer = TestLogWriter();
      initializeLoggerWith(ServerpodCliLogger(writer));
    });

    test(
      'when a shared package writes a warning to the global log, '
      'then the record reaches the CLI logger.',
      () async {
        await _logGlobally((log) => log.warning('Removed empty directory.'));

        expect(writer.entries, hasLength(1));
        expect(writer.entries.single.message, 'Removed empty directory.');
        expect(writer.entries.single.level, LogLevel.warning);
      },
    );

    test(
      'when a shared package writes an error with an attached error object, '
      'then the error object is rendered with the message.',
      () async {
        var stackTrace = StackTrace.current;

        await _logGlobally(
          (log) => log.error(
            'Failed to apply migration 20240101000000000.',
            error: StateError('relation does not exist'),
            stackTrace: stackTrace,
          ),
        );

        expect(writer.entries, hasLength(1));
        var entry = writer.entries.single;
        expect(entry.level, LogLevel.error);
        expect(entry.message, contains('20240101000000000'));
        expect(entry.message, contains('relation does not exist'));
        expect(entry.stackTrace, stackTrace);
      },
    );

    test(
      'when the CLI and a shared package each write a record, '
      'then each record is delivered once.',
      () async {
        log.warning('CLI warning.');
        await _logGlobally((log) => log.warning('Shared warning.'));

        expect(
          writer.entries.map((entry) => entry.message),
          ['CLI warning.', 'Shared warning.'],
        );
      },
    );

    test(
      'when the logger singleton is replaced, '
      'then a global record is delivered once, to the current logger.',
      () async {
        var replacement = TestLogWriter();
        initializeLoggerWith(ServerpodCliLogger(replacement));

        await _logGlobally((log) => log.warning('Only once.'));

        expect(writer.entries, isEmpty);
        expect(replacement.entries, hasLength(1));
      },
    );
  });

  test(
    'Given a CLI logger with the default log level, '
    'when a shared package writes a debug record to the global log, '
    'then it is filtered out.',
    () async {
      writer = TestLogWriter();
      initializeLoggerWith(ServerpodCliLogger(writer));

      await _logGlobally((log) => log.debug('Noisy detail.'));

      expect(writer.entries, isEmpty);
    },
  );

  test(
    'Given a CLI logger with verbose logging, '
    'when a shared package writes a debug record to the global log, '
    'then the record reaches the CLI logger.',
    () async {
      writer = TestLogWriter();
      initializeLoggerWith(ServerpodCliLogger(writer));
      log.logLevel = cli.LogLevel.debug;

      await _logGlobally((log) => log.debug('Noisy detail.'));

      expect(writer.entries, hasLength(1));
      expect(writer.entries.single.level, LogLevel.debug);
    },
  );

  test(
    'Given a CLI logger with quiet logging, '
    'when a shared package writes an error to the global log, '
    'then it is suppressed.',
    () async {
      writer = TestLogWriter();
      initializeLoggerWith(ServerpodCliLogger(writer));
      log.logLevel = cli.LogLevel.nothing;

      await _logGlobally((log) => log.error('Suppress me.'));

      expect(writer.entries, isEmpty);
    },
  );

  group('Given a CLI logger has been closed,', () {
    setUp(() async {
      writer = TestLogWriter();
      initializeLoggerWith(ServerpodCliLogger(writer));
      await closeLogger();
    });

    test(
      'when a shared package writes to the global log, '
      'then the record is dropped.',
      () async {
        shared.log.warning('Nobody is listening.');
        await shared.log.flush();

        expect(writer.entries, isEmpty);
      },
    );

    test(
      'when observing the global log level, '
      'then the previous level is restored.',
      () {
        expect(shared.log.logLevel, LogLevel.info);
      },
    );
  });
}
