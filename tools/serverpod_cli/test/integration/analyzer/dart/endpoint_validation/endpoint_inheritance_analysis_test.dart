import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

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

  group('Given an endpoint that extends another endpoint when analyzed', () {
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

class BaseEndpoint extends Endpoint {
  Future<String> baseMethod(Session session) async {
    return 'base';
  }
}

class SubclassEndpoint extends BaseEndpoint {
  Future<String> concreteMethod(Session session) async {
    return 'subclass';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then both base and subclass endpoint definitions are created.', () {
      expect(
        endpointDefinitions.map((e) => e.className).toSet(),
        {'BaseEndpoint', 'SubclassEndpoint'},
      );
    });

    late var subclassEndpoint = endpointDefinitions.firstWhere(
      (e) => e.className == 'SubclassEndpoint',
    );

    test('then subclass endpoint inherits from base endpoint.', () {
      var baseClass = endpointDefinitions.firstWhere(
        (e) => e.className == 'BaseEndpoint',
      );
      expect(subclassEndpoint.extendsClass, baseClass);
    });

    test('then subclass endpoint has both base and new methods.', () {
      expect(
        subclassEndpoint.methods.map((m) => m.name).toSet(),
        {'baseMethod', 'concreteMethod'},
      );
    });
  });

  group(
    'Given a endpoint that extends another endpoint and overrides a method when analyzed',
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

class BaseEndpoint extends Endpoint {
  Future<String> overriddenMethod(Session session) async {
    return 'base';
  }
}

class SubclassEndpoint extends BaseEndpoint {
  @override
  Future<String> overriddenMethod(Session session) async {
    return 'overridden';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      late var subclassEndpoint = endpointDefinitions.firstWhere(
        (e) => e.className == 'SubclassEndpoint',
      );

      test('then subclass endpoint has overridden method.', () {
        expect(
          subclassEndpoint.methods.map((m) => m.name).toSet(),
          {'overriddenMethod'},
        );
      });

      test(
        'then overridden inherited method has no override annotation, since it will be resolved on code generation.',
        () {
          var overriddenMethod = subclassEndpoint.methods.firstWhere(
            (m) => m.name == 'overriddenMethod',
          );
          expect(overriddenMethod.annotations, hasLength(0));
        },
      );
    },
  );

  group(
    'Given an endpoint that extends another endpoint annotated with @doNotGenerate when analyzed',
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
import 'package:serverpod_shared/annotations.dart';

@doNotGenerate
class BaseEndpoint extends Endpoint {
  Future<String> baseMethod(Session session) async {
    return 'base';
  }
}

class SubclassEndpoint extends BaseEndpoint {
  Future<String> concreteMethod(Session session) async {
    return 'subclass';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then only subclass endpoint is included in definitions.', () {
        expect(
          endpointDefinitions.map((e) => e.className).toSet(),
          {'SubclassEndpoint'},
        );
      });

      late var subclassEndpoint = endpointDefinitions.firstWhere(
        (e) => e.className == 'SubclassEndpoint',
      );

      test('then subclass endpoint does not inherit from base endpoint.', () {
        expect(subclassEndpoint.extendsClass, isNull);
      });

      test('then subclass endpoint has both base and subclass methods.', () {
        expect(
          subclassEndpoint.methods.map((m) => m.name).toSet(),
          {'baseMethod', 'concreteMethod'},
        );
      });
    },
  );

  group(
    'Given an endpoint that extends another endpoint annotated as @doNotGenerate that also extends another endpoint when analyzed',
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
import 'package:serverpod_shared/annotations.dart';

class PublicBaseEndpoint extends Endpoint {
  Future<String> publicBaseMethod(Session session) async {
    return 'public base';
  }
}

@doNotGenerate
class HiddenBaseEndpoint extends PublicBaseEndpoint {
  Future<String> hiddenMethod(Session session) async {
    return 'hidden';
  }
}

class SubclassEndpoint extends HiddenBaseEndpoint {
  Future<String> implementationMethod(Session session) async {
    return 'implementation';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then only public endpoints are included in definitions.', () {
        expect(
          endpointDefinitions.map((e) => e.className).toSet(),
          {'PublicBaseEndpoint', 'SubclassEndpoint'},
        );
      });

      late var subclass = endpointDefinitions.firstWhere(
        (e) => e.className == 'SubclassEndpoint',
      );

      test(
        'then subclass endpoint does not inherit from hidden base endpoint.',
        () {
          expect(subclass.extendsClass, isNull);
        },
      );

      test('then subclass implementation has all inherited methods.', () {
        expect(
          subclass.methods.map((m) => m.name).toSet(),
          {'hiddenMethod', 'publicBaseMethod', 'implementationMethod'},
        );
      });
    },
  );
}
