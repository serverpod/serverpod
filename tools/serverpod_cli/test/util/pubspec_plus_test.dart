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
  sdk: '>=3.5.0 <4.0.0'

dependencies:
  serverpod: 2.3.1

dev_dependencies:
  lints: '>=3.0.0 <7.0.0'
  test: ^1.24.2
  serverpod_test: 2.3.1
''';
    group('when calling PubspecPlus.parse', () {
      late PubspecPlus pubspecPlus = PubspecPlus.parse(pubspecString);
      var depsByName = {for (var d in pubspecPlus.deps) d.name: d};

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
      });

      test('then it returns a lints dependency of kind dev', () {
        var lintsDep = depsByName['lints']!;
        expect(lintsDep.kind, DepKind.dev);
      });

      test('then it returns a lints dependency of type HostedDep', () {
        var lintsDep = depsByName['lints']!;
        expect(lintsDep, isA<HostedDep>());
      });

      test('then it returns a lints dependency with correct version', () {
        var lintsDep = depsByName['lints']!;
        expect(
          (lintsDep as HostedDep).dependency.version,
          VersionConstraint.parse('>=3.0.0 <7.0.0'),
        );
      });

      test('then it returns a serverpod dependency of kind normal', () {
        var serverpodDep = depsByName['serverpod']!;
        expect(serverpodDep.kind, DepKind.normal);
      });

      test('then it returns a serverpod dependency of type HostedDep', () {
        var serverpodDep = depsByName['serverpod']!;
        expect(serverpodDep, isA<HostedDep>());
      });

      test('then it returns a serverpod dependency with correct version', () {
        var serverpodDep = depsByName['serverpod']!;
        expect(
          (serverpodDep as HostedDep).dependency.version,
          VersionConstraint.parse('2.3.1'),
        );
      });

      test('then the span of the serverpod dependency is correct', () {
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
      });

      test('then the span of the lints dependency is correct', () {
        final lintsSpan = depsByName['lints']!.span;
        expect(lintsSpan.start.line, 8); // 0-based
        expect(lintsSpan.start.column, 9);
        expect(lintsSpan.end.line, 8);
        expect(lintsSpan.end.column, 25);
        expect(lintsSpan.text, "'>=3.0.0 <7.0.0'");
        expect(
          lintsSpan.message('<the message>'),
          'line 9, column 10: <the message>\n' // 1-based
          '  ╷\n'
          "9 │   lints: '>=3.0.0 <7.0.0'\n"
          '  │          ^^^^^^^^^^^^^^^^\n'
          '  ╵',
        );
      });

      test('then the span of the test dependency is correct', () {
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
      });

      test('then the span serverpod_test dependency is correct', () {
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
