import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show FileEx, FileWriteEx, ServerpodAddresses;

/// What a runner publishes about itself in `.dart_tool/serverpod/runner.json`.
///
/// A crashed runner leaves it behind, so only `resolveRunner` decides liveness.
class RunnerManifest {
  /// The attach protocol version, bumped on any change old peers would misread.
  static const currentProtocolVersion = 1;

  const RunnerManifest({
    required this.pid,
    required this.projectId,
    required this.config,
    this.protocolVersion = currentProtocolVersion,
    this.cliVersion = templateVersion,
    this.vmService,
    this.servers,
    this.ports,
    this.docker,
    this.stage = RunnerStage.running,
    this.exitCode,
  });

  final int protocolVersion;
  final String cliVersion;

  /// The runner's pid, never proof of liveness since pids get reused.
  final int pid;

  /// The name of this package's registry link, from `RunnerRegistry.idFor`.
  final String projectId;

  /// The pod's VM service proxy, null until the runner has a stack.
  final RunnerVmServiceUris? vmService;

  /// The addresses the pod's listeners bound, null until the pod reports them.
  final ServerpodAddresses? servers;

  /// The bind ports this runner claims, keyed by listener name.
  ///
  /// Null until port resolution runs, and empty when the stack moved aside.
  final Map<String, int>? ports;

  /// The Docker Compose services, null before the stack or without Docker.
  final RunnerDocker? docker;

  /// The configuration the runner cannot change after startup.
  final RunnerConfig config;

  final RunnerStage stage;

  /// The code an aborted start exited with.
  final int? exitCode;

  /// Whether this is the record of an aborted start.
  ///
  /// A graceful shutdown publishes [RunnerStage.stopping] without an exit code.
  bool get isFinished => stage == RunnerStage.stopping && exitCode != null;

  /// A copy with the given fields replaced, where null keeps the current value.
  RunnerManifest copyWith({
    RunnerVmServiceUris? vmService,
    ServerpodAddresses? servers,
    Map<String, int>? ports,
    RunnerDocker? docker,
    RunnerStage? stage,
    int? exitCode,
  }) => RunnerManifest(
    protocolVersion: protocolVersion,
    cliVersion: cliVersion,
    pid: pid,
    projectId: projectId,
    config: config,
    vmService: vmService ?? this.vmService,
    servers: servers ?? this.servers,
    ports: ports ?? this.ports,
    docker: docker ?? this.docker,
    stage: stage ?? this.stage,
    exitCode: exitCode ?? this.exitCode,
  );

  Map<String, Object?> toJson() => {
    'protocolVersion': protocolVersion,
    'cliVersion': cliVersion,
    'pid': pid,
    'stage': stage.name,
    if (exitCode != null) 'exitCode': exitCode,
    'projectId': projectId,
    if (vmService != null) 'vmService': vmService!.toJson(),
    if (servers != null) 'servers': servers!.toJson(),
    if (ports != null) 'ports': ports,
    if (docker != null) 'docker': docker!.toJson(),
    'config': config.toJson(),
  };

  static RunnerManifest fromJson(Map<String, Object?> json) => RunnerManifest(
    protocolVersion: json['protocolVersion'] as int? ?? 0,
    cliVersion: json['cliVersion'] as String? ?? '',
    pid: json['pid'] as int? ?? 0,
    stage: RunnerStage.byName(json['stage'] as String?),
    exitCode: json['exitCode'] as int?,
    projectId: json['projectId'] as String? ?? '',
    vmService: switch (_map(json['vmService'])) {
      final map? => RunnerVmServiceUris.fromJson(map),
      _ => null,
    },
    servers: switch (_map(json['servers'])) {
      final map? => ServerpodAddresses.fromJson(map),
      _ => null,
    },
    ports: _ports(json['ports']),
    docker: switch (_map(json['docker'])) {
      final map? => RunnerDocker.fromJson(map),
      _ => null,
    },
    config: RunnerConfig.fromJson(_map(json['config']) ?? const {}),
  );

