import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analytics/protocol_feature_analyzer.dart';
import 'package:test/test.dart';

import '../test_util/builders/generator_config_builder.dart';
import '../test_util/builders/module_config_builder.dart';

/// Module naming is pure configuration mapping — there is no generated data to
/// drive — so it is covered here rather than in the generate integration test.
/// Everything the analyzer derives from models and endpoints is asserted
/// against real parsed sources in
/// `test/integration/analytics/generate_feature_analytics_test.dart`.
void main() {
  test(
    'Given a project depending on official and custom modules, '
    'when its protocol features are analyzed, '
    'then only official modules are named while every module is counted.',
    () {
      final officialModules = officialServerpodModules.toList()..sort();
      final snapshot = ProtocolFeatureAnalyzer.analyze(
        protocolDefinition: const ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
        ),
        config: GeneratorConfigBuilder().withModules([
          for (final module in officialModules)
            ModuleConfigBuilder(module).build(),
          ModuleConfigBuilder('my_private_module').build(),
        ]).build(),
      );

      expect(
        snapshot.serverpodModules,
        officialModules,
        reason: 'Custom module names must never be sent.',
      );
      expect(
        snapshot.counts['module_count'],
        officialModules.length + 1,
        reason: 'Custom modules still count towards the total.',
      );
    },
  );

  test(
    'Given the official module allowlist, '
    'when its names are compared with ModuleConfig naming, '
    'then every entry uses the stripped server-package form.',
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
}
