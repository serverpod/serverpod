import 'dart:convert';
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

    group('Given a directory with files and subdirectories', () {
      test('then the checksum is consistent when calculated multiple times',
          () async {
        var testDir = Directory(p.join(tempDir.path, 'test_template'));
        testDir.createSync(recursive: true);
        File(p.join(testDir.path, 'file1.txt')).writeAsStringSync('content1');
        File(p.join(testDir.path, 'file2.txt')).writeAsStringSync('content2');
        Directory(p.join(testDir.path, 'subdir')).createSync();
        File(p.join(testDir.path, 'subdir', 'file3.txt'))
            .writeAsStringSync('content3');

        var checksum1 =
            await TemplateChecksumManager.calculateDirectoryChecksum(testDir);
        var checksum2 =
            await TemplateChecksumManager.calculateDirectoryChecksum(testDir);

        expect(checksum1, equals(checksum2));
        expect(checksum1, isNotEmpty);
      });
    });

    group('Given two directories with different content', () {
      test('then the checksums are different', () async {
        var testDir1 = Directory(p.join(tempDir.path, 'test_template1'));
        testDir1.createSync(recursive: true);
        File(p.join(testDir1.path, 'file.txt')).writeAsStringSync('content1');

        var testDir2 = Directory(p.join(tempDir.path, 'test_template2'));
        testDir2.createSync(recursive: true);
        File(p.join(testDir2.path, 'file.txt')).writeAsStringSync('content2');

        var checksum1 =
            await TemplateChecksumManager.calculateDirectoryChecksum(testDir1);
        var checksum2 =
            await TemplateChecksumManager.calculateDirectoryChecksum(testDir2);

        expect(checksum1, isNot(equals(checksum2)));
      });
    });

    group('Given a directory with content when adding checksums.json file', () {
      test('then the checksum remains unchanged', () async {
        var testDir = Directory(p.join(tempDir.path, 'test_template'));
        testDir.createSync(recursive: true);
        File(p.join(testDir.path, 'file.txt')).writeAsStringSync('content');

        var checksumBefore =
            await TemplateChecksumManager.calculateDirectoryChecksum(testDir);

        File(p.join(testDir.path, 'checksums.json'))
            .writeAsStringSync('{"test": "value"}');

        var checksumAfter =
            await TemplateChecksumManager.calculateDirectoryChecksum(testDir);

        expect(checksumBefore, equals(checksumAfter));
      });
    });

    group('Given template directories with matching checksums', () {
      test('then verification returns true', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

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

        var serverChecksum =
            await TemplateChecksumManager.calculateDirectoryChecksum(serverDir);
        var clientChecksum =
            await TemplateChecksumManager.calculateDirectoryChecksum(clientDir);
        var flutterChecksum =
            await TemplateChecksumManager.calculateDirectoryChecksum(
                flutterDir);

        var checksums = {
          'directories': {
            'projectname_server': serverChecksum,
            'projectname_client': clientChecksum,
            'projectname_flutter': flutterChecksum,
          },
          'templates': {
            'mini': 'dummy', // Not used in basic verification
          },
        };

        File(p.join(templateDir.path, 'checksums.json'))
            .writeAsStringSync(jsonEncode(checksums));

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

        var checksums = {
          'directories': {
            'projectname_server': 'incorrect_checksum',
          },
          'templates': {
            'mini': 'dummy',
          },
        };

        File(p.join(templateDir.path, 'checksums.json'))
            .writeAsStringSync(jsonEncode(checksums));

        var result = await TemplateChecksumManager.verifyTemplateChecksums(
          templateDir,
          templateType: 'mini',
        );

        expect(result, isFalse);
      });
    });

    group('Given template directory without checksums.json', () {
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

    group('Given valid checksums when verifying with retry', () {
      test('then succeeds without redownload', () async {
        var templateDir = Directory(p.join(tempDir.path, 'templates'));
        templateDir.createSync(recursive: true);

        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt')).writeAsStringSync('server');

        var serverChecksum =
            await TemplateChecksumManager.calculateDirectoryChecksum(serverDir);

        var checksums = {
          'directories': {
            'projectname_server': serverChecksum,
          },
          'templates': {
            'mini': 'dummy',
          },
        };

        File(p.join(templateDir.path, 'checksums.json'))
            .writeAsStringSync(jsonEncode(checksums));

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

        var serverDir =
            Directory(p.join(templateDir.path, 'projectname_server'));
        serverDir.createSync(recursive: true);
        File(p.join(serverDir.path, 'file.txt'))
            .writeAsStringSync('wrong_content');

        var correctContent = 'correct_content';
        var tempTestDir = Directory(p.join(tempDir.path, 'temp_test'));
        tempTestDir.createSync();
        File(p.join(tempTestDir.path, 'file.txt'))
            .writeAsStringSync(correctContent);
        var expectedChecksum =
            await TemplateChecksumManager.calculateDirectoryChecksum(
                tempTestDir);
        tempTestDir.deleteSync(recursive: true);

        var checksums = {
          'directories': {
            'projectname_server': expectedChecksum,
          },
          'templates': {
            'mini': 'dummy',
          },
        };

        File(p.join(templateDir.path, 'checksums.json'))
            .writeAsStringSync(jsonEncode(checksums));

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
              File(p.join(templateDir.path, 'checksums.json'))
                  .writeAsStringSync(jsonEncode(checksums));
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

        var checksums = {
          'directories': {
            'projectname_server': 'will_never_match',
          },
          'templates': {
            'mini': 'dummy',
          },
        };

        // Create initial checksums.json with wrong checksum
        File(p.join(templateDir.path, 'checksums.json'))
            .writeAsStringSync(jsonEncode(checksums));

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
            File(p.join(templateDir.path, 'checksums.json'))
                .writeAsStringSync(jsonEncode(checksums));
          },
        );

        expect(result, isFalse);
        expect(downloadCount,
            equals(TemplateChecksumManager.maxRetryAttempts - 1));
      });
    });
  });
}
