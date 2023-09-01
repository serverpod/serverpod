import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Classes without table', () {
    test(
        'Given a class with the restricted field name "toJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  toJson: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "toJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "fromJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  fromJson: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "fromJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "toString" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  toString: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "toString" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "runtimeType" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  runtimeType: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "runtimeType" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "hashCode" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  hashCode: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "hashCode" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "noSuchMethod" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  noSuchMethod: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "noSuchMethod" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "operator" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  operator: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "operator" is reserved and cannot be used.',
      );
    });

    // Dart keywords

    test(
      'Given a class with the restricted field name "abstract" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  abstract: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "abstract" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "else" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  else: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "else" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "import" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  import: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "import" is reserved and cannot be used.',
        );
      },
    );
    test(
      'Given a class with the restricted field name "super" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  super: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "super" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "as" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  as: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "as" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "enum" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  enum: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "enum" is reserved and cannot be used.',
        );
      },
    );
    test(
      'Given a class with the restricted field name "in" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  in: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "in" is reserved and cannot be used.',
        );
      },
    );
    test(
      'Given a class with the restricted field name "switch" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  switch: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "switch" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "assert" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  assert: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "assert" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "export" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  export: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "export" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "interface" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  interface: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "interface" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "sync" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  sync: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "sync" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "async" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  async: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "async" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "extend" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  extend: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "extend" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "is" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  is: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "is" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "this" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  this: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "this" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "await" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  await: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "await" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "extension" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  extension: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "extension" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "library" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  library: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "library" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "throw" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  throw: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "throw" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "break" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  break: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "break" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "external" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  external: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "external" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "mixin" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  mixin: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "mixin" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "true" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  'true': String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "true" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "case" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  case: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "case" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "factory" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  factory: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "factory" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "new" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  new: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "new" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "try" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  try: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "try" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "class" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  class: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "class" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "final" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  final: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "final" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "catch" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  catch: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "catch" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "false" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  'false': String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "false" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "null" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  'null': String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "null" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "typedef" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  typedef: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "typedef" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "on" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  on: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "on" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "var" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  var: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "var" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "const" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  const: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "const" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "finally" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  finally: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "finally" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "void" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  void: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "void" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "continue" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  continue: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "continue" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "for" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  for: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "for" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "part" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  part: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "part" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "while" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  while: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "while" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "covariant" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  covariant: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "covariant" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "function" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  function: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "function" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "rethrow" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  rethrow: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "rethrow" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "with" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  with: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "with" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "default" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  default: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "default" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "get" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  get: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "get" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "return" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  return: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "return" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "yield" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  yield: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "yield" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "deferred" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  deferred: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "deferred" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "hide" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  hide: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "hide" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "set" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  set: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "set" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "do" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  do: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "do" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "if" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  if: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "if" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "show" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  show: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "show" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "dynamic" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  dynamic: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "dynamic" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "implements" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  implements: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "implements" is reserved and cannot be used.',
        );
      },
    );

    test(
      'Given a class with the restricted field name "static" then collect an error',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
class: Example
fields:
  static: String
''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition = SerializableEntityAnalyzer.extractEntityDefinition(
          protocol,
        );
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition!],
        );

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The field name "static" is reserved and cannot be used.',
        );
      },
    );
  });
  group('Classes with table', () {
    test(
        'Given a class with the restricted field name "count" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  count: int
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "count" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "insert" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  insert: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "insert" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "update" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  update: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "update" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "deleteRow" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  deleteRow: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "deleteRow" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "delete" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  delete: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "delete" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "findById" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  findById: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "findById" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "findSingleRow" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  findSingleRow: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "findSingleRow" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "find" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  find: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "find" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "setColumn" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  setColumn: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "setColumn" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "allToJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  allToJson: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "allToJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "toJsonForDatabase" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  toJsonForDatabase: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "toJsonForDatabase" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "toJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  toJson: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "toJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "fromJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  fromJson: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "fromJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "tableName" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  tableName: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "tableName" is reserved and cannot be used.',
      );
    });

    test(
        'Given a class with the restricted field name "include" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  include: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "include" is reserved and cannot be used.',
      );
    });
  });

  group('Exceptions', () {
    test(
        'Given an exception with the restricted field name "toJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
exception: Example
fields:
  toJson: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "toJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given an exception with the restricted field name "fromJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
exception: Example
fields:
  fromJson: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "fromJson" is reserved and cannot be used.',
      );
    });
  });

  group('Enums', () {
    test(
        'Given an enum with the restricted field name "toJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
values:
  - toJson
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The enum value "toJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given an enum with the restricted field name "fromJson" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
values:
  - fromJson
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The enum value "fromJson" is reserved and cannot be used.',
      );
    });

    test(
        'Given an enum with the restricted field name "toString" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
values:
  - toString
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The enum value "toString" is reserved and cannot be used.',
      );
    });

    test(
        'Given an enum with the restricted field name "runtimeType" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
values:
  - runtimeType
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The enum value "runtimeType" is reserved and cannot be used.',
      );
    });

    test(
        'Given an enum with the restricted field name "hashCode" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
values:
  - hashCode
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The enum value "hashCode" is reserved and cannot be used.',
      );
    });

    test(
        'Given an enum with the restricted field name "noSuchMethod" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
values:
  - noSuchMethod
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The enum value "noSuchMethod" is reserved and cannot be used.',
      );
    });

    test(
        'Given an enum with the restricted field name "operator" then collect an error',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
values:
  - operator
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The enum value "operator" is reserved and cannot be used.',
      );
    });
  });
}
