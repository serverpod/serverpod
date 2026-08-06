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

  test(
    'Given a stage with a same-directory symlink chain, '
    'when materializing, '
    'then every link becomes a real copy of the chain end and none remain.',
    () async {
      fileIn('share/extension/real.sql').writeAsStringSync('REAL');
      linkIn('share/extension/hop.sql').createSync('real.sql');
      linkIn('share/extension/entry.sql').createSync('hop.sql');

      var result = await run();

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(fileIn('share/extension/entry.sql').readAsStringSync(), 'REAL');
      expect(fileIn('share/extension/hop.sql').readAsStringSync(), 'REAL');
      expect(stage.listSync(recursive: true).whereType<Link>(), isEmpty);
    },
  );

  test(
    'Given a stage with the mingw PostGIS form (a target written relative to the bundle root), '
    'when materializing, '
    'then the bundle-root interpretation resolves and the link becomes a real copy.',
    () async {
      fileIn('share/extension/upgrade.sql').writeAsStringSync('UPGRADE');
      linkIn('share/extension/alias.sql').createSync(
        './share/extension/upgrade.sql',
      );

      var result = await run();

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(
        fileIn('share/extension/alias.sql').readAsStringSync(),
        'UPGRADE',
      );
    },
  );

  test(
    'Given a dangling link that sorts before a valid link, '
    'when materializing, '
    'then the run fails naming the dangling link instead of skipping it.',
    () async {
      linkIn('share/extension/a-dangling.sql').createSync('missing.sql');
      fileIn('share/extension/real.sql').writeAsStringSync('REAL');
      linkIn('share/extension/z-valid.sql').createSync('real.sql');

      var result = await run();

      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('a-dangling.sql'));
      expect(result.stderr, contains('cannot materialize'));
    },
  );

  test(
    'Given a valid parent-relative target whose basename collides with an unrelated same-directory file, '
    'when materializing, '
    'then the actual target is copied rather than the colliding file.',
    () async {
      Directory(p.join(stage.path, 'share', 'other')).createSync();
      fileIn('share/other/data.sql').writeAsStringSync('RIGHT');
      fileIn('share/extension/data.sql').writeAsStringSync('WRONG');
      linkIn('share/extension/link.sql').createSync('../other/data.sql');

      var result = await run();

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(
        fileIn('share/extension/link.sql').readAsStringSync(),
        'RIGHT',
      );
    },
  );

  test(
    'Given a dangling same-directory target whose basename exists only at the bundle root, '
    'when materializing, '
    'then the link is rejected instead of copying the unrelated root file.',
    () async {
      fileIn('missing.sql').writeAsStringSync('WRONG');
      linkIn('share/extension/link.sql').createSync('missing.sql');

      var result = await run();

      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('cannot materialize'));
      expect(linkIn('share/extension/link.sql').existsSync(), isTrue);
    },
  );

  test(
    'Given a parent-relative target that escapes the stage, '
    'when materializing, '
    'then the run fails without copying the outside file.',
    () async {
      var outsideFile = File('${stage.path}_outside.sql')
        ..writeAsStringSync('OUTSIDE');
      addTearDown(() {
        if (outsideFile.existsSync()) outsideFile.deleteSync();
      });
      var target = p.relative(
        outsideFile.path,
        from: p.join(stage.path, 'share', 'extension'),
      );
      linkIn('share/extension/link.sql').createSync(target);

      var result = await run();

      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('resolves outside the stage'));
      expect(linkIn('share/extension/link.sql').existsSync(), isTrue);
    },
  );

  test(
    'Given a symlink cycle, '
    'when materializing, '
    'then the run fails citing the hop limit instead of looping forever.',
    () async {
      linkIn('share/extension/a.sql').createSync('b.sql');
      linkIn('share/extension/b.sql').createSync('a.sql');

      var result = await run();

      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('32 symlink hops'));
    },
  );

  test(
    'Given a link with an absolute target, '
    'when materializing, '
    'then the run fails even though the target exists inside the stage.',
    () async {
      fileIn('share/extension/real.sql').writeAsStringSync('REAL');
      linkIn('share/extension/abs.sql').createSync(
        p.join(stage.path, 'share', 'extension', 'real.sql'),
      );

      var result = await run();

      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('absolute target'));
    },
  );
}
