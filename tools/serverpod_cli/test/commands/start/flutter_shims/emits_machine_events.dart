// Test shim for [FlutterProcess]: emits a sequence of `--machine`
// JSON events (progress, webLaunchUrl, debugPort, started) over stdout,
// then waits for SIGINT/SIGTERM so the lifecycle methods can be
// exercised.
//
// The `--ws=<uri>` CLI arg controls the `wsUri` reported in
// `app.debugPort`; tests provide a URL that points at their fake VM
// service WebSocket server.
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
    'event': 'app.started',
    'params': {},
  });

  final stopper = Completer<void>();

  // Handle SIGINT (and SIGTERM where supported) cleanly so the shim
  // exits when [FlutterProcess.stop] sends a signal.
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
