// Test shim: stands in for a version manager's `flutter` that binds an SDK to
// a directory, the way `puro use` does. Reports the `flutterRoot` held in a
// `.flutter_env` file in the directory it runs in, or the root given by
// `--unbound=<path>` when there is none.
import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final env = File('.flutter_env');
  final root = env.existsSync()
      ? env.readAsStringSync().trim()
      : args
            .where((a) => a.startsWith('--unbound='))
            .map((a) => a.substring('--unbound='.length))
            .first;

  print(jsonEncode({'flutterRoot': root}));
}
