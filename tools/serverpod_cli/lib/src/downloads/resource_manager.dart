import 'dart:io';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

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

  Directory get localCacheDirectory =>
      Directory(p.join(homeDirectory.path, '.serverpod'));

  Directory get versionedDir =>
      Directory(p.join(localCacheDirectory.path, templateVersion));

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
      var userIdFile = File(p.join(localCacheDirectory.path, uuidFilePath));
      var userId = userIdFile.readAsStringSync();
      return userId;
    } catch (e) {
      // Failed to read userId from file, it's probably not created.
    }
    var userId = const Uuid().v4();
    try {
      var userIdFile = File(p.join(localCacheDirectory.path, uuidFilePath));
      userIdFile.createSync(recursive: true);
      userIdFile.writeAsStringSync(userId);
    } finally {}

    return userId;
  }

  Future<void> storeLatestCliVersion(LatestCliVersionArtefact cliData) async {
    var latestCliVersionFile = File(
        p.join(localCacheDirectory.path, _LatestCliVersionConstants.filePath));
    try {
      if (!latestCliVersionFile.existsSync()) {
        latestCliVersionFile.createSync(recursive: true);
      }

      var data = {};
      data[_LatestCliVersionConstants.versionKeyword] = cliData.version;
      data[_LatestCliVersionConstants.validUntilKeyword] =
          cliData.validUntil.millisecondsSinceEpoch;

      latestCliVersionFile.writeAsStringSync(data.toString());
    } catch (e) {
      // Failed to write latest cli version to file.
    }
  }

  Future<LatestCliVersionArtefact?> tryFetchLatestCliVersion() async {
    var latestCliVersionFile = File(p.join(
      localCacheDirectory.path,
      _LatestCliVersionConstants.filePath,
    ));
    try {
      if (latestCliVersionFile.existsSync()) {
        var yaml = loadYaml(
          latestCliVersionFile.readAsStringSync(),
          sourceUrl: latestCliVersionFile.uri,
        );
        if (yaml is YamlMap) {
          var version =
              Version.parse(yaml[_LatestCliVersionConstants.versionKeyword]);
          var validUntil = DateTime.fromMillisecondsSinceEpoch(
              yaml[_LatestCliVersionConstants.validUntilKeyword]);
          return LatestCliVersionArtefact(version, validUntil);
        }
      }
    } catch (e) {
      // Failed to read latest cli version, it's probably not created.
      if (latestCliVersionFile.existsSync()) {
        // If the file exists it might be corrupted so we delete it.
        latestCliVersionFile.deleteSync();
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
    print('Downloading templates for version $templateVersion');
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
    print('Download complete.\n');
  }
}

abstract class _LatestCliVersionConstants {
  static const filePath = 'latest_cli_version.yaml';
  static const versionKeyword = 'latest_version';
  static const validUntilKeyword = 'valid_until';
}

class LatestCliVersionArtefact {
  Version version;
  DateTime validUntil;

  LatestCliVersionArtefact(this.version, this.validUntil);
}
