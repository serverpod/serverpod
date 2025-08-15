#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/downloads/template_checksum_manager.dart';

/// CLI tool to calculate checksums for Serverpod templates
/// This is used by the bash script util/calculate_template_checksum
void main(List<String> args) async {
  var serverpodHome = Platform.environment['SERVERPOD_HOME'];
  if (serverpodHome == null) {
    stderr.writeln('Error: SERVERPOD_HOME environment variable not set');
    stderr
        .writeln('Please set SERVERPOD_HOME to the Serverpod repository root');
    exit(1);
  }

  var templatesDir = p.join(
    serverpodHome,
    'templates',
    'serverpod_templates',
  );

  if (!await Directory(templatesDir).exists()) {
    stderr.writeln('Error: Templates directory not found at $templatesDir');
    stderr.writeln(
        'Make sure SERVERPOD_HOME points to the Serverpod repository root');
    exit(1);
  }

  // Template directories to process
  var templateDirs = [
    'projectname_server',
    'projectname_server_upgrade',
    'projectname_client',
    'projectname_flutter',
    'modulename_server',
    'modulename_client',
    'github',
  ];

  var checksums = <String, String>{};

  // Calculate individual directory checksums
  for (var dirName in templateDirs) {
    var dir = Directory(p.join(templatesDir, dirName));
    if (await dir.exists()) {
      stderr.writeln('Calculating checksum for $dirName...');
      var checksum =
          await TemplateChecksumManager.calculateDirectoryChecksum(dir);
      checksums[dirName] = checksum;
      stderr.writeln('  $dirName: $checksum');
    } else {
      stderr.writeln('Warning: Directory $dirName not found, skipping...');
    }
  }

  // Calculate composite checksums for template types
  stderr.writeln('\nCalculating composite checksums...');

  // Mini template: projectname_server, projectname_client, projectname_flutter
  var miniChecksum = StringBuffer();
  miniChecksum.write(checksums['projectname_server'] ?? '');
  miniChecksum.write(checksums['projectname_client'] ?? '');
  miniChecksum.write(checksums['projectname_flutter'] ?? '');
  var miniFinal = md5.convert(utf8.encode(miniChecksum.toString())).toString();

  // Server template: all projectname directories + github
  var serverChecksum = StringBuffer();
  serverChecksum.write(checksums['projectname_server'] ?? '');
  serverChecksum.write(checksums['projectname_server_upgrade'] ?? '');
  serverChecksum.write(checksums['projectname_client'] ?? '');
  serverChecksum.write(checksums['projectname_flutter'] ?? '');
  serverChecksum.write(checksums['github'] ?? '');
  var serverFinal =
      md5.convert(utf8.encode(serverChecksum.toString())).toString();

  // Module template: modulename_server, modulename_client
  var moduleChecksum = StringBuffer();
  moduleChecksum.write(checksums['modulename_server'] ?? '');
  moduleChecksum.write(checksums['modulename_client'] ?? '');
  var moduleFinal =
      md5.convert(utf8.encode(moduleChecksum.toString())).toString();

  // Output JSON result
  var result = {
    'directories': checksums,
    'templates': {
      'mini': miniFinal,
      'server': serverFinal,
      'module': moduleFinal,
    },
  };

  // Pretty print JSON
  var encoder = JsonEncoder.withIndent('  ');
  stdout.writeln(encoder.convert(result));
}
