import 'dart:io';
import 'package:path/path.dart' as p;

/// Find the path to the Dart SDK
// This is needed to work around this issue with the analyzer package:
// https://github.com/dart-lang/sdk/issues/48002
String? findDartSdk() {
  // If running as a script, resolvedExecutable points to dart binary
  var dartSdk = _sdkPathFromDartExe(Platform.resolvedExecutable);
  if (dartSdk != null) return dartSdk;

  // AOT compiled — check explicit env vars
  dartSdk = Platform.environment['DART_SDK'];
  if (dartSdk != null && _isValidSdk(dartSdk)) return dartSdk;

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    final sdk = p.join(flutterRoot, 'bin', 'cache', 'dart-sdk');
    if (_isValidSdk(sdk)) return sdk;
  }

  // Fall back to PATH
  final result = Process.runSync(
    Platform.isWindows ? 'where' : 'which',
    ['dart'],
  );

  if (result.exitCode != 0) return null;

  final dartBin = (result.stdout as String).trim().split('\n').first;
  final resolved = File(dartBin).resolveSymbolicLinksSync();

  return _sdkPathFromDartExe(resolved);
}

String? _sdkPathFromDartExe(String dartExe) {
  final dir = p.absolute(p.dirname(dartExe));
  final exe = p.basenameWithoutExtension(dartExe);
  if (exe == 'dart') {
    // Check for flutter install
    var sdk = p.join(dir, 'cache', 'dart-sdk');
    if (_isValidSdk(sdk)) return sdk;
    // Check for pure dart install
    sdk = p.dirname(dir);
    if (_isValidSdk(sdk)) return sdk;
  }
  return null;
}

bool _isValidSdk(String path) => File(p.join(path, 'version')).existsSync();
