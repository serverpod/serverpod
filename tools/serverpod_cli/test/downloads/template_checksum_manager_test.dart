import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/downloads/template_checksum_manager.dart';
import 'package:test/test.dart';

void main() {
  group('TemplateChecksumManager', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('test_checksum_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    group('Given template directories with matching checksums', () {
      test('then verification returns true', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        // Create template directories with files
        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt')).writeAsStringSync('server');
        File(p.join(serverDir.path, 'main.dart')).writeAsStringSync('main');

        var clientDir =
            Directory(p.join(templateDir.path, 'projectname_client'));
        clientDir.createSync(recursive: true);
        File(p.join(clientDir.path, 'file.txt')).writeAsStringSync('client');

        var flutterDir =
            Directory(p.join(templateDir.path, 'projectname_flutter'));
        flutterDir.createSync(recursive: true);
        File(p.join(flutterDir.path, 'file.txt')).writeAsStringSync('flutter');

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  mini:
    - projectname_server
    - projectname_client
    - projectname_flutter
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        // Create YAML checksums file with correct checksums
        var checksumsYaml = '''
projectname_server:
  file.txt: cf1e8c14e54505f60aa10ceb8d5d8ab3
  main.dart: fad58de7366495db4650cfefac2fcd61

projectname_client:
  file.txt: 62608e08adc29a8d6dbc9754e659f125

projectname_flutter:
  file.txt: 5acebc4cb70ddbb074b0ac76aab176ae
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'mini',
        );

        expect(result, isTrue);
      });
    });

    group('Given template directories with mismatched checksums', () {
      test('then verification returns false', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt')).writeAsStringSync('content');

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  mini:
    - projectname_server
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        // Create YAML with incorrect checksum
        var checksumsYaml = '''
projectname_server:
  file.txt: incorrect_checksum
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'mini',
        );

        expect(result, isFalse);
      });
    });

    group('Given template directory without template_checksums.yaml', () {
      test('then verification returns true', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'mini',
        );

        expect(result, isTrue);
      });
    });

    group('Given missing template directory', () {
      test('then verification returns false', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  mini:
    - projectname_server
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        // Create YAML requiring projectname_server but don't create the directory
        var checksumsYaml = '''
projectname_server:
  file.txt: cf1e8c14e54505f60aa10ceb8d5d8ab3
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'mini',
        );

        expect(result, isFalse);
      });
    });

    group('Given missing file in template', () {
      test('then verification returns false', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        // Don't create the file that's listed in checksums

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  mini:
    - projectname_server
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        var checksumsYaml = '''
projectname_server:
  missing_file.txt: cf1e8c14e54505f60aa10ceb8d5d8ab3
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'mini',
        );

        expect(result, isFalse);
      });
    });

    group('Given valid checksums when verifying with retry', () {
      test('then succeeds without redownload', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        // For mini template, we need all three directories
        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt')).writeAsStringSync('server');

        var clientDir =
            Directory(p.join(templateDir.path, 'projectname_client'));
        clientDir.createSync(recursive: true);
        File(p.join(clientDir.path, 'file.txt')).writeAsStringSync('client');

        var flutterDir =
            Directory(p.join(templateDir.path, 'projectname_flutter'));
        flutterDir.createSync(recursive: true);
        File(p.join(flutterDir.path, 'file.txt')).writeAsStringSync('flutter');

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  mini:
    - projectname_server
    - projectname_client
    - projectname_flutter
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        var checksumsYaml = '''
projectname_server:
  file.txt: cf1e8c14e54505f60aa10ceb8d5d8ab3
projectname_client:
  file.txt: 62608e08adc29a8d6dbc9754e659f125
projectname_flutter:
  file.txt: 5acebc4cb70ddbb074b0ac76aab176ae
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var downloadCount = 0;

        var result = await TemplateChecksumManager.verifyWithRetry(
          templateDir,
          templateType: 'mini',
          redownloadCallback: () async {
            downloadCount++;
          },
        );

        expect(result, isTrue);
        expect(downloadCount, equals(0),
            reason: 'Should not redownload when checksums match');
      });
    });

    group(
        'Given corrupted templates when verifying with retry and redownloading fixes the issue',
        () {
      test('then succeeds after one retry', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        // Create all directories but with wrong content in one
        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt'))
            .writeAsStringSync('wrong_content');

        var clientDir =
            Directory(p.join(templateDir.path, 'projectname_client'));
        clientDir.createSync(recursive: true);
        File(p.join(clientDir.path, 'file.txt')).writeAsStringSync('client');

        var flutterDir =
            Directory(p.join(templateDir.path, 'projectname_flutter'));
        flutterDir.createSync(recursive: true);
        File(p.join(flutterDir.path, 'file.txt')).writeAsStringSync('flutter');

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  mini:
    - projectname_server
    - projectname_client
    - projectname_flutter
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        var correctContent = 'correct_content';
        var checksumsYaml = '''
projectname_server:
  file.txt: 8d834aa8af95c3d4d6b416652529b937
projectname_client:
  file.txt: 62608e08adc29a8d6dbc9754e659f125
projectname_flutter:
  file.txt: 5acebc4cb70ddbb074b0ac76aab176ae
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var downloadCount = 0;

        var result = await TemplateChecksumManager.verifyWithRetry(
          templateDir,
          templateType: 'mini',
          redownloadCallback: () async {
            downloadCount++;
            // Simulate successful redownload by fixing the content
            if (downloadCount == 1) {
              // Recreate with correct content
              templateDir.createSync(recursive: true);

              serverDir.createSync(recursive: true);
              File(p.join(serverDir.path, 'file.txt'))
                  .writeAsStringSync(correctContent);

              clientDir.createSync(recursive: true);
              File(p.join(clientDir.path, 'file.txt'))
                  .writeAsStringSync('client');

              flutterDir.createSync(recursive: true);
              File(p.join(flutterDir.path, 'file.txt'))
                  .writeAsStringSync('flutter');

              File(p.join(templateDir.path, 'template_files.yaml'))
                  .writeAsStringSync(filesManifestYaml);
              File(p.join(templateDir.path, 'template_checksums.yaml'))
                  .writeAsStringSync(checksumsYaml);
            }
          },
        );

        expect(result, isTrue);
        expect(downloadCount, equals(1),
            reason: 'Should redownload once when initial verification fails');
      });
    });

    group(
        'Given persistently corrupted templates when verifying with retry and redownload always fails',
        () {
      test('then fails after max retry attempts', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  mini:
    - projectname_server
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        var checksumsYaml = '''
projectname_server:
  file.txt: will_never_match
''';

        // Create initial checksums.yaml with wrong checksum
        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        // Create initial directory with content
        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt'))
            .writeAsStringSync('initial_wrong');

        var downloadCount = 0;

        var result = await TemplateChecksumManager.verifyWithRetry(
          templateDir,
          templateType: 'mini',
          redownloadCallback: () async {
            downloadCount++;
            // Always recreate with wrong content
            templateDir.createSync(recursive: true);
            var serverDir =
                Directory(p.join(templateDir.path, 'projectname_server'));
            serverDir.createSync(recursive: true);
            File(p.join(serverDir.path, 'file.txt'))
                .writeAsStringSync('always_wrong');
            File(p.join(templateDir.path, 'template_files.yaml'))
                .writeAsStringSync(filesManifestYaml);
            File(p.join(templateDir.path, 'template_checksums.yaml'))
                .writeAsStringSync(checksumsYaml);
          },
        );

        expect(result, isFalse);
        expect(downloadCount,
            equals(TemplateChecksumManager.maxRetryAttempts - 1));
      });
    });

    group('Given server template type', () {
      test('then verifies all required directories', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        // Create all required directories for server template
        var dirs = [
          'projectname_server',
          'projectname_server_upgrade',
          'projectname_client',
          'projectname_flutter',
          'github'
        ];

        for (var dirName in dirs) {
          var dir = Directory(p.join(templateDir.path, dirName));
          dir.createSync(recursive: true);
          File(p.join(dir.path, 'file.txt')).writeAsStringSync('content');
        }

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  server:
    - projectname_server
    - projectname_server_upgrade
    - projectname_client
    - projectname_flutter
    - github
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        var checksumsYaml = '''
projectname_server:
  file.txt: 9a0364b9e99bb480dd25e1f0284c8555
projectname_server_upgrade:
  file.txt: 9a0364b9e99bb480dd25e1f0284c8555
projectname_client:
  file.txt: 9a0364b9e99bb480dd25e1f0284c8555
projectname_flutter:
  file.txt: 9a0364b9e99bb480dd25e1f0284c8555
github:
  file.txt: 9a0364b9e99bb480dd25e1f0284c8555
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'server',
        );

        expect(result, isTrue);
      });
    });

    group('Given module template type', () {
      test('then verifies only module directories', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        // Create module directories
        var serverDir =
            Directory(p.join(templateDir.path, 'modulename_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt')).writeAsStringSync('server');

        var clientDir =
            Directory(p.join(templateDir.path, 'modulename_client'));
        clientDir.createSync(recursive: true);
        File(p.join(clientDir.path, 'file.txt')).writeAsStringSync('client');

        // Create template files manifest
        var filesManifestYaml = '''
template_types:
  module:
    - modulename_server
    - modulename_client
''';
        File(p.join(templateDir.path, 'template_files.yaml'))
            .writeAsStringSync(filesManifestYaml);

        var checksumsYaml = '''
modulename_server:
  file.txt: cf1e8c14e54505f60aa10ceb8d5d8ab3
modulename_client:
  file.txt: 62608e08adc29a8d6dbc9754e659f125
''';

        File(p.join(templateDir.path, 'template_checksums.yaml'))
            .writeAsStringSync(checksumsYaml);

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'module',
        );

        expect(result, isTrue);
      });
    });
  });
}
