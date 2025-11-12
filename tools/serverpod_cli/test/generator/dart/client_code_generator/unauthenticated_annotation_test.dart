import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/annotation_definition_builder.dart';
import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';

const generator = DartClientCodeGenerator();

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given an endpoint with no @unauthenticatedClientCall annotation when generating client code',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withFilePath('lib/src/endpoints/example_endpoint.dart')
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('hello')
                    .withReturnType(
                      TypeDefinitionBuilder().withFutureOf('String').build(),
                    )
                    .buildMethodCallDefinition(),
                MethodDefinitionBuilder()
                    .withName('streaming')
                    .withReturnType(
                      TypeDefinitionBuilder().withStreamOf('String').build(),
                    )
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then method calls does not have the "authenticated" parameter, as it defaults to true.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('callServerEndpoint'))
              .first;

          expect(
            clientCode,
            contains('''\
  Future<String> hello() => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {},
      );
'''),
          );
        },
      );

      test(
        'then streaming method calls does not have the "authenticated" parameter, as it defaults to true.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('callStreamingServerEndpoint'))
              .first;

          expect(
            clientCode,
            contains('''\
  Stream<String> streaming() =>
      caller.callStreamingServerEndpoint<Stream<String>, String>(
        'example',
        'streaming',
        {},
        {},
      );
'''),
          );
        },
      );
    },
  );

  group(
    'Given an endpoint class annotated as @unauthenticatedClientCall with more than one method when generating client code',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withFilePath('lib/src/endpoints/example_endpoint.dart')
              .withAnnotations([
                AnnotationDefinitionBuilder()
                    .withName('unauthenticatedClientCall')
                    .build(),
              ])
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('hello')
                    .withReturnType(
                      TypeDefinitionBuilder().withFutureOf('String').build(),
                    )
                    .buildMethodCallDefinition(),
                MethodDefinitionBuilder()
                    .withName('streaming')
                    .withReturnType(
                      TypeDefinitionBuilder().withStreamOf('String').build(),
                    )
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then method calls have the authenticated parameter set to false.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('callServerEndpoint'))
              .first;

          expect(
            clientCode,
            contains('''\
  Future<String> hello() => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {},
        authenticated: false,
      );
'''),
          );
        },
      );

      test(
        'then streaming method calls have the authenticated parameter set to false.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('callStreamingServerEndpoint'))
              .first;

          expect(
            clientCode,
            contains('''\
  Stream<String> streaming() =>
      caller.callStreamingServerEndpoint<Stream<String>, String>(
        'example',
        'streaming',
        {},
        {},
        authenticated: false,
      );
'''),
          );
        },
      );
    },
  );

  group(
    'Given an endpoint class with only a few methods annotated as @unauthenticatedClientCall when generating client code',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withFilePath('lib/src/endpoints/example_endpoint.dart')
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('hello')
                    .withReturnType(
                      TypeDefinitionBuilder().withFutureOf('String').build(),
                    )
                    .withAnnotations([
                      AnnotationDefinitionBuilder()
                          .withName('unauthenticatedClientCall')
                          .build(),
                    ])
                    .buildMethodCallDefinition(),
                MethodDefinitionBuilder()
                    .withName('authenticated')
                    .withReturnType(
                      TypeDefinitionBuilder().withFutureOf('String').build(),
                    )
                    .buildMethodCallDefinition(),
                MethodDefinitionBuilder()
                    .withName('streaming')
                    .withReturnType(
                      TypeDefinitionBuilder().withStreamOf('String').build(),
                    )
                    .withAnnotations([
                      AnnotationDefinitionBuilder()
                          .withName('unauthenticatedClientCall')
                          .build(),
                    ])
                    .buildMethodStreamDefinition(),
                MethodDefinitionBuilder()
                    .withName('streamingAuthenticated')
                    .withReturnType(
                      TypeDefinitionBuilder().withStreamOf('String').build(),
                    )
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then annotated method call has the authenticated parameter set to false.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('hello'))
              .first;

          expect(
            clientCode,
            contains('''\
  Future<String> hello() => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {},
        authenticated: false,
      );
'''),
          );
        },
      );

      test(
        'then annotated method has not propagated the @unauthenticatedClientCall annotation.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('hello'))
              .first;

          expect(
            clientCode,
            matches(
              r'(?<!@unauthenticatedClientCall)\n\s*Future<String> hello\(\)',
            ),
          );
        },
      );

      test(
        'then annotated streaming method call has the authenticated parameter set to false.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('streaming'))
              .first;

          expect(
            clientCode,
            contains('''\
  Stream<String> streaming() =>
      caller.callStreamingServerEndpoint<Stream<String>, String>(
        'example',
        'streaming',
        {},
        {},
        authenticated: false,
      );
'''),
          );
        },
      );

      test(
        'then annotated streaming method has not propagated the @unauthenticatedClientCall annotation.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('streaming'))
              .first;

          expect(
            clientCode,
            matches(
              r'(?<!@unauthenticatedClientCall)\n\s*Stream<String> streaming\(\)',
            ),
          );
        },
      );

      test(
        'then non-annotated method call does not have the "authenticated" parameter, as it defaults to true.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('authenticated'))
              .first;

          expect(
            clientCode,
            contains('''\
  Future<String> authenticated() => caller.callServerEndpoint<String>(
        'example',
        'authenticated',
        {},
      );
'''),
          );
        },
      );

      test(
        'then non-annotated streaming method call does not have the "authenticated" parameter, as it defaults to true.',
        () {
          var clientCode = codeMap.values
              .where((code) => code.contains('streamingAuthenticated'))
              .first;

          expect(
            clientCode,
            contains('''\
  Stream<String> streamingAuthenticated() =>
      caller.callStreamingServerEndpoint<Stream<String>, String>(
        'example',
        'streamingAuthenticated',
        {},
        {},
      );
'''),
          );
        },
      );
    },
  );
}
