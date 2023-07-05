import 'dart:io';

import 'package:serverpod_cli/src/config/config.dart';
import 'package:path/path.dart';

class ProtocolSource {
  String yaml;
  Uri uri;
  List<String> protocolRootPathParts;

  ProtocolSource(this.yaml, this.uri, this.protocolRootPathParts);
}

class ProtocolHelper {
  static Future<List<ProtocolSource>> loadProjectYamlProtocolsFromDisk(
    GeneratorConfig config,
  ) async {
    var sourceDir = Directory(joinAll(config.protocolSourcePathParts));
    var sourceFileList = await sourceDir.list(recursive: true).toList();
    sourceFileList.sort((a, b) => a.path.compareTo(b.path));

    var files = sourceFileList
        .where((entity) => entity is File && entity.path.endsWith('.yaml'))
        .cast<File>();

    List<ProtocolSource> sources = [];
    for (var entity in files) {
      var yaml = await entity.readAsString();

      sources.add(ProtocolSource(
        yaml,
        entity.uri,
        extractPathFromProtocolRoot(config, entity.uri),
      ));
    }

    return sources;
  }

  static List<String> extractPathFromProtocolRoot(
      GeneratorConfig config, Uri fileUri) {
    var sourceDir = Directory(joinAll(config.protocolSourcePathParts));
    var sourceDirPartsLength = split(sourceDir.path).length;
    return split(dirname(fileUri.path)).skip(sourceDirPartsLength).toList();
  }
}
