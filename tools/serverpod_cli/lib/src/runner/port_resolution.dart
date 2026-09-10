import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// What the runner decided about the configured ports.
///
/// Another live Serverpod runner means a second worktree, which moves aside to
/// ephemeral ports. Anything else holding a port, a stray pod or an unrelated
/// service, is a conflict to report rather than hide.
class PortResolution {
  PortResolution({
    required this.useEphemeral,
    required this.conflicts,
    this.unattributed = const {},
  }) : assert(
         conflicts.isEmpty || !useEphemeral,
         'A stack with conflicts does not start, so it moves no ports.',
       ),
       assert(
         unattributed.isEmpty || useEphemeral,
         'Unattributed ports move the stack aside.',
       );

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
  /// has not decided its ports yet could still be the holder.
  ///
  /// Not [conflicts]. The stack moves aside rather than refuse to start, and
  /// names these so a developer can tell that from an unrelated process.
  final Map<String, int> unattributed;

  bool get hasConflicts => conflicts.isNotEmpty;

  /// The listeners in [ports] the pod binds ephemeral ports for: all of them
  /// when the stack moved aside, else the ones configured with port zero,
  /// whose bound port needs pinning across respawns just the same.
  Iterable<String> ephemeralListeners(Map<String, int> ports) => useEphemeral
      ? ports.keys
      : [
          for (final entry in ports.entries)
            if (entry.value == 0) entry.key,
        ];

  /// The ports in [ports] this runner will bind as configured, for its
  /// manifest: none when the stack moved aside, else every listener not
  /// configured with port zero.
  ///
  /// A peer resolving its ports meanwhile reads this as a claim, so it moves
  /// aside for a port this runner will bind and keeps one it will not.
  Map<String, int> claimedPorts(Map<String, int> ports) =>
      useEphemeral ? const {} : fixedPorts(ports);
}

/// The listeners in [ports] configured with a fixed port, the ones a runner
/// binding as configured will take.
Map<String, int> fixedPorts(Map<String, int> ports) => {
  for (final entry in ports.entries)
    if (entry.value != 0) entry.key: entry.value,
};

