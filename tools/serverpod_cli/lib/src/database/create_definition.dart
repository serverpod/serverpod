import 'package:intl/intl.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

/// Create the target [DatabaseDefinition] based on the [serializableModel].
DatabaseDefinition createDatabaseDefinitionFromModels(
  List<SerializableModelDefinition> serializableModels,
  String moduleName,
  List<ModuleConfig> allModules,
) {
  var tables = <TableDefinition>[
    for (var classDefinition in serializableModels)
      if (classDefinition is ClassDefinition &&
          classDefinition.tableName != null)
        TableDefinition(
          module: moduleName,
          name: classDefinition.tableName!,
          dartName: classDefinition.className,
          schema: 'public',
          columns: [
            for (var column in classDefinition.fields)
              if (column.shouldSerializeFieldForDatabase(true))
                ColumnDefinition(
                  name: column.name,
                  columnType:
                      ColumnType.values.byName(column.type.databaseTypeEnum),
                  // The id column is not null, since it is auto incrementing.
                  isNullable: column.name != 'id' && column.type.nullable,
                  dartType: column.type.toString(),
                  columnDefault: _getColumnDefault(
                    column,
                    classDefinition,
                    ColumnType.values.byName(column.type.databaseTypeEnum),
                  ),
                )
          ],
          foreignKeys: _createForeignKeys(classDefinition),
          indexes: [
            IndexDefinition(
              indexName: '${classDefinition.tableName!}_pkey',
              elements: [
                IndexElementDefinition(
                    definition: 'id', type: IndexElementDefinitionType.column)
              ],
              type: 'btree',
              isUnique: true,
              isPrimary: true,
            ),
            for (var index in classDefinition.indexes)
              IndexDefinition(
                indexName: index.name,
                elements: [
                  for (var field in index.fields)
                    IndexElementDefinition(
                        type: IndexElementDefinitionType.column,
                        definition: field)
                ],
                type: index.type,
                isUnique: index.unique,
                isPrimary: false,
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
    installedModules:
        allModules.where((module) => module.migrationVersions.isNotEmpty).map(
      (module) {
        return DatabaseMigrationVersion(
          module: module.name,
          version: module.migrationVersions.last,
        );
      },
    ).toList(),
  );
}

List<ForeignKeyDefinition> _createForeignKeys(ClassDefinition classDefinition) {
  var fields = classDefinition.fields
      .where((field) => field.relation is ForeignRelationDefinition)
      .toList();

  List<ForeignKeyDefinition> foreignKeys = [];
  for (var i = 0; i < fields.length; i++) {
    var field = fields[i];
    var relation = field.relation as ForeignRelationDefinition;
    foreignKeys.add(ForeignKeyDefinition(
      constraintName: '${classDefinition.tableName!}_fk_$i',
      columns: [field.name],
      referenceTable: relation.parentTable,
      referenceTableSchema: 'public',
      referenceColumns: ['id'],
      onDelete: relation.onDelete,
      onUpdate: relation.onUpdate,
    ));
  }

  return foreignKeys;
}

void _sortTableDefinitions(List<TableDefinition> tables) {
  // Sort by name to make sure that we get consistent output
  tables.sort((a, b) => a.name.compareTo(b.name));
}

String? _getColumnDefault(
  SerializableModelFieldDefinition column,
  ClassDefinition classDefinition,
  ColumnType type,
) {
  if (column.name == 'id') {
    return "nextval('${classDefinition.tableName!}_id_seq'::regclass)";
  }

  var defaultValueType = column.type.defaultValueType;
  if (defaultValueType == null) return null;

  var defaultValue = column.defaultPersistValue;
  if (defaultValue == null) return null;

  switch (defaultValueType) {
    case DefaultValueAllowedType.dateTime:
      if (defaultValue is! String) {
        throw StateError('Invalid DateTime default value: $defaultValue');
      }

      if (defaultValue == defaultDateTimeValueNow) {
        return 'CURRENT_TIMESTAMP';
      }

      DateTime? dateTime = DateTime.parse(defaultValue);
      return '\'${DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime)}\'::timestamp without time zone';
    case DefaultValueAllowedType.bool:
      return defaultValue;
    case DefaultValueAllowedType.int:
      return '$defaultValue';
    case DefaultValueAllowedType.double:
      return '$defaultValue';
    case DefaultValueAllowedType.string:
      return '$defaultValue::text';
    case DefaultValueAllowedType.uuidValue:
      if (defaultUuidValueRandom == defaultValue) {
        return 'gen_random_uuid()';
      }
      return '$defaultValue::uuid';
  }
}
