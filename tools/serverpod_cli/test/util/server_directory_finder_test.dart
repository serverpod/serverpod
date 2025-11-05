import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('serverpod_finder_test_');
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  Future<Directory> createMockServerDirectory(
    Directory parent,
    String name,
  ) async {
    var serverDir = Directory(path.join(parent.path, name));
    await serverDir.create(recursive: true);

    var pubspecFile = File(path.join(serverDir.path, 'pubspec.yaml'));
    await pubspecFile.writeAsString('''
name: $name
dependencies:
  serverpod: ^2.0.0
''');

    return serverDir;
  }

  Future<Directory> createMockNonServerDirectory(
    Directory parent,
    String name,
  ) async {
    var dir = Directory(path.join(parent.path, name));
    await dir.create(recursive: true);

    var pubspecFile = File(path.join(dir.path, 'pubspec.yaml'));
    await pubspecFile.writeAsString('''
name: $name
dependencies:
  http: ^1.0.0
''');

    return dir;
  }

  group('ServerDirectoryFinder.search', () {
    test(
      'Given current directory is a server directory, '
      'when search is called, '
      'then it returns found status with current directory',
      () async {
        var serverDir = await createMockServerDirectory(tempDir, 'test_server');

        var result = ServerDirectoryFinder.search(serverDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given sibling directory with _flutter suffix, '
      'when search is called, '
      'then it finds the _server sibling',
      () async {
        var projectName = 'myapp';
        var serverDir =
            await createMockServerDirectory(tempDir, '${projectName}_server');
        var flutterDir = await createMockNonServerDirectory(
            tempDir, '${projectName}_flutter');

        var result = ServerDirectoryFinder.search(flutterDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given sibling directory with _client suffix, '
      'when search is called, '
      'then it finds the _server sibling',
      () async {
        var projectName = 'myapp';
        var serverDir =
            await createMockServerDirectory(tempDir, '${projectName}_server');
        var clientDir = await createMockNonServerDirectory(
            tempDir, '${projectName}_client');

        var result = ServerDirectoryFinder.search(clientDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given server directory is a child, '
      'when search is called from parent, '
      'then it finds the server directory',
      () async {
        var serverDir = await createMockServerDirectory(tempDir, 'test_server');

        var result = ServerDirectoryFinder.search(tempDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given server directory is nested 2 levels deep, '
      'when search is called from root, '
      'then it finds the server directory',
      () async {
        var nestedDir = Directory(path.join(tempDir.path, 'level1', 'level2'));
        await nestedDir.create(recursive: true);
        var serverDir =
            await createMockServerDirectory(nestedDir, 'test_server');

        var result = ServerDirectoryFinder.search(tempDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given server directory is parent, '
      'when search is called from child directory, '
      'then it finds the server directory',
      () async {
        var serverDir = await createMockServerDirectory(tempDir, 'test_server');
        var childDir = Directory(path.join(serverDir.path, 'lib', 'src'));
        await childDir.create(recursive: true);

        var result = ServerDirectoryFinder.search(childDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given no server directories exist, '
      'when search is called, '
      'then it returns notFound status',
      () async {
        await createMockNonServerDirectory(tempDir, 'some_project');

        var result = ServerDirectoryFinder.search(tempDir);

        expect(result.status, equals(SearchStatus.notFound));
        expect(result.directory, isNull);
        expect(result.candidates, isEmpty);
      },
    );

    test(
      'Given multiple server directories exist at same level, '
      'when search is called, '
      'then it returns multipleFound status',
      () async {
        await createMockServerDirectory(tempDir, 'server1');
        await createMockServerDirectory(tempDir, 'server2');

        var result = ServerDirectoryFinder.search(tempDir);

        expect(result.status, equals(SearchStatus.multipleFound));
        expect(result.directory, isNull);
        expect(result.candidates.length, equals(2));
      },
    );

    test(
      'Given mixed server and non-server directories, '
      'when search is called, '
      'then it only finds server directories',
      () async {
        await createMockNonServerDirectory(tempDir, 'client');
        var serverDir = await createMockServerDirectory(tempDir, 'server');
        await createMockNonServerDirectory(tempDir, 'flutter');

        var result = ServerDirectoryFinder.search(tempDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given search depth is limited to 2, '
      'when server directory is 3 levels deep, '
      'then it does not find the server directory',
      () async {
        var deepDir =
            Directory(path.join(tempDir.path, 'l1', 'l2', 'l3', 'l4'));
        await deepDir.create(recursive: true);
        await createMockServerDirectory(deepDir, 'test_server');

        var result = ServerDirectoryFinder.search(tempDir);

        // Should not find it because it's too deep
        expect(result.status, equals(SearchStatus.notFound));
      },
    );

    test(
      'Given server directory is in a sibling of parent, '
      'when search is called from deeply nested directory, '
      'then it finds the server by searching upward',
      () async {
        // Create structure: tempDir/server (server) and tempDir/app/lib/src (search from here)
        var serverDir = await createMockServerDirectory(tempDir, 'server');
        var appDir = Directory(path.join(tempDir.path, 'app', 'lib', 'src'));
        await appDir.create(recursive: true);

        var result = ServerDirectoryFinder.search(appDir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, isNotNull);
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );

    test(
      'Given .git directory exists in parent, '
      'when searching upward, '
      'then it stops at the repository boundary',
      () async {
        var gitDir = Directory(path.join(tempDir.path, '.git'));
        await gitDir.create(recursive: true);

        var subDir = Directory(path.join(tempDir.path, 'subdir'));
        await subDir.create(recursive: true);

        var serverDir = await createMockServerDirectory(subDir, 'server');

        var result = ServerDirectoryFinder.search(serverDir);
        expect(result.status, equals(SearchStatus.found));

        var deepDir =
            Directory(path.join(serverDir.path, 'lib', 'src', 'models'));
        await deepDir.create(recursive: true);

        result = ServerDirectoryFinder.search(deepDir);

        expect(result.status, equals(SearchStatus.found));
      },
    );

    test(
      'Given melos.yaml exists in parent, '
      'when searching upward, '
      'then it stops at the workspace boundary',
      () async {
        var melosFile = File(path.join(tempDir.path, 'melos.yaml'));
        await melosFile
            .writeAsString('name: my_workspace\npackages:\n  - packages/**\n');

        var packagesDir = Directory(path.join(tempDir.path, 'packages'));
        await packagesDir.create(recursive: true);

        var serverDir = await createMockServerDirectory(packagesDir, 'server');

        var outsideDir = Directory(path.join(tempDir.path, 'outside'));
        await outsideDir.create(recursive: true);

        var result = ServerDirectoryFinder.search(serverDir);
        expect(result.status, equals(SearchStatus.found));
      },
    );

    test(
      'Given nested structure with server outside repository boundary, '
      'when searching from inside boundary, '
      'then it does not find server outside boundary',
      () async {
        var outsideDir =
            Directory(path.join(tempDir.parent.path, 'outside_repo'));
        await outsideDir.create(recursive: true);
        await createMockServerDirectory(outsideDir, 'server_outside');

        var gitDir = Directory(path.join(tempDir.path, '.git'));
        await gitDir.create(recursive: true);

        var insideDir = Directory(path.join(tempDir.path, 'inside'));
        await insideDir.create(recursive: true);

        var result = ServerDirectoryFinder.search(insideDir);

        expect(result.status, equals(SearchStatus.notFound));

        await outsideDir.delete(recursive: true);
      },
    );

    test(
      'Given at repository root with .git, '
      'when searching from root, '
      'then it does not check siblings outside the repository',
      () async {
        var parentDir = tempDir.parent;
        var siblingRepoDir = Directory(path.join(parentDir.path, 'other_repo'));
        await siblingRepoDir.create(recursive: true);
        await createMockServerDirectory(siblingRepoDir, 'other_server');

        var gitDir = Directory(path.join(tempDir.path, '.git'));
        await gitDir.create(recursive: true);

        var insideServerDir =
            await createMockServerDirectory(tempDir, 'myproject_server');

        var result = ServerDirectoryFinder.search(tempDir);

        expect(result.status, equals(SearchStatus.found));
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(insideServerDir.path)),
        );
        expect(result.candidates.length, equals(1));

        await siblingRepoDir.delete(recursive: true);
      },
    );

    test(
      'Given server is 2 levels deep in monorepo (e.g., backend/myproject_server), '
      'when searching from sibling directory (e.g., apps/), '
      'then it finds the deeply nested server',
      () async {
        var gitDir = Directory(path.join(tempDir.path, '.git'));
        await gitDir.create(recursive: true);

        var appsDir = Directory(path.join(tempDir.path, 'apps'));
        await appsDir.create(recursive: true);

        var backendDir = Directory(path.join(tempDir.path, 'backend'));
        await backendDir.create(recursive: true);
        var serverDir =
            await createMockServerDirectory(backendDir, 'myproject_server');

        var result = ServerDirectoryFinder.search(appsDir);

        expect(result.status, equals(SearchStatus.found));
        expect(
          path.normalize(result.directory!.path),
          equals(path.normalize(serverDir.path)),
        );
      },
    );
  });

  group('SearchResult', () {
    test(
      'Given SearchResult.single constructor, '
      'when created, '
      'then status is found and directory is set',
      () {
        var dir = Directory('/test/path');
        var result = SearchResult.single(dir);

        expect(result.status, equals(SearchStatus.found));
        expect(result.directory, equals(dir));
        expect(result.candidates, equals([dir]));
      },
    );

    test(
      'Given SearchResult.multiple constructor, '
      'when created with 2 directories, '
      'then status is multipleFound and candidates are set',
      () {
        var dir1 = Directory('/test/path1');
        var dir2 = Directory('/test/path2');
        var result = SearchResult.multiple([dir1, dir2]);

        expect(result.status, equals(SearchStatus.multipleFound));
        expect(result.directory, isNull);
        expect(result.candidates, equals([dir1, dir2]));
      },
    );

    test(
      'Given SearchResult.notFound constructor, '
      'when created, '
      'then status is notFound and directory is null',
      () {
        var result = SearchResult.notFound();

        expect(result.status, equals(SearchStatus.notFound));
        expect(result.directory, isNull);
        expect(result.candidates, isEmpty);
      },
    );
  });
}
