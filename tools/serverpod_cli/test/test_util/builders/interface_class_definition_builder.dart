import 'package:serverpod_cli/src/analyzer/models/definitions.dart';

import 'serializable_entity_field_definition_builder.dart';
import 'type_definition_builder.dart';

typedef _FieldBuilder = SerializableModelFieldDefinition Function();

class InterfaceClassDefinitionBuilder {
  String _fileName;
  String _sourceFileName;
  String _className;
  List<String> _subDirParts;
  bool _serverOnly;
  List<_FieldBuilder> _fields;
  List<String>? _documentation;
  List<ResolvedImplementsDefinition> _isImplementing;

  InterfaceClassDefinitionBuilder()
      : _fileName = 'example',
        _sourceFileName = 'example.yaml',
        _className = 'Example',
        _fields = [],
        _subDirParts = [],
        _serverOnly = false,
        _isImplementing = [];

  InterfaceClassDefinition build() {
    return InterfaceClassDefinition(
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

  InterfaceClassDefinitionBuilder withFileName(String fileName) {
    _fileName = fileName;
    return this;
  }

  InterfaceClassDefinitionBuilder withSimpleField(
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

  InterfaceClassDefinitionBuilder withSourceFileName(String sourceFileName) {
    _sourceFileName = sourceFileName;
    return this;
  }

  InterfaceClassDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  InterfaceClassDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _subDirParts = subDirParts;
    return this;
  }

  InterfaceClassDefinitionBuilder withServerOnly(bool serverOnly) {
    _serverOnly = serverOnly;
    return this;
  }

  InterfaceClassDefinitionBuilder withField(
      SerializableModelFieldDefinition field) {
    _fields.add(() => field);
    return this;
  }

  InterfaceClassDefinitionBuilder withFields(
    List<SerializableModelFieldDefinition> fields,
  ) {
    _fields = fields.map((f) => () => f).toList();
    return this;
  }

  InterfaceClassDefinitionBuilder withDocumentation(
      List<String>? documentation) {
    _documentation = documentation;
    return this;
  }

  InterfaceClassDefinitionBuilder withImplementedInterfaces(
    List<ClassDefinition> interfaces,
  ) {
    _isImplementing = [
      for (var implementedInterface in interfaces)
        ResolvedImplementsDefinition(implementedInterface)
    ];
    return this;
  }
}
