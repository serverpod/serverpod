import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

class FieldDefinitionBuilder {
  SerializableEntityFieldDefinition _fieldDefinition;

  FieldDefinitionBuilder()
      : _fieldDefinition = SerializableEntityFieldDefinition(
          name: 'name',
          type: TypeDefinition(
            className: 'String',
            nullable: true,
          ),
          scope: SerializableEntityFieldScope.all,
        );

  SerializableEntityFieldDefinition build() => _fieldDefinition;

  FieldDefinitionBuilder withName(String name) {
    _fieldDefinition = _fieldDefinition.copyWith(name: name);
    return this;
  }

  FieldDefinitionBuilder withTypeDefinition(
    String className, [
    bool nullable = false,
  ]) {
    var type = _fieldDefinition.type.copyWith(
      className: className,
      nullable: nullable,
    );

    _fieldDefinition = _fieldDefinition.copyWith(type: type);
    return this;
  }

  FieldDefinitionBuilder withType(TypeDefinition type) {
    _fieldDefinition = _fieldDefinition.copyWith(type: type);
    return this;
  }

  FieldDefinitionBuilder withScope(
    SerializableEntityFieldScope scope,
  ) {
    _fieldDefinition = _fieldDefinition.copyWith(scope: scope);
    return this;
  }

  FieldDefinitionBuilder withParentTable(
    String? parentTable,
  ) {
    _fieldDefinition = _fieldDefinition.copyWith(parentTable: parentTable);
    return this;
  }

  FieldDefinitionBuilder withDocumentation(
    List<String>? documentation,
  ) {
    _fieldDefinition = _fieldDefinition.copyWith(documentation: documentation);
    return this;
  }
}
