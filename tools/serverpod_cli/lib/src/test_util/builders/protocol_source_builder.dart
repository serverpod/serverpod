import 'package:serverpod_cli/src/util/protocol_helper.dart';

class ProtocolSourceBuilder {
  late String yaml;
  late Uri yamlSourceUri;
  late List<String> protocolRootPathParts;

  ProtocolSourceBuilder() {
    withYaml('''
    class: Example
    fields:
      name: String
    ''');
    yamlSourceUri = Uri(path: 'lib/src/protocol/example.yaml');
    protocolRootPathParts = [];
  }

  ProtocolSourceBuilder withFileName(String fileName) {
    yamlSourceUri = Uri(path: 'lib/src/protocol/$fileName.yaml');
    return this;
  }

  ProtocolSourceBuilder withYaml(String yaml) {
    var paddingSize = _countPadding(yaml);
    var paddingToRemove = _createPadding(paddingSize);

    this.yaml = yaml.replaceAll(paddingToRemove, '');
    return this;
  }

  ProtocolSourceBuilder withYamlSourceUri(Uri yamlSourceUri) {
    this.yamlSourceUri = yamlSourceUri;
    return this;
  }

  ProtocolSourceBuilder withProtocolRootPathParts(
      List<String> protocolRootPathParts) {
    this.protocolRootPathParts = protocolRootPathParts;
    return this;
  }

  ProtocolSource build() {
    return ProtocolSource(yaml, yamlSourceUri, protocolRootPathParts);
  }
}

int _countPadding(String yaml) {
  var contentStartIndex = 0;
  for (int i = 0; i < yaml.length; i++) {
    if (yaml[i] != ' ') {
      contentStartIndex = i;
      break;
    }
  }
  return contentStartIndex;
}

String _createPadding(int count) {
  var padding = '';
  for (int i = 0; i < count; i++) {
    padding += ' ';
  }
  return padding;
}
