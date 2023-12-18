import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Valid datatypes', () {
    var datatypes = [
      'String',
      'String?',
      'bool',
      'int',
      'double',
      'Uuid',
      'DateTime',
      'List<String>',
      'List<String>?',
      'List<String?>?',
      'List<List<Map<String,int>>>',
      'Map<String,String>',
      'Map<String,List<int>>',
      'Map<String,Map<String,int>>',
      'Map<String,Map<String,List<List<Map<String,int>>>>>',
    ];

    for (var datatype in datatypes) {
      group('Given a class with a field with the type $datatype', () {
        var protocols = [
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
          protocols,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();

        var definition = definitions.first as ClassDefinition;

        test('then no errors was generated', () {
          expect(collector.errors, isEmpty);
        });

        test('then a class with that field type set to $datatype is generated.',
            () {
          expect(definition.fields.first.type.toString(), datatype);
        });
      });
    }

    group('Given a class with a field with a module type', () {
      var protocols = [
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
        protocols,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test(
          'then a class with that field type set to module:auth:UserInfo is generated.',
          () {
        expect(definition.fields.first.type.toString(), 'module:auth:UserInfo');
      });
    });

    group('Given a class with a field with the type ByteData', () {
      var protocols = [
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
        protocols,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test(
          'then a class with that field type set to dart:typed_data:ByteData is generated.',
          () {
        expect(
          definition.fields.first.type.toString(),
          'dart:typed_data:ByteData',
        );
      });
    });

    group('Given a class with a field with the type MyEnum', () {
      var protocols = [
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
        protocols,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      test('then no errors was generated', () {
        expect(collector.errors, isEmpty);
      });

      test('then a class with that field type set to MyEnum.', () {
        expect(definition.fields.first.type.toString(), 'protocol:MyEnum');
      });

      test('then the type is tagged as an enum', () {
        expect(definition.fields.first.type.isEnumType, isTrue);
      });
    });

    test(
        'Given a class with a field of a Map type with a lot of whitespace, then all the data types components are extracted.',
        () {
      var protocols = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            customField: Map<  String  , CustomClass  ? > ?   
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        protocols,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();
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
        var protocols = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            customField: Map<String, CustomClass>
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer = StatefulAnalyzer(
          protocols,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();
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
        var protocols = [
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
          protocols,
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
          'The field has an invalid datatype "$datatype".',
        );
      });
    }

    test(
        'Given a class with a field without a datatype defined, then collect an error that defining a datatype is required.',
        () {
      var protocols = [
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
        protocols,
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
  });
}
