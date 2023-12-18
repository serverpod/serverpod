import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var repositoryClassName = '${testClassName}Repository';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  group('Given a class with table name when generating code', () {
    var tableName = 'example_table';
    var models = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );

    test('then a static db field is generated on the base class.', () {
      var dbField = CompilationUnitHelpers.tryFindFieldDeclaration(
        baseClass!,
        name: 'db',
      );

      expect(
        dbField?.fields.toSource(),
        'const db = $repositoryClassName._()',
      );
    });

    var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: repositoryClassName,
    );

    test('then the class name $repositoryClassName is generated', () {
      expect(
        repositoryClass,
        isNotNull,
        reason: 'Missing class named $repositoryClassName.',
      );
    });

    group('then the $repositoryClassName class', () {
      group('has a find method', () {
        var findMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'find',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'find',
            ),
            isTrue,
          );
        });

        test('that returns a future with a list of the base class', () {
          expect(
            findMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            findMethod?.returnType?.toSource(),
            contains('List<$testClassName>'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            findMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named optional param', () {
          var params = findMethod?.parameters?.toSource();
          expect(
            params,
            contains('WhereExpressionBuilder<${testClassName}Table>? where'),
          );
        });

        test('that takes the limit int as an optional param', () {
          expect(
            findMethod?.parameters?.toSource(),
            contains('int? limit'),
          );
        });

        test('that takes the offset int as an optional param', () {
          expect(
            findMethod?.parameters?.toSource(),
            contains('int? offset'),
          );
        });

        test('that takes the orderBy column as an optional param', () {
          expect(
            findMethod?.parameters?.toSource(),
            contains('OrderByBuilder<ExampleTable>? orderBy'),
          );
        });

        test('that takes the orderDescending bool as an optional param', () {
          expect(
            findMethod?.parameters?.toSource(),
            contains('bool orderDescending'),
          );
        });

        test('that takes the orderByList as an optional param', () {
          expect(
            findMethod?.parameters?.toSource(),
            contains('OrderByListBuilder<ExampleTable>? orderByList'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            findMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has a findFirstRow method', () {
        var findRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'findFirstRow',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'findFirstRow',
            ),
            isTrue,
          );
        });

        test('that returns a future with a nullable base class', () {
          expect(
            findRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            findRowMethod?.returnType?.toSource(),
            contains('$testClassName?'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            findRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named optional param', () {
          var params = findRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('WhereExpressionBuilder<${testClassName}Table>? where'),
          );
        });

        test('that takes the offset as a named optional param', () {
          var params = findRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('int? offset'),
          );
        });

        test('that takes the orderBy as a named optional param', () {
          var params = findRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('OrderByBuilder<ExampleTable>? orderBy'),
          );
        });

        test('that takes the orderBy as a named optional param', () {
          var params = findRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('OrderByListBuilder<ExampleTable>? orderByList'),
          );
        });

        test(
            'that takes the orderDescending as a named param with the default value false',
            () {
          var params = findRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('bool orderDescending = false'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            findRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has a findById method', () {
        var findByIdMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'findById',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'findById',
            ),
            isTrue,
          );
        });

        test('that returns a future with a nullable base class', () {
          expect(
            findByIdMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            findByIdMethod?.returnType?.toSource(),
            contains('$testClassName?'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            findByIdMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes an int as a required param', () {
          expect(
            findByIdMethod?.parameters?.toSource(),
            contains('int id'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            findByIdMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an insert method', () {
        var insertMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'insert',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'insert',
            ),
            isTrue,
          );
        });

        test('that returns a future with the base class', () {
          expect(
            insertMethod?.returnType?.toSource(),
            contains('Future<List<$testClassName>>'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            insertMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the row as a required param', () {
          expect(
            insertMethod?.parameters?.toSource(),
            contains('List<$testClassName> rows'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            insertMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an insert row method', () {
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'insertRow',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'insertRow',
            ),
            isTrue,
          );
        });

        test('that returns a future with the base class', () {
          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            insertRowMethod?.returnType?.toSource(),
            contains(testClassName),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the row as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('$testClassName row'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an update method', () {
        var updateMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'update',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'update',
            ),
            isTrue,
          );
        });

        test('that returns a future with the base class', () {
          expect(
            updateMethod?.returnType?.toSource(),
            contains('Future<List<$testClassName>>'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            updateMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the row as a required param', () {
          expect(
            updateMethod?.parameters?.toSource(),
            contains('List<$testClassName> rows'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            updateMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an update row method', () {
        var updateRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'updateRow',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'updateRow',
            ),
            isTrue,
          );
        });

        test('that returns a future with the base class', () {
          expect(
            updateRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            updateRowMethod?.returnType?.toSource(),
            contains(testClassName),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            updateRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the row as a required param', () {
          expect(
            updateRowMethod?.parameters?.toSource(),
            contains('$testClassName row'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            updateRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an delete method', () {
        var deleteMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'delete',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'delete',
            ),
            isTrue,
          );
        });

        test('that returns a future with the base class', () {
          expect(
            deleteMethod?.returnType?.toSource(),
            contains('Future<List<int>>'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            deleteMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the row as a required param', () {
          expect(
            deleteMethod?.parameters?.toSource(),
            contains('List<$testClassName> rows'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            deleteMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an delete row method', () {
        var deleteRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'deleteRow',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'deleteRow',
            ),
            isTrue,
          );
        });

        test('that returns a future with the base class', () {
          expect(
            deleteRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            deleteRowMethod?.returnType?.toSource(),
            contains('int'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            deleteRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the row as a required param', () {
          expect(
            deleteRowMethod?.parameters?.toSource(),
            contains('$testClassName row'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            deleteRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an delete where method', () {
        var deleteWhereMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'deleteWhere',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'deleteWhere',
            ),
            isTrue,
          );
        });

        test('that returns a future with a list of int', () {
          expect(
            deleteWhereMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            deleteWhereMethod?.returnType?.toSource(),
            contains('List<int>'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            deleteWhereMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named required param', () {
          var params = deleteWhereMethod?.parameters?.toSource();
          expect(
            params,
            contains('WhereExpressionBuilder<${testClassName}Table> where'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            deleteWhereMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an count method', () {
        var countMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'count',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'count',
            ),
            isTrue,
          );
        });

        test('that returns a future with a list of int', () {
          expect(
            countMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            countMethod?.returnType?.toSource(),
            contains('int'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            countMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named optional param', () {
          var params = countMethod?.parameters?.toSource();
          expect(
            params,
            contains('WhereExpressionBuilder<${testClassName}Table>? where'),
          );
        });

        test('that takes the limit int as an optional param', () {
          expect(
            countMethod?.parameters?.toSource(),
            contains('int? limit'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            countMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });
    }, skip: repositoryClass == null);
  });
}
