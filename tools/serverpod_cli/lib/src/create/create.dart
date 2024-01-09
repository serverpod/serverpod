import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/database_setup.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'copier.dart';

enum ServerpodTemplateType {
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
  // check if project name is valid
  if (!StringValidators.isValidProjectName(name)) {
    log.error(
      'Invalid project name. Project names can only contain letters, numbers, '
      'and underscores.',
    );
    return false;
  }

  var dbPassword = generateRandomString();
  var dbProductionPassword = generateRandomString();
  var dbStagingPassword = generateRandomString();

  var awsName = name.replaceAll('_', '-');
  var randomAwsId = math.Random.secure().nextInt(10000000).toString();

  var serverpodDirs = ServerpodDirectories(
    projectDir: Directory(p.join(Directory.current.path, name)),
    name: name,
  );
  if (serverpodDirs.projectDir.existsSync()) {
    log.error('Project $name already exists.');
    return false;
  }

  if (template == ServerpodTemplateType.server) {
    log.info(
      'Creating Serverpod project "$name".',
      type: TextLogType.init,
    );
  } else if (template == ServerpodTemplateType.module) {
    log.info(
      'Creating Serverpod module "$name".',
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

  if (template == ServerpodTemplateType.server) {
    success &= await log.progress(
      'Writing project files.',
      () async {
        _copyServerTemplates(
          serverpodDirs,
          name: name,
          awsName: awsName,
          randomAwsId: randomAwsId,
          dbPassword: dbPassword,
          dbProductionPassword: dbProductionPassword,
          dbStagingPassword: dbStagingPassword,
          customServerpodPath: productionMode ? null : serverpodHome,
        );
        return true;
      },
    );

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
              _copyModuleTemplates(serverpodDirs, name: name);
              return true;
            }));
  }

  if (success || force) {
    log.info(
      'Serverpod created.',
      newParagraph: true,
      type: TextLogType.success,
    );

    if (template == ServerpodTemplateType.server) {
      _logStartInstructions(name);
    }
  }

  return success;
}

void _logStartInstructions(name) {
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

void _copyServerTemplates(
  ServerpodDirectories serverpodDirs, {
  required String name,
  required String awsName,
  required String randomAwsId,
  required String dbPassword,
  required String dbProductionPassword,
  required String dbStagingPassword,
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
        replacement: customServerpodPath == null ? templateVersion : '',
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
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/serverpod',
          replacement: 'path: $customServerpodPath/packages/serverpod',
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
    removePrefixes: [
      if (customServerpodPath == null) 'path',
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
      Replacement(
        slotName: '#--CONDITIONAL_COMMENT--#',
        replacement: '',
      ),
      Replacement(
        slotName: 'VERSION',
        replacement: customServerpodPath == null ? templateVersion : '',
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/serverpod_client',
          replacement: 'path: $customServerpodPath/packages/serverpod_client',
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
      if (customServerpodPath == null) 'path',
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
      Replacement(
        slotName: '#--CONDITIONAL_COMMENT--#',
        replacement: '',
      ),
      Replacement(
        slotName: 'VERSION',
        replacement: customServerpodPath == null ? templateVersion : '',
      ),
      if (customServerpodPath != null)
        Replacement(
          slotName: 'path: ../../../packages/serverpod_flutter',
          replacement: 'path: $customServerpodPath/packages/serverpod_flutter',
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
      if (customServerpodPath == null)
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
  );
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

void _copyModuleTemplates(
  ServerpodDirectories serverpodDirs, {
  required String name,
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
  );
  copier.copyFiles();
}
