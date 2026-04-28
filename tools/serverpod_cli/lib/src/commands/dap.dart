import 'dart:async';
import 'dart:io';

import 'package:config/config.dart';
import 'package:dds/dap.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/dap/serverpod_debug_adapter.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/file_ex.dart';
import 'package:serverpod_cli/src/util/platform_check.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';

/// Options for the `dap` command.
enum DapOption<V> implements OptionDefinition<V> {
  ipv6(
    FlagOption(
      argName: 'ipv6',
      defaultsTo: false,
      negatable: false,
      helpText: 'Whether to bind DAP/VM Service connections to IPv6 addresses.',
    ),
  )
  ;

  const DapOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// `serverpod dap` - runs a Debug Adapter Protocol server.
///
/// Picks a transport at startup and announces it on stderr so the launching
/// extension knows how to connect:
///
/// - When [hasUnixSocketSupport] holds (macOS / Linux always; Windows on
///   Dart 3.11+) and the server package can be discovered, binds a Unix
///   domain socket at `<systemTemp>/serverpod-dap-<hash>.sock` (hashed by
///   the absolute server-dir path so projects don't collide) and announces
///   `SERVERPOD_DAP_SOCKET=<path>`. The extension connects via VS Code's
///   `DebugAdapterNamedPipeServer`.
/// - Otherwise announces `SERVERPOD_DAP_STDIO` and speaks DAP on
///   stdin/stdout. The extension drops its monitoring spawn and returns
///   `DebugAdapterExecutable` so VS Code respawns the CLI with its own
///   stdio framing.
///
/// UDS is preferred over TCP because TCP loopback is reachable by every
/// local process, while UDS access is restricted by file permissions
/// (default umask 022 makes the socket 0644 = owner-only-connect, since
/// UDS `connect()` needs write permission).
///
/// Hidden because end users invoke it via launch.json, not directly.
class DapCommand extends ServerpodCommand<DapOption> {
  static const String commandName = 'dap';

  /// Marker prefix written to stderr when UDS is the chosen transport. The
  /// full line is `SERVERPOD_DAP_SOCKET=<absolute-path>`. The literal is
  /// also matched on the extension side; if you change it here, update
  /// `tools/serverpod_vscode_extension/src/debug.ts` to match.
  static const String socketAnnouncement = 'SERVERPOD_DAP_SOCKET';

  /// Marker line written to stderr when stdio is the chosen transport. The
  /// extension responds by killing this process and returning
  /// `DebugAdapterExecutable` so VS Code respawns with managed stdio
  /// framing.
  static const String stdioAnnouncement = 'SERVERPOD_DAP_STDIO';

  @override
  final name = commandName;

  @override
  bool get hidden => true;

  @override
  final description =
      'Start a Debug Adapter Protocol server for serverpod, intended to be '
      'launched by an editor as the debug adapter for `type: "serverpod"`.';

  DapCommand() : super(options: DapOption.values);

  @override
  Future<void> runWithConfig(Configuration<DapOption> commandConfig) async {
    final ipv6 = commandConfig.value(DapOption.ipv6);

    if (await _tryRunOverUnixSocket(ipv6: ipv6)) return;
    await _runOverStdio(ipv6: ipv6);
  }

  /// Attempts UDS transport. Returns `true` if the session ran on UDS;
  /// `false` if UDS isn't available on this platform, the server package
  /// could not be discovered, or the bind itself failed - the caller
  /// should fall back to stdio.
  Future<bool> _tryRunOverUnixSocket({required bool ipv6}) async {
    if (!hasUnixSocketSupport()) return false;

    final Directory serverDir;
    try {
      serverDir = await ServerDirectoryFinder.findOrPrompt(interactive: false);
    } on Object {
      return false;
    }

    // Socket lives in systemTemp, not under the server's .dart_tool/, because
    // macOS limits sockaddr_un.sun_path to 104 bytes (incl. NUL): a typical
    // <home>/Projects/.../<name>_server/.dart_tool/serverpod/dap.sock easily
    // exceeds that. bindUnixSocket's shortestPath helper makes our bind side
    // fit by going relative, but the announcement (and VS Code's connect on
    // it) is absolute - which hits the limit on the client. systemTemp gives
    // a short, predictable base on every platform. It is also already a
    // per-user directory on macOS (0700) and Windows (per-user ACL); on Linux
    // /tmp is world-traversable but the socket file inherits umask 022 -> 0644
    // which denies connect to non-owners (UDS connect needs write).
    final hash = serverDir.absolute.path.hashCode
        .toUnsigned(32)
        .toRadixString(36);
    final socketPath = p.join(
      Directory.systemTemp.path,
      'serverpod-dap-$hash.sock',
    );

    final ServerSocket server;
    try {
      server = await bindUnixSocket(socketPath);
    } on Object {
      return false;
    }

    // Subscribe before announcing so a fast SIGTERM between announce and
    // the first await still cleans up the socket file.
    final signalSubs = _registerSignalCleanup(socketPath);

    stderr.writeln('$socketAnnouncement=$socketPath');
    await stderr.flush();

    try {
      // The launcher opens exactly one connection per debug session.
      final socket = await server.first;
      await server.close();

      // Socket is Stream<Uint8List>; ByteStreamServerChannel's transformer
      // expects Stream<List<int>>. The cast adapts the runtime stream type
      // (Uint8List IS-A List<int>, but transformers are contravariant in
      // the input parameter so the static types don't unify).
      final channel = ByteStreamServerChannel(
        socket.cast<List<int>>(),
        socket,
        null,
      );
      ServerpodDebugAdapter(channel, ipv6: ipv6, onError: _onProtocolError);

      await channel.closed;
      await socket.close();
    } finally {
      for (final sub in signalSubs) {
        await sub.cancel();
      }
      await File(socketPath).deleteIfExists();
    }
    return true;
  }

  Future<void> _runOverStdio({required bool ipv6}) async {
    stderr.writeln(stdioAnnouncement);
    await stderr.flush();

    // The non-blocking sink can fail mid-flush when the editor disconnects;
    // the failure is benign at shutdown. Match `dart debug_adapter`'s
    // behaviour and swallow it explicitly.
    unawaited(stdout.nonBlocking.done.catchError((Object _) {}));

    final channel = ByteStreamServerChannel(stdin, stdout.nonBlocking, null);
    ServerpodDebugAdapter(channel, ipv6: ipv6, onError: _onProtocolError);

    await channel.closed;
  }

  /// Registers SIGTERM/SIGINT handlers that unlink [socketPath] before
  /// exiting. Skips signals that aren't deliverable on the current
  /// platform (SIGTERM on Windows).
  List<StreamSubscription<ProcessSignal>> _registerSignalCleanup(
    String socketPath,
  ) {
    final subs = <StreamSubscription<ProcessSignal>>[];
    void handle(ProcessSignal sig) {
      try {
        File(socketPath).deleteSync();
      } on FileSystemException catch (_) {
        // Already gone (race with normal cleanup) - nothing to do.
      }
      exit(sig == ProcessSignal.sigint ? 130 : 143);
    }

    subs.add(ProcessSignal.sigint.watch().listen(handle));
    if (!Platform.isWindows) {
      subs.add(ProcessSignal.sigterm.watch().listen(handle));
    }
    return subs;
  }

  void _onProtocolError(Object e) {
    stderr.writeln(
      'Input could not be parsed as a Debug Adapter Protocol message.\n'
      'The `serverpod dap` command is intended to be invoked by an editor '
      'using the Debug Adapter Protocol.\n\n'
      '$e',
    );
  }
}
