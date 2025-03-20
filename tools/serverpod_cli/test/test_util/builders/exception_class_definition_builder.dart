import 'package:serverpod_cli/src/analyzer/models/definitions.dart';

import 'serializable_entity_field_definition_builder.dart';
import 'type_definition_builder.dart';

typedef _FieldBuilder = SerializableModelFieldDefinition Function();

class ExceptionClassDefinitionBuilder {
  String _fileName;
  String _sourceFileName;
  String _className;
  List<String> _subDirParts;
  bool _serverOnly;
  List<_FieldBuilder> _fields;
  List<String>? _documentation;
  List<ResolvedImplementsDefinition> _isImplementing;
  ExceptionClassDefinitionBuilder()
      : _fileName = 'example',
        _sourceFileName = 'example.yaml',
        _className = 'Example',
        _fields = [],
        _subDirParts = [],
        _serverOnly = false,
        _isImplementing = [];

  ExceptionClassDefinition build() {
    return ExceptionClassDefinition(
      fileName: _fileName,
      sourceFileName: _sourceFileName,
      className: _className,
      fields: _fields.map((f) => f()).toList(),
      subDirParts: _subDirParts,
      serverOnly: _serverOnly,
      documentation: _documentation,
      type: TypeDefinitionBuilder().withClassName(_className).build(),
      isImplementing: _isImplementing,
    );
  }

  ExceptionClassDefinitionBuilder withFileName(String fileName) {
    _fileName = fileName;
    return this;
  }

  ExceptionClassDefinitionBuilder withSourceFileName(String sourceFileName) {
    _sourceFileName = sourceFileName;
    return this;
  }

  ExceptionClassDefinitionBuilder withSimpleField(
    String fieldName,
    String type, {
    dynamic defaultValue,
    bool nullable = false,
  }) {
    _fields.add(
      () => FieldDefinitionBuilder()
          .withName(fieldName)
          .withTypeDefinition(type, nullable)
          .withDefaults(defaultModelValue: defaultValue)
          .build(),
    );
    return this;
  }

  ExceptionClassDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  ExceptionClassDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _subDirParts = subDirParts;
    return this;
  }

  ExceptionClassDefinitionBuilder withServerOnly(bool serverOnly) {
    _serverOnly = serverOnly;
    return this;
  }

  ExceptionClassDefinitionBuilder withField(
      SerializableModelFieldDefinition field) {
    _fields.add(() => field);
    return this;
  }

  ExceptionClassDefinitionBuilder withFields(
    List<SerializableModelFieldDefinition> fields,
  ) {
    _fields = fields.map((f) => () => f).toList();
    return this;
  }

  ExceptionClassDefinitionBuilder withDocumentation(
      List<String>? documentation) {
    _documentation = documentation;
    return this;
  }

  ExceptionClassDefinitionBuilder withImplementedInterfaces(
    List<InterfaceClassDefinition> interfaces,
  ) {
    _isImplementing = [
      for (var implementedInterface in interfaces)
        ResolvedImplementsDefinition(implementedInterface)
    ];
    return this;
  }
}
