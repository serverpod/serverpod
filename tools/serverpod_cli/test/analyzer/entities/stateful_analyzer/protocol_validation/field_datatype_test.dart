import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
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
      'module:auth:UserInfo',
    ];

    for (var datatype in datatypes) {
      group('Given a class with a field with the type $datatype', () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
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

    group('Given a class with a field with the type ByteData', () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
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
        expect(definition.fields.first.type.toString(),
            'dart:typed_data:ByteData');
      });
    });

    test(
      'Given a class with a field of a Map type, then all the data types components are extracted.',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
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
    ];

    for (var datatype in invalidDatatypes) {
      test(
          'Given a class with a field with only $datatype as the type, then collect an error that it is an invalid type.',
          () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
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
        ProtocolSourceBuilder().withYaml(
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
