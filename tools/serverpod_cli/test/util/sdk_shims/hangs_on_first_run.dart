// Test shim: stands in for a `flutter` on PATH that hangs the first time it is
// run and answers after that, the way one busy setting itself up would.
// `--state=<file>` is where it remembers that it has run before. The hung run
// exits on its own after a while, so a copy the test could not kill does not
// outlive the run for long.
import 'dart:io';

Future<void> main(List<String> args) async {
  final state = File(
    args
        .where((a) => a.startsWith('--state='))
        .map((a) => a.substring('--state='.length))
        .first,
  );
  if (state.existsSync()) {
    print('Flutter 3.32.0 • channel stable');
    return;
  }

  state.createSync();
  await Future<void>.delayed(const Duration(seconds: 30));
}