/// Decides whether the stack for [serverDir] can use [ports], or has to fall
/// back to ephemeral ones.
///
/// [ports] is keyed by listener name (`api`, `insights`, `web`) so a conflict
/// can be reported against the listener a developer configured. Other runners
/// are found through [registry], where every runner on this machine registers
/// itself when it publishes.
Future<PortResolution> resolvePorts({
  required String serverDir,
  required Map<String, int> ports,
  RunnerRegistry? registry,
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

  final held = await _portsHeldByOtherRunners(
    serverDir,
    registry ?? RunnerRegistry(),
    probeTimeout,
  );

  final conflicts = {
    for (final entry in occupied.entries)
      if (!held.ports.contains(entry.value)) entry.key: entry.value,
  };

  if (conflicts.isEmpty) {
    // A port a sibling has claimed but not bound yet is as taken as one it
    // holds: two stacks racing for one port fails whichever binds second, so
    // this one moves aside while the port is still free. A sibling that has
    // not decided yet could claim any of them.
    final claimed = ports.values.any(held.ports.contains);
    return PortResolution(
      useEphemeral: claimed || held.silentRunner,
      conflicts: const {},
    );
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

/// Whether anything answers on [port] on either loopback address.
///
/// The pod binds `anyIPv6`, which takes IPv4 only on a dual-stack socket. Where
/// the host gives it none, an IPv4-only probe reads a held port as free.
Future<bool> _isListening(int port, Duration timeout) async {
  final probes = [
    for (final address in [
      InternetAddress.loopbackIPv4,
      InternetAddress.loopbackIPv6,
    ])
      _connects(address, port, timeout),
  ];
  return (await Future.wait(probes)).any((listening) => listening);
}

Future<bool> _connects(
  InternetAddress address,
  int port,
  Duration timeout,
) async {
  try {
    final socket = await Socket.connect(address, port, timeout: timeout);
    socket.destroy();
    return true;
  } on SocketException {
    return false;
  }
}

/// The ports other Serverpod runners have claimed or bound, and whether any is
/// up without having decided.
///
/// A port is attributed to a runner by the claim its manifest makes before
/// Docker and the first compile, and by the addresses its pod reported,
/// whichever protocol version it speaks. `silentRunner` covers a runner with
/// neither: one between publishing and resolving its ports, and one that
/// holds its lock but did not answer its socket in time, which is a busy
/// runner as often as a dying one.
Future<({Set<int> ports, bool silentRunner})> _portsHeldByOtherRunners(
  String serverDir,
  RunnerRegistry registry,
  Duration probeTimeout,
) async {
  final canonical = p.canonicalize(serverDir);
  final ports = <int>{};
  var silentRunner = false;
  for (final runner in await registry.scan(probeTimeout: probeTimeout)) {
    if (runner.serverDir == canonical) continue;
    final manifest = switch (runner.resolution) {
      LiveRunner(:final manifest) => manifest,
      IncompatibleRunner(:final manifest) => manifest,
      NoRunner(lockHeld: true, :final staleManifest) => staleManifest,
      NoRunner() => null,
    };
    if (manifest == null) continue;
    final claimed = manifest.ports;
    final published = _publishedPorts(manifest).toSet();
    if (claimed == null && published.isEmpty) silentRunner = true;
    ports
      ..addAll(claimed?.values ?? const [])
      ..addAll(published);
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

/// The environment overrides that make the pod bind ephemeral ports for
/// [listeners], named the way [resolvePorts] names them.
///
/// The public port goes to zero with the bind port, so the pod advertises the
/// port it bound rather than the one configured.
///
/// Pass only listeners the project configured. The config merges the
/// environment over the yaml, and a port variable alone brings a listener into
/// existence, so an insights port set for a project with no `insightsServer:`
/// section would start an insights server nobody asked for.
Map<String, String> ephemeralPortEnvironment(Iterable<String> listeners) => {
  for (final listener in listeners) ...{
    ?portEnvironmentVariables[listener]: '0',
    ?publicPortEnvironmentVariables[listener]: '0',
  },
};

/// [environment] with each port-zero override replaced by the port the pod
/// bound, read from [addresses].
///
/// A pod spawned with port zero binds a different port every time, and the
/// Flutter apps launched against the first one would lose the second. Once
/// the pod has reported what it bound, every later spawn asks for that.
Map<String, String> pinResolvedPorts(
  Map<String, String> environment,
  ServerpodAddresses addresses,
) {
  final bound = {
    'api': addresses.api,
    'insights': addresses.insights,
    'web': addresses.web,
  };
  return {
    for (final entry in environment.entries)
      entry.key: switch (_boundPort(entry.key, bound)) {
        final port? when entry.value == '0' => '$port',
        _ => entry.value,
      },
  };
}

int? _boundPort(String variable, Map<String, String?> bound) {
  final address = bound[_listenerByPortVariable[variable]];
  if (address == null) return null;
  final port = Uri.tryParse(address)?.port;
  return port == null || port == 0 ? null : port;
}

/// The environment variable that sets each listener's port, by listener name.
final portEnvironmentVariables = {
  'api': ServerpodEnv.apiPort.envVariable,
  'insights': ServerpodEnv.insightsPort.envVariable,
  'web': ServerpodEnv.webPort.envVariable,
};

/// The environment variable that sets each listener's public port, by
/// listener name.
final publicPortEnvironmentVariables = {
  'api': ServerpodEnv.apiPublicPort.envVariable,
  'insights': ServerpodEnv.insightsPublicPort.envVariable,
  'web': ServerpodEnv.webPublicPort.envVariable,
};

/// The listener each port variable, bind or public, belongs to.
final _listenerByPortVariable = {
  for (final entry in portEnvironmentVariables.entries) entry.value: entry.key,
  for (final entry in publicPortEnvironmentVariables.entries)
    entry.value: entry.key,
};
