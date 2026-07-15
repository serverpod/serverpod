import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/binary/binary_store.dart';
import 'package:serverpod_embedded_postgres/src/binary/bundle_builder.dart';
import 'package:serverpod_embedded_postgres/src/binary/bundle_spec.dart';
import 'package:serverpod_embedded_postgres/src/binary/maven_url.dart';
import 'package:serverpod_embedded_postgres/src/binary/serverpod_bundle.dart';
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

  group('Given two revisions of the same PG version,', () {
    late _FakeBundleArtifact r1;
    late _FakeBundleArtifact r2;

    setUp(() {
      r1 = _FakeBundleArtifact(spec: _specWithRevision(1));
      r2 = _FakeBundleArtifact(spec: _specWithRevision(2));
    });

    test(
      'when resolving their install dirs '
      'then each revision gets its own directory.',
      () {
        var store = BinaryStore(cacheRoot: cache);

        expect(
          store.installDirFor(r1).path,
          isNot(store.installDirFor(r2).path),
        );

        store.close();
      },
    );

    test(
      'when revision 1 is already cached and ensure runs for revision 2 '
      'then revision 2 is downloaded rather than served from the stale cache.',
      () async {
        var bytes = Uint8List.fromList([1, 2, 3]);
        var shaHex = sha256.convert(bytes).toString();
        var downloads = <Uri>[];
        var store = BinaryStore(
          cacheRoot: cache,
          httpClient: MockClient((req) async {
            if (req.url == r2.archiveUrl) {
              downloads.add(req.url);
              return http.Response.bytes(bytes, 200);
            }
            if (req.url == r2.sha256Url) return http.Response(shaHex, 200);
            return http.Response('not found', 404);
          }),
        );
        var r1Dir = await _installFake(store, r1);

        var r2Dir = await store.ensure(r2);

        expect(downloads, [r2.archiveUrl]);
        expect(r2Dir.path, isNot(r1Dir.path));
        expect(store.metaFileFor(r2).existsSync(), isTrue);

        store.close();
      },
    );

    test(
      'when ensure runs concurrently for both revisions, '
      'then both installs proceed independently.',
      () async {
        var bytes = Uint8List.fromList([1, 2, 3]);
        var shaHex = sha256.convert(bytes).toString();
        var activeDownloads = 0;
        var maximumActiveDownloads = 0;
        var store = BinaryStore(
          cacheRoot: cache,
          httpClient: MockClient((req) async {
            if (req.url == r1.archiveUrl || req.url == r2.archiveUrl) {
              activeDownloads++;
              maximumActiveDownloads = max(
                maximumActiveDownloads,
                activeDownloads,
              );
              await Future<void>.delayed(const Duration(milliseconds: 100));
              activeDownloads--;
              return http.Response.bytes(bytes, 200);
            }
            if (req.url == r1.sha256Url || req.url == r2.sha256Url) {
              return http.Response(shaHex, 200);
            }
            return http.Response('not found', 404);
          }),
          pollInterval: const Duration(milliseconds: 10),
          hardTimeout: const Duration(seconds: 2),
        );

        var installs = await Future.wait([
          store.ensure(r1),
          store.ensure(r2),
        ]);

        expect(maximumActiveDownloads, 2);
        expect(installs[0].path, isNot(installs[1].path));
        expect(store.metaFileFor(r1).existsSync(), isTrue);
        expect(store.metaFileFor(r2).existsSync(), isTrue);

        store.close();
      },
    );
  });

  group('Given a release asset that is not published (404) '
      'and an available builder', () {
    test(
      'when ensure runs in the default download mode '
      'then BinaryFetchException(404) is thrown and the builder is never invoked.',
      () async {
        var store = BinaryStore(
          cacheRoot: cache,
          httpClient: MockClient((req) async {
            return http.Response('not found', 404);
          }),
        );

        await expectLater(
          store.ensure(
            _FakeBundleArtifact(spec: _specWithRevision(1)),
            builder: const _MustNotBuildBuilder(),
          ),
          throwsA(
            isA<BinaryFetchException>().having(
              (e) => e.statusCode,
              'statusCode',
              404,
            ),
          ),
        );

        store.close();
      },
    );
  });

  group(
    'Given a bundle whose embedded manifest disagrees with the requested artifact',
    () {
      test(
        'when ensure runs '
        'then BinaryVerificationException is thrown and nothing is cached.',
        () async {
          var artifact = _FakeBundleArtifact(
            spec: _specWithRevision(2),
            manifestOverride: {
              'postgres': '16.13.0',
              'revision': 1,
              'platform': 'linux-x64',
              'postgis': '3.5.4',
              'pgvector': '0.8.3',
            },
          );
          var bytes = Uint8List.fromList([1, 2, 3]);
          var store = BinaryStore(
            cacheRoot: cache,
            httpClient: MockClient((req) async {
              if (req.url == artifact.archiveUrl) {
                return http.Response.bytes(bytes, 200);
              }
              if (req.url == artifact.sha256Url) {
                return http.Response(sha256.convert(bytes).toString(), 200);
              }
              return http.Response('not found', 404);
            }),
          );

          await expectLater(
            store.ensure(artifact),
            throwsA(isA<BinaryVerificationException>()),
          );
          expect(store.installDirFor(artifact).existsSync(), isFalse);
          expect(store.metaFileFor(artifact).existsSync(), isFalse);

          store.close();
        },
      );
    },
  );
}

