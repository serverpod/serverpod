import 'dart:io';

import 'package:package_config/package_config.dart' as pc;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/native_assets_builder.dart';
import 'package:test/test.dart';

import '../../test_util/file_system_entity_helpers.dart';

void main() {
  group('Given a project with no packages that have build hooks', () {
    late Directory tempDir;
    late NativeAssetsBuilder builder;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'native_assets_builder_test_',
      );
      await _createMinimalDartProject(tempDir.path);
      builder = NativeAssetsBuilder(
        dartExecutable: _dartExecutable(),
        serverDir: tempDir.path,
        outputDir: p.join(tempDir.path, '.dart_tool', 'serverpod', 'na'),
      );
    });

    tearDown(() async {
      await tempDir.deleteWithRetry(recursive: true);
    });

    test(
      'when build is called, '
      'then it returns NativeAssetsBuildSkipped',
      () async {
        final outcome = await builder.build();
        expect(outcome, isA<NativeAssetsBuildSkipped>());
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when build is called, '
      'then no manifest yaml is written',
      () async {
        await builder.build();
        expect(File(builder.manifestPath).existsSync(), isFalse);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when build is called twice, '
      'then both calls succeed without error',
      () async {
        final first = await builder.build();
        final second = await builder.build();
        expect(first, isA<NativeAssetsBuildSkipped>());
        expect(second, isA<NativeAssetsBuildSkipped>());
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });

  group('Given a workspace with the server as a member package', () {
    late Directory tempDir;
    late NativeAssetsBuilder builder;
    late String serverDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'native_assets_builder_workspace_test_',
      );
      serverDir = p.join(tempDir.path, 'server');
      await _createWorkspaceProject(
        rootDir: tempDir.path,
        memberDir: serverDir,
      );
      builder = NativeAssetsBuilder(
        dartExecutable: _dartExecutable(),
        serverDir: serverDir,
        outputDir: p.join(serverDir, '.dart_tool', 'serverpod', 'na'),
      );
    });

    tearDown(() async {
      await tempDir.deleteWithRetry(recursive: true);
    });

    test(
      'when discoverProjectRoot is called from the member dir, '
      'then it walks up to the workspace root',
      () async {
        final root = await builder.discoverProjectRoot();

        expect(
          p.equals(root, tempDir.path),
          isTrue,
          reason:
              'Project root should be the workspace root, not the member '
              'dir. Got: $root',
        );
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });

  group(
    'Given a project with a build hook that emits no assets',
    () {
      late Directory tempDir;
      late NativeAssetsBuilder builder;

      setUp(() async {
        tempDir = await Directory.systemTemp.createTemp(
          'native_assets_builder_hook_test_',
        );
        await _createProjectWithBuildHook(
          dir: tempDir.path,
          hookBody: '// No assets emitted.',
        );
        builder = NativeAssetsBuilder(
          dartExecutable: _dartExecutable(),
          serverDir: tempDir.path,
          outputDir: p.join(tempDir.path, '.dart_tool', 'serverpod', 'na'),
        );
      });

      tearDown(() async {
        await tempDir.deleteWithRetry(recursive: true);
      });

      test(
        'when build is called, '
        'then it returns NativeAssetsBuildSuccess with no manifest',
        () async {
          final outcome = await builder.build();

          expect(outcome, isA<NativeAssetsBuildSuccess>());
          final success = outcome as NativeAssetsBuildSuccess;
          expect(
            success.manifestPath,
            isNull,
            reason:
                'A hook that emits no assets should produce no manifest yaml. '
                'manifestChanged=${success.manifestChanged}',
          );
          expect(File(builder.manifestPath).existsSync(), isFalse);
        },
        timeout: const Timeout(Duration(minutes: 2)),
      );

      test(
        'when build is called twice, '
        'then the second call reports the manifest as unchanged',
        () async {
          await builder.build();
          final second = await builder.build();

          expect(second, isA<NativeAssetsBuildSuccess>());
          expect((second as NativeAssetsBuildSuccess).manifestChanged, isFalse);
        },
        timeout: const Timeout(Duration(minutes: 2)),
      );
    },
    skip: Platform.isWindows
        ? 'hooks_runner subprocesses keep .dart_tool handles open on Windows '
              'long enough to race tearDown — see CI run 25155561001'
        : null,
  );
}

/// Creates a Dart workspace at [rootDir] with one member at [memberDir].
/// `.dart_tool/` lives only at the workspace root, matching real pub layout.
Future<void> _createWorkspaceProject({
  required String rootDir,
  required String memberDir,
}) async {
  final relMember = p.relative(memberDir, from: rootDir);

  await Directory('$rootDir/.dart_tool').create(recursive: true);
  await Directory(memberDir).create(recursive: true);

  await File('$rootDir/pubspec.yaml').writeAsString('''
name: test_workspace
environment:
  sdk: ^3.8.0
workspace:
  - $relMember
''');

  await File('$memberDir/pubspec.yaml').writeAsString('''
name: test_server
environment:
  sdk: ^3.8.0
resolution: workspace
''');

  await File('$rootDir/.dart_tool/package_config.json').writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "test_workspace",
      "rootUri": "..",
      "packageUri": "lib/"
    },
    {
      "name": "test_server",
      "rootUri": "../$relMember",
      "packageUri": "lib/"
    }
  ]
}
''');

  await File('$rootDir/.dart_tool/package_graph.json').writeAsString('''
{
  "roots": ["test_workspace", "test_server"],
  "packages": [
    {
      "name": "test_workspace",
      "version": "1.0.0",
      "dependencies": [],
      "devDependencies": []
    },
    {
      "name": "test_server",
      "version": "1.0.0",
      "dependencies": [],
      "devDependencies": []
    }
  ],
  "configVersion": 1
}
''');
}

/// Creates a minimal Dart project with `pubspec.yaml` and a
/// `package_config.json` that has no packages with `hook/` directories. This
/// is the smallest input the hook runner accepts.
Future<void> _createMinimalDartProject(String dir) async {
  await Directory('$dir/.dart_tool').create(recursive: true);

  await File('$dir/pubspec.yaml').writeAsString('''
