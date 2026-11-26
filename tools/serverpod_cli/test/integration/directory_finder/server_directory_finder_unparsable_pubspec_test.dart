import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../../test_util/server_directory_finder_helpers.dart';

Matcher throwsPubspecParseExceptionFor(String dirName) => throwsA(
  isA<PubspecParseException>().having(
    (e) => path.basename(path.dirname(e.path)),
    'directory of path',
    dirName,
  ),
);

void main() {
  group('ServerDirectoryFinder.search with an unparsable pubspec', () {
    test(
      'Given a server and an unrelated directory with an unparsable pubspec as children, '
      'when search is called from the parent, '
      'then it returns the server',
      () async {
        await d.dir('project', [
          serverDir('my_server'),
          unparsablePubspecDir('scratch'),
        ]).create();

        var result = ServerDirectoryFinder.search(
          Directory(path.join(d.sandbox, 'project')),
        );

        expect(path.basename(result!.path), 'my_server');
      },
    );

    test(
      'Given a server nested inside a directory with an unparsable pubspec, '
      'when search is called from above it, '
      'then it returns the nested server',
      () async {
        await d.dir('project', [
          unparsablePubspecDir('workspace', [serverDir('my_server')]),
        ]).create();

        var result = ServerDirectoryFinder.search(
          Directory(path.join(d.sandbox, 'project')),
        );

        expect(path.basename(result!.path), 'my_server');
      },
    );

    test(
      'Given a server and an unrelated directory with an unparsable pubspec in a parent directory, '
      'when search is called from a sibling directory, '
      'then it returns the server',
      () async {
        await d.dir('project', [
          serverDir('my_server'),
          unparsablePubspecDir('scratch'),
          d.dir('docs', []),
        ]).create();

        var result = ServerDirectoryFinder.search(
          Directory(path.join(d.sandbox, 'project', 'docs')),
        );

        expect(path.basename(result!.path), 'my_server');
      },
    );

    test(
      'Given a server containing an example with an unparsable pubspec, '
      'when search is called from inside the server, '
      'then it returns the server',
      () async {
        await d.dir('project', [serverDir('my_server')]).create();
        await unparsablePubspecDir(
          'example',
        ).create(path.join(d.sandbox, 'project', 'my_server'));
        var libDir = Directory(
          path.join(d.sandbox, 'project', 'my_server', 'lib'),
        )..createSync();

        var result = ServerDirectoryFinder.search(libDir);

        expect(path.basename(result!.path), 'my_server');
      },
    );

    test(
      'Given the start directory has an unparsable pubspec, '
      'when search is called, '
      'then it throws a PubspecParseException',
      () async {
        await unparsablePubspecDir('my_server').create();

        expect(
          () => ServerDirectoryFinder.search(
            Directory(path.join(d.sandbox, 'my_server')),
          ),
          throwsPubspecParseExceptionFor('my_server'),
        );
      },
    );

    test(
      'Given a parent directory has an unparsable pubspec, '
      'when search is called from inside it, '
      'then it throws a PubspecParseException',
      () async {
        await unparsablePubspecDir('my_server', [d.dir('lib', [])]).create();

        expect(
          () => ServerDirectoryFinder.search(
            Directory(path.join(d.sandbox, 'my_server', 'lib')),
          ),
          throwsPubspecParseExceptionFor('my_server'),
        );
      },
    );

    test(
      'Given the _server sibling of a _flutter directory has an unparsable pubspec, '
      'when search is called from the _flutter directory, '
      'then it throws a PubspecParseException',
      () async {
        await d.dir('project', [
          unparsablePubspecDir('myapp_server'),
          nonServerDir('myapp_flutter'),
        ]).create();

        expect(
          () => ServerDirectoryFinder.search(
            Directory(path.join(d.sandbox, 'project', 'myapp_flutter')),
          ),
          throwsPubspecParseExceptionFor('myapp_server'),
        );
      },
    );

    test(
      'Given the only server-like child has an unparsable pubspec, '
      'when search is called from the parent, '
      'then it throws a PubspecParseException',
      () async {
        await d.dir('project', [
          unparsablePubspecDir('my_server'),
          nonServerDir('my_client'),
        ]).create();

        expect(
          () => ServerDirectoryFinder.search(
            Directory(path.join(d.sandbox, 'project')),
          ),
          throwsPubspecParseExceptionFor('my_server'),
        );
      },
    );

    test(
      'Given a child with an unparsable pubspec and another server further up, '
      'when search is called, '
      'then it throws a PubspecParseException instead of returning the server further away',
      () async {
        await d.dir('root', [
          serverDir('other_server'),
          d.dir('app', [unparsablePubspecDir('app_server')]),
        ]).create();

        expect(
          () => ServerDirectoryFinder.search(
            Directory(path.join(d.sandbox, 'root', 'app')),
          ),
          throwsPubspecParseExceptionFor('app_server'),
        );
      },
    );

    test(
      'Given a directory with an unparsable pubspec found while searching parents and another server further up, '
      'when search is called, '
      'then it throws a PubspecParseException instead of returning the server further away',
      () async {
        await d.dir('root', [
          serverDir('other_server'),
          d.dir('app', [unparsablePubspecDir('app_server'), d.dir('docs', [])]),
        ]).create();

        expect(
          () => ServerDirectoryFinder.search(
            Directory(path.join(d.sandbox, 'root', 'app', 'docs')),
          ),
          throwsPubspecParseExceptionFor('app_server'),
        );
      },
    );
  });

  group('ServerDirectoryFinder.findOrPrompt with an unparsable pubspec', () {
    test(
      'Given no server and a child with an unparsable pubspec, '
      'when findOrPrompt is called, '
      'then it throws the PubspecParseException instead of reporting no project',
      () async {
        await d.dir('project', [unparsablePubspecDir('my_server')]).create();

        await expectLater(
          ServerDirectoryFinder.findOrPrompt(
            startDir: Directory(path.join(d.sandbox, 'project')),
            interactive: false,
          ),
          throwsPubspecParseExceptionFor('my_server'),
        );
      },
    );
  });
}
