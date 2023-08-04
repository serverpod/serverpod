import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

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

  FieldDefinitionBuilder withTypeDefinition(
    String className, [
    bool nullable = false,
  ]) {
    _type = TypeDefinition(className: className, nullable: nullable);
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
    _relation = ForeignRelationDefinition(
      parentTable: parentTable,
      referenceFieldName: referenceFieldName,
      onUpdate: ForeignKeyAction.noAction,
    );
    return this;
  }

  FieldDefinitionBuilder withDocumentation(
    List<String>? documentation,
  ) {
    _documentation = documentation;
    return this;
  }

  SerializableEntityFieldDefinition build() {
    return SerializableEntityFieldDefinition(
      name: _name,
      type: _type,
      scope: _scope,
      relation: _relation,
      shouldPersist: _shouldPersist,
      documentation: _documentation,
    );
  }
}
