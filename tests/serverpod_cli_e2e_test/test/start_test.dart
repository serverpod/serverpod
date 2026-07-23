@Timeout(Duration(minutes: 12))
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:serverpod_cli_e2e_test/src/keyword_search_in_stream.dart';
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

const startWatchKeywords = [
  serverRunning,
  serverReloaded,
  serverRestarted,
];

/// Creates a `config/development.yaml` with port 0 (OS-assigned) to avoid
/// port conflicts when multiple tests run concurrently or sequentially.
void createDynamicPortConfig(String serverDirPath) {
  var configDir = Directory(path.join(serverDirPath, 'config'));
  configDir.createSync(recursive: true);
  File(path.join(configDir.path, 'development.yaml')).writeAsStringSync('''
apiServer:
  port: 0
  publicHost: localhost
  publicPort: 0
  publicScheme: http
''');
}

/// Starts the serverpod process and wires up a [KeywordSearchInStream] to
/// listen for [keywords] on stdout. Returns the process and stream search.
Future<(Process, KeywordSearchInStream)> startServerpodWithStreamSearch(
  List<String> args, {
  required String workingDirectory,
  required List<String> keywords,
}) async {
  var process = await startServerpod(
    args,
    workingDirectory: workingDirectory,
  );

  var streamSearch = KeywordSearchInStream(keywords: keywords);
  var stdoutSubscription = process.stdout
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .listen(streamSearch.onData);
  var stderrSubscription = process.stderr
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .listen(print);

  addTearDown(() {
    stdoutSubscription.cancel();
    stderrSubscription.cancel();
  });

  return (process, streamSearch);
}

/// Waits for the server to reach "Server running." state, then waits briefly
/// to ensure the file watcher is ready to receive changes.
Future<void> waitForServerRunning(KeywordSearchInStream streamSearch) async {
  await expectLater(
    streamSearch.keywordFound,
    completion(isTrue),
    reason: 'Server did not reach "Server running." state before timeout.',
  );
  await Future.delayed(const Duration(seconds: 1));
}

