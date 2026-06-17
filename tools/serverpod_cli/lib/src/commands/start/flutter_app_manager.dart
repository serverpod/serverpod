import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/flutter_dependency_tracker.dart';
import 'package:serverpod_cli/src/commands/start/flutter_process.dart';
import 'package:serverpod_cli/src/config/flutter_app_config.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vm_proxy/proxy.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Binds a [VmServiceProxy] for a companion Flutter app and writes its
/// stable IDE attach URI to [infoFile].
Future<VmServiceProxy> bindFlutterAppProxy({
  required String infoFile,
  FutureOr<void> Function()? onWaitingClientArrived,
}) async {
  final proxy = VmServiceProxy(
    upstreamWs: null,
    onWaitingClientArrived: onWaitingClientArrived,
  );
  await proxy.bind();
  await File(infoFile).parent.create(recursive: true);
  await File(infoFile).writeAsString(
    jsonEncode({'uri': proxy.httpUri.toString()}),
  );
  log.info('Flutter VM service proxy listening on ${proxy.httpUri}');
  return proxy;
}

/// Owns one runtime slot per configured companion Flutter app.
class FlutterAppManager {
  /// Creates a [FlutterAppManager].
  FlutterAppManager({
    required List<FlutterAppConfig> apps,
    required this.serverpodToolDir,
    required this.runMode,
    required this.onProgress,
    required this.onReady,
    required this.onStart,
    required this.onEnsureAppTab,
    required this.stdoutSinkFor,
    required this.stderrSinkFor,
    this.flutterExecutableForTesting,
    this.argsOverrideForTesting,
  }) : _apps = apps;

  /// Test-only override for the `flutter` executable path.
  final String? flutterExecutableForTesting;

  /// Test-only override for `flutter run` arguments per app.
  final List<String>? Function(FlutterAppConfig app)? argsOverrideForTesting;

  /// Test-only override for [checkDependencyChange].
  @visibleForTesting
  FlutterDependencyChange Function(String appId)?
  dependencyChangeOverrideForTesting;

  /// Test-only override for [restart].
  @visibleForTesting
  Future<void> Function(String appId)? restartOverrideForTesting;

  /// Test-only override for [launch].
  @visibleForTesting
  Future<void> Function(String appId)? launchOverrideForTesting;

  final String serverpodToolDir;
  final String runMode;
  final void Function(FlutterAppConfig app, String stage) onProgress;
  final void Function(FlutterAppConfig app, String url) onReady;
  final Future<void> Function(
    FlutterAppConfig app,
    FlutterProcess process,
  )
  onStart;
  final void Function(FlutterAppConfig app) onEnsureAppTab;
  final IOSink Function(FlutterAppConfig app) stdoutSinkFor;
  final IOSink Function(FlutterAppConfig app) stderrSinkFor;

  final List<FlutterAppConfig> _apps;
  final Map<String, _AppRuntime> _runtimes = {};
  bool _initialized = false;

  /// All configured apps in list order.
  Iterable<FlutterAppConfig> get apps => _apps;

  /// App ids with a running [FlutterProcess].
  Iterable<String> get runningAppIds sync* {
    for (final entry in _runtimes.entries) {
      if (entry.value.process?.isRunning ?? false) {
        yield entry.key;
      }
    }
  }

  /// Returns the [FlutterProcess] for [appId], if any.
  FlutterProcess? processFor(String appId) => _runtimes[appId]?.process;

  /// Whether [appId] has a running Flutter process.
  bool isRunning(String appId) => processFor(appId)?.isRunning ?? false;

  /// Whether [appId] is starting up (spawn through URL publication).
  bool isLaunching(String appId) {
    final runtime = _runtimeFor(appId);
    if (runtime == null) return false;
    if (runtime.spawnInFlight) return true;
    final process = runtime.process;
    if (process == null || !process.isRunning) return false;
    return process.flutterAppUrl == null;
  }

  /// Injects [process] for [appId] in tests.
  @visibleForTesting
  void setProcessForTesting(String appId, FlutterProcess process) {
    final runtime = _runtimeFor(appId);
    if (runtime == null) {
      throw StateError('Unknown Flutter app id: $appId');
    }
    runtime.process = process;
  }

  /// Returns the dependency tracker for [appId], if configured.
  FlutterDependencyTracker? dependencyTrackerFor(String appId) =>
      _runtimes[appId]?.dependencyTracker;

  /// Checks dependency changes for [appId].
  FlutterDependencyChange checkDependencyChange(String appId) {
    if (dependencyChangeOverrideForTesting != null) {
      return dependencyChangeOverrideForTesting!(appId);
    }
    return _runtimes[appId]?.dependencyTracker?.refresh() ??
        FlutterDependencyChange.none;
  }

  /// Returns running app ids whose `lib` directory contains any of [paths].
  ///
  /// When no app matches, returns every running app id so single-app behavior
  /// is preserved for server-side or ambiguous changes.
  Set<String> appIdsForChangedPaths(Iterable<String> paths) {
    final running = runningAppIds.toList();
    if (running.isEmpty) return {};

    final affected = <String>{};
    for (final appId in running) {
      final runtime = _runtimes[appId];
      if (runtime == null) continue;
      final libDir = p.normalize(p.joinAll([...runtime.app.pathParts, 'lib']));
      for (final changed in paths) {
        if (p.isWithin(libDir, p.normalize(changed))) {
          affected.add(appId);
          break;
        }
      }
    }

    return affected.isEmpty ? running.toSet() : affected;
  }

