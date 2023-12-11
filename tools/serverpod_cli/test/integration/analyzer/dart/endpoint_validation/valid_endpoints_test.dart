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

  group('Given a valid endpoint file when analyzed', () {
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

    group('then endpoint definition', () {
      test('has expected name.', () {
        var name = endpointDefinitions.firstOrNull?.name;
        expect(name, 'example');
      });

      test('has no documentation.', () {
        var documentation =
            endpointDefinitions.firstOrNull?.documentationComment;
        expect(documentation, isNull);
      });

      test('has expected class name.', () {
        var className = endpointDefinitions.firstOrNull?.className;
        expect(className, 'ExampleEndpoint');
      });

      test('has an endpoint method defined.', () {
        var methods = endpointDefinitions.firstOrNull?.methods;
        expect(methods, hasLength(1));
      });

      test('has expected filePath.', () {
        var filePath = endpointDefinitions.firstOrNull?.filePath;
        expect(
            filePath,
            path.join(
              Directory.current.path,
              testDirectory.path,
              'endpoint.dart',
            ));
      });

      test('has expected subDirParts.', () {
        var subDirParts = endpointDefinitions.firstOrNull?.subDirParts;
        expect(subDirParts, isEmpty);
      });
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
      });

      test('does not have session as parameter', () {
        var parameters =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.parameters;
        expect(parameters, isNot(contains('session')));
      });

      test('has expected number of mandatory parameters.', () {
        var parameters =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.parameters;
        expect(parameters, hasLength(1));
      });

      test('has no positional parameters.', () {
        var parametersPositional = endpointDefinitions
            .firstOrNull?.methods.firstOrNull?.parametersPositional;
        expect(parametersPositional, isEmpty);
      });

      test('has no named parameters.', () {
        var parametersNamed = endpointDefinitions
            .firstOrNull?.methods.firstOrNull?.parametersNamed;
        expect(parametersNamed, isEmpty);
      });
    });

    group('then endpoint method parameter', () {
      test('has expected name.', () {
        var name = endpointDefinitions
            .firstOrNull?.methods.firstOrNull?.parameters.firstOrNull?.name;
        expect(name, 'name');
      });

      test('has expected type.', () {
        var type = endpointDefinitions
            .firstOrNull?.methods.firstOrNull?.parameters.firstOrNull?.type;
        expect(type?.className, 'String');
      });

      test('is required.', () {
        var required = endpointDefinitions
            .firstOrNull?.methods.firstOrNull?.parameters.firstOrNull?.required;
        expect(required, isTrue);
      });

      test('has dart parameter.', () {
        var dartParameter = endpointDefinitions.firstOrNull?.methods.firstOrNull
            ?.parameters.firstOrNull?.dartParameter;
        expect(dartParameter, isNotNull);
      });
    });
  });

  group('Given a valid endpoint with documentation when analyzed', () {
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

/// This is an example endpoint.
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

    test('then endpoint definition has expected documentation.', () {
      var documentation = endpointDefinitions.firstOrNull?.documentationComment;
      expect(documentation, '/// This is an example endpoint.');
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

  group('Given a valid endpoint stored in a subdirectory when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile =
          File(path.join(testDirectory.path, 'subdirectory', 'endpoint.dart'));
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

    test('then endpoint definition has expected subDirParts.', () {
      var subDirParts = endpointDefinitions.firstOrNull?.subDirParts;
      expect(subDirParts, hasLength(1));
      expect(subDirParts?.first, 'subdirectory');
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

  group(
      'Given a valid endpoint method with optional positional parameter when analyzed',
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
  Future<String> hello(Session session, String name, [String positional='world']) async {
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

    test('then endpoint definition has one method defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, hasLength(1));
    });

    test('then endpoint definition method has one positional parameter.', () {
      var parametersPositional = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersPositional;
      expect(parametersPositional, hasLength(1));
    });

    test('then endpoint methods positional parameter has expected name', () {
      var name = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersPositional.firstOrNull?.name;
      expect(name, 'positional');
    });

    test('then the endpoints positional parameter has expected type', () {
      var type = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersPositional.firstOrNull?.type;
      expect(type?.className, 'String');
    });

    test('then the endpoint methods positional parameter is not required', () {
      var required = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersPositional.firstOrNull?.required;
      expect(required, isFalse);
    });

    test('then the endpoint methods positional parameter has dart parameter',
        () {
      var dartParameter = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersPositional.firstOrNull?.dartParameter;
      expect(dartParameter, isNotNull);
    });
  });

  group('Given a valid endpoint method with named parameter with default value',
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
  Future<String> hello(Session session, String name, {String named='world'}) async {
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

    test('then endpoint definition has one method defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, hasLength(1));
    });

    test('then endpoint definition method has one positional parameter.', () {
      var parametersNamed =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parametersNamed;
      expect(parametersNamed, hasLength(1));
    });

    test('then endpoint methods positional parameter has expected name', () {
      var name = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersNamed.firstOrNull?.name;
      expect(name, 'named');
    });

    test('then the endpoints positional parameter has expected type', () {
      var type = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersNamed.firstOrNull?.type;
      expect(type?.className, 'String');
    });

    test('then the endpoint methods named parameter is required', () {
      var required = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersNamed.firstOrNull?.required;
      expect(required, isTrue);
    });

    test('then the endpoint methods named parameter has dart parameter', () {
      var dartParameter = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersNamed.firstOrNull?.dartParameter;
      expect(dartParameter, isNotNull);
    });
  });

  group(
      'Given a valid endpoint method with nullable named parameter when analyzed',
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
  Future<String> hello(Session session, String name, {String? named}) async {
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

    test('then endpoint definition has one method defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, hasLength(1));
    });

    test('then endpoint definition method has one positional parameter.', () {
      var parametersNamed =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parametersNamed;
      expect(parametersNamed, hasLength(1));
    });

    test('then endpoint methods positional parameter has expected name', () {
      var name = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersNamed.firstOrNull?.name;
      expect(name, 'named');
    });

    test('then the endpoints positional parameter has expected type', () {
      var type = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersNamed.firstOrNull?.type;
      expect(type?.className, 'String');
    });

    test('then the endpoint methods named parameter is not required', () {
      var required = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersNamed.firstOrNull?.required;
      expect(required, isFalse);
    });

    test('then the endpoint methods named parameter has dart parameter', () {
      var dartParameter = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersNamed.firstOrNull?.dartParameter;
      expect(dartParameter, isNotNull);
    });
  });

  group(
      'Given a valid endpoint method with required named parameter when analyzed',
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
  Future<String> hello(Session session, String name, {required String named}) async {
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

    test('then endpoint definition has one method defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, hasLength(1));
    });

    test('then endpoint definition method has one positional parameter.', () {
      var parametersNamed =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parametersNamed;
      expect(parametersNamed, hasLength(1));
    });

    test('then endpoint methods positional parameter has expected name', () {
      var name = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersNamed.firstOrNull?.name;
      expect(name, 'named');
    });

    test('then the endpoints positional parameter has expected type', () {
      var type = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersNamed.firstOrNull?.type;
      expect(type?.className, 'String');
    });

    test('then the endpoint methods named parameter is required', () {
      var required = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersNamed.firstOrNull?.required;
      expect(required, isTrue);
    });

    test('then the endpoint methods named parameter has dart parameter', () {
      var dartParameter = endpointDefinitions.firstOrNull?.methods.firstOrNull
          ?.parametersNamed.firstOrNull?.dartParameter;
      expect(dartParameter, isNotNull);
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

  group('Given multiple valid endpoint files when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var firstEndpointFile =
          File(path.join(testDirectory.path, 'endpoint_one.dart'));
      firstEndpointFile.createSync(recursive: true);
      firstEndpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpointOne extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      var secondEndpointFile =
          File(path.join(testDirectory.path, 'endpoint_two.dart'));
      secondEndpointFile.createSync(recursive: true);
      secondEndpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpointTwo extends Endpoint {
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

    test('then two endpoint definitions are created.', () {
      expect(endpointDefinitions, hasLength(2));
    });
  });
}
