import 'dart:io';

import 'copier.dart';
import '../shared/environment.dart';

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
      srcDir: Directory('$serverpodHome/templates/PROJECTNAME_server'),
      dstDir: serverDir,
      replacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: '../../packages/serverpod',
          replacement: '$serverpodHome/packages/serverpod',
        ),
      ],
      fileNameReplacements: [
        Replacement(slotName: 'PROJECTNAME', replacement: name),
      ],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy client files
    copier = Copier(
      srcDir: Directory('$serverpodHome/templates/PROJECTNAME_client'),
      dstDir: clientDir,
      replacements: [
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: '../../packages/serverpod',
          replacement: '$serverpodHome/packages/serverpod',
        ),
      ],
      fileNameReplacements: [
        Replacement(slotName: 'PROJECTNAME', replacement: name),
      ],
      verbose: verbose,
    );
    copier.copyFiles();
  }
  else if (template == 'module') {
    // Copy server files
    var copier = Copier(
      srcDir: Directory('$serverpodHome/templates/MODULENAME_server'),
      dstDir: serverDir,
      replacements: [
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: '../../packages/serverpod',
          replacement: '$serverpodHome/packages/serverpod',
        ),
      ],
      fileNameReplacements: [
        Replacement(slotName: 'MODULENAME', replacement: name),
      ],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy client files
    copier = Copier(
      srcDir: Directory('$serverpodHome/templates/MODULENAME_client'),
      dstDir: clientDir,
      replacements: [
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: '../../packages/serverpod',
          replacement: '$serverpodHome/packages/serverpod',
        ),
      ],
      fileNameReplacements: [
        Replacement(slotName: 'MODULENAME', replacement: name),
      ],
      verbose: verbose,
    );
    copier.copyFiles();
  }
  else {
    print('Unknown template: $template (valid options are "server" or "module")');
  }
}
