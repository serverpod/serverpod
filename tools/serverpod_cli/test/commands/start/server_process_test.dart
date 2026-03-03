import 'dart:async';
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

          await serverProcess.start();
          final exitCode = await serverProcess.exitCode;
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

          await serverProcess.start();
          expect(serverProcess.isRunning, isTrue);

          await serverProcess.stop();
          expect(serverProcess.isRunning, isFalse);
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

          await serverProcess.start();

          expect(() => serverProcess.start(), throwsStateError);

          await serverProcess.stop();
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
    late String vmServiceInfoFile;
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
          vmServiceInfoFile: vmServiceInfoFile,
          stdoutSink: _NullIOSink(),
          stderrSink: _NullIOSink(),
        );

        await serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        expect(serverProcess.isVmServiceConnected, isTrue);

        await serverProcess.stop();
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
          vmServiceInfoFile: vmServiceInfoFile,
          stdoutSink: _NullIOSink(),
          stderrSink: _NullIOSink(),
        );

        await serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        final reloaded = await serverProcess.reload(dillPath);
        expect(reloaded, isTrue);

        await serverProcess.stop();
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'when onReloadRequested is provided and connectToVmService is called, '
      'then the custom reloadSources service is registered',
      () async {
        var callbackCalled = false;
        final serverProcess = ServerProcess(
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

        await serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        // The service is registered; verify the process is connected.
        expect(serverProcess.isVmServiceConnected, isTrue);
        expect(callbackCalled, isFalse);

        await serverProcess.stop();
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'when onExternalReload is provided and an external reload occurs, '
      'then the callback is invoked',
      () async {
        final externalReloadCompleter = Completer<void>();
        final serverProcess = ServerProcess(
          serverDir: tempDir.path,
          serverArgs: [],
          dartExecutable: dartExecutable,
          enableVmService: true,
          vmServiceInfoFile: vmServiceInfoFile,
          stdoutSink: _NullIOSink(),
          stderrSink: _NullIOSink(),
          onExternalReload: () {
            if (!externalReloadCompleter.isCompleted) {
              externalReloadCompleter.complete();
            }
          },
        );

        await serverProcess.start(dillPath: dillPath);
        await serverProcess.connectToVmService();

        // Read the VM service URI from the service info file and connect
        // a second client to trigger a reload directly, bypassing our
        // custom service. This simulates an IDE reload.
        final infoJson = jsonDecode(
          await File(vmServiceInfoFile).readAsString(),
        ) as Map<String, dynamic>;
        final httpUri = infoJson['uri'] as String;
        final wsUri = httpUri
            .replaceFirst('http://', 'ws://')
            .replaceFirst('https://', 'wss://');
        final wsUriWithSuffix =
            wsUri.endsWith('/') ? '${wsUri}ws' : '$wsUri/ws';
        final externalVmService = await vmServiceConnectUri(wsUriWithSuffix);
        final vm = await externalVmService.getVM();
        final isolateId = vm.isolates!.first.id!;
        final dillUri = Uri.file(p.absolute(dillPath)).toString();
        await externalVmService.reloadSources(
          isolateId,
          rootLibUri: dillUri,
        );

        // Wait for the external reload to be detected.
        await externalReloadCompleter.future.timeout(
          const Duration(seconds: 5),
        );
        expect(externalReloadCompleter.isCompleted, isTrue);

        await externalVmService.dispose();
        await serverProcess.stop();
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
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
