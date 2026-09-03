import 'dart:io';

import 'package:serverpod_cli/src/util/dart_install.dart';

/// Drives [runDartInstall] so the test can vary the environment around it.
///
/// The descriptor names a package that cannot resolve, so a working
/// `dart install` fails version solving and installs nothing. A non-zero
/// exit means the call threw instead of reporting a failed install.
Future<void> main() async {
  final result = await runDartInstall(
    'serverpod_cli_no_such_package',
    message: 'Installing',
  );
  print('success=${result.success}');

  exit(0);
}
