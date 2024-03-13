import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';

class ParameterDefinitionBuilder {
  String _name = 'example';
  TypeDefinition _type =
      TypeDefinitionBuilder().withClassName('String').build();
  bool _required = false;

  ParameterDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  ParameterDefinitionBuilder withType(TypeDefinition type) {
    _type = type;
    return this;
  }

  ParameterDefinitionBuilder withRequired(bool required) {
    _required = required;
    return this;
  }

  ParameterDefinition build() {
    return ParameterDefinition(
      name: _name,
      type: _type,
      required: _required,
    );
  }
}
