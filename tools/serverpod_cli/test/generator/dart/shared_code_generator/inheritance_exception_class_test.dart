import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const sharedPackageName = 'shared_pkg';
const projectName = 'example_project';
const serverPathParts = ['server_root'];
final config = GeneratorConfigBuilder()
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withModules([])
    .build();
const generator = DartSharedCodeGenerator();

void main() {
  var parentClassName = 'AppException';
  var parentClassFileName = 'app_exception';
  var parentExpectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$parentClassFileName.dart',
  ]);

  var childClassName = 'NotFoundException';
  var childClassFileName = 'not_found_exception';
  var childExpectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$childClassFileName.dart',
  ]);

  group(
    'Given a child exception named $childClassName extending a parent exception named $parentClassName when generating shared code',
    () {
      var parent = ExceptionClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('message', 'String')
          .withSharedPackageName(sharedPackageName)
          .build();

      var child = ExceptionClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSimpleField('code', 'int', nullable: true)
          .withExtendsClass(parent)
          .withSharedPackageName(sharedPackageName)
          .build();

      parent.childClasses.add(ResolvedInheritanceDefinition(child));

      var models = [parent, child];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var parentCompilationUnit = parseString(
        content: codeMap[parentExpectedFilePath]!,
      ).unit;
      late var childCompilationUnit = parseString(
        content: codeMap[childExpectedFilePath]!,
      ).unit;

      group('then the $parentClassName', () {
        late var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
          parentCompilationUnit,
          name: parentClassName,
        );

        test('is defined', () {
          expect(parentClass, isNotNull);
        });

        test('does have a toJson method', () {
          var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            parentClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);
        });
      });

      group('then the $childClassName', () {
        late var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
          childCompilationUnit,
          name: childClassName,
        );

        test('is defined', () {
          expect(childClass, isNotNull);
        });

        test('extends the parent exception', () {
          expect(
            childClass!.extendsClause?.superclass.toSource(),
            parentClassName,
          );
        });

        test('does have a toJson method', () {
          var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            childClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);
        });

        test('does have a fromJson factory constructor', () {
          var fromJsonConstructor = childClass!.body.childEntities
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
      });
    },
  );
}
