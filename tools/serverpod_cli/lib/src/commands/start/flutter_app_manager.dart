import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/flutter_dependency_tracker.dart';
import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
import 'package:serverpod_cli/src/commands/start/flutter_process.dart';
import 'package:serverpod_cli/src/commands/start/package_dependency_tracker.dart';
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
    required this.serverpodToolDir,
    required this.runMode,
    required this.onProgress,
    required this.onReady,
    required this.onStart,
    required this.onStop,
    required this.onLaunchFailed,
    required this.onEnsureAppTab,
    required this.onLog,
    required this.stdoutSinkFor,
    required this.stderrSinkFor,
    required this.serverPubspecFile,
    required this.serverPackageDirectoryPathParts,
    required this.projectName,
    required this.launchFlutterApp,
    this.flutterExecutableForTesting,
    this.argsOverrideForTesting,
  });

  /// Test-only override for the `flutter` executable path.
  final String? flutterExecutableForTesting;

  /// Test-only override for `flutter run` arguments per app.
  final List<String>? Function(FlutterAppConfig app)? argsOverrideForTesting;

  /// Test-only override for [checkDependencyChange].
  @visibleForTesting
  PackageDependencyChange Function(String appId)?
  dependencyChangeOverrideForTesting;

  /// Test-only override for [restart].
  @visibleForTesting
  Future<void> Function(String appId)? restartOverrideForTesting;

  /// Test-only override for [launch].
  @visibleForTesting
  Future<void> Function(String appId)? launchOverrideForTesting;

  /// When set, IDE-attach auto-launch (the `onWaitingClientArrived` proxy
  /// callback) routes through this instead of calling [launch] directly. Read
  /// lazily when a client attaches, so it can be assigned after [initialize]
  /// (e.g. once the owning session exists); a client arriving before then
  /// falls back to [launch].
  FutureOr<void> Function(String appId)? launchOnWaitingClient;

  final String serverpodToolDir;
  final String runMode;
  final void Function(FlutterAppConfig app, String stage) onProgress;

  /// Fires once per launch when the app is up: on the published web URL
  /// for web devices, or on the daemon's `app.started` event otherwise
  /// ([url] is null when the device publishes no URL).
  final void Function(FlutterAppConfig app, String? url) onReady;
  final Future<void> Function(FlutterAppConfig app, FlutterProcess process)
  onStart;
  final void Function(FlutterAppConfig app) onStop;
  final void Function(FlutterAppConfig app) onLaunchFailed;
  final void Function(FlutterAppConfig app) onEnsureAppTab;
  final void Function(FlutterAppConfig app, FlutterLogEvent event) onLog;
  final IOSink Function(FlutterAppConfig app) stdoutSinkFor;
  final IOSink Function(FlutterAppConfig app) stderrSinkFor;

  /// The server's `pubspec.yaml`, used to fingerprint the `flutter_apps`
  /// config and detect changes without re-parsing on every file event.
  final File serverPubspecFile;
  final List<String> serverPackageDirectoryPathParts;
  final String projectName;
  final bool launchFlutterApp;

  String? _cachedFlutterAppsFingerprint;

  final List<FlutterAppConfig> _apps = [];
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

  /// DTD URIs of running apps, keyed by app id. A running app that has not
  /// published its DTD URI yet maps to `null`. Stopped apps are omitted - this
  /// backs the `get_flutter_app_dtd` MCP tool, so stopping an app drops it from
  /// the tool's output.
  Map<String, String?> get dtdUris => {
    for (final appId in runningAppIds) appId: processFor(appId)?.dtdUri,
  };

  /// Returns the [FlutterProcess] for [appId], if any.
  FlutterProcess? processFor(String appId) => _runtimes[appId]?.process;

  /// Whether [appId] has a running Flutter process.
  bool isRunning(String appId) => processFor(appId)?.isRunning ?? false;

  /// Whether [appId] is starting up (spawn through the ready signal).
  bool isLaunching(String appId) {
    final runtime = _runtimeFor(appId);
    if (runtime == null) return false;
    if (runtime.spawnInFlight) return true;
    final process = runtime.process;
    if (process == null || !process.isRunning) return false;
    return !runtime.readySignaled;
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
  PackageDependencyChange checkDependencyChange(String appId) {
    if (dependencyChangeOverrideForTesting != null) {
      return dependencyChangeOverrideForTesting!(appId);
    }
    return _runtimes[appId]?.dependencyTracker?.refresh() ??
        PackageDependencyChange.none;
  }

  /// Checks whether the `serverpod: flutter_apps:` section of the server's
  /// `pubspec.yaml` has changed since the last check. Returns `true` when the
  /// fingerprint differs, meaning the Flutter app config should be reloaded.
  bool hasServerFlutterAppsChanged() {
    final fingerprint = computeFlutterAppsFingerprint(serverPubspecFile);
    final changed = fingerprint != _cachedFlutterAppsFingerprint;
    _cachedFlutterAppsFingerprint = fingerprint;
    return changed;
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
    await loadApps();
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
    runtime.readySignaled = false;
    final isRelaunch = runtime.relaunchInProgress;
    runtime.relaunchInProgress = false;

    onEnsureAppTab(runtime.app);

    final device = runtime.app.device ?? flutterDeviceWebServerWithBrowser;

    late final FlutterProcess process;
    process = FlutterProcess(
      flutterPackageDir: p.joinAll(runtime.app.pathParts),
      device: device,
      extraArgs: runtime.app.extraRunArgs,
      flutterProxy: runtime.proxy,
      flutterExecutable: flutterExecutableForTesting ?? 'flutter',
      machineArgsOverride: argsOverrideForTesting?.call(runtime.app),
      stdoutSink: stdoutSinkFor(runtime.app),
      stderrSink: stderrSinkFor(runtime.app),
      onLog: (event) => onLog(runtime.app, event),
      onProgress: (stage) {
        onProgress(runtime.app, stage);
        log.info('  ${runtime.app.name}: $stage');
      },
      // The ready signal for non-web devices, which never publish a URL. Web
      // devices publish their URL before `app.started`, so it is carried
      // along here when the URL path has not signaled first.
      onStarted: () => _signalReady(runtime, process.flutterAppUrl),
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

  /// Stops [appId] without relaunching it. No-op when [appId] is unknown or
  /// not running. Unlike [stopAll] this keeps the app's VM-service info file so
  /// it can be relaunched later (e.g. via the launch panel or Ctrl+R).
  Future<void> stop(String appId) async {
    final runtime = _runtimeFor(appId);
    if (runtime == null) return;
    final app = runtime.app;
    runtime.relaunchInProgress = false;
    await runtime.process?.stop();
    runtime.process = null;
    onStop(app);
  }

  /// Loads configured apps from [serverPubspecFile].
  ///
  /// Apps present in the old config but absent in the new one are stopped and
  /// removed. Apps present in the new config but absent in the old one are
  /// initialized (VM-service proxy bound, dependency tracker set up) and
  /// launched if [FlutterAppConfig.autoLaunch] is true. Apps present in both
  /// are kept running but their config is updated.
  Future<void> loadApps() async {
    final newApps = loadFlutterApps(
      serverPubspecFile: serverPubspecFile,
      serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
      projectName: projectName,
    );

    final oldIds = {for (final a in _apps) a.id};
    final newIds = {for (final a in newApps) a.id};

    // Stop and remove apps no longer configured.
    for (final id in oldIds.difference(newIds)) {
      await stop(id);
      await _runtimes[id]?.proxy.close();
      _runtimes.remove(id);
    }

    _apps
      ..clear()
      ..addAll(newApps);

    _cacheFlutterAppsFingerprint();

    // Add newly configured apps or update existing ones.
    for (final app in newApps) {
      final existing = _runtimes[app.id];
      if (existing == null) {
        final infoFile = _infoFileFor(app.id);
        final proxy = await bindFlutterAppProxy(
          infoFile: infoFile,
          onWaitingClientArrived: () {
            final launch = launchOnWaitingClient;
            if (launch != null) return launch(app.id);
            return this.launch(app.id);
          },
        );
        _runtimes[app.id] = _AppRuntime(
          app: app,
          proxy: proxy,
          infoFile: infoFile,
        );
      } else {
        existing.app = app;
      }

      _setupDependencyTracker(app.id);
      if (launchFlutterApp && app.autoLaunch) {
        await launch(app.id);
      }
    }
  }

  /// Stops every running app and removes per-app VM-service info files.
  Future<void> stopAll() async {
    await _runtimes.values.map((runtime) async {
      await runtime.process?.stop();
      runtime.process = null;
      await File(runtime.infoFile).deleteIfExists();
    }).wait;
  }

  /// Closes every proxy and deletes info files.
  Future<void> dispose() async {
    await stopAll();
    await _runtimes.values.map((runtime) => runtime.proxy.close()).wait;
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
      final dartToolDir = PackageDependencyTracker.resolveDartToolDir(
        flutterPackageDir,
        packageName: flutterPackageName,
      );
      if (dartToolDir != null) {
        runtime.dependencyTracker = FlutterDependencyTracker(
          dartToolDir: dartToolDir,
          flutterPackageName: flutterPackageName,
          flutterPackageDir: flutterPackageDir,
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

  void _cacheFlutterAppsFingerprint() {
    _cachedFlutterAppsFingerprint = computeFlutterAppsFingerprint(
      serverPubspecFile,
    );
  }

  /// Invokes [onReady] at most once per launch. Ready has two sources - the
  /// published web URL (web devices) and the daemon's `app.started` event
  /// (non-web devices) - so a second signal is swallowed here.
  void _signalReady(_AppRuntime runtime, String? url) {
    if (runtime.readySignaled) return;
    runtime.readySignaled = true;
    log.info(
      url == null
          ? '${runtime.app.name} is running.'
          : '${runtime.app.name} running at $url',
    );
    onReady(runtime.app, url);
  }

  Future<void> _connectAfterLaunch(
    _AppRuntime runtime,
    FlutterProcess process, {
    required String device,
    required bool isRelaunch,
  }) async {
    final launched = await log.progress(
      isRelaunch
          ? 'Relaunching ${runtime.app.name}'
          : 'Launching ${runtime.app.name} (first run may take 30-60s)',
      () async {
        await process.launched;
        // `launched` also completes when the process exits during the build
        // (e.g. a missing asset in pubspec.yaml), so a published web URL or
        // VM-service URI is what distinguishes a real launch from a failure.
        return process.flutterAppUrl != null || process.vmServiceUri != null;
      },
    );

    if (!launched) {
      final code = await process.exitCode;
      log.warning(
        'Launching ${runtime.app.name} failed (exit code $code). '
        'Check its log for details about the build error.',
      );
      onLaunchFailed(runtime.app);
      return;
    }

    final url = process.flutterAppUrl;
    if (url != null) {
      _signalReady(runtime, url);
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

  FlutterAppConfig app;
  final VmServiceProxy proxy;
  final String infoFile;
  FlutterProcess? process;
  FlutterDependencyTracker? dependencyTracker;
  bool spawnInFlight = false;
  bool relaunchInProgress = false;
  bool readySignaled = false;
}
