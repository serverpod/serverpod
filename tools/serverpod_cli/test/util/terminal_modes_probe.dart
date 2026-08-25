import 'dart:io';

import 'package:serverpod_cli/src/util/terminal_modes.dart';

/// Prints whether stdin supports terminal modes, for
/// `terminal_modes_test.dart`, which runs this with stdin on a pipe.
void main() {
  stdout.writeln(stdinSupportsTerminalModes);
}
