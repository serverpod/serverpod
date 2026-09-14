// Test shim: answers `--version --machine` with a `flutterRoot` pointing at
// the directory given by `--root=<path>`. Stands in for a `flutter` on PATH
// during invocation resolution.
import 'dart:convert';

void main(List<String> args) {
  final root = args
      .where((a) => a.startsWith('--root='))
      .map((a) => a.substring('--root='.length))
      .first;

  print(jsonEncode({'flutterRoot': root}));
}
