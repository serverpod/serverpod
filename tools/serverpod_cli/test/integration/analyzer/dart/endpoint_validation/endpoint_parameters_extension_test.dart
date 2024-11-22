import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/extension/endpoint_parameters_extension.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/test_util/endpoint_validation_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

const pathToServerpodRoot = '../../../../../../../..';
var testProjectDirectory = Directory(path.joinAll([
  'test',
  'integration',
  'analyzer',
  'dart',
  'endpoint_validation',
  const Uuid().v4(),
]));

Directory createTestDirectory({
  required String endpointCode,
}) {
  var testDirectory = Directory(
    path.join(testProjectDirectory.path, const Uuid().v4()),
  );
  var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
  endpointFile.createSync(recursive: true);
  endpointFile.writeAsStringSync(endpointCode);
  return testDirectory;
}

Future<List<ParameterElement>> _getEndpointMethodParameters(
  String endpointCode,
) async {
  var testDirectory = createTestDirectory(
    endpointCode: endpointCode,
  );
  var analyzer = EndpointsAnalyzer(testDirectory);
  var context = analyzer.collection.contexts.firstOrNull;
  if (context == null) return [];

  var filePath = context.contextRoot.analyzedFiles().toList().firstOrNull;
  if (filePath == null) return [];

  var library = await context.currentSession.getResolvedLibrary(filePath);

  if (library is! ResolvedLibraryResult) return [];

  List<ParameterElement> parameters = library.element.topLevelElements
      .whereType<ClassElement>()
      .expand((classElement) => classElement.methods)
      .expand((method) => method.parameters)
      .toList();

  return parameters;
}

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory, pathToServerpodRoot);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group('Given an endpoint method when calling extension methods on parameters',
      () {
    test(
        'with Session as first parameter then "isFirstRequiredParameterSession" '
        'extension method should return true', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session) async {
    return 'Hello';
  }
}
''');

      expect(
        parameters.isFirstRequiredParameterSession,
        isTrue,
      );
    });

    test(
        'with a non-Session first parameter then "isFirstRequiredParameterSession" '
        'extension method should return false', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(String name, Session session) async {
    return 'Hello';
  }
}
''');

      expect(
        parameters.isFirstRequiredParameterSession,
        isFalse,
      );
    });

    test(
        'with a Session as a required named parameter then "isFirstRequiredParameterSession" '
        'extension method should return false', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello({
    required Session session,
  }) async {
    return 'Hello';
  }
}
''');

      expect(
        parameters.isFirstRequiredParameterSession,
        isFalse,
      );
    });

    test(
        'with a Session as an optional parameter then "isFirstRequiredParameterSession" '
        'extension method should return false', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello([Session? session]) async {
    return 'Hello';
  }
}
''');

      expect(
        parameters.isFirstRequiredParameterSession,
        isFalse,
      );
    });

    test(
        'with a Session as a required positional parameter and other parameters '
        'then "withoutSessionParameter" extension method should return a list '
        'with the other parameters and the Session parameter removed',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name, {
    required int age,
  }) async {
    return 'Hello';
  }
}
''');
      var filteredParameters = parameters.withoutSessionParameter;
      expect(
        filteredParameters,
        hasLength(2),
      );

      expect(
        filteredParameters.map((p) => p.name),
        ['name', 'age'],
      );
    });
  });
}
