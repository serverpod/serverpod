import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:data_assets/data_assets.dart';
import 'package:file/local.dart';
import 'package:hooks/hooks.dart';
// hooks_runner requires a `Logger` (from package:logging) on its constructor.
// We import the type only to satisfy the API and route every record through
// the serverpod CLI [log]; there are no log calls of our own against it.
import 'package:hooks_runner/hooks_runner.dart' as hr;
import 'package:logging/logging.dart' show Level, Logger, LogRecord;
import 'package:package_config/package_config.dart' as pc;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/vendored/native_assets_bundling.dart';

const _fileSystem = LocalFileSystem();

/// Outcome of a [NativeAssetsBuilder.build] invocation.
sealed class NativeAssetsBuildOutcome {
  const NativeAssetsBuildOutcome();
}

/// The project has no packages with native build hooks; nothing to do.
class NativeAssetsBuildSkipped extends NativeAssetsBuildOutcome {
  const NativeAssetsBuildSkipped();
}

/// The build ran (possibly cached). [manifestPath] is the path to the
/// `native_assets.yaml` to pass to `frontend_server` via `--native-assets`,
/// or `null` if the build produced no bundleable assets.
///
/// [manifestChanged] is `true` when the manifest content differs from the
/// previous successful build (or this is the first build). Callers should
/// restart `frontend_server` with the new manifest when this is `true`.
class NativeAssetsBuildSuccess extends NativeAssetsBuildOutcome {
  final String? manifestPath;
  final bool manifestChanged;

  const NativeAssetsBuildSuccess({
    required this.manifestPath,
    required this.manifestChanged,
  });
}

/// The build failed. [message] contains a short, user-facing summary; full
/// hook logs are emitted via the serverpod CLI logger as the build runs.
class NativeAssetsBuildFailed extends NativeAssetsBuildOutcome {
  final String message;
  const NativeAssetsBuildFailed(this.message);
}

/// Outcome of [NativeAssetsBuilder.applyTo].
sealed class NativeAssetsApplyOutcome {
  const NativeAssetsApplyOutcome();
}

/// Hooks ran (or were skipped) and the manifest is up to date on [compiler].
/// [restarted] is `true` when the builder restarted [KernelCompiler] because
/// the manifest changed; the caller should treat the next compile as a full
/// one.
class NativeAssetsApplySuccess extends NativeAssetsApplyOutcome {
  final bool restarted;
  const NativeAssetsApplySuccess({this.restarted = false});
}

/// Hooks failed; [message] is a short, user-facing summary.
class NativeAssetsApplyFailure extends NativeAssetsApplyOutcome {
  final String message;
  const NativeAssetsApplyFailure(this.message);
}

/// Walks up from [fromDir] to the first pubspec that is *not* a workspace
/// member (i.e. `resolution != 'workspace'`). The directory containing that
/// pubspec is either the workspace root (when a workspace is in use) or the
/// package itself (when it isn't); pub places `.dart_tool/` only there, so its
/// `package_config.json` is the one the Frontend Server resolves for the
/// server package.
///
/// Validates that `package_config.json` and `package_graph.json` exist
/// alongside the pubspec, so callers can trust the returned root without
/// re-checking.
Future<String> discoverProjectRootFrom(String fromDir) async {
  var dir = p.canonicalize(fromDir);
  while (true) {
    final pubspec = await tryParsePubspecAt(dir);
    if (pubspec != null && pubspec.resolution != 'workspace') {
      final cfg = p.join(dir, '.dart_tool', 'package_config.json');
      final graph = p.join(dir, '.dart_tool', 'package_graph.json');
      if (!await File(cfg).exists() || !await File(graph).exists()) {
        throw StateError(
          'Found project root at $dir but its .dart_tool is missing '
          'package_config.json / package_graph.json. Run `dart pub get`.',
        );
      }
      return dir;
    }
    final parent = p.dirname(dir);
    if (parent == dir) {
      throw StateError(
        'No project root pubspec found walking up from $fromDir. '
        'Server packages with `resolution: workspace` need a workspace '
        'root pubspec above them.',
      );
    }
    dir = parent;
  }
}

/// The subset of [NativeAssetsBuilder] that [WatchSession] drives, factored out
/// so the session can be exercised with a fake in tests. [NativeAssetsBuilder]
/// is the only production implementation.
abstract interface class NativeAssetsApplier {
  /// Runs build hooks and applies the result to [compiler]. See
  /// [NativeAssetsBuilder.applyTo].
  Future<NativeAssetsApplyOutcome> applyTo(KernelCompiler compiler);

  /// Drops cached package-discovery state so the next apply re-reads
  /// `package_config.json`. See [NativeAssetsBuilder.reset].
  void reset();
}

