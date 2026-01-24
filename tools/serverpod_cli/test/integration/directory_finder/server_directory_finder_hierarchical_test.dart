import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../../test_util/server_directory_finder_helpers.dart';

void main() {
  group(
    'ServerDirectoryFinder.search hierarchical order and early returns',
    () {
      test(
        'Given server in both child and parent directories, '
        'when search is called, '
        'then it returns child server (early return from children search)',
        () async {
          await d.dir('parent', [
            d.file('pubspec.yaml', '''
name: parent_server
dependencies:
  serverpod: ^2.0.0
'''),
            d.dir('subdir', [
              serverDir('child_server'),
            ]),
          ]).create();

          var subdirPath = Directory(path.join(d.sandbox, 'parent', 'subdir'));
          var result = ServerDirectoryFinder.search(subdirPath);

          expect(result, isNotNull);
          expect(
            path.basename(result!.path),
            equals('child_server'),
            reason: 'Should return child server, not parent',
          );
        },
      );

      test(
        'Given server found via sibling pattern and in parent, '
        'when search is called from client directory, '
        'then it returns sibling server (early return from sibling search)',
        () async {
          await d.dir('project', [
            d.file('pubspec.yaml', '''
name: project_server
dependencies:
  serverpod: ^2.0.0
'''),
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
            reason: 'Should return sibling server, not parent',
          );
        },
      );

      test(
        'Given multiple servers in children (same tier), '
        'when search is called, '
        'then it throws AmbiguousSearchException (no early return)',
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
            reason: 'Should find both children and throw exception',
          );
        },
      );

      test(
        'Given no server in children or siblings but server in parent, '
        'when search is called from deep subdirectory, '
        'then it returns parent server (reaches upward search tier)',
        () async {
          await d.dir('project', [
            d.file('pubspec.yaml', '''
name: project_server
dependencies:
  serverpod: ^2.0.0
'''),
            d.dir('some_dir', [
              d.dir('deep_dir', []),
            ]),
          ]).create();

          var deepDir = Directory(
            path.join(d.sandbox, 'project', 'some_dir', 'deep_dir'),
          );
          var result = ServerDirectoryFinder.search(deepDir);

          expect(result, isNotNull);
          expect(
            path.basename(result!.path),
            equals('project'),
            reason: 'Should find parent server via upward search',
          );
        },
      );
    },
  );
}
