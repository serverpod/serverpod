import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'interprocess_lock.dart';
import 'sdk_path.dart';

/// Locates the serverpod repository root: walks up from [from] (defaults to
/// the current directory) until `tools/serverpod_cli` is found.
///
/// For the serverpod repository's own test suites. The suites sit at varying
/// depths (e.g. `tests/serverpod_test_server` is two levels below the root
/// but the SQLite server is three), so a fixed number of `..` segments would
/// point at the wrong directory.
String findServerpodHome({Directory? from}) {
  final start = (from ?? Directory.current).absolute;
  for (var dir = start; ; dir = dir.parent) {
    if (Directory(p.join(dir.path, 'tools', 'serverpod_cli')).existsSync()) {
      return p.canonicalize(dir.path);
    }
    if (dir.parent.path == dir.path) {
      throw StateError(
        'Could not locate the serverpod repository root: no '
        'tools/serverpod_cli directory found above ${start.path}.',
      );
    }
  }
}

/// Builds the serverpod repository's in-repo CLI once and returns the path
/// to the executable (`<buildRoot>/bundle/bin/serverpod_cli`).
///
/// For the repository's own test suites, which run the CLI without a
/// globally activated `serverpod`:
/// - A prebuilt bundle is reused when `SERVERPOD_CLI_EXE` points at one
///   (CI's build_cli job builds the CLI once for the whole workflow).
/// - [buildRoot] defaults to a directory under the system temp directory
///   named by a hash of the CLI's sources (see [serverpodCliSourceHash]), so
///   every process and run building the same sources reuses one build.
/// - One build per [buildRoot]: concurrent callers elect a single builder via
///   a lock; the rest wait and reuse its output. The build lands in
///   [buildRoot] by a rename, so an existing executable is always complete.
/// - Builds against one checkout are serialized across runs (a second lock,
///   keyed on the checkout): `dart pub get` and the compile both touch the
///   shared tools/serverpod_cli/.dart_tool.
Future<String> buildServerpodCli({
  String? buildRoot,
  String? serverpodHome,
}) async {
  final prebuilt = Platform.environment['SERVERPOD_CLI_EXE'];
  if (prebuilt != null && File(prebuilt).existsSync()) return prebuilt;

  final home = serverpodHome ?? findServerpodHome();
  final cliRoot = p.join(home, 'tools', 'serverpod_cli');
  final root =
      buildRoot ??
      p.join(
        Directory.systemTemp.path,
        'serverpod_cli_build',
        serverpodCliSourceHash(home),
      );
  final exePath = _exePathIn(root);
  if (File(exePath).existsSync()) return exePath;

  Directory(p.dirname(root)).createSync(recursive: true);
  await InterProcessLock.withLock(
    '$root.lock',
    staleWhen: const StaleLockPolicy.processLiveness(
      staleAfter: Duration(minutes: 2),
    ),
    timeout: const Duration(minutes: 10),
    heartbeatInterval: const Duration(seconds: 30),
    () async {
      if (File(exePath).existsSync()) return;

      await InterProcessLock.withLock(
        _treeBuildLockPath(cliRoot),
        staleWhen: const StaleLockPolicy.processLiveness(
          staleAfter: Duration(minutes: 2),
        ),
        timeout: const Duration(minutes: 10),
        heartbeatInterval: const Duration(seconds: 30),
        () async {
          var result = await Process.run(dartExecutablePath, [
            'pub',
            'get',
          ], workingDirectory: cliRoot);
          if (result.exitCode != 0) {
            throw StateError(
              'pub get in $cliRoot failed:'
              '\n${result.stdout}\n${result.stderr}',
            );
          }

          final staging = Directory('$root.$pid');
          if (staging.existsSync()) staging.deleteSync(recursive: true);
          // `dart build cli` (not `dart compile exe`): serverpod_cli pulls
          // sqlite3, whose native-asset build hooks `dart compile exe`
          // rejects.
          result = await Process.run(dartExecutablePath, [
            'build',
            'cli',
            '-t',
            p.join(cliRoot, 'bin', 'serverpod_cli.dart'),
            '-o',
            staging.path,
          ], workingDirectory: cliRoot);
          if (result.exitCode != 0) {
            throw StateError(
              'dart build cli failed:\n${result.stdout}\n${result.stderr}',
            );
          }

          final stale = Directory(root);
          if (stale.existsSync()) stale.deleteSync(recursive: true);
          staging.renameSync(root);
        },
      );
    },
  );

  return exePath;
}

