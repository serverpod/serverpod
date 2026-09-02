import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart' show LocalStorageManager;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:uuid/uuid.dart';

/// The directory every runner on this machine leaves a pointer in, so a
/// client that was not started inside the server package can still find it.
///
/// Lives under the user's home rather than the system temp directory: it is
/// the directory the CLI already owns, it is per user on every platform
/// without any permission handling, and a desktop client knows where home is
/// as well as the CLI does. Set `SERVERPOD_RUNNER_REGISTRY_DIR` to move it,
/// for a CI job or a test that must not touch the real one.
String serverpodRunnerRegistryDirPath() {
  final override = Platform.environment['SERVERPOD_RUNNER_REGISTRY_DIR'];
  if (override != null && override.isNotEmpty) return override;
  return p.join(
    LocalStorageManager.homeDirectory.path,
    '.serverpod',
    'runners',
  );
}

/// A runner the registry knows about and that answered a probe.
class RegisteredRunner {
  const RegisteredRunner({required this.serverDir, required this.resolution});

  /// The server package the runner serves, canonical.
  final String serverDir;

  /// What resolving it found: live, or live but speaking another protocol.
  final RunnerResolution resolution;
}

/// Pointers from a per-user directory to the server packages with a runner.
///
/// Each entry is a small JSON file naming one server directory and nothing
/// else. A reader resolves the runner through `resolveRunner`, exactly as a
/// client started inside the package does, so the manifest stays the one
/// place addresses are read from and a stale pointer cannot steer a client at
/// a dead socket. Entries a crashed runner left behind are pruned by whoever
/// scans next, since the same probe already says which ones are dead.
class RunnerRegistry {
  RunnerRegistry({Directory? dir})
    : dir = dir ?? defaultDir ?? Directory(serverpodRunnerRegistryDirPath());

  final Directory dir;

  /// Where a registry built without a [dir] lives, in place of the per-user
  /// directory. For a test that runs a runner in-process and must not touch
  /// the real one.
  @visibleForTesting
  static Directory? defaultDir;

  static const _entryNamespace = 'e3d5a8b2-4f6c-4d1e-9b7a-2c8f0e1d3a5b';

  /// The entry file for [serverDir], named by a stable hash of its canonical
  /// path so registering twice overwrites rather than duplicates.
  File entryFor(String serverDir) => File(
    p.join(
      dir.path,
      '${const Uuid().v5(_entryNamespace, _canonical(serverDir))}.json',
    ),
  );

  /// Records that a runner serves [serverDir].
  Future<void> register(String serverDir) async {
    await dir.create(recursive: true);
    await entryFor(serverDir).writeAsString(
      jsonEncode({'serverDir': _canonical(serverDir)}),
    );
  }

  /// Forgets [serverDir]; a missing entry is fine.
  Future<void> unregister(String serverDir) async {
    try {
      await entryFor(serverDir).delete();
    } on FileSystemException {
      // Already gone, which is the state asked for.
    }
  }

  /// The server directories with an entry, whether or not their runner is
  /// still alive. Unreadable entries are skipped.
  Future<List<String>> serverDirs() async {
    if (!await dir.exists()) return const [];
    final dirs = <String>[];
    await for (final entity in dir.list()) {
      if (entity is! File || !entity.path.endsWith('.json')) continue;
      try {
        final decoded = jsonDecode(await entity.readAsString());
        if (decoded case {'serverDir': final String serverDir}) {
          dirs.add(serverDir);
        }
      } catch (_) {}
    }
    dirs.sort();
    return dirs;
  }

  /// Resolves every entry, removes the ones whose runner is gone, and returns
  /// the rest.
  Future<List<RegisteredRunner>> scan({
    Duration probeTimeout = const Duration(seconds: 1),
  }) async {
    final found = <RegisteredRunner>[];
    for (final serverDir in await serverDirs()) {
      final resolution = await resolveRunner(
        serverDir,
        probeTimeout: probeTimeout,
      );
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
