import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

class SerializableEntityFieldDefinitionBuilder {
  SerializableEntityFieldDefinition _fieldDefinition;

  SerializableEntityFieldDefinitionBuilder()
      : _fieldDefinition = SerializableEntityFieldDefinition(
          name: 'name',
          type: TypeDefinition(
            className: 'String',
            nullable: false,
          ),
          scope: SerializableEntityFieldScope.all,
        );

  SerializableEntityFieldDefinition build() => _fieldDefinition;

  SerializableEntityFieldDefinitionBuilder withFieldName(String name) {
    _fieldDefinition = _fieldDefinition.copyWith(name: name);
    return this;
  }

  SerializableEntityFieldDefinitionBuilder withTypeDefinition(
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

  SerializableEntityFieldDefinitionBuilder withType(TypeDefinition type) {
    _fieldDefinition = _fieldDefinition.copyWith(type: type);
    return this;
  }

  SerializableEntityFieldDefinitionBuilder withScope(
    SerializableEntityFieldScope scope,
  ) {
    _fieldDefinition = _fieldDefinition.copyWith(scope: scope);
    return this;
  }

  SerializableEntityFieldDefinitionBuilder withParentTable(
    String? parentTable,
  ) {
    _fieldDefinition = _fieldDefinition.copyWith(parentTable: parentTable);
    return this;
  }

  SerializableEntityFieldDefinitionBuilder withDocumentation(
    List<String>? documentation,
  ) {
    _fieldDefinition = _fieldDefinition.copyWith(documentation: documentation);
    return this;
  }
}
