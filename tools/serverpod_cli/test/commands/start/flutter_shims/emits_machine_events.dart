// Test shim: emits a fixed `--machine` event sequence, then waits for
// SIGINT/SIGTERM. `--ws=<uri>` overrides the wsUri in app.debugPort.
// `--pid-file=<path>` writes the shim's pid there on startup, so a test
// can kill the process directly to simulate a spontaneous app exit
// (e.g. browser closed).
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final pidFile = args
      .where((a) => a.startsWith('--pid-file='))
      .map((a) => a.substring('--pid-file='.length))
      .firstOrNull;
  if (pidFile != null) File(pidFile).writeAsStringSync('$pid');

  final wsUri = args
      .firstWhere(
        (a) => a.startsWith('--ws='),
        orElse: () => '--ws=ws://127.0.0.1:0/ws',
      )
      .substring('--ws='.length);
  final webUrl = args
      .firstWhere(
        (a) => a.startsWith('--web-url='),
        orElse: () => '--web-url=http://localhost:54321',
      )
      .substring('--web-url='.length);

  void emit(Map<String, Object?> event) {
    stdout.writeln(jsonEncode([event]));
  }

  emit({
    'event': 'app.progress',
    'params': {'message': 'Launching ...'},
  });
  emit({
    'event': 'app.webLaunchUrl',
    'params': {'url': webUrl},
  });
  emit({
    'event': 'app.debugPort',
    'params': {'wsUri': wsUri, 'port': Uri.parse(wsUri).port},
  });
  emit({
    'event': 'app.dtd',
    'params': {'uri': 'ws://127.0.0.1:9100/ws'},
  });
  emit({
    'event': 'app.started',
    'params': {},
  });

  final stopper = Completer<void>();

  ProcessSignal.sigint.watch().listen((_) {
    if (!stopper.isCompleted) stopper.complete();
  });
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) {
      if (!stopper.isCompleted) stopper.complete();
    });
  }

  await stopper.future;
}
