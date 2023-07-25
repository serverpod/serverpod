import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';

import 'serializable_entity_field_definition_builder.dart';

class ClassDefinitionBuilder {
  ClassDefinition _classDefinition;

  ClassDefinitionBuilder()
      : _classDefinition = ClassDefinition(
          fileName: 'example',
          sourceFileName: 'example.yaml',
          className: 'Example',
          fields: [],
          subDirParts: [],
          serverOnly: false,
          isException: false,
        );

  ClassDefinition build() => _classDefinition;

  ClassDefinitionBuilder withFileName(String fileName) {
    _classDefinition = _classDefinition.copyWith(fileName: fileName);
    return this;
  }

  ClassDefinitionBuilder withSourceFileName(String sourceFileName) {
    _classDefinition = _classDefinition.copyWith(
      sourceFileName: sourceFileName,
    );
    return this;
  }

  ClassDefinitionBuilder withClassName(String className) {
    _classDefinition = _classDefinition.copyWith(className: className);
    return this;
  }

  ClassDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _classDefinition = _classDefinition.copyWith(subDirParts: subDirParts);
    return this;
  }

  ClassDefinitionBuilder withServerOnly(bool serverOnly) {
    _classDefinition = _classDefinition.copyWith(serverOnly: serverOnly);
    return this;
  }

  ClassDefinitionBuilder withTableName(String? tableName) {
    _classDefinition = _classDefinition.copyWith(tableName: tableName);
    return this;
  }

  ClassDefinitionBuilder withSimpleField(
    String fieldName,
    String typeDefinition, {
    bool nullable = false,
  }) {
    _classDefinition = _classDefinition.copyWith(
      fields: [
        ..._classDefinition.fields,
        SerializableEntityFieldDefinitionBuilder()
            .withFieldName(fieldName)
            .withTypeDefinition(typeDefinition, nullable)
            .build()
      ],
    );
    return this;
  }

  ClassDefinitionBuilder withFields(
    List<SerializableEntityFieldDefinition> fields,
  ) {
    _classDefinition = _classDefinition.copyWith(fields: fields);
    return this;
  }

  ClassDefinitionBuilder withIndexes(
    List<SerializableEntityIndexDefinition>? indexes,
  ) {
    _classDefinition = _classDefinition.copyWith(indexes: indexes);
    return this;
  }

  ClassDefinitionBuilder withDocumentation(List<String>? documentation) {
    _classDefinition = _classDefinition.copyWith(documentation: documentation);
    return this;
  }

  ClassDefinitionBuilder withIsException(bool isException) {
    _classDefinition = _classDefinition.copyWith(isException: isException);
    return this;
  }
}
