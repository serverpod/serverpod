import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Keeps `runner.json` in step with the runner it describes.
class RunnerManifestPublisher {
  RunnerManifestPublisher({
    required String serverDir,
    required RunnerManifest manifest,
    RunnerRegistry? registry,
  }) : _serverDir = serverDir,
       _manifest = manifest,
       _registry = registry ?? RunnerRegistry();

  final String _serverDir;
  final RunnerRegistry _registry;
  RunnerManifest _manifest;
  final List<StreamSubscription<void>> _subscriptions = [];
  bool _finished = false;

  /// The last queued write, which the next one chains onto.
  Future<void> _pending = Future.value();

  RunnerManifest get manifest => _manifest;

  /// Writes the first manifest and registers the runner in the registry.
  Future<void> publish() async {
    await _write();
    await _registry.register(_serverDir).catchError((Object e) {
      log.warning('Failed to register the runner: $e');
    });
  }

  /// Rewrites the manifest with [resolve] whenever [changes] fires.
  void republishOn(
    Stream<void> changes,
    RunnerManifest Function(RunnerManifest current) resolve,
  ) {
    _subscriptions.add(
      changes.listen((_) {
        _manifest = resolve(_manifest);
        unawaited(_write());
      }),
    );
  }

  Future<void> replace(RunnerManifest manifest) {
    _manifest = manifest;
    return _write();
  }

  /// Writes the final manifest with [exitCode] and unregisters the runner.
  ///
  /// The file stays, so a caller that polled too late still reads the outcome.
  Future<void> finish({required int exitCode}) async {
    await _stopRepublishing();
    _manifest = _manifest.copyWith(
      stage: RunnerStage.stopping,
      exitCode: exitCode,
    );
    await _write();
    _finished = true;
    await _unregister();
  }

  Future<void> _unregister() => _registry.unregister(_serverDir).catchError((
    Object e,
  ) {
    log.warning('Failed to remove the runner from the registry: $e');
  });

  Future<void> _stopRepublishing() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Queues a write of the manifest, logging a failure instead of throwing.
  ///
  /// A failure left in [_pending] would skip every later write.
  Future<void> _write() {
    if (_finished) return _pending;
    return _pending = _pending
        .then((_) => _manifest.writeTo(_serverDir))
        .catchError((Object e) {
          log.warning('Failed to write the runner manifest: $e');
        });
  }
}

/// The Docker Compose project name for [serverDir], as Compose derives it.
String composeProjectName(String serverDir) {
  final base = p.basename(p.canonicalize(serverDir)).toLowerCase();
  final kept = base.replaceAll(RegExp(r'[^a-z0-9_-]'), '');
  return kept.replaceFirst(RegExp(r'^[_-]+'), '');
}
