import 'dart:io';

import 'package:serverpod_cli/src/util/directory.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  group('Given a directory with an unparsable pubspec.yaml,', () {
    setUp(() async {
      await d.dir('my_project_server', [
        d.file(
          'pubspec.yaml',
          'name: my_project_server\n'
              'dependencies:\n'
              '  serverpod: ^4.0.0test: ^1.0.0\n',
        ),
      ]).create();
    });

    test(
      'when findServerDirectory is called on it, '
      'then it throws a parse error',
      () {
        expect(
          () => findServerDirectory(Directory(d.path('my_project_server'))),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Error while parsing pubspec file'),
            ),
          ),
        );
      },
    );
  });
}
