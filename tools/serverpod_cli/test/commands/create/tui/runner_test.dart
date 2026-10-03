import 'dart:io';

import 'package:ci/ci.dart' as ci;
import 'package:serverpod_cli/src/commands/create/tui/runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log_io.dart' show LogLevel, TestLogWriter;
import 'package:test/test.dart';

import '../../../test_util/mock_std.dart';

class _TerminalStdin extends MockStdin {
  @override
  bool get hasTerminal => true;

  @override
  bool get echoMode => true;
}

/// Stdin that cannot report the terminal modes the TUI has to capture.
///
/// Reading `echoMode` is what actually decides whether the TUI can start, and
/// it throws on a redirected stdin. `hasTerminal` is deliberately left true
/// here to mirror `< /dev/null`, which Dart reports as a terminal because it
/// classifies every character device as one.
class _NonTerminalStdin extends MockStdin {
  @override
  bool get hasTerminal => true;

  @override
  bool get echoMode =>
      throw const StdinException('Error getting terminal echo mode');
}

class _TerminalStdout extends MockStdout {
  @override
  bool get hasTerminal => true;
}

/// Runs [body] with `stdin` and `stdout` reporting the given terminal state.
T _withTerminals<T>(
  T Function() body, {
  required bool stdin,
  required bool stdout,
}) {
  return IOOverrides.runZoned(
    body,
    stdin: () => stdin ? _TerminalStdin() : _NonTerminalStdin(),
    stdout: () => stdout ? _TerminalStdout() : MockStdout(),
  );
}

void main() {
  late TestLogWriter writer;

  setUp(() {
    writer = TestLogWriter();
    initializeLoggerWith(ServerpodCliLogger(writer));
  });

  tearDown(closeLogger);

  test(
    'Given only stdin is attached to a terminal, '
    'when calling shouldUseCreateTui with interactive set to null, '
    'then it returns false.',
    () {
      final useTui = _withTerminals(
        () => shouldUseCreateTui(null),
        stdin: true,
        stdout: false,
      );

      expect(useTui, isFalse);
    },
  );

  test(
    'Given only stdout is attached to a terminal, '
    'when calling shouldUseCreateTui with interactive set to null, '
    'then it returns false.',
    () {
      final useTui = _withTerminals(
        () => shouldUseCreateTui(null),
        stdin: false,
        stdout: true,
      );

      expect(useTui, isFalse);
    },
  );

  group('Given stdin and stdout are both attached to a terminal,', () {
    test(
      'when calling shouldUseCreateTui with interactive set to null, '
      'then it returns true unless in CI.',
      () {
        final useTui = _withTerminals(
          () => shouldUseCreateTui(null),
          stdin: true,
          stdout: true,
        );

        expect(useTui, equals(!ci.isCI));
      },
    );

    test(
      'when calling shouldUseCreateTui with interactive set to true, '
      'then it returns true unless in CI.',
      () {
        final useTui = _withTerminals(
          () => shouldUseCreateTui(true),
          stdin: true,
          stdout: true,
        );

        expect(useTui, equals(!ci.isCI));
      },
    );

    test(
      'when calling shouldUseCreateTui with interactive set to false, '
      'then it returns false.',
      () {
        final useTui = _withTerminals(
          () => shouldUseCreateTui(false),
          stdin: true,
          stdout: true,
        );

        expect(useTui, isFalse);
      },
    );
  });

  group('Given stdin and stdout are both not attached to a terminal,', () {
    test(
      'when calling shouldUseCreateTui with interactive set to null, '
      'then it returns false.',
      () {
        final useTui = _withTerminals(
          () => shouldUseCreateTui(null),
          stdin: false,
          stdout: false,
        );

        expect(useTui, isFalse);
      },
    );

    test(
      'when calling shouldUseCreateTui with interactive set to true, '
      'then it logs a warning and returns false.',
      () async {
        final useTui = _withTerminals(
          () => shouldUseCreateTui(true),
          stdin: false,
          stdout: false,
        );

        await log.flush();

        expect(useTui, isFalse);
        expect(writer.entries, hasLength(1));
        expect(writer.entries.single.level, LogLevel.warning);
        expect(
          writer.entries.single.message,
          contains('Interactive mode was requested'),
        );
      },
    );

    test(
      'when calling shouldUseCreateTui with interactive set to false, '
      'then it returns false.',
      () {
        final useTui = _withTerminals(
          () => shouldUseCreateTui(false),
          stdin: false,
          stdout: false,
        );

        expect(useTui, isFalse);
      },
    );
  });
}
