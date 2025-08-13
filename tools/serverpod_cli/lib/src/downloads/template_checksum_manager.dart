import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

class TemplateChecksumManager {
  static const String checksumsFileName = 'checksums.json';
  static const int maxRetryAttempts = 5;
  static const String bugReportUrl =
      'https://github.com/serverpod/serverpod/issues/new?template=bug_report.yml';

  /// Calculate MD5 checksum for a directory tree
  static Future<String> calculateDirectoryChecksum(Directory dir) async {
    var fileHashes = <String>[];

    var files = await dir
        .list(recursive: true, followLinks: false)
        .where((entity) => entity is File)
        .cast<File>()
        .toList();

    files.sort((a, b) => a.path.compareTo(b.path));

    for (var file in files) {
      var fileName = p.basename(file.path);
      if (fileName == checksumsFileName || fileName == 'checksum.json') {
        continue;
      }

      var relativePath = p.relative(file.path, from: dir.path);

      var content = await file.readAsBytes();
      var fileHash = md5.convert(content).toString();

      fileHashes.add('$relativePath:$fileHash');
    }

    var combinedHashes = fileHashes.join('\n');
    var finalChecksum = md5.convert(utf8.encode(combinedHashes)).toString();

    return finalChecksum;
  }

  /// Verify checksums for downloaded templates
  static Future<bool> verifyTemplateChecksums(
    Directory templateDir, {
    required String templateType,
  }) async {
    var checksumsFile = File(p.join(templateDir.path, checksumsFileName));

    if (!await checksumsFile.exists()) {
      return true;
    }

    try {
      var checksumsJson = jsonDecode(await checksumsFile.readAsString())
          as Map<String, dynamic>;
      var expectedChecksums =
          checksumsJson['directories'] as Map<String, dynamic>?;
      var templateChecksums =
          checksumsJson['templates'] as Map<String, dynamic>?;

      if (expectedChecksums == null || templateChecksums == null) {
        return false;
      }

      List<String> dirsToCheck;
      String? compositeChecksum;

      switch (templateType) {
        case 'mini':
          dirsToCheck = [
            'projectname_server',
            'projectname_client',
            'projectname_flutter'
          ];
          compositeChecksum = templateChecksums['mini'] as String?;
          break;
        case 'server':
          dirsToCheck = [
            'projectname_server',
            'projectname_server_upgrade',
            'projectname_client',
            'projectname_flutter',
            'github'
          ];
          compositeChecksum = templateChecksums['server'] as String?;
          break;
        case 'module':
          dirsToCheck = ['modulename_server', 'modulename_client'];
          compositeChecksum = templateChecksums['module'] as String?;
          break;
        default:
          return true;
      }

      for (var dirName in dirsToCheck) {
        var dir = Directory(p.join(templateDir.path, dirName));
        if (!await dir.exists()) {
          continue;
        }

        var expectedChecksum = expectedChecksums[dirName] as String?;
        if (expectedChecksum == null) {
          continue;
        }

        var actualChecksum = await calculateDirectoryChecksum(dir);
        if (expectedChecksum != actualChecksum) {
          print('Checksum mismatch for $dirName:');
          print('  Expected: $expectedChecksum');
          print('  Actual:   $actualChecksum');
          return false;
        }
      }

      if (compositeChecksum != null && compositeChecksum != 'dummy') {
        var compositeHashes = StringBuffer();
        for (var dirName in dirsToCheck) {
          var dir = Directory(p.join(templateDir.path, dirName));
          if (await dir.exists()) {
            var dirChecksum = await calculateDirectoryChecksum(dir);
            compositeHashes.write(dirChecksum);
          }
        }

        var actualComposite =
            md5.convert(utf8.encode(compositeHashes.toString())).toString();
        if (compositeChecksum != actualComposite) {
          print('Composite checksum mismatch for $templateType:');
          print('  Expected: $compositeChecksum');
          print('  Actual:   $actualComposite');
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error verifying checksums: $e');
      return false;
    }
  }

  /// Verify checksums with retry logic
  static Future<bool> verifyWithRetry(
    Directory templateDir, {
    required String templateType,
    required Future<void> Function() redownloadCallback,
  }) async {
    for (var attempt = 1; attempt <= maxRetryAttempts; attempt++) {
      print(
          'Verifying template checksums (attempt $attempt/$maxRetryAttempts)...');

      var isValid = await verifyTemplateChecksums(
        templateDir,
        templateType: templateType,
      );

      if (isValid) {
        return true;
      }

      if (attempt < maxRetryAttempts) {
        print('Checksum verification failed. Redownloading templates...');

        if (await templateDir.exists()) {
          await templateDir.delete(recursive: true);
        }

        await redownloadCallback();
      }
    }

    print('');
    print(
        'ERROR: Template checksum verification failed after $maxRetryAttempts attempts.');
    print('This might indicate corrupted template files.');
    print('Please report this issue at: $bugReportUrl');
    print('');

    return false;
  }
}
