@Timeout(Duration(minutes: 10))
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:test/test.dart';

import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

/// The progress label printed at the start of every watch-mode analysis run.
const _analysisRunMarker = 'Analyzing changes...';

void main() {
  group('Given a live generate --watch process,', () {
    Directory? tempDir;
    Process? watchProcess;
    late File modelFile;
    late File generatedProtocolFile;
    final output = <String>[];

    tearDownAll(() async {
      final process = watchProcess;
      if (process != null) {
        process.kill();
        await process.exitCode.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            process.kill(ProcessSignal.sigkill);
            return process.exitCode;
          },
        );
      }

      final directory = tempDir;
      if (directory != null) {
        await directory.deleteWithRetry(recursive: true);
      }
    });

    setUpAll(() async {
      final directory = Directory.systemTemp.createTempSync('cli_test_');
      tempDir = directory;

      final serverDir = Directory(p.join(directory.path, 'test_server'));
      await createTestEnvironment(serverDir);

      // The sibling client package GeneratorConfig.load expects.
      File(p.join(directory.path, 'test_client', 'pubspec.yaml'))
        ..createSync(recursive: true)
        ..writeAsStringSync('''
name: test_client

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies: {}
''');

      modelFile =
          File(
              p.join(
                serverDir.path,
                'lib',
                'src',
                'protocol',
                'item.spy.yaml',
              ),
            )
            ..createSync(recursive: true)
            ..writeAsStringSync('''
class: Item
fields:
  name: String
''');

      generatedProtocolFile = File(
        p.join(serverDir.path, 'lib', 'src', 'generated', 'protocol.dart'),
      );

      final process = await Process.start(Platform.resolvedExecutable, [
        await resolveServerpodCliEntrypoint(),
        '--verbose',
        '--no-analytics',
        '--no-interactive',
        'generate',
        '--watch',
        '--directory',
        serverDir.path,
      ]);
      watchProcess = process;

      for (final stream in [process.stdout, process.stderr]) {
        stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(output.add);
      }

      await _waitForOutput(initialCodeGenerationComplete, output: output);

      // Prove the file watcher is live before testing what it ignores.
      final outputStart = output.length;
      modelFile.writeAsStringSync('''
class: Item
fields:
  name: String
  count: int
''');
      await _waitForOutput(
        incrementalCodeGenerationComplete,
        from: outputStart,
        output: output,
      );
    });

    group('when a generated file changes,', () {
      late List<String> outputAfterGeneratedFileChange;

      setUpAll(() async {
        final outputStart = output.length;

        // This is what every generation run produces. Reacting to the change
        // would make each generation run trigger the next one.
        generatedProtocolFile.writeAsStringSync(
          '${generatedProtocolFile.readAsStringSync()}\n// touched\n',
        );

        // Long enough for the watcher's debounce (100ms) plus the analysis
        // progress marker to appear if the event were processed.
        await Future<void>.delayed(const Duration(seconds: 3));
        outputAfterGeneratedFileChange = output.skip(outputStart).toList();
      });

      test('then the change does not trigger an analysis run.', () {
        expect(
          outputAfterGeneratedFileChange.where(
            (line) => line.contains(_analysisRunMarker),
          ),
          isEmpty,
          reason: 'The generated file change must be ignored.',
        );
      });

      test(
        'then subsequent source changes still trigger an analysis run.',
        () async {
          final outputStart = output.length;
          modelFile.writeAsStringSync('''
class: Item
fields:
  name: String
  count: int
  description: String
''');
          await _waitForOutput(
            incrementalCodeGenerationComplete,
            from: outputStart,
            output: output,
          );

          expect(
            output
                .skip(outputStart)
                .where((line) => line.contains(_analysisRunMarker)),
            hasLength(1),
          );
        },
      );
    });
  });
}

Future<void> _waitForOutput(
  String needle, {
  required List<String> output,
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
