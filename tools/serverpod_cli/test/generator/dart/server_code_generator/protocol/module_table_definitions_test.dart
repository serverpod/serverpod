import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/module_config_builder.dart';

const generator = DartServerCodeGenerator();

void main() {
  final expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'protocol.dart',
  );

  group(
    'Given a project with an example table and the modules module_a and module_b, '
    'when generating the server protocol,',
    () {
      late String protocol;

      setUpAll(() {
        final config = GeneratorConfigBuilder()
            .withName('example_project')
            .withModules([
              ModuleConfigBuilder('module_a').build(),
              ModuleConfigBuilder('module_b').build(),
            ])
            .build();
        final protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [
            ModelClassDefinitionBuilder()
                .withClassName('Example')
                .withFileName('example')
                .withTableName('example')
                .build(),
          ],
          futureCalls: [],
        );

        protocol = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        )[expectedFileName]!;
      });

      test(
        'then targetTableDefinitions combines the own tables of the project, of each module and of serverpod.',
        () {
          final moduleA = importPrefixFor(
            'package:module_a_server/module_a_server.dart',
          );
          final moduleB = importPrefixFor(
            'package:module_b_server/module_b_server.dart',
          );

          expect(
            protocol,
            contains(
              '  static List<_isp.TableDefinition> get targetTableDefinitions => [\n'
              '    ..._ownTableDefinitions,\n'
              '    ...$moduleA.Protocol().getOwnTableDefinitions(),\n'
              '    ...$moduleB.Protocol().getOwnTableDefinitions(),\n'
              '    ..._isp.Protocol.targetTableDefinitions,\n'
              '  ];\n',
            ),
          );
        },
      );

      test(
        'then the target table definitions of the modules are not referenced.',
        () {
          final moduleA = importPrefixFor(
            'package:module_a_server/module_a_server.dart',
          );
          final moduleB = importPrefixFor(
            'package:module_b_server/module_b_server.dart',
          );

          expect(
            protocol,
            allOf(
              isNot(contains('$moduleA.Protocol.targetTableDefinitions')),
              isNot(contains('$moduleB.Protocol.targetTableDefinitions')),
            ),
          );
        },
      );

      test('then _ownTableDefinitions holds the example table.', () {
        expect(
          protocol,
          contains(
            '  static List<_isp.TableDefinition> get _ownTableDefinitions => [\n'
            '    _isp.TableDefinition(\n'
            "      name: 'example',\n",
          ),
        );
      });

      test('then getOwnTableDefinitions returns _ownTableDefinitions.', () {
        expect(
          protocol,
          contains(
            '  @override\n'
            '  List<_isp.TableDefinition> getOwnTableDefinitions() => _ownTableDefinitions;\n',
          ),
        );
      });
    },
  );

  group(
    'Given a module without module dependencies, '
    'when generating the server protocol,',
    () {
      late String protocol;

      setUpAll(() {
        final config = GeneratorConfigBuilder()
            .withName('example_module')
            .withPackageType(PackageType.module)
            .build();

        protocol = generator.generateProtocolCode(
          protocolDefinition: const ProtocolDefinition(
            endpoints: [],
            models: [],
            futureCalls: [],
          ),
          config: config,
        )[expectedFileName]!;
      });

      test('then targetTableDefinitions returns _ownTableDefinitions.', () {
        expect(
          protocol,
          contains(
            '  static List<_isp.TableDefinition> get targetTableDefinitions =>\n'
            '      _ownTableDefinitions;\n',
          ),
        );
      });

      test('then getOwnTableDefinitions returns _ownTableDefinitions.', () {
        expect(
          protocol,
          contains(
            '  @override\n'
            '  List<_isp.TableDefinition> getOwnTableDefinitions() => _ownTableDefinitions;\n',
          ),
        );
      });
    },
  );
}
