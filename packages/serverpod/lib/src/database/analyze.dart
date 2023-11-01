import 'dart:io';

import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/database.dart';

import '../util/column_type_extension.dart';

/// Analyzes the structure of [Database]s.
class DatabaseAnalyzer {
  /// Analyze the structure of the [database].
  static Future<DatabaseDefinition> analyze(Database database) async {
    return DatabaseDefinition(
      name: (await database.dangerouslyQuery('SELECT current_database();'))
          .first
          .first,
      tables: await Future.wait((await database.dangerouslyQuery(
// Get list of all tables and the schema they are in.
          '''
SELECT schemaname, tablename
FROM pg_catalog.pg_tables
WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';
''')).map((tableInfo) async {
        var schemaName = tableInfo.first;
        var tableName = tableInfo.last;

        var columns = (await database.dangerouslyQuery(
// Get the columns of this table and sort them based on their position.
                '''
SELECT column_name, column_default, is_nullable, data_type
FROM information_schema.columns
WHERE table_schema = '$schemaName' AND table_name = '$tableName'
ORDER BY ordinal_position;
'''))
            .map((e) => ColumnDefinition(
                name: e[0],
                columnDefault: e[1],
                columnType: ExtendedColumnType.fromSqlType(e[3]),
                // SQL outputs YES or NO. So we have to convert it to a bool manually.
                isNullable: e[2] == 'YES'))
            .toList();

        var indexes = (await database.dangerouslyQuery(
// We want to get the name (0), tablespace (1), isUnique (2), isPrimary (3),
// elements (4), isElementAColumn (5), predicate (6) and type of each index for this table.
//
// Most information is stored in pg_index.
//
// Since we only know the name of our table and not the oid, we have to
// include pg_class in order to filter. Since we need pg_class twice, we name it t (table).
//
// Since we only know the name of our namespace / schema and not the oid, we have to
// include pg_namespace in order to filter. Name it n (namespace) to avoid duplicate column names.
//
// The name of the index and the tablespace are not stored in pg_index.
// So we join pg_class again. Name it i (index).
//
// The index can be stored in an other tablespace then the table. The name of the tablespace
// is stored in pg_tablespace. Use a left join, since i.reltablespace might be zero (if the default is used).
// Name the table ts (tablespace).
//
// We need to know the type of the index (e.g. btree). Use pg_am to map between the type id and its name.
//
// Filter for the current table.
//
// In the first ARRAY, generate_subscripts generates us the indexes for the values of indkey. (In the first dimension.)
// Then pg_get_indexdef gives us the name name of the column or the expression of the
// appropriate element of the index.
//
// A value in indkey is zero if we have an expression instead of an column.
// So we check if the value is greater then zero to get a bool that tells us if it is a column.
//
// pg_get_expr gets us the expression for the predicate.
            '''
SELECT i.relname, ts.spcname, indisunique, indisprimary,
ARRAY(
       SELECT pg_get_indexdef(indexrelid, k + 1, true)
       FROM generate_subscripts(indkey, 1) as k
       ) as indkey_names,
ARRAY(SELECT i > 0 FROM unnest(indkey::int[]) as i) indkey_is_column,
pg_get_expr(indpred, indrelid), am.amname
FROM pg_index
JOIN pg_class t ON t.oid = indrelid
JOIN pg_namespace n ON n.oid = t.relnamespace
JOIN pg_class i ON i.oid = indexrelid
LEFT JOIN pg_tablespace as ts ON i.reltablespace = ts.oid
JOIN pg_am am ON am.oid=i.relam
WHERE t.relname = '$tableName' AND n.nspname = '$schemaName';
''')).map((index) {
          return IndexDefinition(
            indexName: index[0],
            tableSpace: index[1],
            elements: List.generate(
                index[4].length,
                (i) => IndexElementDefinition(
                    type: index[5][i]
                        ? IndexElementDefinitionType.column
                        : IndexElementDefinitionType.expression,
                    definition:
                        (index[4][i] as String).removeSurroundingQuotes)),
            type: index[7],
            isUnique: index[2],
            isPrimary: index[3],
            //TODO: Maybe unquote in the future. Should be considered when Serverpod introduces partial indexes.
            predicate: index[6],
          );
        }).toList();

        var foreignKeys = (await database.dangerouslyQuery(
// We want to get the constraint name (0), on update type (1),
// on delete type (2), match type (3), constraint columns (4)
// referenced table (5), namespace / schema of the referenced table (6),
// referenced columns (7) for each foreign key.
//
// Most data is in the pg_constraint table.
// Join pg_class as t (table) to filter by the table name.
// Join pg_class as r (referenced) to get the name of the referenced table.
// Join pg_namespace as nt (namespace table) to filter by the namespace / schema name of the table.
// Join pg_namespace as nr (namespace referenced) to get the namespace / schema of the referenced table.
//
// The first ARRAY resolves the column name for each of the columns in conkey.
// The second ARRAY resolves the column name for each of the referenced columns in confkey.
                '''
SELECT conname, confupdtype, confdeltype, confmatchtype,
ARRAY(
       SELECT attname::text
       FROM unnest(conkey) as i
       JOIN pg_attribute ON attrelid = t.oid AND attnum = i
       ) as conkey,
r.relname, nr.nspname,
ARRAY(
       SELECT attname::text
       FROM unnest(confkey) as i
       JOIN pg_attribute ON attrelid = r.oid AND attnum = i
       ) as confkey
FROM pg_constraint
JOIN pg_class t ON t.oid = conrelid
JOIN pg_class r ON r.oid = confrelid
JOIN pg_namespace nt ON nt.oid = t.relnamespace
JOIN pg_namespace nr ON nr.oid = r.relnamespace
WHERE contype = 'f' AND t.relname = '$tableName' AND nt.nspname = '$schemaName';
'''))
            .map((key) => ForeignKeyDefinition(
                  constraintName: key[0],
                  columns: key[4],
                  referenceTable: key[5],
                  referenceTableSchema: key[6],
                  referenceColumns: key[7],
                  onUpdate: (key[1] as String).toForeignKeyAction(),
                  onDelete: (key[2] as String).toForeignKeyAction(),
                  matchType: (key[3] as String).toForeignKeyMatchType(),
                ))
            .toList();

        return TableDefinition(
          name: tableName,
          schema: schemaName,
          columns: columns,
          foreignKeys: foreignKeys,
          indexes: indexes,
        );
      })),
      migrationApiVersion: DatabaseConstants.migrationApiVersion,
    );
  }

