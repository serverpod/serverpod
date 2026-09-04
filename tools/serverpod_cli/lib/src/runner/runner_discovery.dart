import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show connectUnixSocket;

/// What resolving a server package's runner found.
sealed class RunnerResolution {
  const RunnerResolution();
}

/// No runner is serving this server package.
///
/// Either there was no manifest, or the one there named a socket that refuses
/// connections.
final class NoRunner extends RunnerResolution {
  const NoRunner({this.staleManifest});

  /// The manifest left behind by a runner that is no longer listening, when
  /// there was one.
  ///
  /// A caller starting a runner overwrites it.
  final RunnerManifest? staleManifest;
}

/// A runner is listening and speaks a protocol this client understands.
final class LiveRunner extends RunnerResolution {
  const LiveRunner(this.manifest, {this.versionWarning});

  final RunnerManifest manifest;

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
/// whose owner is wedged does not hang the caller.
Future<RunnerResolution> resolveRunner(
  String serverDir, {
  Duration probeTimeout = const Duration(seconds: 1),
}) async {
  final manifest = await RunnerManifest.readFrom(serverDir);
  if (manifest == null) return const NoRunner();

  final probePaths = [
    manifest.sockets.tui,
    manifest.sockets.mcp,
  ].where((path) => path.isNotEmpty);

  var listening = false;
  for (final path in probePaths) {
    if (await _isListening(path, probeTimeout)) {
      listening = true;
      break;
    }
  }
  if (!listening) return NoRunner(staleManifest: manifest);

  if (manifest.protocolVersion != RunnerManifest.currentProtocolVersion) {
    return IncompatibleRunner(manifest);
  }

  return LiveRunner(
    manifest,
    versionWarning: manifest.cliVersion == templateVersion
        ? null
        : 'The running runner was started by serverpod_cli '
              '${manifest.cliVersion}, but this is $templateVersion. '
              'Restart it with `serverpod runner stop` to pick up this version.',
  );
}

/// Whether something accepts a connection on the Unix socket at [path].
///
/// Says nothing before disconnecting. The runner counts a client as attached
/// only once it asks for the snapshot, so a silent probe is not a UI
/// arriving.
Future<bool> _isListening(String path, Duration timeout) async {
  if (path.isEmpty) return false;
  try {
    final probe = await connectUnixSocket(path, timeout: timeout);
    probe.destroy();
    return true;
  } catch (_) {
    return false;
  }
}
