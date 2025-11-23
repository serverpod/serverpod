import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'server_directory_finder_test_utils.dart';

void main() {
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
