import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/database_setup.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'copier.dart';

enum ServerpodTemplateType {
  mini('mini'),
  server('server'),
  module('module');

  final String name;
  const ServerpodTemplateType(this.name);

  static ServerpodTemplateType? tryParse(String text) {
    for (var templateType in ServerpodTemplateType.values) {
      if (templateType.name == text) {
        return templateType;
      }
    }
    return null;
  }
}

Future<bool> performCreate(
  String name,
  ServerpodTemplateType template,
  bool force,
) async {
  if (name == '.') {
    return await _performUpgrade(template);
  }

  // check if project name is valid
  if (!StringValidators.isValidProjectName(name)) {
    log.error(
      'Invalid project name. Project names can only contain letters, numbers, '
      'and underscores.',
    );
    return false;
  }

  var serverpodDirs = ServerpodDirectories(
    projectDir: Directory(p.join(Directory.current.path, name)),
    name: name,
  );
  if (serverpodDirs.projectDir.existsSync()) {
    log.error('Project $name already exists.');
    return false;
  }

  if (template == ServerpodTemplateType.module) {
    log.info(
      'Creating Serverpod module "$name".',
      type: TextLogType.init,
    );
  } else {
    log.info(
      'Creating Serverpod project "$name".',
      type: TextLogType.init,
    );
  }

  bool success = await log.progress(
    'Creating project directories.',
    () async {
      _createProjectDirectories(template, serverpodDirs);
      return true;
    },
    newParagraph: true,
  );

  if (template == ServerpodTemplateType.server ||
      template == ServerpodTemplateType.mini) {
    success &= await log.progress(
      'Writing project files.',
      () async {
        _copyServerTemplates(
          serverpodDirs,
          name: name,
          customServerpodPath: productionMode ? null : serverpodHome,
        );
        return true;
      },
    );
  }

  if (template == ServerpodTemplateType.server) {
    success &= await log.progress(
      'Writing additional project files.',
      () async {
        _copyServerUpgrade(
          serverpodDirs,
          name: name,
        );
        return true;
      },
    );
  }

  if (template == ServerpodTemplateType.server ||
      template == ServerpodTemplateType.mini) {
    success &= await log.progress('Getting server package dependencies.', () {
      return CommandLineTools.dartPubGet(serverpodDirs.serverDir);
    });
    success &= await log.progress('Getting client package dependencies.', () {
      return CommandLineTools.dartPubGet(serverpodDirs.clientDir);
    });
    success &=
        await log.progress('Getting Flutter app package dependencies.', () {
      return CommandLineTools.flutterCreate(serverpodDirs.flutterDir);
    });

    success &= await log.progress('Creating default database migration.', () {
      return DatabaseSetup.createDefaultMigration(
        serverpodDirs.serverDir,
        name,
      );
    });
  } else if (template == ServerpodTemplateType.module) {
    success &= await log.progress(
        'Writing project files.',
        () => Future(() {
              _copyModuleTemplates(
                serverpodDirs,
                name: name,
                customServerpodPath: productionMode ? null : serverpodHome,
              );
              return true;
            }));
  }

  if (success || force) {
    log.info(
      'Serverpod project created.',
      newParagraph: true,
      type: TextLogType.success,
    );

    if (template == ServerpodTemplateType.server) {
      _logStartInstructions(name);
    } else if (template == ServerpodTemplateType.mini) {
      _logMiniStartInstructions(name);
    }
  }

  return success;
}

Future<bool> _performUpgrade(ServerpodTemplateType template) async {
  if (template != ServerpodTemplateType.server) {
    log.error(
      'The upgrade command can only be used with server templates.',
    );
    return false;
  }

  var serverDir = findServerDirectory(Directory.current);
  if (serverDir == null) {
    log.error(
      'Could not find a Serverpod project in the current directory.',
    );
    return false;
  }

  var name = await getProjectName(serverDir);
  if (name == null) {
    log.error(
      'Could not find a project name in the pubspec.yaml file.',
    );
    return false;
  }

  var serverpodDir = ServerpodDirectories(
    name: name,
    projectDir: serverDir.parent,
  );

  var success = true;
  success &= await log.progress(
    'Upgrading project.',
    () async {
      _copyServerUpgrade(
        serverpodDir,
        name: name,
        skipMain: true,
      );
      return true;
    },
  );

  if (success) {
    log.info(
      'Serverpod project upgraded.',
      newParagraph: true,
      type: TextLogType.success,
    );

    _logStartInstructions(name);
  }

  return success;
}

void _logMiniStartInstructions(String name) {
  log.info(
    'All setup. You are ready to rock! 🥳',
    type: TextLogType.header,
  );
  log.info(
    'Start your Serverpod by running:',
    type: TextLogType.header,
  );

  if (Platform.isWindows) {
    log.info(
      'cd .\\${p.join(name, '${name}_server')}\\',
      type: TextLogType.command,
      newParagraph: true,
    );
    log.info(
      'dart .\\bin\\main.dart',
      type: TextLogType.command,
    );
  } else {
    log.info(
      'cd ${p.join(name, '${name}_server')}',
      type: TextLogType.command,
      newParagraph: true,
    );
    log.info(
      'dart bin/main.dart',
      type: TextLogType.command,
    );
  }

  log.info(' ');
}

