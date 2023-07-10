import 'package:serverpod_cli/src/logger/logger.dart';

void printInternalError(dynamic error, StackTrace stackTrace) {
  logger.printError(
      'Yikes! It is possible that this error is caused by an'
      ' internal issue with the Serverpod tooling. We would appreciate if you '
      'filed an issue over at Github. Please include the stack trace below and '
      'describe any steps you did to trigger the error.'
      '''

https://github.com/serverpod/serverpod/issues

$error
''',
      stackTrace: stackTrace);
}
