import 'dart:io';

import 'package:serverpod_cli/src/logger/logger.dart';

import '../create/copier.dart';

/// The internal tool for generating the pubspec.yaml files in the Serverpod
/// repo.
void performGeneratePubspecs(String version, String mode) {
  // Verify that we are in the serverpod directory
  var dirPackages = Directory('packages');
  var dirTemplates = Directory('templates/pubspecs');
  var dirRoot = Directory('.');

  if (!dirPackages.existsSync() ||
      !dirTemplates.existsSync() ||
      !dirRoot.existsSync()) {
    log.error('Must be run from the serverpod repository root');
    return;
  }

  log.info('Doing some fancy generation');

  if (mode == 'development') {
    // Development mode
    var copier = Copier(
      srcDir: dirTemplates,
      dstDir: dirRoot,
      replacements: [
        Replacement(
          slotName: 'VERSION',
          replacement: version,
        ),
        Replacement(
          slotName: '# TEMPLATE',
          replacement:
              '# This file is generated. Do not modify, instead edit the files '
              'in the templates/pubspecs directory.\n# Mode: $mode',
        ),
        Replacement(
          slotName: 'PRODUCTION_MODE',
          replacement: 'false',
        ),
        Replacement(
          slotName: '#--CONDITIONALLY_REMOVE_LINE--#',
          replacement: '',
        )
      ],
      fileNameReplacements: [],
    );
    copier.copyFiles();
  } else {
    // Production mode
    var copier = Copier(
      srcDir: dirTemplates,
      dstDir: dirRoot,
      replacements: [
        Replacement(
          slotName: 'VERSION',
          replacement: version,
        ),
        Replacement(
          slotName: '# TEMPLATE',
          replacement:
              '# This file is generated. Do not modify, instead edit the files in the templates/pubspecs directory.\n# Mode: $mode',
        ),
        Replacement(
          slotName: 'PRODUCTION_MODE',
          replacement: 'true',
        ),
      ],
      removePatterns: [
        '#--CONDITIONALLY_REMOVE_LINE--#',
      ],
      fileNameReplacements: [],
    );
    copier.copyFiles();
  }
}
