import 'dart:io';
import 'dart:math' as math;

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/database_setup.dart';
import 'package:serverpod_cli/src/create/generate_files.dart';
import 'package:serverpod_cli/src/downloads/resource_manager.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/entitlements_modifier.dart';
import 'package:serverpod_cli/src/util/project_name.dart';
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
  bool force,
) async {
  // If the name is a dot, we are upgrading an existing project
  // Instead of creating a new one, we try to upgrade the current directory.
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

  // Create workspace configuration first, before flutter create
  success &= await log.progress('Creating workspace configuration.', () async {
    _createWorkspacePubspec(
      serverpodDirs,
      name: name,
      template: template,
      customServerpodPath: productionMode ? null : serverpodHome,
    );
    return true;
  });

  if (template == ServerpodTemplateType.server ||
      template == ServerpodTemplateType.mini) {
    success &=
        await log.progress('Getting Flutter app package dependencies.', () {
      return CommandLineTools.flutterCreate(serverpodDirs.flutterDir);
    });

    // Copy our Flutter template files over the flutter create files
    success &= await log.progress('Applying Flutter template.', () async {
      _copyFlutterTemplateFiles(
        serverpodDirs,
        name: name,
        customServerpodPath: productionMode ? null : serverpodHome,
      );
      return true;
    });

    await log.progress('Updating Flutter app MacOS entitlements.', () {
      return EntitlementsModifier.addNetworkToEntitlements(
          serverpodDirs.flutterDir);
    });
  }

  success &= await log.progress('Getting workspace dependencies.', () {
    return CommandLineTools.dartPubGet(serverpodDirs.projectDir);
  });

  success &= await log.progress('Running serverpod generator', () async {
    return await GenerateFiles.generateFiles(serverpodDirs.serverDir);
  });

  if (template == ServerpodTemplateType.server ||
      template == ServerpodTemplateType.module) {
    success &= await log.progress('Creating default database migration.', () {
      return DatabaseSetup.createDefaultMigration(
        serverpodDirs.serverDir,
        name,
      );
    });
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

  success &= await log.progress('Running serverpod generator', () async {
    return await GenerateFiles.generateFiles(serverpodDir.serverDir);
  });

  success &= await log.progress('Creating default database migration.', () {
    return DatabaseSetup.createDefaultMigration(
      serverpodDir.serverDir,
      name,
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

  if (template == ServerpodTemplateType.server ||
      template == ServerpodTemplateType.mini) {
    _createDirectory(serverpodDirs.flutterDir);
  }

  if (template == ServerpodTemplateType.server) {
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
          replacement: generateRandomString(),
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

void _createWorkspacePubspec(
  ServerpodDirectories serverpodDirs, {
  required String name,
  required ServerpodTemplateType template,
  String? customServerpodPath,
}) {
  log.debug('Creating workspace pubspec.yaml', newParagraph: true);

  // Determine workspace members based on template type
  List<String> workspaceMembers;
  if (template == ServerpodTemplateType.module) {
    workspaceMembers = [
      '${name}_server',
      '${name}_client',
    ];
  } else {
    // Server or mini template
    workspaceMembers = [
      '${name}_server',
      '${name}_client',
      '${name}_flutter',
    ];
  }

  // Generate workspace members YAML list
  var workspaceMembersYaml =
      workspaceMembers.map((member) => '  - $member').join('\n');

  // Generate dependency overrides for development mode
  var dependencyOverridesYaml = '';
  if (customServerpodPath != null) {
    dependencyOverridesYaml = '''

dependency_overrides:
  serverpod:
    path: $customServerpodPath/packages/serverpod
  serverpod_client:
    path: $customServerpodPath/packages/serverpod_client
  serverpod_flutter:
    path: $customServerpodPath/packages/serverpod_flutter
  serverpod_serialization:
    path: $customServerpodPath/packages/serverpod_serialization
  serverpod_shared:
    path: $customServerpodPath/packages/serverpod_shared
  serverpod_service_client:
    path: $customServerpodPath/packages/serverpod_service_client
  serverpod_test:
    path: $customServerpodPath/packages/serverpod_test''';
  }

  // Read the workspace template
  var templatePath = p.join(
    resourceManager.templateDirectory.path,
    'workspace_pubspec.yaml',
  );
  var templateFile = File(templatePath);
  var contents = templateFile.readAsStringSync();

  // Replace the placeholders
  contents = contents.replaceAll('{{WORKSPACE_MEMBERS}}', workspaceMembersYaml);
  contents =
      contents.replaceAll('{{DEPENDENCY_OVERRIDES}}', dependencyOverridesYaml);

  // Write the workspace pubspec.yaml
  var workspacePubspecPath =
      p.join(serverpodDirs.projectDir.path, 'pubspec.yaml');
  var workspacePubspecFile = File(workspacePubspecPath);
  workspacePubspecFile.writeAsStringSync(contents);
}

void _copyFlutterTemplateFiles(
  ServerpodDirectories serverpodDirs, {
  required String name,
  String? customServerpodPath,
}) {
  log.debug('Copying Flutter template files', newParagraph: true);

  // Copy just the files we need from our template, preserving flutter create's platform files
  var templateDir = Directory(
      p.join(resourceManager.templateDirectory.path, 'projectname_flutter'));

  // Copy pubspec.yaml
  var srcPubspec = File(p.join(templateDir.path, 'pubspec.yaml'));
  var dstPubspec = File(p.join(serverpodDirs.flutterDir.path, 'pubspec.yaml'));
  var pubspecContent = srcPubspec.readAsStringSync();

  // Apply replacements
  pubspecContent = pubspecContent.replaceAll('projectname', name);
  if (customServerpodPath != null) {
    pubspecContent = pubspecContent.replaceAll(
      'path: ../../../packages/',
      'path: $customServerpodPath/packages/',
    );
  }

  // Add resolution: workspace after the description line
  var lines = pubspecContent.split('\n');
  var newLines = <String>[];
  for (var i = 0; i < lines.length; i++) {
    newLines.add(lines[i]);
    if (lines[i].startsWith('description:')) {
      newLines.add('resolution: workspace');
    }
  }
  pubspecContent = newLines.join('\n');

  dstPubspec.writeAsStringSync(pubspecContent);

  // Copy lib directory
  var copier = Copier(
    srcDir: Directory(p.join(templateDir.path, 'lib')),
    dstDir: Directory(p.join(serverpodDirs.flutterDir.path, 'lib')),
    replacements: [
      Replacement(
        slotName: 'projectname',
        replacement: name,
      ),
    ],
    fileNameReplacements: [],
  );
  copier.copyFiles();
}
