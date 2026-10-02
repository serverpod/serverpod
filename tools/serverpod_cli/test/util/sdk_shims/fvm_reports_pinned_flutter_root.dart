// Test shim: stands in for a `flutter` on PATH that runs `fvm flutter`,
// answering `--version --machine`. Like fvm, it walks up from the
// directory it runs in to the filesystem root looking for a
// `.fvmrc` pin, and reports the `flutterRoot` it holds. Real fvm stores a
// version there instead. With no pin it reports the root given by
// `--global=<path>`, or fails when there is none.
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final global = args
      .where((a) => a.startsWith('--global='))
      .map((a) => a.substring('--global='.length))
      .firstOrNull;

  String? root = global;
  var dir = Directory.current.absolute;
  while (true) {
    final pin = File('${dir.path}${Platform.pathSeparator}.fvmrc');
    if (pin.existsSync()) {
      root = pin.readAsStringSync().trim();
      break;
    }
    if (dir.parent.path == dir.path) break;
    dir = dir.parent;
  }

  if (root == null) exit(1);
  print(jsonEncode({'flutterRoot': root}));
}
