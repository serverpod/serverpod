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

  group(
      'Given a valid endpoint with a method with only session parameter when analyzed',
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
  Future<String> hello(Session session) async {
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

    test('then endpoint method definition is created.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, hasLength(1));
    });
    test('then endpoint method does not have session as parameter', () {
      var parameters =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parameters;
      expect(parameters, isNot(contains('session')));
    });

    test('then endpoint method has no parameters.', () {
      var parameters =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parameters;
      expect(parameters, isEmpty);
    });

    test('then endpoint method has no positional parameters.', () {
      var parametersPositional = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersPositional;
      expect(parametersPositional, isEmpty);
    });

    test('then endpoint method has no named parameters.', () {
      var parametersNamed =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parametersNamed;
      expect(parametersNamed, isEmpty);
    });
  });

  group(
      'Given a valid endpoint with a method with additional parameter besides session when analyzed',
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
      expect(methods, hasLength(1));
    });
    test('then endpoint method does not have session as parameter', () {
      var parameters =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parameters;
      expect(parameters, isNot(contains('session')));
    });

    test('then endpoint method has no positional parameters.', () {
      var parametersPositional = endpointDefinitions
          .firstOrNull?.methods.firstOrNull?.parametersPositional;
      expect(parametersPositional, isEmpty);
    });

    test('then endpoint method has no named parameters.', () {
      var parametersNamed =
          endpointDefinitions.firstOrNull?.methods.firstOrNull?.parametersNamed;
      expect(parametersNamed, isEmpty);
    });

    group('then endpoint method parameter', () {
      test('is defined.', () {
        var parameters =
            endpointDefinitions.firstOrNull?.methods.firstOrNull?.parameters;
        expect(parameters, hasLength(1));
      });

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
  });
}
