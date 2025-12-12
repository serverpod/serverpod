import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/scripts/script.dart';
import 'package:serverpod_cli/src/scripts/scripts.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:term_glyph/term_glyph.dart' as glyph;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

PubspecPlus _buildPubspec(String scriptsText) {
  final editor = YamlEditor('''
name: test_project
version: 1.0.0
''');
  final node = loadYamlNode(scriptsText);
  if (node is YamlMap) {
    editor.update(
      ['serverpod'],
      wrapAsYamlNode({'scripts': node}),
    );
  }
  return PubspecPlus.parse(editor.toString());
}

Scripts _buildScripts(String scriptsText) =>
    Scripts.fromPubspec(_buildPubspec(scriptsText));

void main() {
  // Use Unicode glyphs for better and consistent visual output
  // (Not default on windows)
  glyph.ascii = false;
  group('Script', () {
    test(
      'Given a name and command, '
      'when creating a Script, '
      'then it has the correct properties',
      () {
        var script = const Script(name: 'start', command: 'dart run');

        expect(script.name, 'start');
        expect(script.command, 'dart run');
      },
    );

    test(
      'Given two Scripts with same name and command, '
      'when comparing, '
      'then they are equal',
      () {
        var script1 = const Script(name: 'start', command: 'dart run');
        var script2 = const Script(name: 'start', command: 'dart run');

        expect(script1, equals(script2));
      },
    );

    test(
      'Given two Scripts with different commands, '
      'when comparing, '
      'then they are not equal',
      () {
        var script1 = const Script(name: 'start', command: 'dart run');
        var script2 = const Script(name: 'start', command: 'dart test');

        expect(script1, isNot(equals(script2)));
      },
    );
  });

  group('Scripts.fromPubspec', () {
    test(
      'Given yaml with a single script, '
      'when parsing, '
      'then Scripts contains one entry',
      () {
        var scripts = _buildScripts('''
start: dart bin/main.dart
''');

        expect(scripts.length, 1);
        expect(scripts['start']?.name, 'start');
        expect(scripts['start']?.command, 'dart bin/main.dart');
      },
    );

    test(
      'Given yaml with multiple scripts, '
      'when parsing, '
      'then Scripts contains all entries',
      () {
        var scripts = _buildScripts('''
start: dart bin/main.dart
test: dart test
build: dart compile exe bin/main.dart
''');

        expect(scripts.length, 3);
        expect(scripts['start']?.command, 'dart bin/main.dart');
        expect(scripts['test']?.command, 'dart test');
        expect(scripts['build']?.command, 'dart compile exe bin/main.dart');
      },
    );

    test(
      'Given yaml with a non-string command value, '
      'when parsing, '
      'then ScriptsParseException is thrown with correct message and span',
      () {
        var pubspec = _buildPubspec('''
start:
  - dart
  - run
''');

        expect(
          () => Scripts.fromPubspec(pubspec),
          throwsA(
            isA<ScriptsParseException>()
                .having(
                  (e) => e.message,
                  'message',
                  'Script "start" must have a string command, got YamlList',
                )
                .having((e) => e.span, 'span', isNotNull)
                .having(
                  (e) => e.toString(),
                  'toString()',
                  'Error on line 5, column 7: Script "start" must have a string command, got YamlList\n'
                      '  ╷\n'
                      '5 │ ┌       - dart\n'
                      '6 │ └       - run\n'
                      '  ╵',
                ),
          ),
        );
      },
    );
  });

  group('ScriptsParseException', () {
    test(
      'Given an exception without a span, '
      'when calling toString, '
      'then only the message is returned',
      () {
        var exception = ScriptsParseException('Test error message');

        expect(exception.toString(), equals('Test error message'));
        expect(exception.span, isNull);
      },
    );

    test(
      'Given an exception with a span, '
      'when calling toString, '
      'then the output includes source context',
      () {
        var yaml =
            loadYaml('''
invalid_value: 123
''')
                as YamlMap;
        var span = yaml.nodes['invalid_value']!.span;

        var exception = ScriptsParseException('Value must be a string', span);

        var output = exception.toString();
        expect(output, contains('Value must be a string'));
        expect(output, contains('line'));
        expect(output, contains('123'));
      },
    );
  });

  group('Scripts.fromPubspecFile', () {
    test(
      'Given a non-existent file, '
      'when loading scripts, '
      'then it throws PathNotFoundException',
      () {
        var nonExistentFile = File(p.join(d.sandbox, 'nonexistent.yaml'));

        expect(
          () => Scripts.fromPubspecFile(nonExistentFile),
          throwsA(isA<PathNotFoundException>()),
        );
      },
    );

    test(
      'Given a pubspec without "serverpod/scripts", '
      'when loading scripts, '
      'then an empty Scripts is returned',
      () async {
        final pubspec = _buildPubspec('');

        var scripts = Scripts.fromPubspec(pubspec);

        expect(scripts, isEmpty);
      },
    );

    test(
      'Given a pubspec with serverpod_scripts, '
      'when loading scripts, '
      'then all scripts are parsed',
      () async {
        await d.file('pubspec.yaml', '''
name: test_project
version: 1.0.0

serverpod:
  scripts:
    start: dart bin/main.dart --apply-migrations
    dev: dart bin/main.dart --role webserver
''').create();

        var scripts = Scripts.fromPubspecFile(
          File(p.join(d.sandbox, 'pubspec.yaml')),
        );

        expect(scripts.length, 2);
        expect(
          scripts['start']?.command,
          'dart bin/main.dart --apply-migrations',
        );
        expect(scripts['dev']?.command, 'dart bin/main.dart --role webserver');
      },
    );

    test(
      'Given a pubspec with serverpod_scripts as a non-map value, '
      'when loading scripts, '
      'then ScriptsParseException is thrown with correct message and span',
      () async {
        await d.file('pubspec.yaml', '''
name: test_project
version: 1.0.0

serverpod:
  scripts: not_a_map
''').create();

        expect(
          () =>
              Scripts.fromPubspecFile(File(p.join(d.sandbox, 'pubspec.yaml'))),
          throwsA(
            isA<ScriptsParseException>()
                .having(
                  (e) => e.message,
                  'message',
                  'Invalid node',
                )
                .having((e) => e.span, 'span', isNotNull)
                .having(
                  (e) => e.toString(),
                  'toString()',
                  allOf(
                    startsWith('Error on line 5, column 12 of '),
                    // path is dynamic
                    endsWith(
                      'pubspec.yaml: Invalid node\n'
                      '  ╷\n'
                      '5 │   scripts: not_a_map\n'
                      '  │            ^^^^^^^^^\n'
                      '  ╵',
                    ),
                  ),
                ),
          ),
        );
      },
    );

    test(
      'Given a pubspec with an invalid script command, '
      'when loading scripts, '
      'then ScriptsParseException is thrown with correct message and span',
      () async {
        await d.file('pubspec.yaml', '''
name: test_project
version: 1.0.0

serverpod:
  scripts:
    start:
    - not
    - a
    - string
''').create();

        expect(
          () =>
              Scripts.fromPubspecFile(File(p.join(d.sandbox, 'pubspec.yaml'))),
          throwsA(
            isA<ScriptsParseException>()
                .having(
                  (e) => e.message,
                  'message',
                  'Script "start" must have a string command, got YamlList',
                )
                .having((e) => e.span, 'span', isNotNull)
                .having(
                  (e) => e.toString(),
                  'toString()',
                  allOf(
                    startsWith('Error on line 7, column 5 of '),
                    // path is dynamic
                    endsWith(
                      'pubspec.yaml: Script "start" must have a string command, got YamlList\n'
                      '  ╷\n'
                      '7 │ ┌     - not\n'
                      '8 │ │     - a\n'
                      '9 │ └     - string\n'
                      '  ╵',
                    ),
                  ),
                ),
          ),
        );
      },
    );
  });

  group('Scripts.findPubspecFile', () {
    test(
      'Given a server directory with pubspec.yaml, '
      'when finding pubspec, '
      'then the file is returned',
      () async {
        await d.file('pubspec.yaml', '''
name: test_server
dependencies:
  serverpod: any
''').create();

        var found = await Scripts.findPubspecFile(Directory(d.sandbox));

        expect(found, isNotNull);
        expect(found!.path, p.join(d.sandbox, 'pubspec.yaml'));
      },
    );

    test(
      'Given a subdirectory with server pubspec.yaml in parent, '
      'when finding pubspec, '
      'then the parent file is returned',
      () async {
        await d.dir('sub', [d.dir('dir')]).create();
        await d.file('pubspec.yaml', '''
name: test_server
dependencies:
  serverpod: any
''').create();

        var found = await Scripts.findPubspecFile(
          Directory(p.join(d.sandbox, 'sub/dir')),
          interactive: false,
        );

        expect(found, isNotNull);
        expect(found!.path, p.join(d.sandbox, 'pubspec.yaml'));
      },
    );
  });
}
