import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
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
      'when called for a (version, platform) tuple then the path layers '
      'cache root / BOM / platform.',
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
      'when ensure is called and meta.json exists then no HTTP requests '
      'are issued and the install dir is returned.',
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
      'when ensure runs then BinaryVerificationException is thrown and the '
      'install dir is left absent (caller can retry).',
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
      'when the body is not a 64-char hex string then BinaryFetchException '
      'is thrown.',
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
