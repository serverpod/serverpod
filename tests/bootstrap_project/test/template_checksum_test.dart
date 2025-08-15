@Timeout(Duration(minutes: 5))

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../lib/src/util.dart';

const tempDirName = 'temp';

void main() async {
  final rootPath = path.join(Directory.current.path, '..', '..');
  final cliPath = path.join(rootPath, 'tools', 'serverpod_cli');
  final tempPath = path.join(rootPath, tempDirName);
  final templatesPath = path.join(rootPath, 'templates', 'serverpod_templates');

  setUpAll(() async {
    await runProcess(
      'dart',
      ['pub', 'global', 'activate', '-s', 'path', '.'],
      workingDirectory: cliPath,
    );

    await Directory(tempPath).create();
  });

  tearDownAll(() async {
    try {
      await Directory(tempPath).delete(recursive: true);
    } catch (e) {}
  });

  group('Template checksum verification', () {
    test(
        'Given template files when calculating checksums then checksums are correctly generated',
        () async {
      var calculateProcess = await runProcess(
        'bash',
        ['util/calculate_template_checksum'],
        workingDirectory: rootPath,
      );

      expect(
        calculateProcess.exitCode,
        0,
        reason: 'Failed to calculate template checksums',
      );

      var checksumsFile = File(path.join(templatesPath, 'checksums.json'));
      expect(checksumsFile.existsSync(), isTrue,
          reason: 'checksums.json file was not created');
    });

    test(
        'Given no cached templates when creating a new project then templates are downloaded and verified',
        () async {
      final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

      var serverpodDir = Directory(path.join(
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!,
        '.serverpod',
      ));
      if (serverpodDir.existsSync()) {
        try {
          await serverpodDir.delete(recursive: true);
        } catch (_) {}
      }

      var createProcess = await runProcess(
        'serverpod',
        ['create', projectName, '--mini', '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          'SERVERPOD_HOME': rootPath,
        },
      );

      expect(
        createProcess.exitCode,
        0,
        reason: 'Failed to create project with template verification',
      );

      expect(
        Directory(path.join(tempPath, projectName)).existsSync(),
        isTrue,
        reason: 'Project directory was not created',
      );

      try {
        await Directory(path.join(tempPath, projectName))
            .delete(recursive: true);
      } catch (_) {}
    });

    test(
        'Given corrupted template files when creating a new project then corruption is detected and templates redownloaded',
        () async {
      // This test must be skipped in local development because:
      // 1. We can't corrupt repository templates (would break the repo)
      // 2. Testing with downloaded templates would affect user's ~/.serverpod directory
      // 3. In CI, we can safely test with downloaded templates without affecting developers
      if (!Platform.environment.containsKey('CI')) {
        markTestSkipped(
            'Skipping corruption test - cannot safely corrupt templates in local development');
        return;
      }

      final (:projectName, :commandRoot) = createRandomProjectName(tempPath);

      // First, ensure we have downloaded templates (not using dev mode)
      // We run without SERVERPOD_HOME to force download mode
      var firstCreateProcess = await runProcess(
        'serverpod',
        ['create', '${projectName}_first', '--mini', '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          // Explicitly remove SERVERPOD_HOME to ensure we're not in dev mode
          'PATH': Platform.environment['PATH'] ?? '',
          'HOME': Platform.environment['HOME'] ?? '',
        },
      );

      expect(firstCreateProcess.exitCode, 0,
          reason: 'Failed to create first project and download templates');

      // Now corrupt the downloaded templates
      var serverpodDir = Directory(path.join(
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!,
        '.serverpod',
      ));

      expect(serverpodDir.existsSync(), isTrue,
          reason: 'Templates directory should exist after first create');

      // Find template files to corrupt
      var templateFiles = serverpodDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) =>
              f.path.contains('projectname_server') && f.path.endsWith('.dart'))
          .toList();

      expect(templateFiles.isNotEmpty, isTrue,
          reason: 'Should find template files to corrupt');

      // Corrupt multiple files to ensure corruption is significant
      var corruptedCount = 0;
      for (var file in templateFiles.take(3)) {
        await file
            .writeAsString('// CORRUPTED CONTENT\nthrow "Template corrupted";');
        corruptedCount++;
      }

      expect(corruptedCount, greaterThan(0),
          reason: 'Should have corrupted at least one file');

      // Now try to create another project - should detect corruption and re-download
      var secondCreateProcess = await runProcess(
        'serverpod',
        ['create', projectName, '--mini', '-v', '--no-analytics'],
        workingDirectory: tempPath,
        environment: {
          // Again, no SERVERPOD_HOME to ensure we use downloaded templates
          'PATH': Platform.environment['PATH'] ?? '',
          'HOME': Platform.environment['HOME'] ?? '',
        },
      );

      // The process should succeed after re-downloading templates
      expect(
        secondCreateProcess.exitCode,
        0,
        reason: 'Should recover from corrupted templates by re-downloading',
      );

      expect(
        Directory(path.join(tempPath, projectName)).existsSync(),
        isTrue,
        reason: 'Project directory should be created after recovery',
      );

      // Verify the created project has valid content (not corrupted)
      var serverMainFile = File(path.join(
        tempPath,
        projectName,
        '${projectName}_server',
        'bin',
        'main.dart',
      ));

      expect(serverMainFile.existsSync(), isTrue,
          reason: 'Server main.dart should exist');

      var content = await serverMainFile.readAsString();
      expect(content.contains('CORRUPTED'), isFalse,
          reason: 'Generated files should not contain corruption marker');

      try {
        await Directory(path.join(tempPath, projectName))
            .delete(recursive: true);
        await Directory(path.join(tempPath, '${projectName}_first'))
            .delete(recursive: true);
      } catch (_) {}
    });
  });
}
