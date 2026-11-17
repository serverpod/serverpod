import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:test/test.dart';

class _ResourceManager extends ResourceManager {
  final Directory cache;

  _ResourceManager(this.cache, {super.useLocalTemplates = false});

  @override
  Directory get localStorageDirectory => cache;

  @override
  Directory get templateDirectory =>
      Directory(p.join(versionedDir.path, 'serverpod_template'));
}

List<int> _archive(Map<String, String> files) {
  final archive = Archive();
  for (final entry in files.entries) {
    final content = utf8.encode(entry.value);
    archive.addFile(ArchiveFile(entry.key, content.length, content));
  }
  return const GZipEncoder().encode(TarEncoder().encode(archive));
}

Future<void> _install(
  ResourceManager manager,
  Map<String, String> files, {
  int statusCode = 200,
}) => http.runWithClient(
  manager.installTemplates,
  () => MockClient(
    (_) async => http.Response.bytes(_archive(files), statusCode),
  ),
);

void main() {
  late Directory cache;
  late _ResourceManager manager;
  const templates = {
    'pubspec.yaml': 'name: serverpod_templates',
    'projectname_server/bin/main.dart': 'void main() {}',
  };
  const brokenTemplates = {
    ...templates,
    'conflict': 'This file prevents creating the next directory.',
    'conflict/child.txt': 'Cannot be extracted.',
  };

  setUp(() {
    cache = Directory.systemTemp.createTempSync('serverpod_templates_test_');
    manager = _ResourceManager(cache);
  });

  tearDown(() => cache.deleteSync(recursive: true));

  test('an empty cache directory is not an installed template package', () {
    manager.templateDirectory.createSync(recursive: true);

    expect(manager.isTemplatesInstalled, isFalse);
  });

  test('a partially extracted legacy cache is downloaded again', () async {
    File(p.join(manager.templateDirectory.path, 'pubspec.yaml'))
      ..createSync(recursive: true)
      ..writeAsStringSync(templates['pubspec.yaml']!);

    expect(manager.isTemplatesInstalled, isFalse);

    await _install(manager, templates);

    expect(manager.isTemplatesInstalled, isTrue);
    expect(
      File(
        p.join(
          manager.templateDirectory.path,
          'projectname_server/bin/main.dart',
        ),
      ).readAsStringSync(),
      templates['projectname_server/bin/main.dart'],
    );
  });

  test(
    'failed extraction can be retried without using partial files',
    () async {
      await expectLater(
        _install(manager, brokenTemplates),
        throwsA(isA<FileSystemException>()),
      );
      expect(manager.isTemplatesInstalled, isFalse);
      expect(manager.templateDirectory.existsSync(), isFalse);

      await _install(manager, templates);

      expect(manager.isTemplatesInstalled, isTrue);
      expect(
        File(
          p.join(
            manager.templateDirectory.path,
            'projectname_server/bin/main.dart',
          ),
        ).readAsStringSync(),
        templates['projectname_server/bin/main.dart'],
      );
      expect(manager.versionedDir.listSync(), hasLength(1));
    },
  );

  test('failed replacement preserves an installed template package', () async {
    await _install(manager, templates);

    await expectLater(
      _install(manager, brokenTemplates),
      throwsA(isA<FileSystemException>()),
    );

    expect(manager.isTemplatesInstalled, isTrue);
    expect(
      File(p.join(manager.templateDirectory.path, 'conflict')).existsSync(),
      isFalse,
    );
    expect(manager.versionedDir.listSync(), hasLength(1));
  });

  test('an unsuccessful HTTP response is not installed', () async {
    await expectLater(
      _install(manager, templates, statusCode: 503),
      throwsA(isA<HttpException>()),
    );

    expect(manager.isTemplatesInstalled, isFalse);
  });

  test('an archive without a package manifest is not installed', () async {
    await expectLater(
      _install(manager, {'README.md': 'Not a template package.'}),
      throwsA(isA<FormatException>()),
    );

    expect(manager.isTemplatesInstalled, isFalse);
  });

  test(
    'deleting the template files invalidates a completed installation',
    () async {
      await _install(manager, templates);
      await File(
        p.join(manager.templateDirectory.path, 'pubspec.yaml'),
      ).delete();

      expect(manager.isTemplatesInstalled, isFalse);

      await _install(manager, templates);

      expect(manager.isTemplatesInstalled, isTrue);
    },
  );

  test('local source templates do not require a download marker', () {
    final localManager = _ResourceManager(cache, useLocalTemplates: true);
    File(p.join(localManager.templateDirectory.path, 'pubspec.yaml'))
      ..createSync(recursive: true)
      ..writeAsStringSync(templates['pubspec.yaml']!);

    expect(localManager.isTemplatesInstalled, isTrue);
  });
}
