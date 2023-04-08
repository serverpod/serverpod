import 'dart:io';

void printInternalError(dynamic error, StackTrace stackTrace) {
  stderr.writeln(
    'Yikes! It is possible that this error is caused by an internal issue with '
    'the Serverpod tooling. We would appreciate if you filed an issue over at Github. Please include the stack trace below and describe any steps you did to trigger the error.',
  );
  stderr.writeln('https://github.com/serverpod/serverpod/issues');
  stderr.writeln(error);
  stderr.writeln(stackTrace);
  stderr.writeln('');
}
