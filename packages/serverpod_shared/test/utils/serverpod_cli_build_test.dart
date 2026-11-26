import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/process_io.dart';
import 'package:test/test.dart';

/// Writes a minimal serverpod checkout under [root]: `serverpod_cli`
/// depending on the in-repo `serverpod_shared` and the hosted `ext`, plus an
/// unrelated in-repo package.
void _writeCheckout(String root, {String extVersion = '1.0.0'}) {
  void write(String path, String contents) {
    File(p.join(root, path))
      ..createSync(recursive: true)
      ..writeAsStringSync(contents);
  }

  write(
    '.dart_tool/package_config.json',
    jsonEncode({
      'configVersion': 2,
      'packages': [
        {'name': 'serverpod_cli', 'rootUri': '../tools/serverpod_cli'},
        {'name': 'serverpod_shared', 'rootUri': '../packages/serverpod_shared'},
        {'name': 'unrelated', 'rootUri': '../packages/unrelated'},
        {'name': 'ext', 'rootUri': 'file:///pub-cache/ext-$extVersion'},
      ],
    }),
  );
  write(
    '.dart_tool/package_graph.json',
    jsonEncode({
      'configVersion': 1,
      'packages': [
        {
          'name': 'serverpod_cli',
          'dependencies': ['serverpod_shared', 'ext'],
          'devDependencies': ['unrelated'],
        },
        {'name': 'serverpod_shared', 'dependencies': []},
        {'name': 'unrelated', 'dependencies': []},
        {'name': 'ext', 'dependencies': []},
      ],
    }),
  );
  write('tools/serverpod_cli/pubspec.yaml', 'name: serverpod_cli\n');
  write('tools/serverpod_cli/bin/serverpod_cli.dart', 'void main() {}\n');
  write('tools/serverpod_cli/lib/cli.dart', 'const cli = 1;\n');
  write('tools/serverpod_cli/test/cli_test.dart', 'void main() {}\n');
  write('packages/serverpod_shared/pubspec.yaml', 'name: serverpod_shared\n');
  write('packages/serverpod_shared/lib/shared.dart', 'const shared = 1;\n');
  write('packages/unrelated/pubspec.yaml', 'name: unrelated\n');
  write('packages/unrelated/lib/unrelated.dart', 'const unrelated = 1;\n');
}

void main() {
  group('Given a serverpod checkout,', () {
    late Directory tempDir;
    late String root;
    late String hash;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('scb');
      root = p.join(tempDir.path, 'checkout');
      _writeCheckout(root);
      hash = serverpodCliSourceHash(root);
    });

    tearDown(() => tempDir.deleteSync(recursive: true));

    test(
      'when a second checkout has the same sources, '
      'then its hash is the same',
      () {
        final other = p.join(tempDir.path, 'other');
        _writeCheckout(other);

        expect(serverpodCliSourceHash(other), hash);
      },
    );

    for (final (what, path) in [
      ('a CLI library', 'tools/serverpod_cli/lib/cli.dart'),
      ('the CLI entrypoint', 'tools/serverpod_cli/bin/serverpod_cli.dart'),
      ('the CLI pubspec', 'tools/serverpod_cli/pubspec.yaml'),
      (
        'a library of an in-repo dependency',
        'packages/serverpod_shared/lib/shared.dart',
      ),
    ]) {
      test('when $what changes, then the hash changes', () {
        File(
          p.join(root, path),
        ).writeAsStringSync('// changed\n', mode: FileMode.append);

        expect(serverpodCliSourceHash(root), isNot(hash));
      });
    }

    test('when a CLI library is added, then the hash changes', () {
      File(p.join(root, 'tools/serverpod_cli/lib/src/new.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync('');

      expect(serverpodCliSourceHash(root), isNot(hash));
    });

    test(
      'when a hosted dependency resolves to another version, '
      'then the hash changes',
      () {
        _writeCheckout(root, extVersion: '1.0.1');

        expect(serverpodCliSourceHash(root), isNot(hash));
      },
    );

    for (final (what, path) in [
      ('a CLI test', 'tools/serverpod_cli/test/cli_test.dart'),
      (
        'a package the CLI only depends on for development',
        'packages/unrelated/lib/unrelated.dart',
      ),
    ]) {
      test('when $what changes, then the hash is the same', () {
        File(
          p.join(root, path),
        ).writeAsStringSync('// changed\n', mode: FileMode.append);

        expect(serverpodCliSourceHash(root), hash);
      });
    }
  });
}
