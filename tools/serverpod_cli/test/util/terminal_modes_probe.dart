import 'dart:io';

import 'package:serverpod_cli/src/util/terminal_modes.dart';

/// Prints [stdinSupportsTerminalModes] for `terminal_modes_test.dart`.
void main() {
  stdout.writeln(stdinSupportsTerminalModes);
}
