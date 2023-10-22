import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  test(
      'Given an Example type when converting unknownSchemaType to json then the type is set to object and is referencing to Example',
      () {
    expect(
      unknownSchemaTypeToJson(exampleType),
      {
        'type': 'object',
        '\$ref': '#/components/schemas/Example',
      },
    );
  });
  test(
      'Given a nullable Example type when converting unknownSchemaType to json then the type is set to object, with a reference to Example, and is nullable.',
      () {
    expect(
      unknownSchemaTypeToJson(exampleTypeNullable),
      {
        'type': 'object',
        '\$ref': '#/components/schemas/Example',
        'nullable': true
      },
    );
  });
  test(
      'Given an Example type  when converting unknownSchemaType to json with child set to true then  the type is excluded.',
      () {
    expect(
      unknownSchemaTypeToJson(exampleType, true),
      {
        '\$ref': '#/components/schemas/Example',
      },
    );
  });

  test(
      'Given a dynamic value when converting unknownSchemaType to json then the type is set to object and is referencing to AnyValue',
      () {
    expect(
      unknownSchemaTypeToJson(dynamicType),
      {
        'type': 'object',
        '\$ref': '#/components/schemas/AnyValue',
      },
    );
  });
}
