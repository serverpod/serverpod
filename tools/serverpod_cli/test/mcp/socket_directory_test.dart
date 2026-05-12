import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/mcp/socket_directory.dart';
import 'package:test/test.dart';

void main() {
  group('Given sanitizeProjectName', () {
    test(
      'when input has uppercase and underscores, '
      'then they are lowercased and replaced with hyphens',
      () {
        expect(sanitizeProjectName('My_Project'), 'my-project');
      },
    );

    test(
      'when input has runs of separators, '
      'then they are collapsed and trimmed',
      () {
        expect(sanitizeProjectName('--foo___bar---'), 'foo-bar');
      },
    );

    test(
      'when input is empty, '
      'then output is empty',
      () {
        expect(sanitizeProjectName(''), '');
      },
    );
  });

  group('Given serverpodMcpSocketPath', () {
    test(
      'when called with a project name, '
      'then it returns a path under the shared serverpod socket dir',
      () {
        final path = serverpodMcpSocketPath(pid: 1234, project: 'My App');
        expect(p.dirname(path), serverpodMcpSocketDir);
        expect(p.basename(path), 'serverpod-1234-my-app.sock');
      },
    );

    test(
      'when project name sanitizes to empty, '
      'then the filename omits the project suffix',
      () {
        final path = serverpodMcpSocketPath(pid: 99, project: '___');
        expect(p.basename(path), 'serverpod-99.sock');
      },
    );
  });

  group('Given listServerpodMcpSockets', () {
    setUp(() {
      ensureServerpodMcpSocketDir();
    });

    test(
      'when a socket file is present for the current process, '
      'then it is returned',
      () async {
        final path = serverpodMcpSocketPath(pid: pid, project: 'dcur');
        await _writeStubSocket(path);
        addTearDown(() => _safeDelete(path));

        final results = listServerpodMcpSockets();

        expect(
          results.map((s) => s.path),
          contains(path),
          reason: 'Live PID socket should be discovered',
        );
        final me = results.firstWhere((s) => s.path == path);
        expect(me.pid, pid);
        expect(me.project, 'dcur');
      },
    );

    test(
      'when a socket file is present for a non-existent PID, '
      'then it is removed and not returned',
      () async {
        // Pick a PID that won't exist. POSIX maxes out at PID_MAX (e.g.
        // 99999 on macOS, 4194304 on Linux). 2_000_000_000 is safely beyond.
        const stalePid = 2000000000;
        final path = serverpodMcpSocketPath(
          pid: stalePid,
          project: 'dstl',
        );
        await _writeStubSocket(path);
        addTearDown(() => _safeDelete(path));

        final results = listServerpodMcpSockets();

        expect(results.where((s) => s.pid == stalePid), isEmpty);
        expect(
          File(path).existsSync(),
          isFalse,
          reason: 'Stale socket file should be cleaned up',
        );
      },
    );

    test(
      'when a non-matching file is present, '
      'then it is ignored',
      () async {
        final path = p.join(
          serverpodMcpSocketDir,
          'not-a-serverpod-socket.txt',
        );
        await File(path).writeAsString('');
        addTearDown(() => _safeDelete(path));

        final results = listServerpodMcpSockets();

        expect(results.where((s) => s.path == path), isEmpty);
        expect(
          File(path).existsSync(),
          isTrue,
          reason: 'Non-matching files should not be touched',
        );
      },
    );
  });
}

/// Creates a placeholder file at [path]. The real socket binding is not
/// needed for discovery tests - `listServerpodMcpSockets` only stats the
/// directory and parses filenames.
Future<void> _writeStubSocket(String path) async {
  await File(path).writeAsString('');
}

void _safeDelete(String path) {
  try {
    File(path).deleteSync();
  } on FileSystemException {
    // Already gone.
  }
}
