import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_shared/serverpod_shared.dart'
    show FileEx, FileWriteEx, ServerpodAddresses;

/// The default of every [RunnerManifest.copyWith] field that can be cleared,
/// distinguishing "not passed" from "passed as null".
const _keep = Object();

/// What the runner publishes about itself: where to reach it, what it is
/// serving, and the configuration it was started with.
///
/// Lives at `<serverDir>/.dart_tool/serverpod/runner.json`, written once the
/// runner holds its lock and socket, rewritten as the stage or an address
/// moves, and removed on a graceful shutdown.
///
/// The sockets are not named here. They sit beside the file under fixed
/// names, and a client derives their paths from where it found the manifest,
/// so a mount that shows the project at another path still works.
///
/// A crash leaves the file behind, so its presence alone is not evidence of a
/// live runner. `resolveRunner` decides that.
class RunnerManifest {
  /// The protocol spoken over the attach socket.
  ///
  /// A detached runner survives `dart pub global activate serverpod_cli`, so a
  /// new client can meet an old runner. Bump this when a change to the attach
  /// protocol would leave an older client misreading a newer runner, or the
  /// reverse.
  static const currentProtocolVersion = 1;

  const RunnerManifest({
    required this.pid,
    required this.projectId,
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

  /// The registry's name for this server package, a stable hash of its
  /// canonical path.
  ///
  /// Names the link the registry keeps to the directory this manifest is in,
  /// for a client whose own path to the sockets beside it exceeds the socket
  /// address limit.
  final String projectId;

  /// The pod's VM service proxy, once it has booted.
  ///
  /// Null until then. A degraded start never gets one.
  final RunnerVmServiceUris? vmService;

  /// The addresses the pod's listeners resolved to.
  ///
  /// Null until the pod reports them.
  final ServerpodAddresses? servers;

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

  /// This manifest with the given fields replaced.
  ///
  /// [vmService], [servers] and [docker] are what the runner published about
  /// the stack, and take null to mean "no longer any". Omit them to keep what
  /// is there. A `??` default would leave `runner status` naming a dead server.
  RunnerManifest copyWith({
    Object? vmService = _keep,
    Object? servers = _keep,
    Object? docker = _keep,
    RunnerStage? stage,
    int? exitCode,
  }) => RunnerManifest(
    protocolVersion: protocolVersion,
    cliVersion: cliVersion,
    pid: pid,
    projectId: projectId,
    config: config,
    vmService: identical(vmService, _keep)
        ? this.vmService
        : vmService as RunnerVmServiceUris?,
    servers: identical(servers, _keep)
        ? this.servers
        : servers as ServerpodAddresses?,
    docker: identical(docker, _keep) ? this.docker : docker as RunnerDocker?,
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
    await file.writeAsStringAtomically(
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