/// Orchestrates `package:hooks_runner` on behalf of `serverpod start`.
///
/// `dart compile` refuses to run build hooks, and `frontend_server` does not
/// know how to find them - they live outside the kernel-compile pipeline.
/// This class fills that gap: invoke [build] once before each
/// `frontend_server` compile cycle, then feed [NativeAssetsBuildSuccess.manifestPath]
/// to `frontend_server` via `--native-assets`.
///
/// Hook execution is internally cached by `hooks_runner` keyed on hook
/// inputs/dependencies/environment, so re-invoking each watch cycle is cheap
/// when nothing changed.
class NativeAssetsBuilder implements NativeAssetsApplier {
  /// Path to the dart executable (used to compile and run individual hooks).
  final String dartExecutable;

  /// The server package directory. Its own `pubspec.yaml` is read to name the
  /// root package; [projectRoot] (not necessarily this directory) holds the
  /// `package_config.json`.
  final String serverDir;

  /// The resolution root whose `.dart_tool/` holds the `package_config.json` /
  /// `package_graph.json` (the workspace root, or [serverDir] when standalone).
  /// Resolved once by the caller via [discoverProjectRootFrom] and passed in,
  /// so the walk is not repeated here. Stable for the builder's lifetime.
  final String projectRoot;

  /// Output directory for the assets and the manifest yaml (typically
  /// `<serverDir>/.dart_tool/serverpod/native_assets/`).
  final String outputDir;

  Future<hr.PackageLayout>? _packageLayoutFuture;
  Future<hr.NativeAssetsBuildRunner>? _runnerFuture;
  String? _lastManifestContent;
  List<EncodedAsset>? _lastEncodedAssets;

  /// Bridges `hooks_runner`'s `Logger` records into the serverpod CLI [log].
  /// Detached so it never escapes into the global `package:logging` hierarchy.
  late final Logger _logger = Logger.detached('hooks_runner')
    ..onRecord.listen(_forwardLogRecord);

  NativeAssetsBuilder({
    required this.dartExecutable,
    required this.serverDir,
    required this.projectRoot,
    required this.outputDir,
  });

  /// Path of the manifest yaml this builder writes (whether or not it has
  /// been written yet).
  String get manifestPath => p.join(outputDir, 'native_assets.yaml');

  /// Drops the cached package layout and build runner so the next [build]
  /// re-reads `package_config.json` and re-discovers build-hook packages. Call
  /// after a `pub get` or other change that adds or removes packages with build
  /// hooks. ([projectRoot] is stable and not re-resolved.)
  ///
  /// The manifest/encoded-asset caches are deliberately kept: the next [build]
  /// re-runs the hooks and compares its result to them, so a dependency change
  /// that leaves the native assets unchanged still reports
  /// `manifestChanged: false` and avoids a needless FES restart.
  @override
  void reset() {
    _packageLayoutFuture = null;
    _runnerFuture = null;
  }

  Future<hr.PackageLayout> _loadPackageLayout() async {
    final pkgConfigUri = Uri.file(
      p.join(projectRoot, '.dart_tool', 'package_config.json'),
    );

    // Run the package_config load and the server pubspec read in parallel.
    final (packageConfig, serverPubspec) = await (
      pc.loadPackageConfigUri(pkgConfigUri),
      tryParsePubspecAt(serverDir),
    ).wait;
    if (serverPubspec == null) {
      throw StateError('Could not parse pubspec.yaml in $serverDir');
    }

    return hr.PackageLayout.fromPackageConfig(
      _fileSystem,
      packageConfig,
      pkgConfigUri,
      serverPubspec.name,
      includeDevDependencies: false,
    );
  }

  Future<hr.NativeAssetsBuildRunner> _createRunner() async {
    final layout = await (_packageLayoutFuture ??= _loadPackageLayout());
    return hr.NativeAssetsBuildRunner(
      dartExecutable: Uri.file(dartExecutable),
      logger: _logger,
      fileSystem: _fileSystem,
      packageLayout: layout,
      userDefines: hr.UserDefines(
        workspacePubspec: Uri.file(p.join(projectRoot, 'pubspec.yaml')),
      ),
    );
  }

