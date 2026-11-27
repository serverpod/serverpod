// The tests walk decoded JSON documents, so dynamic access is intended.
// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/yaml/openapi_generator.dart';
import 'package:test/test.dart';

import '../../test_util/builders/endpoint_definition_builder.dart';
import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/method_definition_builder.dart';
import '../../test_util/builders/parameter_definition_builder.dart';
import '../../test_util/builders/type_definition_builder.dart';

const _bearer = {'type': 'http', 'scheme': 'bearer'};

GeneratorConfig _config({
  bool enabled = true,
  Map<String, Map<String, Object?>> schemes = const {'serverpodAuth': _bearer},
}) => GeneratorConfigBuilder()
    .withOpenApi(OpenApiConfig(enabled: enabled, securitySchemes: schemes))
    .build();

Map<String, dynamic> _generate(
  List<EndpointDefinition> endpoints, {
  GeneratorConfig? config,
}) {
  var c = config ?? _config();
  var files = const OpenApiGenerator().generateProtocolCode(
    protocolDefinition: ProtocolDefinition(
      endpoints: endpoints,
      models: const [],
      futureCalls: const [],
    ),
    config: c,
  );
  return jsonDecode(files.values.single) as Map<String, dynamic>;
}

EndpointDefinition _endpoint(
  List<MethodDefinition> methods, {
  List<AnnotationDefinition> annotations = const [],
  String name = 'greeting',
}) => EndpointDefinitionBuilder()
    .withName(name)
    .withMethods(methods)
    .withAnnotations(annotations)
    .build();

