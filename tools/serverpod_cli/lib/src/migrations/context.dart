import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../analyzer/dart/custom_class_analyzer.dart';
import '../generator/code_generation_collector.dart';

class MigrationGenerationContext {
  MigrationGenerationContext._({required this.modelDefinitions});

  final List<SerializableModelDefinition> modelDefinitions;

  static Future<MigrationGenerationContext> load(GeneratorConfig config) async {
    final libDirectory = Directory(p.joinAll(config.libSourcePathParts));

    final customClassPackageRoots = config.extraClasses
        .map((e) => e.packageRoot)
        .whereType<String>()
        .toSet()
        .toList();

    final customClassAnalyzerCollector = CodeGenerationCollector();

    final serializationTypes =
        await CustomClassAnalyzer(
          libDirectory,
          customClassPackageRoots: customClassPackageRoots,
        ).analyze(
          collector: customClassAnalyzerCollector,
          extraClasses: config.extraClasses,
        );

    customClassAnalyzerCollector.printErrors();

    if (customClassAnalyzerCollector.hasSevereErrors) {
      throw GenerateMigrationDatabaseDefinitionException();
    }

    CustomClassAnalyzer.applyResults(config.extraClasses, serializationTypes);

    var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
    var modelDefinitions = StatefulAnalyzer(config, models, (uri, collector) {
      collector.printErrors();

      if (collector.hasSevereErrors) {
        throw GenerateMigrationDatabaseDefinitionException();
      }
    }).validateAll();

    return MigrationGenerationContext._(modelDefinitions: modelDefinitions);
  }
}