/// Fails the test if the download path ever falls back to building.
final class _MustNotBuildBuilder extends BundleBuilder {
  const _MustNotBuildBuilder();

  @override
  Future<File> build({
    required BundleSpec spec,
    required String platform,
  }) async {
    fail('the builder must not be invoked in download mode');
  }
}

BundleSpec _specWithRevision(int revision) => BundleSpec(
  postgresVersion: Version(16, 13, 0),
  revision: revision,
  postgisVersion: '3.5.4',
  pgvectorVersion: '0.8.3',
);

/// Installs [artifact] into [store] via a self-contained mock server, so a
/// test can start from a "revision already cached" state.
Future<Directory> _installFake(
  BinaryStore store,
  _FakeBundleArtifact artifact,
) async {
  var bytes = Uint8List.fromList([9, 9, 9]);
  var seeded = BinaryStore(
    cacheRoot: store.cacheRoot,
    httpClient: MockClient((req) async {
      if (req.url == artifact.archiveUrl) {
        return http.Response.bytes(bytes, 200);
      }
      if (req.url == artifact.sha256Url) {
        return http.Response(sha256.convert(bytes).toString(), 200);
      }
      return http.Response('not found', 404);
    }),
  );
  try {
    return await seeded.ensure(artifact);
  } finally {
    seeded.close();
  }
}

/// A Serverpod bundle artifact whose "extraction" writes a minimal install
/// tree directly (bin/postgres + the identity manifest), sidestepping the
/// XZ layer that synthetic fixtures cannot roundtrip reliably. Passing
/// [manifestOverride] simulates a mislabeled archive.
final class _FakeBundleArtifact extends ServerpodBundleArtifact {
  final Map<String, Object?>? manifestOverride;

  _FakeBundleArtifact({required super.spec, this.manifestOverride})
    : super(platform: 'linux-x64');

  @override
  void extractInto(
    Uint8List archiveBytes,
    Directory destination, {
    void Function(double fraction)? onProgress,
  }) {
    File(
      p.join(destination.path, 'bin', 'postgres'),
    ).createSync(recursive: true);
    File(p.join(destination.path, bundleManifestFileName)).writeAsStringSync(
      jsonEncode(
        manifestOverride ??
            {
              'postgres': spec.bom,
              'revision': spec.revision,
              'platform': platform,
              'postgis': spec.postgisVersion,
              'pgvector': spec.pgvectorVersion,
            },
      ),
    );
    onProgress?.call(1.0);
  }
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
