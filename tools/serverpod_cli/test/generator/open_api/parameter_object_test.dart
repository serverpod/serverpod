import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Validate ParameterObject: ', () {
    test('when query name is status and type is String', () {
      ParameterObject object = ParameterObject(
        name: 'status',
        inField: ParameterLocation.query,
        requiredField: true,
        allowEmptyValue: false,
        schema: ParameterSchemaObject(
          TypeDefinition(className: 'String', nullable: false),
        ),
      );

      expect({
        'name': 'status',
        'in': 'query',
        'required': true,
        'schema': {
          'type': 'string',
        }
      }, object.toJson());
    });

    test('when path name is status and type is String', () {
      ParameterObject object = ParameterObject(
        name: 'status',
        inField: ParameterLocation.path,
        requiredField: true,
        allowEmptyValue: false,
        schema: ParameterSchemaObject(
          TypeDefinition(
            className: 'String',
            nullable: false,
            url: 'dart:core',
          ),
        ),
      );

      expect(
        {
          'name': 'status',
          'in': 'path',
          'required': true,
          'schema': {
            'type': 'string',
          }
        },
        object.toJson(),
      );
    });

    test('when header name is Authorization and type is String', () {
      ParameterObject object = ParameterObject(
        name: 'Authorization',
        inField: ParameterLocation.header,
        requiredField: true,
        allowEmptyValue: false,
        schema: ParameterSchemaObject(
          TypeDefinition(
            className: 'String',
            nullable: false,
            url: 'dart:core',
          ),
        ),
      );

      expect(
        {
          'name': 'Authorization',
          'in': 'header',
          'required': true,
          'schema': {
            'type': 'string',
          }
        },
        object.toJson(),
      );
    });
  });
}
