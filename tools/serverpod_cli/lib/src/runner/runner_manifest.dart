import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show FileEx;

/// What the runner publishes about itself: where to reach it, what it is
/// serving, and the configuration it was started with.
///
/// Lives at `<serverDir>/.dart_tool/serverpod/runner.json`, written once the
/// runner holds its lock and socket, rewritten as the stage or an address
/// moves, and removed on a graceful shutdown.
///
/// A crash leaves the file behind, so its presence alone is not evidence of a
/// live runner. `resolveRunner` decides that.
class RunnerManifest {
  /// The protocol spoken over [RunnerSockets.tui].
  ///
  /// A detached runner survives `dart pub global activate serverpod_cli`, so a
  /// new client can meet an old runner. Bump this when a change to the attach
  /// protocol would leave an older client misreading a newer runner, or the
  /// reverse.
  static const currentProtocolVersion = 1;

  const RunnerManifest({
    required this.pid,
    required this.sockets,
    required this.config,
    this.protocolVersion = currentProtocolVersion,
    this.cliVersion = templateVersion,
    this.vmService,
    this.servers,
    this.docker,
    this.stage = RunnerStage.running,
    this.exitCode,
  });

  final int protocolVersion;
  final String cliVersion;

  /// The runner process id, for diagnostics.
  ///
  /// Not used for liveness. A pid can be reused, and the runner may be in
  /// another pid namespace.
  final int pid;

  final RunnerSockets sockets;

  /// The pod's VM service proxy, once it has booted.
  ///
  /// Null until then. A degraded start never gets one.
  final RunnerVmServiceUris? vmService;

  /// The addresses the pod's listeners resolved to.
  ///
  /// Null until the pod reports them.
  final RunnerServerUris? servers;

  /// The Docker Compose services this runner started or attached to.
  ///
  /// Null when it did not consider Docker.
  final RunnerDocker? docker;

  /// What the runner cannot change after startup.
  final RunnerConfig config;

  /// How far the runner has got.
  ///
  /// Published as [RunnerStage.starting] before Docker, generation and the
  /// first compile, then rewritten as the stage moves.
  final RunnerStage stage;

  /// What the runner left with, on a start that aborted.
  ///
  /// Such a start leaves the manifest behind at [RunnerStage.stopping] rather
  /// than removing it.
  final int? exitCode;

  /// Whether a runner left this behind as the record of a stop that finished.
  ///
  /// An aborted start is the one shutdown that ends with the file still on
  /// disk, and [exitCode] is what marks it. A runner on its way down
  /// republishes the stage alone and removes the file when it is done.
  bool get isFinished => stage == RunnerStage.stopping && exitCode != null;

  RunnerManifest copyWith({
    RunnerSockets? sockets,
    RunnerVmServiceUris? vmService,
    RunnerServerUris? servers,
    RunnerDocker? docker,
    RunnerStage? stage,
    int? exitCode,
  }) => RunnerManifest(
    protocolVersion: protocolVersion,
    cliVersion: cliVersion,
    pid: pid,
    sockets: sockets ?? this.sockets,
    config: config,
    vmService: vmService ?? this.vmService,
    servers: servers ?? this.servers,
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
    'sockets': sockets.toJson(),
    if (vmService != null) 'vmService': vmService!.toJson(),
    if (servers != null) 'servers': servers!.toJson(),
    if (docker != null) 'docker': docker!.toJson(),
    'config': config.toJson(),
  };

  static RunnerManifest fromJson(Map<String, Object?> json) => RunnerManifest(
    protocolVersion: json['protocolVersion'] as int? ?? 0,
    cliVersion: json['cliVersion'] as String? ?? '',
    pid: json['pid'] as int? ?? 0,
    stage: switch (json['stage']) {
      final String name => RunnerStage.byName(name),
      _ => RunnerStage.running,
    },
    exitCode: json['exitCode'] as int?,
    sockets: RunnerSockets.fromJson(_map(json['sockets']) ?? const {}),
    vmService: switch (_map(json['vmService'])) {
      final map? => RunnerVmServiceUris.fromJson(map),
      _ => null,
    },
    servers: switch (_map(json['servers'])) {
      final map? => RunnerServerUris.fromJson(map),
      _ => null,
    },
    docker: switch (_map(json['docker'])) {
      final map? => RunnerDocker.fromJson(map),
      _ => null,
    },
    config: RunnerConfig.fromJson(_map(json['config']) ?? const {}),
  );

