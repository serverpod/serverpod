import 'dart:io';

import 'package:cli_tools/cli_tools.dart';

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
  if (hasTerminalInput) {
    originalEchoMode = stdin.echoMode;
    originalLineMode = stdin.lineMode;
    stdin.echoMode = false;
    stdin.lineMode = false;
  }

  try {
    _renderState(
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

      if (keyCode == _KeyCodes.escapeSequenceStart) {
        var nextByte = stdin.readByteSync();
        if (nextByte == _KeyCodes.controlSequenceIntroducer) {
          nextByte = stdin.readByteSync();
          if (nextByte == _KeyCodes.arrowUp) {
            selectedIndex =
                (selectedIndex - 1 + options.length) % options.length;
          } else if (nextByte == _KeyCodes.arrowDown) {
            selectedIndex = (selectedIndex + 1) % options.length;
          } else {
            continue;
          }

          _renderState(
            selectedIndex: selectedIndex,
            options: options,
            promptMessage: prompt,
            lineCount: lineCount,
            redraw: true,
          );
        }
      }
    }
  } finally {
    if (hasTerminalInput) {
      stdin.echoMode = originalEchoMode!;
      stdin.lineMode = originalLineMode!;
    }
  }
}

void _renderState({
  required int selectedIndex,
  required List<Option> options,
  required String promptMessage,
  required int lineCount,
  required bool redraw,
}) {
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
}

abstract final class _KeyCodes {
  static const escapeSequenceStart = 27;
  static const controlSequenceIntroducer = 91;
  static const arrowUp = 65;
  static const arrowDown = 66;
  static const enterCR = 13;
  static const enterLF = 10;
  static const q = 113;
}

String _underline(final String text) => '\x1B[4m$text\x1B[0m';
