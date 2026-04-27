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
    'Given a file with valid conditional template directives in its name',
    () {
      late File file;
      setUp(() async {
        file = File(p.join(testDir.path, '{{#web}}web{{!web}}.dart'));
        await file.writeAsString('''import 'dart.io';''');
      });

      test(
        'when rendering the template with a true context value, '
        'then the file name is formatted to remove the template directives',
        () async {
          await templateRenderer.render(TemplateContext(web: true));

          await expectLater(file.exists(), completion(false));
          await expectLater(
            File(p.join(testDir.path, 'web.dart')).exists(),
            completion(true),
          );
        },
      );

      test(
        'when rendering the template with a false context value, '
        'then the file is deleted',
        () async {
          await templateRenderer.render(TemplateContext(web: false));

          await expectLater(file.exists(), completion(false));
          await expectLater(
            File(p.join(testDir.path, 'web.dart')).exists(),
            completion(false),
          );
        },
      );

      test(
        'when rendering the template with empty context, '
        'then the file is deleted',
        () async {
          await templateRenderer.render(TemplateContext());

          await expectLater(file.exists(), completion(false));
          await expectLater(
            File(p.join(testDir.path, 'web.dart')).exists(),
            completion(false),
          );
        },
      );
    },
  );

  group(
    'Given a file with invalid conditional template directives in its name',
    () {
      late File file;
      setUp(() async {
        file = File(p.join(testDir.path, '{{#web}}web{{+web}}.dart'));
        await file.writeAsString('''import 'dart.io';''');
      });

      test(
        'when rendering the template with a true context value, '
        'then the file name is not formatted to remove the template directives',
        () async {
          await templateRenderer.render(TemplateContext(web: true));

          await expectLater(file.exists(), completion(true));
          await expectLater(
            File(p.join(testDir.path, 'web.dart')).exists(),
            completion(false),
          );
        },
      );

      test(
        'when rendering the template with a false context value, '
        'then the file name is not formatted to remove the template directives',
        () async {
          await templateRenderer.render(TemplateContext(web: false));

          await expectLater(file.exists(), completion(true));
          await expectLater(
            File(p.join(testDir.path, 'web.dart')).exists(),
            completion(false),
          );
        },
      );

      test(
        'when rendering the template with empty context, '
        'then the file name is not formatted to remove the template directives',
        () async {
          await templateRenderer.render(TemplateContext());

          await expectLater(file.exists(), completion(true));
          await expectLater(
            File(p.join(testDir.path, 'web.dart')).exists(),
            completion(false),
          );
        },
      );
    },
  );

  group(
    'Given a YAML file with template directives in its content, ',
    () {
      late File file;

      setUp(() async {
        file = File(p.join(testDir.path, 'config.yaml'));
        await file.writeAsString('''
development:
  # {{#redis}}
  redis: 'REDIS_PASSWORD'
  # {{/redis}}
  database: 'DB_PASSWORD'
''');
      });

      test(
        'when rendering the template with a true context value, '
        'then the template directives are processed correctly',
        () async {
          await templateRenderer.render(TemplateContext(redis: true));
          final content = await file.readAsString();

          expect(
            content,
            matches(
              r'development:\n'
              r"  redis: \'REDIS_PASSWORD\'\n"
              r"  database: \'DB_PASSWORD\'\n",
            ),
          );
        },
      );

      test(
        'when rendering the template with a false context value, '
        'then the template directives are processed correctly',
        () async {
          await templateRenderer.render(TemplateContext(redis: false));
          final content = await file.readAsString();

          expect(
            content,
            matches(
              r'development:\n'
              r"  database: \'DB_PASSWORD\'\n",
            ),
          );
        },
      );
    },
  );

  group(
    'Given a dart file with template directives in its content',
    () {
      late File file;

      setUp(() async {
        file = File(p.join(testDir.path, 'test.dart'));
        await file.writeAsString('''
import 'dart:io';
// {{#postgres}}
import 'postgres.dart';
// {{/postgres}}
// {{#web}}
import 'web.dart';
// {{/web}}

void main() {
  // {{#postgres}}
  print('postgres enabled');
  // {{/postgres}}
  // {{#web}}
  print('web enabled');
  // {{/web}}
}
''');
      });

      test(
        'when rendering the template with true context values, '
        'then all the sections with conditional directives are retained in the file',
        () async {
          await templateRenderer.render(
            TemplateContext(web: true, postgres: true),
          );
          final content = await file.readAsString();
          expect(
            content,
            matches(
              r"import \'dart:io\';\n"
              r"import \'postgres.dart\';\n"
              r"import \'web.dart\';\n"
              r'\n'
              r'void main\(\) \{\n'
              r"  print\(\'postgres enabled\'\);\n"
              r"  print\(\'web enabled\'\);\n"
              r'\}\n',
            ),
          );
        },
      );

      test(
        'when rendering the template with a mix of true and false context values, '
        'then only the sections with true conditional directives are retained in the file',
        () async {
          await templateRenderer.render(
            TemplateContext(postgres: true, web: false),
          );
          final content = await file.readAsString();
          expect(
            content,
            matches(
              r"import \'dart:io\';\n"
              r"import \'postgres.dart\';\n"
              r'\n'
              r'void main\(\) \{\n'
              r"  print\(\'postgres enabled\'\);\n"
              r'\}\n',
            ),
          );
        },
      );

      test(
        'when rendering the template with empty context, '
        'then all conditional sections are removed from the file',
        () async {
          await templateRenderer.render(TemplateContext());
          final content = await file.readAsString();
          expect(
            content,
            matches(
              r"import \'dart:io\';\n"
              r'\n'
              r'void main\(\) \{\}\n',
            ),
          );
        },
      );
    },
  );

  test(
    'Given a dart file with template directives in its content'
    'when rendering the template, '
    'then the file is formatted',
    () async {
      final file = File(p.join(testDir.path, 'test.dart'));
      await file.writeAsString('''
import 'dart:io';


// {{#postgres}}
import 'postgres.dart';
// {{/postgres}}
// {{#web}}
import 'web.dart';
// {{/web}}

void main() {
  // {{#postgres}}
  print('postgres enabled');
  // {{/postgres}}


  // {{#web}}
  print('web enabled');
  // {{/web}}
}
''');

      await templateRenderer.render(TemplateContext());
      final content = await file.readAsString();
      expect(
        content,
        matches(
          r"import \'dart:io\';\n"
          r'\n'
          r'void main\(\) \{\}\n',
        ),
      );
    },
  );

  test(
    'Given a file with all its contents enclosed in conditional directives'
    'when rendering the template with empty context, '
    'then the file is deleted',
    () async {
      final file = File(p.join(testDir.path, 'only_conditionals.dart'));
      await file.writeAsString('''
// {{#sqlite}}
import 'sqlite.dart';
// {{/sqlite}}
// {{#web}}
import 'auth.web';
// {{/web}}
''');

      await templateRenderer.render(TemplateContext());
      await expectLater(file.exists(), completion(false));
    },
  );
}
