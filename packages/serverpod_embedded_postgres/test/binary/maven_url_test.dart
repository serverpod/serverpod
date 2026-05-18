import 'dart:ffi' show Abi;

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/binary/maven_url.dart';
import 'package:test/test.dart';

void main() {
  group('Given platformSuffixForAbi', () {
    test(
      'when called with each supported ABI then the matching Zonky suffix is returned.',
      () {
        expect(platformSuffixForAbi(Abi.linuxX64), 'linux-amd64');
        expect(platformSuffixForAbi(Abi.linuxArm64), 'linux-arm64v8');
        expect(platformSuffixForAbi(Abi.macosX64), 'darwin-amd64');
        expect(platformSuffixForAbi(Abi.macosArm64), 'darwin-arm64v8');
        expect(platformSuffixForAbi(Abi.windowsX64), 'windows-amd64');
      },
    );

    test(
      'when called with an ABI Zonky does not publish '
      'then UnsupportedPlatformException is thrown.',
      () {
        expect(
          () => platformSuffixForAbi(Abi.windowsArm64),
          throwsA(isA<UnsupportedPlatformException>()),
        );
        expect(
          () => platformSuffixForAbi(Abi.androidArm64),
          throwsA(isA<UnsupportedPlatformException>()),
        );
      },
    );
  });

  group('Given a ZonkyArtifact', () {
    test(
      'when constructed for darwin-amd64 16.13.0 '
      "then BOM, artifact ID, and JAR filename match Zonky's actual layout.",
      () {
        var a = ZonkyArtifact(
          version: Version(16, 13, 0),
          platform: 'darwin-amd64',
        );

        expect(a.bom, '16.13.0');
        expect(a.artifactId, 'embedded-postgres-binaries-darwin-amd64');
        expect(
          a.jarFileName,
          'embedded-postgres-binaries-darwin-amd64-16.13.0.jar',
        );
      },
    );

    test('when computing jarUrl then it points at Maven Central.', () {
      var a = ZonkyArtifact(
        version: Version(16, 13, 0),
        platform: 'darwin-amd64',
      );

      expect(
        a.jarUrl.toString(),
        'https://repo1.maven.org/maven2/io/zonky/test/postgres/'
        'embedded-postgres-binaries-darwin-amd64/16.13.0/'
        'embedded-postgres-binaries-darwin-amd64-16.13.0.jar',
      );
    });

    test('when computing sha256Url then it appends ".sha256" to jarUrl.', () {
      var a = ZonkyArtifact(
        version: Version(16, 13, 0),
        platform: 'linux-arm64v8',
      );

      expect(a.sha256Url.toString(), endsWith('.jar.sha256'));
      expect(a.sha256Url.toString(), startsWith(a.jarUrl.toString()));
    });

    test(
      'when comparing two artifacts with the same version and platform '
      'then they are equal.',
      () {
        var a = ZonkyArtifact(
          version: Version(16, 13, 0),
          platform: 'darwin-amd64',
        );
        var b = ZonkyArtifact(
          version: Version(16, 13, 0),
          platform: 'darwin-amd64',
        );

        expect(a, equals(b));
        expect(a.hashCode, b.hashCode);
      },
    );

    test(
      'when constructed via forCurrentPlatform '
      'then platform matches the host ABI.',
      () {
        var a = ZonkyArtifact.forCurrentPlatform(version: Version(16, 13, 0));

        expect(a.platform, platformSuffixForAbi(Abi.current()));
      },
    );
  });
}
