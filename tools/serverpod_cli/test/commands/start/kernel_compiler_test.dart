import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

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
      'then it produces a .dill file with no errors',
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
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when compile completes, '
      'then no compile marker remains',
      () async {
        final marker = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill.compiling',
        );

        await compiler.start();
        await compiler.compile();

        expect(File(marker).existsSync(), isFalse);
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
      'then it reports a non-zero error count',
      () async {
        await compiler.start();
        final result = await compiler.compile();

        expect(result.errorCount, greaterThan(0));
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when compile finishes with errors, '
      'then the compile marker is still cleared',
      () async {
        await compiler.start();
        final result = await compiler.compile();

        expect(result.errorCount, greaterThan(0));
        // The FES finished writing, so the dill state is consistent.
        expect(
          File('${compiler.outputDill}.compiling').existsSync(),
          isFalse,
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
