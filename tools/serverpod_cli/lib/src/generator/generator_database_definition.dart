import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

Future<DatabaseDefinition> generateDatabaseDefinition({
  required Directory directory,
  required int priority,
}) {
  return _generateSinglePackageDatabaseDefinition(
    directory: directory,
    priority: priority,
  );
}

Future<DatabaseDefinition> _generateSinglePackageDatabaseDefinition({
  required Directory directory,
  required int priority,
}) async {
  var config = await GeneratorConfig.load(directory.path);
  if (config == null) {
    throw Exception('Failed to load generator config');
  }

  var protocols = await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);
  var entityDefinitions = StatefulAnalyzer(protocols).validateAll();

  var databaseDefinition = createDatabaseDefinitionFromEntities(
    entityDefinitions,
  );
  databaseDefinition.priority = priority;
  for (var table in databaseDefinition.tables) {
    table.module = config.name;
  }
  return databaseDefinition;
}
