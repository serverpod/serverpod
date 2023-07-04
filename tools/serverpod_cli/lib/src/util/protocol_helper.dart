import 'dart:io';

import 'package:serverpod_cli/src/config/config.dart';
import 'package:path/path.dart';

class ProtocolSource {
  String yaml;
  Uri uri;

  ProtocolSource(this.yaml, this.uri);
}

class ProtocolHelper {
  static Future<List<ProtocolSource>> loadProjectYamlProtocolsFromDisk(
      GeneratorConfig config) async {
    var sourceDir = Directory(joinAll(config.protocolSourcePathParts));
    var sourceFileList = await sourceDir.list(recursive: true).toList();
    sourceFileList.sort((a, b) => a.path.compareTo(b.path));

    var files = sourceFileList
        .where((entity) => entity is File && entity.path.endsWith('.yaml'))
        .cast<File>();

    List<ProtocolSource> sources = [];
    for (var entity in files) {
      var yaml = await entity.readAsString();

      sources.add(ProtocolSource(yaml, entity.uri));
    }

    return sources;
  }
}
