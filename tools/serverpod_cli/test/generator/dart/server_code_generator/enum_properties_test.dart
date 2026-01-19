import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/enum_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join('lib', 'src', 'generated', 'example.dart');

  group(
    'Given an enhanced enum with custom properties when generating code',
    () {
      var models = [
        EnumDefinitionBuilder()
            .withClassName('HttpStatus')
            .withFileName('example')
            .withProperties([
              EnumPropertyDefinition(
                name: 'statusCode',
                type: 'int',
                isRequired: true,
              ),
              EnumPropertyDefinition(
                name: 'message',
                type: 'String',
                isRequired: true,
              ),
            ])
            .withValues([
              ProtocolEnumValueDefinition('ok', null, {
                'statusCode': 200,
                'message': "'OK'",
              }),
              ProtocolEnumValueDefinition('notFound', null, {
                'statusCode': 404,
                'message': "'Not Found'",
              }),
            ])
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      test(
        'then enum has final fields for each property',
        () {
          expect(codeMap[expectedFileName], contains('final int statusCode;'));
          expect(codeMap[expectedFileName], contains('final String message;'));
        },
      );

      test(
        'then enum has const constructor with property parameters',
        () {
          expect(codeMap[expectedFileName], contains('const HttpStatus('));
          expect(codeMap[expectedFileName], contains('this.statusCode,'));
          expect(codeMap[expectedFileName], contains('this.message,'));
        },
      );

      test(
        'then enum values include property arguments',
        () {
          expect(codeMap[expectedFileName], contains("ok(200, 'OK')"));
          expect(
            codeMap[expectedFileName],
            contains("notFound(404, 'Not Found')"),
          );
        },
      );
    },
  );

  group('Given a simple enum without properties when generating code', () {
    var models = [
      EnumDefinitionBuilder()
          .withClassName('SimpleEnum')
          .withFileName('example')
          .withValues([
            ProtocolEnumValueDefinition('first'),
            ProtocolEnumValueDefinition('second'),
          ])
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test(
      'then enum has no custom constructor',
      () {
        expect(
          codeMap[expectedFileName],
          isNot(contains('const SimpleEnum(')),
        );
      },
    );

    test(
      'then enum values are simple without arguments',
      () {
        expect(codeMap[expectedFileName], contains('first,'));
        expect(codeMap[expectedFileName], contains('second;'));
      },
    );
  });
}
