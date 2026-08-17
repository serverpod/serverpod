import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_source_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

/// The generation of `detach`/`detachRow` for named list relations must not
/// depend on the order in which the model files are analyzed, and must only
/// happen when the foreign key field is nullable.
void main() {
  const companyYaml = '''
        class: Company
        table: company
        database: all
        fields:
          employees: List<Employee>?, relation(name=company_employees)
        ''';

  CompilationUnit generateCompanyCode(
    List<({String fileName, String yaml})> orderedModels,
  ) {
    var modelSources = orderedModels
        .map(
          (model) => ModelSourceBuilder()
              .withFileName(model.fileName)
              .withYaml(model.yaml)
              .build(),
        )
        .toList();

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      modelSources,
      onErrorsCollector(collector),
    );
    var models = analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected the models to be analyzed without errors.',
    );

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var companyFilePath = codeMap.keys
        .where((filePath) => filePath.endsWith('company.dart'))
        .firstOrNull;

    expect(
      companyFilePath,
      isNotNull,
      reason: 'Expected the code for the list owner to be generated.',
    );

    return parseString(content: codeMap[companyFilePath]!).unit;
  }

  group('Given a named one to many relation with a required foreign key,', () {
    const requiredForeignKeyEmployeeYaml = '''
        class: Employee
        table: employee
        database: all
        fields:
          company: Company?, relation(name=company_employees)
        ''';

    group('when the foreign class is analyzed before the list owner,', () {
      late CompilationUnit compilationUnit;

      setUp(() {
        compilationUnit = generateCompanyCode([
          (fileName: 'employee', yaml: requiredForeignKeyEmployeeYaml),
          (fileName: 'company', yaml: companyYaml),
        ]);
      });

      test('then a class named CompanyAttachRepository is generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyAttachRepository',
          ),
          isTrue,
          reason: 'Expected the class CompanyAttachRepository to be generated.',
        );
      });

      test('then a class named CompanyDetachRepository is NOT generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRepository',
          ),
          isFalse,
          reason:
              'The class CompanyDetachRepository was found but was expected '
              'to not exist.',
        );
      });

      test('then a class named CompanyDetachRowRepository is NOT generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRowRepository',
          ),
          isFalse,
          reason:
              'The class CompanyDetachRowRepository was found but was expected '
              'to not exist.',
        );
      });
    });

    group('when the list owner is analyzed before the foreign class,', () {
      late CompilationUnit compilationUnit;

      setUp(() {
        compilationUnit = generateCompanyCode([
          (fileName: 'company', yaml: companyYaml),
          (fileName: 'employee', yaml: requiredForeignKeyEmployeeYaml),
        ]);
      });

      test('then a class named CompanyAttachRepository is generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyAttachRepository',
          ),
          isTrue,
          reason: 'Expected the class CompanyAttachRepository to be generated.',
        );
      });

      test('then a class named CompanyDetachRepository is NOT generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRepository',
          ),
          isFalse,
          reason:
              'The class CompanyDetachRepository was found but was expected '
              'to not exist.',
        );
      });

      test('then a class named CompanyDetachRowRepository is NOT generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRowRepository',
          ),
          isFalse,
          reason:
              'The class CompanyDetachRowRepository was found but was expected '
              'to not exist.',
        );
      });
    });
  });

  group('Given a named one to many relation with an optional foreign key,', () {
    const optionalForeignKeyEmployeeYaml = '''
        class: Employee
        table: employee
        database: all
        fields:
          company: Company?, relation(name=company_employees, optional)
        ''';

    group('when the foreign class is analyzed before the list owner,', () {
      late CompilationUnit compilationUnit;

      setUp(() {
        compilationUnit = generateCompanyCode([
          (fileName: 'employee', yaml: optionalForeignKeyEmployeeYaml),
          (fileName: 'company', yaml: companyYaml),
        ]);
      });

      test('then a class named CompanyDetachRepository is generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRepository',
          ),
          isTrue,
          reason: 'Expected the class CompanyDetachRepository to be generated.',
        );
      });

      test('then a class named CompanyDetachRowRepository is generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRowRepository',
          ),
          isTrue,
          reason:
              'Expected the class CompanyDetachRowRepository to be generated.',
        );
      });
    });

    group('when the list owner is analyzed before the foreign class,', () {
      late CompilationUnit compilationUnit;

      setUp(() {
        compilationUnit = generateCompanyCode([
          (fileName: 'company', yaml: companyYaml),
          (fileName: 'employee', yaml: optionalForeignKeyEmployeeYaml),
        ]);
      });

      test('then a class named CompanyDetachRepository is generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRepository',
          ),
          isTrue,
          reason: 'Expected the class CompanyDetachRepository to be generated.',
        );
      });

      test('then a class named CompanyDetachRowRepository is generated', () {
        expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: 'CompanyDetachRowRepository',
          ),
          isTrue,
          reason:
              'Expected the class CompanyDetachRowRepository to be generated.',
        );
      });
    });
  });
}