void main() {
  test('Given a disabled config, then no file is generated.', () {
    var files = const OpenApiGenerator().generateProtocolCode(
      protocolDefinition: const ProtocolDefinition(
        endpoints: [],
        models: [],
        futureCalls: [],
      ),
      config: _config(enabled: false),
    );
    expect(files, isEmpty);
  });

  group('Given servers configured', () {
    var config = GeneratorConfigBuilder()
        .withOpenApi(
          const OpenApiConfig(
            enabled: true,
            securitySchemes: {'serverpodAuth': _bearer},
            servers: [
              OpenApiServer(
                name: 'development',
                url: 'http://localhost:8080',
                description: 'Development',
                testCredentials: {
                  'serverpodAuth': {'token': 'test-token'},
                },
              ),
              OpenApiServer(
                name: 'production',
                url: 'https://api.example.com',
                description: 'Production',
              ),
            ],
          ),
        )
        .build();
    var spec = _generate([], config: config);

    test('then they are listed in order with their descriptions.', () {
      expect(spec['servers'], [
        {
          'url': 'http://localhost:8080',
          'description': 'Development',
          'x-test-credentials': {
            'serverpodAuth': {'token': 'test-token'},
          },
        },
        {'url': 'https://api.example.com', 'description': 'Production'},
      ]);
    });

    test('then servers without credentials have no credentials key.', () {
      expect(spec['servers'][1], isNot(contains('x-test-credentials')));
    });

    test('and none are configured, then there is no servers key.', () {
      expect(_generate([]), isNot(contains('servers')));
    });
  });

  group('Given an endpoint method with a documented parameter', () {
    var spec = _generate([
      _endpoint([
        MethodDefinitionBuilder()
            .withName('hello')
            .withDocumentationComment('/// Says hello.\n/// More detail.')
            .withParametersNamed([
              ParameterDefinitionBuilder()
                  .withName('name')
                  .withRequired(true)
                  .build(),
              ParameterDefinitionBuilder()
                  .withName('age')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('int')
                        .withNullable(true)
                        .build(),
                  )
                  .build(),
            ])
            .buildMethodCallDefinition(),
      ]),
    ]);

    test('then the path is /endpoint/method with POST.', () {
      expect(spec['openapi'], '3.1.0');
      expect(spec['paths'], contains('/greeting/hello'));
      expect(spec['paths']['/greeting/hello'], contains('post'));
    });

    test('then required parameters are listed and nullable ones are not.', () {
      var schema =
          spec['paths']['/greeting/hello']['post']['requestBody']['content']['application/json']['schema'];
      expect(schema['required'], ['name']);
      expect(schema['properties']['age']['type'], ['integer', 'null']);
    });

    test('then the doc comment becomes summary and description.', () {
      var op = spec['paths']['/greeting/hello']['post'];
      expect(op['summary'], 'Says hello. More detail.');
      expect(op['description'], 'Says hello.\nMore detail.');
      expect(op['tags'], ['greeting']);
    });

    test('then no security is declared.', () {
      expect(
        spec['paths']['/greeting/hello']['post'],
        isNot(contains('security')),
      );
    });
  });

  group('Given @OpenApiAuth', () {
    var auth = const AnnotationDefinition(
      name: 'OpenApiAuth',
      properties: {
        'scheme': 'serverpodAuth',
        'scopes': ['admin'],
      },
    );

    test('on the class, then operations get the security requirement.', () {
      var spec = _generate([
        _endpoint(
          [
            MethodDefinitionBuilder().buildMethodCallDefinition(),
          ],
          annotations: [auth],
        ),
      ]);
      var op = spec['paths']['/greeting/example']['post'];
      expect(op['security'], [
        {
          'serverpodAuth': ['admin'],
        },
      ]);
      expect(op['responses'], contains('401'));
      expect(op['responses'], contains('403'));
      expect(spec['components']['securitySchemes'], contains('serverpodAuth'));
    });

    test(
      'on the method, then it overrides the class and @unauthenticated.',
      () {
        var spec = _generate([
          _endpoint(
            [
              MethodDefinitionBuilder().withAnnotations([
                const AnnotationDefinition(name: 'unauthenticatedClientCall'),
              ]).buildMethodCallDefinition(),
            ],
            annotations: [auth],
          ),
        ]);
        expect(spec['paths']['/greeting/example']['post']['security'], isEmpty);
        expect(
          spec['paths']['/greeting/example']['post']['responses'],
          isNot(contains('401')),
        );
      },
    );

    test('with an undeclared scheme, then it is ignored.', () {
      var spec = _generate(
        [
          _endpoint(
            [
              MethodDefinitionBuilder().buildMethodCallDefinition(),
            ],
            annotations: [auth],
          ),
        ],
        config: _config(schemes: const {}),
      );
      expect(
        spec['paths']['/greeting/example']['post'],
        isNot(contains('security')),
      );
    });
  });

  test('Given @OpenApiDoc, then it overrides the doc comment.', () {
    var spec = _generate([
      _endpoint([
        MethodDefinitionBuilder()
            .withDocumentationComment('/// From comment.')
            .withAnnotations([
              const AnnotationDefinition(
                name: 'OpenApiDoc',
                properties: {
                  'summary': 'Custom',
                  'operationId': 'sayHi',
                  'tags': ['a', 'b'],
                },
              ),
            ])
            .buildMethodCallDefinition(),
      ]),
    ]);
    var op = spec['paths']['/greeting/example']['post'];
    expect(op['summary'], 'Custom');
    expect(op['operationId'], 'sayHi');
    expect(op['tags'], ['a', 'b']);
  });

  test('Given @OpenApiResponse, then the extra response is documented.', () {
    var spec = _generate([
      _endpoint([
        MethodDefinitionBuilder().withAnnotations([
          const AnnotationDefinition(
            name: 'OpenApiResponse',
            properties: {'statusCode': 404, 'description': 'Not found.'},
          ),
        ]).buildMethodCallDefinition(),
      ]),
    ]);
    expect(
      spec['paths']['/greeting/example']['post']['responses']['404'],
      {'description': 'Not found.'},
    );
  });

  test('Given excluded and streaming methods, then they are omitted.', () {
    var spec = _generate([
      _endpoint([
        MethodDefinitionBuilder().withName('hidden').withAnnotations([
          const AnnotationDefinition(name: 'openApiExclude'),
        ]).buildMethodCallDefinition(),
        MethodDefinitionBuilder()
            .withName('stream')
            .buildMethodStreamDefinition(),
        MethodDefinitionBuilder().withName('shown').buildMethodCallDefinition(),
      ]),
      _endpoint(
        [MethodDefinitionBuilder().buildMethodCallDefinition()],
        name: 'hiddenEndpoint',
        annotations: [const AnnotationDefinition(name: 'openApiExclude')],
      ),
    ]);
    expect(spec['paths'].keys, ['/greeting/shown']);
  });

  test('Given collection return types, then schemas are mapped.', () {
    var spec = _generate([
      _endpoint([
        MethodDefinitionBuilder()
            .withReturnType(
              TypeDefinitionBuilder().withClassName('Future').withGenerics([
                TypeDefinitionBuilder().withMapOf('String', 'DateTime').build(),
              ]).build(),
            )
            .buildMethodCallDefinition(),
      ]),
    ]);
    var schema =
        spec['paths']['/greeting/example']['post']['responses']['200']['content']['application/json']['schema'];
    expect(schema['type'], 'object');
    expect(schema['additionalProperties'], {
      'type': 'string',
      'format': 'date-time',
    });
  });

  test('Given the same input twice, then the output is identical.', () {
    var endpoints = [
      _endpoint([MethodDefinitionBuilder().buildMethodCallDefinition()]),
    ];
    var protocol = ProtocolDefinition(
      endpoints: endpoints,
      models: const [],
      futureCalls: const [],
    );
    var a = const OpenApiGenerator().generateProtocolCode(
      protocolDefinition: protocol,
      config: _config(),
    );
    var b = const OpenApiGenerator().generateProtocolCode(
      protocolDefinition: protocol,
      config: _config(),
    );
    expect(a, b);
  });

  group('OpenApiConfig.fromYaml', () {
    test('null yields a disabled config.', () {
      expect(OpenApiConfig.fromYaml(null).enabled, isFalse);
    });
  });
}
