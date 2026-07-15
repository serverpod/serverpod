import 'dart:convert';
import 'dart:ffi' show Abi;
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/src/binary/bundle_spec.dart';
import 'package:serverpod_embedded_postgres/src/binary/serverpod_bundle.dart';
import 'package:serverpod_embedded_postgres/src/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('Given serverpodPlatformSuffix', () {
    test(
      'when called with each supported ABI then the bundle suffix matches.',
      () {
        expect(serverpodPlatformSuffix(Abi.linuxX64), 'linux-x64');
        expect(serverpodPlatformSuffix(Abi.linuxArm64), 'linux-arm64');
        expect(serverpodPlatformSuffix(Abi.macosX64), 'macos-x64');
        expect(serverpodPlatformSuffix(Abi.macosArm64), 'macos-arm64');
        expect(serverpodPlatformSuffix(Abi.windowsX64), 'windows-x64');
      },
    );
  });

  final spec = BundleSpec(
    postgresVersion: Version(16, 13, 0),
    revision: 1,
    postgisVersion: '3.5.4',
    pgvectorVersion: '0.8.3',
  );

  group('Given a ServerpodBundleArtifact', () {
    final artifact = ServerpodBundleArtifact(
      spec: spec,
      platform: 'macos-arm64',
    );

    test('then bom is major.minor.patch.', () {
      expect(artifact.bom, '16.13.0');
    });

    test('then the cache key embeds the bundle revision.', () {
      expect(artifact.cacheKey, '16.13.0-r1');
    });

    test('then the archive filename embeds bom + revision + platform.', () {
      expect(
        artifact.archiveFileName,
        'serverpod-postgres-16.13.0-r1-macos-arm64.tar.xz',
      );
    });

    test('then the archive URL points at the revisioned release tag.', () {
      expect(artifact.archiveUrl.host, 'github.com');
      expect(
        artifact.archiveUrl.toString(),
        endsWith(
          '/releases/download/embedded-postgres-v16.13.0-r1/'
          'serverpod-postgres-16.13.0-r1-macos-arm64.tar.xz',
        ),
      );
    });

    test('then the sha256 URL is the archive URL + .sha256.', () {
      expect(artifact.sha256Url.toString(), '${artifact.archiveUrl}.sha256');
    });
  });

  group('Given two revisions of the same PG version', () {
    final r1 = ServerpodBundleArtifact(spec: spec, platform: 'linux-x64');
    final r2 = ServerpodBundleArtifact(
      spec: BundleSpec(
        postgresVersion: Version(16, 13, 0),
        revision: 2,
        postgisVersion: '3.5.4',
        pgvectorVersion: '0.8.3',
      ),
      platform: 'linux-x64',
    );

    test('then they resolve to different archive URLs.', () {
      expect(r1.archiveUrl, isNot(r2.archiveUrl));
    });

    test('then they have different cache keys.', () {
      expect(r1.cacheKey, isNot(r2.cacheKey));
    });

    test('then they are not equal.', () {
      expect(r1, isNot(r2));
    });
  });

  group('Given an extracted bundle tree', () {
    late Directory installDir;
    late ServerpodBundleArtifact artifact;

    setUp(() {
      installDir = Directory.systemTemp.createTempSync('bundle_manifest_');
      artifact = ServerpodBundleArtifact(spec: spec, platform: 'linux-x64');
    });

    tearDown(() {
      if (installDir.existsSync()) installDir.deleteSync(recursive: true);
    });

    void writeManifest(Map<String, Object?> manifest) {
      File(
        p.join(installDir.path, bundleManifestFileName),
      ).writeAsStringSync(jsonEncode(manifest));
    }

    test(
      'when the manifest matches the requested artifact, '
      'then validateExtracted accepts the tree.',
      () {
        writeManifest({
          'postgres': '16.13.0',
          'revision': 1,
          'platform': 'linux-x64',
          'postgis': '3.5.4',
          'pgvector': '0.8.3',
        });

        expect(() => artifact.validateExtracted(installDir), returnsNormally);
      },
    );

    test(
      'when the manifest is missing, '
      'then validateExtracted throws BinaryVerificationException.',
      () {
        expect(
          () => artifact.validateExtracted(installDir),
          throwsA(
            isA<BinaryVerificationException>().having(
              (e) => e.message,
              'message',
              contains('contains no $bundleManifestFileName'),
            ),
          ),
        );
      },
    );

    test(
      'when the manifest carries a different revision, '
      'then validateExtracted throws BinaryVerificationException naming the mismatch.',
      () {
        writeManifest({
          'postgres': '16.13.0',
          'revision': 2,
          'platform': 'linux-x64',
          'postgis': '3.5.4',
          'pgvector': '0.8.3',
        });

        expect(
          () => artifact.validateExtracted(installDir),
          throwsA(
            isA<BinaryVerificationException>().having(
              (e) => e.message,
              'message',
              contains('revision: expected 1, found 2'),
            ),
          ),
        );
      },
    );

    test(
      'when the manifest carries a different PG version and platform, '
      'then validateExtracted throws BinaryVerificationException naming both mismatches.',
      () {
        writeManifest({
          'postgres': '16.14.0',
          'revision': 1,
          'platform': 'windows-x64',
          'postgis': '3.5.4',
          'pgvector': '0.8.3',
        });

        expect(
          () => artifact.validateExtracted(installDir),
          throwsA(
            isA<BinaryVerificationException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('postgres: expected 16.13.0, found 16.14.0'),
                contains('platform: expected linux-x64, found windows-x64'),
              ),
            ),
          ),
        );
      },
    );

    test(
      'when the manifest is not valid JSON, '
      'then validateExtracted throws BinaryVerificationException.',
      () {
        File(
          p.join(installDir.path, bundleManifestFileName),
        ).writeAsStringSync('not json {');

        expect(
          () => artifact.validateExtracted(installDir),
          throwsA(
            isA<BinaryVerificationException>().having(
              (e) => e.message,
              'message',
              contains('malformed $bundleManifestFileName'),
            ),
          ),
        );
      },
    );
  });
}
