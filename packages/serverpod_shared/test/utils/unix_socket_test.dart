import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a path inside the current directory, '
    'when calling shortestPath, '
    'then it returns a relative path to the same file.',
    () {
      var here = Directory.current.path;
      var nested = p.join(here, 'a', 'b', 'c.txt');

      var shortened = shortestPath(nested);

      expect(shortened, isNot(startsWith('/')));
      expect(p.canonicalize(shortened), p.canonicalize(nested));
    },
  );

  test(
    'Given the system temp directory, '
    'when calling shortestPath, '
    'then it returns a path that resolves to the same directory.',
    () {
      // /tmp is typically very short and likely shorter than the relative
      // form from a deep cwd. On systems where /tmp is symlinked elsewhere,
      // canonicalize keeps it stable.
      var absolute = Directory.systemTemp.path;

      var shortened = shortestPath(absolute);

      // Either the absolute form is shorter, or they tie. Confirm the
      // result resolves to the same absolute path either way.
      expect(p.canonicalize(shortened), p.canonicalize(absolute));
    },
  );

  test(
    'Given a target directory that is a sibling of the base directory, '
    'when calling shortestPathRelativeTo, '
    'then it returns the path to the sibling through "..".',
    () {
      var tmp = Directory.systemTemp.createTempSync('shortest_test_');
      try {
        var pgData = Directory(p.join(tmp.path, 'pgdata'))..createSync();
        var run = Directory(p.join(tmp.path, 'run'))..createSync();

        var shortened = shortestPathRelativeTo(run.path, from: pgData.path);

        expect(shortened, p.join('..', 'run'));
      } finally {
        tmp.deleteSync(recursive: true);
      }
    },
  );

  test(
    'Given a target directory equal to the base directory, '
    'when calling shortestPathRelativeTo, '
    'then it returns a path that resolves to that directory.',
    () {
      var tmp = Directory.systemTemp.createTempSync('shortest_test_');
      try {
        var shortened = shortestPathRelativeTo(tmp.path, from: tmp.path);

        // Either '.' (relative) wins, or the absolute path does -
        // both resolve to the same canonical path.
        expect(
          p.canonicalize(p.join(tmp.path, shortened)),
          p.canonicalize(tmp.path),
        );
      } finally {
        tmp.deleteSync(recursive: true);
      }
    },
  );

  test(
    'Given a macOS host, '
    'when calling maxUnixSocketPathBytes, '
    'then it returns 104.',
    () {
      if (!Platform.isMacOS && !Platform.isIOS) return;

      expect(maxUnixSocketPathBytes(), 104);
    },
    skip: !(Platform.isMacOS || Platform.isIOS),
  );

  test(
    'Given a Linux host, '
    'when calling maxUnixSocketPathBytes, '
    'then it returns 108.',
    () {
      if (!Platform.isLinux) return;

      expect(maxUnixSocketPathBytes(), 108);
    },
    skip: !Platform.isLinux,
  );

  test(
    'Given a unix socket path that fits the platform cap, '
    'when checking unixSocketPathFits, '
    'then it returns true.',
    () {
      var tmp = Directory.systemTemp.createTempSync('uds_fits_');
      try {
        expect(unixSocketPathFits(p.join(tmp.path, 't.sock')), isTrue);
      } finally {
        tmp.deleteSync(recursive: true);
      }
    },
  );

  test(
    'Given a unix socket path that exceeds the platform cap even when shortened, '
    'when checking unixSocketPathFits, '
    'then it returns false.',
    () {
      var deep = '/tmp';
      while (deep.length <= maxUnixSocketPathBytes() + 20) {
        deep = '$deep/aaaaaaaaaaaaaaaaaa';
      }

      expect(unixSocketPathFits(deep), isFalse);
    },
  );

  test(
    'Given a unix socket path that fits the platform cap, '
    'when calling requireUnixSocketPathFits, '
    'then it returns without throwing.',
    () {
      var tmp = Directory.systemTemp.createTempSync('uds_short_');
      try {
        var path = p.join(tmp.path, '.s.PGSQL.5432');

        expect(() => requireUnixSocketPathFits(path), returnsNormally);
      } finally {
        tmp.deleteSync(recursive: true);
      }
    },
  );

  test(
    'Given a unix socket path that exceeds the platform cap even when shortened, '
    'when calling requireUnixSocketPathFits, '
    'then it throws a SocketException.',
    () {
      // Build a deeply nested absolute path under /tmp until it's longer
      // than 108 bytes even after canonicalization. Avoid relying on cwd
      // because shortestPath may relativize and shrink it under the cap.
      var deep = '/tmp';
      while (deep.length <= maxUnixSocketPathBytes() + 20) {
        deep = '$deep/aaaaaaaaaaaaaaaaaa';
      }

      expect(
        () => requireUnixSocketPathFits(deep),
        throwsA(isA<SocketException>()),
      );
    },
  );

  test(
    'Given a unix socket path that fits the platform cap, '
    'when calling reachableUnixSocketPath, '
    'then it returns the shortest form of the path.',
    () {
      var tmp = Directory.systemTemp.createTempSync('uds_reach_');
      try {
        var path = p.join(tmp.path, '.s.PGSQL.5432');

        expect(reachableUnixSocketPath(path), shortestPath(path));
      } finally {
        tmp.deleteSync(recursive: true);
      }
    },
  );

  group(
    'Given a directory too deep for a unix socket path into it',
    () {
      late Directory tmp;
      late String deep;

      setUp(() {
        tmp = Directory.systemTemp.createTempSync('uds_deep_');
        deep = tmp.path;
        while (deep.length <= maxUnixSocketPathBytes() + 20) {
          deep = p.join(deep, 'aaaaaaaaaaaaaaaaaa');
        }
        Directory(deep).createSync(recursive: true);
      });

      tearDown(() => tmp.deleteSync(recursive: true));

      test(
        'when binding and connecting through reachableUnixSocketPath, '
        'then the connection reaches the socket in that directory.',
        () async {
          var path = p.join(deep, '.s.PGSQL.5432');
          var server = await ServerSocket.bind(
            InternetAddress(
              reachableUnixSocketPath(path),
              type: InternetAddressType.unix,
            ),
            0,
          );
          addTearDown(server.close);
          server.listen(
            (client) => client
              ..write('hi')
              ..close(),
          );

          var socket = await Socket.connect(
            InternetAddress(
              reachableUnixSocketPath(path),
              type: InternetAddressType.unix,
            ),
            0,
          );
          addTearDown(socket.destroy);

          expect(String.fromCharCodes(await socket.first), 'hi');
          expect(
            FileSystemEntity.typeSync(path, followLinks: false),
            FileSystemEntityType.unixDomainSock,
          );
        },
      );

      test(
        'when calling reachableUnixSocketPath for two sockets in it, '
        'then both are reached through the same short directory.',
        () {
          var first = reachableUnixSocketPath(p.join(deep, 'a.sock'));
          var second = reachableUnixSocketPath(p.join(deep, 'b.sock'));

          expect(p.dirname(first), p.dirname(second));
          expect(unixSocketPathFits(first), isTrue);
        },
      );

      test(
        'when calling reachableUnixSocketPath, '
        'then the link lives in a directory only the current user can access.',
        () {
          var linked = reachableUnixSocketPath(p.join(deep, 'a.sock'));

          var linkDir = p.dirname(p.dirname(linked));
          expect(FileStat.statSync(linkDir).mode & 0x3f, 0);
        },
      );
    },
    skip: Platform.isWindows
        ? 'Links to socket directories are only verified on POSIX'
        : false,
  );
}
