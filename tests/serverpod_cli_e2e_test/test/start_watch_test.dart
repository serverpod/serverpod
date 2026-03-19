@Timeout(Duration(minutes: 12))
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli_e2e_test/src/keyword_search_in_stream.dart';
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

const startWatchKeywords = [
  'Server running.',
  'Server reloaded.',
  'Server restarted.',
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
  process.stdout
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .listen(streamSearch.onData);
  process.stderr
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .listen(print);

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
    var projectName =
        'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
    var serverDir = path.join(projectName, '${projectName}_server');

    Process? serverProcess;
    KeywordSearchInStream? streamSearch;

    setUpAll(() async {
      var result = await runServerpod(
        ['create', projectName, '--mini'],
        workingDirectory: d.sandbox,
      );
      assert(
        result.exitCode == 0,
        'Failed to create the serverpod project.',
      );
      createDynamicPortConfig(path.join(d.sandbox, serverDir));
    });

    tearDown(() async {
      serverProcess?.kill();
      streamSearch?.cancel();
    });

    group("when running 'serverpod start --watch'", () {
      setUp(() async {
        (serverProcess, streamSearch) = await startServerpodWithStreamSearch(
          ['start', '--watch'],
          workingDirectory: path.join(d.sandbox, serverDir),
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
              d.sandbox,
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
              d.sandbox,
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
              d.sandbox,
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

    group("when running 'serverpod start --watch --no-fes'", () {
      setUp(() async {
        (serverProcess, streamSearch) = await startServerpodWithStreamSearch(
          ['start', '--watch', '--no-fes'],
          workingDirectory: path.join(d.sandbox, serverDir),
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
    });

    group("when running 'serverpod start'", () {
      setUp(() async {
        (serverProcess, streamSearch) = await startServerpodWithStreamSearch(
          ['start'],
          workingDirectory: path.join(d.sandbox, serverDir),
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
              d.sandbox,
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
}
