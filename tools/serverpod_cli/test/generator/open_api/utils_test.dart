import 'package:serverpod_cli/src/generator/open_api/helpers/extensions.dart';
import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  group('Test Utils: ', () {
    test(
        'Given a subDirs when calling `getExtraPath` Then it returns the expected path.',
        () {
      List<String> subDirs = [
        'api',
        'v1',
      ];
      expect('/api/v1', getExtraPath(subDirs));
    });
  });
  group('Given a set of `TypeDefinition`s', () {
    test(
        'When converting `TypeDefinition` to `OpenAPISchemaType` then all are converted as excepted.',
        () {
      expect(
        stringType.toOpenAPISchemaType,
        OpenAPISchemaType.string,
      );
      expect(
        intType.toOpenAPISchemaType,
        OpenAPISchemaType.integer,
      );
      expect(
        boolType.toOpenAPISchemaType,
        OpenAPISchemaType.boolean,
      );
      expect(
        boolType.toOpenAPISchemaType,
        OpenAPISchemaType.boolean,
      );
      expect(
        doubleType.toOpenAPISchemaType,
        OpenAPISchemaType.number,
      );
      expect(
        listBuilder.build().toOpenAPISchemaType,
        OpenAPISchemaType.array,
      );
      expect(
        mapBuilder.build().toOpenAPISchemaType,
        OpenAPISchemaType.object,
      );
      expect(
        exampleType.toOpenAPISchemaType,
        OpenAPISchemaType.serializableObjects,
      );
    });
  });
}
