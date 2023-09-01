import 'package:serverpod_cli/src/util/protocol_helper.dart';

class ProtocolSourceBuilder {
  late String yaml;
  late Uri yamlSourceUri;
  late List<String> protocolRootPathParts;

  ProtocolSourceBuilder() {
    yaml = '''
    class: Example
    fields:
      name: String
    ''';
    yamlSourceUri = Uri(path: 'lib/src/protocol/example.yaml');
    protocolRootPathParts = [];
  }

  ProtocolSourceBuilder withFileName(String fileName) {
    yamlSourceUri = Uri(path: 'lib/src/protocol/$fileName.yaml');
    return this;
  }

  ProtocolSourceBuilder withYaml(String yaml) {
    this.yaml = yaml;
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
