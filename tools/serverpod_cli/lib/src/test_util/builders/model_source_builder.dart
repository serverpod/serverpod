import 'package:serverpod_cli/src/util/model_helper.dart';

class ModelSourceBuilder {
  late String yaml;
  late Uri yamlSourceUri;
  late List<String> protocolRootPathParts;

  ModelSourceBuilder() {
    withYaml('''
    class: Example
    fields:
      name: String
    ''');
    yamlSourceUri = Uri(path: 'lib/src/model/example.yaml');
    protocolRootPathParts = [];
  }

  ModelSourceBuilder withFileName(String fileName) {
    yamlSourceUri = Uri(path: 'lib/src/model/$fileName.yaml');
    return this;
  }

  ModelSourceBuilder withYaml(String yaml) {
    this.yaml = yaml;
    return this;
  }

  ModelSourceBuilder withYamlSourceUri(Uri yamlSourceUri) {
    this.yamlSourceUri = yamlSourceUri;
    return this;
  }

  ModelSourceBuilder withProtocolRootPathParts(
      List<String> protocolRootPathParts) {
    this.protocolRootPathParts = protocolRootPathParts;
    return this;
  }

  ModelSource build() {
    return ModelSource(yaml, yamlSourceUri, protocolRootPathParts);
  }
}
