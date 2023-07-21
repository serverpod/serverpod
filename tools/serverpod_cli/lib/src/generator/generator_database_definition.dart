import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

Future<DatabaseDefinition> generateDatabaseDefinition({
  required Directory directory,
  required int priority,
  bool full = false,
}) {
  if (full) {
    return _generateFullDatabaseDefinition(directory: directory);
  } else {
    return _generateSinglePackageDatabaseDefinion(
      directory: directory,
      priority: priority,
    );
  }
}

Future<DatabaseDefinition> _generateFullDatabaseDefinition({
  required Directory directory,
}) async {
  // Find paths to all modules
  var tableDefinitions = <TableDefinition>[];

  var paths = await locateAllModulePaths(directory: directory);
  for (var path in paths) {
    var config = await GeneratorConfig.load(path.toFilePath());

    if (config == null) {
      continue;
    }

    var collector = CodeGenerationCollector();
    var moduleDefinitions = await SerializableEntityAnalyzer.analyzeAllFiles(
      collector: collector,
      config: config,
    );

    var moduleDatabaseDefinition = createDatabaseDefinitionFromEntities(
      moduleDefinitions,
    );
    for (var table in moduleDatabaseDefinition.tables) {
      table.module = config.name;
    }
    tableDefinitions.addAll(moduleDatabaseDefinition.tables);
  }

  var databaseDefinition = DatabaseDefinition(tables: tableDefinitions);

  return databaseDefinition;
}

Future<DatabaseDefinition> _generateSinglePackageDatabaseDefinion({
  required Directory directory,
  required int priority,
}) async {
  var config = await GeneratorConfig.load(directory.path);
  if (config == null) {
    throw Exception('Failed to load generator config');
  }

  var collector = CodeGenerationCollector();
  var entityDefinitions = await SerializableEntityAnalyzer.analyzeAllFiles(
    collector: collector,
    config: config,
  );

  var databaseDefinition = createDatabaseDefinitionFromEntities(
    entityDefinitions,
  );
  databaseDefinition.priority = priority;
  for (var table in databaseDefinition.tables) {
    table.module = config.name;
  }
  return databaseDefinition;
}
