import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/quote_utils.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Create the target [DatabaseDefinition] based on the [serializableModels].
DatabaseDefinition createDatabaseDefinitionFromModels(
  List<SerializableModelDefinition> serializableModels,
  String moduleName,
  List<ModuleConfig> allModules,
) {
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
                  fieldName: column.name,
                  columnType: ColumnType.values.byName(
                    column.type.databaseTypeEnum,
                  ),
                  // The id column is not null, since it is auto generated.
                  isNullable: column.name != 'id' && column.type.nullable,
                  dartType: column.type.toString(),
                  columnDefault: _parseColumnDefault(column),
                  vectorDimension: column.type.vectorDimension,
                ),
          ],
          foreignKeys: _createForeignKeys(classDefinition),
          indexes: [
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
    schemaVersion: currentSchemaVersion,
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

/// Parses the default value for a column.
///
/// String defaults are stored in SQL-escaped form so they can be used directly
/// in SQL without further escaping or unescaping during normalization.
///
/// If the column is an enum, it returns the value in the expected format for
/// the enum serialization.
///
/// The transformations in this function match the expected type of the column
/// on all database implementations.
dynamic _parseColumnDefault(SerializableModelFieldDefinition column) {
  final defaultPersistValue = column.defaultPersistValue;
  final defaultValueType = column.type.defaultValueType;
  if (defaultPersistValue == null || defaultValueType == null) return null;

  switch (defaultValueType) {
    case DefaultValueAllowedType.string:
    case DefaultValueAllowedType.uri:
      return escapeSqlString(defaultPersistValue);
    case DefaultValueAllowedType.uuidValue:
      // Special values like "random" and "random_v7" are SQL function names,
      // not string literals - return as-is without escaping.
      if (defaultPersistValue == defaultUuidValueRandom ||
          defaultPersistValue == defaultUuidValueRandomV7) {
        return defaultPersistValue;
      }
      return escapeSqlString(defaultPersistValue);
    case DefaultValueAllowedType.int:
    case DefaultValueAllowedType.bool:
    case DefaultValueAllowedType.double:
    case DefaultValueAllowedType.dateTime:
      return defaultPersistValue.toString();
    case DefaultValueAllowedType.bigInt:
      // BigInt is stored in as text in the database, so keep the abstract
      // default as a quoted text literal to match database introspection.
      return escapeSqlString("'${defaultPersistValue.toString()}'");
    case DefaultValueAllowedType.duration:
      // Duration is stored as bigint milliseconds in the database.
      return parseDuration(defaultPersistValue).toJson().toString();
    case DefaultValueAllowedType.isEnum:
      final enumDefinition = column.type.enumDefinition;
      if (enumDefinition == null) return null;
      return switch (enumDefinition.serialized) {
        // Matches the expected value format for an integer column.
        EnumSerialization.byIndex =>
          '${enumDefinition.values.indexWhere((e) => e.name == defaultPersistValue)}',
        // Matches the expected value format for a text column.
        EnumSerialization.byName => escapeSqlString("'$defaultPersistValue'"),
      };
  }
}

void _sortTableDefinitions(List<TableDefinition> tables) {
  // Sort by name to make sure that we get consistent output
  tables.sort((a, b) => a.name.compareTo(b.name));
}
