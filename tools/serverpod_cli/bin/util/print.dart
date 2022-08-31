import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:super_string/super_string.dart';

/// Private print function to terminal with word wrap.
void _printww(String string) {
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

/// Print to terminal with word wrap.
void printww(String string) => _printww(string);

/// Print to terminal with a new line.
void printwwln(String string) {
  printww(string);
  printww('');
}

/// Print to terminal as warning in yellow color.
void printWarning(String string) => printww('${Colorize(string).yellow()}');

/// Print to terminal as warning in yellow color with a new line.
void printWarningln(String string) => printwwln('${Colorize(string).yellow()}');

/// Print to terminal as error in red color.
void printError(String string) => printww('${Colorize(string).red()}');

/// Print to terminal as error in red color with a new line.
void printErrorln(String string) => printwwln('${Colorize(string).red()}');
