import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

/// Create the target [DatabaseDefinition] based on the [serializableEntities].
DatabaseDefinition createDatabaseDefinitionFromEntities(
    List<SerializableEntityDefinition> serializableEntities) {
  return DatabaseDefinition(tables: [
    for (var classDefinition in serializableEntities)
      if (classDefinition is ClassDefinition &&
          classDefinition.tableName != null)
        TableDefinition(
          name: classDefinition.tableName!,
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
                  columnDefault: column.name == 'id'
                      ? "nextval('${classDefinition.tableName!}_id_seq'::regclass)"
                      : null,
                )
          ],
          foreignKeys: [
            for (var i = 0;
                i <
                    classDefinition.fields
                        .where((field) => field.parentTable != null)
                        .length;
                i++)
              () {
                var column = classDefinition.fields
                    .where((field) => field.parentTable != null)
                    .toList()[i];
                return ForeignKeyDefinition(
                  constraintName: '${classDefinition.tableName!}_fk_$i',
                  columns: [column.name],
                  referenceTable: column.parentTable!,
                  referenceTableSchema: 'public',
                  referenceColumns: ['id'],
                  onDelete: ForeignKeyAction.cascade,
                );
              }()
          ],
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
            for (var index in classDefinition.indexes ??
                <SerializableEntityIndexDefinition>[])
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
          //TODO: Add an option in the yaml-protocol specification for this.
          managed: true,
        ),
  ]);
}
