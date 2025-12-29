import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_calls_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/endpoint_validation_helpers.dart';

const pathToServerpodRoot = '../../../../../../../..';
var testProjectDirectory = Directory(
  path.joinAll([
    'test',
    'integration',
    'analyzer',
    'dart',
    'future_call_validation',
    const Uuid().v4(),
  ]),
);

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory, pathToServerpodRoot);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group('Given a valid future call class when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );
    var testGeneratedDirectory = Directory(
      path.join(testDirectory.path, 'src', 'generated'),
    );

    late List<FutureCallDefinition> futureCallDefinitions;
    late FutureCallsAnalyzer analyzer;
    setUpAll(() async {
      var futureCallFile = File(
        path.join(testDirectory.path, 'future_call.dart'),
      );
      futureCallFile.createSync(recursive: true);
      futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
     session.log('Hello \$name');
  }
}
''');

      final parameterValidator = FutureCallMethodParameterValidator(
        modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
      );

      analyzer = FutureCallsAnalyzer(
        directory: testDirectory,
        generatedDirectory: testGeneratedDirectory,
        parameterValidator: parameterValidator,
      );

      futureCallDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then future call definition is created.', () {
      expect(futureCallDefinitions, hasLength(1));
    });

    group('then future call definition', () {
      test('has expected name.', () {
        var name = futureCallDefinitions.firstOrNull?.name;
        expect(name, 'example');
      });

      test('has no documentation.', () {
        var documentation =
            futureCallDefinitions.firstOrNull?.documentationComment;
        expect(documentation, isNull);
      });

      test('has expected class name.', () {
        var className = futureCallDefinitions.firstOrNull?.className;
        expect(className, 'ExampleFutureCall');
      });

      test('has a method defined.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(1));
      });

      test('has expected filePath.', () {
        var filePath = futureCallDefinitions.firstOrNull?.filePath;
        expect(
          filePath,
          path.join(
            Directory.current.path,
            testDirectory.path,
            'future_call.dart',
          ),
        );
      });
    });
  });

  group('Given a valid future call with documentation when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );
    var testGeneratedDirectory = Directory(
      path.join(testDirectory.path, 'src', 'generated'),
    );

    late List<FutureCallDefinition> futureCallDefinitions;
    late FutureCallsAnalyzer analyzer;
    setUpAll(() async {
      var futureCallFile = File(
        path.join(testDirectory.path, 'future_call.dart'),
      );
      futureCallFile.createSync(recursive: true);
      futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

/// This is an example future call.
class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');

      final parameterValidator = FutureCallMethodParameterValidator(
        modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
      );

      analyzer = FutureCallsAnalyzer(
        directory: testDirectory,
        generatedDirectory: testGeneratedDirectory,
        parameterValidator: parameterValidator,
      );

      futureCallDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then future call definition is created.', () {
      expect(futureCallDefinitions, hasLength(1));
    });

    test('then future call definition has expected documentation.', () {
      var documentation =
          futureCallDefinitions.firstOrNull?.documentationComment;
      expect(documentation, '/// This is an example future call.');
    });
  });

  group(
    'Given a future call class that does not extend FutureCall<SerializableModel> ',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );
      var testGeneratedDirectory = Directory(
        path.join(testDirectory.path, 'src', 'generated'),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        var futureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

abstract class SimpleData implements SerializableModel {}

class ExampleFutureCall extends FutureCall<SimpleData> {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');

        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          generatedDirectory: testGeneratedDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then future call definition is not created.', () {
        expect(futureCallDefinitions, isEmpty);
      });
    },
  );

  group(
    'Given a future call class that extends FutureCall<SerializableModel> ',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );
      var testGeneratedDirectory = Directory(
        path.join(testDirectory.path, 'src', 'generated'),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        var futureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall<SerializableModel> {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');

        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          generatedDirectory: testGeneratedDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });
    },
  );

  group(
    'Given a dart class that does not inherit from FutureCall when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );
      var testGeneratedDirectory = Directory(
        path.join(testDirectory.path, 'src', 'generated'),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        var futureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall {
  Future<String> hello(Session session, String name) async {
    session.log('Hello, \$name!');
  }
}
''');

        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          generatedDirectory: testGeneratedDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then no future call definition is created.', () {
        expect(futureCallDefinitions, isEmpty);
      });
    },
  );

  group(
    'Given same future call class definition in multiple files when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );
      var testGeneratedDirectory = Directory(
        path.join(testDirectory.path, 'src', 'generated'),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        var firstFutureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        firstFutureCallFile.createSync(recursive: true);
        firstFutureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello, \$name!');
  }
}
''');
        var secondFutureCallFile = File(
          path.join(testDirectory.path, 'future_call2.dart'),
        );
        secondFutureCallFile.createSync(recursive: true);
        secondFutureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello, \$name!');
  }
}
''');

        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          generatedDirectory: testGeneratedDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then two validation errors are reported.', () {
        expect(collector.errors, hasLength(2));
      });

      test(
        'then validation error explains that multiple future call definitions exist.',
        () {
          expect(
            collector.errors.firstOrNull?.message,
            'Multiple future call definitions for ExampleFutureCall exists. Please provide a unique name for each future call class.',
          );
        },
      );

      test('then no future call definition is created.', () {
        expect(futureCallDefinitions, isEmpty);
      });
    },
  );
}
