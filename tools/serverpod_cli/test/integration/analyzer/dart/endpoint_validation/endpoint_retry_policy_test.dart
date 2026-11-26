import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/endpoint_validation_helpers.dart';
import '../../../../test_util/file_system_entity_helpers.dart';

final config = GeneratorConfigBuilder().build();
late Directory testProjectDirectory;

const _retryPolicyClass = '''
class CustomPolicy extends FutureCallRetryPolicy {
  CustomPolicy();
  factory CustomPolicy.fromJson(Map<String, dynamic> json) => CustomPolicy();

  @override
  Duration? nextDelay(FutureCallRetryContext context) => null;

  @override
  Map<String, dynamic> toJson() => {};
}
''';

/// Analyzes an endpoint file with [contents] and a retry policy class, and
/// returns the endpoint definitions found.
Future<List<EndpointDefinition>> _analyzeEndpoint(
  String contents,
  CodeGenerationCollector collector,
) async {
  var directory = Directory(
    path.join(testProjectDirectory.path, const Uuid().v4()),
  );
  File(path.join(directory.path, 'endpoint.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

$_retryPolicyClass
$contents
''');

  return EndpointsAnalyzer(directory).analyze(
    collector: collector,
    models: StatefulAnalyzer(config, []).models,
  );
}

void main() {
  setUpAll(() async {
    testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');
    await createTestEnvironment(testProjectDirectory);
  });

  tearDownAll(() async {
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group(
    'Given an endpoint method with a retry policy parameter,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late List<EndpointDefinition> endpointDefinitions;

      setUpAll(() async {
        endpointDefinitions = await _analyzeEndpoint('''
class ExampleEndpoint extends Endpoint {
  Future<void> schedule(Session session, CustomPolicy policy) async {}
}
''', collector);
      });

      test('then an error says retry policies are server-only.', () {
        expect(
          collector.errors.map((e) => e.message),
          [
            'The type "CustomPolicy" is a future call retry policy. Retry '
                'policies are server-only, so they can\'t be used as endpoint '
                'parameters.',
          ],
        );
      });

      test('then the method is not collected.', () {
        expect(endpointDefinitions.single.methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint method with a parameter that is a list of a built-in retry policy,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();

      setUpAll(() async {
        await _analyzeEndpoint('''
class ExampleEndpoint extends Endpoint {
  Future<void> schedule(
    Session session,
    List<FixedDelayRetryPolicy> policies,
  ) async {}
}
''', collector);
      });

      test(
        'then an error names the retry policy and says it is server-only.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            [
              'The type "FixedDelayRetryPolicy" is a future call retry policy. '
                  'Retry policies are server-only, so they can\'t be used as '
                  'endpoint parameters.',
            ],
          );
        },
      );
    },
  );

  group(
    'Given an endpoint method with a parameter of the retry policy base class,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();

      setUpAll(() async {
        await _analyzeEndpoint('''
class ExampleEndpoint extends Endpoint {
  Future<void> schedule(Session session, FutureCallRetryPolicy policy) async {}
}
''', collector);
      });

      test('then an error says retry policies are server-only.', () {
        expect(
          collector.errors.map((e) => e.message),
          [
            'The type "FutureCallRetryPolicy" is a future call retry policy. '
                'Retry policies are server-only, so they can\'t be used as '
                'endpoint parameters.',
          ],
        );
      });
    },
  );

  group(
    'Given an endpoint method that returns a retry policy,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late List<EndpointDefinition> endpointDefinitions;

      setUpAll(() async {
        endpointDefinitions = await _analyzeEndpoint('''
class ExampleEndpoint extends Endpoint {
  Future<CustomPolicy> policy(Session session) async => CustomPolicy();
}
''', collector);
      });

      test('then an error says retry policies are server-only.', () {
        expect(
          collector.errors.map((e) => e.message),
          [
            'The type "CustomPolicy" is a future call retry policy. Retry '
                'policies are server-only, so they can\'t be returned from '
                'endpoints.',
          ],
        );
      });

      test('then the method is not collected.', () {
        expect(endpointDefinitions.single.methods, isEmpty);
      });
    },
  );

  group(
    'Given an endpoint method that streams records containing a retry policy,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();

      setUpAll(() async {
        await _analyzeEndpoint('''
class ExampleEndpoint extends Endpoint {
  Stream<(int, {CustomPolicy policy})> policies(Session session) async* {}
}
''', collector);
      });

      test(
        'then an error names the retry policy and says it is server-only.',
        () {
          expect(
            collector.errors.map((e) => e.message),
            [
              'The type "CustomPolicy" is a future call retry policy. Retry '
                  'policies are server-only, so they can\'t be returned from '
                  'endpoints.',
            ],
          );
        },
      );
    },
  );
}
