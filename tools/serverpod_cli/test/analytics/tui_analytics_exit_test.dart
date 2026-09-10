import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/endpoint_validation_helpers.dart';

void main() {
  test(
    'Given pending command, session, and watch-mode events, '
    'when the TUI backend exits with an error code, '
    'then all events reach PostHog before the process exits with that code.',
    () async {
      await d.dir('.git', [d.file('config', '')]).create();
      await d.dir('myapp_server', [
        d.file('pubspec.yaml', 'name: myapp_server'),
      ]).create();
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      final events = <String>[];
      final requests = <HttpRequest>[];
      final allReceived = Completer<void>();
      server.listen((request) async {
        final body =
            jsonDecode(await utf8.decoder.bind(request).join())
                as Map<String, dynamic>;
        events.add(body['event'] as String);
        requests.add(request);
        if (requests.length == 3) allReceived.complete();
      });
      final driver = p.join(
        await resolveServerpodRoot(),
        'tools',
        'serverpod_cli',
        'test',
        'test_util',
        'analytics_exit_driver.dart',
      );
      final process = await Process.start(Platform.resolvedExecutable, [
        driver,
        'http://127.0.0.1:${server.port}',
        p.join(d.sandbox, 'myapp_server'),
        '7',
      ]);
      addTearDown(process.kill);
      final output = utf8.decoder.bind(process.stdout).join();
      final errors = utf8.decoder.bind(process.stderr).join();
      var exited = false;
      final exitCode = process.exitCode.then((code) {
        exited = true;
        return code;
      });

      // A completion signal from the HTTP receiver replaces a timing guess.
      // Surface an early child exit immediately instead of hanging for events.
      await Future.any([
        allReceived.future,
        exitCode.then((code) async {
          if (!allReceived.isCompleted) {
            fail('Exited with $code before delivery: ${await errors}');
          }
        }),
      ]);
      final exitedBeforeResponses = exited;
      for (final request in requests) {
        request.response.write('{"status":1}');
        await request.response.close();
      }
      final code = await exitCode;
      await output;
      final stderr = await errors;

      expect(exitedBeforeResponses, isFalse);
      expect(
        events,
        unorderedEquals(['start', 'cli.session_start', 'cli.generate']),
      );
      expect(code, 7, reason: stderr);
    },
    // The child compiles the CLI libraries before exercising shutdown.
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
