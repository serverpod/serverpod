import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:uuid/uuid.dart';

final resourceManager = ResourceManager();

class ResourceManager {
  Directory get localStorageDirectory =>
      Directory(p.join(LocalStorageManager.homeDirectory.path, '.serverpod'));

  Directory get versionedDir =>
      Directory(p.join(localStorageDirectory.path, templateVersion));

  Directory get templateDirectory {
    if (productionMode) {
      return Directory(p.join(versionedDir.path, 'serverpod_template'));
    } else {
      return Directory(
        p.join(serverpodHome, 'templates', 'serverpod_templates'),
      );
    }
  }

  String get uniqueUserId {
    const uuidFilePath = 'uuid';
    try {
      var userIdFile = File(p.join(localStorageDirectory.path, uuidFilePath));
      var userId = userIdFile.readAsStringSync();
      return userId;
    } catch (e) {
      // Failed to read userId from file, it's probably not created.
    }
    var userId = const Uuid().v4();
    try {
      var userIdFile = File(p.join(localStorageDirectory.path, uuidFilePath));
      userIdFile.createSync(recursive: true);
      userIdFile.writeAsStringSync(userId);
    } finally {}

    return userId;
  }

  Future<void> storeLatestCliVersion(
    PackageVersionData cliVersionData, {
    String? localStoragePath,
  }) async {
    localStoragePath ??= localStorageDirectory.path;

    try {
      await LocalStorageManager.storeJsonFile(
        fileName: ResourceManagerConstants.latestVersionFilePath,
        json: cliVersionData.toJson(),
        localStoragePath: localStoragePath,
      );
    } catch (e) {
      // Failed to store latest cli version to file.
      // Silently ignore since users can't do anything about it.
    }
  }

  Future<PackageVersionData?> tryFetchLatestCliVersion({
    String? localStoragePath,
  }) async {
    localStoragePath ??= localStorageDirectory.path;

    void deleteFile(File file) {
      try {
        file.deleteSync();
      } catch (_) {
        // Failed to delete file.
        // Silently ignore since users can't do anything about it.
      }
    }

    try {
      return await LocalStorageManager.tryFetchAndDeserializeJsonFile(
        fileName: ResourceManagerConstants.latestVersionFilePath,
        localStoragePath: localStoragePath,
        fromJson: PackageVersionData.fromJson,
      );
    } on ReadException catch (e) {
      deleteFile(e.file);
    } on DeserializationException catch (e) {
      deleteFile(e.file);
    }

    return null;
  }

  String get packageDownloadUrl =>
      'https://pub.dev/packages/serverpod_templates/versions/$templateVersion.tar.gz';

  bool get isTemplatesInstalled {
    if (!versionedDir.existsSync() && productionMode) return false;

    return templateDirectory.existsSync();
  }

  Future<void> installTemplates() async {
    log.info('Downloading templates for version $templateVersion');
    if (!versionedDir.existsSync()) versionedDir.createSync(recursive: true);

    var response = await http.get(Uri.parse(packageDownloadUrl));
    var data = response.bodyBytes;

    // var outFile = File(p.join(versionedDir.path, 'serverpod_templates.tar.gz'));
    // outFile.writeAsBytesSync(data);

    // Const constructor was introduced in version 4.0.0 of archive package.
    // At the time this was written, that version was 2 days old and we don't
    // want to force a constraint on the package for this.
    // ignore: prefer_const_constructors
    var unzipped = GZipDecoder().decodeBytes(data);
    var archive = TarDecoder().decodeBytes(unzipped);

    for (var file in archive) {
      var outFileName = p.join(templateDirectory.path, file.name);
      if (file.isFile) {
        var outFile = File(outFileName);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      } else {
        await Directory(outFileName).create(recursive: true);
      }
    }
    log.info('Download complete.');
  }
}
