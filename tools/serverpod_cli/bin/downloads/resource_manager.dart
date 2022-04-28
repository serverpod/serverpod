import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../generated/version.dart';
import '../shared/environment.dart';

final ResourceManager resourceManager = ResourceManager();

class ResourceManager {
  Directory get homeDirectory {
    Map<String, String> envVars = Platform.environment;

    if (Platform.isMacOS) {
      return Directory(envVars['HOME']!);
    } else if (Platform.isLinux) {
      return Directory(envVars['HOME']!);
    } else if (Platform.isWindows) {
      return Directory(envVars['UserProfile']!);
    }

    throw (Exception('Unsupported platform.'));
  }

  Directory get localCacheDirectory =>
      Directory(homeDirectory.path + '/.serverpod');
  Directory get versionedDir =>
      Directory(localCacheDirectory.path + '/$templateVersion');
  Directory get templateDirectory {
    if (productionMode) {
      return Directory(versionedDir.path + '/serverpod_template');
    } else {
      return Directory(serverpodHome + '/templates/serverpod_templates');
    }
  }

  String get uniqueUserId {
    const String uuidFilePath = '/uuid';
    try {
      File userIdFile = File(localCacheDirectory.path + uuidFilePath);
      String userId = userIdFile.readAsStringSync();
      return userId;
    } catch (e) {
      // Failed to read userId from file, it's probably not created.
    }
    String userId = const Uuid().v4();
    try {
      File userIdFile = File(localCacheDirectory.path + uuidFilePath);
      userIdFile.writeAsStringSync(userId);
    } finally {}

    return userId;
  }

  String get packageDownloadUrl =>
      'https://storage.googleapis.com/pub-packages/packages/serverpod_templates-$templateVersion.tar.gz';

  bool get isTemplatesInstalled {
    if (!versionedDir.existsSync()) return false;

    return templateDirectory.existsSync();
  }

  Future<void> installTemplates() async {
    print('Downloading templates for version $templateVersion');
    if (!versionedDir.existsSync()) versionedDir.createSync(recursive: true);

    http.Response response = await http.get(Uri.parse(packageDownloadUrl));
    Uint8List data = response.bodyBytes;

    // var outFile = File(versionedDir.path + '/serverpod_templates.tar.gz');
    // outFile.writeAsBytesSync(data);

    List<int> unzipped = GZipDecoder().decodeBytes(data);
    Archive archive = TarDecoder().decodeBytes(unzipped);

    for (ArchiveFile file in archive) {
      String outFileName = '${templateDirectory.path}/${file.name}';
      if (file.isFile) {
        File outFile = File(outFileName);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      } else {
        await Directory(outFileName).create(recursive: true);
      }
    }
    print('Download complete.\n');
  }
}
