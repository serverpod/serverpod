import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  String getExpectedFilePath(String fileName) => p.joinAll([
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$fileName.dart',
  ]);

  group(
    'Given a hierarchy with a non-sealed parent exception and a child exception when generating code',
    () {
      var parent = ExceptionClassDefinitionBuilder()
          .withClassName('AppException')
          .withFileName('app_exception')
          .withSimpleField('message', 'String')
          .build();

      var child = ExceptionClassDefinitionBuilder()
          .withClassName('NotFoundException')
          .withFileName('not_found_exception')
          .withSimpleField('code', 'int')
          .withExtendsClass(parent)
          .build();

      parent.childClasses.add(ResolvedInheritanceDefinition(child));

      var models = [parent, child];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var parentCompilationUnit = parseString(
        content: codeMap[getExpectedFilePath(parent.fileName)]!,
      ).unit;
      var childCompilationUnit = parseString(
        content: codeMap[getExpectedFilePath(child.fileName)]!,
      ).unit;

      group('then the ${parent.className}', () {
        var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
          parentCompilationUnit,
          name: parent.className,
        );

        test('is defined.', () {
          expect(parentClass, isNotNull);
        });

        test('is not declared sealed.', () {
          expect(parentClass!.toSource(), isNot(contains('sealed class')));
        });

        test('does NOT have a part directive.', () {
          var partDirective = CompilationUnitHelpers.tryFindPartDirective(
            parentCompilationUnit,
            uri: '${child.fileName}.dart',
          );

          expect(partDirective, isNull);
        });

        test('does have a toJson method.', () {
          var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            parentClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);
        });

        test('does have a toString method.', () {
          var toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            parentClass!,
            name: 'toString',
          );

          expect(toStringMethod, isNotNull);
        });
      });

      group('then the ${child.className}', () {
        var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
          childCompilationUnit,
          name: child.className,
        );

        test('is defined.', () {
          expect(childClass, isNotNull);
        });

        test('does NOT have a part-of directive.', () {
          var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
            childCompilationUnit,
            uri: '${parent.fileName}.dart',
          );

          expect(partOfDirective, isNull);
        });

        test('extends the parent exception.', () {
          expect(
            childClass!.extendsClause?.superclass.toSource(),
            parent.className,
          );
        });

        test('does have a toJson method.', () {
          var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            childClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);
        });

        test('does have a fromJson factory constructor.', () {
          var fromJsonConstructor = childClass!.members
              .whereType<ConstructorDeclaration>()
              .where(
                (constructor) => constructor.factoryKeyword != null,
              );

          expect(
            fromJsonConstructor.any(
              (constructor) => constructor.name?.lexeme == 'fromJson',
            ),
            isTrue,
          );
        });

        test('does have a toString method.', () {
          var toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            childClass!,
            name: 'toString',
          );

          expect(toStringMethod, isNotNull);
        });
      });
    },
  );
}
