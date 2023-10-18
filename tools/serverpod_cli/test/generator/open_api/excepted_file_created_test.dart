import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

const projectName = 'example_project';
var config = GeneratorConfigBuilder().withName(projectName).build();
const generator = OpenAPIGenerator();
void main() {
  group('Given a single Endpoint and Entity when generating openapi schema',
      () {
    var method = MethodDefinition(
      name: 'hello',
      documentationComment: '',
      parameters: [],
      parametersPositional: [],
      parametersNamed: [],
      returnType: TypeDefinition(className: 'String', nullable: false),
    );
    var exampleClass = ClassDefinition(
        fileName: '',
        sourceFileName: '',
        className: 'Example',
        fields: [
          SerializableEntityFieldDefinition(
              name: 'name',
              type: TypeDefinition(className: 'String', nullable: false),
              scope: EntityFieldScopeDefinition.all,
              shouldPersist: true)
        ],
        serverOnly: false,
        isException: false);
    var endpoint = EndpointDefinition(
      name: 'example',
      documentationComment: '/// example endpoint',
      methods: [method],
      className: 'ExampleEndpoint',
      filePath: '',
      subDirParts: ['v1'],
    );
    ProtocolDefinition protocolDefinition =
        ProtocolDefinition(endpoints: [endpoint], entities: [exampleClass]);

    var codeMap = generator.generateOpenAPISchema(
        protocolDefinition: protocolDefinition, config: config);
    test('then openapi file is created', () {
      expect(
        codeMap,
        contains(
          path.join('lib', 'src', 'generated', 'openapi', 'openapi.json'),
        ),
        reason: 'Expected openapi file to be present, found none.',
      );
    });
  });
}