name: test_server
environment:
  sdk: ^3.0.0
''');

  await File('$dir/.dart_tool/package_config.json').writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "test_server",
      "rootUri": "..",
      "packageUri": "lib/"
    }
  ]
}
''');

  // hooks_runner asserts this file exists alongside package_config.json.
  await File('$dir/.dart_tool/package_graph.json').writeAsString('''
{
  "roots": ["test_server"],
  "packages": [
    {
      "name": "test_server",
      "version": "1.0.0",
      "dependencies": [],
      "devDependencies": []
    }
  ],
  "configVersion": 1
}
''');
}

/// Creates a Dart project at [dir] whose `hook/build.dart` calls
/// `package:hooks` build with [hookBody] inserted into the closure.
///
/// Builds a `package_config.json` that points at `package:hooks` and its
/// transitive dependencies via the host test runner's already-resolved
/// package_config - which is the only way to compile the hook without
/// shelling out to `dart pub get` (and without making the test depend on
/// network access).
Future<void> _createProjectWithBuildHook({
  required String dir,
  required String hookBody,
}) async {
  await Directory(p.join(dir, '.dart_tool')).create(recursive: true);
  await Directory(p.join(dir, 'hook')).create(recursive: true);

  await File(p.join(dir, 'pubspec.yaml')).writeAsString('''
name: test_server
environment:
  sdk: ^3.10.0
dependencies:
  hooks: ^1.0.0
''');

  await File(p.join(dir, 'hook', 'build.dart')).writeAsString('''
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    $hookBody
  });
}
''');

  // Inherit every package from the test runner's own package_config.json so
  // `package:hooks` and its full transitive dep tree (yaml, pub_semver,
  // record_use, meta, ...) resolve without `dart pub get`. The hook only
  // imports `package:hooks`; the extras are harmless on the lookup path.
  final hostConfig = await pc.findPackageConfig(Directory.current);
  if (hostConfig == null) {
    throw StateError(
      'Could not locate the host package_config.json from '
      '${Directory.current.path}. Run `dart pub get` first.',
    );
  }

  // Sanity-check that the host has hooks resolved. If this fails the test
  // won't compile the hook, so a clear error here beats the kernel-compile
  // mess downstream.
  if (!hostConfig.packages.any((p) => p.name == 'hooks')) {
    throw StateError(
      'Host package_config.json does not include `hooks`; '
      'run `dart pub get` in the serverpod_cli package.',
    );
  }

  final entries = <Map<String, Object?>>[
    {
      'name': 'test_server',
      'rootUri': '../',
      'packageUri': 'lib/',
      'languageVersion': '3.10',
    },
    for (final pkg in hostConfig.packages)
      {
        'name': pkg.name,
        'rootUri': pkg.root.toString(),
        'packageUri': 'lib/',
        'languageVersion': pkg.languageVersion?.toString() ?? '3.0',
      },
  ];

  await File(p.join(dir, '.dart_tool', 'package_config.json')).writeAsString(
    '{\n'
    '  "configVersion": 2,\n'
    '  "packages": [\n'
    '${entries.map(_encodeEntry).join(',\n')}\n'
    '  ]\n'
    '}\n',
  );

  // hooks_runner only requires that this file exists alongside
  // package_config.json; the contents are not used to drive hook compilation.
  await File(p.join(dir, '.dart_tool', 'package_graph.json')).writeAsString('''
{
  "roots": ["test_server"],
  "packages": [
    {
      "name": "test_server",
      "version": "1.0.0",
      "dependencies": ["hooks"],
      "devDependencies": []
    }
  ],
  "configVersion": 1
}
''');
}

String _encodeEntry(Map<String, Object?> entry) {
  final fields = entry.entries
      .map((e) => '      "${e.key}": "${e.value}"')
      .join(',\n');
  return '    {\n$fields\n    }';
}

/// Resolves the dart executable from the SDK currently running these tests.
String _dartExecutable() {
  final exe = Platform.resolvedExecutable;
  // When tests run under `dart test`, resolvedExecutable is dart itself.
  // When run under dartaotruntime (e.g. via the AOT serverpod CLI), prefer
  // the sibling `dart` binary in the same SDK bin directory.
  if (p.basenameWithoutExtension(exe) == 'dart') return exe;
  final dir = p.dirname(exe);
  return p.join(dir, Platform.isWindows ? 'dart.exe' : 'dart');
}