String _exePathIn(String buildRoot) => p.join(
  buildRoot,
  'bundle',
  'bin',
  Platform.isWindows ? 'serverpod_cli.exe' : 'serverpod_cli',
);

/// A hash of what the in-repo CLI of the serverpod repository at
/// [serverpodHome] is built from.
///
/// Covers the Dart SDK version, the resolved version of every package the
/// CLI depends on, and the `pubspec.yaml`, `bin/`, `hook/` and `lib/` files
/// of every package in the repository among them, `serverpod_cli`
/// included. Checkouts with the same sources get the same hash. Reads the workspace's `.dart_tool/package_config.json` and
/// `.dart_tool/package_graph.json`.
String serverpodCliSourceHash(String serverpodHome) {
  final dartTool = p.join(serverpodHome, '.dart_tool');
  final config =
      jsonDecode(
            File(p.join(dartTool, 'package_config.json')).readAsStringSync(),
          )
          as Map<String, dynamic>;
  final graph =
      jsonDecode(
            File(p.join(dartTool, 'package_graph.json')).readAsStringSync(),
          )
          as Map<String, dynamic>;

  final rootUris = {
    for (final package
        in (config['packages'] as List).cast<Map<String, dynamic>>())
      package['name'] as String: Uri.directory(
        dartTool,
      ).resolve(package['rootUri'] as String),
  };
  final dependencies = {
    for (final package
        in (graph['packages'] as List).cast<Map<String, dynamic>>())
      package['name'] as String: (package['dependencies'] as List)
          .cast<String>(),
  };

  final closure = <String>{};
  void visit(String name) {
    if (!closure.add(name)) return;
    dependencies[name]?.forEach(visit);
  }

  visit('serverpod_cli');

  final output = _DigestSink();
  final input = sha256.startChunkedConversion(output)
    ..add(utf8.encode('${Platform.version}\n'));
  for (final name in closure.toList()..sort()) {
    final rootUri = rootUris[name];
    if (rootUri == null) {
      throw StateError('Package $name is missing from $dartTool.');
    }
    final root = p.fromUri(rootUri);
    if (!p.isWithin(serverpodHome, root)) {
      input.add(utf8.encode('$name $rootUri\n'));
      continue;
    }
    input.add(utf8.encode('$name ${p.relative(root, from: serverpodHome)}\n'));

    final files = [
      File(p.join(root, 'pubspec.yaml')),
      for (final dir in ['bin', 'hook', 'lib'])
        if (Directory(p.join(root, dir)).existsSync())
          ...Directory(
            p.join(root, dir),
          ).listSync(recursive: true).whereType<File>(),
    ]..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      input
        ..add(utf8.encode('${p.relative(file.path, from: root)}\n'))
        ..add(file.readAsBytesSync());
    }
  }
  input.close();
  return output.digest.toString().substring(0, 16);
}

class _DigestSink implements Sink<Digest> {
  late Digest digest;

  @override
  void add(Digest data) => digest = data;

  @override
  void close() {}
}

/// Lock serializing CLI builds against one checkout, shared by every run in
/// that tree (the per-run build locks are keyed on their build roots and so
/// do not exclude each other).
String _treeBuildLockPath(String cliRoot) {
  final key = cliRoot.replaceAll(RegExp('[^a-zA-Z0-9]'), '_');
  return p.join(Directory.systemTemp.path, 'serverpod_cli_build_$key.lock');
}
