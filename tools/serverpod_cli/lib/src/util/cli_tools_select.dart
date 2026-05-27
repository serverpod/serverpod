import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/util/windows_console_input.dart';

export 'package:cli_tools/cli_tools.dart' show Option;

// TODO: This is a temporary solution to fix the issue with the logger. We
// should push this solution to `cli_tools` and use the `logger` parameter.

/// Prompts the user to select an option from a list of [options].
///
/// API-compatible with `package:cli_tools` `select()`, but redraws the prompt
/// in place using cursor movement + erase-below instead of full-screen clear.
Future<Option> select(
  final String prompt, {
  required final List<Option> options,
  required final Logger logger,
}) async {
  // Keep the cli_tools signature for drop-in compatibility, but we intentionally
  // do not use the passed logger because some logger adapters ignore write()
  // formatting flags and break the in-place redraw behavior.
  if (logger.logLevel == LogLevel.nothing) {
    // Intentionally ignored; keep signature-compatible with cli_tools `select`.
  }

  if (options.isEmpty) {
    throw ArgumentError('Options cannot be empty.');
  }

  var selectedIndex = 0;
  final lineCount = options.length + 3; // prompt + options + blank + hint
  final hasTerminalInput = stdin.hasTerminal;

  bool? originalEchoMode;
  bool? originalLineMode;
  int? originalWindowsConsoleMode;
  if (hasTerminalInput) {
    originalEchoMode = stdin.echoMode;
    originalLineMode = stdin.lineMode;
    stdin.echoMode = false;
    stdin.lineMode = false;
    if (Platform.isWindows) {
      // Windows Terminal/ConPTY delivers arrow keys as character-less key
      // events that readByteSync drops, so the ESC [ A / ESC [ B parsing below
      // never sees them. Enabling virtual-terminal input makes the cursor keys
      // arrive as those escape sequences, exactly as on POSIX terminals.
      originalWindowsConsoleMode = enableWindowsVirtualTerminalInput();
    }
  }

  try {
    await _renderState(
      selectedIndex: selectedIndex,
      options: options,
      promptMessage: prompt,
      lineCount: lineCount,
      redraw: false,
    );

    if (!hasTerminalInput) {
      stdout.writeln(
        'Interactive selection requires a terminal. '
        'Use --no-interactive or --directory.',
      );
      throw ExitException.error();
    }

    while (true) {
      final keyCode = stdin.readByteSync();

      final confirmSelection =
          keyCode == _KeyCodes.enterCR || keyCode == _KeyCodes.enterLF;
      if (confirmSelection) {
        return options[selectedIndex];
      }

      final quit = keyCode == _KeyCodes.q;
      if (quit) {
        throw ExitException.error();
      }

      // Navigation: arrow keys, plus j/k (vim-style) as aliases. The aliases
      // matter on terminals/sessions where the cursor keys don't reach stdin
      // as escape sequences. mason_logger uses the same j/k convention.
      int? step;
      if (keyCode == _KeyCodes.k) {
        step = -1;
      } else if (keyCode == _KeyCodes.j) {
        step = 1;
      } else if (keyCode == _KeyCodes.escapeSequenceStart) {
        if (stdin.readByteSync() == _KeyCodes.controlSequenceIntroducer) {
          final arrow = stdin.readByteSync();
          if (arrow == _KeyCodes.arrowUp) {
            step = -1;
          } else if (arrow == _KeyCodes.arrowDown) {
            step = 1;
          }
        }
      }

      if (step == null) continue;

      selectedIndex = (selectedIndex + step + options.length) % options.length;
      await _renderState(
        selectedIndex: selectedIndex,
        options: options,
        promptMessage: prompt,
        lineCount: lineCount,
        redraw: true,
      );
    }
  } finally {
    if (hasTerminalInput) {
      if (originalWindowsConsoleMode != null) {
        restoreWindowsConsoleInputMode(originalWindowsConsoleMode);
      }
      // Restore lineMode before echoMode: on Windows ENABLE_ECHO_INPUT is only
      // valid while ENABLE_LINE_INPUT is set, so re-enabling echo while line
      // mode is still off throws "Error setting terminal echo mode ... errno =
      // 87". Line-without-echo is a valid intermediate state on every platform.
      stdin.lineMode = originalLineMode!;
      stdin.echoMode = originalEchoMode!;
    }
  }
}

Future<void> _renderState({
  required int selectedIndex,
  required List<Option> options,
  required String promptMessage,
  required int lineCount,
  required bool redraw,
}) async {
  if (redraw) {
    stdout.write('\x1B[${lineCount}A\x1B[0J');
  }

  stdout.writeln(promptMessage);

  for (int i = 0; i < options.length; i++) {
    final radioButton = i == selectedIndex ? '(●)' : '(○)';
    final optionText = '$radioButton ${options[i].name}';

    stdout.writeln(i == selectedIndex ? _underline(optionText) : optionText);
  }

  stdout.writeln();
  stdout.writeln('Press [Enter] to confirm.');

  // Drain stdout to the terminal before the caller blocks on
  // stdin.readByteSync(). A synchronous read parks the isolate without
  // running the event loop, so anything still buffered in stdout never
  // reaches a Windows console — the menu renders blank even though key
  // input keeps working. The previous cli_tools-based path avoided this
  // by writing from the IsolatedLogWriter's still-spinning isolate.
  await stdout.flush();
}

abstract final class _KeyCodes {
  static const escapeSequenceStart = 27;
  static const controlSequenceIntroducer = 91;
  static const arrowUp = 65;
  static const arrowDown = 66;
  static const enterCR = 13;
  static const enterLF = 10;
  static const q = 113;
  static const j = 106;
  static const k = 107;
}

String _underline(final String text) => '\x1B[4m$text\x1B[0m';
