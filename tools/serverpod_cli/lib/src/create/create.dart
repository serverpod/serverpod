import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../downloads/resource_manager.dart';
import '../generated/version.dart';
import '../util/command_line_tools.dart';
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
  // check if project name is valid
  if (!StringValidators.isValidProjectName(name)) {
    log.error(
      'Invalid project name. Project names can only contain letters, numbers, '
      'and underscores.',
    );
    return;
  }
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

  if ((!portsAvailable || !dockerConfigured) && template == 'server') {
    var strIssue =
        'There are some issues with your setup that will prevent your Serverpod'
        ' project from running out of the box and without further '
        'configuration. You can still create this project by passing -f to '
        '"serverpod create" and manually configure your Serverpod.';
    var strIssuePorts =
        'One or more network ports Serverpod want to use are not available. The'
        ' most likely reason is that you have another Serverpod project'
        ' running, but it can also be another service.';
    var strIssueDocker =
        'You do not have Docker installed or it is not running. Serverpod uses '
        'Docker to run Postgres and Redis. It\'s recommended that you install '
        'Docker Desktop from https://www.docker.com/get-started but you can '
        'also install and configure Postgres and Redis manually and run this '
        'command with the -f flag added.';

    log.error(strIssue);

    if (!portsAvailable) {
      log.error(strIssuePorts, style: const PrettyPrint(newParagraph: true));
      log.error('Ports in use:', style: const PrettyPrint(newParagraph: true));
      for (var serverDescription in usedPorts.keys) {
        var port = usedPorts[serverDescription]!;
        log.error(
          '$port: $serverDescription',
          style: const PrettyPrint(type: PrettyPrintType.list),
        );
      }
    }
    if (!dockerConfigured) {
      log.error(strIssueDocker, style: const PrettyPrint(newParagraph: true));
    }
    if (!force) {
      return;
    }
  }

  var dbPassword = generateRandomString();
  var dbProductionPassword = generateRandomString();
  var dbStagingPassword = generateRandomString();

  var awsName = name.replaceAll('_', '-');
  var randomAwsId = math.Random.secure().nextInt(10000000).toString();

  var projectDir = Directory(p.join(Directory.current.path, name));
  if (projectDir.existsSync()) {
    log.error('Project $name already exists.');
    return;
  }

  log.info(
    'Creating project $name.',
    style: const PrettyPrint(newParagraph: true),
  );

  if (verbose) {
    log.debug(
      'Creating directory: ${projectDir.path}',
      style: const PrettyPrint(
        type: PrettyPrintType.list,
      ),
    );
  }
  projectDir.createSync();

  var serverDir = Directory(p.join(projectDir.path, '${name}_server'));
  if (verbose) {
    log.debug(
      'Creating directory: ${serverDir.path}',
      style: const PrettyPrint(
        type: PrettyPrintType.list,
      ),
    );
  }
  serverDir.createSync();

  var clientDir = Directory(p.join(projectDir.path, '${name}_client'));
  if (verbose) {
    log.debug(
      'Creating directory: ${clientDir.path}',
      style: const PrettyPrint(
        type: PrettyPrintType.list,
      ),
    );
  }

  if (template == 'server') {
    var flutterDir = Directory(p.join(projectDir.path, '${name}_flutter'));
    if (verbose) {
      log.debug(
        'Creating directory: ${flutterDir.path}',
        style: const PrettyPrint(
          type: PrettyPrintType.list,
        ),
      );
    }
    flutterDir.createSync();

    var githubDir = Directory(p.join(projectDir.path, '.github'));
    if (verbose) {
      log.debug(
        'Creating directory: ${githubDir.path}',
        style: const PrettyPrint(
          type: PrettyPrintType.list,
        ),
      );
    }
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
          slotName: '#--CONDITIONAL_COMMENT--#',
          replacement: '',
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
          slotName: 'DB_STAGING_PASSWORD',
          replacement: dbStagingPassword,
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
        Replacement(
          slotName: 'gcloudignore',
          replacement: '.gcloudignore',
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
          slotName: '#--CONDITIONAL_COMMENT--#',
          replacement: '',
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
          slotName: '#--CONDITIONAL_COMMENT--#',
          replacement: '',
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
      removePrefixes: [
        'path: ../../../packages/serverpod_flutter',
      ],
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
          slotName: '#--CONDITIONAL_COMMENT--#',
          replacement: '',
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
          slotName: '#--CONDITIONAL_COMMENT--#',
          replacement: '',
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
    log.warning(
        'Unknown template: $template (valid options are "server" or "module")');
  }

  if (dockerConfigured && template != 'module') {
    if (Platform.isWindows) {
      await CommandLineTools.cleanupForWindows(projectDir, name);
      _logSuccessMessage();
      log.info(
        'cd .\\${p.join(name, '${name}_server')}\\',
        style: const PrettyPrint(
            type: PrettyPrintType.command, newParagraph: true),
      );
      log.info(
        '.\\setup-tables.cmd',
        style: const PrettyPrint(type: PrettyPrintType.command),
      );
      log.info(
        'docker compose up --build --detach',
        style: const PrettyPrint(type: PrettyPrintType.command),
      );
      log.info(
        'dart .\\bin\\main.dart',
        style: const PrettyPrint(type: PrettyPrintType.command),
      );
    } else {
      // Create tables
      await CommandLineTools.createTables(projectDir, name);
      _logSuccessMessage();
      log.info(
        'cd ${p.join(name, '${name}_server')}',
        style: const PrettyPrint(
            type: PrettyPrintType.command, newParagraph: true),
      );
      log.info(
        'docker compose up --build --detach',
        style: const PrettyPrint(type: PrettyPrintType.command),
      );
      log.info(
        'dart dart bin/main.dart',
        style: const PrettyPrint(type: PrettyPrintType.command),
      );
    }
  }
}

void _logSuccessMessage() {
  log.info('SERVERPOD CREATED 🥳',
      style:
          const PrettyPrint(newParagraph: true, type: PrettyPrintType.success));
  log.info(
    'All setup. You are ready to rock!',
    style: const PrettyPrint(newParagraph: true, type: PrettyPrintType.success),
  );
  log.info(
    'Start your Serverpod by running:',
    style: const PrettyPrint(newParagraph: true),
  );
}
