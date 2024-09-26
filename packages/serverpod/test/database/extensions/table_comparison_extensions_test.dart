import 'package:serverpod/src/database/extensions.dart';
import 'package:test/test.dart';
import 'package:serverpod/protocol.dart';

void main() {
  test('Given identical tables when compared then mismatches list is empty',
      () {
    var tableA = TableDefinition(
      name: 'test_table',
      schema: 'public',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'name',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    );

    var tableB = TableDefinition(
      name: 'test_table',
      schema: 'public',
      columns: [
        ColumnDefinition(
          name: 'id',
          columnType: ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        ColumnDefinition(
          name: 'name',
          columnType: ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    );

    var mismatches = tableA.like(tableB);

    expect(mismatches, isEmpty);
  });

  group('Given tables with different columns', () {
    test(
      'when a column is missing in the target table then mismatches include missing column',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
            ColumnDefinition(
              name: 'age',
              columnType: ColumnType.integer,
              isNullable: true,
              dartType: 'int?',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
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
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains('Column "age" is missing in the target schema.'),
        );
      },
    );

    test(
      'when the target table has an extra column then mismatches include extra column',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
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
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
            ColumnDefinition(
              name: 'name',
              columnType: ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains('Extra column "name" found in the target schema.'),
        );
      },
    );

    test(
      'when columns have different types then mismatches include column type mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'value',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'value',
              columnType: ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains(
            'Column "value" mismatch: Type mismatch: Expected "integer", found "text".',
          ),
        );
      },
    );

    test(
      'when columns have different nullability then mismatches include column nullability mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'name',
              columnType: ColumnType.text,
              isNullable: false,
              dartType: 'String',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'name',
              columnType: ColumnType.text,
              isNullable: true,
              dartType: 'String?',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains(
            'Column "name" mismatch: Nullability mismatch: Expected "false", found "true".',
          ),
        );
      },
    );
  });

  group('Given tables with different indexes', () {
    test(
      'when an index is missing in the target table then mismatches include missing index',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          indexes: [],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains('Index "idx_id" is missing in the target schema.'),
        );
      },
    );

    test(
      'when indexes have different definitions then mismatches include index mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.column,
                  definition: 'id',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          indexes: [
            IndexDefinition(
              indexName: 'idx_id',
              elements: [
                IndexElementDefinition(
                  type: IndexElementDefinitionType.expression,
                  definition: 'id DESC',
                ),
              ],
              type: 'btree',
              isUnique: false,
              isPrimary: false,
            ),
          ],
          foreignKeys: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains(
            'Index "idx_id" mismatch: Index element mismatch at position 0: Element type mismatch: Expected "column", found "expression"., Element definition mismatch: Expected "id", found "id DESC".',
          ),
        );
      },
    );
  });

  group('Given tables with different foreign keys', () {
    test(
      'when a foreign key is missing in the target table then mismatches include missing foreign key',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [
            ForeignKeyDefinition(
              constraintName: 'fk_user',
              columns: ['user_id'],
              referenceTable: 'users',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: ForeignKeyAction.noAction,
              onDelete: ForeignKeyAction.noAction,
              matchType: null,
            ),
          ],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains('Foreign key "fk_user" is missing in the target schema.'),
        );
      },
    );

    test(
      'when foreign keys have different definitions then mismatches include foreign key mismatch',
      () {
        var tableA = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [
            ForeignKeyDefinition(
              constraintName: 'fk_user',
              columns: ['user_id'],
              referenceTable: 'users',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: ForeignKeyAction.noAction,
              onDelete: ForeignKeyAction.noAction,
              matchType: null,
            ),
          ],
          indexes: [],
          managed: true,
        );

        var tableB = TableDefinition(
          name: 'test_table',
          schema: 'public',
          columns: [
            ColumnDefinition(
              name: 'user_id',
              columnType: ColumnType.integer,
              isNullable: false,
              dartType: 'int',
            ),
          ],
          foreignKeys: [
            ForeignKeyDefinition(
              constraintName: 'fk_user',
              columns: ['user_id'],
              referenceTable: 'users',
              referenceTableSchema: 'public',
              referenceColumns: ['id'],
              onUpdate: ForeignKeyAction.cascade,
              onDelete: ForeignKeyAction.noAction,
              matchType: null,
            ),
          ],
          indexes: [],
          managed: true,
        );

        var mismatches = tableA.like(tableB);

        expect(
          mismatches,
          contains(
            'Foreign key "fk_user" mismatch: OnUpdate action mismatch: Expected "noAction", found "cascade".',
          ),
        );
      },
    );
  });

  test(
    'Given tables with different names when compared then mismatches include table name mismatch',
    () {
      var tableA = TableDefinition(
        name: 'test_table_a',
        schema: 'public',
        columns: [],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var tableB = TableDefinition(
        name: 'test_table_b',
        schema: 'public',
        columns: [],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var mismatches = tableA.like(tableB);

      expect(
        mismatches,
        contains(
            'Table name mismatch: Expected "test_table_a", found "test_table_b".'),
      );
    },
  );

  test(
    'Given tables with different schemas when compared then mismatches include schema mismatch',
    () {
      var tableA = TableDefinition(
        name: 'test_table',
        schema: 'schema_a',
        columns: [],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var tableB = TableDefinition(
        name: 'test_table',
        schema: 'schema_b',
        columns: [],
        foreignKeys: [],
        indexes: [],
        managed: true,
      );

      var mismatches = tableA.like(tableB);

      expect(
        mismatches,
        contains('Schema mismatch: Expected "schema_a", found "schema_b".'),
      );
    },
  );
}
