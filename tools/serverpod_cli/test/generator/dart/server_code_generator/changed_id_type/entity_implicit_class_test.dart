import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.type.className;
    var idTypeAlias = idType.aliases.first;

    group('Given the id type is $idTypeAlias', () {
      group(
          'Given a class with a field that should persist but is scoped too none',
          () {
        var models = [
          ModelClassDefinitionBuilder()
              .withClassName(testClassName)
              .withFileName(testClassFileName)
              .withTableName('example')
              .withIdFieldType(idType)
              .withSimpleField('extra', 'bool')
              .withField(FieldDefinitionBuilder()
                  .withName('_name')
                  .withType(TypeDefinition(className: 'String', nullable: true))
                  .withShouldPersist(true)
                  .withScope(ModelFieldScopeDefinition.none)
                  .build())
              .build()
        ];

        var codeMap = generator.generateSerializableModelsCode(
          models: models,
          config: config,
        );

        var compilationUnit =
            parseString(content: codeMap[expectedFilePath]!).unit;

        var implicitClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: '${testClassName}Implicit',
        );

        test(
            'then an implicit class named ${testClassName}Implicit is correctly generated',
            () {
          expect(implicitClass, isNotNull);
        });

        test(
            'then the private constructor have the id parameter with type $idClassName',
            () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
            implicitClass!,
            name: '_',
          );

          expect(
            constructor?.parameters.toSource(),
            contains('$idClassName? id, required bool extra, this.\$_name})'),
          );
        });
      });
    });
  }
}
