import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart';

import '../downloads/resource_manager.dart';
import '../generated/version.dart';
import '../util/command_line_tools.dart';
import '../util/print.dart';
import 'copier.dart';
import 'port_checker.dart';

const _defaultPorts = <String, int>{
  'Serverpod API': 8080,
  'Serverpod insights API': 8081,
  'Serverpod Relic web server': 8082,
  'PostgreSQL server': 8090,
  'Redis server': 8091,
};

Future<void> performCreate(
  String name,
  bool verbose,
  String template,
  bool force,
) async {
  // Check we are set to create a new project
  var usedPorts = <String, int>{};
  for (var serverDescription in _defaultPorts.keys) {
    var port = _defaultPorts[serverDescription]!;

    var available = await isNetworkPortAvailable(port);
    if (!available) {
      usedPorts[serverDescription] = port;
    }
  }
  var portsAvailable = usedPorts.isEmpty;

  // Check that docker is installed
  var dockerConfigured = await CommandLineTools.existsCommand('docker') &&
      await CommandLineTools.isDockerRunning();

  if (!portsAvailable || !dockerConfigured) {
    var strIssue =
        'There are some issues with your setup that will prevent your Serverpod project from running out of the box and without further configuration. You can still create this project by passing -f to "serverpod create" and manually configure your Serverpod.';
    var strIssuePorts =
        'One or more network ports Serverpod want to use are not available. The most likely reason is that you have another Serverpod project running, but it can also be another service.';
    var strIssueDocker =
        'You do not have Docker installed or it is not running. Serverpod uses Docker to run Postgres and Redis. It\'s recommended that you install Docker Desktop from https://www.docker.com/get-started but you can also install and configure Postgres and Redis manually and run this command with the -f flag added.';

    printww(strIssue);

    if (!portsAvailable) {
      printww('');
      printww(strIssuePorts);
      printww('');
      printww('Ports in use:');
      for (var serverDescription in usedPorts.keys) {
        var port = usedPorts[serverDescription]!;
        print(' • $port: $serverDescription');
      }
    }
    if (!dockerConfigured) {
      printww('');
      printww(strIssueDocker);
    }
    if (!force) {
      return;
    }
  }

  var dbPassword = generateRandomString();
  var dbProductionPassword = generateRandomString();

  var awsName = name.replaceAll('_', '-');
  var randomAwsId = Random.secure().nextInt(10000000).toString();

  var projectDir = Directory(p.join(Directory.current.path, name));
  if (projectDir.existsSync()) {
    print('Project $name already exists.');
    return;
  }

  print('Creating project $name...');

  if (verbose) print('Creating directory: ${projectDir.path}');
  projectDir.createSync();

  var serverDir = Directory(p.join(projectDir.path, name + '_server'));
  if (verbose) print('Creating directory: ${serverDir.path}');
  serverDir.createSync();

  var clientDir = Directory(p.join(projectDir.path, name + '_client'));
  if (verbose) print('Creating directory: ${clientDir.path}');

  if (template == 'server') {
    var flutterDir = Directory(p.join(projectDir.path, name + '_flutter'));
    if (verbose) print('Creating directory: ${flutterDir.path}');
    flutterDir.createSync();

    var githubDir = Directory(p.join(projectDir.path, '.github'));
    if (verbose) print('Creating directory: ${githubDir.path}');
    githubDir.createSync();

    // Copy server files
    var copier = Copier(
      srcDir: Directory(
          p.join(resourceManager.templateDirectory.path, 'projectname_server')),
      dstDir: serverDir,
      replacements: [
        Replacement(
          slotName: 'projectname',
          replacement: name,
        ),
        Replacement(
          slotName: 'awsname',
          replacement: awsName,
        ),
        Replacement(
          slotName: 'randomawsid',
          replacement: randomAwsId,
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
          replacement: dbPassword,
        ),
        Replacement(
          slotName: 'DB_PRODUCTION_PASSWORD',
          replacement: dbProductionPassword,
        ),
        Replacement(
          slotName: 'REDIS_PASSWORD',
          replacement: generateRandomString(),
        ),
      ],
      fileNameReplacements: [
        Replacement(
          slotName: 'projectname',
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
          p.join(resourceManager.templateDirectory.path, 'projectname_client')),
      dstDir: clientDir,
      replacements: [
        Replacement(
          slotName: 'projectname',
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
          slotName: 'projectname',
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
      srcDir: Directory(p.join(
          resourceManager.templateDirectory.path, 'projectname_flutter')),
      dstDir: flutterDir,
      replacements: [
        Replacement(
          slotName: 'projectname',
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
          slotName: 'projectname',
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

    copier = Copier(
      srcDir:
          Directory(p.join(resourceManager.templateDirectory.path, 'github')),
      dstDir: githubDir,
      replacements: [
        Replacement(
          slotName: 'projectname',
          replacement: name,
        ),
        Replacement(
          slotName: 'awsname',
          replacement: awsName,
        ),
        Replacement(
          slotName: 'randomawsid',
          replacement: randomAwsId,
        ),
      ],
      fileNameReplacements: [],
      verbose: verbose,
    );
    copier.copyFiles();

    print('');

    CommandLineTools.dartPubGet(serverDir);
    CommandLineTools.dartPubGet(clientDir);
    CommandLineTools.flutterCreate(flutterDir);
  } else if (template == 'module') {
    // Copy server files
    var copier = Copier(
      srcDir: Directory(
          p.join(resourceManager.templateDirectory.path, 'modulename_server')),
      dstDir: serverDir,
      replacements: [
        Replacement(
          slotName: 'modulename',
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
          slotName: 'modulename',
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
          p.join(resourceManager.templateDirectory.path, 'modulename_client')),
      dstDir: clientDir,
      replacements: [
        Replacement(
          slotName: 'modulename',
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
          slotName: 'modulename',
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

  if (dockerConfigured && template != 'module') {
    await CommandLineTools.createTables(projectDir, name);

    printwwln('');
    printwwln('SERVERPOD CREATED 🥳');
    printwwln('All setup. You are ready to rock!');
    printwwln('Start your Serverpod by running:');
    stdout.writeln('  \$ cd ${p.join(name, '${name}_server')}');
    stdout.writeln('  \$ docker-compose up --build --detach');
    stdout.writeln('  \$ dart bin/main.dart');
    printww('');
  }
}
