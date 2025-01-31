import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  String getExpectedFilePath(String fileName, {List<String>? subDirParts}) =>
      p.joinAll([
        '..',
        'example_project_client',
        'lib',
        'src',
        'protocol',
        ...?subDirParts,
        '$fileName.dart',
      ]);

  group(
      'Given a hierarchy with a sealed parent that has a model and a normal child, when generating code',
      () {
    var parent = ClassDefinitionBuilder()
        .withSubDirParts(['subdir'])
        .withClassName('Example')
        .withFileName('example')
        .withField(FieldDefinitionBuilder()
            .withName('user')
            .withType(
              TypeDefinitionBuilder()
                  .withClassName('User')
                  .withUrl(defaultModuleAlias)
                  .build(),
            )
            .build())
        .withIsSealed(true)
        .build();

    var child = ClassDefinitionBuilder()
        .withSubDirParts(['subdir'])
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int')
        .withExtendsClass(parent)
        .build();

    var user = ClassDefinitionBuilder()
        .withSubDirParts(['subdir'])
        .withClassName('User')
        .withFileName('user')
        .withSimpleField('name', 'String')
        .build();

    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      parent,
      child,
      user,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var parentCompilationUnit = parseString(
      content: codeMap[getExpectedFilePath(
        parent.fileName,
        subDirParts: ['subdir'],
      )]!,
    ).unit;

    test(
        'then the ${parent.className} has a relative protocol import directive correctly generated',
        () {
      var protocolImport = CompilationUnitHelpers.tryFindImportDirective(
        parentCompilationUnit,
        uri: '../protocol.dart',
      );

      expect(protocolImport, isNotNull);
    });
  });
}
