import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  /*
  The following types are not explicitly tested here because they are
  interpreted as the respective type. We are already validating the type of our
  values and keys in other tests.
  [
    'null',
    'true',
    'false',
  ];
  */

  var restrictedFieldNames = [
    'toJson',
    'toJsonForProtocol',
    'fromJson',
    'toString',
    'hashCode',
    'runtimeType',
    'noSuchMethod',
    'abstract',
    'else',
    'import',
    'super',
    'as',
    'enum',
    'in',
    'switch',
    'assert',
    'export',
    'interface',
    'sync',
    'async',
    'extend',
    'is',
    'this',
    'await',
    'extension',
    'library',
    'throw',
    'break',
    'external',
    'mixin',
    'case',
    'factory',
    'new',
    'try',
    'class',
    'final',
    'catch',
    'typedef',
    'on',
    'var',
    'const',
    'finally',
    'operator',
    'void',
    'continue',
    'for',
    'part',
    'while',
    'covariant',
    'function',
    'rethrow',
    'with',
    'default',
    'get',
    'return',
    'yield',
    'deferred',
    'hide',
    'set',
    'do',
    'if',
    'show',
    'dynamic',
    'implements',
    'static',
  ];

  var restrictedDatabaseClassFieldNames = [
    'count',
    'insert',
    'update',
    'deleteRow',
    'delete',
    'findById',
    'findSingleRow',
    'find',
    'setColumn',
    'toJsonForDatabase',
    'tableName',
    'include',
    'db',
    'table',
  ];

  group('Classes with table', () {
    for (var keyword in restrictedFieldNames) {
      test(
          'Given a class with the restricted field name "$keyword" then collect an error',
          () {
        var collector = CodeGenerationCollector();

        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              $keyword: String
            ''',
          ).build()
        ];

        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "$keyword" is reserved and cannot be used.',
        );
      });
    }

    for (var keyword in restrictedDatabaseClassFieldNames) {
      test(
          'Given a class with the restricted field name "$keyword" then collect an error',
          () {
        var collector = CodeGenerationCollector();

        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              $keyword: String
            ''',
          ).build()
        ];

        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "$keyword" is reserved and cannot be used.',
        );
      });
    }
  });

  group('Classes without table', () {
    for (var keyword in restrictedFieldNames) {
      test(
          'Given a class with the restricted field name "$keyword" then collect an error',
          () {
        var collector = CodeGenerationCollector();

        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              $keyword: String
            ''',
          ).build()
        ];

        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "$keyword" is reserved and cannot be used.',
        );
      });
    }
  });
  group('Exceptions', () {
    for (var keyword in restrictedFieldNames) {
      test(
          'Given a class with the restricted field name "$keyword" then collect an error',
          () {
        var collector = CodeGenerationCollector();

        var models = [
          ModelSourceBuilder().withYaml(
            '''
            exception: Example
            fields:
              $keyword: String
            ''',
          ).build()
        ];

        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "$keyword" is reserved and cannot be used.',
        );
      });
    }
  });
  group('Enums', () {
    for (var keyword in restrictedFieldNames) {
      test(
          'Given a class with the restricted field name "$keyword" then collect an error',
          () {
        var collector = CodeGenerationCollector();

        var models = [
          ModelSourceBuilder().withYaml(
            '''
            enum: Example
            values:
              - $keyword
            ''',
          ).build()
        ];

        StatefulAnalyzer analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The enum value "$keyword" is reserved and cannot be used.',
        );
      });
    }
  });
}
