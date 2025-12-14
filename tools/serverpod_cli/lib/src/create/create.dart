import 'dart:io';
import 'dart:math' as math;

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/create/database_setup.dart';
import 'package:serverpod_cli/src/create/generate_files.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/entitlements_modifier.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
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
  bool force, {
  required bool? interactive,
}) async {
  // If the name is a dot, we are upgrading an existing project
  // Instead of creating a new one, we try to upgrade the current directory.
  if (name == '.') {
    return await _performUpgrade(template, interactive: interactive);
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
      }),
    );
  }

  if (template == ServerpodTemplateType.server) {
    success &= await log.progress(
      'Writing additional project files.',
      () async {
        await _copyServerUpgrade(
          serverpodDirs,
          name: name,
          isUpgrade: false,
          customServerpodPath: productionMode ? null : serverpodHome,
        );
        await _copyFlutterUpgrade(
          serverpodDirs,
          name: name,
          customServerpodPath: productionMode ? null : serverpodHome,
        );
        return true;
      },
    );
  }

  success &= await log.progress('Getting server package dependencies.', () {
    return CommandLineTools.dartPubGet(serverpodDirs.serverDir);
  });

  success &= await log.progress('Getting client package dependencies.', () {
    return CommandLineTools.dartPubGet(serverpodDirs.clientDir);
  });

  if (template == ServerpodTemplateType.server ||
      template == ServerpodTemplateType.mini) {
    success &= await log.progress(
      'Getting Flutter app package dependencies.',
      () {
        return CommandLineTools.flutterCreate(serverpodDirs.flutterDir);
      },
    );
    await log.progress('Updating Flutter app MacOS entitlements.', () {
      return EntitlementsModifier.addNetworkToEntitlements(
        serverpodDirs.flutterDir,
      );
    });
  }

  success &= await log.progress('Running serverpod generator', () async {
    return await GenerateFiles.generateFiles(
      serverpodDirs.serverDir,
      interactive: interactive,
    );
  });

  if (template == ServerpodTemplateType.server ||
      template == ServerpodTemplateType.module) {
    success &= await log.progress('Creating default database migration.', () {
      return DatabaseSetup.createDefaultMigration(
        serverpodDirs.serverDir,
        name,
        interactive: interactive,
      );
    });
  }

  if (template == ServerpodTemplateType.server) {
    success &= await log.progress(
      'Building Flutter web app.',
      () {
        return CommandLineTools.flutterBuild(
          serverpodDirs.flutterDir,
          serverpodDirs.serverDir,
        );
      },
    );
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

Future<bool> _performUpgrade(
  ServerpodTemplateType template, {
  required bool? interactive,
}) async {
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
      await _copyServerUpgrade(
        serverpodDir,
        name: name,
        isUpgrade: true,
        customServerpodPath: productionMode ? null : serverpodHome,
      );
      return true;
    },
  );

  success &= await log.progress('Running serverpod generator', () async {
    return await GenerateFiles.generateFiles(
      serverpodDir.serverDir,
      interactive: interactive,
    );
  });

  success &= await log.progress('Creating default database migration.', () {
    return DatabaseSetup.createDefaultMigration(
      serverpodDir.serverDir,
      name,
      interactive: interactive,
    );
  });

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

Future<void> _copyFlutterUpgrade(
  ServerpodDirectories serverpodDirs, {
  required String name,
  String? customServerpodPath,
}) async {
  log.debug('Copying Flutter upgrade files.', newParagraph: true);
  var copier = Copier(
    srcDir: Directory(
      p.join(
        resourceManager.templateDirectory.path,
        'projectname_flutter_upgrade',
      ),
    ),
    dstDir: serverpodDirs.flutterDir,
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
    ],
    fileNameReplacements: const [],
    ignoreFileNames: const [],
  );
  copier.copyFiles();

  log.debug('Adding auth dependencies to Flutter pubspec', newParagraph: true);
  _addDependenciesToPubspec(
    pubspecFile: File(p.join(serverpodDirs.flutterDir.path, 'pubspec.yaml')),
    additions: [
      (
        name: 'serverpod_auth_idp_flutter',
        source: DependencySource.version(
          VersionConstraint.parse(templateVersion),
        ),
        type: DependencyType.normal,
      ),
      (
        name: 'flutter_secure_storage',
        source: DependencySource.version(
          VersionConstraint.parse('^10.0.0'),
        ),
        type: DependencyType.override,
      ),
      if (customServerpodPath != null) ...[
        (
          name: 'serverpod_auth_idp_flutter',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_flutter',
          ),
          type: DependencyType.override,
        ),
        (
          name: 'serverpod_auth_core_client',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_client',
          ),
          type: DependencyType.override,
        ),
        (
          name: 'serverpod_auth_core_flutter',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_flutter',
          ),
          type: DependencyType.override,
        ),
        (
          name: 'serverpod_auth_idp_client',
          source: DependencySourcePath(
            '$customServerpodPath/modules/serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_client',
          ),
          type: DependencyType.override,
        ),
      ],
    ],
  );
}

