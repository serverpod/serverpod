import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  var listBuilder = TypeDefinitionBuilder().withClassName('List');
  var stringType = TypeDefinitionBuilder().withClassName('String').build();
  var doubleType = TypeDefinitionBuilder().withClassName('double').build();
  var intType = TypeDefinitionBuilder().withClassName('int').build();

  test(
      'Given an OpenAPIParameterSchema with String when converting to json then the type is set to string.',
      () {
    OpenAPIParameterSchema object = OpenAPIParameterSchema(stringType);
    expect(
      object.toJson(),
      {'type': 'string'},
    );
  });
  test(
      'Given an OpenAPIParameterSchema with int when converting to json then the type is set to integer.',
      () {
    OpenAPIParameterSchema object = OpenAPIParameterSchema(
      intType,
    );
    expect({
      'type': 'integer',
      'format': 'int64',
    }, object.toJson());
  });

  test(
      'Given an OpenAPIParameterSchema with double when converting to json then the type is set to integer.',
      () {
    OpenAPIParameterSchema object = OpenAPIParameterSchema(
      doubleType,
    );
    expect({
      'type': 'number',
      'format': 'float',
    }, object.toJson());
  });

  test(
      'Given an OpenAPIParameterSchema with List<int> when converting to json then the type is set to array and items type is integer.',
      () {
    OpenAPIParameterSchema object =
        OpenAPIParameterSchema(listBuilder.withGenerics([intType]).build());
    expect({
      'type': 'array',
      'items': {
        'type': 'integer',
        'format': 'int64',
      }
    }, object.toJson());
  });

  test(
      'Given an OpenAPIParameterSchema with List<String> when converting to json then the type is set to array and items type is string.',
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
      'Given an OpenAPIParameterSchema with List<double> when converting to json then the type is set to array and items type is number.',
      () {
    OpenAPIParameterSchema object =
        OpenAPIParameterSchema(listBuilder.withGenerics([doubleType]).build());
    expect({
      'type': 'array',
      'items': {
        'type': 'number',
        'format': 'float',
      }
    }, object.toJson());
  });

  test(
      'Given an OpenAPIParameterSchema with TestEnum when converting to json then the type is set to string and contains key enum.',
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
