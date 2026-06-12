@Tags(['integration'])
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/src/binary/binary_store.dart';
import 'package:serverpod_embedded_postgres/src/binary/maven_url.dart';
import 'package:test/test.dart';

/// Integration test against the real Zonky artifact on Maven Central.
/// Slow on first run (~20s download + ~30s pure-Dart XZ decode); fast
/// thereafter via the per-user cache. Skip with `dart test --exclude-tags
/// integration` if needed.
///
/// Uses the production user cache so warm-up shared with normal package
/// usage. The cache is intentionally persistent across runs.
void main() {
  group('Given the production Maven server and the host platform', () {
    test(
      'when ensure runs to completion '
      'then bin/postgres and bin/initdb exist, are executable, and a meta.json sentinel records the install.',
      () async {
        var store = BinaryStore();
        var artifact = ZonkyArtifact.forCurrentPlatform(
          version: Version(16, 13, 0),
        );

        var dir = await store.ensure(artifact);

        var exeSuffix = Platform.isWindows ? '.exe' : '';
        var postgres = File(p.join(dir.path, 'bin', 'postgres$exeSuffix'));
        var initdb = File(p.join(dir.path, 'bin', 'initdb$exeSuffix'));
        expect(
          postgres.existsSync(),
          isTrue,
          reason: 'bin/postgres must be present in install dir',
        );
        expect(
          initdb.existsSync(),
          isTrue,
          reason: 'bin/initdb must be present in install dir',
        );

        if (!Platform.isWindows) {
          expect(
            postgres.statSync().mode & 0x40,
            isNot(0),
            reason: 'bin/postgres should be executable on POSIX',
          );
          expect(
            initdb.statSync().mode & 0x40,
            isNot(0),
            reason: 'bin/initdb should be executable on POSIX',
          );
        }

        expect(store.metaFileFor(artifact).existsSync(), isTrue);

        store.close();
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test(
      'when ensure is called twice in a row '
      'then the second call is fast (cache hit) and returns the same directory.',
      () async {
        var store = BinaryStore();
        var artifact = ZonkyArtifact.forCurrentPlatform(
          version: Version(16, 13, 0),
        );

        // Prime the cache (no-op if already warm from the previous test).
        await store.ensure(artifact);

        var sw = Stopwatch()..start();
        var dir = await store.ensure(artifact);
        sw.stop();

        expect(dir.path, store.installDirFor(artifact).path);
        expect(
          sw.elapsedMilliseconds,
          lessThan(500),
          reason: 'cache hit must be <500ms (no HTTP, no extract)',
        );

        store.close();
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}
