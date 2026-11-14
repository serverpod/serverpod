import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';
import '../../../../test_util/file_system_entity_helpers.dart';

var testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory);
  });

  tearDownAll(() async {
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group('Given an endpoint using the OpenAPI annotations when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@OpenApiAuth('serverpodAuth', scopes: ['admin', 'write'])
class ExampleEndpoint extends Endpoint {
  @OpenApiDoc(summary: 'Say hi', tags: ['a', 'b'], operationId: 'sayHi')
  @OpenApiResponse(404, 'Not found.')
  @OpenApiResponse(409, 'Conflict.')
  Future<String> hello(Session session, String name) async => name;

  @openApiExclude
  Future<String> hidden(Session session) async => '';
}
''');
      endpointDefinitions = await EndpointsAnalyzer(
        testDirectory,
      ).analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then @OpenApiAuth scheme and scopes are parsed on the class.', () {
      var auth = endpointDefinitions.single.annotations.firstWhere(
        (a) => a.name == 'OpenApiAuth',
      );
      expect(auth.properties['scheme'], 'serverpodAuth');
      expect(auth.properties['scopes'], ['admin', 'write']);
    });

    test(
      'then @OpenApiDoc and repeated @OpenApiResponse are parsed on the method.',
      () {
        var hello = endpointDefinitions.single.methods.firstWhere(
          (m) => m.name == 'hello',
        );
        var doc = hello.annotations.firstWhere((a) => a.name == 'OpenApiDoc');
        expect(doc.properties['summary'], 'Say hi');
        expect(doc.properties['operationId'], 'sayHi');
        expect(doc.properties['tags'], ['a', 'b']);

        var responses = hello.annotations.where(
          (a) => a.name == 'OpenApiResponse',
        );
        expect(responses.map((r) => r.properties['statusCode']), [404, 409]);
      },
    );

    test('then @openApiExclude is parsed on the method.', () {
      var hidden = endpointDefinitions.single.methods.firstWhere(
        (m) => m.name == 'hidden',
      );
      expect(hidden.annotations.has('openApiExclude'), isTrue);
    });
  });

  group('Given @OpenApiAuth with an undeclared scheme', () {
    const source = '''
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@OpenApiAuth('missing')
class ClassEndpoint extends Endpoint {
  Future<String> hello(Session session) async => '';
}

class MethodEndpoint extends Endpoint {
  @OpenApiAuth('missing')
  Future<String> bad(Session session) async => '';

  @OpenApiAuth('known')
  Future<String> good(Session session) async => '';
}
''';

    Future<(CodeGenerationCollector, List<EndpointDefinition>)> analyze(
      Set<String>? schemes,
    ) async {
      var collector = CodeGenerationCollector();
      var directory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );
      File(path.join(directory.path, 'endpoint.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(source);
      var definitions = await EndpointsAnalyzer(directory).analyze(
        collector: collector,
        models: const [],
        openApiSecuritySchemes: schemes,
      );
      return (collector, definitions);
    }

    test(
      'when schemes are checked, then an error is reported for the class and '
      'the method, and only the valid method is kept.',
      () async {
        var (collector, definitions) = await analyze({'known'});

        var messages = collector.errors.map((e) => e.message).toList();
        expect(messages, hasLength(2));
        expect(
          messages,
          everyElement(contains('security scheme "missing"')),
        );
        expect(messages.first, contains('Declared schemes: known.'));

        expect(
          definitions.map((d) => d.className),
          isNot(contains('ClassEndpoint')),
        );
        var methods = definitions
            .singleWhere((d) => d.className == 'MethodEndpoint')
            .methods
            .map((m) => m.name);
        expect(methods, ['good']);
      },
    );

    test('when no schemes are declared, then the message says so.', () async {
      var (collector, _) = await analyze({});
      expect(
        collector.errors.first.message,
        contains('No security schemes are declared.'),
      );
    });

    test(
      'when scheme checking is off, then no errors are reported.',
      () async {
        var (collector, definitions) = await analyze(null);
        expect(collector.errors, isEmpty);
        expect(definitions, hasLength(2));
      },
    );
  });
}
