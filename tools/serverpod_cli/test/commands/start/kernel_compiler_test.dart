import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:test/test.dart';

void main() {
  group('Given a KernelCompiler with a valid Dart project', () {
    late Directory tempDir;
    late KernelCompiler compiler;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'kernel_compiler_test_',
      );
      await _createMinimalDartProject(tempDir.path);
    });

    tearDown(() async {
      compiler.dispose();
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

        compiler = KernelCompiler(
          entryPoint: p.join(tempDir.path, 'bin', 'main.dart'),
          outputDill: outputDill,
          packagesPath: p.join(
            tempDir.path,
            '.dart_tool',
            'package_config.json',
          ),
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
      'when compile is called with changed paths, '
      'then it succeeds incrementally',
      () async {
        final outputDill = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        );
        final mainFile = p.join(tempDir.path, 'bin', 'main.dart');

        compiler = KernelCompiler(
          entryPoint: mainFile,
          outputDill: outputDill,
          packagesPath: p.join(
            tempDir.path,
            '.dart_tool',
            'package_config.json',
          ),
        );

        await compiler.start();

        // Initial compile.
        final initial = await compiler.compile();
        expect(initial.errorCount, 0);
        compiler.accept();

        // Modify the file.
        await File(mainFile).writeAsString(
          'void main() { print("modified"); }',
        );

        // Incremental compile.
        final recompiled = await compiler.compile(changedPaths: {mainFile});
        expect(recompiled.errorCount, 0);
        compiler.accept();
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );

    test(
      'when compiling code with errors, '
      'then it reports a non-zero error count',
      () async {
        final mainFile = p.join(tempDir.path, 'bin', 'main.dart');
        await File(mainFile).writeAsString('void main() { undefinedFunc(); }');

        final outputDill = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        );

        compiler = KernelCompiler(
          entryPoint: mainFile,
          outputDill: outputDill,
          packagesPath: p.join(
            tempDir.path,
            '.dart_tool',
            'package_config.json',
          ),
        );

        await compiler.start();
        final result = await compiler.compile();

        expect(result.errorCount, greaterThan(0));
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
