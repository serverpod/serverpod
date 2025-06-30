import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  group('Given Child extends Parent when getClassNameForObject is called', () {
    var expectedFileName = path.join(
      '..',
      'example_project_client',
      'lib',
      'src',
      'protocol',
      'protocol.dart',
    );

    var parent = ModelClassDefinitionBuilder()
        .withClassName('Parent')
        .withFileName('parent')
        .withSimpleField('id', 'int')
        .build();

    var child = ModelClassDefinitionBuilder()
        .withClassName('Child')
        .withFileName('child')
        .withSimpleField('name', 'String')
        .withExtendsClass(parent)
        .build();

    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [parent, child];
    var protocolDefinition = ProtocolDefinition(endpoints: [], models: models);

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    var protocolCompilationUnit =
        parseString(content: codeMap[expectedFileName]!).unit;

    var protocolClass = CompilationUnitHelpers.tryFindClassDeclaration(
      protocolCompilationUnit,
      name: 'Protocol',
    );

    test('then concrete Child check comes before Parent check', () {
      var getClassNameForObjectMethod =
          CompilationUnitHelpers.tryFindMethodDeclaration(
        protocolClass!,
        name: 'getClassNameForObject',
      );

      expect(getClassNameForObjectMethod, isNotNull);

      var methodSource = getClassNameForObjectMethod!.toSource();

      // Find positions of both class checks
      var parentCheckIndex = methodSource.indexOf('data is _i2.Parent');
      var childCheckIndex = methodSource.indexOf('data is _i3.Child');

      // Both checks should be present
      expect(parentCheckIndex, greaterThan(-1),
          reason: 'Parent check should be present');
      expect(childCheckIndex, greaterThan(-1),
          reason: 'Child check should be present');

      // Child (concrete class) should be checked before Parent (base class)
      expect(childCheckIndex, lessThan(parentCheckIndex),
          reason:
              'Concrete class Child should be checked before parent class Parent');
    });
  });
}
