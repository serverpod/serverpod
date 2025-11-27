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
    return withName('id')
      ..withIdType(type: type.type, isNullable: isNullable)
      ..withDefaults(
        defaultPersistValue: type.defaultValue,
      );
  }

  FieldDefinitionBuilder withEnumDefinition(
    EnumDefinition enumDefinition, [
    bool nullable = false,
  ]) {
    _type = TypeDefinition(
      className: enumDefinition.className,
      nullable: nullable,
      enumDefinition: enumDefinition,
    );
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

  FieldDefinitionBuilder withDefaults({
    dynamic defaultModelValue,
    dynamic defaultPersistValue,
  }) {
    _defaultModelValue = defaultModelValue ?? _defaultModelValue;
    _defaultPersistValue = defaultPersistValue ?? _defaultPersistValue;
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
