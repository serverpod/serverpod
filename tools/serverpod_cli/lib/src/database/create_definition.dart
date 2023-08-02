import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:collection/collection.dart';

/// Create the target [DatabaseDefinition] based on the [serializableEntities].
DatabaseDefinition createDatabaseDefinitionFromEntities(
    List<SerializableEntityDefinition> serializableEntities) {
  var tables = <TableDefinition>[
    for (var classDefinition in serializableEntities)
      if (classDefinition is ClassDefinition &&
          classDefinition.tableName != null)
        TableDefinition(
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
                  columnDefault: column.name == 'id'
                      ? "nextval('${classDefinition.tableName!}_id_seq'::regclass)"
                      : null,
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
          //TODO: Add an option in the class specification for this.
          managed: true,
        ),
  ];

  // Sort the database definitions
  _sortTableDefinitions(tables);

  return DatabaseDefinition(tables: tables);
}

List<ForeignKeyDefinition> _createForeignKeys(ClassDefinition classDefinition) {
  return classDefinition.fields
      .where((field) => field.relation is IdRelationDefinition)
      .mapIndexed((i, field) {
    var relation = field.relation as IdRelationDefinition;
    return ForeignKeyDefinition(
      constraintName: '${classDefinition.tableName!}_fk_$i',
      columns: [field.name],
      referenceTable: relation.parentTable,
      referenceTableSchema: 'public',
      referenceColumns: ['id'],
      onDelete: ForeignKeyAction.cascade,
    );
  }).toList();
}

void _sortTableDefinitions(List<TableDefinition> tables) {
  // First sort by name to make sure that we get consistent output
  tables.sort((a, b) => a.name.compareTo(b.name));

  // Force to run at least one time
  var movedEntry = true;

  // Move tables with dependencies down the list until all dependencies are
  // resolved
  while (movedEntry) {
    movedEntry = false;
    var visitedTableNames = <String>{};

    // Iterate from the top of the list
    tableLoop:
    for (int i = 0; i < tables.length; i++) {
      var table = tables[i];

      for (var field in table.columns) {
        // Find parent, if any
        String? parent;
        if (table.foreignKeys.isNotEmpty) {
          for (var key in table.foreignKeys) {
            if (key.columns.length != 1) {
              throw FormatException(
                'Serverpod does not support foreign keys with multiple column '
                'references for table "${table.name}"',
              );
            }
            assert(key.columns.length == 1);
            if (field.name == key.columns.first) {
              parent = key.referenceTable;
              break;
            }
          }
        }

        // Check if a parent is not above the current table and not self-referencing
        if (parent != null &&
            parent != table.name &&
            !visitedTableNames.contains(parent)) {
          var tableToMove = table;
          for (int j = i; j < tables.length; j++) {
            if (tables[j].name == parent) {
              // Move a table down the list, below its dependency
              tables.removeAt(i);
              tables.insert(j, tableToMove);
              movedEntry = true;
              break;
            }
          }

          if (!movedEntry) {
            // We failed to move a table because the dependency is missing
            throw FormatException('The table "${table.name}" '
                '(class "${table.dartName}" is referencing a table '
                'that doesn\'t exist ($parent).)');
          }

          break tableLoop;
        }
      }
      visitedTableNames.add(table.name);
    }
  }
}
