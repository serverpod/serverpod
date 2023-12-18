import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/foreign_relation_definition_builder.dart';

class FieldDefinitionBuilder {
  String _name;
  TypeDefinition _type;
  EntityFieldScopeDefinition _scope;
  RelationDefinition? _relation;
  bool _shouldPersist;
  List<String>? _documentation;

  FieldDefinitionBuilder()
      : _name = 'name',
        _type = TypeDefinition(
          className: 'String',
          nullable: true,
        ),
        _scope = EntityFieldScopeDefinition.all,
        _shouldPersist = true;

  FieldDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  FieldDefinitionBuilder withPrimaryKey() {
    _name = 'id';
    _type = TypeDefinition.int;

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

  FieldDefinitionBuilder withIdType([bool isNullable = false]) {
    _type = TypeDefinition.int;
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
    EntityFieldScopeDefinition scope,
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

  SerializableModelFieldDefinition build() {
    return SerializableModelFieldDefinition(
      name: _name,
      type: _type,
      scope: _scope,
      relation: _relation,
      shouldPersist: _shouldPersist,
      documentation: _documentation,
    );
  }
}
