// Test shim: stands in for a `flutter` on PATH that hangs instead of answering.
// Exits on its own after a while, so a copy the test could not kill does not
// outlive the run for long.
Future<void> main() async {
  await Future<void>.delayed(const Duration(seconds: 30));
}
