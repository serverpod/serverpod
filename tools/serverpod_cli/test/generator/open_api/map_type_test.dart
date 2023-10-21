import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  test('Given a Map when converting to json then the type is set to object.',
      () {
    expect(
      mapTypeToJson(mapBuilder.build()),
      {
        'type': 'object',
      },
    );
  });

  test(
      'Given a Map<String,String> when converting to json then the type is set to object with additionalProperties set to string.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,int> when converting to json then the type is set to object with additionalProperties set to integer.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,double> when converting to json then the type is set to object with additionalProperties set to number.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,BigInt> when converting to json then the type is set to object with additionalProperties set to number.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,bool> when converting to json then the type is set to object with additionalProperties set to boolean.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,List<String>> when converting to json then the type is set to object with additionalProperties set to array with items of string.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,List<int>> when converting to json then the type is set to object with additionalProperties set to array with items of integer.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,List<double>> when converting to json then the type is set to object with additionalProperties set to array with items of number.',
      () {
    expect(
      mapTypeToJson(
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
      'Given a Map<String,List<bool>> when converting to json then the type is set to object with additionalProperties set to array with items of boolean.',
      () {
    expect(
      mapTypeToJson(
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
