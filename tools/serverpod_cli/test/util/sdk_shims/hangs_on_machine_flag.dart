// Test shim: stands in for a `flutter` on PATH that hangs when asked
// `--version --machine` and answers a plain `--version`, the way one too busy
// to answer the first time would by the second. The hung run exits on its own
// after a while, so a copy the test could not kill does not outlive the run
// for long.
Future<void> main(List<String> args) async {
  if (!args.contains('--machine')) {
    print('Flutter 3.32.0 • channel stable');
    return;
  }

  await Future<void>.delayed(const Duration(seconds: 30));
}
