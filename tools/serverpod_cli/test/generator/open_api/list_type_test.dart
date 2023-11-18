import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  var listBuilder = TypeDefinitionBuilder().withClassName('List');
  var exampleType = TypeDefinitionBuilder().withClassName('Example').build();
  var stringType = TypeDefinitionBuilder().withClassName('String').build();
  var doubleType = TypeDefinitionBuilder().withClassName('double').build();
  var bigIntType = TypeDefinitionBuilder().withClassName('BigInt').build();
  var boolType = TypeDefinitionBuilder().withClassName('bool').build();
  var intType = TypeDefinitionBuilder().withClassName('int').build();
  var mapBuilder = TypeDefinitionBuilder().withClassName('Map');

  test(
      'Given a List when converting to json then the type is set to array and items with AnyValue.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.build()),
      {
        'type': 'array',
        'items': {'\$ref': '#/components/schemas/AnyValue'}
      },
    );
  });
  test(
      'Given a List with the child arg set to true when converting to json then the type is set to array and items with AnyValue.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.build(), true),
      {
        'type': 'array',
        'items': {'\$ref': '#/components/schemas/AnyValue'}
      },
    );
  });
  test(
      'Given List<Example> when converting to json then the type is set to array and items with referencing the Example type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([exampleType]).build()),
      {
        'type': 'array',
        'items': {
          '\$ref': '#/components/schemas/Example',
        }
      },
    );
  });
  test(
      'Given a List<Example> with the child arg set to true when converting to json then the type is set to array and items with referencing the Example type.',
      () {
    expect(
      typeDefinitionToJson(
          listBuilder.withGenerics([exampleType]).build(), true),
      {
        'type': 'array',
        'items': {
          '\$ref': '#/components/schemas/Example',
        }
      },
    );
  });

  test(
      'Given a List<String> when converting to json then the type is set to array and items with the string type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([stringType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'string',
        }
      },
    );
  });
  test(
      'Given a List<String> with the child arg set to true when converting to json then the type is set to array and items with the string type.',
      () {
    expect(
      typeDefinitionToJson(
          listBuilder.withGenerics([stringType]).build(), true),
      {
        'type': 'array',
        'items': {
          'type': 'string',
        }
      },
    );
  });

  test(
      'Given a List<int> with the child arg set to true when converting to json then the type is set to array and items with the integer type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([intType]).build(), true),
      {
        'type': 'array',
        'items': {
          'type': 'integer',
          'format': 'int64',
        }
      },
    );
  });
  test(
      'Given a List<int> when converting to json then the type is set to array and items with the integer type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([intType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'integer',
          'format': 'int64',
        }
      },
    );
  });
  test(
      'Given a List<double> when converting to json then the type is set to array and items with the number type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([doubleType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'number',
          'format': 'float',
        }
      },
    );
  });
  test(
      'Given a List<double> with the child arg set to true when converting to json then the type is set to array and items with the number type.',
      () {
    expect(
      typeDefinitionToJson(
          listBuilder.withGenerics([doubleType]).build(), true),
      {
        'type': 'array',
        'items': {
          'type': 'number',
          'format': 'float',
        }
      },
    );
  });

  test(
      'Given a List<BigInt> when converting to json then the type is set to array and items with the number type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([bigIntType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'number',
        }
      },
    );
  });
  test(
      'Given a List<BigInt> with the child arg set to true when converting to json then the type is set to array and items with the number type.',
      () {
    expect(
      typeDefinitionToJson(
          listBuilder.withGenerics([bigIntType]).build(), true),
      {
        'type': 'array',
        'items': {
          'type': 'number',
        }
      },
    );
  });

  test(
      'Given a List<bool> when converting to json then the type is set to array and items with the boolean type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([boolType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'boolean',
        }
      },
    );
  });
  test(
      'Given a List<bool> with the child arg set to true when converting to json then the type is set to array and items with the boolean type.',
      () {
    expect(
      typeDefinitionToJson(listBuilder.withGenerics([boolType]).build(), true),
      {
        'type': 'array',
        'items': {
          'type': 'boolean',
        }
      },
    );
  });

  test(
      'Given a List<List<String>> when converting to json then the type is set to array and items with the array type of string.',
      () {
    expect(
      typeDefinitionToJson(
        listBuilder.withGenerics(
          [
            listBuilder.withGenerics([stringType]).build(),
          ],
        ).build(),
      ),
      {
        'type': 'array',
        'items': {
          'type': 'array',
          'items': {
            'type': 'string',
          }
        }
      },
    );
  });
  test(
      'Given a List<List<String>> with the child arg set to true when converting to json then the type is set to array and items with the array type of string.',
      () {
    expect(
      typeDefinitionToJson(
          listBuilder.withGenerics(
            [
              listBuilder.withGenerics([stringType]).build(),
            ],
          ).build(),
          true),
      {
        'type': 'array',
        'items': {
          'type': 'array',
          'items': {
            'type': 'string',
          }
        }
      },
    );
  });
  test(
      'Given a List<Map<String,String>>> when converting to json then the type is set to array and the items are represented as object with additionalProperties set to string.',
      () {
    expect(
      typeDefinitionToJson(
        listBuilder.withGenerics(
          [
            mapBuilder.withGenerics([
              stringType,
              stringType,
            ]).build(),
          ],
        ).build(),
      ),
      {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': {
            'type': 'string',
          }
        }
      },
    );
  });
  test(
      'Given a List<Map<String,String>>> with the child arg set to true when converting to json then the type is set to array and the items are represented as object with additionalProperties set to string.',
      () {
    expect(
      typeDefinitionToJson(
          listBuilder.withGenerics(
            [
              mapBuilder.withGenerics([
                stringType,
                stringType,
              ]).build(),
            ],
          ).build(),
          true),
      {
        'type': 'array',
        'items': {
          'type': 'object',
          'additionalProperties': {
            'type': 'string',
          }
        }
      },
    );
  });
}
