import 'dart:io';

import 'package:super_string/super_string.dart';

void printww(String string) {
  if (stdout.hasTerminal) {
    var leadingWrap = string.startsWith('\n');
    var endingWrap = string.endsWith('\n');
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
