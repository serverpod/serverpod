import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';

const pathToServerpodRoot = '../../../../../../../..';
var testProjectDirectory = Directory(
  path.joinAll([
    'test',
    'integration',
    'analyzer',
    'dart',
    'endpoint_validation',
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

  group('Given a valid endpoint with a method when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    group('then endpoint method definition', () {
      test('has expected name.', () {
        var name = endpointDefinitions.firstOrNull?.methods.firstOrNull?.name;
        expect(name, 'hello');
      });

      test('has no documentation.', () {
        var documentation = endpointDefinitions
            .firstOrNull
            ?.methods
            .firstOrNull
            ?.documentationComment;
        expect(documentation, isNull);
      });

      test('has expected return type.', () {
        var returnType =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
        expect(returnType?.className, 'Future');
        expect(returnType?.generics, hasLength(1));
        expect(returnType?.generics.firstOrNull?.className, 'String');
      });
    });
  });

  group(
    'Given a valid endpoint method with a first positional nullable `Session` parameter when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session? session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });
      test('then a hint message is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.first.message,
          'The "Session" argument in an endpoint method does not have to be nullable, consider making it non-nullable.',
        );
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then an endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(1));
      });

      group('then endpoint method definition', () {
        test('has expected name.', () {
          var name = endpointDefinitions.firstOrNull?.methods.firstOrNull?.name;
          expect(name, 'hello');
        });

        test('has no documentation.', () {
          var documentation = endpointDefinitions
              .firstOrNull
              ?.methods
              .firstOrNull
              ?.documentationComment;
          expect(documentation, isNull);
        });

        test('has expected return type.', () {
          var returnType =
              endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
          expect(returnType?.className, 'Future');
          expect(returnType?.generics, hasLength(1));
          expect(returnType?.generics.firstOrNull?.className, 'String');
        });
      });
    },
  );

  group(
    'Given an endpoint with a method that has a `Session` as second positional parameter when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(String name, Session session) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no endpoint definition methods are created.', () {
        expect(endpointDefinitions.firstOrNull?.methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint with a method that has a `Session` as required named parameter when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello({
  required Session session,
}) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no endpoint definition methods are created.', () {
        expect(endpointDefinitions.firstOrNull?.methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint with excluded method name (overridden method from Endpoint class)',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
   @override
   dynamic getUserObject(Session session) async {
    return 'Hello';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then endpoint definition has does not have method defined.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint method without a first positional `Session` param and the other parameters are not a `Session` parameter when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(String name, int num) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });
      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then no endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint method without a first positional `Session` param and the first parameter instead contains a named `Session` parameter when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello({required Session session, required String name}) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });
      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then no endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint method without a first positional `Session` param and the first parameter instead contains an optional `Session` parameter when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello([Session? session, String name = "name"]) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });
      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then no endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  test(
    'Given an endpoint method with a Stream<void> return when analyzed then an error is reported',
    () async {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late EndpointsAnalyzer analyzer;

      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'dart:async';
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Stream<void> hello(Session session) async* {
    yield 'Hello';
    yield 'World';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      await analyzer.analyze(collector: collector);

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The type "void" is not supported for streams.',
      );
    },
  );

  group('Given an endpoint method with a stream return type when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'dart:async';
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Stream<String> hello(Session session) async* {
    yield 'Hello';
    yield 'World';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    group('then endpoint method definition', () {
      test('is a method stream definition.', () {
        var methodDefinition =
            endpointDefinitions.firstOrNull?.methods.firstOrNull;
        expect(methodDefinition, isA<MethodStreamDefinition>());
      });

      test('has stream return type.', () {
        var returnType =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
        expect(returnType?.className, 'Stream');
        expect(returnType?.generics, hasLength(1));
        expect(returnType?.generics.firstOrNull?.className, 'String');
      });
    });
  });

  group('Given an endpoint method with a stream parameter when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'dart:async';
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, Stream<String> stream) async {
    return 'Hello \${await stream.first}';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint method definition is a streaming method.', () {
      var methodDefinition =
          endpointDefinitions.firstOrNull?.methods.firstOrNull;
      expect(methodDefinition, isA<MethodStreamDefinition>());
    });
  });

  group(
    'Given an endpoint method that does not return Future when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  String hello(Session session, String name) {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then a validation errors is reported.', () {
        expect(collector.errors, hasLength(1));
      });

      test('then validation error informs that return type must be future', () {
        expect(
          collector.errors.firstOrNull?.message,
          'Return type must be a Future or a Stream.',
        );
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then no endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint method that returns a Future missing defined type when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then a validation errors is reported.', () {
        expect(collector.errors, hasLength(1));
      });

      test('then validation error informs that return type must be future', () {
        expect(
          collector.errors.firstOrNull?.message,
          'Return generic must have a type defined. E.g. Future<String>.',
        );
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then no endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint method that returns a Stream missing defined type when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Stream hello(Session session, String name) async* {
    yield 'Hello';
    yield 'World';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      group('then endpoint method definition', () {
        test('is a method stream definition.', () {
          var methodDefinition =
              endpointDefinitions.firstOrNull?.methods.firstOrNull;
          expect(methodDefinition, isA<MethodStreamDefinition>());
        });

        test('has dynamic stream return type.', () {
          var returnType =
              endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
          expect(returnType?.className, 'Stream');
          expect(returnType?.generics, hasLength(1));
          expect(returnType?.generics.firstOrNull?.className, 'dynamic');
        });
      });
    },
  );

  group(
    'Given an endpoint method that returns a Stream with nullable type when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Stream<String?> hello(Session session, String name) async* {
    yield 'Hello';
    yield 'World';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      group('then endpoint method definition', () {
        test('is a method stream definition.', () {
          var methodDefinition =
              endpointDefinitions.firstOrNull?.methods.firstOrNull;
          expect(methodDefinition, isA<MethodStreamDefinition>());
        });

        test('has stream return type.', () {
          var returnType =
              endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
          expect(returnType?.className, 'Stream');
          expect(returnType?.generics, hasLength(1));
          expect(returnType?.generics.firstOrNull?.className, 'String');
          expect(returnType?.generics.firstOrNull?.nullable, isTrue);
        });
      });
    },
  );

  group(
    'Given an endpoint method that returns a Stream with dynamic type when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Stream<dynamic> hello(Session session, String name) async* {
    yield 'Hello';
    yield 'World';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      group('then endpoint method definition', () {
        test('is a method stream definition.', () {
          var methodDefinition =
              endpointDefinitions.firstOrNull?.methods.firstOrNull;
          expect(methodDefinition, isA<MethodStreamDefinition>());
        });

        test('has dynamic stream return type.', () {
          var returnType =
              endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
          expect(returnType?.className, 'Stream');
          expect(returnType?.generics, hasLength(1));
          expect(returnType?.generics.firstOrNull?.className, 'dynamic');
        });
      });
    },
  );

  group(
    'Given an endpoint method with Stream parameter that returns a Future with nullable type when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String?> hello2(Session session, Stream<String> stream) async {
    return 'Hello \${await stream.first}';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      group('then endpoint method definition', () {
        test('is a method stream definition.', () {
          var methodDefinition =
              endpointDefinitions.firstOrNull?.methods.firstOrNull;
          expect(methodDefinition, isA<MethodStreamDefinition>());
        });

        test('has future return type.', () {
          var returnType =
              endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
          expect(returnType?.className, 'Future');
          expect(returnType?.generics, hasLength(1));
          expect(returnType?.generics.firstOrNull?.className, 'String');
          expect(returnType?.generics.firstOrNull?.nullable, isTrue);
        });
      });
    },
  );

  group(
    'Given an endpoint method that returns a Future null type when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<Null> hello(Session session, String name) async {
    return null;
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isNotEmpty);
      });
    },
  );

  group(
    'Given an endpoint method that returns a Future with dynamic type when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<dynamic> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then a validation errors is reported.', () {
        expect(collector.errors, hasLength(1));
      });

      test('then validation error informs that return type must be future', () {
        expect(
          collector.errors.firstOrNull?.message,
          'Return generic must have a type defined. E.g. Future<String>.',
        );
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then no endpoint method definition is created.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, isEmpty);
      });
    },
  );

  group('Given a valid endpoint with private method when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> _hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition has does not have method defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
    'Given a valid endpoint with multiple methods defined when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }

  Future<String> world(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then endpoint definition has two methods defined.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(2));
      });

      test('then endpoint definition has expected method names.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods?.firstOrNull?.name, 'hello');
        expect(methods?.lastOrNull?.name, 'world');
      });
    },
  );

  group('Given a valid endpoint method with documentation when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  /// This is a method comment.
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method has expected documentation.', () {
      var documentation = endpointDefinitions
          .firstOrNull
          ?.methods
          .firstOrNull
          ?.documentationComment;
      expect(documentation, '/// This is a method comment.');
    });
  });

  group(
    'Given a valid endpoint method with "@Deprecated(<string literal>)" annotation',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  @Deprecated('This method is deprecated.')
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then endpoint definition method has expected annotations.', () {
        var annotations =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.annotations;
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
    'Given a valid endpoint method with "@Deprecated(<string const expr>)" annotation',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

const deprecatedMessage = 'is deprecated';

class ExampleEndpoint extends Endpoint {
  @Deprecated('This method \${deprecatedMessage}.')
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then endpoint definition method has expected annotations.', () {
        var annotations =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.annotations;
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

  group('Given a valid endpoint method with "@deprecated" annotation', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  @deprecated
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method has expected annotations.', () {
      var annotations =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.annotations;
      expect(annotations?.length, 1);
      expect(annotations![0].name, 'deprecated');
      expect(annotations[0].arguments, null);
      expect(
        annotations[0].methodCallAnalyzerIgnoreRule,
        'deprecated_member_use_from_same_package',
      );
    });
  });

  group('Given an endpoint method with a void return type', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<void> hello(Session session) async {
    print('Hello world');
    return;
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint method definition is created.', () {
      expect(endpointDefinitions.firstOrNull?.methods, hasLength(1));
    });
  });

  group('Given an endpoint method with a record return type', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<(String, String)> hello(Session session) async {
    return ('Hello', 'World');
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    group('then endpoint method definition', () {
      test('has expected name.', () {
        var name = endpointDefinitions.firstOrNull?.methods.firstOrNull?.name;
        expect(name, 'hello');
      });

      test('has no documentation.', () {
        var documentation = endpointDefinitions
            .firstOrNull
            ?.methods
            .firstOrNull
            ?.documentationComment;
        expect(documentation, isNull);
      });

      test('has expected return type.', () {
        var returnType =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.returnType;
        expect(returnType?.className, 'Future');
        expect(returnType?.generics, hasLength(1));
        expect(returnType?.generics.single.isRecordType, isTrue);
      });
    });
  });

  group('Given an endpoint method with a function as return type', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

typedef TestFunctionBuilder = String Function();

class ExampleEndpoint extends Endpoint {
  Future<TestFunctionBuilder> hello(Session session) async {
    return () => 'Hello world';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test(
      'then a validation error is reported that the type is not supported.',
      () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.firstOrNull?.message,
          'The type "String Function()" is not a supported endpoint return type.',
        );
      },
    );

    test('then toString reports that the type is not supported.', () {
      //These RegEx patterns are used to match the error message because the output
      //is slightly different between Windows and macOS. Fox example, macOS outputs
      //╷ in the error message, while Windows outputs ,. This may be something to review
      var regexPattern = r'''Found 1 issue\.

Error on line 6, column 31 of .+: The type "String Function\(\)" is not a supported endpoint return type\.
.*6.*Future<TestFunctionBuilder> hello\(Session session\) async {
.*\^\^\^\^\^
.*''';

      var actual = collector.toString();

      expect(
        RegExp(regexPattern, multiLine: true, dotAll: true).hasMatch(actual),
        isTrue,
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint method definition is not created.', () {
      expect(endpointDefinitions.firstOrNull?.methods, isEmpty);
    });
  });

  group(
    'Given valid endpoint with a single method marked as `@doNotGenerate` when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  @doNotGenerate
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });

      test('then no methods are collected.', () {
        expect(
          endpointDefinitions.firstOrNull?.methods,
          isEmpty,
        );
      });
    },
  );
}
