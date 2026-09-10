import 'dart:io';

import 'package:cli_tools/cli_tools.dart' show ExitException;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/status.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_logging_cli/serverpod_logging_cli.dart';
import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

import '../test_util/wait_for.dart';

void main() {
  group('Given a runner whose sockets no path fits,', () {
    late Directory root;
    late String serverDir;
    late TestLogWriter writer;

    setUp(() async {
      root = await Directory.systemTemp.createTemp('far');
      // Too deep for a socket address via the package or a registry link.
      serverDir = p.joinAll([root.path, ...List.filled(12, 'deeper_still')]);
      await Directory(serverDir).create(recursive: true);
      RunnerRegistry.defaultDir = Directory(p.join(serverDir, 'registry'));
      await RunnerManifest(
        pid: 4242,
        projectId: RunnerRegistry.idFor(serverDir),
        config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
      ).writeTo(serverDir);
      writer = TestLogWriter();
      initializeLoggerWith(ServerpodCliLogger(writer));
      addTearDown(closeLogger);
    });

    tearDown(() async {
      RunnerRegistry.defaultDir = null;
      try {
        root.deleteSync(recursive: true);
      } catch (_) {}
    });

    test(
      'when a client command resolves it, '
      'then it leaves with the paths it tried rather than an internal error',
      () async {
        await expectLater(
          resolveRunnerOrExit(serverDir),
          throwsA(isA<ExitException>()),
        );

        await waitFor(() => writer.entries.isNotEmpty);
        final error = writer.entries.single;
        expect(error.level, LogLevel.error);
        expect(error.message, contains('beyond reach'));
        expect(error.message, contains('tui.sock'));
      },
      skip: Platform.isWindows ? 'Unix socket addresses' : null,
    );
  });
}
