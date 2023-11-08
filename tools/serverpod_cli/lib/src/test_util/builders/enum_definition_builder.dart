import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';

class EnumDefinitionBuilder {
  String _fileName;
  String _sourceFileName;
  String _className;
  SerializeEnumAs _serializeAs;
  List<String> _subDirParts;
  bool _serverOnly;

  List<ProtocolEnumValueDefinition> _values;
  List<String>? _documentation;

  EnumDefinitionBuilder()
      : _fileName = 'example',
        _sourceFileName = 'example.yaml',
        _className = 'Example',
        // TODO: For Serverpod 2.0, change the default to `true`.
        _serializeAs = SerializeEnumAs.int,
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
      fileName: _fileName,
      sourceFileName: _sourceFileName,
      className: _className,
      serializeAs: _serializeAs,
      values: _values,
      subDirParts: _subDirParts,
      serverOnly: _serverOnly,
      documentation: _documentation,
    );
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

  EnumDefinitionBuilder withSerializeAs(SerializeEnumAs serializeAs) {
    _serializeAs = serializeAs;
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
