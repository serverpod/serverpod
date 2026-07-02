import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_embedded_postgres/serverpod_embedded_postgres.dart';
import 'package:serverpod_embedded_postgres/src/cluster/postgres_conf_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Given buildPostgresConfBody for UnixTransport', () {
    test(
      'when PGDATA has a sibling "run" dir '
      'then unix_socket_directories is the relative path "../run".',
      () {
        var tmp = Directory.systemTemp.createTempSync('conf_builder_test_');
        try {
          var pgData = Directory(p.join(tmp.path, 'pgdata'))..createSync();
          Directory(p.join(tmp.path, 'run')).createSync();

          var body = buildPostgresConfBody(
            transport: const UnixTransport(),
            pgDataDir: pgData,
          );

          expect(body, contains("unix_socket_directories = '../run'"));
          expect(body, contains("listen_addresses = ''"));
          expect(body, contains('unix_socket_permissions = 0700'));
        } finally {
          tmp.deleteSync(recursive: true);
        }
      },
    );
  });

  group('Given buildPostgresConfBody for TcpTransport', () {
    test(
      'when port = 5433 '
      'then listen_addresses is loopback and the explicit port is set.',
      () {
        var tmp = Directory.systemTemp.createTempSync('conf_builder_test_');
        try {
          var pgData = Directory(p.join(tmp.path, 'pgdata'))..createSync();

          var body = buildPostgresConfBody(
            transport: const TcpTransport(port: 5433),
            pgDataDir: pgData,
          );

          expect(body, contains("listen_addresses = '127.0.0.1'"));
          expect(body, contains('port = 5433'));
          expect(body, contains("unix_socket_directories = ''"));
        } finally {
          tmp.deleteSync(recursive: true);
        }
      },
    );
  });

  group('Given buildPostgresConfBody and max_connections', () {
    test('when maxConnections is omitted then the default is used.', () {
      var tmp = Directory.systemTemp.createTempSync('conf_builder_test_');
      try {
        var pgData = Directory(p.join(tmp.path, 'pgdata'))..createSync();
        Directory(p.join(tmp.path, 'run')).createSync();

        var body = buildPostgresConfBody(
          transport: const UnixTransport(),
          pgDataDir: pgData,
        );

        expect(body, contains('max_connections = $defaultMaxConnections'));
      } finally {
        tmp.deleteSync(recursive: true);
      }
    });

    test('when maxConnections is set then it overrides the default.', () {
      var tmp = Directory.systemTemp.createTempSync('conf_builder_test_');
      try {
        var pgData = Directory(p.join(tmp.path, 'pgdata'))..createSync();
        Directory(p.join(tmp.path, 'run')).createSync();

        var body = buildPostgresConfBody(
          transport: const UnixTransport(),
          pgDataDir: pgData,
          maxConnections: 42,
        );

        expect(body, contains('max_connections = 42'));
      } finally {
        tmp.deleteSync(recursive: true);
      }
    });
  });

  group('Given rewriteManagedBlock', () {
    test(
      'when the original has no markers then the managed block is appended.',
      () {
        var original = '# user comment\nshared_buffers = 256MB\n';

        var result = rewriteManagedBlock(original, 'cluster_name = x\n');

        expect(result, contains('# user comment'));
        expect(result, contains('shared_buffers = 256MB'));
        expect(result, contains(confBlockBeginMarker));
        expect(result, contains(confBlockEndMarker));
        expect(result, contains('cluster_name = x'));
      },
    );

    test(
      'when the original already has our managed block '
      'then the block is replaced (not duplicated) and outside-block content is preserved.',
      () {
        var first = rewriteManagedBlock('# keep me\n', 'cluster_name = a\n');
        var second = rewriteManagedBlock(first, 'cluster_name = b\n');

        expect(second, contains('# keep me'));
        expect(second, contains('cluster_name = b'));
        expect(second, isNot(contains('cluster_name = a')));
        // Marker must appear exactly once.
        expect(
          confBlockBeginMarker.allMatches(second).length,
          1,
          reason: 'BEGIN marker must be unique post-rewrite',
        );
      },
    );

    test(
      'when applied twice with the same body then the result is stable.',
      () {
        var once = rewriteManagedBlock('# preexisting\n', 'cluster_name = z\n');
        var twice = rewriteManagedBlock(once, 'cluster_name = z\n');

        expect(twice, once);
      },
    );

    test(
      'when the file has a stray BEGIN with no END '
      'then a StateError is thrown rather than clobbering the rest of the file.',
      () {
        var corrupted = '$confBlockBeginMarker\nbroken\n';

        expect(
          () => rewriteManagedBlock(corrupted, 'cluster_name = z\n'),
          throwsStateError,
        );
      },
    );

    test(
      'when the managed block uses CRLF line endings '
      "then the END marker's trailing \\r\\n is consumed (no stray \\r leaks past the block).",
      () {
        var crlf =
            '# keep\r\n$confBlockBeginMarker\r\nold = 1\r\n'
            '$confBlockEndMarker\r\nafter = 2\r\n';

        var result = rewriteManagedBlock(crlf, 'new = 1\n');

        expect(
          result,
          isNot(contains('\r\nafter')),
          reason: 'no orphan \\r should remain between block and suffix',
        );
        expect(result, contains('after = 2'));
        expect(result, contains('new = 1'));
      },
    );
  });
}
