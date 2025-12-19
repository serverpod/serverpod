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
  test(
    'Given a name and command, '
    'when creating a Script, '
    'then it has the correct properties',
    () {
      var script = Script(name: 'start', command: 'dart run');

      expect(script.name, 'start');
      expect(script.command, 'dart run');
    },
  );

  test(
    'Given two Scripts with same name and command, '
    'when comparing, '
    'then they are equal',
    () {
      var script1 = Script(name: 'start', command: 'dart run');
      var script2 = Script(name: 'start', command: 'dart run');

      expect(script1, equals(script2));
    },
  );

  test(
    'Given two Scripts with different commands, '
    'when comparing, '
    'then they are not equal',
    () {
      var script1 = Script(name: 'start', command: 'dart run');
      var script2 = Script(name: 'start', command: 'dart test');

      expect(script1, isNot(equals(script2)));
    },
  );

  test(
    'Given yaml with a no scripts, '
    'when parsing, '
    'then Scripts is empty',
    () async {
      final scripts = _buildScripts('');
      expect(scripts, isEmpty);
    },
  );

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
    'then ScriptParseException is thrown with correct message and span',
    () {
      var pubspec = _buildPubspec('''
start:
  - dart
  - run
''');

      expect(
        () => Scripts.fromPubspec(pubspec),
        throwsA(
          isA<ScriptParseException>()
              .having(
                (e) => e.message,
                'message',
                'Script "start" must be a string command or a map with '
                    '"windows" and/or "posix" keys, got YamlList',
              )
              .having((e) => e.span, 'span', isNotNull)
              .having(
                (e) => e.toString(),
                'toString()',
                'Error on line 5, column 7: Script "start" must be a string command or a map with "windows" and/or "posix" keys, got YamlList\n'
                    '  ╷\n'
                    '5 │ ┌       - dart\n'
                    '6 │ └       - run\n'
                    '  ╵',
              ),
        ),
      );
    },
  );

  test(
    'Given an ScriptParseException without a span, '
    'when calling toString, '
    'then only the message is returned',
    () {
      var exception = ScriptParseException('Test error message');

      expect(exception.toString(), equals('Test error message'));
      expect(exception.span, isNull);
    },
  );

  test(
    'Given an ScriptParseException with a span, '
    'when calling toString, '
    'then the output includes source context',
    () {
      var yaml =
          loadYaml('''
invalid_value: 123
''')
              as YamlMap;
      var span = yaml.nodes['invalid_value']!.span;

      var exception = ScriptParseException('Value must be a string', span);

      var output = exception.toString();
      expect(output, contains('Value must be a string'));
      expect(output, contains('line'));
      expect(output, contains('123'));
    },
  );

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
    'Given a pubspec.yaml file with "serverpod/scripts", '
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
    'Given a pubspec.yaml file with "serverpod/scripts" as a non-map value, '
    'when loading scripts, '
    'then ScriptParseException is thrown with correct message and span',
    () async {
      await d.file('pubspec.yaml', '''
name: test_project
version: 1.0.0

serverpod:
  scripts: not_a_map
''').create();

      expect(
        () => Scripts.fromPubspecFile(File(p.join(d.sandbox, 'pubspec.yaml'))),
        throwsA(
          isA<ScriptParseException>()
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
    'Given a pubspec.yaml file with an invalid script command, '
    'when loading scripts, '
    'then ScriptParseException is thrown with correct message and span',
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
        () => Scripts.fromPubspecFile(File(p.join(d.sandbox, 'pubspec.yaml'))),
        throwsA(
          isA<ScriptParseException>()
              .having(
                (e) => e.message,
                'message',
                'Script "start" must be a string command or a map with '
                    '"windows" and/or "posix" keys, got YamlList',
              )
              .having((e) => e.span, 'span', isNotNull)
              .having(
                (e) => e.toString(),
                'toString()',
                allOf(
                  startsWith('Error on line 7, column 5 of '),
                  // path is dynamic
                  endsWith(
                    'pubspec.yaml: Script "start" must be a string command or a map with "windows" and/or "posix" keys, got YamlList\n'
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

  group('Platform-specific scripts', () {
    test(
      'Given yaml with platform-specific script with both platforms, '
      'when parsing, '
      'then Script has both commands',
      () {
        var scripts = _buildScripts('''
start:
  windows: start.bat
  posix: ./start.sh
''');

        expect(scripts.length, 1);
        expect(scripts['start']?.name, 'start');
        expect(scripts['start']?.commands[PlatformGroup.windows], 'start.bat');
        expect(scripts['start']?.commands[PlatformGroup.posix], './start.sh');
      },
    );

    test(
      'Given yaml with platform-specific script with only windows, '
      'when parsing, '
      'then Script has only windows command',
      () {
        var scripts = _buildScripts('''
start:
  windows: start.bat
''');

        expect(scripts.length, 1);
        expect(scripts['start']?.commands[PlatformGroup.windows], 'start.bat');
        expect(scripts['start']?.commands[PlatformGroup.posix], isNull);
      },
    );

    test(
      'Given yaml with platform-specific script with only posix, '
      'when parsing, '
      'then Script has only posix command',
      () {
        var scripts = _buildScripts('''
start:
  posix: ./start.sh
''');

        expect(scripts.length, 1);
        expect(scripts['start']?.commands[PlatformGroup.windows], isNull);
        expect(scripts['start']?.commands[PlatformGroup.posix], './start.sh');
      },
    );

    test(
      'Given yaml with mixed simple and platform-specific scripts, '
      'when parsing, '
      'then all scripts are parsed correctly',
      () {
        var scripts = _buildScripts('''
simple: dart run
platform:
  windows: cmd /c start
  posix: ./run.sh
''');

        expect(scripts.length, 2);
        expect(scripts['simple']?.commands[PlatformGroup.windows], 'dart run');
        expect(scripts['simple']?.commands[PlatformGroup.posix], 'dart run');
        expect(
          scripts['platform']?.commands[PlatformGroup.windows],
          'cmd /c start',
        );
        expect(scripts['platform']?.commands[PlatformGroup.posix], './run.sh');
      },
    );

    test(
      'Given yaml with empty platform map, '
      'when parsing, '
      'then ScriptParseException is thrown',
      () {
        var pubspec = _buildPubspec('''
start: {}
''');

        expect(
          () => Scripts.fromPubspec(pubspec),
          throwsA(
            isA<ScriptParseException>().having(
              (e) => e.message,
              'message',
              'Script "start" must specify at least one platform command '
                  '(windows or posix)',
            ),
          ),
        );
      },
    );

    test(
      'Given yaml with unknown platform key, '
      'when parsing, '
      'then ScriptParseException is thrown',
      () {
        var pubspec = _buildPubspec('''
start:
  linux: ./start.sh
''');

        expect(
          () => Scripts.fromPubspec(pubspec),
          throwsA(
            isA<ScriptParseException>().having(
              (e) => e.message,
              'message',
              'Unknown platform "linux". Valid platforms are: windows or posix',
            ),
          ),
        );
      },
    );

    test(
      'Given yaml with non-string platform command, '
      'when parsing, '
      'then ScriptParseException is thrown',
      () {
        var pubspec = _buildPubspec('''
start:
  windows: 123
''');

        expect(
          () => Scripts.fromPubspec(pubspec),
          throwsA(
            isA<ScriptParseException>().having(
              (e) => e.message,
              'message',
              'Command for platform "windows" must be a string, got int',
            ),
          ),
        );
      },
    );

    test(
      'Given a Script created with simple command, '
      'when checking equality with platformSpecific, '
      'then they are equal if commands match',
      () {
        var simple = Script(name: 'test', command: 'dart run');
        var specific = Script.platformSpecific(
          name: 'test',
          windowsCommand: 'dart run',
          posixCommand: 'dart run',
        );

        expect(simple, equals(specific));
      },
    );

    test(
      'Given a Script with different platform commands, '
      'when calling toString, '
      'then it shows both platforms',
      () {
        var script = Script.platformSpecific(
          name: 'start',
          windowsCommand: 'start.bat',
          posixCommand: './start.sh',
        );

        expect(
          script.toString(),
          'Script(name: start, windows: start.bat, posix: ./start.sh)',
        );
      },
    );

    test(
      'Given a Script with same command for both platforms, '
      'when calling toString, '
      'then it shows single command',
      () {
        var script = Script(name: 'start', command: 'dart run');

        expect(script.toString(), 'Script(name: start, command: dart run)');
      },
    );

    test(
      'Given a Script with command for current platform, '
      'when checking supportsCurrentPlatform, '
      'then it returns true',
      () {
        var script = Script(name: 'start', command: 'dart run');

        expect(script.supportsCurrentPlatform, isTrue);
      },
    );

    test(
      'Given a Script without command for current platform, '
      'when checking supportsCurrentPlatform, '
      'then it returns false',
      () {
        // Create a script that only supports the other platform
        var script = Platform.isWindows
            ? Script.platformSpecific(
                name: 'start',
                posixCommand: './start.sh',
              )
            : Script.platformSpecific(
                name: 'start',
                windowsCommand: 'start.bat',
              );

        expect(script.supportsCurrentPlatform, isFalse);
      },
    );

    test(
      'Given a Script without command for current platform, '
      'when accessing command, '
      'then UnsupportedPlatformException is thrown',
      () {
        // Create a script that only supports the other platform
        var script = Platform.isWindows
            ? Script.platformSpecific(
                name: 'start',
                posixCommand: './start.sh',
              )
            : Script.platformSpecific(
                name: 'start',
                windowsCommand: 'start.bat',
              );

        expect(
          () => script.command,
          throwsA(
            isA<UnsupportedPlatformException>()
                .having((e) => e.scriptName, 'scriptName', 'start')
                .having(
                  (e) => e.platform,
                  'platform',
                  Platform.isWindows ? 'windows' : 'posix',
                )
                .having(
                  (e) => e.toString(),
                  'toString()',
                  Platform.isWindows
                      ? 'Script "start" is not available on windows'
                      : 'Script "start" is not available on posix',
                ),
          ),
        );
      },
    );
  });
}
