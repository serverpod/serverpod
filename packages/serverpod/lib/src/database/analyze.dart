import 'package:serverpod/protocol.dart';
import 'package:serverpod/src/database/database.dart';

import '../util/column_type_extension.dart';

class DatabaseAnalyzer {
  static Future<DatabaseDefinition> analyze(Database database) async {
    return DatabaseDefinition(
      name: (await database.query('SELECT current_database();')).first.first,
      tables: await Future.wait((await database.query(
              "SELECT schemaname, tablename FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';"))
          .map((tableInfo) async {
        var schemaName = tableInfo.first;
        var tableName = tableInfo.last;

        var columns = (await database.query('''
SELECT column_name, column_default, is_nullable, data_type
FROM information_schema.columns
WHERE table_schema = '$schemaName' AND table_name = '$tableName'
ORDER BY ordinal_position;
'''))
            .map((e) => ColumnDefinition(
                name: e[0],
                columnDefault: e[1],
                columnType: ExtendedColumnType.fromSqlType(e[3]),
                isNullable: e[2] == 'YES'))
            .toList();

        var indexes = (await database.query('''
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
                    definition: (index[4][i] as String).unquote)),
            type: index[7],
            isUnique: index[2],
            isPrimary: index[3],
            //TODO: Maybe unquote in the future. Should be considered when Serverpod introduces partial indexes.
            predicate: index[6],
          );
        }).toList();

        var foreignKeys = (await database.query('''
SELECT conname, confupdtype, confdeltype, confmatchtype,
ARRAY(
       SELECT attname::text
       FROM unnest(conkey) as i
       JOIN pg_attribute ON attrelid = t.oid AND attnum = i
       ) as conkey,
r.relname,
ARRAY(
       SELECT attname::text
       FROM unnest(confkey) as i
       JOIN pg_attribute ON attrelid = r.oid AND attnum = i
       ) as confkey
FROM pg_constraint
JOIN pg_class t ON t.oid = conrelid
JOIN pg_class r ON r.oid = confrelid
JOIN pg_namespace n ON n.oid = t.relnamespace
WHERE contype = 'f' AND t.relname = '$tableName' AND n.nspname = '$schemaName';
'''))
            .map((key) => ForeignKeyDefinition(
                  constraintName: key[0],
                  columns: key[4],
                  referenceTable: key[5],
                  referenceColumns: key[6],
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
    );
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

extension on String {
  String get unquote {
    //TODO: Handle " that are inside an expression.
    if (startsWith('"') && endsWith('"')) {
      return substring(1, length - 1);
    } else {
      return this;
    }
  }
}
