// Test shim: stands in for a `flutter` wrapper that answers
// `--version --machine` with the `flutterRoot` given by `--root=<path>` and
// exits, leaving behind a child that keeps the wrapper's stdout open.
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final root = args
      .where((a) => a.startsWith('--root='))
      .map((a) => a.substring('--root='.length))
      .first;

  print(jsonEncode({'flutterRoot': root}));

  await Process.start(
    Platform.resolvedExecutable,
    [Platform.script.resolve('never_answers.dart').toFilePath()],
    mode: ProcessStartMode.inheritStdio,
    // Not the directory the test is about to delete.
    workingDirectory: Directory.systemTemp.path,
  );
  exit(0);
}
