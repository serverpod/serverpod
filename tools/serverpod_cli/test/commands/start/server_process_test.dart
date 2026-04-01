import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
import 'package:serverpod_cli/src/util/sdk_path.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

/// An IOSink that discards all output.
class _NullIOSink implements IOSink {
  @override
  Encoding encoding = utf8;

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future addStream(Stream<List<int>> stream) => stream.drain();

  @override
  Future close() async {}

  @override
  Future get done => Future.value();

  @override
  Future flush() async {}

  @override
  void write(Object? object) {}

  @override
  void writeAll(Iterable objects, [String separator = '']) {}

  @override
  void writeCharCode(int charCode) {}

  @override
  void writeln([Object? object = '']) {}
}

void main() {
  setUpAll(() {
    initializeLogger();
  });

  tearDownAll(() async {
    await closeLogger();
  });

  group('Given a ServerProcess with a simple exit command', () {
    late Directory tempDir;
    late ServerProcess serverProcess;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'server_process_test_',
      );
      await _createMinimalDartProject(tempDir.path);
      await File(
        '${tempDir.path}/bin/main.dart',
      ).writeAsString('void main() { print("hello"); }');

      serverProcess = ServerProcess(
        serverDir: tempDir.path,
        serverArgs: [],
        stdoutSink: _NullIOSink(),
        stderrSink: _NullIOSink(),
      );
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test(
      'when started, '
      'then it returns the exit code when the process exits',
      () async {
        await serverProcess.start();
        final exitCode = await serverProcess.exitCode;
        expect(exitCode, 0);
        expect(serverProcess.isRunning, isFalse);
      },
    );
  });

  group('Given a ServerProcess with a long-running command', () {
    late Directory tempDir;
    late ServerProcess serverProcess;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'server_process_test_',
      );
      await _createMinimalDartProject(tempDir.path);
      await File('${tempDir.path}/bin/main.dart').writeAsString('''
import 'dart:io';
void main() {
  ProcessSignal.sigint.watch().listen((_) => exit(0));
  Future.delayed(Duration(hours: 1));
}
''');

      serverProcess = ServerProcess(
        serverDir: tempDir.path,
        serverArgs: [],
        stdoutSink: _NullIOSink(),
        stderrSink: _NullIOSink(),
      );
    });

    tearDown(() async {
      await serverProcess.stop();
      await tempDir.delete(recursive: true);
    });

    test(
      'when stop is called, '
      'then the process is terminated',
      () async {
        await serverProcess.start();
        expect(serverProcess.isRunning, isTrue);

        await serverProcess.stop();
        expect(serverProcess.isRunning, isFalse);
      },
    );

    test(
      'when start is called again, '
      'then it throws a StateError',
      () async {
        await serverProcess.start();
        expect(() => serverProcess.start(), throwsStateError);
      },
    );
  });

  group('Given a ServerProcess with VM service enabled', () {
    late Directory tempDir;
    late String dillPath;
    late String vmServiceInfoFile;
    late String dartExecutable;
    late ServerProcess serverProcess;

    setUp(() async {
      final sdkRoot = getSdkPath();
      dartExecutable = p.join(sdkRoot, 'bin', 'dart');
      tempDir = await Directory.systemTemp.createTemp(
        'server_process_vm_test_',
      );
      await _createMinimalDartProject(tempDir.path);
      final mainFile = p.join(tempDir.path, 'bin', 'main.dart');
      await File(mainFile).writeAsString('''
import 'dart:io';
void main() {
  ProcessSignal.sigint.watch().listen((_) => exit(0));
  Future.delayed(Duration(hours: 1));
}
''');

      // Compile the initial kernel using KernelCompiler.
      dillPath = p.join(tempDir.path, '.dart_tool', 'serverpod', 'server.dill');
      vmServiceInfoFile = p.join(
        tempDir.path,
        '.dart_tool',
        'serverpod',
        'vm-service-info.json',
      );
      final compiler = KernelCompiler(
        entryPoint: mainFile,
        outputDill: dillPath,
        packagesPath: p.join(tempDir.path, '.dart_tool', 'package_config.json'),
      );
      await compiler.start();
      final result = await compiler.compile();
      if (result.errorCount > 0) {
        throw StateError(
          'Failed to compile kernel: ${result.compilerOutputLines.join('\n')}',
        );
      }
      compiler.accept();
      await compiler.dispose();

      serverProcess = ServerProcess(
        serverDir: tempDir.path,
        serverArgs: [],
        dartExecutable: dartExecutable,
        enableVmService: true,
        vmServiceInfoFile: vmServiceInfoFile,
        stdoutSink: _NullIOSink(),
        stderrSink: _NullIOSink(),
      );
    });

    tearDown(() async {
      await serverProcess.stop();
      // On Windows, TerminateProcess may not release file handles immediately.
      for (var i = 0; ; i++) {
        try {
          await tempDir.delete(recursive: true);
          break;
        } on FileSystemException {
          if (i >= 4) rethrow;
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    });

    test(
      'when connectToVmService is called, '
      'then it connects to the VM service',
      () async {
        await serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        expect(serverProcess.isVmServiceConnected, isTrue);
      },
    );

    test(
      'when reload is called with the same dill path, '
      'then the reload succeeds',
      () async {
        await serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        final reloaded = await serverProcess.reload(dillPath);
        expect(reloaded, isTrue);
      },
    );
  });

  group(
    'Given a ServerProcess with VM service enabled and an onReloadRequested callback',
    () {
      late Directory tempDir;
      late String dillPath;
      late String vmServiceInfoFile;
      late String dartExecutable;
      late ServerProcess serverProcess;
      late bool callbackCalled;

      setUp(() async {
        final sdkRoot = getSdkPath();
        dartExecutable = p.join(sdkRoot, 'bin', 'dart');
        tempDir = await Directory.systemTemp.createTemp(
          'server_process_vm_test_',
        );
        await _createMinimalDartProject(tempDir.path);
        final mainFile = p.join(tempDir.path, 'bin', 'main.dart');
        await File(mainFile).writeAsString('''
import 'dart:io';
void main() {
  ProcessSignal.sigint.watch().listen((_) => exit(0));
  Future.delayed(Duration(hours: 1));
}
''');

        // Compile the initial kernel using KernelCompiler.
        dillPath = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        );
        vmServiceInfoFile = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'vm-service-info.json',
        );
        final compiler = KernelCompiler(
          entryPoint: mainFile,
          outputDill: dillPath,
          packagesPath: p.join(
            tempDir.path,
            '.dart_tool',
            'package_config.json',
          ),
        );
        await compiler.start();
        final result = await compiler.compile();
        if (result.errorCount > 0) {
          throw StateError(
            'Failed to compile kernel: ${result.compilerOutputLines.join('\n')}',
          );
        }
        compiler.accept();
        await compiler.dispose();

        callbackCalled = false;
        serverProcess = ServerProcess(
          serverDir: tempDir.path,
          serverArgs: [],
          dartExecutable: dartExecutable,
          enableVmService: true,
          vmServiceInfoFile: vmServiceInfoFile,
          stdoutSink: _NullIOSink(),
          stderrSink: _NullIOSink(),
          onReloadRequested: () async {
            callbackCalled = true;
            return dillPath;
          },
        );
      });

      tearDown(() async {
        await serverProcess.stop();
        // On Windows, TerminateProcess may not release file handles immediately.
        for (var i = 0; ; i++) {
          try {
            await tempDir.delete(recursive: true);
            break;
          } on FileSystemException {
            if (i >= 4) rethrow;
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      });

      test(
        'when connectToVmService is called, '
        'then it connects successfully without invoking the callback',
        () async {
          await serverProcess.start(dillPath: dillPath);
          await serverProcess.connectToVmService();

          // The service is registered; verify the process is connected.
          expect(serverProcess.isVmServiceConnected, isTrue);
          expect(callbackCalled, isFalse);
        },
      );
    },
  );

  group(
    'Given a ServerProcess with VM service enabled and a dill path containing spaces',
    () {
      late Directory tempDir;
      late String dillPath;
      late String vmServiceInfoFile;
      late String dartExecutable;
      late ServerProcess serverProcess;

      setUp(() async {
        final sdkRoot = getSdkPath();
        dartExecutable = p.join(sdkRoot, 'bin', 'dart');
        // Temp directory name includes spaces so the compiled .dill path does too.
        tempDir = await Directory.systemTemp.createTemp(
          'server process vm spaces',
        );
        await _createMinimalDartProject(tempDir.path);
        final mainFile = p.join(tempDir.path, 'bin', 'main.dart');
        await File(mainFile).writeAsString('''
import 'dart:io';
void main() {
  ProcessSignal.sigint.watch().listen((_) => exit(0));
  Future.delayed(Duration(hours: 1));
}
''');

        dillPath = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'server.dill',
        );
        vmServiceInfoFile = p.join(
          tempDir.path,
          '.dart_tool',
          'serverpod',
          'vm-service-info.json',
        );
        final compiler = KernelCompiler(
          entryPoint: mainFile,
          outputDill: dillPath,
          packagesPath: p.join(
            tempDir.path,
            '.dart_tool',
            'package_config.json',
          ),
        );
        await compiler.start();
        final result = await compiler.compile();
        if (result.errorCount > 0) {
          throw StateError(
            'Failed to compile kernel: ${result.compilerOutputLines.join('\n')}',
          );
        }
        compiler.accept();
        await compiler.dispose();

        expect(dillPath.contains(' '), isTrue);

        serverProcess = ServerProcess(
          serverDir: tempDir.path,
          serverArgs: [],
          dartExecutable: dartExecutable,
          enableVmService: true,
          vmServiceInfoFile: vmServiceInfoFile,
          stdoutSink: _NullIOSink(),
          stderrSink: _NullIOSink(),
        );
      });

      tearDown(() async {
        await serverProcess.stop();
        for (var i = 0; ; i++) {
          try {
            await tempDir.delete(recursive: true);
            break;
          } on FileSystemException {
            if (i >= 4) rethrow;
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      });

      test(
        'when start and reload use a dillPath with spaces, '
        'then VM service connect and reload succeed',
        () async {
          await serverProcess.start(dillPath: dillPath);
          await serverProcess.connectToVmService();

          expect(serverProcess.isVmServiceConnected, isTrue);

          final reloaded = await serverProcess.reload(dillPath);
          expect(reloaded, isTrue);
        },
      );
    },
  );
}

/// Creates a minimal Dart project structure.
Future<void> _createMinimalDartProject(String dir) async {
  await Directory('$dir/bin').create(recursive: true);
  await Directory('$dir/.dart_tool/serverpod').create(recursive: true);
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
}
