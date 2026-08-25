import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// What the runner decided about the configured ports.
///
/// Another live Serverpod runner means a second worktree, which moves aside to
/// ephemeral ports. Anything else holding a port, a stray pod or an unrelated
/// service, is a conflict to report rather than hide.
class PortResolution {
  const PortResolution({
    required this.useEphemeral,
    required this.conflicts,
    this.unattributed = const {},
  });

  /// Whether the pod binds ephemeral ports instead of the configured ones.
  ///
  /// Decided for the three listeners as a block. An api server on 8080 beside
  /// a web server on a moved port is harder to reason about than a stack
  /// wholly where the manifest says.
  final bool useEphemeral;

  /// The ports held by something that is not a Serverpod runner.
  ///
  /// Non-empty means the runner must not start.
  final Map<String, int> conflicts;

  /// The ports held by something no runner accounted for, while a runner that
  /// has published no addresses yet could still be the holder.
  ///
  /// Not [conflicts]. The stack moves aside rather than refuse to start, and
  /// names these so a developer can tell that from an unrelated process.
  final Map<String, int> unattributed;

  bool get hasConflicts => conflicts.isNotEmpty;
}

/// Decides whether the stack for [serverDir] can use [ports], or has to fall
/// back to ephemeral ones.
///
/// [ports] is keyed by listener name (`api`, `insights`, `web`) so a conflict
/// can be reported against the listener a developer configured.
Future<PortResolution> resolvePorts({
  required String serverDir,
  required Map<String, int> ports,
  Duration probeTimeout = const Duration(milliseconds: 300),
}) async {
  final occupied = <String, int>{};
  await Future.wait([
    for (final entry in ports.entries)
      if (entry.value != 0)
        _isListening(entry.value, probeTimeout).then((listening) {
          if (listening) occupied[entry.key] = entry.value;
        }),
  ]);

  if (occupied.isEmpty) {
    return const PortResolution(useEphemeral: false, conflicts: {});
  }

  final held = await _portsHeldByOtherRunners(serverDir);
  final conflicts = {
    for (final entry in occupied.entries)
      if (!held.ports.contains(entry.value)) entry.key: entry.value,
  };

  if (conflicts.isEmpty) {
    return const PortResolution(useEphemeral: true, conflicts: {});
  }

  // The silent runner could hold any of these, and blaming it would fail the
  // second worktree on a race with the first one's startup.
  if (held.silentRunner) {
    return PortResolution(
      useEphemeral: true,
      conflicts: const {},
      unattributed: conflicts,
    );
  }

  return PortResolution(useEphemeral: false, conflicts: conflicts);
}

Future<bool> _isListening(int port, Duration timeout) async {
  try {
    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      port,
      timeout: timeout,
    );
    socket.destroy();
    return true;
  } on SocketException {
    return false;
  }
}

/// The ports other live Serverpod runners have published as theirs, and
/// whether any published none at all.
///
/// A port is attributed to a runner by the addresses its manifest names.
/// `silentRunner` covers a runner that is up but has named nothing.
///
/// Candidates are looked for beside the repository this server package sits
/// in, where `git worktree` and a second clone both put them.
Future<({Set<int> ports, bool silentRunner})> _portsHeldByOtherRunners(
  String serverDir,
) async {
  final canonical = p.canonicalize(serverDir);
  final runners = await Future.wait([
    for (final candidate in _siblingServerDirs(canonical))
      if (candidate != canonical) resolveRunner(candidate),
  ]);

  final ports = <int>{};
  var silentRunner = false;
  for (final runner in runners) {
    if (runner is! LiveRunner) continue;
    final published = _publishedPorts(runner.manifest).toSet();
    if (published.isEmpty) silentRunner = true;
    ports.addAll(published);
  }
  return (ports: ports, silentRunner: silentRunner);
}

/// The ports named by a manifest's published server addresses.
Iterable<int> _publishedPorts(RunnerManifest manifest) sync* {
  final servers = manifest.servers;
  if (servers == null) return;
  for (final url in [servers.api, servers.insights, servers.web]) {
    if (url == null) continue;
    final port = Uri.tryParse(url)?.port;
    if (port != null && port != 0) yield port;
  }
}

/// Returns the server directories of other checkouts that might be running a
/// stack.
///
/// Walks up from [serverDir] to the enclosing repository, then looks for the
/// same relative path under each sibling of that repository.
Iterable<String> _siblingServerDirs(String serverDir) sync* {
  final repoRoot = _repositoryRootOf(serverDir);
  if (repoRoot == null) return;

  final relative = p.relative(serverDir, from: repoRoot);
  final parent = Directory(p.dirname(repoRoot));
  if (!parent.existsSync()) return;

  // The parent need not be listable: a mounted volume, a restricted home. No
  // neighbours to find is not a reason to fail a start.
  final List<FileSystemEntity> siblings;
  try {
    siblings = parent.listSync();
  } on FileSystemException {
    return;
  }

  for (final sibling in siblings.whereType<Directory>()) {
    final candidate = p.canonicalize(p.join(sibling.path, relative));
    if (Directory(candidate).existsSync()) yield candidate;
  }
}

/// Returns the nearest enclosing directory holding a `.git` entry, or null.
String? _repositoryRootOf(String from) {
  var dir = Directory(from);
  while (true) {
    if (Directory(p.join(dir.path, '.git')).existsSync() ||
        File(p.join(dir.path, '.git')).existsSync()) {
      return p.canonicalize(dir.path);
    }
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
}

/// The environment overrides that make the pod bind ephemeral ports for
/// [listeners], named the way [resolvePorts] names them.
///
/// Pass only listeners the project configured. The config merges the
/// environment over the yaml, and a port variable alone brings a listener into
/// existence, so an insights port set for a project with no `insightsServer:`
/// section would start an insights server nobody asked for.
Map<String, String> ephemeralPortEnvironment(Iterable<String> listeners) => {
  for (final listener in listeners) ?portEnvironmentVariables[listener]: '0',
};

/// The environment variable that sets each listener's port, by listener name.
final portEnvironmentVariables = {
  'api': ServerpodEnv.apiPort.envVariable,
  'insights': ServerpodEnv.insightsPort.envVariable,
  'web': ServerpodEnv.webPort.envVariable,
};
