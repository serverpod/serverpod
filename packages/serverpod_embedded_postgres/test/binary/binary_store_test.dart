import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/binary/binary_store.dart';
import 'package:serverpod_embedded_postgres/src/binary/maven_url.dart';
import 'package:test/test.dart';

void main() {
  late Directory cache;
  late ZonkyArtifact artifact;

  setUp(() {
    cache = Directory.systemTemp.createTempSync('binary_store_test_');
    artifact = ZonkyArtifact(
      version: Version(16, 13, 0),
      platform: 'darwin-amd64',
    );
  });

  tearDown(() {
    if (cache.existsSync()) cache.deleteSync(recursive: true);
  });

  group('Given installDirFor', () {
    test(
      'when called for a (version, platform) tuple '
      'then the path layers cache root / BOM / platform.',
      () {
        var store = BinaryStore(cacheRoot: cache);

        var dir = store.installDirFor(artifact);

        expect(
          dir.path,
          p.join(cache.path, '16.13.0', 'darwin-amd64'),
        );

        store.close();
      },
    );
  });

  group('Given a populated cache', () {
    test(
      'when ensure is called and meta.json exists '
      'then no HTTP requests are issued and the install dir is returned.',
      () async {
        var requests = 0;
        var store = BinaryStore(
          cacheRoot: cache,
          httpClient: MockClient((req) async {
            requests++;
            return http.Response('SHOULD-NOT-FETCH', 500);
          }),
        );
        var meta = store.metaFileFor(artifact);
        meta.parent.createSync(recursive: true);
        meta.writeAsStringSync('{"bom":"16.13.0"}');

        var dir = await store.ensure(artifact);

        expect(dir.path, store.installDirFor(artifact).path);
        expect(requests, 0, reason: 'cache hit must not fetch');
      },
    );
  });

  // The "ensure produces a working install" happy path needs real Zonky
  // bytes (synthetic JARs hit package:archive 3.6.x's XZEncoder/XZDecoder
  // roundtrip bug). Phase 2e covers it as an integration test against a
  // genuine Maven artifact. Per "test our code, trust upstream", we don't
  // pad here with a synthetic-pipeline test.

  group('Given a server delivering a JAR with a sha mismatch', () {
    test(
      'when ensure runs '
      'then BinaryVerificationException is thrown and the install dir is left absent (caller can retry).',
      () async {
        var jarBytes = _buildSyntheticJar();
        var bogusSha = 'a' * 64;
        var store = BinaryStore(
          cacheRoot: cache,
          httpClient: _maven(artifact, jarBytes: jarBytes, sha256: bogusSha),
        );

        await expectLater(
          store.ensure(artifact),
          throwsA(isA<BinaryVerificationException>()),
        );
        expect(store.installDirFor(artifact).existsSync(), isFalse);

        store.close();
      },
    );
  });

  group('Given a malformed sha256 sidecar', () {
    test(
      'when the body is not a 64-char hex string '
      'then BinaryFetchException is thrown.',
      () async {
        var jarBytes = _buildSyntheticJar();
        var store = BinaryStore(
          cacheRoot: cache,
          httpClient: _maven(
            artifact,
            jarBytes: jarBytes,
            sha256: 'not-a-real-sha',
          ),
        );

        await expectLater(
          store.ensure(artifact),
          throwsA(isA<BinaryFetchException>()),
        );

        store.close();
      },
    );
  });

  group('Given an empty cache and 4 concurrent isolates', () {
    test(
      'when each isolate calls ensure '
      'then exactly one fetches the JAR and all four return the same install dir.',
      () async {
        var jarBytes = _buildSyntheticJar();
        var shaHex = sha256.convert(jarBytes).toString();

        var tracker = File(p.join(cache.path, 'fetches.log'));
        tracker.writeAsStringSync('');

        var ports = List.generate(4, (_) => ReceivePort());
        var isolates = <Isolate>[];
        for (var i = 0; i < ports.length; i++) {
          isolates.add(
            await Isolate.spawn(
              _concurrentWorker,
              (
                port: ports[i].sendPort,
                cachePath: cache.path,
                trackerPath: tracker.path,
                jarBytes: jarBytes,
                shaHex: shaHex,
              ),
              debugName: 'worker-$i',
            ),
          );
        }

        var results = await Future.wait(ports.map((p) => p.first));
        for (var port in ports) {
          port.close();
        }
        for (var iso in isolates) {
          iso.kill(priority: Isolate.immediate);
        }

        // All four returned the same install dir.
        expect(
          results.toSet(),
          hasLength(1),
          reason: 'all isolates should resolve to one install dir',
        );

        // Exactly one fetch hit the mock - the others rode the winner's
        // coattails via the claim file.
        var fetches = tracker
            .readAsLinesSync()
            .where((l) => l.isNotEmpty)
            .toList();
        expect(
          fetches,
          hasLength(1),
          reason:
              'expected exactly one JAR fetch across 4 isolates, got: $fetches',
        );
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });

  group('Given a stale claim file (mtime older than staleAfter)', () {
    test(
      'when ensure runs '
      'then the claim is stolen and the extract proceeds to write meta.',
      () async {
        var jarBytes = _buildSyntheticJar();
        var shaHex = sha256.convert(jarBytes).toString();

        var claim = File(
          p.join(cache.path, '${artifact.bom}.${artifact.platform}.claim'),
        );
        cache.createSync(recursive: true);
        claim.createSync();
        claim.setLastModifiedSync(
          DateTime.now().subtract(const Duration(hours: 1)),
        );

        var store = BinaryStore(
          cacheRoot: cache,
          httpClient: _maven(artifact, jarBytes: jarBytes, sha256: shaHex),
          staleAfter: const Duration(seconds: 1),
          pollInterval: const Duration(milliseconds: 20),
        );

        await store.ensure(artifact);

        expect(store.metaFileFor(artifact).existsSync(), isTrue);
        expect(
          claim.existsSync(),
          isFalse,
          reason: 'winning extractor must release its claim',
        );

        store.close();
      },
      timeout: const Timeout(Duration(seconds: 10)),
    );
  });

  group(
    'Given a fresh claim file (not yet stale) and a short hard timeout',
    () {
      test(
        'when ensure runs '
        'then it throws BinaryFetchException citing the claim, without fetching.',
        () async {
          var requests = 0;
          var claim = File(
            p.join(cache.path, '${artifact.bom}.${artifact.platform}.claim'),
          );
          cache.createSync(recursive: true);
          claim.createSync();

          var store = BinaryStore(
            cacheRoot: cache,
            httpClient: MockClient((req) async {
              requests++;
              return http.Response('unexpected', 500);
            }),
            staleAfter: const Duration(minutes: 5),
            hardTimeout: const Duration(milliseconds: 250),
            pollInterval: const Duration(milliseconds: 20),
          );

          await expectLater(
            store.ensure(artifact),
            throwsA(
              isA<BinaryFetchException>().having(
                (e) => e.toString(),
                'message',
                allOf(contains('Timed out'), contains(claim.path)),
              ),
            ),
          );
          expect(requests, 0, reason: 'loser must not issue HTTP');

          store.close();
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );
    },
  );

  group(
    'Given an installDir from a prior winner that crashed before writing meta',
    () {
      test(
        'when ensure runs again '
        'then it re-extracts cleanly (installDir is replaced, meta is written).',
        () async {
          var installDir = Directory(
            p.join(cache.path, artifact.bom, artifact.platform),
          );
          installDir.createSync(recursive: true);
          // Sentinel from the "crashed" install - must NOT survive re-extract.
          File(
            p.join(installDir.path, 'leftover.txt'),
          ).writeAsStringSync('from a crashed prior run');

          var jarBytes = _buildSyntheticJar();
          var shaHex = sha256.convert(jarBytes).toString();
          var store = BinaryStore(
            cacheRoot: cache,
            httpClient: _maven(artifact, jarBytes: jarBytes, sha256: shaHex),
          );

          await store.ensure(artifact);

          expect(store.metaFileFor(artifact).existsSync(), isTrue);
          expect(
            File(p.join(installDir.path, 'leftover.txt')).existsSync(),
            isFalse,
            reason: 'a fresh extract must replace the old installDir',
          );
          // Synthetic JAR's only entry is bin/postgres.
          expect(
            File(p.join(installDir.path, 'bin', 'postgres')).existsSync(),
            isTrue,
          );

          store.close();
        },
        timeout: const Timeout(Duration(seconds: 10)),
      );
    },
  );
}

/// Mock client that responds to the JAR URL and the sidecar URL for a given
/// artifact. Anything else 404s, so missed fetches surface as test failures.
MockClient _maven(
  ZonkyArtifact artifact, {
  required Uint8List jarBytes,
  required String sha256,
}) {
  return MockClient((req) async {
    if (req.url == artifact.jarUrl) {
      return http.Response.bytes(jarBytes, 200);
    }
    if (req.url == artifact.sha256Url) {
      return http.Response(sha256, 200);
    }
    return http.Response('not found', 404);
  });
}

/// Smallest possible JAR that BinaryStore + ZonkyArchive will accept:
/// a zip containing a single .txz at the root, the txz being an XZ-wrapped
/// tar with a single file `bin/postgres` (mode 0o755).
Uint8List _buildSyntheticJar() {
  var tar = Archive();
  tar.addFile(
    ArchiveFile('bin/postgres', 1, [0])..mode = 0x1ED, // 0o755
  );
  var tarBytes = TarEncoder().encode(tar);
  var txzBytes = XZEncoder().encode(tarBytes);

  var zip = Archive();
  zip.addFile(ArchiveFile('postgres-test.txz', txzBytes.length, txzBytes));
  return Uint8List.fromList(ZipEncoder().encode(zip));
}

typedef _WorkerMsg = ({
  SendPort port,
  String cachePath,
  String trackerPath,
  Uint8List jarBytes,
  String shaHex,
});

/// Top-level so `Isolate.spawn` can find it. Each isolate creates its own
/// BinaryStore against the same cacheRoot and races on the claim file. The
/// JAR fetch appends to a shared tracker file; the test counts entries to
/// verify exactly one winner did the download.
Future<void> _concurrentWorker(_WorkerMsg msg) async {
  var artifact = ZonkyArtifact(
    version: Version(16, 13, 0),
    platform: 'darwin-amd64',
  );
  var trackerFile = File(msg.trackerPath);
  var client = MockClient((req) async {
    if (req.url == artifact.jarUrl) {
      // Append-mode write is atomic for small payloads on POSIX - good
      // enough for "did anyone fetch?" counting. We don't rely on order.
      trackerFile.writeAsStringSync(
        'fetch\n',
        mode: FileMode.append,
        flush: true,
      );
      return http.Response.bytes(msg.jarBytes, 200);
    }
    if (req.url == artifact.sha256Url) {
      return http.Response(msg.shaHex, 200);
    }
    return http.Response('not found', 404);
  });
  var store = BinaryStore(
    cacheRoot: Directory(msg.cachePath),
    httpClient: client,
    pollInterval: const Duration(milliseconds: 20),
  );
  try {
    var dir = await store.ensure(artifact);
    msg.port.send(dir.path);
  } finally {
    store.close();
  }
}
