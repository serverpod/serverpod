// Test shim: emits the `--machine` event sequence of a desktop-device run
// (e.g. `-d linux`) - progress, debugPort, and started, but no
// `app.webLaunchUrl` (that event is web-only) - then waits for
// SIGINT/SIGTERM. `--ws=<uri>` overrides the wsUri in app.debugPort.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final wsUri = args
      .firstWhere(
        (a) => a.startsWith('--ws='),
        orElse: () => '--ws=ws://127.0.0.1:0/ws',
      )
      .substring('--ws='.length);

  void emit(Map<String, Object?> event) {
    stdout.writeln(jsonEncode([event]));
  }

  emit({
    'event': 'app.progress',
    'params': {'message': 'Syncing files to device Linux...'},
  });
  emit({
    'event': 'app.debugPort',
    'params': {'wsUri': wsUri, 'port': Uri.parse(wsUri).port},
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
