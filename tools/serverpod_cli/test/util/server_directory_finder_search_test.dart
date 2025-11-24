import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'server_directory_finder_test_utils.dart';

void main() {
  group('ServerDirectoryFinder.search', () {
    test(
      'Given current directory is a server directory, '
      'when search is called, '
      'then it returns found status with current directory',
      () async {
        await serverDir('test_server').create();

        var testDir = Directory(path.join(d.sandbox, 'test_server'));
        var result = ServerDirectoryFinder.search(testDir);

        expect(result, isNotNull);
        expect(
          path.normalize(result!.path),
          equals(path.normalize(testDir.path)),
        );
      },
    );

    test(
      'Given _flutter suffix directory with sibling server directory, '
      'when search is called, '
      'then it finds the _server sibling',
      () async {
        await d.dir('project', [
          serverDir('myapp_server'),
          nonServerDir('myapp_flutter'),
        ]).create();

        var flutterDir = Directory(
          path.join(d.sandbox, 'project', 'myapp_flutter'),
        );
        var result = ServerDirectoryFinder.search(flutterDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('myapp_server'),
        );
      },
    );

    test(
      'Given _client suffix directory with sibling server directory, '
      'when search is called, '
      'then it finds the _server sibling',
      () async {
        await d.dir('project', [
          serverDir('myapp_server'),
          nonServerDir('myapp_client'),
        ]).create();

        var clientDir = Directory(
          path.join(d.sandbox, 'project', 'myapp_client'),
        );
        var result = ServerDirectoryFinder.search(clientDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('myapp_server'),
        );
      },
    );

    test(
      'Given server directory is a child, '
      'when search is called from parent, '
      'then it finds the server directory',
      () async {
        await d.dir('parent', [
          serverDir('test_server'),
        ]).create();

        var parentDir = Directory(path.join(d.sandbox, 'parent'));
        var result = ServerDirectoryFinder.search(parentDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('test_server'),
        );
      },
    );

    test(
      'Given server directory is nested 2 levels deep, '
      'when search is called from root, '
      'then it finds the server directory',
      () async {
        await d.dir('root', [
          d.dir('level1', [
            d.dir('level2', [
              serverDir('test_server'),
            ]),
          ]),
        ]).create();

        var rootDir = Directory(path.join(d.sandbox, 'root'));
        var result = ServerDirectoryFinder.search(rootDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('test_server'),
        );
      },
    );

    test(
      'Given server directory is parent, '
      'when search is called from child directory, '
      'then it finds the server directory',
      () async {
        await d.dir('test_server', [
          d.file('pubspec.yaml', '''
name: test_server
dependencies:
  serverpod: ^2.0.0
'''),
          d.dir('lib', [
            d.dir('src', []),
          ]),
        ]).create();

        var childDir = Directory(
          path.join(d.sandbox, 'test_server', 'lib', 'src'),
        );
        var result = ServerDirectoryFinder.search(childDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('test_server'),
        );
      },
    );

    test(
      'Given no server directories exist, '
      'when search is called, '
      'then it returns notFound status',
      () async {
        await d.dir('project', [
          nonServerDir('some_project'),
        ]).create();

        var projectDir = Directory(path.join(d.sandbox, 'project'));
        var result = ServerDirectoryFinder.search(projectDir);

        expect(result, isNull);
      },
    );

    test(
      'Given multiple server directories exist at same level, '
      'when search is called, '
      'then it throws AmbiguousSearchException',
      () async {
        await d.dir('project', [
          serverDir('server1'),
          serverDir('server2'),
        ]).create();

        var projectDir = Directory(path.join(d.sandbox, 'project'));

        expect(
          () => ServerDirectoryFinder.search(projectDir),
          throwsA(
            isA<AmbiguousSearchException>().having(
              (e) => e.matches.length,
              'matches.length',
              equals(2),
            ),
          ),
        );
      },
    );

    test(
      'Given mixed server and non-server directories, '
      'when search is called, '
      'then it only finds server directories',
      () async {
        await d.dir('project', [
          nonServerDir('client'),
          serverDir('server'),
          nonServerDir('flutter'),
        ]).create();

        var projectDir = Directory(path.join(d.sandbox, 'project'));
        var result = ServerDirectoryFinder.search(projectDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('server'),
        );
      },
    );

    test(
      'Given search depth is limited to 2, '
      'when server directory is 3 levels deep, '
      'then it does not find the server directory',
      () async {
        await d.dir('root', [
          d.dir('l1', [
            d.dir('l2', [
              d.dir('l3', [
                d.dir('l4', [
                  serverDir('test_server'),
                ]),
              ]),
            ]),
          ]),
        ]).create();

        var rootDir = Directory(path.join(d.sandbox, 'root'));
        var result = ServerDirectoryFinder.search(rootDir);

        expect(result, isNull);
      },
    );

    test(
      'Given server directory is in a sibling of parent, '
      'when search is called from deeply nested directory, '
      'then it finds the server by searching upward',
      () async {
        await d.dir('root', [
          serverDir('server'),
          d.dir('app', [
            d.dir('lib', [
              d.dir('src', []),
            ]),
          ]),
        ]).create();

        var deepDir = Directory(
          path.join(d.sandbox, 'root', 'app', 'lib', 'src'),
        );
        var result = ServerDirectoryFinder.search(deepDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('server'),
        );
      },
    );

    test(
      'Given .git directory blocks upward search, '
      'when searching from below .git boundary, '
      'then it does not find server above the boundary',
      () async {
        await d.dir('server', [
          d.file('pubspec.yaml', '''
name: server
dependencies:
  serverpod: ^2.0.0
'''),
          d.dir('subdir', [
            d.dir('.git', []),
            d.dir('secondSubdir', []),
          ]),
        ]).create();

        // Search from below the .git boundary
        var searchDir = Directory(
          path.join(d.sandbox, 'server', 'subdir', 'secondSubdir'),
        );
        var result = ServerDirectoryFinder.search(searchDir);

        // Should NOT find the server directory above .git
        expect(result, isNull);
      },
    );

    test(
      'Given melos.yaml blocks upward search, '
      'when searching from below melos.yaml boundary, '
      'then it does not find server above the boundary',
      () async {
        await d.dir('server', [
          d.file('pubspec.yaml', '''
name: server
dependencies:
  serverpod: ^2.0.0
'''),
          d.dir('subdir', [
            d.file('melos.yaml', 'name: my_workspace\npackages:\n  - **\n'),
            d.dir('secondSubdir', []),
          ]),
        ]).create();

        // Search from below the melos.yaml boundary
        var searchDir = Directory(
          path.join(d.sandbox, 'server', 'subdir', 'secondSubdir'),
        );
        var result = ServerDirectoryFinder.search(searchDir);

        // Should NOT find the server directory above melos.yaml
        expect(result, isNull);
      },
    );

    test(
      'Given at repository root with .git, '
      'when searching from root, '
      'then it does not check siblings outside the repository',
      () async {
        await d.dir('other_repo', [
          serverDir('other_server'),
        ]).create();

        await d.dir('my_repo', [
          d.dir('.git', []),
          serverDir('my_server'),
        ]).create();

        var repoDir = Directory(path.join(d.sandbox, 'my_repo'));
        var result = ServerDirectoryFinder.search(repoDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('my_server'),
        );
      },
    );

    test(
      'Given server is 2 levels deep in monorepo (e.g., backend/myproject_server), '
      'when searching from sibling directory (e.g., apps/), '
      'then it finds the deeply nested server',
      () async {
        await d.dir('monorepo', [
          d.dir('.git', []),
          d.dir('apps', []),
          d.dir('backend', [
            serverDir('level_api'),
          ]),
        ]).create();

        var appsDir = Directory(path.join(d.sandbox, 'monorepo', 'apps'));
        var result = ServerDirectoryFinder.search(appsDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('level_api'),
        );
      },
    );
  });
}
