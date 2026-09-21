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
}
