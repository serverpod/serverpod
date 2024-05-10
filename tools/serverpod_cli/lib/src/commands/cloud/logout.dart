import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class CloudLogoutCommand extends ServerpodCommand {
  @override
  final name = 'logout';

  @override
  final description = 'Log out from the Serverpod cloud.';

  @override
  void run() async {
    var cloudData = await resourceManager.tryFetchServerpodCloudData();

    if (cloudData == null) {
      log.info('You are not logged in to the Serverpod cloud.');
      return;
    }

    // TODO: Invalidate the token on the server.
    try {
      await resourceManager.removeServerpodCloudData();
    } catch (e, stackTrace) {
      log.error(
          'Failed to remove authentication information from disk. Please remove the file manually: $e',
          stackTrace: stackTrace);
      throw ExitException();
    }

    log.info('Successfully logged out from the Serverpod cloud.');
  }
}
