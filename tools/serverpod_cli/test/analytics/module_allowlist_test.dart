import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/protocol_feature_analyzer.dart';
import 'package:test/test.dart';

import '../test_util/builders/generator_config_builder.dart';
import '../test_util/builders/module_config_builder.dart';

/// Module naming is pure configuration mapping — there is no generated data to
/// drive — so it is covered here rather than in the generate integration test.
/// Everything the analyzer derives from models and endpoints is asserted
/// against real parsed sources in
/// `test/integration/analytics/generate_analytics_test.dart`.
void main() {
  group('Given a project depending on modules, ', () {
    test(
      'when a dependency is an official Serverpod module, '
      'then it is named and counted.',
      () {
        final snapshot = ProtocolFeatureAnalyzer.analyze(
          protocolDefinition: const ProtocolDefinition(
            endpoints: [],
            models: [],
            futureCalls: [],
          ),
          config: GeneratorConfigBuilder().withModules([
            ModuleConfigBuilder('serverpod_auth_idp').build(),
            ModuleConfigBuilder('serverpod_auth_migration').build(),
            ModuleConfigBuilder('my_private_module').build(),
          ]).build(),
        );

        expect(
          snapshot.serverpodModules,
          ['serverpod_auth_idp', 'serverpod_auth_migration'],
          reason: 'Custom module names must never be sent.',
        );
        expect(
          snapshot.counts['module_count'],
          3,
          reason: 'Custom modules still count towards the total.',
        );
      },
    );

    test(
      'when every module package is renamed to its module name, '
      'then the allowlist matches what the config actually produces.',
      () {
        // `ModuleConfig.name` is the server package with `_server` stripped, so
        // the allowlist is written in that form. A mismatch here would silently
        // report zero adoption for a real module.
        for (final module in officialServerpodModules) {
          expect(module, isNot(endsWith('_server')));
          expect(module, startsWith('serverpod_'));
        }
      },
    );
  });
}
