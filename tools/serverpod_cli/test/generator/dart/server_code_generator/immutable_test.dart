import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  group(
      'Given an immutable class named $testClassName with one primitive var when generating code',
      () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withIsImmutable(true)
          .withSimpleField('name', 'String')
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    group('then the $testClassName', () {
      var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      group('has a hashCode method', () {
        var hashCodeGetter = CompilationUnitHelpers.tryFindMethodDeclaration(
          baseClass!,
          name: 'hashCode',
        );

        test('declared.', () {
          expect(
            hashCodeGetter,
            isNotNull,
            reason: 'No hashCode method found on $testClassName',
          );
        });

        test('declared as a getter (no parameters).', () {
          expect(hashCodeGetter?.isGetter, equals(true));
          expect(
            hashCodeGetter?.parameters,
            isNull,
            reason: 'hashCode should not declare parameters',
          );
        }, skip: hashCodeGetter == null);

        test('with the return type of integer.', () {
          expect(hashCodeGetter?.returnType?.toSource(), equals('int'));
        }, skip: hashCodeGetter == null);
      }, skip: baseClass == null);

      group('has a == operator', () {
        var equalsOperator = CompilationUnitHelpers.tryFindMethodDeclaration(
          baseClass!,
          name: '==',
        );

        test('declared.', () {
          expect(
            equalsOperator,
            isNotNull,
            reason: 'No == operator found on $testClassName',
          );
        });

        test('declared as an operator.', () {
          expect(
            equalsOperator?.isOperator,
            equals(true),
            reason: '== should be declared as an operator',
          );
        }, skip: equalsOperator == null);

        test('with one parameter.', () {
          expect(
            equalsOperator?.parameters?.parameters.length,
            equals(1),
            reason: '== should have one parameter',
          );
        }, skip: equalsOperator == null);

        test('with the return type of boolean.', () {
          expect(equalsOperator?.returnType?.toSource(), equals('bool'));
        }, skip: equalsOperator == null);
      }, skip: baseClass == null);
    });
  });
}
