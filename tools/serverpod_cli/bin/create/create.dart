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

const _defaultPorts = <int>[8080, 8081, 8090, 8091];

Future<void> performCreate(
  String name,
  bool verbose,
  String template,
  bool force,
) async {
  // Check we are set to create a new project
  var portsAvailable = true;
  for (var port in _defaultPorts) {
    var available = await isNetworkPortAvailable(port);
    if (!available) {
      portsAvailable = false;
      break;
    }
  }

  // Check that docker is installed
  var dockerConfigured = await CommandLineTools.existsCommand('docker') &&
      await CommandLineTools.isDockerRunning();

  if (!portsAvailable || !dockerConfigured) {
    var strIssue =
        'There are some issues with your setup that will prevent your Serverpod project from running out of the box and without further configuration. You can still create this project by passing -f to "serverpod create".';
    var strIssuePorts =
        'By default your server will run on port 8080 and 8081 and Postgres and Redis will run on 8090 and 8091. One or more of these ports are currently in use. The most likely reason is that you have another Serverpod project running, but it can also be another service. You can either stop the other service and run this command again, or you can create the project with the -f flag added and manually configure the ports in the config/development.yaml and docker-compose.yaml files.';
    var strIssueDocker =
        'You do not have Docker installed or it is not running. Serverpod uses Docker to run Postgres and Redis. It\'s recommended that you install Docker Desktop from https://www.docker.com/get-started but you can also install and configure Postgres and Redis manually and run this command with the -f flag added.';

    printww(strIssue);

    if (!portsAvailable) {
      printww('');
      printww(strIssuePorts);
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

  if (dockerConfigured && !Platform.isWindows) {
    await CommandLineTools.createTables(projectDir, name);

    printwwln('');
    printwwln('=== SERVERPOD CREATED ===');
    printwwln('All setup. You are ready to rock!');
    printwwln('Start your Serverpod server by running:');
    stdout.writeln('  \$ cd ${p.join(name, '${name}_server')}');
    stdout.writeln('  \$ docker-compose up --build --detach');
    stdout.writeln('  \$ serverpod run');
    printww('');
    printwwln('You can also start Serverpod manually by running:');
    stdout.writeln('  \$ cd ${p.join(name, '${name}_server')}');
    stdout.writeln('  \$ docker-compose up --build --detach');
    stdout.writeln('  \$ dart bin/main.dart');
    printww('');
  }

  if (Platform.isWindows) {
    printwwln('');
    printwwln('=== SERVERPOD CREATED ===');
    printww('You are almost ready to rock!');
    printwwln('To get going, you need to start Docker by running:');
    stdout.writeln('  \$ cd ${p.join(name, '${name}_server')}');
    stdout.writeln('  \$ docker-compose up --build --detach');
    printww('');
    printwwln(
        'When your docker container is up and running you need to install the default Serverpod postgres tables. (You only need to to this once.)');
    stdout.writeln(
        '  \$ Get-Content .\\generated\\tables-serverpod.pgsql | docker-compose run -T postgres env PGPASSWORD="$dbPassword" psql -h postgres -U postgres -d $name');
    printww('');
    printwwln(
        'Unfortunately `serverpod run` is not yet supported on Windows, but you should be able to start Serverpod by running:');
    stdout.writeln('  \$ dart .\\bin\\main.dart');
    printww('');
  }
}
