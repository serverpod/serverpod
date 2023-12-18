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

    test(
        'then a class named ${testClassName}AttachRowRepository is NOT generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}AttachRowRepository',
        ),
        isFalse,
        reason:
            'The class ${testClassName}AttachRowRepository was found but was expected to not exist.',
      );
    });

    test(
        'then a class named ${testClassName}DetachRowRepository is NOT generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}DetachRowRepository',
        ),
        isFalse,
        reason:
            'The class ${testClassName}DetachRowRepository was found but was expected to not exist.',
      );
    });
  });
  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example_table')
          .withObjectRelationField(
            'company',
            'Company',
            'company',
            nullableRelation: true,
          )
          .withObjectRelationField(
            'address',
            'Address',
            'address',
            foreignKeyFieldName: 'companyAddressId',
          )
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Repository',
    );

    group('then the class name ${testClassName}Repository', () {
      test('has a final attach field', () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          repositoryClass!,
          name: 'attachRow',
        );

        expect(
          field?.toSource(),
          'final attachRow = const ${testClassName}AttachRowRepository._();',
          reason: 'Missing static instance field.',
        );
      });

      test('has a final detach field', () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          repositoryClass!,
          name: 'detachRow',
        );

        expect(
          field?.toSource(),
          'final detachRow = const ${testClassName}DetachRowRepository._();',
          reason: 'Missing static instance field.',
        );
      });
    }, skip: repositoryClass == null);

    test('then a class named ${testClassName}AttachRowRepository is generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}AttachRowRepository',
        ),
        isTrue,
        reason:
            'Expected the class ${testClassName}AttachRowRepository to be generated.',
      );
    });

    var repositoryAttachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRowRepository',
    );

    group('then the ${testClassName}AttachRowRepository', () {
      test('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          repositoryAttachClass!,
          name: '_',
        );
        expect(
          constructor?.toSource(),
          'const ${testClassName}AttachRowRepository._();',
          reason: 'Missing private constructor.',
        );
      });

      var companyMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryAttachClass!,
        name: 'company',
      );

      test('has a company method defined.', () {
        expect(companyMethod, isNotNull, reason: 'Missing company method.');
      });

      test(
          'company method has the input params of session, example and company',
          () {
        expect(
          companyMethod?.parameters?.toSource(),
          matches(
            r'(_i\d.Session session, Example example, Company company)',
          ),
        );
      }, skip: companyMethod == null);

      var addressMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryAttachClass,
        name: 'address',
      );

      test('has a address method defined.', () {
        expect(addressMethod, isNotNull, reason: 'Missing address method.');
      });

      test(
          'the address method has the input params of session, example and address',
          () {
        expect(
          addressMethod?.parameters?.toSource(),
          matches(
            r'(_i\d.Session session, Example example, Address address)',
          ),
        );
      }, skip: addressMethod == null);

      test('has no method for the id field', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            repositoryAttachClass,
            name: 'id',
          ),
          isFalse,
        );
      });

      test('has no method for the companyId field', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            repositoryAttachClass,
            name: 'companyId',
          ),
          isFalse,
        );
      });

      test('has no method for the companyAddressId field', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            repositoryAttachClass,
            name: 'companyAddressId',
          ),
          isFalse,
        );
      });
    }, skip: repositoryClass == null);

    test('then a class named ${testClassName}DetachRowRepository is generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}DetachRowRepository',
        ),
        isTrue,
        reason:
            'Expected the class ${testClassName}DetachRowRepository to be generated.',
      );
    });

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRowRepository',
    );
    group('then the ${testClassName}DetachRowRepository', () {
      test('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          repositoryDetachClass!,
          name: '_',
        );
        expect(
          constructor?.toSource(),
          'const ${testClassName}DetachRowRepository._();',
          reason: 'Missing private constructor.',
        );
      });

      var companyMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryDetachClass!,
        name: 'company',
      );

      test('has a company method defined.', () {
        expect(companyMethod, isNotNull, reason: 'Missing company method.');
      });

      test('company method has the input params of session, example', () {
        expect(
          companyMethod?.parameters?.toSource(),
          '(_i1.Session session, Example example)',
        );
      }, skip: companyMethod == null);

      var addressMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryDetachClass,
        name: 'address',
      );

      test('has NOT an address method defined for none nullable relation.', () {
        expect(addressMethod, isNull, reason: 'Missing address method.');
      });

      test('has no method for the id field', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            repositoryDetachClass,
            name: 'id',
          ),
          isFalse,
        );
      });

      test('has no method for the companyId field', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            repositoryDetachClass,
            name: 'companyId',
          ),
          isFalse,
        );
      });

      test('has no method for the companyAddressId field', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            repositoryDetachClass,
            name: 'companyAddressId',
          ),
          isFalse,
        );
      });
    }, skip: repositoryClass == null);
  });

  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example')
          .withObjectRelationField('company', 'Company', 'company')
          .withObjectRelationFieldNoForeignKey(
            'address',
            'Address',
            'address',
          )
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRowRepository',
    );

    test('then no detach repository is generated', () {
      expect(
        repositoryDetachClass,
        isNull,
        reason:
            'The class ${testClassName}DetachRowRepository was found but was expected to not exist.',
      );
    });
  });

  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example')
          .withObjectRelationField(
            'company',
            'Company',
            'company',
            nullableRelation: true,
          )
          .withObjectRelationFieldNoForeignKey(
            'address',
            'Address',
            'address',
          )
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRowRepository',
    );

    group(
        'then the address method is not generated for none nullable relation.',
        () {
      var addressMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryDetachClass!,
        name: 'address',
      );

      test('', () {
        expect(addressMethod, isNull, reason: 'Missing address method.');
      });
    });
  });

  group(
      'Given a class with a self relation where the field has the same name as the class',
      () {
    var tableName = 'example_table';
    var models = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withObjectRelationField(
            'example',
            testClassName,
            tableName,
            nullableRelation: true,
          )
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var attachRowRepository = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRowRepository',
    );

    group('then the attach method for example', () {
      var method = CompilationUnitHelpers.tryFindMethodDeclaration(
        attachRowRepository!,
        name: 'example',
      );

      test('has the secondary input param named "nestedExample" ', () {
        expect(
          method?.parameters?.toSource(),
          matches(
            r'(_i\d.Session session, Example example, Example nestedExample)',
          ),
        );
      });
    });

    test('then the class name ${testClassName}Repository is generated', () {
      expect(
        attachRowRepository,
        isNotNull,
        reason: 'Missing class named ${testClassName}Repository.',
      );
    });
  });
}
