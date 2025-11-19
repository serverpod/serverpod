import 'package:path/path.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

class ModelSourceBuilder {
  String moduleAlias;
  String yaml;
  String fileName;
  List<String> yamlSourcePathParts;
  Uri? yamlSourceUri;
  List<String> subDirPathParts;
  String fileExtension;

  ModelSourceBuilder()
    : fileExtension = '.yaml',
      subDirPathParts = [],
      fileName = 'example',
      yamlSourcePathParts = ['lib', 'src', 'model'],
      moduleAlias = defaultModuleAlias,
      yaml = '''
    class: Example
    fields:
      name: String
''';

  ModelSourceBuilder withModuleAlias(String moduleAlias) {
    this.moduleAlias = moduleAlias;
    return this;
  }

  ModelSourceBuilder withFileName(String fileName) {
    this.fileName = fileName;
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

  ModelSourceBuilder withProtocolRootPathParts(List<String> subDirPathParts) {
    this.subDirPathParts = subDirPathParts;
    return this;
  }

  ModelSourceBuilder withYamlSourcePathParts(List<String> yamlSourcePathParts) {
    this.yamlSourcePathParts = yamlSourcePathParts;
    return this;
  }

  ModelSourceBuilder withFileExtension(String fileExtension) {
    this.fileExtension = fileExtension;
    return this;
  }

  ModelSource build() {
    var yamlSourceUri = Uri(
      path: joinAll(
        [
          'module',
          moduleAlias,
          ...yamlSourcePathParts,
          '$fileName$fileExtension',
        ],
      ),
    );
    return ModelSource(
      moduleAlias,
      yaml,
      this.yamlSourceUri ?? yamlSourceUri,
      subDirPathParts,
    );
  }
}
