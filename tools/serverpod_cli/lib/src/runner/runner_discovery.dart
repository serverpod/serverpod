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
final class NoRunner extends RunnerResolution {
  const NoRunner({this.staleManifest, this.lockHeld = false});

  /// The manifest whose sockets did not answer, safe to delete once unlocked.
  final RunnerManifest? staleManifest;

  /// Whether the lock is held by a runner stopping or too busy to answer.
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

  /// The path by which this client reaches the attach socket.
  final String tuiSocket;

  /// A warning when a different CLI version started the runner.
  final String? versionWarning;
}

/// A runner is listening but speaks another protocol, so the client refuses.
final class IncompatibleRunner extends RunnerResolution {
  const IncompatibleRunner(this.manifest);

  final RunnerManifest manifest;

  String get message =>
      'A serverpod runner is already running for this project, but it speaks '
      'attach protocol version ${manifest.protocolVersion} while this CLI '
      'speaks ${RunnerManifest.currentProtocolVersion}. '
      'Stop it with `serverpod runner stop` and start it again to pick up this '
      'version of the CLI.';
}

/// Resolves the runner serving the server package at [serverDir].
///
/// A socket connection decides liveness, since a crash leaves the manifest.
/// Throws a [SocketException] when no socket path fits the address limit.
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
      // In the runner itself, the probe would drop its own POSIX lock.
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

/// The path by which a client reaches the runner socket [name].
///
/// Prefers the package path, which a sandboxed client without home can use,
/// over the registry link. Throws a [SocketException] when neither fits.
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

/// Whether [path] accepts a connection, probed silently so no UI attaches.
Future<bool> _isListening(String path, Duration timeout) async {
  try {
    final probe = await connectUnixSocket(path, timeout: timeout);
    probe.destroy();
    return true;
  } catch (_) {
    return false;
  }
}
