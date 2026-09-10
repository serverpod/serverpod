import 'dart:io';

import 'package:cli_tools/cli_tools.dart' show LocalStorageManager;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show FileEx;
import 'package:uuid/uuid.dart';

/// The per-user registry directory, or `SERVERPOD_RUNNER_REGISTRY_DIR` if set.
String serverpodRunnerRegistryDirPath() {
  final override = Platform.environment['SERVERPOD_RUNNER_REGISTRY_DIR'];
  if (override != null && override.isNotEmpty) return override;
  return p.join(
    LocalStorageManager.homeDirectory.path,
    '.serverpod',
    'runners',
  );
}

/// A registry entry whose runner answered a probe or still holds its lock.
class RegisteredRunner {
  const RegisteredRunner({required this.serverDir, required this.resolution});

  /// The canonical path of the server package the runner serves.
  final String serverDir;

  /// What [resolveRunner] found, never a [NoRunner] with a free lock.
  final RunnerResolution resolution;
}

/// Per-user links to the tool directory of every package with a runner.
///
/// Readers resolve each entry through [resolveRunner]. A link also gives
/// clients a path to the sockets short enough for a socket address.
class RunnerRegistry {
  RunnerRegistry({Directory? dir})
    : dir = dir ?? defaultDir ?? Directory(serverpodRunnerRegistryDirPath());

  final Directory dir;

  /// The directory to use instead of the per-user one, for tests.
  @visibleForTesting
  static Directory? defaultDir;

  static const _entryNamespace = 'e3d5a8b2-4f6c-4d1e-9b7a-2c8f0e1d3a5b';

  /// The registry's name for [serverDir], a UUID v5 of its canonical path.
  static String idFor(String serverDir) =>
      const Uuid().v5(_entryNamespace, _canonical(serverDir));

  Link linkFor(String serverDir) => Link(toolDirFor(idFor(serverDir)));

  /// The path of the link for the package with [projectId].
  String toolDirFor(String projectId) => p.join(dir.path, projectId);

  /// Records that a runner serves [serverDir].
  Future<void> register(String serverDir) async {
    await dir.create(recursive: true);
    final link = linkFor(serverDir);
    final target = serverpodToolDirPath(_canonical(serverDir));
    try {
      await link.create(target);
    } on FileSystemException {
      await link.update(target);
    }
  }

  /// Removes the link for [serverDir], if there is one.
  Future<void> unregister(String serverDir) =>
      linkFor(serverDir).deleteIfExists();

  /// The server directories with a link, live runner or not.
  Future<List<String>> serverDirs() async {
    if (!await dir.exists()) return const [];
    final dirs = <String>[];
    await for (final entity in dir.list(followLinks: false)) {
      if (entity is! Link) continue;
      try {
        dirs.add(p.dirname(p.dirname(await entity.target())));
      } on FileSystemException {
        // Removed between listing and reading.
      }
    }
    dirs.sort();
    return dirs;
  }

  /// Resolves every entry, pruning dead ones, and returns those that resolved.
  Future<List<RegisteredRunner>> scan({
    Duration probeTimeout = const Duration(seconds: 1),
  }) async {
    final found = <RegisteredRunner>[];
    for (final serverDir in await serverDirs()) {
      final RunnerResolution resolution;
      try {
        resolution = await resolveRunner(
          serverDir,
          probeTimeout: probeTimeout,
          registry: this,
        );
      } on SocketException {
        // No socket path fits, so the runner may still be alive.
        continue;
      }
      if (resolution case NoRunner(lockHeld: false)) {
        await unregister(serverDir);
        continue;
      }
      found.add(RegisteredRunner(serverDir: serverDir, resolution: resolution));
    }
    return found;
  }

  static String _canonical(String serverDir) => p.canonicalize(serverDir);
}
