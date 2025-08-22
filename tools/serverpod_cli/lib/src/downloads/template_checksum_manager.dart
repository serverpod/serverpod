import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class TemplateChecksumManager {
  static const String checksumsFileName = 'template_checksums.yaml';
  static const String filesManifestName = 'template_files.yaml';
  static const int maxRetryAttempts = 5;
  static const String bugReportUrl =
      'https://github.com/serverpod/serverpod/issues/new?template=bug_report.yml';

  /// Verify checksums for downloaded templates using the YAML manifest
  static Future<bool> verifyTemplateChecksums(
    Directory templateDir, {
    required String templateType,
  }) async {
    var checksumsFile = File(p.join(templateDir.path, checksumsFileName));

    if (!await checksumsFile.exists()) {
      // No checksums file means we can't verify
      // In production, this would be downloaded with templates
      // In development, this should exist
      return true;
    }

    try {
      var checksumsYaml = loadYaml(await checksumsFile.readAsString()) as Map;
      
      // Read the template files manifest to get template type mappings
      var filesManifestFile = File(p.join(templateDir.path, filesManifestName));
      List<String> dirsToVerify;
      
      if (!await filesManifestFile.exists()) {
        print('Template files manifest not found: $filesManifestName');
        return false;
      }
      
      // Read template type mapping from manifest
      var filesManifest = loadYaml(await filesManifestFile.readAsString()) as Map;
      var templateTypes = filesManifest['template_types'] as Map?;
      
      if (templateTypes == null) {
        print('No template_types section found in manifest');
        return false;
      }
      
      if (!templateTypes.containsKey(templateType)) {
        print('Unknown template type in manifest: $templateType');
        return false;
      }
      
      dirsToVerify = List<String>.from(templateTypes[templateType] as List);

      // Verify each directory's files
      for (var dirName in dirsToVerify) {
        if (!checksumsYaml.containsKey(dirName)) {
          print('Missing checksums for directory: $dirName');
          return false;
        }
        
        var dirChecksums = checksumsYaml[dirName] as Map;
        var dir = Directory(p.join(templateDir.path, dirName));
        
        if (!await dir.exists()) {
          print('Missing template directory: $dirName');
          return false;
        }
        
        // Verify each file in the manifest
        for (var entry in dirChecksums.entries) {
          var filePath = entry.key as String;
          var expectedChecksum = entry.value as String;
          
          var file = File(p.join(dir.path, filePath));
          if (!await file.exists()) {
            print('Missing file: $dirName/$filePath');
            return false;
          }
          
          var content = await file.readAsBytes();
          var actualChecksum = md5.convert(content).toString();
          
          if (actualChecksum != expectedChecksum) {
            print('Checksum mismatch for $dirName/$filePath:');
            print('  Expected: $expectedChecksum');
            print('  Actual:   $actualChecksum');
            return false;
          }
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