  /// Retrieves a list of installed database migrations.
  static Future<List<DatabaseMigrationVersion>> getInstalledMigrationVersions(
      Database database) async {
    var migrations = <DatabaseMigrationVersion>[];

    try {
      var rows =
          await database.dangerouslyQuery('SELECT * FROM serverpod_migrations');
      for (var row in rows) {
        migrations.add(
          DatabaseMigrationVersion(
            module: row[0],
            version: row[1],
            priority: row[2],
            timestamp: row[3],
          ),
        );
      }
    } catch (e) {
      // Ignore if the table does not exist.
      stderr.writeln('Failed to get installed migrations: $e');
    }

    return migrations;
  }
}

extension on String {
  ForeignKeyAction? toForeignKeyAction() {
    switch (this) {
      case 'a':
        return ForeignKeyAction.noAction;
      case 'r':
        return ForeignKeyAction.restrict;
      case 'c':
        return ForeignKeyAction.cascade;
      case 'n':
        return ForeignKeyAction.setNull;
      case 'd':
        return ForeignKeyAction.setDefault;
      default:
        return null;
    }
  }

  ForeignKeyMatchType? toForeignKeyMatchType() {
    switch (this) {
      case 'f':
        return ForeignKeyMatchType.full;
      case 'p':
        return ForeignKeyMatchType.partial;
      case 's':
        return ForeignKeyMatchType.simple;
      default:
        return null;
    }
  }
}

/// Utility tools used by the [DatabaseAnalyzer].
extension on String {
  /// Removes the surrounding quotes if the string
  /// starts and ends with ".
  String get removeSurroundingQuotes {
    //TODO: Handle " that are inside an expression.
    if (startsWith('"') && endsWith('"')) {
      return substring(1, length - 1);
    } else {
      return this;
    }
  }
}
