import 'dart:io';

import '../generated/version.dart';
import 'copier.dart';

import '../downloads/resource_manager.dart';

void performCreate(String name, bool verbose, String template) {
  var projectDir = Directory(Directory.current.path + '/' + name);
  if (projectDir.existsSync()) {
    print('Project $name already exists.');
    return;
  }

  if (verbose)
    print('Creating directory: ${projectDir.path}');
  projectDir.create();

  var serverDir = Directory(projectDir.path + '/' + name + '_server');
  if (verbose)
    print('Creating directory: ${serverDir.path}');
  serverDir.createSync();

  var clientDir = Directory(projectDir.path + '/' + name + '_client');
  if (verbose)
    print('Creating directory: ${clientDir.path}');
  clientDir.createSync();

  if (template == 'server') {
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
