import 'dart:io';

import 'package:serverpod_shared/serverpod_shared.dart';

import '../downloads/resource_manager.dart';
import '../generated/version.dart';
import '../util/print.dart';
import 'command_line_tools.dart';
import 'copier.dart';
import 'port_checker.dart';

const _defaultPorts = <int>[8080, 8081, 8090, 8091];

Future<void> performCreate(
    String name, bool verbose, String template, bool force) async {
  // Check we are set to create a new project
  var portsAvailable = true;
  for (final port in _defaultPorts) {
    var available = await isNetworkPortAvailable(port);
    if (!available) {
      portsAvailable = false;
      break;
    }
  }

  // Check that docker is installed
  final dockerInstalled = await CommandLineTools.existsCommand('docker');

  if (!portsAvailable || !dockerInstalled) {
    var strIssue =
        'There are some issues with your setup that will prevent your Serverpod project from running out of the box and without further configuration. You can still create this project by passing -f to "serverpod create".';
    var strIssuePorts =
        'By default your server will run on port 8080 and 8081 and Postgres and Redis will run on 8090 and 8091. One or more of these ports are currently in use. The most likely reason is that you have another Serverpod project running, but it can also be another service. You can either stop the other service and run this command again, or you can create the project with the -f flag added and manually configure the ports in the config/development.yaml and docker-compose.yaml files.';
    var strIssueDocker =
        'You do not have Docker installed. Serverpod uses Docker to run Postgres and Redis. It\'s recommended that you install Docker Desktop from https://www.docker.com/get-started but you can also install and configure Postgres and Redis manually and run this command with the -f added.';

    printww(strIssue);

    if (!portsAvailable) {
      printww('');
      printww(strIssuePorts);
    }
    if (!dockerInstalled) {
      printww('');
      printww(strIssueDocker);
    }
    if (!force) {
      return;
    }
  }

  var projectDir = Directory(Directory.current.path + '/' + name);
  if (projectDir.existsSync()) {
    print('Project $name already exists.');
    return;
  }

  print('Creating project $name...');

  if (verbose) print('Creating directory: ${projectDir.path}');
  projectDir.createSync();

  var serverDir = Directory(projectDir.path + '/' + name + '_server');
  if (verbose) print('Creating directory: ${serverDir.path}');
  serverDir.createSync();

  var clientDir = Directory(projectDir.path + '/' + name + '_client');
  if (verbose) print('Creating directory: ${clientDir.path}');

  if (template == 'server') {
    var flutterDir = Directory(projectDir.path + '/' + name + '_flutter');
    if (verbose) print('Creating directory: ${flutterDir.path}');
    flutterDir.createSync();

    // Copy server files
    var copier = Copier(
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/PROJECTNAME_server'),
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
        Replacement(
          slotName: 'DB_PASSWORD',
          replacement: generateRandomString(),
        ),
        Replacement(
          slotName: 'REDIS_PASSWORD',
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
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/PROJECTNAME_client'),
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
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/PROJECTNAME_flutter'),
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
      ignoreFileNames: [
        'pubspec.lock',
        'ios',
        'android',
        'web',
        'macos',
        'build',
      ],
      verbose: verbose,
    );
    copier.copyFiles();

    await CommandLineTools.dartPubGet(serverDir);
    await CommandLineTools.dartPubGet(clientDir);
    await CommandLineTools.flutterCreate(flutterDir);
  } else if (template == 'module') {
    // Copy server files
    var copier = Copier(
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/MODULENAME_server'),
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
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/MODULENAME_client'),
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
  } else {
    print(
        'Unknown template: $template (valid options are "server" or "module")');
  }

  if (dockerInstalled) {
    await CommandLineTools.createTables(projectDir, name);

    printww('');
    printww('');
    printww('All setup. You are ready to rock!');
    printww('');
    printww('Start Postgres and Redis by running:');
    stdout.writeln('    cd $name/${name}_server');
    stdout.writeln('    docker-compose up --build --detach');
    printww('');
    printww('Then start your Serverpod server by running:');
    stdout.writeln('    dart bin/main.dart');
    printww('');
  }
}
