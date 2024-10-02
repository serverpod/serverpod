import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given missing templates folder when loading templates then no templates are loaded',
      () async {
    Templates templates = Templates();
    var uniqueUuid = const Uuid().v4();
    var nonExistingDirectory =
        Directory(path.joinAll([uniqueUuid, 'non-existing-directory']));

    await templates.loadAll(nonExistingDirectory);

    expect(templates, isEmpty);
  });
}
