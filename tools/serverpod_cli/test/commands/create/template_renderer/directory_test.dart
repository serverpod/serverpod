import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/create/template_renderer.dart';
import 'package:test/test.dart';

void main() {
  late Directory testDir;
  late TemplateRenderer templateRenderer;

  setUp(() async {
    testDir = await Directory.systemTemp.createTemp('template_test_');
    templateRenderer = TemplateRenderer(dir: testDir);
  });

  tearDown(() async {
    await testDir.delete(recursive: true);
  });

  group(
    'Given a directory with valid conditional template directives in its name',
    () {
      late Directory dir;

      setUp(() async {
        dir = Directory(p.join(testDir.path, '{{#web}}web{{!web}}'));
        await dir.create();
      });

      test(
        'when rendering the template with a true context value, '
        'then the directory name is formatted to remove the template directives',
        () async {
          await templateRenderer.render(TemplateContext(web: true));

          await expectLater(
            Directory(p.join(testDir.path, '{{#web}}web{{!web}}')).exists(),
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
          await templateRenderer.render(TemplateContext(web: false));

          await expectLater(
            Directory(p.join(testDir.path, '{{#web}}web{{!web}}')).exists(),
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
          await templateRenderer.render(TemplateContext());

          await expectLater(
            Directory(p.join(testDir.path, '{{#web}}web{{!web}}')).exists(),
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
        dir = Directory(p.join(testDir.path, '{{#web}}web{{+web}}'));
        await dir.create();
      });

      test(
        'when rendering the template with a true context value, '
        'then the directory name is not formatted to remove the template directive',
        () async {
          await templateRenderer.render(TemplateContext(web: true));

          await expectLater(
            Directory(p.join(testDir.path, '{{#web}}web{{+web}}')).exists(),
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
          await templateRenderer.render(TemplateContext(web: false));

          await expectLater(
            Directory(p.join(testDir.path, '{{#web}}web{{+web}}')).exists(),
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
          await templateRenderer.render(TemplateContext(web: true));

          await expectLater(
            Directory(p.join(testDir.path, '{{#web}}web{{+web}}')).exists(),
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
      final webDir = Directory(p.join(testDir.path, '{{#web}}web{{!web}}'));
      await webDir.create();

      final redisDir = Directory(
        p.join(testDir.path, '{{#redis}}redis{{!redis}}'),
      );
      await redisDir.create();

      await templateRenderer.render(TemplateContext(redis: false, web: true));

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
            '{{#web}}web{{!web}}',
            '{{#postgres}}postgres{{!postgres}}',
            '{{#redis}}redis{{!redis}}',
          ),
        );
        await nestedDir.create(recursive: true);
      });

      test(
        'when rendering templates with true context values, '
        'then the nested directories are not deleted',
        () async {
          await templateRenderer.render(
            TemplateContext(postgres: true, web: true, redis: true),
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
          await templateRenderer.render(
            TemplateContext(web: false, redis: true, postgres: true),
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
          await templateRenderer.render(
            TemplateContext(redis: false, postgres: true, web: true),
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
