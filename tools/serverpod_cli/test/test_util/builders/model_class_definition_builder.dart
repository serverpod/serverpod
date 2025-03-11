import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

import 'foreign_relation_definition_builder.dart';
import 'serializable_entity_field_definition_builder.dart';
import 'type_definition_builder.dart';

typedef _FieldBuilder = SerializableModelFieldDefinition Function();

class ModelClassDefinitionBuilder {
  String _fileName;
  String _sourceFileName;
  String _className;
  List<String> _subDirParts;
  bool _serverOnly;
  String? _tableName;
  bool _managedMigration;
  List<_FieldBuilder> _fields;
  List<SerializableModelIndexDefinition> _indexes;
  List<String>? _documentation;
  bool _isSealed;
  List<InheritanceDefinition> _childClasses;
  InheritanceDefinition? _extendsClass;
  List<ImplementsDefinition> _isImplementing;

  ModelClassDefinitionBuilder()
      : _fileName = 'example',
        _sourceFileName = 'example.yaml',
        _className = 'Example',
        _fields = [],
        _subDirParts = [],
        _managedMigration = true,
        _serverOnly = false,
        _indexes = [],
        _childClasses = [],
        _isImplementing = [],
        _isSealed = false;

  ModelClassDefinition build() {
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

    return ModelClassDefinition(
      fileName: _fileName,
      sourceFileName: _sourceFileName,
      className: _className,
      fields: _fields.map((f) => f()).toList(),
      subDirParts: _subDirParts,
      serverOnly: _serverOnly,
      tableName: _tableName,
      manageMigration: _managedMigration,
      indexes: _indexes,
      documentation: _documentation,
      childClasses: _childClasses,
      extendsClass: _extendsClass,
      isImplementing: _isImplementing,
      isSealed: _isSealed,
      type: TypeDefinitionBuilder().withClassName(_className).build(),
    );
  }

  ModelClassDefinitionBuilder withFileName(String fileName) {
    _fileName = fileName;
    return this;
  }

  ModelClassDefinitionBuilder withSourceFileName(String sourceFileName) {
    _sourceFileName = sourceFileName;
    return this;
  }

  ModelClassDefinitionBuilder withClassName(String className) {
    _className = className;
    return this;
  }

  ModelClassDefinitionBuilder withSubDirParts(List<String> subDirParts) {
    _subDirParts = subDirParts;
    return this;
  }

  ModelClassDefinitionBuilder withServerOnly(bool serverOnly) {
    _serverOnly = serverOnly;
    return this;
  }

  ModelClassDefinitionBuilder withTableName(String? tableName) {
    _tableName = tableName;
    return this;
  }

  ModelClassDefinitionBuilder withManagedMigration(bool isManaged) {
    _managedMigration = isManaged;
    return this;
  }

  ModelClassDefinitionBuilder withSimpleField(
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

  ModelClassDefinitionBuilder withListField(
    String fieldName,
    String className, {
    bool nullable = false,
    ModelFieldScopeDefinition scope = ModelFieldScopeDefinition.all,
  }) {
    _fields.add(
      () => FieldDefinitionBuilder()
          .withName(fieldName)
          .withShouldPersist(false)
          .withScope(scope)
          .withType(
            TypeDefinitionBuilder()
                .withNullable(nullable)
                .withClassName('List')
                .withGenerics([
              TypeDefinitionBuilder().withClassName(className).build()
            ]).build(),
          )
          .build(),
    );
    return this;
  }

  ModelClassDefinitionBuilder withMapField(
    String fieldName, {
    required String keyType,
    required String valueType,
    bool nullable = false,
    ModelFieldScopeDefinition scope = ModelFieldScopeDefinition.all,
  }) {
    _fields.add(
      () => FieldDefinitionBuilder()
          .withName(fieldName)
          .withShouldPersist(false)
          .withScope(scope)
          .withType(
            TypeDefinitionBuilder()
                .withNullable(nullable)
                .withClassName('Map')
                .withGenerics([
              TypeDefinitionBuilder().withClassName(keyType).build(),
              TypeDefinitionBuilder().withClassName(valueType).build(),
            ]).build(),
          )
          .build(),
    );
    return this;
  }

  ModelClassDefinitionBuilder withField(
      SerializableModelFieldDefinition field) {
    _fields.add(() => field);
    return this;
  }

  ModelClassDefinitionBuilder withObjectRelationFieldNoForeignKey(
    String fieldName,
    String className,
    String parentTable, {
    String? foreignKeyFieldName,
    TypeDefinition? foreignIdType,
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
              parentTableIdType: foreignIdType ?? TypeDefinition.int,
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

  ModelClassDefinitionBuilder withObjectRelationField(
    String fieldName,
    String className,
    String parentTable, {
    String? foreignKeyFieldName,
    TypeDefinition? foreignKeyParentTableIdType,
    bool nullableRelation = false,
  }) {
    var foreignFieldName = foreignKeyFieldName ?? '${fieldName}Id';
    var foreignTableIdType = foreignKeyParentTableIdType ?? TypeDefinition.int;
    _fields.addAll([
      () => FieldDefinitionBuilder()
          .withName(fieldName)
          .withTypeDefinition(className, true)
          .withShouldPersist(false)
          .withRelation(ObjectRelationDefinition(
            parentTable: parentTable,
            parentTableIdType: foreignTableIdType,
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

  ModelClassDefinitionBuilder withImplicitListRelationField(
    String fieldName,
    String className, {
    TypeDefinition? foreignKeyOwnerIdType,
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
            foreignKeyOwnerIdType: foreignKeyOwnerIdType ?? TypeDefinition.int,
            foreignFieldName:
                '\$_${_className.camelCase}${fieldName.pascalCase}${_className.pascalCase}Id',
            nullableRelation: true,
            implicitForeignField: true,
          ))
          .build();
    });
    return this;
  }

  ModelClassDefinitionBuilder withListRelationField(
    String fieldName,
    String className,
    String foreignKeyFieldName, {
    TypeDefinition? foreignKeyOwnerIdType,
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
            foreignKeyOwnerIdType: foreignKeyOwnerIdType ?? TypeDefinition.int,
            foreignFieldName: foreignKeyFieldName,
            nullableRelation: nullableRelation,
            implicitForeignField: false,
          ))
          .build();
    });

    return this;
  }

  ModelClassDefinitionBuilder withFields(
    List<SerializableModelFieldDefinition> fields,
  ) {
    _fields = fields.map((f) => () => f).toList();
    return this;
  }

  ModelClassDefinitionBuilder withIndexes(
    List<SerializableModelIndexDefinition> indexes,
  ) {
    _indexes = indexes;
    return this;
  }

  ModelClassDefinitionBuilder withDocumentation(List<String>? documentation) {
    _documentation = documentation;
    return this;
  }

  ModelClassDefinitionBuilder withChildClasses(
    List<ModelClassDefinition> childClasses,
  ) {
    _childClasses = [
      for (var child in childClasses) ResolvedInheritanceDefinition(child),
    ];
    return this;
  }

  ModelClassDefinitionBuilder withImplementedInterfaces(
    List<ClassDefinition> interfaces,
  ) {
    _isImplementing = [
      for (var implementedInterface in interfaces)
        ResolvedImplementsDefinition(implementedInterface)
    ];
    return this;
  }

  ModelClassDefinitionBuilder withExtendsClass(
      ModelClassDefinition parentClass) {
    _extendsClass = ResolvedInheritanceDefinition(parentClass);
    return this;
  }

  ModelClassDefinitionBuilder withIsSealed(bool isSealed) {
    _isSealed = isSealed;
    return this;
  }
}
