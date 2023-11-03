import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

void main() {
  var intType = TypeDefinitionBuilder().withClassName('int').build();
  var intNullableType =
      TypeDefinitionBuilder().withClassName('int').withNullable(true).build();

  var stringType = TypeDefinitionBuilder().withClassName('String').build();
  var stringNullableType = TypeDefinitionBuilder()
      .withClassName('String')
      .withNullable(true)
      .build();

  var doubleType = TypeDefinitionBuilder().withClassName('double').build();
  var doubleNullableType = TypeDefinitionBuilder()
      .withClassName('double')
      .withNullable(true)
      .build();

  var bigIntType = TypeDefinitionBuilder().withClassName('BigInt').build();
  var bigIntNullableType = TypeDefinitionBuilder()
      .withClassName('BigInt')
      .withNullable(true)
      .build();

  var boolType = TypeDefinitionBuilder().withClassName('bool').build();
  var boolNullableType =
      TypeDefinitionBuilder().withClassName('bool').withNullable(true).build();
  group('Serializes an int.', () {
    test(
        'Given an int when converting to json then the type is set to integer.',
        () {
      expect(
        typeDefinitionToJson(intType),
        {
          'type': 'integer',
          'format': 'int64',
        },
      );
    });

    test(
        'Given a nullable int when converting to json then the type is set to integer and is nullable.',
        () {
      expect(
        typeDefinitionToJson(intNullableType),
        {
          'type': ['integer', 'null'],
          'format': 'int64',
        },
      );
    });
  });

  group('Serializes a String.', () {
    test(
        'Given a String when converting to json then the type is set to string.',
        () {
      expect(
        typeDefinitionToJson(stringType),
        {
          'type': 'string',
        },
      );
    });

    test(
        'Given a nullable String when converting to json then the type is set to string and is nullable.',
        () {
      expect(
        typeDefinitionToJson(stringNullableType),
        {
          'type': ['string', 'null'],
        },
      );
    });
  });
  group('Serializes a double.', () {
    test(
        'Given a double when converting to json then the type is set to number.',
        () {
      expect(
        typeDefinitionToJson(doubleType),
        {
          'type': 'number',
          'format': 'float',
        },
      );
    });

    test(
        'Given a nullable double when converting to json then the type is set to number and is nullable.',
        () {
      expect(
        typeDefinitionToJson(doubleNullableType),
        {
          'type': ['number', 'null'],
          'format': 'float',
        },
      );
    });
  });

  group('Serializes a BigInt.', () {
    test(
        'Given a BigInt when converting to json then the type is set to number.',
        () {
      expect(
        typeDefinitionToJson(bigIntType),
        {
          'type': 'number',
        },
      );
    });

    test(
        'Given a nullable BigInt when converting to json then the type is set to number and is nullable.',
        () {
      expect(
        typeDefinitionToJson(bigIntNullableType),
        {
          'type': ['number', 'null'],
        },
      );
    });
  });

  group('Serializes a bool.', () {
    test(
        'Given an bool when converting to json then the type is set to boolean.',
        () {
      expect(
        typeDefinitionToJson(boolType),
        {
          'type': 'boolean',
        },
      );
    });

    test(
        'Given a nullable bool when converting to json then the type is set to boolean and is nullable.',
        () {
      expect(
        typeDefinitionToJson(boolNullableType),
        {
          'type': ['boolean', 'null'],
        },
      );
    });
  });
}
