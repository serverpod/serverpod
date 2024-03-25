import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  group('Valid datatypes', () {
    var datatypes = [
      'String',
      'String?',
      'bool',
      'int',
      'double',
      'DateTime',
      'Duration',
      'UuidValue',
      'List<String>',
      'List<String>?',
      'List<String?>?',
      'List<List<Map<String,int>>>',
      'Map<String,String>',
      'Map<String,String?>',
      'Map<String,List<int>>',
      'Map<String,Map<String,int>>',
      'Map<String,Map<String,List<List<Map<String,int>>>>>',
    ];

    for (var datatype in datatypes) {
      group('Given a class with a field with the type $datatype', () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: $datatype
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();

        test('then no errors was generated', () {
          expect(collector.errors, isEmpty);
        });

        test('then a class with that field type set to $datatype is generated.',
            () {
          var definition = definitions.first as ClassDefinition;
          expect(definition.fields.first.type.toString(), datatype);
        });
      });
    }

    group('Given a class with a field with a module type', () {
      var models = [
        ModelSourceBuilder().withModuleAlias('auth').withYaml(
          '''
          class: UserInfo
          table: serverpod_user_info
          fields:
            nickname: String
          ''',
        ).build(),
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: module:auth:UserInfo
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test(
          'then a class with that field type set to module:auth:UserInfo is generated.',
          () {
        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.first.type.className, 'UserInfo');
      });
    });

    group(
        'Given a class with a field with a serverpod class type referenced by module prefix',
        () {
      var models = [
        ModelSourceBuilder().withModuleAlias('serverpod').withYaml(
          '''
          class: ServerpodClass
          table: serverpod_table
          fields:
            nickname: String
          ''',
        ).build(),
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: module:serverpod:ServerpodClass
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test('then the class name is the one defined in serverpod.', () {
        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.first.type.className, 'ServerpodClass');
      });
    });

    group(
        'Given a class with a field with a serverpod class type referenced by module prefix',
        () {
      var models = [
        ModelSourceBuilder().withModuleAlias('serverpod').withYaml(
          '''
          class: ServerpodClass
          table: serverpod_table
          fields:
            nickname: String
          ''',
        ).build(),
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: serverpod:ServerpodClass
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test('then the class name is the one defined in serverpod.', () {
        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.first.type.className, 'ServerpodClass');
      });
    });

    test(
        'Given a class with a field with a module type without the module:alias path then an error is reported that the datatype does not exist.',
        () {
      var models = [
        ModelSourceBuilder().withModuleAlias('auth').withYaml(
          '''
          class: UserInfo
          table: serverpod_user_info
          fields:
            nickname: String
          ''',
        ).build(),
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: UserInfo
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        contains('The field has an invalid datatype "UserInfo".'),
      );
    });

    test(
        'Given a module class referencing another module class then no errors are reported.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: module:auth:UserInfo
          ''',
        ).build(),
        ModelSourceBuilder()
            .withModuleAlias('auth')
            .withFileName('user_profile')
            .withYaml(
          '''
          class: UserProfile
          fields:
            email: String
          ''',
        ).build(),
        ModelSourceBuilder()
            .withModuleAlias('auth')
            .withFileName('user_info')
            .withYaml(
          '''
          class: UserInfo
          table: serverpod_user_info
          fields:
            nickname: String
            profile: UserProfile
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(collector.errors, isEmpty);
    });

    group('Given a class with a field with the type ByteData', () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: ByteData
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test(
          'then a class with that field type set to dart:typed_data:ByteData is generated.',
          () {
        var definition = definitions.first as ClassDefinition;
        expect(
          definition.fields.first.type.toString(),
          'dart:typed_data:ByteData',
        );
      });
    });

    group('Given a class with a field with the type MyEnum', () {
      var models = [
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          fields:
            myEnum: MyEnum
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('my_enum').withYaml(
          '''
          enum: MyEnum
          values:
            - first
            - second
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test('then a class with that field type set to MyEnum.', () {
        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.first.type.toString(), 'protocol:MyEnum');
      });

      test('then the type is tagged as an enum', () {
        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.first.type.isEnumType, isTrue);
      });
    });

    test(
        'Given a class with a field with the type List<MyEnum> then the nested type is tagged as an enum',
        () {
      var models = [
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          fields:
            myEnum: List<MyEnum>
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('my_enum').withYaml(
          '''
          enum: MyEnum
          values:
            - first
            - second
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.type.generics.first.isEnumType,
        isTrue,
      );
    });

    test(
        'Given a class with a field with the type Map<MyEnum, MyEnum> then the nested type is tagged as an enum',
        () {
      var models = [
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          fields:
            myEnum: Map<MyEnum, MyEnum>
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('my_enum').withYaml(
          '''
          enum: MyEnum
          values:
            - first
            - second
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.type.generics.first.isEnumType,
        isTrue,
      );

      expect(
        definition.fields.first.type.generics.last.isEnumType,
        isTrue,
      );
    });

    group('Given a class with a field with an enum type from a module', () {
      var models = [
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          fields:
            myEnum: module:auth:MyEnum
          ''',
        ).build(),
        ModelSourceBuilder()
            .withModuleAlias('auth')
            .withFileName('my_enum')
            .withYaml(
          '''
          enum: MyEnum
          values:
            - first
            - second
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test('then a class with that field type set to MyEnum.', () {
        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.first.type.className, 'MyEnum');
      });

      test('then the type is tagged as an enum', () {
        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.first.type.isEnumType, isTrue);
      });
    });

    test(
        'Given a class with a field of a Map type with a lot of whitespace, then all the data types components are extracted.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            customField: Map<  String  , CustomClass  ? > ?   
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('custom_class').withYaml(
          '''
          class: CustomClass
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors to be generated.',
      );

      var definition = definitions.first as ClassDefinition;

      expect(
        definition.fields.first.type.className,
        'Map',
        reason: 'Expected the field to be of type Map, but it was not.',
      );

      expect(definition.fields.first.type.nullable, isTrue,
          reason: 'Expected the Map to be nullable but it was not.');

      expect(
        definition.fields.first.type.generics.first.className,
        'String',
        reason: 'Expected the first generic type to be String, but it was not.',
      );

      expect(
        definition.fields.first.type.generics.last.className,
        'CustomClass',
        reason:
            'Expected the last generic type to be CustomClass, but it was not.',
      );

      expect(
        definition.fields.first.type.generics.last.nullable,
        isTrue,
        reason: 'Expected the CustomClass to be nullable but it was not.',
      );
    });

    test(
      'Given a class with a field of a Map type, then all the data types components are extracted.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              customField: Map<String, CustomClass>
            ''',
          ).build(),
          ModelSourceBuilder().withFileName('custom_class').withYaml(
            '''
            class: CustomClass
            fields:
              name: String
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();

        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors to be generated.',
        );

        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fields.first.type.className,
          'Map',
          reason: 'Expected the field to be of type Map, but it was not.',
        );

        expect(
          definition.fields.first.type.generics.first.className,
          'String',
          reason:
              'Expected the first generic type to be String, but it was not.',
        );

        expect(
          definition.fields.first.type.generics.last.className,
          'CustomClass',
          reason:
              'Expected the last generic type to be CustomClass, but it was not.',
        );
      },
    );
  });

  group('Invalid datatypes', () {
    var invalidDatatypes = [
      '???',
      'String???',
      'invalid-type',
      'Map<String, invalid-type>',
      'List<invalid-type>',
      'Map<String, List<invalid-type>>',
      'List<List<invalid-type>>',
    ];

    for (var datatype in invalidDatatypes) {
      test(
          'Given a class with a field with only $datatype as the type, then collect an error that it is an invalid type.',
          () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: $datatype
            ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error, but none was found.',
        );

        var error = collector.errors.first;

        expect(
          error.message,
          contains('The field has an invalid datatype'),
        );
      });
    }

    test(
        'Given an invalid datatype as the generic type of a List then the error location is scoped to the generic type.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            fields:
              name: List<InvalidClass>
            ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was found.',
      );

      var error = collector.errors.first;

      expect(
        error.span?.start.line,
        2,
      );
      expect(
        error.span?.start.column,
        25,
      );

      expect(
        error.span?.end.line,
        2,
      );
      expect(
        error.span?.end.column,
        37,
      );
    });

    test(
        'Given a class with a field without a datatype defined, then collect an error that defining a datatype is required.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name:
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The field must have a datatype defined (e.g. field: String).',
      );
    });

    test(
        'Given a List type without the generic definition then an error is reported that the generic has to be specified.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: List
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The List type must have one generic type defined (e.g. List<String>).',
      );
    });

    test(
        'Given a List type with several generic types then an error is reported that only one generic can be specified.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: List<String, String>
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The List type must have one generic type defined (e.g. List<String>).',
      );
    });

    test(
        'Given a Map type without the generic definition then an error is reported that the generics has to be specified.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: Map
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The Map type must have two generic types defined (e.g. Map<String, String>).',
      );
    });

    test(
        'Given a Map type with too man generic types then an error is reported that two generics has to be specified.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: Map<String, String, String>
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The Map type must have two generic types defined (e.g. Map<String, String>).',
      );
    });

    test('Given a Map with a String type as key then no errors are reported',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: Map<String, String>
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but some were generated.',
      );
    });

    test('Given a Map with a int type as key then no errors are reported', () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: Map<int, String>
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but some were generated.',
      );
    });

    test(
        'Given a class without a generic type but specified with one then an error is reported that the generic has to be removed.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: Example<String>
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The type "Example" cannot have generic types defined.',
      );
    });
  });

  test(
      'Given a class with the unsupported type dynamic then an errors is reported.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: dynamic
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was generated.',
    );

    var error = collector.errors.first;

    expect(
      error.message,
      'The datatype "dynamic" is not supported in models.',
    );
  });

  test(
      'Given a class with a type starting with package: then do no type checking on the type and no errors are reported.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: package:serverpod_cli/src/lib/example.dart:Example
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but one was generated.',
    );
  });

  test(
      'Given a class with a type starting with project: then do no type checking on the type and no errors are reported.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: project:src/lib/example.dart:Example
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors, but one was generated.',
    );
  });

  group('Given a class with a type set to the class name of a custom type', () {
    var type = TypeDefinition(
      className: 'CustomExample',
      generics: const [],
      nullable: false,
      url: 'package:shared_package/src/lib/custom_example.dart',
      customClass: true,
    );

    var config = GeneratorConfigBuilder().withExtraClasses([type]).build();
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: CustomExample
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    test('then no errors was generated', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but one was generated.',
      );
    });

    test('then the field type is set.', () {
      var definition = definitions.first as ClassDefinition;
      expect(definition.fields.first.type.className, 'CustomExample');
    });

    test('then the type url is set to the custom type.', () {
      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.type.url,
        'package:shared_package/src/lib/custom_example.dart',
      );
    });

    test('then the type is not nullable', () {
      var definition = definitions.first as ClassDefinition;
      expect(definition.fields.first.type.nullable, isFalse);
    });
  });

  group(
      'Given a class with a nullable type set to the class name of a custom type',
      () {
    var type = TypeDefinition(
      className: 'CustomExample',
      generics: const [],
      nullable: false,
      url: 'package:shared_package/src/lib/custom_example.dart',
      customClass: true,
    );

    var config = GeneratorConfigBuilder().withExtraClasses([type]).build();
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: CustomExample?
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    test('then no errors was generated', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but one was generated.',
      );
    });

    test('then the field type is nullable.', () {
      var definition = definitions.first as ClassDefinition;
      expect(definition.fields.first.type.nullable, isTrue);
    });
  });

  group('Given a class with a type set to a list of custom classes', () {
    var type = TypeDefinition(
      className: 'CustomExample',
      generics: const [],
      nullable: false,
      url: 'package:shared_package/src/lib/custom_example.dart',
      customClass: true,
    );

    var config = GeneratorConfigBuilder().withExtraClasses([type]).build();
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: List<CustomExample>
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    test('then no errors was generated', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but one was generated.',
      );
    });

    test('then the field type is set.', () {
      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.type.generics.first.className,
        'CustomExample',
      );
    });

    test('then the type url is set to the custom type.', () {
      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.type.generics.first.url,
        'package:shared_package/src/lib/custom_example.dart',
      );
    });
  });

  group('Given a class with a type set to a map of custom classes', () {
    var type = TypeDefinition(
      className: 'CustomExample',
      generics: const [],
      nullable: false,
      url: 'package:shared_package/src/lib/custom_example.dart',
      customClass: true,
    );

    var config = GeneratorConfigBuilder().withExtraClasses([type]).build();
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: Map<CustomExample, CustomExample>
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    test('then no errors was generated', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but one was generated.',
      );
    });

    test('then the field type is set.', () {
      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.type.generics.first.className,
        'CustomExample',
      );

      expect(
        definition.fields.first.type.generics.last.className,
        'CustomExample',
      );
    });

    test('then the type url is set to the custom type.', () {
      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.type.generics.first.url,
        'package:shared_package/src/lib/custom_example.dart',
      );

      expect(
        definition.fields.first.type.generics.last.url,
        'package:shared_package/src/lib/custom_example.dart',
      );
    });
  });

  group('Given a class with a field type to a module that is not imported', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            user: module:auth:UserInfo
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    test('then an error that the module does not exist is reported.', () {
      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error, but none was generated.',
      );

      var error = collector.errors.first;

      expect(error.message, 'The referenced module "auth" is not found.');
    });

    test('then the error message location pinpoints the module name.', () {
      var error = collector.errors.first;

      expect(error.span?.start.line, 2);
      expect(error.span?.start.column, 25);

      expect(error.span?.end.line, 2);
      expect(error.span?.end.column, 29);
    });
  });

  test(
      'Given a class with a field type reference to serverpod that is not imported then an error that serverpod does not exist is reported.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            user: serverpod:LogLevel
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was generated.',
    );

    var error = collector.errors.first;

    expect(error.message, 'The referenced module "serverpod" is not found.');
  });

  group('Given a class with an int field when analyzing', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
            class: Example
            fields:
              name: int 
            ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    test('then no errors was generated', () {
      expect(collector.errors, isEmpty);
    });

    test('then a definition column type is set to bigint.', () {
      var definition = definitions.first as ClassDefinition;
      expect(definition.fields.first.type.databaseType, 'bigint');
    });
  });
}
