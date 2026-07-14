@Timeout(Duration(minutes: 10))
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:test/test.dart';

import '../../test_util/endpoint_validation_helpers.dart';

/// The progress label printed at the start of every watch-mode analysis run.
const _analysisRunMarker = 'Analyzing changes...';

/// Resolves the CLI entry point so the watch mode under test is the real
/// `serverpod generate --watch` process, not an in-process approximation.
Future<String> _cliBinPath() async {
  final uri = await Isolate.resolvePackageUri(
    Uri.parse('package:serverpod_cli/analyzer.dart'),
  );
  if (uri == null) {
    throw StateError('Could not resolve package:serverpod_cli');
  }
  return p.canonicalize(
    p.join(uri.toFilePath(), '..', '..', 'bin', 'serverpod_cli.dart'),
  );
}

void main() {
  group(
    'Given a running generate --watch whose file watcher has processed a '
    'source model change,',
    () {
      late Directory tempDir;
      late Directory serverDir;
      late File modelFile;
      late File generatedProtocolFile;
      late Process watchProcess;
      final output = <String>[];

      Future<void> waitForOutput(
        String needle, {
        int from = 0,
        Duration timeout = const Duration(minutes: 4),
      }) async {
        final deadline = DateTime.now().add(timeout);
        while (DateTime.now().isBefore(deadline)) {
          if (output.skip(from).any((line) => line.contains(needle))) return;
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
        fail(
          'Timed out waiting for "$needle" in the CLI output:\n'
          '${output.join('\n')}',
        );
      }

      int analysisRunsSince(int from) =>
          output.skip(from).where((l) => l.contains(_analysisRunMarker)).length;

      Future<void> touchModelAndAwaitGeneration() async {
        final from = output.length;
        modelFile.writeAsStringSync(modelFile.readAsStringSync());
        await waitForOutput(incrementalCodeGenerationComplete, from: from);
      }

      tearDownAll(() async {
        watchProcess.kill();
        await watchProcess.exitCode.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            watchProcess.kill(ProcessSignal.sigkill);
            return watchProcess.exitCode;
          },
        );
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      });

      setUpAll(() async {
        tempDir = Directory.systemTemp.createTempSync('cli_test_');
        serverDir = Directory(p.join(tempDir.path, 'test_server'));
        await createTestEnvironment(serverDir);

        // The sibling client package GeneratorConfig.load expects.
        File(p.join(tempDir.path, 'test_client', 'pubspec.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
name: test_client

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies: {}
''');

        modelFile = File(
          p.join(serverDir.path, 'lib', 'src', 'protocol', 'item.spy.yaml'),
        )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: Item
fields:
  name: String
''');

        File(
          p.join(serverDir.path, 'lib', 'src', 'endpoints', 'item_endpoint.dart'),
        )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:test_server/src/generated/protocol.dart';

class ItemEndpoint extends Endpoint {
  Future<Item> getItem(Session session, String name) async {
    return Item(name: name);
  }
}
''');

        generatedProtocolFile = File(
          p.join(serverDir.path, 'lib', 'src', 'generated', 'protocol.dart'),
        );

        watchProcess = await Process.start(Platform.resolvedExecutable, [
          await _cliBinPath(),
          '--verbose',
          '--no-analytics',
          '--no-interactive',
          'generate',
          '--watch',
          '--directory',
          serverDir.path,
        ]);
        for (final stream in [watchProcess.stdout, watchProcess.stderr]) {
          stream
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .listen(output.add);
        }

        await waitForOutput(initialCodeGenerationComplete);

        // Prove the file watcher is live before testing what it ignores:
        // a source model change must round-trip through a generation run.
        await touchModelAndAwaitGeneration();
      });

      test(
        'when a generated file changes, '
        'then no generation is triggered by the generated file event.',
        () async {
          final from = output.length;

          // A generated file changing on disk is what every generation run
          // produces; reacting to it would make each run trigger the next.
          generatedProtocolFile.writeAsStringSync(
            '${generatedProtocolFile.readAsStringSync()}\n// touched\n',
          );

          // Long enough for the watcher's debounce (100ms) plus the analysis
          // progress marker to appear if the event were (wrongly) processed.
          await Future<void>.delayed(const Duration(seconds: 3));
          expect(
            analysisRunsSince(from),
            0,
            reason: 'The generated file change must be ignored, '
                'but an analysis run was triggered.',
          );

          // Control: the watcher is still alive and processing source events
          // after having ignored the generated one.
          await touchModelAndAwaitGeneration();
          expect(analysisRunsSince(from), 1);
        },
      );
    },
  );
}
