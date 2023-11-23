import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/test_util/builders/migration_version_builder.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  var testAssetsPath = path.join('test', 'migrations', 'test_assets');
  var tempDirectory = Directory(path.join(testAssetsPath, 'temp'));

  setUp(() {
    tempDirectory.createSync();
  });

  tearDown(() {
    tempDirectory.deleteSync(recursive: true);
  });

  test(
      'Given an existing directory when writing migration version with same name then exception is thrown.',
      () async {
    var versionName = '00000000000000';
    var versionDirectory = Directory(path.join(
      tempDirectory.path,
      versionName,
    ));
    versionDirectory.createSync();

    var migrationVersion = MigrationVersionBuilder()
        .withMigrationsDirectory(tempDirectory)
        .withVersionName(versionName)
        .build();

    expect(
      () => migrationVersion.write(module: 'test_module'),
      throwsA(isA<MigrationVersionAlreadyExistsException>()),
    );
  });
}
