import 'package:serverpod_cli/src/util/model_helper.dart';

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

  ModelSource build() {
    return ModelSource(yaml, yamlSourceUri, protocolRootPathParts);
  }
}
