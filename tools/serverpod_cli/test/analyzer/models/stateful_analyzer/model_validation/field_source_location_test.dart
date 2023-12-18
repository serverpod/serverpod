import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with a field with an invalid key, then collect an error that locates the invalid key in the comma separated string.',
    () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
class: Example
fields:
  nameId: int, invalid
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 2);
      expect(error.span!.start.column, 15);
      expect(error.span!.end.line, 2);
      expect(error.span!.end.column, 22);
    },
  );

  test(
    'Given a class with a field with the parent keyword but without a value, then collect an error that locates the parent keyword in the comma separated string.',
    () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: int, parent=
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 3);
      expect(error.span!.start.column, 22);
      expect(error.span!.end.line, 3);
      expect(error.span!.end.column, 22);
    },
  );

  test(
    'Given a class with a field with the parent keyword with an invalid table name, then collect an error that locates the value in the comma separated string.',
    () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: int, parent=InvalidName_
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 3);
      expect(error.span!.start.column, 22);
      expect(error.span!.end.line, 3);
      expect(error.span!.end.column, 34);
    },
  );

  test(
    'Given a class with a field with database and api defined, then collect an error that locates the api keyword in the comma separated string.',
    () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: int, database, api
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.last;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 3);
      expect(error.span!.start.column, 25);
      expect(error.span!.end.line, 3);
      expect(error.span!.end.column, 28);
    },
  );

  test(
    'Given a class with a field with an empty string entry at the end, then no errors was generated.',
    () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: int, !persist,
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isEmpty,
      );
    },
  );

  test(
    'Given a class with a field with a duplicated key value, then collect an error that locates the duplicated key in the comma separated string.',
    () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: int, database, database, parent=example
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 3);
      expect(error.span!.start.column, 25);
      expect(error.span!.end.line, 3);
      expect(error.span!.end.column, 33);
    },
  );

  test(
    'Given a class with a field with an invalid dart syntax for the type, then collect an error that locates the invalid type in the comma separated string.',
    () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: Invalid-Type, !persist
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.last;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 3);
      expect(error.span!.start.column, 10);
      expect(error.span!.end.line, 3);
      expect(error.span!.end.column, 22);
    },
  );
}
