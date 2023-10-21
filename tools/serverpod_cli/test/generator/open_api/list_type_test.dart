import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  test(
      'Given \'List\' when converting to json then the type is set to array and items with AnyValue.',
      () {
    expect(
      listTypeToJson(listBuilder.build()),
      {
        'type': 'array',
        'items': {'\$ref': '#/components/schemas/AnyValue'}
      },
    );
  });
  test(
      'Given \'List<Example>\' when converting to json then the type is set to array and items with referencing the \'Example\' type.',
      () {
    expect(
      listTypeToJson(listBuilder.withGenerics([exampleType]).build()),
      {
        'type': 'array',
        'items': {
          '\$ref': '#/components/schemas/Example',
        }
      },
    );
  });

  test(
      'Given \'List<String>\' when converting to json then the type is set to array and items with the \'string\' type.',
      () {
    expect(
      listTypeToJson(listBuilder.withGenerics([stringType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'string',
        }
      },
    );
  });

  test(
      'Given \'List<int>\' when converting to json then the type is set to array and items with the \'integer\' type.',
      () {
    expect(
      listTypeToJson(listBuilder.withGenerics([intType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'integer',
        }
      },
    );
  });

  test(
      'Given \'List<double>\' when converting to json then the type is set to array and items with the \'number\' type.',
      () {
    expect(
      listTypeToJson(listBuilder.withGenerics([doubleType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'number',
        }
      },
    );
  });

  test(
      'Given \'List<BigInt>\' when converting to json then the type is set to array and items with the \'number\' type.',
      () {
    expect(
      listTypeToJson(listBuilder.withGenerics([bigIntType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'number',
        }
      },
    );
  });

  test(
      'Given \'List<bool>\' when converting to json then the type is set to array and items with the \'boolean\' type.',
      () {
    expect(
      listTypeToJson(listBuilder.withGenerics([boolType]).build()),
      {
        'type': 'array',
        'items': {
          'type': 'boolean',
        }
      },
    );
  });

  test(
      'Given \'List<List<String>>\' when converting to json then the type is set to array and items with the \'array\' type of \'string\'.',
      () {
    expect(
      listTypeToJson(
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
      'Given \'List<Map<String,String>>>\' when converting to json then the type is set to array and the items are represented as \'object\' with additionalProperties set to \'string\'.',
      () {
    expect(
      listTypeToJson(
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
}
