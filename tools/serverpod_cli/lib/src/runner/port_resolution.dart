import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
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
    this.overrides = const {},
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

  /// The port each listener binds instead of its configured one, 0 for any.
  final Map<String, int> overrides;

  bool get hasConflicts => conflicts.isNotEmpty;
}

/// The listeners in [ports] configured with a non-zero port.
Map<String, int> fixedPorts(Map<String, int> ports) => {
  for (final entry in ports.entries)
    if (entry.value != 0) entry.key: entry.value,
};

/// The ports a runner claims, [configured] with its [overrides] applied.
Map<String, int> claimedPorts(
  Map<String, int> configured,
  Map<String, int> overrides,
) => fixedPorts({...configured, ...overrides});

/// Decides whether the stack for [serverDir] keeps [ports] or moves aside.
///
/// [ports] and [suggested], the ports to try off the configured ones, are keyed
/// by listener name (`api`, `insights`, `web`).
Future<PortResolution> resolvePorts({
  required String serverDir,
  required Map<String, int> ports,
  Map<String, int> suggested = const {},
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

  final bool useEphemeral;
  var unattributed = const <String, int>{};
  if (conflicts.isEmpty) {
    // A claimed port counts as taken, and a silent runner may claim any.
    useEphemeral = ports.values.any(held.ports.contains) || held.silentRunner;
  } else if (held.silentRunner) {
    // A silent runner may hold these, so move aside instead of failing.
    useEphemeral = true;
    unattributed = conflicts;
  } else {
    return PortResolution(useEphemeral: false, conflicts: conflicts);
  }

  final overrides = {
    for (final MapEntry(key: listener, value: port) in ports.entries)
      if (useEphemeral || port == 0) listener: 0,
  };
  // A configured port would leave a moved-aside stack half moved.
  await Future.wait([
    for (final listener in overrides.keys)
      if (suggested[listener] case final port?
          when port != 0 &&
              !held.ports.contains(port) &&
              !ports.containsValue(port))
        _isListening(port, probeTimeout).then((listening) {
          if (!listening) overrides[listener] = port;
        }),
  ]);
  return PortResolution(
    useEphemeral: useEphemeral,
    conflicts: const {},
    unattributed: unattributed,
    overrides: overrides,
  );
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
    final published = _listenerPorts(manifest.servers).values.toSet();
    if (claimed == null && published.isEmpty) silentRunner = true;
    ports
      ..addAll(claimed?.values ?? const [])
      ..addAll(published);
  }
  return (ports: ports, silentRunner: silentRunner);
}

/// The non-zero ports in [addresses], keyed by listener name.
Map<String, int> _listenerPorts(ServerpodAddresses? addresses) => {
  for (final (listener, url) in [
    ('api', addresses?.api),
    ('insights', addresses?.insights),
    ('web', addresses?.web),
  ])
    if (url != null)
      if (Uri.tryParse(url)?.port case final port? when port != 0)
        listener: port,
};

/// The environment binding each listener in [overrides], and its public port.
///
/// Pass only configured listeners, since a port variable alone creates one.
Map<String, String> portOverrideEnvironment(Map<String, int> overrides) => {
  for (final MapEntry(key: listener, value: port) in overrides.entries) ...{
    ?portEnvironmentVariables[listener]: '$port',
    ?publicPortEnvironmentVariables[listener]: '$port',
  },
};

/// [overrides] with each 0 replaced by the port [addresses] reports.
///
/// Later spawns then keep the port the Flutter apps were built against.
Map<String, int> pinResolvedPorts(
  Map<String, int> overrides,
  ServerpodAddresses addresses,
) {
  final bound = _listenerPorts(addresses);
  return {
    for (final MapEntry(key: listener, value: port) in overrides.entries)
      listener: port == 0 ? bound[listener] ?? 0 : port,
  };
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
