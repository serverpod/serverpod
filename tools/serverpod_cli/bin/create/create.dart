import 'dart:io';

import 'package:serverpod_shared/serverpod_shared.dart';

import '../downloads/resource_manager.dart';
import '../generated/version.dart';
import '../util/command_line_tools.dart';
import '../util/print.dart';
import 'copier.dart';
import 'port_checker.dart';

const List<int> _defaultPorts = <int>[8080, 8081, 8090, 8091];

Future<void> performCreate(
    String name, bool verbose, String template, bool force) async {
  // Check we are set to create a new project
  bool portsAvailable = true;
  for (int port in _defaultPorts) {
    bool available = await isNetworkPortAvailable(port);
    if (!available) {
      portsAvailable = false;
      break;
    }
  }

  // Check that docker is installed
  bool dockerConfigured = await CommandLineTools.existsCommand('docker') &&
      await CommandLineTools.isDockerRunning();

  if (!portsAvailable || !dockerConfigured) {
    String strIssue =
        'There are some issues with your setup that will prevent your Serverpod project from running out of the box and without further configuration. You can still create this project by passing -f to "serverpod create".';
    String strIssuePorts =
        'By default your server will run on port 8080 and 8081 and Postgres and Redis will run on 8090 and 8091. One or more of these ports are currently in use. The most likely reason is that you have another Serverpod project running, but it can also be another service. You can either stop the other service and run this command again, or you can create the project with the -f flag added and manually configure the ports in the config/development.yaml and docker-compose.yaml files.';
    String strIssueDocker =
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

  String dbPassword = generateRandomString();

  String pathSeparator = Platform.pathSeparator;
  Directory projectDir =
      Directory(Directory.current.path + pathSeparator + name);
  if (projectDir.existsSync()) {
    print('Project $name already exists.');
    return;
  }

  print('Creating project $name...');

  if (verbose) print('Creating directory: ${projectDir.path}');
  projectDir.createSync();

  Directory serverDir =
      Directory(projectDir.path + pathSeparator + name + '_server');
  if (verbose) print('Creating directory: ${serverDir.path}');
  serverDir.createSync();

  Directory clientDir =
      Directory(projectDir.path + pathSeparator + name + '_client');
  if (verbose) print('Creating directory: ${clientDir.path}');

  if (template == 'server') {
    Directory flutterDir =
        Directory(projectDir.path + pathSeparator + name + '_flutter');
    if (verbose) print('Creating directory: ${flutterDir.path}');
    flutterDir.createSync();

    // Copy server files
    Copier copier = Copier(
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/PROJECTNAME_server'),
      dstDir: serverDir,
      replacements: <Replacement>[
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
          replacement: dbPassword,
        ),
        Replacement(
          slotName: 'REDIS_PASSWORD',
          replacement: generateRandomString(),
        ),
      ],
      fileNameReplacements: <Replacement>[
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: <String>['path'],
      ignoreFileNames: <String>['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy client files
    copier = Copier(
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/PROJECTNAME_client'),
      dstDir: clientDir,
      replacements: <Replacement>[
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
      fileNameReplacements: <Replacement>[
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: <String>['path'],
      ignoreFileNames: <String>['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy Flutter files
    copier = Copier(
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/PROJECTNAME_flutter'),
      dstDir: flutterDir,
      replacements: <Replacement>[
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
      fileNameReplacements: <Replacement>[
        Replacement(
          slotName: 'PROJECTNAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: <String>[],
      ignoreFileNames: <String>[
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

    print('');

    CommandLineTools.dartPubGet(serverDir);
    CommandLineTools.dartPubGet(clientDir);
    CommandLineTools.flutterCreate(flutterDir);
  } else if (template == 'module') {
    // Copy server files
    Copier copier = Copier(
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/MODULENAME_server'),
      dstDir: serverDir,
      replacements: <Replacement>[
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
      fileNameReplacements: <Replacement>[
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: <String>['path'],
      ignoreFileNames: <String>['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();

    // Copy client files
    copier = Copier(
      srcDir: Directory(
          '${resourceManager.templateDirectory.path}/MODULENAME_client'),
      dstDir: clientDir,
      replacements: <Replacement>[
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
      fileNameReplacements: <Replacement>[
        Replacement(
          slotName: 'MODULENAME',
          replacement: name,
        ),
        Replacement(
          slotName: 'gitignore',
          replacement: '.gitignore',
        ),
      ],
      removePrefixes: <String>['path'],
      ignoreFileNames: <String>['pubspec.lock'],
      verbose: verbose,
    );
    copier.copyFiles();
  } else {
    print(
        'Unknown template: $template (valid options are "server" or "module")');
  }

  if (dockerConfigured && !Platform.isWindows) {
    await CommandLineTools.createTables(projectDir, name);

    printww('');
    printww('');
    printww('=== SERVERPOD CREATED ===');
    printww('');
    printww('All setup. You are ready to rock!');
    printww('');
    printww('Start your Serverpod server by running:');
    printww('');
    stdout.writeln('  \$ cd $name/${name}_server');
    stdout.writeln('  \$ serverpod run');
    printww('');
    printww('You can also start Serverpod manually by running:');
    printww('');
    stdout.writeln('  \$ cd $name/${name}_server');
    stdout.writeln('  \$ docker-compose up --build --detach');
    stdout.writeln('  \$ dart bin/main.dart');
    printww('');
  }

  if (Platform.isWindows) {
    printww('');
    printww('');
    printww('=== SERVERPOD CREATED ===');
    printww('');
    printww('You are almost ready to rock!');
    printww('To get going, you need to start Docker by running:');
    printww('');
    stdout.writeln('  \$ cd .\\$name\\${name}_server');
    stdout.writeln('  \$ docker-compose up --build --detach');
    printww('');
    printww(
        'When your docker container is up and running you need to install the default Serverpod postgres tables. (You only need to to this once.)');
    printww('');
    stdout.writeln(
        '  \$ Get-Content .\\generated\\tables-serverpod.pgsql | docker-compose run -T postgres env PGPASSWORD="$dbPassword" psql -h postgres -U postgres -d $name');
    printww('');
    printww(
        'Unfortunately `serverpod run` is not yet supported on Windows, but you should be able to start Serverpod by running:');
    printww('');
    stdout.writeln('  \$ dart .\\bin\\main.dart');
    printww('');
  }
}