Future<void> _copyServerUpgrade(
  ServerpodDirectories serverpodDirs, {
  required String name,
  required bool isUpgrade,
  String? customServerpodPath,
}) async {
  var awsName = name.replaceAll('_', '-');
  var randomAwsId = math.Random.secure().nextInt(10000000).toString();

  var dbTestPassword = generateRandomString();
  var redisTestPassword = generateRandomString();

  log.debug('Copying server upgrade files.', newParagraph: true);
  var copier = Copier(
    srcDir: Directory(
      p.join(
        resourceManager.templateDirectory.path,
        'projectname_server_upgrade',
      ),
    ),
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
        slotName: 'SERVICE_SECRET_TEST',
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
        slotName: 'DB_TEST_PASSWORD',
        replacement: dbTestPassword,
      ),
      Replacement(
        slotName: 'DB_PRODUCTION_PASSWORD',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'DB_STAGING_PASSWORD',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'REDIS_PASSWORD',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'REDIS_TEST_PASSWORD',
        replacement: redisTestPassword,
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'SERVER_SIDE_SESSION_KEY_HASH_PEPPER_PRODUCTION',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_DEVELOPMENT',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_TEST',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_STAGING',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'EMAIL_SECRET_HASH_PEPPER_PRODUCTION',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_HMAC_SHA512_PRIVATE_KEY_PRODUCTION',
        replacement: generateRandomString(),
      ),
      Replacement(
        slotName: 'JWT_REFRESH_TOKEN_HASH_PEPPER_PRODUCTION',
        replacement: generateRandomString(),
      ),
    ],
    fileNameReplacements: const [],
    ignoreFileNames: [
      if (isUpgrade) ...[
        'server.dart',
        'email_idp_endpoint.dart',
        'jwt_refresh_endpoint.dart',
      ],
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
      Replacement(
        slotName: 'DB_TEST_PASSWORD',
        replacement: dbTestPassword,
      ),
      Replacement(
        slotName: 'REDIS_TEST_PASSWORD',
        replacement: redisTestPassword,
      ),
      Replacement(
        slotName: 'CLI_VERSION',
        replacement: templateVersion,
      ),
    ],
    fileNameReplacements: [],
  );
  copier.copyFiles();

  if (!isUpgrade) {
    log.debug(
      'Adding auth dependencies to server and client pubspecs',
      newParagraph: true,
    );
    _addDependenciesToPubspec(
      pubspecFile: File(p.join(serverpodDirs.serverDir.path, 'pubspec.yaml')),
      additions: [
        (
          name: 'serverpod_auth_idp_server',
          source: DependencySource.version(
            VersionConstraint.parse(templateVersion),
          ),
          type: DependencyType.normal,
        ),
        if (customServerpodPath != null) ...[
          (
            name: 'serverpod_auth_idp_server',
            source: DependencySourcePath(
              '$customServerpodPath/modules/serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_server',
            ),
            type: DependencyType.override,
          ),
          (
            name: 'serverpod_auth_core_server',
            source: DependencySourcePath(
              '$customServerpodPath/modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_server',
            ),
            type: DependencyType.override,
          ),
        ],
      ],
    );
    _addDependenciesToPubspec(
      pubspecFile: File(p.join(serverpodDirs.clientDir.path, 'pubspec.yaml')),
      additions: [
        (
          name: 'serverpod_auth_idp_client',
          source: DependencySource.version(
            VersionConstraint.parse(templateVersion),
          ),
          type: DependencyType.normal,
        ),
        if (customServerpodPath != null) ...[
          (
            name: 'serverpod_auth_idp_client',
            source: DependencySourcePath(
              '$customServerpodPath/modules/serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_client',
            ),
            type: DependencyType.override,
          ),
          (
            name: 'serverpod_auth_core_client',
            source: DependencySourcePath(
              '$customServerpodPath/modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_client',
            ),
            type: DependencyType.override,
          ),
        ],
      ],
    );
  }
}

void _addDependenciesToPubspec({
  required File pubspecFile,
  required List<DependencyUpdate> additions,
}) {
  if (!pubspecFile.existsSync()) {
    log.debug('Pubspec file not found: ${pubspecFile.path}');
    return;
  }

  var contents = pubspecFile.readAsStringSync();
  contents = addDependencyToPubspec(contents, additions: additions);
  pubspecFile.writeAsStringSync(contents);
}

void _copyServerTemplates(
  ServerpodDirectories serverpodDirs, {
  required String name,
  String? customServerpodPath,
}) {
  log.debug('Copying server files');
  var copier = Copier(
    srcDir: Directory(
      p.join(resourceManager.templateDirectory.path, 'projectname_server'),
    ),
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
      p.join(resourceManager.templateDirectory.path, 'projectname_client'),
    ),
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
      p.join(resourceManager.templateDirectory.path, 'projectname_flutter'),
    ),
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
      p.join(resourceManager.templateDirectory.path, 'modulename_server'),
    ),
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
      p.join(resourceManager.templateDirectory.path, 'modulename_client'),
    ),
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
