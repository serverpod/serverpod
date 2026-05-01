import 'dart:io';

import 'package:serverpod_cli/src/util/cli_instrumentation.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../create/copier.dart';

/// The internal tool for generating the pubspec.yaml files in the Serverpod
/// repo.
Future<void> performGeneratePubspecs({
  required String version,
  required String dartVersion,
  required String flutterVersion,
  required String mode,
}) async {
  cliInstrument('generate_pubspecs', 'enter cwd=${Directory.current.path}');

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

  cliInstrument('generate_pubspecs', 'layout ok; before log.info');
  log.info('Doing some fancy generation');
  await log.flush();
  cliInstrument('generate_pubspecs', 'after log.info flush');

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
        ),
      ],
      fileNameReplacements: [],
      processUncommentMarker: false,
    );
    copier.copyFiles();
    cliInstrument(
      'generate_pubspecs',
      'development copier.copyFiles() returned',
    );
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
      processUncommentMarker: false,
    );
    copier.copyFiles();
    cliInstrument(
      'generate_pubspecs',
      'production copier.copyFiles() returned',
    );
  }
  cliInstrument('generate_pubspecs', 'exit');
}
