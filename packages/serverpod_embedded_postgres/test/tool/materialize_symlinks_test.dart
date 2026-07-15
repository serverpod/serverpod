// Skipped on Windows: creating the fixture symlinks needs the very
// privilege the script under test exists to avoid depending on.
@TestOn('!windows')
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

/// Exercises tool/build_postgres/materialize-symlinks.sh, the Windows
/// packaging step that replaces every symlink in the bundle stage with a
/// real copy (Windows end users cannot create symlinks on extraction).
/// Runs the script with bash against synthetic stages.
void main() {
  final script = p.absolute('tool/build_postgres/materialize-symlinks.sh');

  late Directory stage;

  Future<ProcessResult> run() => Process.run('bash', [script, stage.path]);

  File fileIn(String relative) => File(p.join(stage.path, relative));
  Link linkIn(String relative) => Link(p.join(stage.path, relative));

  setUp(() {
    stage = Directory.systemTemp.createTempSync('materialize_symlinks_');
    Directory(p.join(stage.path, 'share', 'extension')).createSync(
      recursive: true,
    );
  });

  tearDown(() {
    if (stage.existsSync()) stage.deleteSync(recursive: true);
  });

  group('Given a stage with a same-directory symlink chain,', () {
    setUp(() {
      fileIn('share/extension/real.sql').writeAsStringSync('REAL');
      linkIn('share/extension/hop.sql').createSync('real.sql');
      linkIn('share/extension/entry.sql').createSync('hop.sql');
    });

    test(
      'when materializing, '
      'then every link becomes a real copy of the chain end and none remain.',
      () async {
        var result = await run();

        expect(result.exitCode, 0, reason: '${result.stderr}');
        expect(fileIn('share/extension/entry.sql').readAsStringSync(), 'REAL');
        expect(fileIn('share/extension/hop.sql').readAsStringSync(), 'REAL');
        expect(
          stage.listSync(recursive: true).whereType<Link>(),
          isEmpty,
        );
      },
    );
  });

  group(
    'Given a stage with the mingw PostGIS form '
    '(a target written relative to the bundle root),',
    () {
      setUp(() {
        fileIn('share/extension/upgrade.sql').writeAsStringSync('UPGRADE');
        linkIn('share/extension/alias.sql').createSync(
          './share/extension/upgrade.sql',
        );
      });

      test(
        'when materializing, '
        'then the bundle-root interpretation resolves and the link becomes a real copy.',
        () async {
          var result = await run();

          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(
            fileIn('share/extension/alias.sql').readAsStringSync(),
            'UPGRADE',
          );
        },
      );
    },
  );

  group(
    'Given a dangling link that sorts before a perfectly valid link,',
    () {
      setUp(() {
        linkIn('share/extension/a-dangling.sql').createSync('missing.sql');
        fileIn('share/extension/real.sql').writeAsStringSync('REAL');
        linkIn('share/extension/z-valid.sql').createSync('real.sql');
      });

      test(
        'when materializing, '
        'then the run fails naming the dangling link instead of skipping it.',
        () async {
          var result = await run();

          expect(result.exitCode, isNot(0));
          expect(result.stderr, contains('a-dangling.sql'));
          expect(result.stderr, contains('cannot materialize'));
        },
      );
    },
  );

  group(
    'Given a valid parent-relative target whose basename collides with an '
    'unrelated same-directory file,',
    () {
      setUp(() {
        Directory(p.join(stage.path, 'share', 'other')).createSync();
        fileIn('share/other/data.sql').writeAsStringSync('RIGHT');
        fileIn('share/extension/data.sql').writeAsStringSync('WRONG');
        linkIn('share/extension/link.sql').createSync('../other/data.sql');
      });

      test(
        'when materializing, '
        'then the actual target is copied rather than the colliding file.',
        () async {
          var result = await run();

          expect(result.exitCode, 0, reason: '${result.stderr}');
          expect(
            fileIn('share/extension/link.sql').readAsStringSync(),
            'RIGHT',
          );
        },
      );
    },
  );

  group(
    'Given a dangling same-directory target whose basename exists only at the bundle root,',
    () {
      setUp(() {
        fileIn('missing.sql').writeAsStringSync('WRONG');
        linkIn('share/extension/link.sql').createSync('missing.sql');
      });

      test(
        'when materializing, '
        'then the link is rejected instead of copying the unrelated root file.',
        () async {
          var result = await run();

          expect(result.exitCode, isNot(0));
          expect(result.stderr, contains('cannot materialize'));
          expect(linkIn('share/extension/link.sql').existsSync(), isTrue);
        },
      );
    },
  );

  group('Given a parent-relative target that escapes the stage,', () {
    late File outsideFile;

    setUp(() {
      outsideFile = File('${stage.path}_outside.sql')
        ..writeAsStringSync('OUTSIDE');
      var target = p.relative(
        outsideFile.path,
        from: p.join(stage.path, 'share', 'extension'),
      );
      linkIn('share/extension/link.sql').createSync(target);
    });

    tearDown(() {
      if (outsideFile.existsSync()) outsideFile.deleteSync();
    });

    test(
      'when materializing, '
      'then the run fails without copying the outside file.',
      () async {
        var result = await run();

        expect(result.exitCode, isNot(0));
        expect(result.stderr, contains('resolves outside the stage'));
        expect(linkIn('share/extension/link.sql').existsSync(), isTrue);
      },
    );
  });

  group('Given a symlink cycle,', () {
    setUp(() {
      linkIn('share/extension/a.sql').createSync('b.sql');
      linkIn('share/extension/b.sql').createSync('a.sql');
    });

    test(
      'when materializing, '
      'then the run fails citing the hop limit instead of looping forever.',
      () async {
        var result = await run();

        expect(result.exitCode, isNot(0));
        expect(result.stderr, contains('32 symlink hops'));
      },
    );
  });

  group('Given a link with an absolute target,', () {
    setUp(() {
      fileIn('share/extension/real.sql').writeAsStringSync('REAL');
      linkIn('share/extension/abs.sql').createSync(
        p.join(stage.path, 'share', 'extension', 'real.sql'),
      );
    });

    test(
      'when materializing, '
      'then the run fails even though the target exists inside the stage.',
      () async {
        var result = await run();

        expect(result.exitCode, isNot(0));
        expect(result.stderr, contains('absolute target'));
      },
    );
  });
}
