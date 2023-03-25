import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/command_runner.dart';
import 'package:serverpod_cli/src/util/internal_error.dart';

void main(List<String> args) async {
  var code = await runZonedGuarded(
    () async {
      try {
        var code = await CliCommandRunner().run(args);
        return code;
      } catch (error, stackTrace) {
        // Last resort error handling.
        printInternalError(error, stackTrace);
        return -1;
      }
    },
    (error, stackTrace) {
      printInternalError(error, stackTrace);
    },
  );
  await Future.wait([stdout.close(), stderr.close()]);
  exit(code ?? -1);
}
