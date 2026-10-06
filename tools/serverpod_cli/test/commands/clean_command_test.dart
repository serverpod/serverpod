import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/clean.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show FileEx;
import 'package:test/test.dart';

void main() {
  late Directory serverDir;
  late Directory toolDir;

  setUp(() async {
    serverDir = await Directory.systemTemp.createTemp('clean');
    toolDir = Directory(serverpodToolDirPath(serverDir.path));
  });

  tearDown(() => serverDir.deleteBestEffort(recursive: true));

  test(
    'Given a server directory with a cached kernel and a runner manifest, '
    'when cleaning the kernel cache, '
    'then only the kernel files are deleted.',
    () async {
      await toolDir.create(recursive: true);
      for (final name in [
        'server.dill',
        'server.dill.incremental.dill',
        'server.dill.compiling',
        'server.dill.entrypoint',
        'runner.json',
      ]) {
        await File(p.join(toolDir.path, name)).create();
      }

      final cleaned = await cleanKernelCache(serverDir.path);

      expect(cleaned, isTrue);
      expect(
        toolDir.listSync().map((entity) => p.basename(entity.path)),
        ['runner.json'],
      );
    },
  );

  test(
    'Given a server directory without a cached kernel, '
    'when cleaning the kernel cache, '
    'then nothing is reported as cleaned.',
    () async {
      final cleaned = await cleanKernelCache(serverDir.path);

      expect(cleaned, isFalse);
    },
  );
}
