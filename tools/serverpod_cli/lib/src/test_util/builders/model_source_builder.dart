import 'package:path/path.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

class ModelSourceBuilder {
  late String moduleAlias;
  late String yaml;
  late List<String> _yamlSourcePathParts;
  Uri? yamlSourceUri;
  late List<String> protocolRootPathParts;

  ModelSourceBuilder() {
    withYaml('''
    class: Example
    fields:
      name: String
    ''');
    _yamlSourcePathParts = ['lib', 'src', 'model', 'example.yaml'];
    protocolRootPathParts = [];
    moduleAlias = defaultModuleAlias;
  }

  ModelSourceBuilder withModuleAlias(String moduleAlias) {
    this.moduleAlias = moduleAlias;
    return this;
  }

  ModelSourceBuilder withFileName(String fileName) {
    _yamlSourcePathParts = ['lib', 'src', 'model', '$fileName.yaml'];
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
    var yamlSourceUri = Uri(
      path: joinAll(['module', moduleAlias, ..._yamlSourcePathParts]),
    );
    return ModelSource(
      moduleAlias,
      yaml,
      this.yamlSourceUri ?? yamlSourceUri,
      protocolRootPathParts,
    );
  }
}
