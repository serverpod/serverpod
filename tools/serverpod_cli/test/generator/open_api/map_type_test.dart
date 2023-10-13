import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Serialize Map TypeDefinition', () {
    test('When TypeDefinition is Map', () {
      TypeDefinition typeDefinition = TypeDefinition(
        className: 'Map',
        nullable: false,
      );
      expect(
        {
          'type': 'object',
        },
        mapTypeToJson(typeDefinition),
      );
    });

    test('When TypeDefinition is Map<String,String>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'String', nullable: false),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'string',
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });
    test('When TypeDefinition is Map<String,int>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'int', nullable: false),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'integer',
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });

    test('When TypeDefinition is Map<String,double>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'double', nullable: false),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'number',
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });
    test('When TypeDefinition is Map<String,BigInt>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'BigInt', nullable: false),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'number',
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });

    test('When TypeDefinition is Map<String,bool>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'String', nullable: false),
        TypeDefinition(className: 'bool', nullable: false),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'boolean',
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });

    test('When TypeDefinition is Map<String,List<String>>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'String', nullable: false),
        TypeDefinition(className: 'List', nullable: false, generics: [
          TypeDefinition(className: 'String', nullable: false),
        ]),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'array',
            'items': {'type': 'string'}
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });
    test('When TypeDefinition is Map<String,List<int>>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'String', nullable: false),
        TypeDefinition(className: 'List', nullable: false, generics: [
          TypeDefinition(className: 'int', nullable: false),
        ]),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'array',
            'items': {'type': 'integer'}
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });

    test('When TypeDefinition is Map<String,List<double>>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'String', nullable: false),
        TypeDefinition(className: 'List', nullable: false, generics: [
          TypeDefinition(className: 'double', nullable: false),
        ]),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'array',
            'items': {'type': 'number'}
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });

    test('When TypeDefinition is Map<String,List<bool>>', () {
      TypeDefinition typeDefinition =
          TypeDefinition(className: 'Map', nullable: false, generics: [
        TypeDefinition(className: 'String', nullable: false),
        TypeDefinition(className: 'List', nullable: false, generics: [
          TypeDefinition(className: 'bool', nullable: false),
        ]),
      ]);
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'array',
            'items': {'type': 'boolean'}
          }
        },
        mapTypeToJson(typeDefinition),
      );
    });
  });
}