  Future<void> writeTo(String serverDir) async {
    final file = File(serverpodRunnerManifestPath(serverDir));
    await file.parent.create(recursive: true);
    await file.writeAsStringAtomically(
      '${const JsonEncoder.withIndent('  ').convert(toJson())}\n',
    );
  }

  /// Reads the manifest at [serverDir], or null when absent or unparseable.
  static Future<RunnerManifest?> readFrom(String serverDir) async {
    final file = File(serverpodRunnerManifestPath(serverDir));
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, Object?>) return null;
      return RunnerManifest.fromJson(decoded);
    } on FileSystemException {
      return null;
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  static Future<void> deleteFrom(String serverDir) =>
      File(serverpodRunnerManifestPath(serverDir)).deleteIfExists();
}

/// The VM service proxy's URI, which survives pod restarts.
class RunnerVmServiceUris {
  const RunnerVmServiceUris({this.proxy});

  final String? proxy;

  Map<String, Object?> toJson() => {if (proxy != null) 'proxy': proxy};

  static RunnerVmServiceUris fromJson(Map<String, Object?> json) =>
      RunnerVmServiceUris(proxy: json['proxy'] as String?);
}

/// The Docker Compose project, and whether this runner started its services.
///
/// A runner stops only the services it started.
class RunnerDocker {
  const RunnerDocker({required this.startedByRunner, required this.project});

  final bool startedByRunner;
  final String project;

  Map<String, Object?> toJson() => {
    'startedByRunner': startedByRunner,
    'project': project,
  };

  static RunnerDocker fromJson(Map<String, Object?> json) => RunnerDocker(
    startedByRunner: json['startedByRunner'] as bool? ?? false,
    project: json['project'] as String? ?? '',
  );
}

const _serverArgsEqual = ListEquality<String>();

/// The runner options fixed at startup, leaving out client-only options.
class RunnerConfig {
  const RunnerConfig({
    required this.watch,
    required this.flutter,
    required this.serverArgs,
    this.docker,
  });

  final bool watch;
  final bool flutter;
  final List<String> serverArgs;

  /// Whether the stack runs Docker Compose, null when a request left it open.
  final bool? docker;

  /// The option names on which this differs from the requested [other].
  List<String> differencesFrom(RunnerConfig other) => [
    if (watch != other.watch) '--watch',
    if (flutter != other.flutter) '--flutter',
    if (other.docker != null && docker != other.docker) '--docker',
    if (!_serverArgsEqual.equals(serverArgs, other.serverArgs))
      'server arguments after --',
  ];

  /// The `serverpod runner serve` arguments that reproduce this configuration.
  List<String> toServeArgs({required String directory}) {
    return [
      '--directory',
      directory,
      if (watch) '--watch' else '--no-watch',
      if (flutter) '--flutter' else '--no-flutter',
      if (docker == true) '--docker',
      if (docker == false) '--no-docker',
      if (serverArgs.isNotEmpty) ...['--', ...serverArgs],
    ];
  }

  Map<String, Object?> toJson() => {
    'watch': watch,
    'flutter': flutter,
    if (docker != null) 'docker': docker,
    'serverArgs': serverArgs,
  };

  static RunnerConfig fromJson(Map<String, Object?> json) => RunnerConfig(
    watch: json['watch'] as bool? ?? true,
    flutter: json['flutter'] as bool? ?? true,
    docker: json['docker'] as bool?,
    serverArgs: switch (json['serverArgs']) {
      final List<Object?> args => [for (final arg in args) '$arg'],
      _ => const [],
    },
  );
}

Map<String, Object?>? _map(Object? value) =>
    value is Map<String, Object?> ? value : null;

/// The port claims in [value], keeping an empty map distinct from null.
Map<String, int>? _ports(Object? value) => switch (_map(value)) {
  final map? => {
    for (final entry in map.entries)
      if (entry.value case final int port) entry.key: port,
  },
  _ => null,
};