  /// Runs build hooks for the server package and its transitive dependencies.
  Future<NativeAssetsBuildOutcome> build() async {
    final runner = await (_runnerFuture ??= _createRunner());

    final hookPackages = await runner.packagesWithBuildHooks();
    if (hookPackages.isEmpty) {
      // No build-hook packages in the closure. If a manifest was produced
      // earlier this session - i.e. the last native dependency was just removed
      // - tear it down and report the change so the FES restarts without
      // `--native-assets`; otherwise the running pod keeps loading the removed
      // package's stale assets. With no prior manifest there is nothing to do.
      if (_lastManifestContent == null) return const NativeAssetsBuildSkipped();
      return _dropManifest();
    }

    final target = hr.Target.current;
    final extensions = <ProtocolExtension>[
      CodeAssetExtension(
        targetOS: target.os,
        linkModePreference: LinkModePreference.dynamic,
        targetArchitecture: target.architecture,
        macOS: target.os == OS.macOS
            ? MacOSCodeConfig(targetVersion: _minMacOSVersion)
            : null,
      ),
      DataAssetsExtension(),
    ];

    final result = await runner.build(
      extensions: extensions,
      linkingEnabled: false,
    );
    if (result.isFailure) {
      return NativeAssetsBuildFailed(
        'Native build hooks failed for: ${hookPackages.join(', ')}',
      );
    }

    final encodedAssets = result.success.encodedAssets;

    // Hooks ran but produced no bundleable assets -> no manifest needed. Tell
    // the caller to ensure the FES is running without a --native-assets arg.
    if (encodedAssets.isEmpty) {
      return _dropManifest();
    }

    // hooks_runner caches build results internally, so the encoded asset list
    // is the same object-graph when nothing changed. Skip the bundle step
    // entirely in that case - it would otherwise re-copy dylibs and re-run
    // install_name_tool / codesign on macOS for every reload cycle.
    if (_lastEncodedAssets != null &&
        _encodedAssetsEq.equals(_lastEncodedAssets!, encodedAssets)) {
      return NativeAssetsBuildSuccess(
        manifestPath: manifestPath,
        manifestChanged: false,
      );
    }

    await Directory(outputDir).create(recursive: true);
    final kernelAssets = await bundleNativeAssets(
      encodedAssets,
      target,
      Directory(outputDir).uri,
      relocatable: false,
    );

    const header =
        '# Native assets mapping for host OS in JIT mode.\n'
        '# Generated by serverpod_cli and package:hooks_runner.\n';
    final newContent = '$header\n${kernelAssets.toNativeAssetsFile()}';

    final changed = _lastManifestContent != newContent;
    if (changed) {
      final manifestFile = File(manifestPath);
      await manifestFile.create(recursive: true);
      await manifestFile.writeAsString(newContent);
    }
    _lastManifestContent = newContent;
    _lastEncodedAssets = List.unmodifiable(encodedAssets);

    return NativeAssetsBuildSuccess(
      manifestPath: manifestPath,
      manifestChanged: changed,
    );
  }

  /// Tears down any previously built manifest: clears the cached state and
  /// deletes the on-disk yaml, returning a success that tells the caller to drop
  /// the FES `--native-assets` argument. [NativeAssetsBuildSuccess.manifestChanged]
  /// reflects whether a manifest existed before, so the caller restarts the FES
  /// only when something actually went away. Shared by the "no build-hook
  /// packages left" and "hooks emitted nothing" paths.
  Future<NativeAssetsBuildSuccess> _dropManifest() async {
    final changed = _lastManifestContent != null;
    _lastManifestContent = null;
    _lastEncodedAssets = const [];
    // Best-effort cleanup of a stale manifest from a prior run. Avoid
    // exists() + delete() (TOCTOU); just delete and ignore "not found".
    try {
      await File(manifestPath).delete();
    } on PathNotFoundException {
      // Already gone.
    }
    return NativeAssetsBuildSuccess(
      manifestPath: null,
      manifestChanged: changed,
    );
  }

  /// Runs build hooks and applies the result to [compiler]:
  ///  - `nativeAssetsPath` is updated to the freshly built manifest (if any)
  ///  - if the manifest content changed AND [compiler] has already started,
  ///    restarts the FES so the new `--native-assets` value takes effect
  ///
  /// Centralises the "did we restart?" bookkeeping that callers in the watch
  /// loop and migration path need to avoid double-restarting.
  @override
  Future<NativeAssetsApplyOutcome> applyTo(KernelCompiler compiler) async {
    final outcome = await build();
    switch (outcome) {
      case NativeAssetsBuildSkipped():
        return const NativeAssetsApplySuccess();
      case NativeAssetsBuildFailed(:final message):
        return NativeAssetsApplyFailure(message);
      case NativeAssetsBuildSuccess(
        :final manifestPath,
        :final manifestChanged,
      ):
        if (!manifestChanged) return const NativeAssetsApplySuccess();
        compiler.nativeAssetsPath = manifestPath;
        if (!compiler.isStarted) return const NativeAssetsApplySuccess();
        await compiler.restart();
        return const NativeAssetsApplySuccess(restarted: true);
    }
  }
}

const _encodedAssetsEq = ListEquality<EncodedAsset>();

/// Minimum macOS deployment target. Matches dartdev's default for hosts that
/// only ever build for the current machine, so hooks compile against the same
/// floor as `dart run`.
const _minMacOSVersion = 13;

/// Routes a single `hooks_runner` log record into the serverpod CLI logger.
///
/// Demotes `INFO` to `debug`: hooks_runner emits the full input/output JSON
/// for every hook invocation at INFO level (build_runner.dart:638, 991,
/// 1031), which is too verbose for normal use. Real user-facing messages are
/// emitted at WARNING/SEVERE.
void _forwardLogRecord(LogRecord rec) {
  final v = rec.level.value;
  if (v >= Level.SEVERE.value) {
    log.error(rec.message);
  } else if (v >= Level.WARNING.value) {
    log.warning(rec.message);
  } else {
    log.debug(rec.message);
  }
}
