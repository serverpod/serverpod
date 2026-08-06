import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/create/template_renderer.dart';
import 'package:test/test.dart';

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

  setUp(() async {
    testDir = await Directory.systemTemp.createTemp('template_test_');
  });

  tearDown(() async {
    await testDir.delete(recursive: true);
  });

  group(
    'Given a file with valid conditional template directives in its name',
    () {
      late File file;
      setUp(() async {
        file = File(p.join(testDir.path, '{{#webapp}}web{{!webapp}}.dart'));
        await file.writeAsString('''import 'dart.io';''');
      });

      test(
        'when rendering the template with a true context value, '
        'then the file name is formatted to remove the template directives',
        () async {
          await renderTestDir(TemplateContext(webapp: true));

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
          await renderTestDir(TemplateContext(webapp: false));

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
          await renderTestDir(TemplateContext());

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
        file = File(p.join(testDir.path, '{{#webapp}}web{{+webapp}}.dart'));
        await file.writeAsString('''import 'dart.io';''');
      });

      test(
        'when rendering the template with a true context value, '
        'then the file name is not formatted to remove the template directives',
        () async {
          await renderTestDir(TemplateContext(webapp: true));

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
          await renderTestDir(TemplateContext(webapp: false));

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
          await renderTestDir(TemplateContext());

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
          await renderTestDir(TemplateContext(redis: true));
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
          await renderTestDir(TemplateContext(redis: false));
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
// {{#website}}
import 'web.dart';
// {{/website}}

void main() {
  // {{#postgres}}
  print('postgres enabled');
  // {{/postgres}}
  // {{#website}}
  print('web enabled');
  // {{/website}}
}
''');
      });

      test(
        'when rendering the template with true context values, '
        'then all the sections with conditional directives are retained in the file',
        () async {
          await renderTestDir(TemplateContext(website: true, postgres: true));
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
          await renderTestDir(TemplateContext(postgres: true, website: false));
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
          await renderTestDir(TemplateContext());
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

      await renderTestDir(TemplateContext());
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

      await renderTestDir(TemplateContext());
      await expectLater(file.exists(), completion(false));
    },
  );

  group(
    'Given a HTML file with template directives in its content',
    () {
      late File file;

      setUp(() async {
        file = File(p.join(testDir.path, 'test.html'));
        await file.writeAsString('''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Built with Serverpod</title>
    <link rel="stylesheet" href="/web/css/style.css">
  </head>
  <body>
    <!-- {{#webapp}} -->
      <div>
        <a class="cta" href="/app">
            Open Flutter app 
          </a>
      </div>
    <!-- {{/webapp}} -->
    <!-- {{#website}} -->
      <div>
        <a class="cta" href="/">
            Open Website 
          </a>
      </div>
    <!-- {{/website}} -->
  </body>
</html>
''');
      });

      test(
        'when rendering the template with true context values, '
        'then all the sections with conditional directives are retained in the file',
        () async {
          await renderTestDir(TemplateContext(website: true, webapp: true));
          final content = await file.readAsString();
          expect(
            content,
            matches(
              r'<!DOCTYPE html>\n'
              r'<html lang="en">\n'
              r'  <head>\n'
              r'    <meta charset="utf-8">\n'
              r'    <title>Built with Serverpod</title>\n'
              r'    <link rel="stylesheet" href="/web/css/style.css">\n'
              r'  </head>\n'
              r'  <body>\n'
              r'      <div>\n'
              r'        <a class="cta" href="/app">\n'
              r'            Open Flutter app \n'
              r'          </a>\n'
              r'      </div>\n'
              r'      <div>\n'
              r'        <a class="cta" href="/">\n'
              r'            Open Website \n'
              r'          </a>\n'
              r'      </div>\n'
              r'  </body>\n'
              r'</html>\n',
            ),
          );
        },
      );

      test(
        'when rendering the template with a mix of true and false context values, '
        'then only the sections with true conditional directives are retained in the file',
        () async {
          await renderTestDir(TemplateContext(website: true, webapp: false));
          final content = await file.readAsString();
          expect(
            content,
            matches(
              r'<!DOCTYPE html>\n'
              r'<html lang="en">\n'
              r'  <head>\n'
              r'    <meta charset="utf-8">\n'
              r'    <title>Built with Serverpod</title>\n'
              r'    <link rel="stylesheet" href="/web/css/style.css">\n'
              r'  </head>\n'
              r'  <body>\n'
              r'      <div>\n'
              r'        <a class="cta" href="/">\n'
              r'            Open Website \n'
              r'          </a>\n'
              r'      </div>\n'
              r'  </body>\n'
              r'</html>\n',
            ),
          );
        },
      );

      test(
        'when rendering the template with empty context, '
        'then all conditional sections are removed from the file',
        () async {
          await renderTestDir(TemplateContext());
          final content = await file.readAsString();
          expect(
            content,
            matches(
              r'<!DOCTYPE html>\n'
              r'<html lang="en">\n'
              r'  <head>\n'
              r'    <meta charset="utf-8">\n'
              r'    <title>Built with Serverpod</title>\n'
              r'    <link rel="stylesheet" href="/web/css/style.css">\n'
              r'  </head>\n'
              r'  <body>\n'
              r'  </body>\n'
              r'</html>\n',
            ),
          );
        },
      );
    },
  );
}
