import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  group('Given generated code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSimpleField('title', 'String')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );
    test(
        'then all code contains instructions to not modify manually but instead to use the generate command.',
        () {
      for (var code in codeMap.values) {
        expect(
          code,
          contains('/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */'),
        );
        expect(
          code,
          contains('/*   To generate run: "serverpod generate"    */'),
        );
      }
    });

    test(
        'then all code contains ignore linting for library_private_types_in_public_api',
        () {
      for (var code in codeMap.values) {
        expect(
          code,
          contains('// ignore_for_file: library_private_types_in_public_api'),
        );
      }
    });

    test('then all code contains ignore linting for public_member_api_docs',
        () {
      for (var code in codeMap.values) {
        expect(
          code,
          contains('// ignore_for_file: public_member_api_docs'),
        );
      }
    });

    test('then all code contains ignore linting for implementation_imports',
        () {
      for (var code in codeMap.values) {
        expect(
          code,
          contains('// ignore_for_file: implementation_imports'),
        );
      }
    });
  });
}
