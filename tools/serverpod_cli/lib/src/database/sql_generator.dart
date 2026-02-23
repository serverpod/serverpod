import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../generator/types.dart';
import 'dialects/postgres.dart';

abstract interface class SqlGenerator {
  factory SqlGenerator.forDialect(DatabaseDialect dialect) => switch (dialect) {
    DatabaseDialect.postgres => PostgresSqlGenerator(),
  };

  String generateDatabaseDefinitionSql(
    DatabaseDefinition databaseDefinition, {
    required List<DatabaseMigrationVersion> installedModules,
  });

  String generateDatabaseMigrationSql(
    DatabaseMigration databaseMigration, {
    required List<DatabaseMigrationVersion> installedModules,
    required List<DatabaseMigrationVersion> removedModules,
  });

  String? getColumnDefault(
    TypeDefinition columnType,
    dynamic defaultValue,
    String tableName,
  );
}
