import 'package:serverpod_service_client/serverpod_service_client.dart';

class DatabaseDefinitionBuilder {
  String _moduleName;
  List<TableDefinition> _tables;
  List<DatabaseMigrationVersion> _installedModules;
  int _migrationApiVersion;

  DatabaseDefinitionBuilder()
      : _moduleName = 'test_project',
        _tables = [],
        _installedModules = [],
        _migrationApiVersion = 1;

  DatabaseDefinition build() {
    return DatabaseDefinition(
      moduleName: _moduleName,
      tables: _tables,
      installedModules: _installedModules,
      migrationApiVersion: _migrationApiVersion,
    );
  }

  DatabaseDefinitionBuilder withModuleName(String moduleName) {
    _moduleName = moduleName;
    return this;
  }

  DatabaseDefinitionBuilder withTable(TableDefinition table) {
    _tables.add(table);
    return this;
  }

  DatabaseDefinitionBuilder withTables(List<TableDefinition> tables) {
    _tables = tables;
    return this;
  }

  DatabaseDefinitionBuilder withDefaultModules() {
    _installedModules = [
      DatabaseMigrationVersion(
        module: 'serverpod',
        version: '00000000000000',
      ),
      DatabaseMigrationVersion(
        module: _moduleName,
        version: '00000000000000',
      ),
    ];
    return this;
  }

  DatabaseDefinitionBuilder withInstalledModule(
      DatabaseMigrationVersion installedModule) {
    _installedModules.add(installedModule);
    return this;
  }

  DatabaseDefinitionBuilder withInstalledModules(
      List<DatabaseMigrationVersion> installedModules) {
    _installedModules = installedModules;
    return this;
  }

  DatabaseDefinitionBuilder withMigrationApiVersion(int migrationApiVersion) {
    _migrationApiVersion = migrationApiVersion;
    return this;
  }
}
