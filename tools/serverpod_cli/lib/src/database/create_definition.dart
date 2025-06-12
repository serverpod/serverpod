import 'package:intl/intl.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/duration_utils.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/quote_utils.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Create the target [DatabaseDefinition] based on the [serializableModel].
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
                  name: column.name,
                  columnType:
                      ColumnType.values.byName(column.type.databaseTypeEnum),
                  // The id column is not null, since it is auto generated.
                  isNullable: column.name != 'id' && column.type.nullable,
                  dartType: column.type.toString(),
                  columnDefault: getColumnDefault(
                    column.type,
                    column.defaultPersistValue,
                    classDefinition.tableName!,
                  ),
                  vectorDimension: column.type.vectorDimension,
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
                vectorDistanceFunction: index.isVectorIndex
                    ? index.vectorDistanceFunction ?? VectorDistanceFunction.l2
                    : null,
                vectorColumnType: index.isVectorIndex
                    ? ColumnType.values.firstWhere((type) =>
                        type.name ==
                        classDefinition.fields
                            .firstWhere((f) => index.fields.contains(f.name))
                            .type
                            .databaseTypeEnum)
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

List<ForeignKeyDefinition> _createForeignKeys(
    ModelClassDefinition classDefinition) {
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

String? getColumnDefault(
  TypeDefinition columnType,
  dynamic defaultValue,
  String tableName,
) {
  var defaultValueType = columnType.defaultValueType;
  if ((defaultValue == null) || (defaultValueType == null)) return null;

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
      if (defaultValue == defaultIntSerial) {
        return "nextval('${tableName}_id_seq'::regclass)";
      }
      return '$defaultValue';
    case DefaultValueAllowedType.double:
      return '$defaultValue';
    case DefaultValueAllowedType.string:
      return '${_escapeSqlString(defaultValue)}::text';
    case DefaultValueAllowedType.uuidValue:
      if (defaultUuidValueRandom == defaultValue) {
        return 'gen_random_uuid()';
      }
      if (defaultUuidValueRandomV7 == defaultValue) {
        return 'gen_random_uuid_v7()';
      }
      return '${_escapeSqlString(defaultValue)}::uuid';
    case DefaultValueAllowedType.uri:
      return '${_escapeSqlString(defaultValue)}::text';
    case DefaultValueAllowedType.bigInt:
      var parsedBigInt = BigInt.parse(defaultValue);
      return "'${parsedBigInt.toString()}'::text";
    case DefaultValueAllowedType.duration:
      Duration parsedDuration = parseDuration(defaultValue);
      return '${parsedDuration.toJson()}';
    case DefaultValueAllowedType.isEnum:
      var enumDefinition = columnType.enumDefinition;
      if (enumDefinition == null) return null;
      var values = enumDefinition.values;
      return switch (enumDefinition.serialized) {
        EnumSerialization.byIndex =>
          '${values.indexWhere((e) => e.name == defaultValue)}',
        EnumSerialization.byName => '\'$defaultValue\'::text',
      };
  }
}

/// Converts a Dart string into a SQL-safe string by escaping necessary characters.
///
/// This method handles:
/// - Escaping single quotes (`'`) to prevent SQL injection and syntax errors.
/// - Handling escaped double quotes (`"`), ensuring they are correctly represented in SQL by doubling them.
///
/// The method performs validation to ensure the string contains valid quoting.
///
/// ### Examples:
/// ```dart
/// _escapeSqlString("This is a \'default persist value")  // Returns "This is a ''default persist value"
/// _escapeSqlString("This is a \"default\" persist value") // Returns "This is a ""default"" persist value"
/// ```
///
/// Throws:
/// - `FormatException` if the string contains invalid quoting.
String _escapeSqlString(String value) {
  if (isValidSingleQuote(value)) {
    return value.replaceAll("\\'", "''").replaceAll('\\"', '"');
  }

  if (isValidDoubleQuote(value)) {
    return value.replaceAll("\\'", "'").replaceAll('\\"', '""');
  }

  /// This exception is unlikely to be thrown due to prior validation checks,
  /// but it's included as a safeguard to handle any unexpected input.
  throw FormatException(
    'The string contains invalid quoting or escape sequences: $value',
  );
}
