import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
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

  group('Given a valid future call with a method when analyzed', () {
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

    group('then future call method definition', () {
      test('has expected name.', () {
        var name = futureCallDefinitions.firstOrNull?.methods.firstOrNull?.name;
        expect(name, 'hello');
      });

      test('has no documentation.', () {
        var documentation = futureCallDefinitions
            .firstOrNull
            ?.methods
            .firstOrNull
            ?.documentationComment;
        expect(documentation, isNull);
      });

      test('has expected return type.', () {
        var returnType =
            futureCallDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
        expect(returnType?.className, 'Future');
        expect(returnType?.generics, hasLength(1));
        expect(returnType?.generics.firstOrNull?.className, 'void');
      });
    });
  });

  group(
    'Given a valid future call method with a first positional nullable `Session` parameter when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session? session, String name) async {
    session?.log('Hello \$name');
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
      test('then a hint message is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.first.message,
          'The "Session" argument in a future call method does not have to be nullable, consider making it non-nullable.',
        );
      });

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });

      test('then an future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(1));
      });

      group('then future call method definition', () {
        test('has expected name.', () {
          var name =
              futureCallDefinitions.firstOrNull?.methods.firstOrNull?.name;
          expect(name, 'hello');
        });

        test('has no documentation.', () {
          var documentation = futureCallDefinitions
              .firstOrNull
              ?.methods
              .firstOrNull
              ?.documentationComment;
          expect(documentation, isNull);
        });

        test('has expected return type.', () {
          var returnType = futureCallDefinitions
              .firstOrNull
              ?.methods
              .firstOrNull
              ?.returnType;
          expect(returnType?.className, 'Future');
          expect(returnType?.generics, hasLength(1));
          expect(returnType?.generics.firstOrNull?.className, 'void');
        });
      });
    },
  );

  group(
    'Given a future call with a method that has a second positional parameter of type `Session` when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello(String name, Session session) async {
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

      test('then no future call definition methods are created.', () {
        expect(futureCallDefinitions.firstOrNull?.methods, isEmpty);
      });
    },
  );

  group(
    'Given a future call with a method that has a `Session` as required named parameter when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello({
  required Session session,
}) async {
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

      test('then no future call definition methods are created.', () {
        expect(futureCallDefinitions.firstOrNull?.methods, isEmpty);
      });
    },
  );

  group(
    'Given a future call method without a first positional `Session` param',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello(String name, int num) async {
    print('Hello \$name');
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
      test('then validation error is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.first.message,
          'The first parameter of a future call method must be a required positional parameter of type "Session".',
        );
      });

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });

      test('then no future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given a future call method without a first positional `Session` param and the first parameter instead contains a named `Session` parameter when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello({required Session session, required String name}) async {
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
      test('then a validation error is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.first.message,
          'The first parameter of a future call method must be a required positional parameter of type "Session".',
        );
      });

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });

      test('then no future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given a future call method without a first positional `Session` parameter and the first parameter instead contains an optional `Session` parameter when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello([Session? session, String name = "name"]) async {
    session?.log('Hello \$name');
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
      test('then validation error is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.first.message,
          'The first parameter of a future call method must be a required positional parameter of type "Session".',
        );
      });

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });

      test('then no future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given a future call method that does not return Future when analyzed',
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

class ExampleFutureCall extends FutureCall {
  String hello(Session session, String name) {
    return 'Hello \$name';
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

      test('then no future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given a future call method that returns a Future missing defined type when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future hello(Session session, String name) async {
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

      test('then a validation error is reported.', () {
        expect(collector.errors, hasLength(1));
      });

      test(
        'then validation error informs that return type must be Future<void>',
        () {
          expect(
            collector.errors.firstOrNull?.message,
            'Return generic must have a type defined. E.g. Future<void>.',
          );
        },
      );

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });

      test('then no future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given a future call method that returns a Future with dynamic type when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future<dynamic> hello(Session session, String name) async {
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

      test('then a validation error is reported.', () {
        expect(collector.errors, hasLength(1));
      });

      test(
        'then validation error informs that return type must be Future<void>',
        () {
          expect(
            collector.errors.firstOrNull?.message,
            'Return generic must have a type defined. E.g. Future<void>.',
          );
        },
      );

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });

      test('then no future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group('Given a valid future call with private method when analyzed', () {
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
  Future<void> _hello(Session session, String name) async {
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

    test('then future call definition does not have method defined.', () {
      var methods = futureCallDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
    'Given a valid future call with multiple methods defined when analyzed',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }

  Future<void> world(Session session, String name) async {
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

      test('then future call definition has two methods defined.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(2));
      });

      test('then future call definition has expected method names.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods?.firstOrNull?.name, 'hello');
        expect(methods?.lastOrNull?.name, 'world');
      });
    },
  );

  group(
    'Given a valid future call method with documentation when analyzed',
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

class ExampleFutureCall extends FutureCall {
  /// This is a method comment.
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

      test(
        'then future call definition method has expected documentation.',
        () {
          var documentation = futureCallDefinitions
              .firstOrNull
              ?.methods
              .firstOrNull
              ?.documentationComment;
          expect(documentation, '/// This is a method comment.');
        },
      );
    },
  );

  group(
    'Given a valid future call method with "@Deprecated(<string literal>)" annotation',
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

class ExampleFutureCall extends FutureCall {
  @Deprecated('This method is deprecated.')
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

      test('then future call definition method has expected annotations.', () {
        var annotations =
            futureCallDefinitions.firstOrNull?.methods.firstOrNull?.annotations;
        expect(annotations?.length, 1);
        expect(annotations![0].name, 'Deprecated');
        expect(annotations[0].arguments, ["'This method is deprecated.'"]);
        expect(
          annotations[0].methodCallAnalyzerIgnoreRule,
          'deprecated_member_use_from_same_package',
        );
      });
    },
  );

  group(
    'Given a valid future call method with "@Deprecated(<string const expr>)" annotation',
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

const deprecatedMessage = 'is deprecated';

class ExampleFutureCall extends FutureCall {
  @Deprecated('This method \${deprecatedMessage}.')
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

      test('then future call definition method has expected annotations.', () {
        var annotations =
            futureCallDefinitions.firstOrNull?.methods.firstOrNull?.annotations;
        expect(annotations?.length, 1);
        expect(annotations![0].name, 'Deprecated');
        expect(annotations[0].arguments, ["'This method is deprecated.'"]);
        expect(
          annotations[0].methodCallAnalyzerIgnoreRule,
          'deprecated_member_use_from_same_package',
        );
      });
    },
  );

  group('Given a valid future call method with "@deprecated" annotation', () {
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
  @deprecated
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

    test('then future call definition method has expected annotations.', () {
      var annotations =
          futureCallDefinitions.firstOrNull?.methods.firstOrNull?.annotations;
      expect(annotations?.length, 1);
      expect(annotations![0].name, 'deprecated');
      expect(annotations[0].arguments, null);
      expect(
        annotations[0].methodCallAnalyzerIgnoreRule,
        'deprecated_member_use_from_same_package',
      );
    });
  });

  group(
    'Given a valid future call with a single method marked as `@doNotGenerate` when analyzed',
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

class ExampleFutureCall extends FutureCall {
  @doNotGenerate
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

      test('then no future call method definition is created.', () {
        expect(
          futureCallDefinitions.firstOrNull?.methods,
          isEmpty,
        );
      });
    },
  );

  group(
    'Given a valid future call with a method that has serializable parameters after the first positional Session parameter',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name, int age) async {
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

      test('then future call definition has method defined.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(1));
        expect(methods?.firstOrNull?.name, 'hello');
      });

      test(
        'then future call definition has a method parameter created for serialization.',
        () {
          var futureCallMethodParameter = futureCallDefinitions
              .firstOrNull
              ?.methods
              .firstOrNull
              ?.futureCallMethodParameter;
          expect(futureCallMethodParameter, isNotNull);
          expect(futureCallMethodParameter?.name, 'object');
          expect(
            futureCallMethodParameter?.type.className,
            'ExampleFutureCallHelloModel',
          );
          expect(
            futureCallMethodParameter?.allParameters.first.name,
            'name',
          );
          expect(
            futureCallMethodParameter?.allParameters.first.type.className,
            'String',
          );
          expect(
            futureCallMethodParameter?.allParameters.last.name,
            'age',
          );
          expect(
            futureCallMethodParameter?.allParameters.last.type.className,
            'int',
          );
        },
      );
    },
  );

  group(
    'Given a valid future call with a method that has a SerializableModel parameter after the Session parameter',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, SerializableModel? object) async {
    session.log('Hello \$object');
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

      test('then future call definition has method defined.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(1));
        expect(methods?.firstOrNull?.name, 'hello');
      });

      test(
        'then no method parameter created for serialization in the future call definition method.',
        () {
          var futureCallMethodParameter = futureCallDefinitions
              .firstOrNull
              ?.methods
              .firstOrNull
              ?.futureCallMethodParameter;
          expect(futureCallMethodParameter, isNull);
        },
      );
    },
  );

  group(
    'Given a valid future call with a method that has non serializable parameters after the first positional Session parameter',
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

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, Object data) async {
    session.log('Hello \$data');
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

      test('then validation errors is reported.', () {
        expect(collector.errors, hasLength(1));
      });

      test(
        'then validation error informs that the non serializable parameter type is not supported',
        () {
          expect(
            collector.errors.firstOrNull?.message,
            'The type "Object" is not a supported future call parameter type.',
          );
        },
      );

      test('then future call definition is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });

      test('then no future call method definition is created.', () {
        var methods = futureCallDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );
}
