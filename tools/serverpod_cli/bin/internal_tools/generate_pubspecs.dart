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

  var copier = Copier(
    srcDir: dirTemplates,
    dstDir: dirRoot,
    replacements: [
      Replacement(
        slotName: 'VERSION',
        replacement: version,
      ),
    ],
    fileNameReplacements: [],
  );

  copier.copyFiles();
}