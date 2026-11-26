import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../../test_util/server_directory_finder_helpers.dart';

void main() {
  group('findServerDirectory', () {
    test(
      'Given a server and a directory with an unparsable pubspec as children, '
      'when findServerDirectory is called on the parent, '
      'then it returns the server',
      () async {
        await d.dir('project', [
          unparsablePubspecDir('broken'),
          serverDir('my_server'),
        ]).create();

        var result = findServerDirectory(
          Directory(path.join(d.sandbox, 'project')),
        );

        expect(path.basename(result!.path), 'my_server');
      },
    );

    test(
      'Given the root has an unparsable pubspec, '
      'when findServerDirectory is called on it, '
      'then it throws a PubspecParseException',
      () async {
        await unparsablePubspecDir('my_server').create();

        expect(
          () => findServerDirectory(
            Directory(path.join(d.sandbox, 'my_server')),
          ),
          throwsA(isA<PubspecParseException>()),
        );
      },
    );

    test(
      'Given no server and a child with an unparsable pubspec, '
      'when findServerDirectory is called on the parent, '
      'then it throws a PubspecParseException',
      () async {
        await d.dir('project', [
          unparsablePubspecDir('my_server'),
          nonServerDir('my_client'),
        ]).create();

        expect(
          () => findServerDirectory(
            Directory(path.join(d.sandbox, 'project')),
          ),
          throwsA(
            isA<PubspecParseException>().having(
              (e) => path.normalize(e.path),
              'path',
              path.join(d.sandbox, 'project', 'my_server', 'pubspec.yaml'),
            ),
          ),
        );
      },
    );

    test(
      'Given no server and no unparsable pubspec, '
      'when findServerDirectory is called, '
      'then it returns null',
      () async {
        await d.dir('project', [
          nonServerDir('my_client'),
        ]).create();

        var result = findServerDirectory(
          Directory(path.join(d.sandbox, 'project')),
        );

        expect(result, isNull);
      },
    );
  });
}
