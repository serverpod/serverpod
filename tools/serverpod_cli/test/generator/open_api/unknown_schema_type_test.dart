import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  var dynamicType = TypeDefinitionBuilder().withClassName('dynamic').build();
  var exampleType = TypeDefinitionBuilder().withClassName('Example').build();
  var exampleTypeNullable = TypeDefinitionBuilder()
      .withClassName('Example')
      .withNullable(true)
      .build();
  test(
      'Given an Example type when converting to json then the type is set to object and is referencing to Example',
      () {
    expect(
      typeDefinitionToJson(exampleType),
      {
        'type': 'object',
        '\$ref': '#/components/schemas/Example',
      },
    );
  });
  test(
      'Given an Example type with the child arg set to true when converting to json then the type is set to object and is referencing to Example',
      () {
    expect(
      typeDefinitionToJson(exampleType),
      {
        'type': 'object',
        '\$ref': '#/components/schemas/Example',
      },
    );
  });
  test(
      'Given a nullable Example type when converting to json then the type is set to object, with a reference to Example, and is nullable.',
      () {
    expect(
      typeDefinitionToJson(exampleTypeNullable),
      {
        'type': ['object', 'null'],
        '\$ref': '#/components/schemas/Example',
      },
    );
  });
  test(
      'Given a nullable Example type with the child arg set to true when converting to json then got the expected output.',
      () {
    expect(
      typeDefinitionToJson(exampleTypeNullable, true),
      {'\$ref': '#/components/schemas/Example'},
    );
  });
  test(
      'Given an Example type  when converting to json with child set to true then  the type is excluded.',
      () {
    expect(
      typeDefinitionToJson(exampleType, true),
      {
        '\$ref': '#/components/schemas/Example',
      },
    );
  });

  test(
      'Given a dynamic value when converting to json then the type is set to object and is referencing to AnyValue',
      () {
    expect(
      typeDefinitionToJson(dynamicType),
      {
        'type': 'object',
        '\$ref': '#/components/schemas/AnyValue',
      },
    );
  });
  test(
      'Given a dynamic value with child set to true when converting to json then the ref is referencing to AnyValue.',
      () {
    expect(
      typeDefinitionToJson(dynamicType, true),
      {
        '\$ref': '#/components/schemas/AnyValue',
      },
    );
  });
}
