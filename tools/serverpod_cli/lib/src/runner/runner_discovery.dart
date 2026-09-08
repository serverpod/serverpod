import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_lock.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show connectUnixSocket, maxUnixSocketPathBytes, unixSocketPathFits;

/// What resolving a server package's runner found.
sealed class RunnerResolution {
  const RunnerResolution();
}

/// No runner is answering for this server package.
///
/// Either there was no manifest, or the one there named a socket that did not
/// answer.
final class NoRunner extends RunnerResolution {
  const NoRunner({this.staleManifest, this.lockHeld = false});

  /// The manifest left behind by a runner that is no longer answering, when
  /// there was one.
  ///
  /// A caller starting a runner overwrites it once [lockHeld] is false.
  final RunnerManifest? staleManifest;

  /// Whether the runner named by [staleManifest] still holds the project
  /// lock.
  ///
  /// A runner closes its sockets first and releases the lock last, after
  /// Docker. Held means a runner on its way out, or one too busy to answer
  /// the probe. Free means it is gone.
  final bool lockHeld;
}

/// A runner is listening and speaks a protocol this client understands.
final class LiveRunner extends RunnerResolution {
  const LiveRunner(
    this.manifest, {
    required this.tuiSocket,
    this.versionWarning,
  });

  final RunnerManifest manifest;

  /// The path this client reaches the attach socket by.
  final String tuiSocket;

  /// Set when the runner was built from a different CLI version at the same
  /// protocol version.
  ///
  /// Attaching is fine. The caller says this once.
  final String? versionWarning;
}

/// A runner is listening but speaks a protocol this client does not
/// understand.
///
/// A detached runner survives `dart pub global activate serverpod_cli`, so
/// this is expected rather than exceptional. There is no negotiation. The
/// client refuses and says how to replace the runner.
final class IncompatibleRunner extends RunnerResolution {
  const IncompatibleRunner(this.manifest);

  final RunnerManifest manifest;

  /// What to tell the user, naming both versions and the way out.
  String get message =>
      'A serverpod runner is already running for this project, but it speaks '
      'attach protocol version ${manifest.protocolVersion} while this CLI '
      'speaks ${RunnerManifest.currentProtocolVersion}. '
      'Stop it with `serverpod runner stop` and start it again to pick up this '
      'version of the CLI.';
}

/// Resolves the runner serving the server package at [serverDir].
///
/// Liveness is decided by connecting to the runner's socket, not by the
/// manifest existing. [probeTimeout] bounds that connect, so a socket file
/// whose owner is wedged does not hang the caller. Throws a [SocketException]
/// when the sockets are beyond reach, see [runnerSocketPath].
Future<RunnerResolution> resolveRunner(
  String serverDir, {
  Duration probeTimeout = const Duration(seconds: 1),
  RunnerRegistry? registry,
}) async {
  final manifest = await RunnerManifest.readFrom(serverDir);
  if (manifest == null) return const NoRunner();

  String socket(String name) => runnerSocketPath(
    serverDir,
    name,
    projectId: manifest.projectId,
    registry: registry,
  );
  final tuiSocket = socket(serverpodTuiSocketName);
  final mcpSocket = socket(serverpodMcpSocketName);

  var listening = false;
  for (final path in [tuiSocket, mcpSocket]) {
    if (await _isListening(path, probeTimeout)) {
      listening = true;
      break;
    }
  }
  if (!listening) {
    return NoRunner(
      staleManifest: manifest,
      // Not from inside the runner: on POSIX its own lock is re-entrant, and
      // the probe would release it.
      lockHeld: manifest.pid != pid && await RunnerLock.isHeld(serverDir),
    );
  }

  if (manifest.protocolVersion != RunnerManifest.currentProtocolVersion) {
    return IncompatibleRunner(manifest);
  }

  return LiveRunner(
    manifest,
    tuiSocket: tuiSocket,
    versionWarning: manifest.cliVersion == templateVersion
        ? null
        : 'The runner was started by serverpod_cli '
              '${manifest.cliVersion}, but this is $templateVersion. '
              'Restart it with `serverpod runner stop` to pick up this version.',
  );
}

/// The path a client reaches the runner's socket [name] for [serverDir] by.
///
/// The runner binds its sockets beside the manifest and the manifest does not
/// name them, so the path is derived from where the manifest was found. The
/// package's own path comes first: a client that shares the project mount but
/// not the home directory, such as a sandboxed agent, has nothing else. When
/// it does not fit the platform's socket address limit, the registry's link
/// for [projectId] is used instead. Throws a [SocketException] naming both
/// when neither fits.
String runnerSocketPath(
  String serverDir,
  String name, {
  required String projectId,
  RunnerRegistry? registry,
}) {
  final candidates = [
    p.join(serverpodToolDirPath(serverDir), name),
    if (projectId.isNotEmpty)
      p.join((registry ?? RunnerRegistry()).toolDirFor(projectId), name),
  ];
  for (final candidate in candidates) {
    if (unixSocketPathFits(candidate)) return candidate;
  }
  throw SocketException(
    'The runner socket for $serverDir is beyond reach: no path to it fits '
    'the ${maxUnixSocketPathBytes()} byte limit of a Unix socket address on '
    '${Platform.operatingSystem}. Tried ${candidates.join(' and ')}.',
  );
}

/// Whether something accepts a connection on the Unix socket at [path].
///
/// Says nothing before disconnecting. The runner counts a client as attached
/// only once it asks for the snapshot, so a silent probe is not a UI
/// arriving.
Future<bool> _isListening(String path, Duration timeout) async {
  try {
    final probe = await connectUnixSocket(path, timeout: timeout);
    probe.destroy();
    return true;
  } catch (_) {
    return false;
  }
}
