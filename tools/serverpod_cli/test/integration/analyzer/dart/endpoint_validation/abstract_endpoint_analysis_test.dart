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

  group('Given abstract endpoint class when analyzed', () {
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

abstract class ExampleEndpoint extends Endpoint {
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

    test('then abstract endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
      expect(endpointDefinitions.first.className, 'ExampleEndpoint');
      expect(endpointDefinitions.first.isAbstract, isTrue);
    });
  });

  group(
    'Given a concrete endpoint that extends an abstract base endpoint when analyzed',
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

abstract class BaseEndpoint extends Endpoint {
  Future<String> baseMethod(Session session) async {
    return 'base';
  }
}

class ConcreteEndpoint extends BaseEndpoint {
  Future<String> concreteMethod(Session session) async {
    return 'concrete';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then both abstract and concrete endpoint definitions are created.',
        () {
          expect(
            endpointDefinitions.map((e) => e.className).toSet(),
            {'BaseEndpoint', 'ConcreteEndpoint'},
          );
        },
      );

      late var concreteEndpoint = endpointDefinitions.firstWhere(
        (e) => e.className == 'ConcreteEndpoint',
      );

      test('then concrete endpoint is not abstract.', () {
        expect(concreteEndpoint.isAbstract, isFalse);
      });

      test('then concrete endpoint inherits from base endpoint.', () {
        var baseClass = endpointDefinitions.firstWhere(
          (e) => e.className == 'BaseEndpoint',
        );
        expect(concreteEndpoint.extendsClass, baseClass);
      });

      test('then concrete endpoint has both base and concrete methods.', () {
        expect(
          concreteEndpoint.methods.map((m) => m.name).toSet(),
          {'baseMethod', 'concreteMethod'},
        );
      });
    },
  );

  group(
    'Given a concrete endpoint that extends an abstract base endpoint and overrides a method when analyzed',
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

abstract class BaseEndpoint extends Endpoint {
  Future<String> overriddenMethod(Session session);
}

class ConcreteEndpoint extends BaseEndpoint {
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

      late var concreteEndpoint = endpointDefinitions.firstWhere(
        (e) => e.className == 'ConcreteEndpoint',
      );

      test('then concrete endpoint has overridden method.', () {
        expect(
          concreteEndpoint.methods.map((m) => m.name).toSet(),
          {'overriddenMethod'},
        );
      });

      test(
        'then overridden inherited method has no override annotation, since it will be resolved on code generation.',
        () {
          var overriddenMethod = concreteEndpoint.methods.firstWhere(
            (m) => m.name == 'overriddenMethod',
          );
          expect(overriddenMethod.annotations, hasLength(0));
        },
      );
    },
  );

  group(
    'Given a concrete endpoint that extends an abstract endpoint annotated with @doNotGenerate when analyzed',
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
abstract class BaseEndpoint extends Endpoint {
  Future<String> baseMethod(Session session) async {
    return 'base';
  }
}

class ConcreteEndpoint extends BaseEndpoint {
  Future<String> concreteMethod(Session session) async {
    return 'concrete';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then only concrete endpoint is included in definitions.', () {
        expect(
          endpointDefinitions.map((e) => e.className).toSet(),
          {'ConcreteEndpoint'},
        );
      });

      late var concreteEndpoint = endpointDefinitions.firstWhere(
        (e) => e.className == 'ConcreteEndpoint',
      );

      test('then concrete endpoint does not inherit from base endpoint.', () {
        expect(concreteEndpoint.extendsClass, isNull);
      });

      test('then concrete endpoint has both base and concrete methods.', () {
        expect(
          concreteEndpoint.methods.map((m) => m.name).toSet(),
          {'baseMethod', 'concreteMethod'},
        );
      });
    },
  );

  group(
    'Given a concrete endpoint that extends an abstract endpoint annotated as @doNotGenerate that also extends another abstract endpoint when analyzed',
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

abstract class PublicBaseEndpoint extends Endpoint {
  Future<String> publicBaseMethod(Session session) async {
    return 'public base';
  }
}

@doNotGenerate
abstract class HiddenBaseEndpoint extends PublicBaseEndpoint {
  Future<String> hiddenMethod(Session session) async {
    return 'hidden';
  }
}

class ConcreteImplementationEndpoint extends HiddenBaseEndpoint {
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
          {'PublicBaseEndpoint', 'ConcreteImplementationEndpoint'},
        );
      });

      late var concrete = endpointDefinitions.firstWhere(
        (e) => e.className == 'ConcreteImplementationEndpoint',
      );

      test(
        'then concrete endpoint does not inherit from hidden base endpoint.',
        () {
          expect(concrete.extendsClass, isNull);
        },
      );

      test('then concrete implementation has all inherited methods.', () {
        expect(
          concrete.methods.map((m) => m.name).toSet(),
          {'hiddenMethod', 'publicBaseMethod', 'implementationMethod'},
        );
      });
    },
  );
}
