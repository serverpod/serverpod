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

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );

    test('then a static db field is generated on the base class.', () {
      var dbField = CompilationUnitHelpers.tryFindFieldDeclaration(
        maybeClassNamedExample!,
        name: 'db',
      );

      expect(
        dbField?.fields.toSource(),
        'final db = ${testClassName}Repository._()',
      );
    });

    var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Repository',
    );

    test('then the class name ${testClassName}Repository is generated', () {
      expect(
        repositoryClass,
        isNotNull,
        reason: 'Missing class named ${testClassName}Repository.',
      );
    });

    group('then the ${testClassName}Repository', () {
      test('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          repositoryClass!,
          name: '_',
        );

        expect(
          constructor?.toSource(),
          'const ${testClassName}Repository._();',
          reason: 'Missing private constructor.',
        );
      });

      test('then does NOT have the attach field.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            repositoryClass!,
            name: 'attach',
          ),
          isFalse,
        );
      });

      test('then does NOT have the detach field.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            repositoryClass!,
            name: 'detach',
          ),
          isFalse,
        );
      });
    }, skip: repositoryClass == null);

    test('then a class named ${testClassName}AttachRepository is NOT generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}AttachRepository',
        ),
        isFalse,
        reason:
            'The class ${testClassName}AttachRepository was found but was expected to not exist.',
      );
    });

    test('then a class named ${testClassName}DetachRepository is NOT generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}DetachRepository',
        ),
        isFalse,
        reason:
            'The class ${testClassName}DetachRepository was found but was expected to not exist.',
      );
    });
  });
  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var entities = [
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

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
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
          name: 'attach',
        );

        expect(
          field?.toSource(),
          'final attach = const ${testClassName}AttachRepository._();',
          reason: 'Missing static instance field.',
        );
      });

      test('has a final detach field', () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          repositoryClass!,
          name: 'detach',
        );

        expect(
          field?.toSource(),
          'final detach = const ${testClassName}DetachRepository._();',
          reason: 'Missing static instance field.',
        );
      });
    }, skip: repositoryClass == null);

    test('then a class named ${testClassName}AttachRepository is generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}AttachRepository',
        ),
        isTrue,
        reason:
            'Expected the class ${testClassName}AttachRepository to be generated.',
      );
    });

    var repositoryAttachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRepository',
    );

    group('then the ${testClassName}AttachRepository', () {
      test('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          repositoryAttachClass!,
          name: '_',
        );
        expect(
          constructor?.toSource(),
          'const ${testClassName}AttachRepository._();',
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

    test('then a class named ${testClassName}DetachRepository is generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}DetachRepository',
        ),
        isTrue,
        reason:
            'Expected the class ${testClassName}DetachRepository to be generated.',
      );
    });

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRepository',
    );
    group('then the ${testClassName}DetachRepository', () {
      test('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          repositoryDetachClass!,
          name: '_',
        );
        expect(
          constructor?.toSource(),
          'const ${testClassName}DetachRepository._();',
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
    var entities = [
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

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRepository',
    );

    test('then no detach repository is generated', () {
      expect(
        repositoryDetachClass,
        isNull,
        reason:
            'The class ${testClassName}DetachRepository was found but was expected to not exist.',
      );
    });
  });

  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var entities = [
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

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRepository',
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
    var entities = [
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

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var attachRepository = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRepository',
    );

    group('then the attach method for example', () {
      var method = CompilationUnitHelpers.tryFindMethodDeclaration(
        attachRepository!,
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
        attachRepository,
        isNotNull,
        reason: 'Missing class named ${testClassName}Repository.',
      );
    });
  });
}
