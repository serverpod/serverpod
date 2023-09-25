import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');
  var tableName = 'example_table';

  group('Given a class with table name when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );
    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    test('then a class named ${testClassName}Include is generated.', () {
      expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: '${testClassName}Include',
          ),
          isTrue,
          reason: 'Missing class named ${testClassName}Include.');
    });
  });

  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withObjectRelationField('company', 'Company', 'company')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExampleInclude =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Include',
    );

    group('then the class named ${testClassName}Include', () {
      var exampleIncludeClass = maybeClassNamedExampleInclude!;
      test('inherits from Include.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              exampleIncludeClass,
              name: 'Include',
            ),
            isTrue,
            reason: 'Missing extends clause for Include.');
      });
      test('has named parameter for field in private constructor.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              exampleIncludeClass,
              name: '_',
              parameters: ['CompanyInclude? company'],
            ),
            isTrue,
            reason:
                'Missing constructor with named parameter for field in ${testClassName}Include.');
      });

      test('has private field as nullable class variable.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              exampleIncludeClass,
              name: '_company',
              type: 'CompanyInclude?',
            ),
            isTrue,
            reason:
                'Missing declaration for company field in ${testClassName}Include.');
      });
      test('has an includes method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              exampleIncludeClass,
              name: 'includes',
            ),
            isTrue,
            reason: 'Missing declaration for includes method.');
      });

      test('has a table method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              exampleIncludeClass,
              name: 'table',
              functionExpression: 'Example.t',
            ),
            isTrue,
            reason: 'Missing declaration for table method.');
      });
    },
        skip: maybeClassNamedExampleInclude == null
            ? 'Could not run test because ${testClassName}Include class was not found.'
            : false);
  });
}
