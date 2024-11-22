import 'dart:io';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_parameter_analyzer.dart';
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

  group('Given an endpoint method when validating parameters', () {
    test('with Session as first parameter then it should have no exceptions',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.validate(parameters);

      expect(result, isEmpty);
    });

    test('with a non-Session first parameter then it should report an error',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(String name, Session session) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.validate(parameters);

      expect(result, hasLength(1));
      expect(
        result.first.message,
        contains(
          'The first parameter of an endpoint method must be a required positional parameter of type "Session".',
        ),
      );
    });

    test(
        'with a Session as a required named parameter then it should report an error',
        () async {
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

      var result = EndpointParameterAnalyzer.validate(parameters);

      expect(result, hasLength(1));
      expect(
        result.first.message,
        contains(
          'The first parameter of an endpoint method must be a required positional parameter of type "Session".',
        ),
      );
    });

    test('with a nullable Session parameter then it should report an error',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session? session) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.validate(parameters);

      expect(result, hasLength(1));
      expect(
        result.first.message,
        contains(
          'The "Session" argument in an endpoint method does not have to be nullable, consider making it non-nullable.',
        ),
      );
    });

    test('with a Future parameter then it should report an error', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, Future<String> name) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.validate(parameters);

      expect(result, hasLength(1));
      expect(
        result.first.message,
        contains(
            'The type "Future" is not a supported endpoint parameter type.'),
      );
    });

    test(
        'with a Stream parameter with void type then it should report an error',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, Stream<void> stream) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.validate(parameters);

      expect(result, hasLength(1));
      expect(
        result.first.message,
        contains('The type "Stream" does not support void generic type.'),
      );
    });

    test('with a nullable Stream parameter then it should report an error',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, Stream<String>? stream) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.validate(parameters);

      expect(result, hasLength(1));
      expect(
        result.first.message,
        contains('Nullable parameters of the type "Stream" are not supported.'),
      );
    });
  });

  group('Given an endpoint method when parsing parameters', () {
    test(
        'with only one Session as a required positional parameter then it should '
        'remove it and return an empty list of required parameters', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.parse(parameters);

      expect(result.required, isEmpty);
    });

    test(
        'with a second required positional parameter then it should parse the parameter correctly',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.parse(parameters);

      expect(result.required, hasLength(1));
      expect(
        result.required.first.name,
        'name',
      );
    });

    test(
        'with a second required named parameter then it should parse the required '
        'named parameter correctly', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, {
    required String name,
  }) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.parse(parameters);

      expect(result.named, hasLength(1));
      expect(
        result.named.first.name,
        'name',
      );
    });

    test(
        'with a second required positional parameter then it should parse the '
        'parameter correctly', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.parse(parameters);

      expect(result.required, hasLength(1));
      expect(
        result.required.first.name,
        'name',
      );
    });

    test(
        'with one required positional and one required named parameter then it '
        'should parse them correctly', () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name, {
    required String lastName,
  }) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.parse(parameters);

      expect(result.required, hasLength(1));
      expect(
        result.required.first.name,
        'name',
      );

      expect(result.named, hasLength(1));
      expect(
        result.named.first.name,
        'lastName',
      );
    });

    test(
        'with one optional positional parameter then it should parse it correctly',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, [String? name = 'John']) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.parse(parameters);

      expect(result.positional, hasLength(1));
      expect(
        result.positional.first.name,
        'name',
      );
    });

    test('with one optional named parameter then it should parse it correctly',
        () async {
      var parameters = await _getEndpointMethodParameters('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, {
    String name = 'John',
  }) async {
    return 'Hello';
  }
}
''');

      var result = EndpointParameterAnalyzer.parse(parameters);

      expect(result.named, hasLength(1));
      expect(
        result.named.first.name,
        'name',
      );
    });
  });
}
