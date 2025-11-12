import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  /// Creates a mock Serverpod server directory descriptor
  d.DirectoryDescriptor serverDir(String name) {
    return d.dir(name, [
      d.file('pubspec.yaml', '''
name: $name
dependencies:
  serverpod: ^2.0.0
'''),
    ]);
  }

  /// Creates a mock non-server directory descriptor
  d.DirectoryDescriptor nonServerDir(String name) {
    return d.dir(name, [
      d.file('pubspec.yaml', '''
name: $name
dependencies:
  http: ^1.0.0
'''),
    ]);
  }

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
      'Given sibling directory with _flutter suffix, '
      'when search is called, '
      'then it finds the _server sibling',
      () async {
        await d.dir('project', [
          serverDir('myapp_server'),
          nonServerDir('myapp_flutter'),
        ]).create();

        var flutterDir =
            Directory(path.join(d.sandbox, 'project', 'myapp_flutter'));
        var result = ServerDirectoryFinder.search(flutterDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('myapp_server'),
        );
      },
    );

    test(
      'Given sibling directory with _client suffix, '
      'when search is called, '
      'then it finds the _server sibling',
      () async {
        await d.dir('project', [
          serverDir('myapp_server'),
          nonServerDir('myapp_client'),
        ]).create();

        var clientDir =
            Directory(path.join(d.sandbox, 'project', 'myapp_client'));
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

        var childDir =
            Directory(path.join(d.sandbox, 'test_server', 'lib', 'src'));
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
          throwsA(isA<AmbiguousSearchException>().having(
            (e) => e.matches.length,
            'matches.length',
            equals(2),
          )),
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

        var deepDir =
            Directory(path.join(d.sandbox, 'root', 'app', 'lib', 'src'));
        var result = ServerDirectoryFinder.search(deepDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('server'),
        );
      },
    );

    test(
      'Given .git directory exists in parent, '
      'when searching upward, '
      'then it stops at the repository boundary',
      () async {
        await d.dir('repo', [
          d.dir('.git', []),
          d.dir('subdir', [
            d.dir('server', [
              d.file('pubspec.yaml', '''
name: server
dependencies:
  serverpod: ^2.0.0
'''),
              d.dir('lib', [
                d.dir('src', [
                  d.dir('models', []),
                ]),
              ]),
            ]),
          ]),
        ]).create();

        var actualServerDir =
            Directory(path.join(d.sandbox, 'repo', 'subdir', 'server'));
        var result = ServerDirectoryFinder.search(actualServerDir);
        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('server'),
        );

        var deepDir = Directory(path.join(
            d.sandbox, 'repo', 'subdir', 'server', 'lib', 'src', 'models'));
        result = ServerDirectoryFinder.search(deepDir);
        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('server'),
        );
      },
    );

    test(
      'Given melos.yaml exists in parent, '
      'when searching upward, '
      'then it stops at the workspace boundary',
      () async {
        await d.dir('workspace', [
          d.file(
              'melos.yaml', 'name: my_workspace\npackages:\n  - packages/**\n'),
          d.dir('packages', [
            serverDir('server'),
          ]),
          d.dir('outside', []),
        ]).create();

        var actualServerDir =
            Directory(path.join(d.sandbox, 'workspace', 'packages', 'server'));
        var result = ServerDirectoryFinder.search(actualServerDir);

        expect(result, isNotNull);
        expect(
          path.basename(result!.path),
          equals('server'),
        );
      },
    );

    test(
      'Given nested structure with server outside repository boundary, '
      'when searching from inside boundary, '
      'then it does not find server outside boundary',
      () async {
        await d.dir('outside_repo', [
          serverDir('server_outside'),
        ]).create();

        await d.dir('inside_repo', [
          d.dir('.git', []),
          d.dir('inside', []),
        ]).create();

        var insideDir =
            Directory(path.join(d.sandbox, 'inside_repo', 'inside'));
        var result = ServerDirectoryFinder.search(insideDir);

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

  group('ServerDirectoryFinder.findOrPrompt with interactive flag', () {
    test(
      'Given multiple server directories exist, '
      'when findOrPrompt is called with interactive=false, '
      'then it throws ServerpodProjectNotFoundException (for CI/CD)',
      () async {
        await d.dir('project', [
          serverDir('server1'),
          serverDir('server2'),
        ]).create();

        var projectDir = Directory(path.join(d.sandbox, 'project'));

        expect(
          () => ServerDirectoryFinder.findOrPrompt(
            startDir: projectDir,
            interactive: false,
          ),
          throwsA(isA<ServerpodProjectNotFoundException>().having(
            (e) => e.message,
            'message',
            contains('Multiple Serverpod projects detected'),
          )),
        );
      },
    );

    test(
      'Given single server directory exists, '
      'when findOrPrompt is called with interactive=false, '
      'then it returns the server directory',
      () async {
        await d.dir('project', [
          serverDir('server'),
        ]).create();

        var projectDir = Directory(path.join(d.sandbox, 'project'));
        var result = await ServerDirectoryFinder.findOrPrompt(
          startDir: projectDir,
          interactive: false,
        );

        expect(result, isNotNull);
        expect(
          path.basename(result.path),
          equals('server'),
        );
      },
    );

    test(
      'Given no server directory exists, '
      'when findOrPrompt is called with interactive=false, '
      'then it throws ServerpodProjectNotFoundException',
      () async {
        await d.dir('project', [
          nonServerDir('client'),
        ]).create();

        var projectDir = Directory(path.join(d.sandbox, 'project'));

        expect(
          () => ServerDirectoryFinder.findOrPrompt(
            startDir: projectDir,
            interactive: false,
          ),
          throwsA(isA<ServerpodProjectNotFoundException>().having(
            (e) => e.message,
            'message',
            contains('No Serverpod server project detected'),
          )),
        );
      },
    );
  });
}
