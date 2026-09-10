// Test shim: succeeds but answers `--version --machine` with plain text
// instead of JSON, the way a `flutter` that ignores `--machine` would.
void main() {
  print('Flutter 3.32.0 • channel stable');
}
