import 'dart:io';

import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/print.dart';

class StdOutLogger extends Logger {
  @override
  void printBox(String message) {
    // TODO: Implement a pretty box print for stdout
    printww(message);
  }

  @override
  void printDebug(String message) {
    printww('DEBUG: $message');
  }

  @override
  void printError(String message, {StackTrace? stackTrace}) {
    stderr.write('ERROR: $message');
    if (stackTrace != null) {
      stderr.write(stackTrace);
    }
  }

  @override
  void printInfo(String message) {
    printww(message);
  }

  @override
  void printWarning(String message) {
    stderr.write('WARNING: $message');
  }

  @override
  Future<void> flush() async {
    await stderr.flush();
    await stdout.flush();
  }
}
