import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/start/kernel_compiler.dart';
import 'package:serverpod_cli/src/commands/start/sdk_path.dart';
import 'package:serverpod_cli/src/commands/start/server_process.dart';
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

  tearDownAll(() {
    resetLogger();
  });

  group('Given a ServerProcess', () {
    test(
      'when started with a simple dart command, '
      'then it returns the exit code when the process exits',
      () async {
        final tempDir = await Directory.systemTemp.createTemp(
          'server_process_test_',
        );
        try {
          await _createMinimalDartProject(tempDir.path);
          await File(
            '${tempDir.path}/bin/main.dart',
          ).writeAsString('void main() { print("hello"); }');

          final serverProcess = ServerProcess(
            serverDir: tempDir.path,
            serverArgs: [],
            stdoutSink: _NullIOSink(),
            stderrSink: _NullIOSink(),
          );

          final exitCode = await serverProcess.start();
          expect(exitCode, 0);
          expect(serverProcess.isRunning, isFalse);
        } finally {
          await tempDir.delete(recursive: true);
        }
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'when stop is called, '
      'then the process is terminated',
      () async {
        final tempDir = await Directory.systemTemp.createTemp(
          'server_process_test_',
        );
        try {
          await _createMinimalDartProject(tempDir.path);
          await File('${tempDir.path}/bin/main.dart').writeAsString('''
import 'dart:io';
void main() {
  ProcessSignal.sigterm.watch().listen((_) => exit(0));
  // Keep alive.
  Future.delayed(Duration(hours: 1));
}
''');

          final serverProcess = ServerProcess(
            serverDir: tempDir.path,
            serverArgs: [],
            stdoutSink: _NullIOSink(),
            stderrSink: _NullIOSink(),
          );

          final startFuture = serverProcess.start();
          await Future.delayed(const Duration(seconds: 3));
          expect(serverProcess.isRunning, isTrue);

          await serverProcess.stop();
          expect(serverProcess.isRunning, isFalse);

          await startFuture;
        } finally {
          await tempDir.delete(recursive: true);
        }
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'when start is called while already running, '
      'then it throws a StateError',
      () async {
        final tempDir = await Directory.systemTemp.createTemp(
          'server_process_test_',
        );
        try {
          await _createMinimalDartProject(tempDir.path);
          await File('${tempDir.path}/bin/main.dart').writeAsString('''
import 'dart:io';
void main() {
  ProcessSignal.sigterm.watch().listen((_) => exit(0));
  Future.delayed(Duration(hours: 1));
}
''');

          final serverProcess = ServerProcess(
            serverDir: tempDir.path,
            serverArgs: [],
            stdoutSink: _NullIOSink(),
            stderrSink: _NullIOSink(),
          );

          final startFuture = serverProcess.start();
          await Future.delayed(const Duration(seconds: 2));

          expect(() => serverProcess.start(), throwsStateError);

          await serverProcess.stop();
          await startFuture;
        } finally {
          await tempDir.delete(recursive: true);
        }
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('Given a ServerProcess with VM service enabled', () {
    late Directory tempDir;
    late String dillPath;
    late String dartExecutable;

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
  ProcessSignal.sigterm.watch().listen((_) => exit(0));
  Future.delayed(Duration(hours: 1));
}
''');

      // Compile the initial kernel using KernelCompiler.
      dillPath = p.join(tempDir.path, '.dart_tool', 'serverpod', 'server.dill');
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
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test(
      'when connectToVmService is called, '
      'then it connects to the VM service',
      () async {
        final serverProcess = ServerProcess(
          serverDir: tempDir.path,
          serverArgs: [],
          dartExecutable: dartExecutable,
          enableVmService: true,
          stdoutSink: _NullIOSink(),
          stderrSink: _NullIOSink(),
        );

        final startFuture = serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        expect(serverProcess.isVmServiceConnected, isTrue);

        await serverProcess.stop();
        await startFuture;
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'when reload is called with the same dill path, '
      'then the reload succeeds',
      () async {
        final serverProcess = ServerProcess(
          serverDir: tempDir.path,
          serverArgs: [],
          dartExecutable: dartExecutable,
          enableVmService: true,
          stdoutSink: _NullIOSink(),
          stderrSink: _NullIOSink(),
        );

        final startFuture = serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        final reloaded = await serverProcess.reload(dillPath);
        expect(reloaded, isTrue);

        await serverProcess.stop();
        await startFuture;
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}

/// Creates a minimal Dart project structure.
Future<void> _createMinimalDartProject(String dir) async {
  await Directory('$dir/bin').create(recursive: true);
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
}
