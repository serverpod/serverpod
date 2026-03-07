import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/database/sql_generator.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Create the target [DatabaseDefinition] based on the [serializableModel].
DatabaseDefinition createDatabaseDefinitionFromModels(
  List<SerializableModelDefinition> serializableModels,
  String moduleName,
  List<ModuleConfig> allModules, {
  DatabaseDialect dialect = DatabaseDialect.postgres,
}) {
  var tables = <TableDefinition>[
    for (var classDefinition in serializableModels)
      if (classDefinition is ModelClassDefinition &&
          classDefinition.tableName != null)
        TableDefinition(
          module: moduleName,
          name: classDefinition.tableName!,
          dartName: classDefinition.className,
          schema: 'public',
          columns: [
            for (var column in classDefinition.fieldsIncludingInherited)
              if (column.shouldSerializeFieldForDatabase(true))
                ColumnDefinition(
                  name: column.columnName,
                  columnType: ColumnType.values.byName(
                    column.type.databaseTypeEnum,
                  ),
                  // The id column is not null, since it is auto generated.
                  isNullable: column.name != 'id' && column.type.nullable,
                  dartType: column.type.toString(),
                  columnDefault: SqlGenerator.forDialect(dialect)
                      .getColumnDefault(
                        column.type,
                        column.defaultPersistValue,
                        classDefinition.tableName!,
                      ),
                  vectorDimension: column.type.vectorDimension,
                ),
          ],
          foreignKeys: _createForeignKeys(classDefinition),
          indexes: [
            IndexDefinition(
              indexName: '${classDefinition.tableName!}_pkey',
              elements: [
                IndexElementDefinition(
                  definition: 'id',
                  type: IndexElementDefinitionType.column,
                ),
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: true,
            ),
            for (var index in classDefinition.indexesIncludingInherited)
              IndexDefinition(
                indexName: index.name,
                elements: [
                  for (var field in index.fields)
                    IndexElementDefinition(
                      type: IndexElementDefinitionType.column,
                      definition: field,
                    ),
                ],
                type: index.type,
                isUnique: index.unique,
                isPrimary: false,
                vectorDistanceFunction: index.isVectorIndex
                    ? index.vectorDistanceFunction ?? VectorDistanceFunction.l2
                    : null,
                vectorColumnType: index.isVectorIndex
                    ? ColumnType.values.firstWhere(
                        (type) =>
                            type.name ==
                            classDefinition.fields
                                .firstWhere(
                                  (f) => index.fields.contains(f.name),
                                )
                                .type
                                .databaseTypeEnum,
                      )
                    : null,
                parameters: index.parameters,
              ),
          ],
          managed: classDefinition.manageMigration,
        ),
  ];

  // Sort the database definitions
  _sortTableDefinitions(tables);

  return DatabaseDefinition(
    moduleName: moduleName,
    tables: tables,
    migrationApiVersion: DatabaseConstants.migrationApiVersion,
    installedModules: allModules
        .where((module) => module.migrationVersions.isNotEmpty)
        .map(
          (module) {
            return DatabaseMigrationVersion(
              module: module.name,
              version: module.migrationVersions.last,
            );
          },
        )
        .toList(),
  );
}

List<ForeignKeyDefinition> _createForeignKeys(
  ModelClassDefinition classDefinition,
) {
  var fields = classDefinition.fields
      .where((field) => field.relation is ForeignRelationDefinition)
      .toList();

  List<ForeignKeyDefinition> foreignKeys = [];
  for (var i = 0; i < fields.length; i++) {
    var field = fields[i];
    var relation = field.relation as ForeignRelationDefinition;
    foreignKeys.add(
      ForeignKeyDefinition(
        constraintName: '${classDefinition.tableName!}_fk_$i',
        columns: [field.columnName],
        referenceTable: relation.parentTable,
        referenceTableSchema: 'public',
        referenceColumns: ['id'],
        onDelete: relation.onDelete,
        onUpdate: relation.onUpdate,
      ),
    );
  }

  return foreignKeys;
}

void _sortTableDefinitions(List<TableDefinition> tables) {
  // Sort by name to make sure that we get consistent output
  tables.sort((a, b) => a.name.compareTo(b.name));
}