  /// Writes this manifest for the server project at [serverDir], creating the
  /// directory if needed.
  Future<void> writeTo(String serverDir) async {
    final file = File(serverpodRunnerManifestPath(serverDir));
    await file.parent.create(recursive: true);
    await file.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(toJson())}\n',
    );
  }

  /// Reads the manifest for the server project at [serverDir], or `null` when
  /// there is none or it cannot be parsed.
  ///
  /// A corrupt manifest reads as absent, being a stale cache the next runner
  /// overwrites.
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

  /// Removes the manifest for the server project at [serverDir].
  static Future<void> deleteFrom(String serverDir) =>
      File(serverpodRunnerManifestPath(serverDir)).deleteIfExists();
}

/// The Unix sockets the runner listens on, as paths relative to the server
/// directory or absolute, whichever is shorter.
class RunnerSockets {
  const RunnerSockets({required this.tui, required this.mcp});

  final String tui;
  final String mcp;

  Map<String, Object?> toJson() => {'tui': tui, 'mcp': mcp};

  static RunnerSockets fromJson(Map<String, Object?> json) => RunnerSockets(
    tui: json['tui'] as String? ?? '',
    mcp: json['mcp'] as String? ?? '',
  );
}

/// The VM service URI clients should attach to.
///
/// The proxy, not the pod's own URI, which moves on every restart.
/// `vm-service-info.pod.json` names the pod's.
class RunnerVmServiceUris {
  const RunnerVmServiceUris({this.proxy});

  final String? proxy;

  Map<String, Object?> toJson() => {if (proxy != null) 'proxy': proxy};

  static RunnerVmServiceUris fromJson(Map<String, Object?> json) =>
      RunnerVmServiceUris(proxy: json['proxy'] as String?);
}

/// The addresses the pod's listeners resolved to.
class RunnerServerUris {
  const RunnerServerUris({this.api, this.insights, this.web});

  final String? api;
  final String? insights;
  final String? web;

  Map<String, Object?> toJson() => {
    if (api != null) 'api': api,
    if (insights != null) 'insights': insights,
    if (web != null) 'web': web,
  };

  static RunnerServerUris fromJson(Map<String, Object?> json) =>
      RunnerServerUris(
        api: json['api'] as String?,
        insights: json['insights'] as String?,
        web: json['web'] as String?,
      );
}

/// Whether this runner started the Docker Compose services, and under which
/// project name.
///
/// Teardown is conditional on [startedByRunner]. A runner that attached to
/// services someone else brought up must not stop them.
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

/// The runner's effective configuration, limited to what it cannot change
/// after startup.
///
/// Options describing the client rather than the stack, `--attach` and
/// `--tui`, are deliberately absent.
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

  /// Whether Docker Compose services are part of this stack.
  ///
  /// What the runner resolved. Null in a requested configuration that passed
  /// neither `--docker` nor `--no-docker`, leaving the default to the project.
  final bool? docker;

  /// The option names on which this configuration differs from [other], for an
  /// error that names them rather than just refusing.
  ///
  /// [other] is what an invocation asked for. This is what the runner is
  /// serving.
  List<String> differencesFrom(RunnerConfig other) => [
    if (watch != other.watch) '--watch',
    if (flutter != other.flutter) '--flutter',
    if (other.docker != null && docker != other.docker) '--docker',
    if (!_serverArgsEqual.equals(serverArgs, other.serverArgs))
      'server arguments after --',
  ];

  /// The `serverpod runner serve` arguments that reproduce this configuration.
  ///
  /// `serverpod start` spawns `runner serve` with these, then compares what
  /// came back via [differencesFrom]. A null [docker] passes neither flag,
  /// leaving the runner to take the default from the project.
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
