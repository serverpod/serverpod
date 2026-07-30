import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given the public embedded PostgreSQL API, '
    'when constructing EmbeddedPostgresOptions with defaults, '
    'then a supported local transport is selected and version matches the default.',
    () {
      var opts = EmbeddedPostgresOptions(
        dataDir: Directory('/tmp/_unused'),
        databaseName: 'projectname',
      );

      expect(
        opts.transport,
        hasUnixSocketSupport() ? isA<UnixTransport>() : isA<TcpTransport>(),
      );
      expect(opts.username, defaultUsername);
      expect(opts.version, defaultPostgresVersion);
      expect(opts.startTimeout, const Duration(seconds: 60));
      expect(opts.detach, isFalse);
    },
  );

  test(
    'Given constructed TcpTransport, '
    'when reading its port and password, '
    'then its port is dynamic and its password is absent.',
    () {
      var t = const TcpTransport();

      expect(t.port, 0);
      expect(t.password, isNull);
    },
  );

  test(
    'Given constructed EmbeddedPostgresOptions with a version override, '
    'when reading its version, '
    'then the overridden version is exposed.',
    () {
      var opts = EmbeddedPostgresOptions(
        dataDir: Directory('/tmp/_unused'),
        databaseName: 'projectname',
        version: Version(15, 12, 0),
      );

      expect(opts.version, Version(15, 12, 0));
    },
  );

  test(
    'Given constructed EmbeddedPostgresOptions with a binary source override, '
    'when reading its binary source, '
    'then the selected BinarySource is exposed.',
    () {
      var opts = EmbeddedPostgresOptions(
        dataDir: Directory('/tmp/_unused'),
        databaseName: 'projectname',
        binarySource: BinarySource.build,
      );

      expect(opts.binarySource, BinarySource.build);
    },
  );

  test(
    'Given a stale cluster exception with existing and requested versions, '
    'when reading its existing and requested versions, '
    'then both versions are exposed.',
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

  test(
    'Given the EmbeddedPostgres static API with the default binary cache, '
    'when reading its path, '
    'then it returns a non-empty Serverpod path.',
    () {
      var dir = EmbeddedPostgres.defaultBinaryCache();

      expect(dir.path, isNotEmpty);
      expect(dir.path, contains('serverpod'));
    },
  );
}
