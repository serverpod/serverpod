import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class EnumDefinitionBuilder {
  String _moduleAlias;
  String _fileName;
  String _sourceFileName;
  String _className;
  EnumSerialization _serialized;
  List<String> _subDirParts;
  bool _serverOnly;

  List<ProtocolEnumValueDefinition> _values;
  List<String>? _documentation;

  EnumDefinitionBuilder()
      : _moduleAlias = defaultModuleAlias,
        _fileName = 'example',
        _sourceFileName = 'example.yaml',
        _className = 'Example',
        _serialized = EnumSerialization.byIndex,
        _subDirParts = [],
        _serverOnly = false,
        _values = [
          ProtocolEnumValueDefinition('A'),
          ProtocolEnumValueDefinition('B'),
          ProtocolEnumValueDefinition('C'),
        ],
        _documentation = [];

  EnumDefinition build() {
    return EnumDefinition(
      moduleAlias: _moduleAlias,
      fileName: _fileName,
      sourceFileName: _sourceFileName,
      className: _className,
      serialized: _serialized,
      values: _values,
      subDirParts: _subDirParts,
      serverOnly: _serverOnly,
      documentation: _documentation,
    );
  }

  EnumDefinitionBuilder withModuleAlias(String moduleAlias) {
    _moduleAlias = moduleAlias;
    return this;
  }

  EnumDefinitionBuilder withFileName(String fileName) {
    _fileName = fileName;
    return this;
  }

  EnumDefinitionBuilder withSourceFileName(String sourceFileName) {
    _sourceFileName = sourceFileName;
    return this;
  }

  EnumDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  EnumDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _subDirParts = subDirParts;
    return this;
  }

  EnumDefinitionBuilder withServerOnly(bool serverOnly) {
    _serverOnly = serverOnly;
    return this;
  }

  EnumDefinitionBuilder withSerialized(EnumSerialization serialized) {
    _serialized = serialized;
    return this;
  }

  EnumDefinitionBuilder withValues(List<ProtocolEnumValueDefinition> values) {
    _values = values;
    return this;
  }

  EnumDefinitionBuilder withValue(String value) {
    _values.add(ProtocolEnumValueDefinition(value));
    return this;
  }

  EnumDefinitionBuilder withDocumentation(List<String>? documentation) {
    _documentation = documentation;
    return this;
  }
}
