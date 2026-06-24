import 'dart:ffi' show Abi;

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/src/binary/serverpod_bundle.dart';
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

  group('Given a ServerpodBundleArtifact', () {
    final artifact = ServerpodBundleArtifact(
      version: Version(16, 13, 0),
      platform: 'macos-arm64',
    );

    test('then bom is major.minor.patch.', () {
      expect(artifact.bom, '16.13.0');
    });

    test('then the archive filename embeds bom + platform.', () {
      expect(
        artifact.archiveFileName,
        'serverpod-postgres-16.13.0-macos-arm64.tar.xz',
      );
    });

    test('then the archive URL points at the GitHub release asset.', () {
      expect(artifact.archiveUrl.host, 'github.com');
      expect(
        artifact.archiveUrl.toString(),
        endsWith(
          '/releases/download/embedded-postgres-v16.13.0/'
          'serverpod-postgres-16.13.0-macos-arm64.tar.xz',
        ),
      );
    });

    test('then the sha256 URL is the archive URL + .sha256.', () {
      expect(artifact.sha256Url.toString(), '${artifact.archiveUrl}.sha256');
    });
  });
}
