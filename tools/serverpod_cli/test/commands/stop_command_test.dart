import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/commands/stop.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show FileEx;
import 'package:test/test.dart';

import '../test_util/hold_lock.dart';

void main() {
  group('Given a manifest a runner left behind at stopping,', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('sct');
      await RunnerManifest(
        pid: 424242,
        stage: RunnerStage.stopping,
        projectId: RunnerRegistry.idFor(tempDir.path),
        config: const RunnerConfig(watch: true, flutter: true, serverArgs: []),
      ).writeTo(tempDir.path);
    });

    tearDown(() => tempDir.deleteBestEffort(recursive: true));

    test(
      'when its process no longer holds the lock, '
      'then the wait for its shutdown ends at once and leaves the manifest',
      () async {
        expect(await awaitRunnerShutdown(tempDir.path), isTrue);

        expect(await RunnerManifest.readFrom(tempDir.path), isNotNull);
      },
    );

    test(
      'when its process still holds the lock, '
      'then the wait goes on until the lock is released',
      () async {
        final holder = await holdLockFromAnotherProcess(tempDir.path);
        final down = awaitRunnerShutdown(tempDir.path);
        var settled = false;
        unawaited(down.whenComplete(() => settled = true));

        await Future<void>.delayed(const Duration(milliseconds: 500));
        expect(settled, isFalse);
        expect(await RunnerManifest.readFrom(tempDir.path), isNotNull);

        holder.kill();
        expect(await down, isTrue);
      },
    );
  });
}
