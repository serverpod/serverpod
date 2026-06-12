import 'dart:io';

import 'package:path/path.dart' as p;

/// Path to a PG binary [name] (`postgres`, `pg_ctl`, `initdb`) in
/// [installDir]'s `bin/`, with `.exe` on Windows.
///
/// The extension matters: `Process.start` works without it because
/// `CreateProcess` auto-resolves `name.exe`, but the path we persist must
/// match what `QueryFullProcessImageNameW` reports so orphan-identity checks
/// don't classify our own postmaster as foreign.
String binExecutable(Directory installDir, String name) {
  var fileName = Platform.isWindows ? '$name.exe' : name;
  return p.join(installDir.path, 'bin', fileName);
}
