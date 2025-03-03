import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/util/pubspec_plus.dart';
import 'package:term_glyph/term_glyph.dart';
import 'package:test/test.dart';

void main() {
  ascii = false;

  group('Given a valid pubspec.yaml', () {
    const pubspecString = '''
name: x_server
environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  serverpod: 2.3.1

dev_dependencies:
  lints: '>=3.0.0 <6.0.0'
  test: ^1.24.2
  serverpod_test: 2.3.1
''';
    group('when calling PubspecPlus.parse', () {
      late PubspecPlus pubspecPlus = PubspecPlus.parse(pubspecString);
      test('then it succeeds', () {
        expect(
          () => pubspecPlus,
          returnsNormally,
        );
      });

      test('then it returns PubspecPlus with correct dependencies', () {
        expect(
          pubspecPlus.deps.map((d) => d.name),
          unorderedEquals(['lints', 'serverpod_test', 'serverpod', 'test']),
        );

        var lintsDep = pubspecPlus.deps.firstWhere((d) => d.name == 'lints');
        expect(lintsDep.kind, DepKind.dev);
        expect(lintsDep, isA<HostedDep>());
        expect(
          (lintsDep as HostedDep).dependency.version,
          VersionConstraint.parse('>=3.0.0 <6.0.0'),
        );

        var serverpodDep =
            pubspecPlus.deps.firstWhere((d) => d.name == 'serverpod');
        expect(serverpodDep.kind, DepKind.normal);
        expect(serverpodDep, isA<HostedDep>());
        expect(
          (serverpodDep as HostedDep).dependency.version,
          VersionConstraint.parse('2.3.1'),
        );
      });

      test('then the span of each dependency is correct', () {
        var depsByName = {for (var d in pubspecPlus.deps) d.name: d};

        final serverpodSpan = depsByName['serverpod']!.span;
        expect(serverpodSpan.start.line, 5); // 0-based
        expect(serverpodSpan.start.column, 13);
        expect(serverpodSpan.end.line, 5);
        expect(serverpodSpan.end.column, 18);
        expect(serverpodSpan.text, '2.3.1');
        expect(
          serverpodSpan.message('<the message>'),
          'line 6, column 14: <the message>\n' // 1-based
          '  ╷\n'
          '6 │   serverpod: 2.3.1\n'
          '  │              ^^^^^\n'
          '  ╵',
        );

        final lintSpan = depsByName['lints']!.span;
        expect(lintSpan.start.line, 8); // 0-based
        expect(lintSpan.start.column, 9);
        expect(lintSpan.end.line, 8);
        expect(lintSpan.end.column, 25);
        expect(lintSpan.text, "'>=3.0.0 <6.0.0'");
        expect(
          lintSpan.message('<the message>'),
          'line 9, column 10: <the message>\n' // 1-based
          '  ╷\n'
          "9 │   lints: '>=3.0.0 <6.0.0'\n"
          '  │          ^^^^^^^^^^^^^^^^\n'
          '  ╵',
        );

        final testSpan = depsByName['test']!.span;
        expect(testSpan.start.line, 9); // 0-based
        expect(testSpan.start.column, 8);
        expect(testSpan.end.line, 9);
        expect(testSpan.end.column, 15);
        expect(testSpan.text, '^1.24.2');
        expect(
          testSpan.message('<the message>'),
          'line 10, column 9: <the message>\n' // 1-based
          '   ╷\n'
          '10 │   test: ^1.24.2\n'
          '   │         ^^^^^^^\n'
          '   ╵',
        );

        final serverpodTestSpan = depsByName['serverpod_test']!.span;
        expect(serverpodTestSpan.start.line, 10); // 0-based
        expect(serverpodTestSpan.start.column, 18);
        expect(serverpodTestSpan.end.line, 10);
        expect(serverpodTestSpan.end.column, 23);
        expect(serverpodTestSpan.text, '2.3.1');
        expect(
          serverpodTestSpan.message('<the message>'),
          'line 11, column 19: <the message>\n' // 1-based
          '   ╷\n'
          '11 │   serverpod_test: 2.3.1\n'
          '   │                   ^^^^^\n'
          '   ╵',
        );
      });
    });
  });
}
