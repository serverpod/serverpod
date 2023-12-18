import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/foreign_relation_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';

import 'serializable_entity_field_definition_builder.dart';

typedef _FieldBuilder = SerializableModelFieldDefinition Function();

class ClassDefinitionBuilder {
  String _fileName;
  String _sourceFileName;
  String _className;
  List<String> _subDirParts;
  bool _serverOnly;
  bool _isException;
  String? _tableName;
  List<_FieldBuilder> _fields;
  List<SerializableModelIndexDefinition> _indexes;
  List<String>? _documentation;

  ClassDefinitionBuilder()
      : _fileName = 'example',
        _sourceFileName = 'example.yaml',
        _className = 'Example',
        _fields = [],
        _subDirParts = [],
        _serverOnly = false,
        _isException = false,
        _indexes = [];

  ClassDefinition build() {
    if (_tableName != null) {
      _fields.insert(
        0,
        () => FieldDefinitionBuilder()
            .withName('id')
            .withType(TypeDefinition.int.asNullable)
            .withScope(ModelFieldScopeDefinition.all)
            .withShouldPersist(true)
            .build(),
      );
    }

    return ClassDefinition(
      fileName: _fileName,
      sourceFileName: _sourceFileName,
      className: _className,
      fields: _fields.map((f) => f()).toList(),
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
      () => FieldDefinitionBuilder()
          .withName(fieldName)
          .withTypeDefinition(type, nullable)
          .build(),
    );
    return this;
  }

  ClassDefinitionBuilder withField(SerializableModelFieldDefinition field) {
    _fields.add(() => field);
    return this;
  }

  ClassDefinitionBuilder withObjectRelationFieldNoForeignKey(
    String fieldName,
    String className,
    String parentTable, {
    String? foreignKeyFieldName,
    bool nullableRelation = false,
  }) {
    _fields.addAll([
      () {
        if (_tableName == null) {
          throw Exception(
            'Cannot create object relation field without table name',
          );
        }
        var foreignFieldName = foreignKeyFieldName ?? '${_tableName}Id';
        return FieldDefinitionBuilder()
            .withName(fieldName)
            .withTypeDefinition(className, true)
            .withShouldPersist(false)
            .withRelation(ObjectRelationDefinition(
              parentTable: parentTable,
              fieldName: foreignFieldName,
              foreignFieldName: 'id',
              isForeignKeyOrigin: false,
              nullableRelation: nullableRelation,
            ))
            .build();
      }
    ]);
    return this;
  }

  ClassDefinitionBuilder withObjectRelationField(
    String fieldName,
    String className,
    String parentTable, {
    String? foreignKeyFieldName,
    bool nullableRelation = false,
  }) {
    var foreignFieldName = foreignKeyFieldName ?? '${fieldName}Id';
    _fields.addAll([
      () => FieldDefinitionBuilder()
          .withName(fieldName)
          .withTypeDefinition(className, true)
          .withShouldPersist(false)
          .withRelation(ObjectRelationDefinition(
            parentTable: parentTable,
            fieldName: foreignFieldName,
            foreignFieldName: 'id',
            nullableRelation: nullableRelation,
            isForeignKeyOrigin: true,
          ))
          .build(),
      () => FieldDefinitionBuilder()
          .withName(foreignFieldName)
          .withIdType(nullableRelation)
          .withShouldPersist(true)
          .withRelation(ForeignRelationDefinitionBuilder()
              .withParentTable(parentTable)
              .withReferenceFieldName('id')
              .build())
          .build(),
    ]);
    return this;
  }

  ClassDefinitionBuilder withImplicitListRelationField(
    String fieldName,
    String className,
  ) {
    _fields.add(() {
      return FieldDefinitionBuilder()
          .withName(fieldName)
          .withShouldPersist(false)
          .withType(
            TypeDefinitionBuilder()
                .withNullable(true)
                .withClassName('List')
                .withGenerics([
              TypeDefinitionBuilder().withClassName(className).build()
            ]).build(),
          )
          .withRelation(ListRelationDefinition(
            fieldName: 'id',
            foreignFieldName:
                '\$_${_className.camelCase}${fieldName.pascalCase}${_className.pascalCase}Id',
            nullableRelation: true,
            implicitForeignField: true,
          ))
          .build();
    });
    return this;
  }

  ClassDefinitionBuilder withListRelationField(
    String fieldName,
    String className,
    String foreignKeyFieldName, {
    bool nullableRelation = false,
  }) {
    _fields.add(() {
      return FieldDefinitionBuilder()
          .withName(fieldName)
          .withShouldPersist(false)
          .withType(
            TypeDefinitionBuilder()
                .withNullable(true)
                .withClassName('List')
                .withGenerics([
              TypeDefinitionBuilder().withClassName(className).build()
            ]).build(),
          )
          .withRelation(ListRelationDefinition(
            fieldName: 'id',
            foreignFieldName: foreignKeyFieldName,
            nullableRelation: nullableRelation,
            implicitForeignField: false,
          ))
          .build();
    });

    return this;
  }

  ClassDefinitionBuilder withFields(
    List<SerializableModelFieldDefinition> fields,
  ) {
    _fields = fields.map((f) => () => f).toList();
    return this;
  }

  ClassDefinitionBuilder withIndexes(
    List<SerializableModelIndexDefinition> indexes,
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
