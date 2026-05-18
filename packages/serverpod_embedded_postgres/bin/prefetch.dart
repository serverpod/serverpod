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

import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';

enum PrefetchOption<V> implements OptionDefinition<V> {
  version(
    StringOption(
      argName: 'version',
      helpText:
          'PG version to fetch (semver). Defaults to $_defaultVersionLiteral.',
    ),
  ),
  target(
    StringOption(
      argName: 'target',
      helpText:
          'Zonky platform suffix (e.g. linux-amd64, darwin-arm64v8, '
          'windows-amd64). Defaults to the host platform.',
    ),
  ),
  help(
    FlagOption(
      argName: 'help',
      argAbbrev: 'h',
      negatable: false,
      defaultsTo: false,
      helpText: 'Show this usage information.',
    ),
  )
  ;

  const PrefetchOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

// Keep in sync with [defaultPostgresVersion]. Inlined as a literal so the
// helpText (which must be const) can interpolate it.
const _defaultVersionLiteral = '16.13.0';

Future<void> main(List<String> args) async {
  final Configuration<PrefetchOption> config;
  try {
    config = Configuration.resolve(
      options: PrefetchOption.values,
      args: args,
      env: Platform.environment,
    );
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  }

  if (config.value(PrefetchOption.help)) {
    stdout.writeln(config.usage);
    return;
  }

  var rawVersion = config.optionalValue(PrefetchOption.version);
  Version version;
  try {
    version = rawVersion != null
        ? Version.parse(rawVersion)
        : defaultPostgresVersion;
  } on FormatException catch (e) {
    stderr.writeln('Invalid --version "$rawVersion": ${e.message}');
    exit(64);
  }
  var target = config.optionalValue(PrefetchOption.target);

  stdout.writeln('Prefetching PG $version (${target ?? "host platform"})...');
  var sw = Stopwatch()..start();
  try {
    await EmbeddedPostgres.prefetch(version, target: target);
    sw.stop();
    stdout.writeln('Done in ${sw.elapsedMilliseconds}ms.');
  } on Exception catch (e, st) {
    stderr
      ..writeln('Prefetch failed: $e')
      ..writeln(st);
    exit(1);
  }
}
