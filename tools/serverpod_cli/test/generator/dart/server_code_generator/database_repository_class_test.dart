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
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
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
            insertRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('List<$testClassName>'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named optional param', () {
          var params = insertRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('${testClassName}ExpressionBuilder? where'),
          );
        });

        test('that takes the limit int as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('int? limit'),
          );
        });

        test('that takes the offset int as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('int? offset'),
          );
        });

        test('that takes the orderBy column as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Column? orderBy'),
          );
        });

        test('that takes the orderDescending bool as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('bool orderDescending'),
          );
        });

        test('that takes the orderByList as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('orderByList'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has a findRow method', () {
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'findRow',
        );
        test('defined', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              repositoryClass,
              name: 'findRow',
            ),
            isTrue,
          );
        });

        test('that returns a future with a nullable base class', () {
          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('$testClassName?'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named optional param', () {
          var params = insertRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('${testClassName}ExpressionBuilder? where'),
          );
        });

        test('that takes the offset as a named optional param', () {
          var params = insertRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('int? offset'),
          );
        });

        test('that takes the orderBy as a named optional param', () {
          var params = insertRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('Column? orderBy'),
          );
        });

        test(
            'that takes the orderDescending as a named param with the default value false',
            () {
          var params = insertRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('bool orderDescending = false'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has a findById method', () {
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
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
            insertRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('$testClassName?'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes an int as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('int id'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
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

      group('has an update row method', () {
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
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

      group('has an delete row method', () {
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
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
            insertRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('int'),
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

      group('has an delete where method', () {
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
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
            insertRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('List<int>'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named required param', () {
          var params = insertRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('required ${testClassName}ExpressionBuilder where'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });

      group('has an count method', () {
        var insertRowMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
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
            insertRowMethod?.returnType?.toSource(),
            contains('Future'),
          );

          expect(
            insertRowMethod?.returnType?.toSource(),
            contains('int'),
          );
        });

        test('that takes the session as a required param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Session session'),
          );
        });

        test('that takes the where callback as a named optional param', () {
          var params = insertRowMethod?.parameters?.toSource();
          expect(
            params,
            contains('${testClassName}ExpressionBuilder? where'),
          );
        });

        test('that takes the limit int as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('int? limit'),
          );
        });

        test('that takes the transaction object as an optional param', () {
          expect(
            insertRowMethod?.parameters?.toSource(),
            contains('Transaction? transaction'),
          );
        });
      });
    }, skip: repositoryClass == null);
  });
}
