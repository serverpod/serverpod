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
      await tempDir.delete(recursive: true);
    });

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
      'when isDillUpToDate is called with a leftover compile marker, '
      'then it returns false',
      () async {
        await compiler.start();
        await compiler.compile();
        await compiler.accept();
        expect(await compiler.isDillUpToDate({}), isTrue);

        File('${compiler.outputDill}.compiling').createSync();

        expect(await compiler.isDillUpToDate({}), isFalse);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when compileIfNeeded runs with a leftover compile marker, '
      'then it discards the cached dill and recompiles',
      () async {
        final watchDirs = {p.join(tempDir.path, 'bin')};

        await compiler.start();
        expect(await compiler.compileIfNeeded(watchDirs), isTrue);

        // Simulate a previous session killed mid-compile.
        File('${compiler.outputDill}.compiling').createSync();

        expect(await compiler.compileIfNeeded(watchDirs), isTrue);
        expect(File('${compiler.outputDill}.compiling').existsSync(), isFalse);
        expect(File(compiler.outputDill).existsSync(), isTrue);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the entrypoint changes, then the cached kernel is not reused',
      () async {
        final watchDirs = {p.join(tempDir.path, 'bin')};
        await compiler.start();
        expect(await compiler.compileIfNeeded(watchDirs), isTrue);
        await compiler.dispose();

        final alternate = p.join(tempDir.path, 'bin', 'main_enterprise.dart');
        await File(alternate).writeAsString('void main() {}');
        final enterpriseCompiler = KernelCompiler(
          entryPoint: alternate,
          outputDill: compiler.outputDill,
          packagesPath: compiler.packagesPath,
        );
        try {
          expect(await enterpriseCompiler.isDillUpToDate({}), isFalse);
          await enterpriseCompiler.start();
          expect(await enterpriseCompiler.compileIfNeeded(watchDirs), isTrue);
          expect(await enterpriseCompiler.isDillUpToDate({}), isTrue);
        } finally {
          await enterpriseCompiler.dispose();
        }
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the entrypoint is edited outside the watched directories, '
      'then a new compiler executes the edited source.',
      () async {
        await compiler.start();
        expect(await compiler.compileIfNeeded({}), isTrue);
        await compiler.dispose();

        final entrypoint = File(compiler.entryPoint);
        await entrypoint.writeAsString("void main() { print('edited'); }");
        final cachedModified = (await File(
          compiler.outputDill,
        ).stat()).modified;
        await entrypoint.setLastModified(
          cachedModified.add(const Duration(seconds: 1)),
        );

        await compiler.start();
        expect(await compiler.compileIfNeeded({}), isTrue);
        final execution = await Process.run(compiler.dartExecutable, [
          compiler.outputDill,
        ]);

        expect(execution.exitCode, 0);
        expect(execution.stdout, 'edited\n');
        expect(execution.stderr, isEmpty);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when the entrypoint is deleted outside the watched directories, '
      'then its cached kernel is no longer current.',
      () async {
        await compiler.start();
        expect(await compiler.compileIfNeeded({}), isTrue);

        await File(compiler.entryPoint).delete();

        expect(await compiler.isDillUpToDate({}), isFalse);
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
        expect(await compiler.compileIfNeeded({}), isTrue);
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
          expect(await alternateCompiler.compileIfNeeded({}), isFalse);
          await alternateCompiler.reject();
        } finally {
          await alternateCompiler.dispose();
        }

        await compiler.start();
        expect(await compiler.compileIfNeeded({}), isTrue);
        final execution = await Process.run(compiler.dartExecutable, [
          compiler.outputDill,
        ]);

        expect(execution.exitCode, 0);
        expect(execution.stdout, 'hello\n');
        expect(execution.stderr, isEmpty);
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when another entrypoint compiles but stops before acceptance, '
      'then its kernel cannot be reused as the original entrypoint.',
      () async {
        await compiler.start();
        expect(await compiler.compileIfNeeded({}), isTrue);
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

        expect(await compiler.isDillUpToDate({}), isFalse);
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

  group('Given a KernelCompiler with a file containing errors', () {
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
      await tempDir.delete(recursive: true);
    });

    test(
      'when compile is called, '
      'then it reports a non-zero error count and keeps the cache invalid.',
      () async {
        await compiler.start();
        final result = await compiler.compile();

        expect(result.errorCount, greaterThan(0));
        expect(
          await compiler.isDillUpToDate({}),
          isFalse,
        );
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
      if (!await compiler.compileIfNeeded({})) {
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
        compiled = await compiler.compileIfNeeded({});
        execution = await Process.run(compiler.dartExecutable, [
          compiler.outputDill,
        ]);
      });

      test('then compilation succeeds.', () {
        expect(compiled, isTrue);
      });

      test('then the repaired code runs successfully.', () {
        expect(execution.exitCode, 0);
        expect(execution.stdout, 'repaired code\n');
        expect(execution.stderr, isEmpty);
      });
    });
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
      await tempDir.delete(recursive: true);
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
