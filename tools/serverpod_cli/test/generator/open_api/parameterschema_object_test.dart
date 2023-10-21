import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  test(
      'Given a `OpenAPIParameterSchema` with `String`  when converting `OpenAPIParameterSchema` to json then the `type` is set to `string`.',
      () {
    OpenAPIParameterSchema object = OpenAPIParameterSchema(stringType);
    expect(
      object.toJson(),
      {'type': 'string'},
    );
  });
  test(
      'Given a `OpenAPIParameterSchema` with `int`  when converting `OpenAPIParameterSchema` to json then the `type` is set to `integer`.',
      () {
    OpenAPIParameterSchema object = OpenAPIParameterSchema(
      intType,
    );
    expect({'type': 'integer'}, object.toJson());
  });

  test(
      'Given a `OpenAPIParameterSchema` with `double`  when converting `OpenAPIParameterSchema` to json then the `type` is set to `integer`.',
      () {
    OpenAPIParameterSchema object = OpenAPIParameterSchema(
      doubleType,
    );
    expect({'type': 'number'}, object.toJson());
  });

  test(
      'Given a `OpenAPIParameterSchema` with `List<int>`  when converting `OpenAPIParameterSchema` to json then the `type` is set to `array` and `items` type is `integer`.',
      () {
    OpenAPIParameterSchema object =
        OpenAPIParameterSchema(listBuilder.withGenerics([intType]).build());
    expect({
      'type': 'array',
      'items': {
        'type': 'integer',
      }
    }, object.toJson());
  });

  test(
      'Given a `OpenAPIParameterSchema` with `List<String>`  when converting `OpenAPIParameterSchema` to json then the `type` is set to `array` and `items` type is `string`.',
      () {
    OpenAPIParameterSchema object =
        OpenAPIParameterSchema(listBuilder.withGenerics([stringType]).build());
    expect({
      'type': 'array',
      'items': {
        'type': 'string',
      }
    }, object.toJson());
  });

  test(
      'Given a `OpenAPIParameterSchema` with `List<double>`  when converting `OpenAPIParameterSchema` to json then the `type` is set to `array` and `items` type is `number`.',
      () {
    OpenAPIParameterSchema object =
        OpenAPIParameterSchema(listBuilder.withGenerics([doubleType]).build());
    expect({
      'type': 'array',
      'items': {
        'type': 'number',
      }
    }, object.toJson());
  });

  test(
      'Given a `OpenAPIParameterSchema` with `TestEnum`  when converting `OpenAPIParameterSchema` to json then the `type` is set to `string` and contains key enum.',
      () {
    OpenAPIParameterSchema object = OpenAPIParameterSchema(
      TypeDefinitionBuilder()
          .withClassName('TestEnum')
          .withIsEnum(true)
          .build(),
    );
    expect({'type': 'string', 'enum': {}}, object.toJson());
  });
}
