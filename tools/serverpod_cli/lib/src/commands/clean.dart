import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/runner_options.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/status.dart'
    show resolveServerDirectory;
import 'package:serverpod_cli/src/runner/runner_lock.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Options for the `clean` command.
enum CleanOption<V> implements OptionDefinition<V> {
  directory<String>(clientDirectoryOption),
  ;

  const CleanOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// The `serverpod clean` command, which deletes the cached server build.
class CleanCommand extends ServerpodCommand<CleanOption> {
  @override
  final name = 'clean';

  @override
  final description =
      'Delete the cached server build so the next `serverpod start` '
      'recompiles from scratch.\n\n'
      'Only needed when `serverpod start` keeps reporting compilation errors '
      'that have already been fixed, even after restarting it.';

  CleanCommand() : super(options: CleanOption.values);

  @override
  Future<void> runWithConfig(Configuration<CleanOption> commandConfig) async {
    final serverDir = await resolveServerDirectory(
      commandConfig.optionalValue(CleanOption.directory),
    );

    final bool cleaned;
    try {
      cleaned = await cleanKernelCache(serverDir.path);
    } on FileSystemException catch (e) {
      log.error(
        'Could not delete ${e.path}. Stop `serverpod start` and try again.',
      );
      throw ExitException.error();
    }

    if (!cleaned) {
      log.info('Nothing to clean.');
      return;
    }

    log.info('Cleaned the cached server build.');
    if (await RunnerLock.isHeld(serverDir.path)) {
      log.info(
        'A runner is still running. Stop it with `serverpod runner stop`, '
        'then start again to rebuild.',
      );
    }
  }
}

/// Deletes the cached server kernel for [serverDir], and whether any existed.
///
/// The kernel's sidecar files all share its name as a prefix.
@visibleForTesting
Future<bool> cleanKernelCache(String serverDir) async {
  final toolDir = Directory(serverpodToolDirPath(serverDir));
  if (!await toolDir.exists()) return false;

  final kernelFiles = await toolDir
      .list()
      .where(
        (entity) =>
            entity is File && p.basename(entity.path).startsWith('server.dill'),
      )
      .toList();
  for (final file in kernelFiles) {
    await file.delete();
  }
  return kernelFiles.isNotEmpty;
}
