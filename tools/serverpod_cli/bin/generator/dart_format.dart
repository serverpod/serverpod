import 'dart:io';

import 'config.dart';

void performDartFormat(bool verbose) {
  ProcessResult result = Process.runSync(
    'dart',
    <String>['format', '.'],
    workingDirectory: config.generatedClientProtocolPath,
  );
  if (verbose) {
    print(result.stdout);
    print(result.stderr);
  }

  result = Process.runSync(
    'dart',
    <String>['format', '.'],
    workingDirectory: config.generatedServerProtocolPath,
  );

  if (verbose) {
    print(result.stdout);
    print(result.stderr);
  }
}
