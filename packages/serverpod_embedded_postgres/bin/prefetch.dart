/// Pre-populate the per-user binary cache for a given PG version.
///
/// Useful for CI warm-up and offline prep. Invoked as:
///
///   dart run serverpod_embedded_postgres:prefetch
///   dart run serverpod_embedded_postgres:prefetch --version 16.13.0
///   dart run serverpod_embedded_postgres:prefetch --target linux-amd64
///
/// `--target` lets a CI host warm caches for non-host platforms (e.g.,
/// pre-extract the linux-amd64 bundle on a macOS runner that will later
/// upload it to a shared cache).
library;

import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';

Future<void> main(List<String> args) async {
  Version version = defaultPostgresVersion;
  String? target;

  for (var i = 0; i < args.length; i++) {
    var arg = args[i];
    if (arg.startsWith('--version=')) {
      version = _parseVersion(arg.substring('--version='.length));
    } else if (arg == '--version' && i + 1 < args.length) {
      version = _parseVersion(args[++i]);
    } else if (arg.startsWith('--target=')) {
      target = arg.substring('--target='.length);
    } else if (arg == '--target' && i + 1 < args.length) {
      target = args[++i];
    } else if (arg == '--help' || arg == '-h') {
      stdout.writeln(_helpText);
      return;
    } else {
      stderr.writeln('Unknown argument: $arg');
      stderr.writeln(_helpText);
      exit(64); // EX_USAGE
    }
  }

  stdout.writeln('Prefetching PG $version (${target ?? "host platform"})...');
  var sw = Stopwatch()..start();
  try {
    await EmbeddedPostgres.prefetch(version, target: target);
    sw.stop();
    stdout.writeln('Done in ${sw.elapsedMilliseconds}ms.');
  } on Exception catch (e) {
    stderr.writeln('Prefetch failed: $e');
    exit(1);
  }
}

const String _helpText =
    '''
Pre-populate the per-user binary cache for a given PG version.

Usage:
  dart run serverpod_embedded_postgres:prefetch [--version <semver>] [--target <platform>]

Options:
  --version <semver>   PG version to fetch (default: $defaultPostgresVersionLiteral).
  --target <platform>  Zonky platform suffix (e.g., linux-amd64,
                       darwin-arm64v8, windows-amd64). Defaults to the host
                       platform via Abi.current().
  -h, --help           Show this help text.
''';

const String _defaultPostgresVersionLiteral = '16.13.0';

// Gives the help text a stable string for the default at compile time.
// (Avoids interpolating defaultPostgresVersion at runtime in a const.)
const String defaultPostgresVersionLiteral = _defaultPostgresVersionLiteral;

Version _parseVersion(String s) {
  try {
    return Version.parse(s);
  } on FormatException catch (e) {
    stderr.writeln('Invalid --version "$s": ${e.message}');
    exit(64);
  }
}
