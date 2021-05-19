import 'dart:io';

import '../create/copier.dart';

void performGeneratePubspecs (String version, String mode) {
  // Verify that we are in the serverpod directory
  var dirPackages = Directory('packages');
  var dirTemplates = Directory('templates/pubspecs');
  var dirRoot = Directory('.');

  if (!dirPackages.existsSync() || !dirTemplates.existsSync() || !dirRoot.existsSync()) {
    print('Must be run from the serverpod repository root');
    return;
  }

  print('Doing some fancy generation');

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
          replacement: '# This file is generated. Do not modify, instead edit the files in the templates/pubspecs directory.\n# Mode: $mode',
        ),
      ],
      fileNameReplacements: [],
    );
    copier.copyFiles();
  }
  else {
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
          replacement: '# This file is generated. Do not modify, instead edit the files in the templates/pubspecs directory.\n# Mode: $mode',
        ),
        Replacement(
          slotName: '#^',
          replacement: '^',
        ),
      ],
      fileNameReplacements: [],
      removePrefixes: ['path', 'serverpod_test_client'],
    );
    copier.copyFiles();
  }
}