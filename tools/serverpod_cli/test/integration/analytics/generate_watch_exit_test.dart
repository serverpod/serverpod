@Timeout(Duration(minutes: 5))
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/messages.dart';
import 'package:test/test.dart';

import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

void main() {
  test(
    'Given generate --watch has an unsent generation burst, '
    'when SIGINT requests shutdown, '
    'then the burst is delivered once before a successful process exit.',
    () => _verifyShutdown(
      signal: ProcessSignal.sigint,
      signalDuringGeneration: false,
    ),
    skip: Platform.isWindows
        ? 'Process.kill cannot send Windows Ctrl+C.'
        : false,
  );

  test(
    'Given generate --watch is generating a changed model, '
    'when SIGTERM requests shutdown, '
    'then the active generation and its analytics finish before exit.',
    () => _verifyShutdown(
      signal: ProcessSignal.sigterm,
      signalDuringGeneration: true,
    ),
    skip: Platform.isWindows ? 'SIGTERM is only handled on POSIX.' : false,
  );
}

Future<void> _verifyShutdown({
  required ProcessSignal signal,
  required bool signalDuringGeneration,
}) async {
  final directory = await Directory.systemTemp.createTemp(
    'generate_watch_exit_',
  );
  addTearDown(() => directory.deleteWithRetry(recursive: true));
  final serverDir = Directory(p.join(directory.path, 'test_server'));
  await createTestEnvironment(serverDir);
  File(p.join(directory.path, 'test_client', 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
name: test_client
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies: {}
''');
  final model =
      File(
          p.join(serverDir.path, 'lib', 'src', 'protocol', 'item.spy.yaml'),
        )
        ..createSync(recursive: true)
        ..writeAsStringSync('''
class: Item
fields:
  name: String
''');

  final receiver = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  addTearDown(() => receiver.close(force: true));
  final events = <Map<String, dynamic>>[];
  final pendingDelivery = Completer<HttpRequest>();
  receiver.listen((request) async {
    final body =
        jsonDecode(await utf8.decoder.bind(request).join())
            as Map<String, dynamic>;
    events.add(body);
    final properties = body['properties'] as Map<String, dynamic>;
    if (body['event'] == 'cli.generate' &&
        properties['is_watch_mode'] == true &&
        !pendingDelivery.isCompleted) {
      pendingDelivery.complete(request);
    } else {
      request.response.write('{"status":1}');
      await request.response.close();
    }
  });

  final process = await Process.start(Platform.resolvedExecutable, [
    p.join(
      await resolveServerpodRoot(),
      'tools',
      'serverpod_cli',
      'test',
      'test_util',
      'generate_watch_exit_driver.dart',
    ),
    'http://127.0.0.1:${receiver.port}',
    serverDir.path,
  ]);
  addTearDown(() async {
    process.kill(ProcessSignal.sigkill);
    await process.exitCode;
  });
  final output = StringBuffer();
  final ready = Completer<void>();
  final generationReached = Completer<void>();
  var modelChanged = false;
  final stdoutDone = process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .forEach((line) {
        output.writeln(line);
        if (line.contains(initialCodeGenerationComplete) &&
            !ready.isCompleted) {
          ready.complete();
        }
        final marker = signalDuringGeneration
            ? 'Analyzing changes...'
            : incrementalCodeGenerationComplete;
        if (modelChanged &&
            line.contains(marker) &&
            !generationReached.isCompleted) {
          generationReached.complete();
        }
      });
  final stderrDone = process.stderr
      .transform(utf8.decoder)
      .forEach(output.write);
  var exited = false;
  final exitCode = process.exitCode.then((code) {
    exited = true;
    return code;
  });

  Future<T> beforeExit<T>(Future<T> completion) => Future.any([
    completion,
    exitCode.then<T>((code) async {
      await Future.wait([stdoutDone, stderrDone]);
      throw StateError('Exited early with $code:\n$output');
    }),
  ]);

  await beforeExit(ready.future);
  modelChanged = true;
  model.writeAsStringSync('''
class: Item
fields:
  name: String
  count: int
''');
  await beforeExit(generationReached.future);

  // The generation marker synchronizes the signal with the actual command;
  // no sleep or synthetic analytics capture stands in for a watch-mode run.
  expect(process.kill(signal), isTrue);
  final request = await beforeExit(pendingDelivery.future);
  final exitedBeforeResponse = exited;
  request.response.write('{"status":1}');
  await request.response.close();
  final code = await exitCode;
  await Future.wait([stdoutDone, stderrDone]);

  final bursts = events.where(
    (event) =>
        event['event'] == 'cli.generate' &&
        (event['properties'] as Map)['is_watch_mode'] == true,
  );
  expect(exitedBeforeResponse, isFalse);
  expect(code, 0, reason: output.toString());
  expect(bursts, hasLength(1));
  expect((bursts.single['properties'] as Map)['incremental_run_count'], 1);
  expect((bursts.single['properties'] as Map)['generation_succeeded'], isTrue);
  final generatedModel = File(
    p.join(serverDir.path, 'lib', 'src', 'generated', 'item.dart'),
  );
  expect(generatedModel.readAsStringSync(), contains('int count;'));
}
