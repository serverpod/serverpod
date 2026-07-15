import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:test/test.dart';

void main() {
  group('Given the public scaffolding', () {
    test('when constructing EmbeddedPostgresOptions with defaults '
        'then UnixTransport is selected and version matches the default.', () {
      var opts = EmbeddedPostgresOptions(
        dataDir: Directory('/tmp/_unused'),
        databaseName: 'projectname',
      );

      expect(opts.transport, isA<UnixTransport>());
      expect(opts.username, defaultUsername);
      expect(opts.version, defaultPostgresVersion);
      expect(opts.startTimeout, const Duration(seconds: 60));
      expect(opts.detach, isFalse);
    });

    test(
      'when picking TcpTransport with port 0 '
      'then port and password defaults are exposed as documented.',
      () {
        var t = const TcpTransport();

        expect(t.port, 0);
        expect(t.password, isNull);
      },
    );

    test('when overriding version then the new version is reflected.', () {
      var opts = EmbeddedPostgresOptions(
        dataDir: Directory('/tmp/_unused'),
        databaseName: 'projectname',
        version: Version(15, 12, 0),
      );

      expect(opts.version, Version(15, 12, 0));
    });
  });

  group('Given the sealed exception hierarchy', () {
    test(
      'when exhaustively switching over EmbeddedPostgresException '
      'then all variants are reachable.',
      () {
        EmbeddedPostgresException any = const InitdbException('x');

        var label = switch (any) {
          BinaryFetchException() => 'fetch',
          BinaryVerificationException() => 'verify',
          BinaryBuildException() => 'build',
          UnsupportedPlatformException() => 'platform',
          UnsupportedVersionException() => 'version',
          InitdbException() => 'initdb',
          StartupTimeoutException() => 'timeout',
          CrashedException() => 'crashed',
          AttachException() => 'attach',
          PostmasterLockBusyException() => 'lock-busy',
          StaleClusterException() => 'stale',
        };

        expect(label, 'initdb');
      },
    );

    test(
      'when constructing StaleClusterException then version fields are set.',
      () {
        var ex = const StaleClusterException(
          'mismatch',
          existingMajor: 15,
          requestedMajor: 16,
        );

        expect(ex.existingMajor, 15);
        expect(ex.requestedMajor, 16);
      },
    );
  });

  group('Given the EmbeddedPostgres static surface', () {
    test(
      'when defaultBinaryCache is read '
      'then a non-empty path resolves (platform-appropriate; full coverage in BinaryStore tests).',
      () {
        var dir = EmbeddedPostgres.defaultBinaryCache();

        expect(dir.path, isNotEmpty);
        expect(dir.path, contains('serverpod'));
      },
    );
  });
}
