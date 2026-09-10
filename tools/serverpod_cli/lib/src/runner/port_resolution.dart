import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_registry.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// What the runner decided about the configured ports.
///
/// See `docs/design/runner.md#address-publication`.
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

  /// Whether all listeners move to ephemeral ports together.
  final bool useEphemeral;

  /// The ports held by something other than a runner, which block the start.
  final Map<String, int> conflicts;

  /// Held ports a silent runner may own. They move the stack aside and warn.
  final Map<String, int> unattributed;

  bool get hasConflicts => conflicts.isNotEmpty;

  /// All listeners in [ports] when moved aside, else those configured with 0.
  Iterable<String> ephemeralListeners(Map<String, int> ports) => useEphemeral
      ? ports.keys
      : [
          for (final entry in ports.entries)
            if (entry.value == 0) entry.key,
        ];

  /// The ports in [ports] this runner claims, none when it moved aside.
  Map<String, int> claimedPorts(Map<String, int> ports) =>
      useEphemeral ? const {} : fixedPorts(ports);
}

/// The listeners in [ports] configured with a non-zero port.
Map<String, int> fixedPorts(Map<String, int> ports) => {
  for (final entry in ports.entries)
    if (entry.value != 0) entry.key: entry.value,
};

/// Decides whether the stack for [serverDir] keeps [ports] or moves aside.
///
/// [ports] is keyed by listener name (`api`, `insights`, `web`).
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
    // A claimed port counts as taken, and a silent runner may claim any.
    final claimed = ports.values.any(held.ports.contains);
    return PortResolution(
      useEphemeral: claimed || held.silentRunner,
      conflicts: const {},
    );
  }

  // A silent runner may hold these, so move aside instead of failing.
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
/// An IPv4-only probe misses a pod on `anyIPv6` without a dual-stack socket.
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

/// The ports other runners claimed or bound, and whether any is silent.
///
/// A silent runner has named no ports yet, or holds its lock without answering.
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

Iterable<int> _publishedPorts(RunnerManifest manifest) sync* {
  final servers = manifest.servers;
  if (servers == null) return;
  for (final url in [servers.api, servers.insights, servers.web]) {
    if (url == null) continue;
    final port = Uri.tryParse(url)?.port;
    if (port != null && port != 0) yield port;
  }
}

/// The environment that binds [listeners], public ports included, to port 0.
///
/// Pass only configured listeners, since a port variable alone creates one.
Map<String, String> ephemeralPortEnvironment(Iterable<String> listeners) => {
  for (final listener in listeners) ...{
    ?portEnvironmentVariables[listener]: '0',
    ?publicPortEnvironmentVariables[listener]: '0',
  },
};

/// [environment] with each port 0 replaced by the port [addresses] reports.
///
/// Later spawns then keep the port the Flutter apps were built against.
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

/// The environment variable that sets each listener's public port.
final publicPortEnvironmentVariables = {
  'api': ServerpodEnv.apiPublicPort.envVariable,
  'insights': ServerpodEnv.insightsPublicPort.envVariable,
  'web': ServerpodEnv.webPublicPort.envVariable,
};

final _listenerByPortVariable = {
  for (final entry in portEnvironmentVariables.entries) entry.value: entry.key,
  for (final entry in publicPortEnvironmentVariables.entries)
    entry.value: entry.key,
};
