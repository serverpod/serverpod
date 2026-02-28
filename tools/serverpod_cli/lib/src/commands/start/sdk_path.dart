import 'dart:io';

import 'package:path/path.dart' as p;

/// Whether this process is running as an AOT-compiled executable.
bool get _isCompiled {
  final exe = p.basename(Platform.resolvedExecutable);
  return exe != 'dart' && exe != 'dart.exe';
}

/// Resolve the SDK path from a dart executable path.
///
/// The dart binary lives at `<sdk>/bin/dart`, so go up two levels.
String _sdkFromExe(String dartExe) => p.dirname(p.dirname(dartExe));

/// Get the Dart SDK path.
///
/// Tries in order:
/// 1. DART_SDK environment variable
/// 2. Platform.resolvedExecutable (reliable when running via `dart`)
/// 3. Shell out to `dart` to resolve its executable path (when AOT-compiled)
String getSdkPath() {
  final dartSdkEnv = Platform.environment['DART_SDK'];
  if (dartSdkEnv != null && dartSdkEnv.isNotEmpty) {
    return dartSdkEnv;
  }

  // When running as JIT, Platform.resolvedExecutable points to the SDK's
  // dart binary - we can derive the SDK path directly.
  if (!_isCompiled) {
    return _sdkFromExe(Platform.resolvedExecutable);
  }

  // AOT-compiled: Platform.resolvedExecutable is our own binary, not dart.
  // Shell out to `dart` running a tiny script that prints its own resolved
  // executable path. This works through wrapper scripts, shims, etc.
  final script = File(
    p.join(Directory.systemTemp.path, '_serverpod_sdk_probe.dart'),
  );
  try {
    script.writeAsStringSync(
      'import "dart:io"; void main() => print(Platform.resolvedExecutable);',
    );
    final result = Process.runSync('dart', [script.path]);
    if (result.exitCode == 0) {
      return _sdkFromExe((result.stdout as String).trim());
    }
  } finally {
    if (script.existsSync()) script.deleteSync();
  }

  throw StateError(
    'Could not locate Dart SDK. Set the DART_SDK environment variable or '
    'ensure `dart` is on your PATH.',
  );
}
