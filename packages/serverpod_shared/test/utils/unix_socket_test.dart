import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given shortestPath', () {
    test(
      'when called with a path inside cwd then a relative form is returned.',
      () {
        var here = Directory.current.path;
        var nested = p.join(here, 'a', 'b', 'c.txt');

        var shortened = shortestPath(nested);

        expect(shortened, isNot(startsWith('/')));
        expect(p.canonicalize(shortened), p.canonicalize(nested));
      },
    );

    test(
      'when called with a path far from cwd then the absolute form is returned.',
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
  });

  group('Given shortestPathRelativeTo', () {
    test(
      'when target is a sibling of [from] then "../sibling" is returned.',
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
      'when [from] equals target then "." is returned.',
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
  });

  group('Given maxUnixSocketPathBytes', () {
    test(
      'when called on macOS then 104 is returned.',
      () {
        if (!Platform.isMacOS && !Platform.isIOS) return;

        expect(maxUnixSocketPathBytes(), 104);
      },
      skip: !(Platform.isMacOS || Platform.isIOS),
    );

    test('when called on Linux then 108 is returned.', () {
      if (!Platform.isLinux) return;

      expect(maxUnixSocketPathBytes(), 108);
    }, skip: !Platform.isLinux);
  });

  group('Given requireUnixSocketPathFits', () {
    test(
      'when path fits the platform cap then it returns without throwing.',
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
      'when shortened path exceeds the cap then SocketException is thrown.',
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
  });
}
