import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';

var intType = TypeDefinitionBuilder().withClassName('int').build();
var intNullableType =
    TypeDefinitionBuilder().withClassName('int').withNullable(true).build();

var stringType = TypeDefinitionBuilder().withClassName('String').build();
var stringNullableType =
    TypeDefinitionBuilder().withClassName('String').withNullable(true).build();

var doubleType = TypeDefinitionBuilder().withClassName('double').build();
var doubleNullableType =
    TypeDefinitionBuilder().withClassName('double').withNullable(true).build();

var bigIntType = TypeDefinitionBuilder().withClassName('BigInt').build();
var bigIntNullableType =
    TypeDefinitionBuilder().withClassName('BigInt').withNullable(true).build();

var boolType = TypeDefinitionBuilder().withClassName('bool').build();
var boolNullableType =
    TypeDefinitionBuilder().withClassName('bool').withNullable(true).build();
var dynamicType = TypeDefinitionBuilder().withClassName('dynamic').build();
var exampleType = TypeDefinitionBuilder().withClassName('Example').build();
var exampleTypeNullable =
    TypeDefinitionBuilder().withClassName('Example').withNullable(true).build();
var listBuilder = TypeDefinitionBuilder().withClassName('List');
var mapBuilder = TypeDefinitionBuilder().withClassName('Map');

var futureBuilder = TypeDefinitionBuilder().withClassName('Future');

var nameField =
    FieldDefinitionBuilder().withName('name').withType(stringType).build();

var exampleClass = ClassDefinitionBuilder()
    .withClassName('Example')
    .withField(nameField)
    .build();

var helloMethod = MethodDefinition(
  name: 'hello',
  documentationComment: '/// Hello',
  parameters: [
    ParameterDefinition(
      name: 'name',
      type: stringType,
      required: true,
    ),
  ],
  parametersPositional: [],
  parametersNamed: [],
  returnType: futureBuilder.withGenerics([stringType]).build(),
);

var exampleEndpoint = EndpointDefinition(
  name: 'Example',
  documentationComment: '/// The Example endpoint.',
  methods: [helloMethod],
  className: 'ExampleEndpoint',
  filePath: '',
  subDirParts: ['v1'],
);

var exampleProtocolDefinition = ProtocolDefinition(
  endpoints: [exampleEndpoint],
  entities: [exampleClass],
);

const exampleProjectName = 'example_project';
var generatorConfig =
    GeneratorConfigBuilder().withName(exampleProjectName).build();
const openAPIgenerator = OpenAPIGenerator();
