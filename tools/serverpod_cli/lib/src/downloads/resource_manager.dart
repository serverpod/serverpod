import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/shared/environment.dart';

final resourceManager = ResourceManager();

class ResourceManager {
  Directory get homeDirectory {
    var envVars = Platform.environment;

    if (Platform.isWindows) {
      return Directory(envVars['UserProfile']!);
    } else if (Platform.isLinux || Platform.isMacOS) {
      return Directory(envVars['HOME']!);
    }
    throw (Exception('Unsupported platform.'));
  }

  Directory get localStorageDirectory =>
      Directory(p.join(homeDirectory.path, '.serverpod'));

  Directory get versionedDir =>
      Directory(p.join(localStorageDirectory.path, templateVersion));

  Directory get templateDirectory {
    if (productionMode) {
      return Directory(p.join(versionedDir.path, 'serverpod_template'));
    } else {
      return Directory(
          p.join(serverpodHome, 'templates', 'serverpod_templates'));
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
    CliVersionData cliVersionData, {
    String? localStoragePath,
  }) async {
    localStoragePath ??= localStorageDirectory.path;
    var latestCliVersionFile = File(p.join(
      localStoragePath,
      ResourceManagerConstants.latestVersionFilePath,
    ));

    try {
      if (!latestCliVersionFile.existsSync()) {
        latestCliVersionFile.createSync(recursive: true);
      }

      var json = jsonEncode(cliVersionData);

      latestCliVersionFile.writeAsStringSync(json);
    } catch (e) {
      // Failed to write latest cli version to file.
    }
  }

  Future<CliVersionData?> tryFetchLatestCliVersion({
    String? localStoragePath,
  }) async {
    localStoragePath ??= localStorageDirectory.path;
    var latestCliVersionFile = File(p.join(
      localStoragePath,
      ResourceManagerConstants.latestVersionFilePath,
    ));

    try {
      if (latestCliVersionFile.existsSync()) {
        var json = jsonDecode(latestCliVersionFile.readAsStringSync());
        return CliVersionData.fromJson(json);
      }
    } catch (e) {
      // Failed to read latest cli version from file.
    }

    // If the file exists it might be corrupted so we delete it.
    if (latestCliVersionFile.existsSync()) {
      try {
        latestCliVersionFile.deleteSync();
      } catch (e) {
        // Failed to delete file
      }
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

class CliVersionData {
  Version version;
  DateTime validUntil;

  CliVersionData(this.version, this.validUntil);

  factory CliVersionData.fromJson(Map<String, dynamic> json) => CliVersionData(
        Version.parse(json['version']),
        DateTime.fromMillisecondsSinceEpoch(json['valid_until']),
      );

  Map<String, dynamic> toJson() => {
        'version': version.toString(),
        'valid_until': validUntil.millisecondsSinceEpoch
      };
}
