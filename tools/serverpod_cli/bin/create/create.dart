import 'dart:io';

import 'package:serverpod_shared/serverpod_shared.dart';

import '../generated/version.dart';
import 'command_line_tools.dart';
import 'copier.dart';

import '../downloads/resource_manager.dart';

Future<void> performCreate(String name, bool verbose, String template) async {
  var projectDir = Directory(Directory.current.path + '/' + name);
  if (projectDir.existsSync()) {
    print('Project $name already exists.');
    return;
  }

  print('Creating project $name...');

  if (verbose)
    print('Creating directory: ${projectDir.path}');
  projectDir.createSync();

  var serverDir = Directory(projectDir.path + '/' + name + '_server');
  if (verbose)
    print('Creating directory: ${serverDir.path}');
  serverDir.createSync();

  var clientDir = Directory(projectDir.path + '/' + name + '_client');
  if (verbose)
    print('Creating directory: ${clientDir.path}');

  if (template == 'server') {
    var flutterDir = Directory(projectDir.path + '/' + name + '_flutter');
    if (verbose)
      print('Creating directory: ${flutterDir.path}');
    flutterDir.createSync();

    // Copy server files
    var copier = Copier(
      srcDir: Directory('${resourceManager.templateDirectory.path}/PROJECTNAME_server'),
      dstDir: serverDir,
      replacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: '#^',
          replacement: '^',
        ),
        Replacement(
          slotName: 'VERSION',
          replacement: templateVersion,
        ),
        Replacement(
          slotName: 'SERVICE_SECRET_DEVELOPMENT',
          replacement: generateRandomString(),
        ),
        Replacement(
          slotName: 'SERVICE_SECRET_STAGING',
          replacement: generateRandomString(),
        ),
        Replacement(
          slotName: 'SERVICE_SECRET_PRODUCTION',
          replacement: generateRandomString(),
        ),
      ],
      fileNameReplacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: ['path'],
      ignoreFileNames: ['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy client files
    copier = Copier(
      srcDir: Directory('${resourceManager.templateDirectory.path}/PROJECTNAME_client'),
      dstDir: clientDir,
      replacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: '#^',
          replacement: '^',
        ),
        Replacement(
          slotName: 'VERSION',
          replacement: templateVersion,
        ),
      ],
      fileNameReplacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: ['path'],
      ignoreFileNames: ['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy Flutter files
    copier = Copier(
      srcDir: Directory('${resourceManager.templateDirectory.path}/PROJECTNAME_flutter'),
      dstDir: flutterDir,
      replacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: '#^',
          replacement: '^',
        ),
        Replacement(
          slotName: 'VERSION',
          replacement: templateVersion,
        ),
      ],
      fileNameReplacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: [],
      ignoreFileNames: ['pubspec.lock', 'ios', 'android', 'web', 'macos', 'build',],
      verbose: verbose,
    );
    copier.copyFiles();

    await CommandLineTools.dartPubGet(serverDir);
    await CommandLineTools.dartPubGet(clientDir);
    await CommandLineTools.flutterCreate(flutterDir);
  }
  else if (template == 'module') {
    // Copy server files
    var copier = Copier(
      srcDir: Directory('${resourceManager.templateDirectory.path}/MODULENAME_server'),
      dstDir: serverDir,
      replacements: [
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: '#^',
          replacement: '^',
        ),
        Replacement(
          slotName: 'VERSION',
          replacement: templateVersion,
        ),
      ],
      fileNameReplacements: [
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: ['path'],
      ignoreFileNames: ['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy client files
    copier = Copier(
      srcDir: Directory('${resourceManager.templateDirectory.path}/MODULENAME_client'),
      dstDir: clientDir,
      replacements: [
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: '#^',
          replacement: '^',
        ),
        Replacement(
          slotName: 'VERSION',
          replacement: templateVersion,
        ),
      ],
      fileNameReplacements: [
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: ['path'],
      ignoreFileNames: ['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();
  }
  else {
    print('Unknown template: $template (valid options are "server" or "module")');
  }
}