void _logStartInstructions(String name) {
  log.info(
    'All setup. You are ready to rock! 🥳',
    type: TextLogType.header,
  );
  log.info(
    'Start your Serverpod by running:',
    type: TextLogType.header,
  );

  if (Platform.isWindows) {
    log.info(
      'cd .\\${p.join(name, '${name}_server')}\\',
      type: TextLogType.command,
      newParagraph: true,
    );
    log.info(
      'docker compose up --build --detach',
      type: TextLogType.command,
    );
    log.info(
      'dart .\\bin\\main.dart --apply-migrations',
      type: TextLogType.command,
    );
  } else {
    log.info(
      'cd ${p.join(name, '${name}_server')}',
      type: TextLogType.command,
      newParagraph: true,
    );
    log.info(
      'docker compose up --build --detach',
      type: TextLogType.command,
    );
    log.info(
      'dart bin/main.dart --apply-migrations',
      type: TextLogType.command,
    );
  }

  log.info(' ');
}

class ServerpodDirectories {
  final Directory projectDir;
  final Directory serverDir;
  final Directory clientDir;
  final Directory flutterDir;
  final Directory githubDir;

  ServerpodDirectories({required this.projectDir, required String name})
      : serverDir = Directory(p.join(projectDir.path, '${name}_server')),
        clientDir = Directory(p.join(projectDir.path, '${name}_client')),
        flutterDir = Directory(p.join(projectDir.path, '${name}_flutter')),
        githubDir = Directory(p.join(projectDir.path, '.github'));
}

void _createProjectDirectories(
  ServerpodTemplateType template,
  ServerpodDirectories serverpodDirs,
) {
  _createDirectory(serverpodDirs.projectDir);
  _createDirectory(serverpodDirs.serverDir);
  _createDirectory(serverpodDirs.clientDir);

  if (template == ServerpodTemplateType.server) {
    _createDirectory(serverpodDirs.flutterDir);
    _createDirectory(serverpodDirs.githubDir);
  }
}

void _createDirectory(Directory dir) {
  log.debug(
    'Creating directory: ${dir.path}',
    type: TextLogType.bullet,
  );
  dir.createSync();
}

void _copyServerUpgrade(
  ServerpodDirectories serverpodDirs, {
  required String name,
  bool skipMain = false,
}) {
  var dbPassword = generateRandomString();
  var dbProductionPassword = generateRandomString();
  var dbStagingPassword = generateRandomString();

  var awsName = name.replaceAll('_', '-');
  var randomAwsId = math.Random.secure().nextInt(10000000).toString();

  log.debug('Copying upgrade files.', newParagraph: true);
  var copier = Copier(
      srcDir: Directory(p.join(resourceManager.templateDirectory.path,
          'projectname_server_upgrade')),
      dstDir: serverpodDirs.serverDir,
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
          slotName: 'gcloudignore',
          replacement: '.gcloudignore',
        ),
      ],
      ignoreFileNames: [
        if (skipMain) 'server.dart'
      ]);
  copier.copyFiles();

  log.debug('Copying .github files', newParagraph: true);
  copier = Copier(
    srcDir: Directory(p.join(resourceManager.templateDirectory.path, 'github')),
    dstDir: serverpodDirs.githubDir,
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
  );
  copier.copyFiles();
}

void _copyServerTemplates(
  ServerpodDirectories serverpodDirs, {
  required String name,
  String? customServerpodPath,
}) {
  log.debug('Copying server files');
  var copier = Copier(
    srcDir: Directory(
        p.join(resourceManager.templateDirectory.path, 'projectname_server')),
    dstDir: serverpodDirs.serverDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
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
    ignoreFileNames: ['pubspec.lock'],
  );
  copier.copyFiles();

  log.debug('Copying client files', newParagraph: true);
  copier = Copier(
    srcDir: Directory(
        p.join(resourceManager.templateDirectory.path, 'projectname_client')),
    dstDir: serverpodDirs.clientDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
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
    ignoreFileNames: ['pubspec.lock'],
  );
  copier.copyFiles();

  log.debug('Copying Flutter files', newParagraph: true);
  copier = Copier(
    srcDir: Directory(
        p.join(resourceManager.templateDirectory.path, 'projectname_flutter')),
    dstDir: serverpodDirs.flutterDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
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
    ignoreFileNames: [
      'pubspec.lock',
      'ios',
      'android',
      'web',
      'macos',
      'build',
    ],
  );
  copier.copyFiles();
}

void _copyModuleTemplates(
  ServerpodDirectories serverpodDirs, {
  required String name,
  String? customServerpodPath,
}) {
  log.debug('Copying server files', newParagraph: true);
  var copier = Copier(
    srcDir: Directory(
        p.join(resourceManager.templateDirectory.path, 'modulename_server')),
    dstDir: serverpodDirs.serverDir,
    replacements: [
      Replacement(
        slotName: 'modulename',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
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
    ignoreFileNames: ['pubspec.lock'],
  );
  copier.copyFiles();

  log.debug('Copying client files', newParagraph: true);
  copier = Copier(
    srcDir: Directory(
        p.join(resourceManager.templateDirectory.path, 'modulename_client')),
    dstDir: serverpodDirs.clientDir,
    replacements: [
      Replacement(
        slotName: 'modulename',
        replacement: name,
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/',
          replacement: 'path: $customServerpodPath/packages/',
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
    ignoreFileNames: ['pubspec.lock'],
  );
  copier.copyFiles();
}
