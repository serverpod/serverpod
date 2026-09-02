import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

import '../../test_util/file_system_entity_helpers.dart';

void main() {
  setUpAll(() {
    initializeLoggerWith(VoidLogger());
  });

  tearDownAll(() async {
    await closeLogger();
  });

  group('Given a KernelCompiler with a valid Dart project', () {
    late Directory tempDir;
    late KernelCompiler compiler;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'kernel_compiler_test_',
      );
      await _createMinimalDartProject(tempDir.path);
      compiler = KernelCompiler(
        entryPoint: p.join(tempDir.path, 'bin', 'main.dart'),
        outputDill: p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        ),
        packagesPath: p.join(
          tempDir.path,
          '.dart_tool',
          'package_config.json',
        ),
      );
    });

    tearDown(() async {
      await compiler.dispose();
      await tempDir.deleteWithRetry(recursive: true);
    });

    test(
      'when its Dart executable is resolved, '
      'then it is the SDK binary with the extension the platform runs',
      () {
        expect(
          compiler.dartExecutable,
          endsWith(p.join('bin', Platform.isWindows ? 'dart.exe' : 'dart')),
        );
        expect(File(compiler.dartExecutable).existsSync(), isTrue);
      },
    );

    test(
      'when compile is called, '
      'then it produces a .dill file with no errors and no compile marker',
      () async {
        final outputDill = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        );

        await compiler.start();
        final result = await compiler.compile();

        expect(result.errorCount, 0);
        expect(result.dillOutput, isNotEmpty);
        expect(File(outputDill).existsSync(), isTrue);
        expect(File('$outputDill.compiling').existsSync(), isFalse);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when compileFromCache runs with a leftover compile marker, '
      'then it discards the cached dill and recompiles',
      () async {
        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);

        // Simulate a previous session killed mid-compile.
        File('${compiler.outputDill}.compiling').createSync();

        expect(await compiler.compileFromCache(), isTrue);
        expect(File('${compiler.outputDill}.compiling').existsSync(), isFalse);
        expect(File(compiler.outputDill).existsSync(), isTrue);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the entrypoint changes, '
      'then the new entrypoint runs from the cached kernel',
      () async {
        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);
        await compiler.dispose();

        final alternate = p.join(tempDir.path, 'bin', 'main_enterprise.dart');
        await File(
          alternate,
        ).writeAsString("void main() { print('enterprise'); }");
        final enterpriseCompiler = KernelCompiler(
          entryPoint: alternate,
          outputDill: compiler.outputDill,
          packagesPath: compiler.packagesPath,
        );
        try {
          await enterpriseCompiler.start();
          expect(await enterpriseCompiler.compileFromCache(), isTrue);
        } finally {
          await enterpriseCompiler.dispose();
        }

        expect(await _run(compiler), 'enterprise\n');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the entrypoint is edited with its modification time preserved, '
      'then a new compiler executes the edited source',
      () async {
        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);
        await compiler.dispose();

        // Same length and timestamp, as after `cp -p` or an archive restore.
        final entrypoint = File(compiler.entryPoint);
        final modified = (await entrypoint.stat()).modified;
        await entrypoint.writeAsString('void main() { print("howdy"); }');
        await entrypoint.setLastModified(modified);

        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);

        expect(await _run(compiler), 'howdy\n');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the entrypoint is deleted before a new compiler starts, '
      'then compilation fails',
      () async {
        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);
        await compiler.dispose();

        await File(compiler.entryPoint).delete();

        await compiler.start();
        expect(await compiler.compileFromCache(), isFalse);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when invalidateCachedDill is called, '
      'then the dill, incremental dill, and marker are deleted',
      () async {
        await compiler.start();
        await compiler.compile();
        File('${compiler.outputDill}.incremental.dill').createSync();
        File('${compiler.outputDill}.compiling').createSync();

        await compiler.invalidateCachedDill();

        expect(File(compiler.outputDill).existsSync(), isFalse);
        expect(
          File('${compiler.outputDill}.incremental.dill').existsSync(),
          isFalse,
        );
        expect(File('${compiler.outputDill}.compiling').existsSync(), isFalse);

        // Absent files do not throw.
        await compiler.invalidateCachedDill();
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when another entrypoint fails compilation, '
      'then restarting the original entrypoint executes its own code.',
      () async {
        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);
        await compiler.dispose();

        final alternate = File(p.join(tempDir.path, 'bin', 'alternate.dart'));
        await alternate.writeAsString('''
void main() { print('alternate'); }
void unused() { undefinedFunction(); }
''');
        final alternateCompiler = KernelCompiler(
          entryPoint: alternate.path,
          outputDill: compiler.outputDill,
          packagesPath: compiler.packagesPath,
        );
        try {
          await alternateCompiler.start();
          expect(await alternateCompiler.compileFromCache(), isFalse);
          await alternateCompiler.reject();
        } finally {
          await alternateCompiler.dispose();
        }

        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);

        expect(await _run(compiler), 'hello\n');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when another entrypoint compiles but stops before acceptance, '
      'then restarting the original entrypoint executes its own code',
      () async {
        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);
        await compiler.dispose();

        final alternate = File(p.join(tempDir.path, 'bin', 'alternate.dart'));
        await alternate.writeAsString("void main() { print('alternate'); }");
        final alternateCompiler = KernelCompiler(
          entryPoint: alternate.path,
          outputDill: compiler.outputDill,
          packagesPath: compiler.packagesPath,
        );
        try {
          await alternateCompiler.start();
          expect((await alternateCompiler.compile()).errorCount, 0);
        } finally {
          await alternateCompiler.dispose();
        }

        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);

        expect(await _run(compiler), 'hello\n');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when compile is called with changed paths, '
      'then it succeeds incrementally',
      () async {
        final mainFile = p.join(tempDir.path, 'bin', 'main.dart');

        await compiler.start();

        // Initial compile.
        final initial = await compiler.compile();
        expect(initial.errorCount, 0);
        await compiler.accept();

        // Modify the file.
        await File(mainFile).writeAsString(
          'void main() { print("modified"); }',
        );

        // Incremental compile.
        final recompiled = await compiler.compile(changedPaths: {mainFile});
        expect(recompiled.errorCount, 0);
        await compiler.accept();
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });

  group('Given a KernelCompiler with a file containing errors,', () {
    late Directory tempDir;
    late KernelCompiler compiler;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'kernel_compiler_test_',
      );
      await _createMinimalDartProject(tempDir.path);

      final mainFile = p.join(tempDir.path, 'bin', 'main.dart');
      await File(mainFile).writeAsString('void main() { undefinedFunc(); }');

      compiler = KernelCompiler(
        entryPoint: mainFile,
        outputDill: p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        ),
        packagesPath: p.join(
          tempDir.path,
          '.dart_tool',
          'package_config.json',
        ),
      );
    });

    tearDown(() async {
      await compiler.dispose();
      await tempDir.deleteWithRetry(recursive: true);
    });

    test(
      'when compile is called, '
      'then it reports a non-zero error count and keeps the compile marker',
      () async {
        await compiler.start();
        final result = await compiler.compile();

        expect(result.errorCount, greaterThan(0));
        expect(File('${compiler.outputDill}.compiling').existsSync(), isTrue);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the failed compile is rejected and the file is fixed, '
      'then the next compile writes a complete kernel to outputDill',
      () async {
        final mainFile = p.join(tempDir.path, 'bin', 'main.dart');

        await compiler.start();
        expect((await compiler.compile()).errorCount, greaterThan(0));
        await compiler.reject();

        await File(mainFile).writeAsString('void main() {}');
        final result = await compiler.compile(changedPaths: {mainFile});
        await compiler.accept();

        expect(result.errorCount, 0);
        expect(result.dillOutput, compiler.outputDill);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });

  group('Given a cached kernel overwritten by a failed full compilation,', () {
    late Directory tempDir;
    late KernelCompiler compiler;
    late String mainFile;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('kernel_compiler_test_');
      await _createMinimalDartProject(tempDir.path);
      mainFile = p.join(tempDir.path, 'bin', 'main.dart');
      compiler = KernelCompiler(
        entryPoint: mainFile,
        outputDill: p.join(tempDir.path, '.dart_tool', 'server.dill'),
        packagesPath: p.join(tempDir.path, '.dart_tool', 'package_config.json'),
      );

      await compiler.start();
      if (!await compiler.compileFromCache()) {
        throw StateError('The initial project must compile successfully.');
      }

      // FES can emit an executable kernel even when an unused function has
      // errors. Running that kernel would silently execute rejected code.
      await File(mainFile).writeAsString('''
void main() { print('rejected code'); }
void unused() { undefinedFunction(); }
''');
      await compiler.reset();
      final failed = await compiler.compile();
      if (failed.errorCount == 0 || failed.dillOutput == null) {
        throw StateError('The failed compile must emit a kernel with errors.');
      }
      await compiler.reject();
      await compiler.dispose();
    });

    tearDownAll(() async {
      await compiler.dispose();
      await tempDir.deleteWithRetry(recursive: true);
    });

    group('when the source is repaired and a new compiler starts,', () {
      late bool compiled;
      late ProcessResult execution;

      setUpAll(() async {
        await File(mainFile).writeAsString(
          "void main() { print('repaired code'); }",
        );
        compiler = KernelCompiler(
          entryPoint: mainFile,
          outputDill: compiler.outputDill,
          packagesPath: compiler.packagesPath,
        );

        await compiler.start();
        compiled = await compiler.compileFromCache();
        execution = await Process.run(compiler.dartExecutable, [
          compiler.outputDill,
        ]);
      });

      test('then compilation succeeds.', () {
        expect(compiled, isTrue);
      });

      test('then the repaired code runs successfully.', () {
        expect(execution.exitCode, 0);
        expect(
          (execution.stdout as String).replaceAll('\r\n', '\n'),
          'repaired code\n',
        );
        expect(execution.stderr, isEmpty);
      });
    });
  });

  group('Given a cached kernel that imports a local package,', () {
    late Directory tempDir;
    late KernelCompiler compiler;
    late File depFile;
    late String packageConfigFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('kernel_compiler_test_');
      await _createMinimalDartProject(tempDir.path);
      final dartToolDir = p.join(tempDir.path, '.dart_tool');
      packageConfigFile = p.join(dartToolDir, 'package_config.json');

      // Sources outside `lib/`, so nothing may assume the default layout.
      depFile = File(p.join(tempDir.path, 'dep', 'src', 'dep.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync("String greeting() => 'original';");
      await File(p.join(tempDir.path, 'bin', 'main.dart')).writeAsString(
        "import 'package:dep/dep.dart';\n"
        'void main() => print(greeting());',
      );
      await File(packageConfigFile).writeAsString(_packageConfig('../dep'));

      compiler = KernelCompiler(
        entryPoint: p.join(tempDir.path, 'bin', 'main.dart'),
        outputDill: p.join(dartToolDir, 'serverpod', 'server.dill'),
        packagesPath: packageConfigFile,
      );

      await compiler.start();
      if (!await compiler.compileFromCache()) {
        throw StateError('The initial project must compile successfully.');
      }
      await compiler.dispose();
    });

    tearDown(() async {
      await compiler.dispose();
      await tempDir.deleteWithRetry(recursive: true);
    });

    test(
      'when the package is edited with its modification time preserved, '
      'then a new compiler executes the edited package code',
      () async {
        final modified = (await depFile.stat()).modified;
        await depFile.writeAsString("String greeting() => 'modified';");
        await depFile.setLastModified(modified);

        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);

        expect(await _run(compiler), 'modified\n');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when package_config.json moves the package, '
      'then a new compiler executes the code at the new location',
      () async {
        File(p.join(tempDir.path, 'dep_v2', 'src', 'dep.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync("String greeting() => 'moved';");
        await File(
          packageConfigFile,
        ).writeAsString(_packageConfig('../dep_v2'));

        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);

        expect(await _run(compiler), 'moved\n');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the package is saved after a new compiler starts, '
      'then the save compiles to an incremental kernel with the saved code',
      () async {
        await compiler.start();
        expect(await compiler.compileFromCache(), isTrue);

        await depFile.writeAsString("String greeting() => 'saved';");
        final result = await compiler.compile(changedPaths: {depFile.path});
        await compiler.accept();

        expect(result.errorCount, 0);
        expect(result.dillOutput, '${compiler.outputDill}.incremental.dill');
        expect(
          latin1.decode(File(result.dillOutput!).readAsBytesSync()),
          contains("'saved'"),
        );
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });

  group('Given a dependency added to package_config.json', () {
    late Directory tempDir;
    late KernelCompiler compiler;
    late String mainFile;
    late String packageConfigFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('kernel_compiler_test_');
      await _createMinimalDartProject(tempDir.path);
      mainFile = p.join(tempDir.path, 'bin', 'main.dart');
      packageConfigFile = p.join(
        tempDir.path,
        '.dart_tool',
        'package_config.json',
      );

      // A sibling package the app will import once it's mapped in
      // package_config.json. Only the source file and the mapping matter to
      // the Frontend Server's resolution, so no pubspec is needed.
      File(p.join(tempDir.path, 'dep', 'lib', 'dep.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync("String depGreeting() => 'hi from dep';");

      compiler = KernelCompiler(
        entryPoint: mainFile,
        outputDill: p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        ),
        packagesPath: packageConfigFile,
      );
    });

    tearDown(() async {
      await compiler.dispose();
      await tempDir.deleteWithRetry(recursive: true);
    });

    test(
      'when compile is called with invalidatePackageConfig, '
      'then the new package resolves without a restart',
      () async {
        await compiler.start();

        // Baseline: main does not import the new package yet.
        expect((await compiler.compile()).errorCount, 0);
        await compiler.accept();

        // The app now imports the package, but package_config.json doesn't map
        // it yet. The resident compiler only knows the packages it read at
        // startup, so without reloading the map the import can't resolve.
        await File(mainFile).writeAsString(
          "import 'package:dep/dep.dart';\n"
          'void main() => print(depGreeting());',
        );
        final beforeReload = await compiler.compile(changedPaths: {mainFile});
        expect(
          beforeReload.errorCount,
          greaterThan(0),
          reason: 'package:dep is not in package_config.json yet',
        );
        await compiler.reject();

        // Map the package in package_config.json (as `pub get` would) and
        // recompile, invalidating the package config so the FES re-reads it.
        await File(packageConfigFile).writeAsString('''
{
  "configVersion": 2,
  "packages": [
    { "name": "test_server", "rootUri": "..", "packageUri": "lib/" },
    { "name": "dep", "rootUri": "../dep", "packageUri": "lib/" }
  ]
}
''');
        final afterReload = await compiler.compile(
          changedPaths: {mainFile},
          invalidatePackageConfig: true,
        );
        expect(
          afterReload.errorCount,
          0,
          reason:
              'invalidating package_config.json should reload the package map '
              'so package:dep resolves',
        );
        await compiler.accept();
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}

/// Runs [compiler]'s output kernel and returns its stdout.
Future<String> _run(KernelCompiler compiler) async {
  final execution = await Process.run(compiler.dartExecutable, [
    compiler.outputDill,
  ]);
  expect(execution.exitCode, 0);
  expect(execution.stderr, isEmpty);
  return (execution.stdout as String).replaceAll('\r\n', '\n');
}

/// A package_config.json mapping `package:dep` to `src/` under [depRoot].
String _packageConfig(String depRoot) =>
    '''
{
  "configVersion": 2,
  "packages": [
    { "name": "test_server", "rootUri": "..", "packageUri": "lib/" },
    { "name": "dep", "rootUri": "$depRoot", "packageUri": "src/" }
  ]
}
''';

/// Creates a minimal Dart project with package_config.json for FES.
Future<void> _createMinimalDartProject(String dir) async {
  await Directory('$dir/bin').create(recursive: true);
  await Directory('$dir/.dart_tool').create(recursive: true);

  await File('$dir/pubspec.yaml').writeAsString('''
name: test_server
environment:
  sdk: ^3.0.0
''');

  await File('$dir/bin/main.dart').writeAsString(
    'void main() { print("hello"); }',
  );

  // Create a minimal package_config.json for the Frontend Server.
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
}
