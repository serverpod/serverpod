import 'package:serverpod_cli/src/util/model_helper.dart';

class ModelSourceBuilder {
  late String moduleAlias;
  late String yaml;
  late String yamlSourcePath;
  Uri? yamlSourceUri;
  late List<String> protocolRootPathParts;

  ModelSourceBuilder() {
    withYaml('''
    class: Example
    fields:
      name: String
    ''');
    yamlSourcePath = 'lib/src/model/example.yaml';
    protocolRootPathParts = [];
    moduleAlias = defaultModuleAlias;
  }

  ModelSourceBuilder withModuleAlias(String moduleAlias) {
    this.moduleAlias = moduleAlias;
    return this;
  }

  ModelSourceBuilder withFileName(String fileName) {
    yamlSourcePath = 'lib/src/model/$fileName.yaml';
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
    var yamlSourceUri = Uri(path: 'module/$moduleAlias/$yamlSourcePath');
    return ModelSource(
      moduleAlias,
      yaml,
      this.yamlSourceUri ?? yamlSourceUri,
      protocolRootPathParts,
    );
  }
}
