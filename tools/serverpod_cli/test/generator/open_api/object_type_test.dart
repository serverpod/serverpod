import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Serializes TypeDefinition: ', () {
    test('When TypeDefinition is Example', () {
      TypeDefinition type =
          TypeDefinition(className: 'Example', nullable: false);

      expect(
        {
          'type': 'object',
          '\$ref': '#/components/schemas/Example',
        },
        customClassToJson(type),
      );
    });
    test('When TypeDefinition is Example?', () {
      TypeDefinition type =
          TypeDefinition(className: 'Example', nullable: true);

      expect(
        {
          'type': 'object',
          '\$ref': '#/components/schemas/Example',
          'nullable': true
        },
        customClassToJson(type),
      );
    });
    test('When TypeDefinition is Example and return without type', () {
      TypeDefinition type =
          TypeDefinition(className: 'Example', nullable: true);

      expect(
        {
          '\$ref': '#/components/schemas/Example',
        },
        customClassToJson(type, true),
      );
    });

    test('When TypeDefinition is dynamic', () {
      TypeDefinition type =
          TypeDefinition(className: 'dynamic', nullable: false);

      expect(
        {
          'type': 'object',
          '\$ref': '#/components/schemas/AnyValue',
        },
        customClassToJson(type),
      );
    });
  });
}
