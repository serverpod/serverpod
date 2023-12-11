import 'dart:io';

import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/endpoint_validation_helpers.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

const pathToServerpod = '../../../../../../../../packages/serverpod';
var testProjectDirectory = Directory(path.joinAll([
  'test',
  'integration',
  'analyzer',
  'dart',
  'endpoint_validation',
  const Uuid().v4(),
]));

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory, pathToServerpod);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group('Given a valid endpoint with a method when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
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
            .firstOrNull?.methods.firstOrNull?.documentationComment;
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
      'Given an endpoint with excluded method name (overriden method from Endpoint class)',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
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

  group('Given an endpoint method without Session param when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
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
  });

  group('Given an endpoint method that does not return Future when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
    });

    test('then a validation errors is reported.', () {
      expect(collector.errors, hasLength(1));
    });

    test('then validation error informs that return type must be future', () {
      expect(
        collector.errors.firstOrNull?.message,
        'Return type must be a Future.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then no endpoint method definition is created.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
      'Given an endpoint method that returns a Future missing defined type when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
    });

    test('then a validation errors is reported.', () {
      expect(collector.errors, hasLength(1));
    });

    test('then validation error informs that return type must be future', () {
      expect(
        collector.errors.firstOrNull?.message,
        'Future must have a type defined. E.g. Future<String>.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then no endpoint method definition is created.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
      'Given an endpoint method that returns a Future null type when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
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
  });

  group(
      'Given an endpoint method that returns a Future with a non existing class when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<TestClassNotDefined> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isNotEmpty));
    });

    test('then a validation errors is reported.', () {
      expect(collector.errors, hasLength(1));
    });

    test('then validation error informs that return type must be future', () {
      expect(
        collector.errors.firstOrNull?.message,
        'Future has an invalid return type.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then no endpoint method definition is created.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
      'Given an endpoint method that returns a Future with dynamic type when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
    });

    test('then a validation errors is reported.', () {
      expect(collector.errors, hasLength(1));
    });

    test('then validation error informs that return type must be future', () {
      expect(
        collector.errors.firstOrNull?.message,
        'Future must have a type defined. E.g. Future<String>.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then no endpoint method definition is created.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group('Given a valid endpoint with private method when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
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

  group('Given a valid endpoint with multiple methods defined when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
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
  });

  group('Given a valid endpoint method with documentation when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

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

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method has expected documentation.', () {
      var documentation = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.documentationComment;
      expect(documentation, '/// This is a method comment.');
    });
  });
}
