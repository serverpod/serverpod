import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Templates', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('templates_test_');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test(
      'Given missing templates folder when loading templates then no templates are loaded',
      () async {
        var uniqueUuid = const Uuid().v4();
        var nonExistingDirectory = Directory(
          path.joinAll([uniqueUuid, 'non-existing-directory']),
        );

        await templates.loadAll(nonExistingDirectory);

        expect(templates, isEmpty);
      },
    );

    test(
      'Given flat template structure when loading templates then all templates are loaded',
      () async {
        // Create flat template structure
        var template1 = File(path.join(tempDir.path, 'template1.html'));
        template1.writeAsStringSync('<h1>Template 1</h1>');

        var template2 = File(path.join(tempDir.path, 'template2.html'));
        template2.writeAsStringSync('<h1>Template 2</h1>');

        await templates.loadAll(tempDir);

        expect(templates['template1'], isNotNull);
        expect(templates['template2'], isNotNull);
        expect(
          templates['template1']!.renderString({}),
          equals('<h1>Template 1</h1>'),
        );
        expect(
          templates['template2']!.renderString({}),
          equals('<h1>Template 2</h1>'),
        );
      },
    );

    test(
      'Given nested template structure when loading templates then nested paths are preserved',
      () async {
        // Create nested template structure
        var adminDir = Directory(path.join(tempDir.path, 'admin'));
        adminDir.createSync();

        var dashboardTemplate = File(
          path.join(adminDir.path, 'dashboard.html'),
        );
        dashboardTemplate.writeAsStringSync('<h1>Admin Dashboard</h1>');

        var userDir = Directory(path.join(adminDir.path, 'user'));
        userDir.createSync();

        var userFormTemplate = File(path.join(userDir.path, 'form.html'));
        userFormTemplate.writeAsStringSync('<h1>User Form</h1>');

        await templates.loadAll(tempDir);

        expect(templates['admin/dashboard'], isNotNull);
        expect(templates['admin/user/form'], isNotNull);
        expect(
          templates['admin/dashboard']!.renderString({}),
          equals('<h1>Admin Dashboard</h1>'),
        );
        expect(
          templates['admin/user/form']!.renderString({}),
          equals('<h1>User Form</h1>'),
        );
      },
    );

    test(
      'Given mixed flat and nested structure when loading templates then all templates are accessible',
      () async {
        // Create flat template
        var baseTemplate = File(path.join(tempDir.path, 'base.html'));
        baseTemplate.writeAsStringSync('<html><body>{{content}}</body></html>');

        // Create nested template
        var adminDir = Directory(path.join(tempDir.path, 'admin'));
        adminDir.createSync();

        var adminTemplate = File(path.join(adminDir.path, 'page.html'));
        adminTemplate.writeAsStringSync('<h1>Admin Page</h1>');

        await templates.loadAll(tempDir);

        expect(templates['base'], isNotNull);
        expect(templates['admin/page'], isNotNull);
        expect(
          templates['base']!.renderString({'content': 'Hello'}),
          equals('<html><body>Hello</body></html>'),
        );
        expect(
          templates['admin/page']!.renderString({}),
          equals('<h1>Admin Page</h1>'),
        );
      },
    );

    test(
      'Given deeply nested structure when loading templates then full nested path key is preserved',
      () async {
        // Create deeply nested structure: admin/users/management/forms/edit.html
        var adminDir = Directory(path.join(tempDir.path, 'admin'));
        adminDir.createSync();

        var usersDir = Directory(path.join(adminDir.path, 'users'));
        usersDir.createSync();

        var managementDir = Directory(path.join(usersDir.path, 'management'));
        managementDir.createSync();

        var formsDir = Directory(path.join(managementDir.path, 'forms'));
        formsDir.createSync();

        var editTemplate = File(path.join(formsDir.path, 'edit.html'));
        editTemplate.writeAsStringSync('<h1>Edit User</h1>');

        await templates.loadAll(tempDir);

        expect(templates['admin/users/management/forms/edit'], isNotNull);
        expect(
          templates['admin/users/management/forms/edit']!.renderString({}),
          equals('<h1>Edit User</h1>'),
        );
      },
    );

    test(
      'Given non-html files in directories when loading templates then only html files are loaded',
      () async {
        // Create directory with mixed file types
        var adminDir = Directory(path.join(tempDir.path, 'admin'));
        adminDir.createSync();

        var htmlTemplate = File(path.join(adminDir.path, 'page.html'));
        htmlTemplate.writeAsStringSync('<h1>HTML Page</h1>');

        var cssFile = File(path.join(adminDir.path, 'style.css'));
        cssFile.writeAsStringSync('body { color: red; }');

        var jsFile = File(path.join(adminDir.path, 'script.js'));
        jsFile.writeAsStringSync('console.log("Hello");');

        await templates.loadAll(tempDir);

        expect(templates['admin/page'], isNotNull);
        expect(templates['admin/style'], isNull);
        expect(templates['admin/script'], isNull);
        expect(
          templates['admin/page']!.renderString({}),
          equals('<h1>HTML Page</h1>'),
        );
      },
    );
  });
}
