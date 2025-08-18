#!/usr/bin/env dart

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// CLI tool to calculate checksums for Serverpod templates
/// Reads template_files.yaml and generates template_checksums.yaml
void main(List<String> args) async {
  var serverpodHome = Platform.environment['SERVERPOD_HOME'];
  if (serverpodHome == null) {
    stderr.writeln('Error: SERVERPOD_HOME environment variable not set');
    stderr.writeln('Please set SERVERPOD_HOME to the Serverpod repository root');
    exit(1);
  }

  var templatesDir = p.join(
    serverpodHome,
    'templates',
    'serverpod_templates',
  );

  // Read the template files manifest
  var filesManifestPath = p.join(templatesDir, 'template_files.yaml');
  var filesManifestFile = File(filesManifestPath);
  
  if (!await filesManifestFile.exists()) {
    stderr.writeln('Error: template_files.yaml not found at $filesManifestPath');
    stderr.writeln('This file defines which files to include in checksums');
    exit(1);
  }

  stderr.writeln('Reading template files manifest...');
  var filesManifest = loadYaml(await filesManifestFile.readAsString()) as Map;
  
  // Get the directories section from the manifest
  var directories = filesManifest['directories'] as Map?;
  if (directories == null) {
    stderr.writeln('Error: No directories section found in template_files.yaml');
    exit(1);
  }
  
  // Calculate checksums for each template directory and file
  var checksums = <String, Map<String, String>>{};
  
  for (var entry in directories.entries) {
    var templateName = entry.key as String;
    var files = entry.value as List;
    
    stderr.writeln('\nProcessing $templateName...');
    var templateChecksums = <String, String>{};
    
    for (var filePath in files) {
      var fullPath = p.join(templatesDir, templateName, filePath as String);
      var file = File(fullPath);
      
      if (!await file.exists()) {
        stderr.writeln('  Warning: File not found: $filePath');
        continue;
      }
      
      var content = await file.readAsBytes();
      var checksum = md5.convert(content).toString();
      templateChecksums[filePath] = checksum;
      
      if (args.contains('--verbose')) {
        stderr.writeln('  $filePath: $checksum');
      }
    }
    
    checksums[templateName] = templateChecksums;
    stderr.writeln('  Processed ${templateChecksums.length} files');
  }
  
  // Generate YAML output
  var output = StringBuffer();
  output.writeln('# Template checksums - auto-generated, do not edit');
  output.writeln('# Generated from template_files.yaml');
  output.writeln('# Last updated: ${DateTime.now().toIso8601String()}');
  output.writeln();
  
  for (var entry in checksums.entries) {
    var templateName = entry.key;
    var templateChecksums = entry.value;
    
    output.writeln('$templateName:');
    for (var fileEntry in templateChecksums.entries) {
      output.writeln('  ${fileEntry.key}: ${fileEntry.value}');
    }
    if (entry.key != checksums.keys.last) {
      output.writeln();
    }
  }
  
  // Write to template_checksums.yaml
  var checksumsPath = p.join(templatesDir, 'template_checksums.yaml');
  var checksumsFile = File(checksumsPath);
  await checksumsFile.writeAsString(output.toString());
  
  stderr.writeln('\nChecksums written to template_checksums.yaml');
  print('Successfully generated checksums for ${checksums.length} templates');
}