import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/config/generator_config_options.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
const generator = DartServerCodeGenerator();

/// Pattern to match a required Transaction? parameter in method signatures.
final _requiredTransactionPattern = RegExp(
  r'required\s+\S*Transaction\?\s+transaction',
);

void main() {
  var testClassName = 'Example';
  var repositoryClassName = '${testClassName}Repository';
  var testClassFileName = 'example';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );

  group(
    'Given a class with table name when generating code with transaction_parameter set to optional',
    () {
      var tableName = 'example_table';
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .build(),
      ];

      late final config = GeneratorConfigBuilder()
          .withName(projectName)
          .withTransactionParameterMode(TransactionParameterMode.optional)
          .build();

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      late final repositoryClass =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: repositoryClassName,
          );

      test(
        'then transaction parameter is optional in the find method.',
        () {
          var findMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'find',
          );

          var params = findMethod?.parameters?.toSource() ?? '';
          // Check for optional Transaction? parameter (not required)
          expect(params, contains('Transaction?'));
          // Verify it does NOT have "required" before Transaction
          expect(
            params,
            isNot(matches(_requiredTransactionPattern)),
          );
        },
      );

      test(
        'then transaction parameter is optional in the insertRow method.',
        () {
          var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'insertRow',
          );

          var params = insertRowMethod?.parameters?.toSource() ?? '';
          // Check for optional Transaction? parameter (not required)
          expect(params, contains('Transaction?'));
          expect(
            params,
            isNot(matches(_requiredTransactionPattern)),
          );
        },
      );

      test(
        'then transaction parameter is optional in the deleteRow method.',
        () {
          var deleteRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'deleteRow',
          );

          var params = deleteRowMethod?.parameters?.toSource() ?? '';
          // Check for optional Transaction? parameter (not required)
          expect(params, contains('Transaction?'));
          expect(
            params,
            isNot(matches(_requiredTransactionPattern)),
          );
        },
      );
    },
  );

  group(
    'Given a class with table name when generating code with transaction_parameter set to required',
    () {
      var tableName = 'example_table';
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .build(),
      ];

      late final config = GeneratorConfigBuilder()
          .withName(projectName)
          .withTransactionParameterMode(TransactionParameterMode.required)
          .build();

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      late final repositoryClass =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: repositoryClassName,
          );

      test(
        'then transaction parameter is required in the find method.',
        () {
          var findMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'find',
          );

          var params = findMethod?.parameters?.toSource() ?? '';
          // Check for required Transaction? parameter
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the findFirstRow method.',
        () {
          var findFirstRowMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                repositoryClass!,
                name: 'findFirstRow',
              );

          var params = findFirstRowMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the findById method.',
        () {
          var findByIdMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'findById',
          );

          var params = findByIdMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the insert method.',
        () {
          var insertMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'insert',
          );

          var params = insertMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the insertRow method.',
        () {
          var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'insertRow',
          );

          var params = insertRowMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the update method.',
        () {
          var updateMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'update',
          );

          var params = updateMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the updateRow method.',
        () {
          var updateRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'updateRow',
          );

          var params = updateRowMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the updateById method.',
        () {
          var updateByIdMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                repositoryClass!,
                name: 'updateById',
              );

          var params = updateByIdMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the updateWhere method.',
        () {
          var updateWhereMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                repositoryClass!,
                name: 'updateWhere',
              );

          var params = updateWhereMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the delete method.',
        () {
          var deleteMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'delete',
          );

          var params = deleteMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the deleteRow method.',
        () {
          var deleteRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'deleteRow',
          );

          var params = deleteRowMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the deleteWhere method.',
        () {
          var deleteWhereMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                repositoryClass!,
                name: 'deleteWhere',
              );

          var params = deleteWhereMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );

      test(
        'then transaction parameter is required in the count method.',
        () {
          var countMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'count',
          );

          var params = countMethod?.parameters?.toSource() ?? '';
          expect(
            params,
            matches(_requiredTransactionPattern),
          );
        },
      );
    },
  );
}
