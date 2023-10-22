import 'package:serverpod_cli/src/generator/open_api/helpers/extensions.dart';
import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  group('Test Utils: ', () {
    test(
        'Given a subDirs when calling getExtraPath Then it returns the expected path.',
        () {
      List<String> subDirs = [
        'api',
        'v1',
      ];
      expect('/api/v1', getExtraPath(subDirs));
    });
  });
  group('Convert TypeDefinition to OpenAPISchemaType.', () {
    test('Given a String when converting it then get OpenAPISchemaType.string.',
        () {
      expect(
        stringType.toOpenAPISchemaType,
        OpenAPISchemaType.string,
      );
    });
    test('Given an int when converting it then get OpenAPISchemaType.integer.',
        () {
      expect(
        intType.toOpenAPISchemaType,
        OpenAPISchemaType.integer,
      );
    });
    test('Given a bool when converting it then get OpenAPISchemaType.boolean.',
        () {
      expect(
        boolType.toOpenAPISchemaType,
        OpenAPISchemaType.boolean,
      );
    });
    test('Given a double when converting it then get OpenAPISchemaType.number.',
        () {
      expect(
        doubleType.toOpenAPISchemaType,
        OpenAPISchemaType.number,
      );
    });
    test('Given a BigInt when converting it then get OpenAPISchemaType.number.',
        () {
      expect(
        bigIntType.toOpenAPISchemaType,
        OpenAPISchemaType.number,
      );
    });

    test('Given a List when converting it then get OpenAPISchemaType.array.',
        () {
      expect(
        listBuilder.build().toOpenAPISchemaType,
        OpenAPISchemaType.array,
      );
    });

    test('Given a Map when converting it then get OpenAPISchemaType.object.',
        () {
      expect(
        mapBuilder.build().toOpenAPISchemaType,
        OpenAPISchemaType.object,
      );
    });

    test(
        'Given an Example class when converting it then get OpenAPISchemaType.serializableObjects.',
        () {
      expect(
        exampleType.toOpenAPISchemaType,
        OpenAPISchemaType.serializableObjects,
      );
    });
    test(
        'Given a dynamic type when converting it then get OpenAPISchemaType.serializableObjects.',
        () {
      expect(
        dynamicType.toOpenAPISchemaType,
        OpenAPISchemaType.serializableObjects,
      );
    });
  });
}
