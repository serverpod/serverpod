import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

import 'foreign_relation_definition_builder.dart';

class FieldDefinitionBuilder {
  String _name;
  TypeDefinition _type;
  ModelFieldScopeDefinition _scope;
  RelationDefinition? _relation;
  bool _shouldPersist;
  List<String>? _documentation;
  dynamic _defaultModelValue;
  dynamic _defaultPersistValue;
  bool _isRequired;

  FieldDefinitionBuilder()
      : _name = 'name',
        _type = TypeDefinition(
          className: 'String',
          nullable: true,
        ),
        _scope = ModelFieldScopeDefinition.all,
        _shouldPersist = true,
        _defaultModelValue = null,
        _defaultPersistValue = null,
        _isRequired = false;

  FieldDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  FieldDefinitionBuilder withPrimaryKey({
    SupportedIdType? type,
    bool isNullable = false,
  }) {
    type ??= SupportedIdType.int;
    _defaultPersistValue = type.defaultValue;
    return withName('id').withIdType(type: type.type, isNullable: isNullable);
  }

  FieldDefinitionBuilder withTypeEnum(
    EnumDefinition enumDefinition, {
    String? defaultModelValue,
    String? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: enumDefinition.className,
      nullable: nullable,
      enumDefinition: enumDefinition,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeString({
    String? defaultModelValue,
    String? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'String',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeBool({
    bool? defaultModelValue,
    bool? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'bool',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeDouble({
    double? defaultModelValue,
    double? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'double',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeInt({
    int? defaultModelValue,
    int? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'int',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeDateTime({
    String? defaultModelValue,
    String? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'DateTime',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeUuidValue({
    String? defaultModelValue,
    String? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'UuidValue',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeDuration({
    String? defaultModelValue,
    String? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'Duration',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeBigInt({
    String? defaultModelValue,
    String? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'BigInt',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeUri({
    String? defaultModelValue,
    String? defaultPersistValue,
    bool nullable = false,
  }) {
    _type = TypeDefinition(
      className: 'Uri',
      nullable: nullable,
    );
    _defaultModelValue = defaultModelValue;
    _defaultPersistValue = defaultPersistValue;
    return this;
  }

  FieldDefinitionBuilder withTypeDefinition(
    String className, [
    bool nullable = false,
    List<TypeDefinition> generics = const [],
  ]) {
    _type = TypeDefinition(
      className: className,
      nullable: nullable,
      generics: generics,
    );
    return this;
  }

  FieldDefinitionBuilder withIdType({
    TypeDefinition? type,
    bool isNullable = false,
  }) {
    _type = type ?? TypeDefinition.int;
    if (!_type.isIdType) throw ArgumentError('Id type $_type is not supported');
    if (isNullable) {
      _type = _type.asNullable;
    }
    return this;
  }

  FieldDefinitionBuilder withType(TypeDefinition type) {
    _type = type;
    return this;
  }

  FieldDefinitionBuilder withScope(
    ModelFieldScopeDefinition scope,
  ) {
    _scope = scope;
    return this;
  }

  FieldDefinitionBuilder withShouldPersist(
    bool shouldPersist,
  ) {
    _shouldPersist = shouldPersist;
    return this;
  }

  FieldDefinitionBuilder withRelation(
    RelationDefinition relation,
  ) {
    _relation = relation;
    return this;
  }

  FieldDefinitionBuilder withRelationTo(
    String parentTable,
    String referenceFieldName,
  ) {
    _relation = ForeignRelationDefinitionBuilder()
        .withParentTable(parentTable)
        .withReferenceFieldName(referenceFieldName)
        .build();
    return this;
  }

  FieldDefinitionBuilder withDocumentation(
    List<String>? documentation,
  ) {
    _documentation = documentation;
    return this;
  }

  FieldDefinitionBuilder withIsRequired(bool isRequired) {
    _isRequired = isRequired;
    return this;
  }

  SerializableModelFieldDefinition build() {
    return SerializableModelFieldDefinition(
      name: _name,
      type: _type,
      scope: _scope,
      relation: _relation,
      shouldPersist: _shouldPersist,
      documentation: _documentation,
      defaultModelValue: _defaultModelValue,
      defaultPersistValue: _defaultPersistValue,
      isRequired: _isRequired,
    );
  }
}
