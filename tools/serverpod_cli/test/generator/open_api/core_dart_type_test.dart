import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  group('Serializes an \'int\'.', () {
    test(
        'Given an int when converting to json then the type is set to \'integer\'.',
        () {
      expect(
        coreDartTypeToJson(intType),
        {
          'type': 'integer',
        },
      );
    });

    test(
        'Given a nullable int when converting to json then the type is set to \'integer\' and is nullable.',
        () {
      expect(
        coreDartTypeToJson(intNullableType),
        {
          'type': 'integer',
          'nullable': true,
        },
      );
    });
  });

  group('Serializes a \'String\'.', () {
    test(
        'Given a String when converting to json then the type is set to \'string\'.',
        () {
      expect(
        coreDartTypeToJson(stringType),
        {
          'type': 'string',
        },
      );
    });

    test(
        'Given a nullable String when converting to json then the type is set to \'string\' and is nullable.',
        () {
      expect(
        coreDartTypeToJson(stringNullableType),
        {
          'type': 'string',
          'nullable': true,
        },
      );
    });
  });
  group('Serializes a \'double\'.', () {
    test(
        'Given a double when converting to json then the type is set to \'number\'.',
        () {
      expect(
        coreDartTypeToJson(doubleType),
        {
          'type': 'number',
        },
      );
    });

    test(
        'Given a nullable double when converting to json then the type is set to \'number\' and is nullable.',
        () {
      expect(
        coreDartTypeToJson(doubleNullableType),
        {
          'type': 'number',
          'nullable': true,
        },
      );
    });
  });

  group('Serializes a \'BigInt\'.', () {
    test(
        'Given a BigInt when converting to json then the type is set to \'number\'.',
        () {
      expect(
        coreDartTypeToJson(bigIntType),
        {
          'type': 'number',
        },
      );
    });

    test(
        'Given a nullable BigInt when converting to json then the type is set to \'number\' and is nullable.',
        () {
      expect(
        coreDartTypeToJson(bigIntNullableType),
        {
          'type': 'number',
          'nullable': true,
        },
      );
    });
  });

  group('Serializes a \'bool\'.', () {
    test(
        'Given an bool when converting to json then the type is set to \'boolean\'.',
        () {
      expect(
        coreDartTypeToJson(boolType),
        {
          'type': 'boolean',
        },
      );
    });

    test(
        'Given a nullable bool when converting to json then the type is set to \'boolean\' and is nullable.',
        () {
      expect(
        coreDartTypeToJson(boolNullableType),
        {
          'type': 'boolean',
          'nullable': true,
        },
      );
    });
  });
}