void main() async {
  group('Given a mini project', () {
    late String sandboxDir;
    var projectName =
        'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
    var serverDir = path.join(projectName, '${projectName}_server');

    Process? serverProcess;
    KeywordSearchInStream? streamSearch;

    setUpAll(() async {
      sandboxDir = d.sandbox;
      var result = await runServerpod(
        ['create', projectName, '--mini'],
        workingDirectory: sandboxDir,
      );
      assert(
        result.exitCode == 0,
        'Failed to create the serverpod project.',
      );
      createDynamicPortConfig(path.join(sandboxDir, serverDir));
    });

    tearDown(() async {
      await serverProcess?.killAndWaitForExit();
      streamSearch?.cancel();

      serverProcess = null;
      streamSearch = null;
    });

    group("when running 'serverpod start --watch'", () {
      setUp(() async {
        (serverProcess, streamSearch) = await startServerpodWithStreamSearch(
          ['start', '--watch'],
          workingDirectory: path.join(sandboxDir, serverDir),
          keywords: startWatchKeywords,
        );
      });

      test(
        'then it generates code, compiles, and reaches running state.',
        () async {
          await expectLater(
            streamSearch!.keywordFound,
            completion(isTrue),
            reason:
                'Server did not reach "Server running." state before timeout.',
          );
        },
      );

      test(
        'then server is hot-reloaded.',
        () async {
          await waitForServerRunning(streamSearch!);

          // Add a new endpoint file.
          var endpointFile = File(
            path.join(
              sandboxDir,
              serverDir,
              'lib',
              'src',
              'endpoints',
              'test_endpoint.dart',
            ),
          );
          endpointFile.createSync(recursive: true);
          endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class TestEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''', flush: true);

          await expectLater(
            streamSearch!.keywordFound,
            completion(isTrue),
            reason: 'Server was not reloaded after endpoint file was added.',
          );
        },
      );

      test(
        'when a model file is added, modified, and deleted then server is reloaded each time.',
        () async {
          await waitForServerRunning(streamSearch!);

          // Add a model file.
          var modelFile = File(
            path.join(
              sandboxDir,
              serverDir,
              'lib',
              'src',
              'models',
              'test_entity.spy.yaml',
            ),
          );
          modelFile.createSync(recursive: true);
          modelFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
''', flush: true);

          await expectLater(
            streamSearch!.keywordFound,
            completion(isTrue),
            reason: 'Server was not reloaded after model file was added.',
          );

          // Verify generated file exists in client package.
          var clientDir = path.join(projectName, '${projectName}_client');
          var entityFile = File(
            path.join(
              sandboxDir,
              clientDir,
              'lib',
              'src',
              'protocol',
              'test_entity.dart',
            ),
          );
          expect(
            entityFile.existsSync(),
            isTrue,
            reason: 'Generated entity file not found in client package.',
          );
          expect(
            entityFile.readAsStringSync(),
            contains('class TestEntity'),
            reason: 'Generated entity file did not contain expected class.',
          );

          // Modify the model file.
          await Future.delayed(const Duration(seconds: 1));
          modelFile.writeAsStringSync('''
class: TestEntity
fields:
  name: String
  age: int
''', flush: true);

          await expectLater(
            streamSearch!.keywordFound,
            completion(isTrue),
            reason: 'Server was not reloaded after model file was modified.',
          );

          expect(
            entityFile.readAsStringSync(),
            contains('int age'),
            reason: 'Generated entity file did not contain the added field.',
          );

          // Delete the model file.
          await Future.delayed(const Duration(seconds: 1));
          modelFile.deleteSync();

          await expectLater(
            streamSearch!.keywordFound,
            completion(isTrue),
            reason: 'Server was not reloaded after model file was deleted.',
          );

          expect(
            entityFile.existsSync(),
            isFalse,
            reason:
                'Generated entity file still exists after model was deleted.',
          );
        },
      );
    });

    group(
      "when running 'serverpod start --no-watch'",
      () {
        setUp(() async {
          (serverProcess, streamSearch) = await startServerpodWithStreamSearch(
            ['start', '--no-watch'],
            workingDirectory: path.join(sandboxDir, serverDir),
            keywords: startWatchKeywords,
          );
        });

        test(
          'then it reaches running state.',
          () async {
            await expectLater(
              streamSearch!.keywordFound,
              completion(isTrue),
              reason:
                  'Server did not reach "Server running." state before timeout.',
            );
          },
        );
      },
      // This test is flaky, so we retry it 3 times to ensure it passes.
      // Issue: https://github.com/serverpod/serverpod/issues/4903
      retry: 3,
    );

    group("when running 'serverpod start'", () {
      setUp(() async {
        (serverProcess, streamSearch) = await startServerpodWithStreamSearch(
          ['start'],
          workingDirectory: path.join(sandboxDir, serverDir),
          keywords: ['Server running.'],
        );
      });

      test(
        'then code is generated and server runs.',
        () async {
          await expectLater(
            streamSearch!.keywordFound,
            completion(isTrue),
            reason: 'Server did not start before timeout.',
          );

          var generatedEndpointsFile = File(
            path.join(
              sandboxDir,
              serverDir,
              'lib',
              'src',
              'generated',
              'endpoints.dart',
            ),
          );
          expect(
            generatedEndpointsFile.existsSync(),
            isTrue,
            reason: 'Generated endpoints file should exist after start.',
          );
        },
      );
    });
  });

  group('Given a project with a configured Flutter app', () {
    const projectName = 'vscode_test_app';
    late String sandboxDir;
    late String serverDir;
    late String fakeFlutterBinDir;
    late File debugPortGate;
    late File flutterVmServiceInfoFile;
    Process? serverProcess;
    StreamSubscription<String>? stdoutSubscription;
    StreamSubscription<String>? stderrSubscription;
    final processOutput = StringBuffer();

    setUpAll(() async {
      sandboxDir = d.sandbox;
      final projectRoot = path.join(sandboxDir, projectName);
      serverDir = path.join(projectRoot, '${projectName}_server');

      final createResult = await runServerpod(
        ['create', projectName, '--no-interactive'],
        workingDirectory: sandboxDir,
      );
      expect(
        createResult.exitCode,
        0,
        reason: 'Failed to create the serverpod project.',
      );
      createDynamicPortConfig(serverDir);

      flutterVmServiceInfoFile = File(
        path.join(
          projectRoot,
          "${projectName}_server",
          '.dart_tool',
          'serverpod',
          'flutter-vm-service-info-$projectName.json',
        ),
      );

      fakeFlutterBinDir = path.join(projectRoot, 'fake_flutter_bin');
      Directory(fakeFlutterBinDir).createSync(recursive: true);
      debugPortGate = File(path.join(projectRoot, 'publish_debug_port.gate'));
      final fakeFlutterExecutable = path.join(
        fakeFlutterBinDir,
        Platform.isWindows ? 'flutter.exe' : 'flutter',
      );
      final fakeFlutterSource = path.join(
        Directory.current.path,
        'test',
        'test_assets',
        'fake_flutter_vm_service.dart',
      );
      final compileResult = await Process.run(
        Platform.resolvedExecutable,
        ['compile', 'exe', fakeFlutterSource, '-o', fakeFlutterExecutable],
      );
      expect(
        compileResult.exitCode,
        0,
        reason:
            'Could not compile fake Flutter executable:\n'
            '${compileResult.stdout}\n${compileResult.stderr}',
      );
    });

    tearDown(() async {
      await serverProcess?.killAndWaitForExit();
      await stdoutSubscription?.cancel();
      await stderrSubscription?.cancel();
      serverProcess = null;
      stdoutSubscription = null;
      stderrSubscription = null;
      processOutput.clear();
      if (debugPortGate.existsSync()) debugPortGate.deleteSync();
    });

    test(
      'when running serverpod start from an IDE, '
      'then start forwards the IDE requests to the flutter process',
      () async {
        final pathSeparator = Platform.isWindows ? ';' : ':';
        serverProcess = await startServerpod(
          ['start', '--no-watch', '--no-tui'],
          workingDirectory: serverDir,
          environment: {
            'PATH':
                '$fakeFlutterBinDir$pathSeparator'
                '${Platform.environment['PATH'] ?? ''}',
            // Ensure the IDE request reaches the proxy before Flutter has
            // published an upstream VM service, matching VS Code's attach
            // behavior during `serverpod start`.
            'FAKE_FLUTTER_DEBUG_PORT_GATE': debugPortGate.path,
          },
        );

        stdoutSubscription = serverProcess!.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(processOutput.writeln);
        stderrSubscription = serverProcess!.stderr
            .transform(const Utf8Decoder())
            .transform(const LineSplitter())
            .listen(processOutput.writeln);

        final proxyHttpUri = await _waitForVmServiceInfo(
          flutterVmServiceInfoFile,
          diagnostics: processOutput,
          processExitCode: serverProcess!.exitCode,
        );

        final proxyWsUri = proxyHttpUri.replace(
          scheme: proxyHttpUri.scheme == 'https' ? 'wss' : 'ws',
          path: '${proxyHttpUri.path}ws',
        );
        final ideSocket = await WebSocket.connect(proxyWsUri.toString());
        addTearDown(ideSocket.close);

        final responses = StreamController<Map<String, Object?>>();
        addTearDown(responses.close);
        ideSocket.listen((data) {
          if (data is String) {
            responses.add(
              Map<String, Object?>.from(jsonDecode(data) as Map),
            );
          }
        });

        // getVersion is the first VM Service Protocol request sent by Dart's
        // debug adapter after VS Code reads a vmServiceInfoFile.
        ideSocket.add(
          jsonEncode({
            'jsonrpc': '2.0',
            'id': 'vscode-handshake',
            'method': 'getVersion',
            'params': <String, Object?>{},
          }),
        );
        // The fake Flutter process cannot publish app.debugPort until this
        // gate opens, so the request above must first be buffered by the real
        // serverpod start VM proxy.
        await Future<void>.delayed(const Duration(milliseconds: 100));
        debugPortGate.writeAsStringSync('publish');

        final response = await responses.stream
            .firstWhere((message) => message['id'] == 'vscode-handshake')
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () => throw TimeoutException(
                'VS Code-style VM-service request did not round-trip.\n'
                '$processOutput',
              ),
            );
        final result = Map<String, Object?>.from(response['result']! as Map);

        expect(result['type'], 'Version');
        expect(result['major'], 4);
        expect(result['servedBy'], 'fake-flutter-vm-service');
      },
    );
  });
}

Future<Uri> _waitForVmServiceInfo(
  File file, {
  required StringBuffer diagnostics,
  required Future<int> processExitCode,
}) async {
  int? exitedWith;
  unawaited(processExitCode.then((exitCode) => exitedWith = exitCode));
  final deadline = DateTime.now().add(const Duration(seconds: 90));
  while (DateTime.now().isBefore(deadline)) {
    if (exitedWith case final exitCode?) {
      throw StateError(
        '`serverpod start` exited with code $exitCode before writing '
        '${file.path}.\n$diagnostics',
      );
    }
    if (file.existsSync()) {
      try {
        final json = jsonDecode(file.readAsStringSync());
        if (json is Map && json['uri'] is String) {
          return Uri.parse(json['uri']! as String);
        }
      } on FormatException {
        // The file may have been observed between creation and its awaited
        // write. Retry until it contains the complete service-info document.
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
  throw TimeoutException(
    'VM-service info file was not written at ${file.path}.\n$diagnostics',
  );
}

extension on Process {
  Future<void> killAndWaitForExit() async {
    this.kill(ProcessSignal.sigint);
    await this.exitCode.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        this.kill(ProcessSignal.sigkill);
        return this.exitCode;
      },
    );
  }
}
