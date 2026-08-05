import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

void printInternalError(dynamic error, StackTrace stackTrace) {
  log.error(
    formatInternalErrorMessage(error),
    stackTrace: stackTrace,
  );
}
