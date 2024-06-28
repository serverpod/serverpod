import 'dart:io';

import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/endpoint_validation_helpers.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

const pathToServerpodRoot = '../../../../../../../..';
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
    await createTestEnvironment(testProjectDirectory, pathToServerpodRoot);
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

  group('Given an endpoint method with a Stream parameter when analyzed', () {
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
  Future<String> hello(Session session, Stream<String> stream) async {
    return stream.first;
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
      expect(methods, hasLength(1));
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
        expect(name, 'stream');
      });

      test('has expected type.', () {
        var type = endpointDefinitions
            .firstOrNull?.methods.firstOrNull?.parameters.firstOrNull?.type;
        expect(type?.className, 'Stream');
      });

      test('has expected generic,', () {
        var generic = endpointDefinitions.firstOrNull?.methods.firstOrNull
            ?.parameters.firstOrNull?.type.generics.firstOrNull;
        expect(generic?.className, 'String');
      });
    });
  });

  group('Given an endpoint method with a function parameter when analyzed', () {
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

typedef TestFunctionBuilder = String Function();

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, TestFunctionBuilder functionParam) async {
    return functionParam();
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });
    test(
        'then a validation error is reported that informs the type is not supported.',
        () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        'The type "String Function()" is not a supported endpoint parameter type.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method is not defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group('Given an endpoint method with a Future parameter when analyzed', () {
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
  Future<String> hello(Session session, Future<String> name) async {
    return name;
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });
    test(
        'then a validation error is reported that informs the type is not supported.',
        () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        'The type "Future" is not a supported endpoint parameter type.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method is not defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
      'Given an endpoint method with a Stream parameter without generic type when analyzed',
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
  Future<String> hello(Session session, Stream stream) async {
    return stream.first as String;
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });
    test(
        'then a validation error is reported that informs the type is not supported.',
        () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        'The type "Stream" must have a concrete type defined. E.g. Stream<String>.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method is not defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
      'Given an endpoint method with a Stream parameter with void type when analyzed',
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
  Future<String> hello(Session session, Stream<void> stream) async {
    return 'hello';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });
    test(
        'then a validation error is reported that informs the type is not supported.',
        () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        'The type "Stream" must have a concrete type defined. E.g. Stream<String>.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method is not defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
      'Given an endpoint method with a Stream parameter with dynamic type when analyzed',
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
  Future<String> hello(Session session, Stream<dynamic> stream) async {
    return 'hello';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });
    test(
        'then a validation error is reported that informs the type is not supported.',
        () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        'The type "Stream" must have a concrete type defined. E.g. Stream<String>.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method is not defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });

  group(
      'Given an endpoint method with a Stream parameter with nullable type when analyzed',
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
  Future<String> hello(Session session, Stream<String?> stream) async {
    return await stream.first ?? 'Hello';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });
    test(
        'then a validation error is reported that informs the type is not supported.',
        () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        'Nullable types are not supported for "Stream" parameters.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then endpoint definition method is not defined.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });
}
