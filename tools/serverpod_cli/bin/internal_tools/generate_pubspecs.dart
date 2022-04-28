import 'dart:io';

import '../create/copier.dart';

void performGeneratePubspecs(String version, String mode) {
  // Verify that we are in the serverpod directory
  Directory dirPackages = Directory('packages');
  Directory dirTemplates = Directory('templates/pubspecs');
  Directory dirRoot = Directory('.');

  if (!dirPackages.existsSync() ||
      !dirTemplates.existsSync() ||
      !dirRoot.existsSync()) {
    print('Must be run from the serverpod repository root');
    return;
  }

  print('Doing some fancy generation');

  if (mode == 'development') {
    // Development mode
    Copier copier = Copier(
      srcDir: dirTemplates,
      dstDir: dirRoot,
      replacements: <Replacement>[
        Replacement(
          slotName: 'PUBLISH_TO',
          replacement: 'publish_to: none',
        ),
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
          replacement: 'false',
        ),
      ],
      fileNameReplacements: <Replacement>[],
    );
    copier.copyFiles();
  } else {
    // Production mode
    Copier copier = Copier(
      srcDir: dirTemplates,
      dstDir: dirRoot,
      replacements: <Replacement>[
        Replacement(
          slotName: 'PUBLISH_TO',
          replacement: '',
        ),
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
          slotName: '#^',
          replacement: '^',
        ),
        Replacement(
          slotName: 'PRODUCTION_MODE',
          replacement: 'true',
        ),
      ],
      fileNameReplacements: <Replacement>[],
      removePrefixes: <String>['path'],
    );
    copier.copyFiles();
  }
}
