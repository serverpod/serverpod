import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given table definitions with an index type not supported by SQLite, '
    'when converting the list of tables to the SQLite dialect, '
    'then a warning is logged with skipped elements.',
    () {
      String? loggedMessage;
      var tables = [
        TableDefinition(
          name: 'items',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [
            IndexDefinition(
              indexName: 'vector_search_idx',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'hnsw',
              isUnique: false,
              isPrimary: false,
            ),
          ],
        ),
      ];

      tables.forDialect(
        DatabaseDialect.sqlite,
        logWarnings: (msg) => loggedMessage = msg,
      );

      expect(
        loggedMessage,
        equals(
          'The following indexes will be skipped due to unsupported types '
          'by the database dialect "sqlite":\n'
          '  • vector_search_idx (hnsw)\n',
        ),
      );
    },
  );
}
