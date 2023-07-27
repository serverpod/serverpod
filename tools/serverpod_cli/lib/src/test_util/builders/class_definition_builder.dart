import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

import 'serializable_entity_field_definition_builder.dart';

class ClassDefinitionBuilder {
  String _fileName;
  String _sourceFileName;
  String _className;
  List<String> _subDirParts;
  bool _serverOnly;
  bool _isException;
  String? _tableName;
  List<SerializableEntityFieldDefinition> _fields;
  List<SerializableEntityIndexDefinition>? _indexes;
  List<String>? _documentation;

  ClassDefinitionBuilder()
      : _fileName = 'example',
        _sourceFileName = 'example.yaml',
        _className = 'Example',
        _fields = [],
        _subDirParts = [],
        _serverOnly = false,
        _isException = false;

  ClassDefinition build() {
    if (_tableName != null) {
      _fields.insert(
        0,
        FieldDefinitionBuilder()
            .withName('id')
            .withType(TypeDefinition.int.asNullable)
            .withScope(SerializableEntityFieldScope.all)
            .build(),
      );
    }

    return ClassDefinition(
      fileName: _fileName,
      sourceFileName: _sourceFileName,
      className: _className,
      fields: _fields,
      subDirParts: _subDirParts,
      serverOnly: _serverOnly,
      isException: _isException,
      tableName: _tableName,
      indexes: _indexes,
      documentation: _documentation,
    );
  }

  ClassDefinitionBuilder withFileName(String fileName) {
    _fileName = fileName;
    return this;
  }

  ClassDefinitionBuilder withSourceFileName(String sourceFileName) {
    _sourceFileName = sourceFileName;
    return this;
  }

  ClassDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  ClassDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _subDirParts = subDirParts;
    return this;
  }

  ClassDefinitionBuilder withServerOnly(bool serverOnly) {
    _serverOnly = serverOnly;
    return this;
  }

  ClassDefinitionBuilder withTableName(String? tableName) {
    _tableName = tableName;
    return this;
  }

  ClassDefinitionBuilder withSimpleField(
    String fieldName,
    String type, {
    bool nullable = false,
  }) {
    _fields.add(
      FieldDefinitionBuilder()
          .withName(fieldName)
          .withTypeDefinition(type, nullable)
          .build(),
    );
    return this;
  }

  ClassDefinitionBuilder withField(SerializableEntityFieldDefinition field) {
    _fields.add(field);
    return this;
  }

  ClassDefinitionBuilder withFields(
    List<SerializableEntityFieldDefinition> fields,
  ) {
    _fields = fields;
    return this;
  }

  ClassDefinitionBuilder withIndexes(
    List<SerializableEntityIndexDefinition>? indexes,
  ) {
    _indexes = indexes;
    return this;
  }

  ClassDefinitionBuilder withDocumentation(List<String>? documentation) {
    _documentation = documentation;
    return this;
  }

  ClassDefinitionBuilder withIsException(bool isException) {
    _isException = isException;
    return this;
  }
}
