import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Keeps `runner.json` in step with the runner it describes.
///
/// Writes it as soon as the runner can be reached, rewrites it as the stage
/// moves or a published address changes, and removes it on graceful shutdown.
/// A crash skips the removal.
class RunnerManifestPublisher {
  RunnerManifestPublisher({
    required String serverDir,
    required RunnerManifest manifest,
  }) : _serverDir = serverDir,
       _manifest = manifest;

  final String _serverDir;
  RunnerManifest _manifest;
  final List<StreamSubscription<void>> _subscriptions = [];

  /// Serializes writes so a burst of address changes cannot interleave two
  /// encodings into one file.
  Future<void> _pending = Future.value();

  /// The manifest as last published.
  RunnerManifest get manifest => _manifest;

  /// Writes the manifest for the first time.
  Future<void> publish() => _write();

  /// Rewrites the manifest whenever [changes] fires, reading current values
  /// through [resolve].
  ///
  /// Takes a whole-manifest update rather than a URI, since
  /// [RunnerManifest.vmService] is not the only thing that can change. Several
  /// sources may be wired, and each [resolve] sees the manifest as the
  /// previous one left it.
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

  /// Writes [last] as the final manifest and stops republishing, leaving the
  /// file behind.
  ///
  /// For a start that aborts. The caller that spawned this runner polls for
  /// the manifest, and one that came and went between two polls would read as
  /// a runner that never came up. Left at [RunnerStage.stopping] with the exit
  /// code, it reads as what happened.
  Future<void> leaveBehind(RunnerManifest last) async {
    await _stopRepublishing();
    _manifest = last;
    await _write();
  }

  /// Replaces the published manifest, e.g. when the pod reports the addresses
  /// its listeners resolved to.
  Future<void> replace(RunnerManifest manifest) {
    _manifest = manifest;
    return _write();
  }

  /// Stops republishing and removes the manifest.
  Future<void> dispose() async {
    await _stopRepublishing();
    await _pending;
    await RunnerManifest.deleteFrom(_serverDir);
  }

  Future<void> _stopRepublishing() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Writes the manifest, keeping a failure to itself.
  ///
  /// A failed write, from the tool directory being removed under a running
  /// runner, would otherwise leave `_pending` permanently failed. Every later
  /// write would then be skipped, and [dispose] would rethrow into a teardown
  /// that still has Docker services and the lock to release.
  Future<void> _write() {
    return _pending = _pending
        .then((_) => _manifest.writeTo(_serverDir))
        .catchError((Object e) {
          log.warning('Failed to write the runner manifest: $e');
        });
  }
}

/// The Docker Compose project name for a stack rooted at [serverDir].
///
/// Mirrors Compose's own default: the base name of the directory it runs in,
/// lowercased, with everything outside `[a-z0-9_-]` dropped and leading
/// separators trimmed. Recorded in the manifest so `serverpod runner status`
/// can name the project for `docker compose -p`.
String composeProjectName(String serverDir) {
  final base = p.basename(p.canonicalize(serverDir)).toLowerCase();
  final kept = base.replaceAll(RegExp(r'[^a-z0-9_-]'), '');
  return kept.replaceFirst(RegExp(r'^[_-]+'), '');
}