  /// Binds per-app VM-service proxies and sets up dependency trackers.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    for (final app in _apps) {
      final infoFile = _infoFileFor(app.id);
      final proxy = await bindFlutterAppProxy(
        infoFile: infoFile,
        onWaitingClientArrived: () => launch(app.id),
      );
      _runtimes[app.id] = _AppRuntime(
        app: app,
        proxy: proxy,
        infoFile: infoFile,
      );
      _setupDependencyTracker(app.id);
    }
  }

  /// Launches [appId] when not already running. No-op in non-development mode
  /// or when the app is already running.
  Future<void> launch(String appId) async {
    if (launchOverrideForTesting != null) {
      await launchOverrideForTesting!(appId);
      return;
    }
    if (runMode != 'development') return;

    final runtime = _runtimeFor(appId);
    if (runtime == null) return;

    final existing = runtime.process;
    if (existing != null && existing.isRunning) return;
    if (runtime.spawnInFlight) return;

    runtime.spawnInFlight = true;
    final isRelaunch = runtime.relaunchInProgress;
    runtime.relaunchInProgress = false;

    onEnsureAppTab(runtime.app);

    final device = runtime.app.device ?? flutterDeviceWebServerWithBrowser;

    final process = FlutterProcess(
      flutterPackageDir: p.joinAll(runtime.app.pathParts),
      device: device,
      extraArgs: runtime.app.extraRunArgs,
      flutterProxy: runtime.proxy,
      flutterExecutable: flutterExecutableForTesting ?? 'flutter',
      machineArgsOverride: argsOverrideForTesting?.call(runtime.app),
      stdoutSink: stdoutSinkFor(runtime.app),
      stderrSink: stderrSinkFor(runtime.app),
      onProgress: (stage) {
        onProgress(runtime.app, stage);
        log.info('  ${runtime.app.name}: $stage');
      },
    );

    try {
      await process.start();
    } on FlutterNotInstalledException catch (e) {
      log.warning(e.message);
      runtime.spawnInFlight = false;
      return;
    } catch (_) {
      runtime.spawnInFlight = false;
      rethrow;
    }

    runtime.process = process;
    runtime.spawnInFlight = false;

    unawaited(
      _connectAfterLaunch(
        runtime,
        process,
        device: device,
        isRelaunch: isRelaunch,
      ),
    );
  }

  /// Stops and relaunches [appId].
  Future<void> restart(String appId) async {
    if (restartOverrideForTesting != null) {
      await restartOverrideForTesting!(appId);
      return;
    }
    final runtime = _runtimeFor(appId);
    if (runtime == null) return;

    runtime.relaunchInProgress = runtime.process != null;
    await runtime.process?.stop();
    runtime.process = null;
    await launch(appId);
  }

  /// Stops every running app and removes per-app VM-service info files.
  Future<void> stopAll() async {
    for (final runtime in _runtimes.values) {
      await runtime.process?.stop();
      runtime.process = null;
      await File(runtime.infoFile).deleteIfExists();
    }
  }

  /// Closes every proxy and deletes info files.
  Future<void> dispose() async {
    await stopAll();
    for (final runtime in _runtimes.values) {
      await runtime.proxy.close();
    }
  }

  _AppRuntime? _runtimeFor(String appId) => _runtimes[appId];

  String _infoFileFor(String appId) =>
      p.join(serverpodToolDir, 'flutter-vm-service-info-$appId.json');

  void _setupDependencyTracker(String appId) {
    final runtime = _runtimeFor(appId);
    if (runtime == null) return;

    final flutterPackageDir = p.joinAll(runtime.app.pathParts);
    if (!runtime.app.hasPackage) return;

    try {
      final flutterPackageName = parsePubspec(
        File(p.join(flutterPackageDir, 'pubspec.yaml')),
      ).name;
      final dartToolDir = FlutterDependencyTracker.resolveDartToolDir(
        flutterPackageDir,
        flutterPackageName: flutterPackageName,
      );
      if (dartToolDir != null) {
        runtime.dependencyTracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: flutterPackageName,
        );
      } else {
        log.debug(
          'Flutter dependency tracking disabled for ${runtime.app.name}: no '
          'resolution listing $flutterPackageName found above '
          '$flutterPackageDir.',
        );
      }
    } catch (e) {
      log.debug(
        'Flutter dependency tracking disabled for ${runtime.app.name}: could '
        'not read the Flutter package name from $flutterPackageDir ($e).',
      );
    }
  }

  Future<void> _connectAfterLaunch(
    _AppRuntime runtime,
    FlutterProcess process, {
    required String device,
    required bool isRelaunch,
  }) async {
    await log.progress(
      isRelaunch
          ? 'Relaunching ${runtime.app.name}'
          : 'Launching ${runtime.app.name} (first run may take 30-60s)',
      () async {
        await process.launched;
        return true;
      },
    );

    final url = process.flutterAppUrl;
    if (url != null) {
      log.info('${runtime.app.name} running at $url');
      onReady(runtime.app, url);
    }

    await log.progress(
      'Connecting to ${runtime.app.name} VM service',
      () async {
        await process.connectToVmService(
          timeout: device == flutterDeviceWebServer
              ? null
              : const Duration(seconds: 30),
        );
        if (process.isVmServiceConnected) {
          await onStart(runtime.app, process);
        }
        return process.isVmServiceConnected;
      },
    );
  }
}

class _AppRuntime {
  _AppRuntime({
    required this.app,
    required this.proxy,
    required this.infoFile,
  });

  final FlutterAppConfig app;
  final VmServiceProxy proxy;
  final String infoFile;
  FlutterProcess? process;
  FlutterDependencyTracker? dependencyTracker;
  bool spawnInFlight = false;
  bool relaunchInProgress = false;
}
