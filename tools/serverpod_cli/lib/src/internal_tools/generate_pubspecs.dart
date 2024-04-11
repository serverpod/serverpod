import 'dart:io';

import 'package:serverpod_cli/src/logger/logger.dart';

import '../create/copier.dart';

/// The internal tool for generating the pubspec.yaml files in the Serverpod
/// repo.
void performGeneratePubspecs({
  required String version,
  required String dartVersion,
  required String flutterVersion,
  required String mode,
}) {
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

  var sharedReplacements = [
    Replacement(
      slotName: 'SERVERPOD_VERSION',
      replacement: version,
    ),
    Replacement(
      slotName: 'DART_VERSION',
      replacement: dartVersion,
    ),
    Replacement(
      slotName: 'FLUTTER_VERSION',
      replacement: flutterVersion,
    ),
    Replacement(
      slotName: '# TEMPLATE',
      replacement:
          '# This file is generated. Do not modify, instead edit the files '
          'in the templates/pubspecs directory.\n# Mode: $mode',
    ),
  ];

  if (mode == 'development') {
    // Development mode
    var copier = Copier(
      srcDir: dirTemplates,
      dstDir: dirRoot,
      replacements: [
        ...sharedReplacements,
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
        ...sharedReplacements,
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
