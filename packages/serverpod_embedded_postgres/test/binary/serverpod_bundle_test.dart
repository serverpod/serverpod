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
  test(
    'Given the supported bundle platforms, '
    'when each platform suffix is resolved, '
    'then it matches the corresponding operating system and architecture.',
    () {
      expect(serverpodPlatformSuffix(Abi.linuxX64), 'linux-x64');
      expect(serverpodPlatformSuffix(Abi.linuxArm64), 'linux-arm64');
      expect(serverpodPlatformSuffix(Abi.macosX64), 'macos-x64');
      expect(serverpodPlatformSuffix(Abi.macosArm64), 'macos-arm64');
      expect(serverpodPlatformSuffix(Abi.windowsX64), 'windows-x64');
    },
  );

  final spec = BundleSpec(
    postgresVersion: Version(16, 13, 0),
    revision: 1,
    postgisVersion: '3.5.4',
    pgvectorVersion: '0.8.3',
  );

  group(
    'Given a PostgreSQL 16.13.0 revision 1 bundle for macOS Arm64, ',
    () {
      late ServerpodBundleArtifact artifact;

      setUp(() {
        artifact = ServerpodBundleArtifact(
          spec: spec,
          platform: 'macos-arm64',
        );
      });

      test(
        'when its BOM is read, '
        'then it includes the patch version.',
        () {
          expect(artifact.bom, '16.13.0');
        },
      );

      test(
        'when its cache key is read, '
        'then it includes the bundle revision.',
        () {
          expect(artifact.cacheKey, '16.13.0-r1');
        },
      );

      test(
        'when its archive filename is read, '
        'then it includes the BOM, revision, and platform.',
        () {
          expect(
            artifact.archiveFileName,
            'serverpod-postgres-16.13.0-r1-macos-arm64.tar.xz',
          );
        },
      );

      test(
        'when its archive URL is read, '
        'then it points to its release tag.',
        () {
          expect(artifact.archiveUrl.host, 'github.com');
          expect(
            artifact.archiveUrl.toString(),
            endsWith(
              '/releases/download/embedded-postgres-v16.13.0-r1/'
              'serverpod-postgres-16.13.0-r1-macos-arm64.tar.xz',
            ),
          );
        },
      );

      test(
        'when its checksum URL is read, '
        'then it appends .sha256 to the archive URL.',
        () {
          expect(
            artifact.sha256Url.toString(),
            '${artifact.archiveUrl}.sha256',
          );
        },
      );
    },
  );

  group('Given two bundle revisions of the same PostgreSQL version, ', () {
    late ServerpodBundleArtifact r1;
    late ServerpodBundleArtifact r2;

    setUp(() {
      r1 = ServerpodBundleArtifact(spec: spec, platform: 'linux-x64');
      r2 = ServerpodBundleArtifact(
        spec: BundleSpec(
          postgresVersion: Version(16, 13, 0),
          revision: 2,
          postgisVersion: '3.5.4',
          pgvectorVersion: '0.8.3',
        ),
        platform: 'linux-x64',
      );
    });

    test(
      'when their archive URLs are compared, '
      'then they are different.',
      () {
        expect(r1.archiveUrl, isNot(r2.archiveUrl));
      },
    );

    test(
      'when their cache keys are compared, '
      'then they are different.',
      () {
        expect(r1.cacheKey, isNot(r2.cacheKey));
      },
    );

    test(
      'when the artifacts are compared, '
      'then they are not equal.',
      () {
        expect(r1, isNot(r2));
      },
    );
  });

  group(
    'Given an empty Linux x64 installation directory and its expected bundle artifact, ',
    () {
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
        'when a matching manifest is written and the directory is validated, '
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
        'when the directory is validated without a manifest, '
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
        'when a manifest with a different revision is written and the directory is validated, '
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
        'when a manifest with a different PG version and platform is written and the directory is validated, '
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
        'when a malformed manifest is written and the directory is validated, '
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
    },
  );
}
