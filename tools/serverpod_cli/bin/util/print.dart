import 'dart:io';

import 'package:super_string/super_string.dart';

/// Print to terminal with word wrap.
void printww(String string) {
  if (stdout.hasTerminal) {
    bool leadingWrap = string.startsWith('\n');
    bool endingWrap = string.endsWith('\n');
    string = string.wordWrap(width: stdout.terminalColumns);

    if (leadingWrap && !string.startsWith('\n')) {
      string = '\n$string';
    }
    if (endingWrap && !string.endsWith('\n')) {
      string = '$string\n';
    }
  }
  stdout.writeln(string);
}
