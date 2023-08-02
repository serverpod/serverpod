import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

class FieldDefinitionBuilder {
  String _name;
  TypeDefinition _type;
  SerializableEntityFieldScope _scope;
  String? _parentTable;
  List<String>? _documentation;

  FieldDefinitionBuilder()
      : _name = 'name',
        _type = TypeDefinition(
          className: 'String',
          nullable: true,
        ),
        _scope = SerializableEntityFieldScope.all;

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
    SerializableEntityFieldScope scope,
  ) {
    _scope = scope;
    return this;
  }

  FieldDefinitionBuilder withParentTable(
    String? parentTable,
  ) {
    _parentTable = parentTable;
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
      parentTable: _parentTable,
      documentation: _documentation,
    );
  }
}
