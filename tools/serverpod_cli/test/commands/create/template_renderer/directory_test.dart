import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/create/template_renderer.dart';
import 'package:test/test.dart';

/// The renderer renames ancestor dirs of the file paths it's given.
/// Tests that exercise dir renaming need at least one file inside the
/// dir to anchor that ancestor. [_sentinel] is the placeholder used.
const _sentinel = '.template_sentinel';

void main() {
  late Directory testDir;
  const renderer = TemplateRenderer();

  /// Renders every file currently under [testDir] - mirrors how the
  /// production caller passes the set of files just written by [Copier].
  Future<void> renderTestDir(TemplateContext context) async {
    final paths = <String>[];
    await for (final entity in testDir.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) paths.add(entity.path);
    }
    await renderer.renderPaths(paths, context);
  }

  Future<void> addSentinel(Directory dir) async {
    await File(p.join(dir.path, _sentinel)).create(recursive: true);
  }

  setUp(() async {
    testDir = await Directory.systemTemp.createTemp('template_test_');
  });

  tearDown(() async {
    await testDir.delete(recursive: true);
  });

  group(
    'Given a directory with valid conditional template directives in its name',
    () {
      late Directory dir;

      setUp(() async {
        dir = Directory(p.join(testDir.path, '{{#webapp}}web{{!webapp}}'));
        await dir.create();
        await addSentinel(dir);
      });

      test(
        'when rendering the template with a true context value, '
        'then the directory name is formatted to remove the template directives',
        () async {
          await renderTestDir(TemplateContext(webapp: true));

          await expectLater(
            Directory(
              p.join(testDir.path, '{{#webapp}}web{{!webapp}}'),
            ).exists(),
            completion(false),
          );
          await expectLater(
            Directory(p.join(testDir.path, 'web')).exists(),
            completion(true),
          );
        },
      );

      test(
        'when rendering the template with a false context value, '
        'then the directory is deleted',
        () async {
          await renderTestDir(TemplateContext(webapp: false));

          await expectLater(
            Directory(
              p.join(testDir.path, '{{#webapp}}web{{!webapp}}'),
            ).exists(),
            completion(false),
          );
          await expectLater(
            Directory(p.join(testDir.path, 'web')).exists(),
            completion(false),
          );
        },
      );

      test(
        'when rendering the template with empty context, '
        'then the directory is deleted',
        () async {
          await renderTestDir(TemplateContext());

          await expectLater(
            Directory(
              p.join(testDir.path, '{{#webapp}}web{{!webapp}}'),
            ).exists(),
            completion(false),
          );
          await expectLater(
            Directory(p.join(testDir.path, 'web')).exists(),
            completion(false),
          );
        },
      );
    },
  );

  group(
    'Given a directory with invalid template directives in its name',
    () {
      late Directory dir;

      setUp(() async {
        dir = Directory(p.join(testDir.path, '{{#webapp}}web{{+webapp}}'));
        await dir.create();
        await addSentinel(dir);
      });

      test(
        'when rendering the template with a true context value, '
        'then the directory name is not formatted to remove the template directive',
        () async {
          await renderTestDir(TemplateContext(webapp: true));

          await expectLater(
            Directory(
              p.join(testDir.path, '{{#webapp}}web{{+webapp}}'),
            ).exists(),
            completion(true),
          );
          await expectLater(
            Directory(p.join(testDir.path, 'web')).exists(),
            completion(false),
          );
        },
      );

      test(
        'when rendering the template with a false context value, '
        'then the directory name is not formatted to remove the template directive',
        () async {
          await renderTestDir(TemplateContext(webapp: false));

          await expectLater(
            Directory(
              p.join(testDir.path, '{{#webapp}}web{{+webapp}}'),
            ).exists(),
            completion(true),
          );
          await expectLater(
            Directory(p.join(testDir.path, 'web')).exists(),
            completion(false),
          );
        },
      );

      test(
        'when rendering the template with empty context, '
        'then the directory name is not formatted to remove the template directive',
        () async {
          await renderTestDir(TemplateContext(webapp: true));

          await expectLater(
            Directory(
              p.join(testDir.path, '{{#webapp}}web{{+webapp}}'),
            ).exists(),
            completion(true),
          );
          await expectLater(
            Directory(p.join(testDir.path, 'web')).exists(),
            completion(false),
          );
        },
      );
    },
  );

  test(
    'Given two directories with template directives in their names, '
    'when rendering templates with a mix of true and false context values, '
    'then the directory with false conditional directive is deleted',
    () async {
      final webDir = Directory(
        p.join(testDir.path, '{{#webapp}}web{{!webapp}}'),
      );
      await webDir.create();
      await addSentinel(webDir);

      final redisDir = Directory(
        p.join(testDir.path, '{{#redis}}redis{{!redis}}'),
      );
      await redisDir.create();
      await addSentinel(redisDir);

      await renderTestDir(TemplateContext(redis: false, webapp: true));

      await expectLater(
        Directory(p.join(testDir.path, 'web')).exists(),
        completion(true),
      );

      await expectLater(
        Directory(p.join(testDir.path, 'redis')).exists(),
        completion(false),
      );
    },
  );

  group(
    'Given nested directories with template directives in their names, ',
    () {
      late Directory nestedDir;

      setUp(() async {
        nestedDir = Directory(
          p.join(
            testDir.path,
            '{{#webapp}}web{{!webapp}}',
            '{{#postgres}}postgres{{!postgres}}',
            '{{#redis}}redis{{!redis}}',
          ),
        );
        await nestedDir.create(recursive: true);
        await addSentinel(nestedDir);
      });

      test(
        'when rendering templates with true context values, '
        'then the nested directories are not deleted',
        () async {
          await renderTestDir(
            TemplateContext(postgres: true, webapp: true, redis: true),
          );

          await expectLater(
            Directory(
              p.join(testDir.path, 'web', 'postgres', 'redis'),
            ).exists(),
            completion(true),
          );
        },
      );

      test(
        'when rendering templates with a false context value for the parent directory '
        'then the nested directories are deleted',
        () async {
          await renderTestDir(
            TemplateContext(webapp: false, redis: true, postgres: true),
          );

          await expectLater(
            Directory(
              p.join(testDir.path, 'web', 'postgres', 'redis'),
            ).exists(),
            completion(false),
          );
        },
      );

      test(
        'when rendering templates with a false context value for a nested directory, '
        'then only the nested directory is deleted',
        () async {
          await renderTestDir(
            TemplateContext(redis: false, postgres: true, webapp: true),
          );

          await expectLater(
            Directory(p.join(testDir.path, 'web', 'postgres')).exists(),
            completion(true),
          );

          await expectLater(
            Directory(
              p.join(testDir.path, 'web', 'postgres', 'redis'),
            ).exists(),
            completion(false),
          );
        },
      );
    },
  );
}
