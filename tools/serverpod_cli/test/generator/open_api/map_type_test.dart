import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  var listBuilder = TypeDefinitionBuilder().withClassName('List');
  var stringType = TypeDefinitionBuilder().withClassName('String').build();
  var doubleType = TypeDefinitionBuilder().withClassName('double').build();
  var bigIntType = TypeDefinitionBuilder().withClassName('BigInt').build();
  var boolType = TypeDefinitionBuilder().withClassName('bool').build();
  var intType = TypeDefinitionBuilder().withClassName('int').build();
  var mapBuilder = TypeDefinitionBuilder().withClassName('Map');

  test('Given a Map when converting to json then the type is set to object.',
      () {
    expect(
      typeDefinitionToJson(mapBuilder.build()),
      {
        'type': 'object',
      },
    );
  });
  test('Given a Map when converting to json then the type is set to object.',
      () {
    expect(
      typeDefinitionToJson(mapBuilder.build(), true),
      {
        'type': 'object',
      },
    );
  });

  test(
      'Given a Map<String,String> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics([
          stringType,
          stringType,
        ]).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'string',
        }
      },
    );
  });
  test(
      'Given a Map<String,int> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics([
          stringType,
          intType,
        ]).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'integer',
        }
      },
    );
  });

  test(
      'Given a Map<String,double> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics([
          stringType,
          doubleType,
        ]).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'number',
        }
      },
    );
  });
  test(
      'Given a Map<String,BigInt> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics([
          stringType,
          bigIntType,
        ]).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'number',
        }
      },
    );
  });
  test(
      'Given a Map<String,bool> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics([
          stringType,
          boolType,
        ]).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'boolean',
        }
      },
    );
  });
  test(
      'Given a Map<String,List<String>> when converting to json then the type is set to object with the correct additionalProperties..',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics(
          [
            stringType,
            listBuilder.withGenerics(
              [stringType],
            ).build(),
          ],
        ).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'array',
          'items': {'type': 'string'}
        }
      },
    );
  });

  test(
      'Given a Map<String,List<int>> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics(
          [
            stringType,
            listBuilder.withGenerics(
              [intType],
            ).build(),
          ],
        ).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'array',
          'items': {'type': 'integer'}
        }
      },
    );
  });
  test(
      'Given a Map<String,List<double>> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics(
          [
            stringType,
            listBuilder.withGenerics(
              [doubleType],
            ).build(),
          ],
        ).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'array',
          'items': {'type': 'number'}
        }
      },
    );
  });
  test(
      'Given a Map<String,List<bool>> when converting to json then the type is set to object with the correct additionalProperties.',
      () {
    expect(
      typeDefinitionToJson(
        mapBuilder.withGenerics(
          [
            stringType,
            listBuilder.withGenerics(
              [boolType],
            ).build(),
          ],
        ).build(),
      ),
      {
        'type': 'object',
        'additionalProperties': {
          'type': 'array',
          'items': {'type': 'boolean'}
        }
      },
    );
  });
}
