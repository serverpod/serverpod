import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/sql_query_builder.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_database/src/concepts/table_relation.dart';
import 'package:test/test.dart';

class TableWithColumnOverride extends Table<int?> {
  late final ColumnString userName;
  late final ColumnInt userAge;

  TableWithColumnOverride() : super(tableName: 'user') {
    userName = ColumnString('user_name', this, fieldName: 'userName');
    userAge = ColumnInt('user_age', this, fieldName: 'userAge');
  }

  @override
  List<Column> get columns => [id, userName, userAge];
}

void main() {
  ValueEncoder.set(PostgresValueEncoder());

  group('Given model with an explicit column field name', () {
    test(
      'when building the select query then the explicit column name '
      'is used in the sql',
      () {
        final table = TableWithColumnOverride();
        final tableName = table.tableName;
        final query = SelectQueryBuilder(
          table: table,
        ).withSelectFields(table.columns).build();
        expect(
          query,
          'SELECT "$tableName"."id" AS "$tableName.id", '
          '"$tableName"."user_name" AS "$tableName.userName", '
          '"$tableName"."user_age" AS "$tableName.userAge" '
          'FROM "$tableName"',
        );
      },
    );

    test(
      'when deleting a table with explicit column names then the explicit column name is used in the sql',
      () {
        final table = TableWithColumnOverride();
        final query = DeleteQueryBuilder(
          table: table,
        ).withReturn(Returning.all).withWhere(Constant.bool(true)).build();
        expect(
          query,
          'DELETE FROM "${table.tableName}" WHERE TRUE '
          'RETURNING "${table.tableName}"."id" AS "${table.tableName}.id", '
          '"${table.tableName}"."user_name" AS "${table.tableName}.userName", '
          '"${table.tableName}"."user_age" AS "${table.tableName}.userAge"',
        );
      },
    );
  });

  group('Given model with relation with explicit column name', () {
    var citizenTable = TableWithExplicitColumn(tableName: 'citizen');
    var companyTable = Table<int?>(tableName: 'company');

    test(
      'when where expression depends on relations then output includes joins according to table relations.',
      () {
        var relationTable = TableWithExplicitColumn(
          tableName: companyTable.tableName,
          tableRelation: TableRelation([
            TableRelationEntry(
              relationAlias: 'company',
              field: ColumnInt(
                'company_id',
                citizenTable,
                fieldName: 'companyId',
              ),
              foreignField: ColumnInt(
                'company_id',
                companyTable,
                fieldName: 'companyId',
              ),
            ),
          ]),
        );

        var query = SelectQueryBuilder(table: citizenTable)
            .withWhere(
              ColumnString(
                'company_name',
                relationTable,
                fieldName: 'companyName',
              ).equals('Serverpod'),
            )
            .build();

        expect(
          query,
          'SELECT "citizen"."id" AS "citizen.id", "citizen"."company_id" AS "citizen.companyId" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."company_id" = "citizen_company_company"."company_id" WHERE "citizen_company_company"."company_name" = \'Serverpod\'',
        );
      },
    );
  });

  group('Given model with nested relation with explicit column name', () {
    var citizenTable = TableWithExplicitColumn(tableName: 'citizen');
    var companyTable = Table<int?>(tableName: 'company');

    test(
      'when where expression depends on nested relations then output includes joins according to table relations.',
      () {
        var nestedRelationTable = TableWithExplicitColumn(
          tableName: citizenTable.tableName,
          tableRelation: TableRelation([
            TableRelationEntry(
              relationAlias: 'company',
              field: ColumnInt(
                'company_id',
                citizenTable,
                fieldName: 'companyId',
              ),
              foreignField: ColumnInt(
                'company_id',
                companyTable,
                fieldName: 'companyId',
              ),
            ),
            TableRelationEntry(
              relationAlias: 'ceo',
              field: ColumnInt(
                'ceo_id',
                companyTable,
                fieldName: 'ceoId',
              ),
              foreignField: ColumnInt(
                'citizen_id',
                citizenTable,
                fieldName: 'citizenId',
              ),
            ),
          ]),
        );

        var query = SelectQueryBuilder(table: citizenTable)
            .withWhere(
              ColumnString(
                'citizen_name',
                nestedRelationTable,
                fieldName: 'citizenName',
              ).equals('Alex'),
            )
            .build();

        expect(
          query,
          'SELECT "citizen"."id" AS "citizen.id", "citizen"."company_id" AS "citizen.companyId" FROM "citizen" LEFT JOIN "company" AS "citizen_company_company" ON "citizen"."company_id" = "citizen_company_company"."company_id" LEFT JOIN "citizen" AS "citizen_company_company_ceo_citizen" ON "citizen_company_company"."ceo_id" = "citizen_company_company_ceo_citizen"."citizen_id" WHERE "citizen_company_company_ceo_citizen"."citizen_name" = \'Alex\'',
        );
      },
    );
  });

  group('Given model with one-to-many relation with explicit column name', () {
    var citizenTable = Table<int?>(tableName: 'citizen');

    test(
      'when ordering by many relation then output is many relation order by query.',
      () {
        var relationTable = TableWithExplicitManyRelation(
          tableName: citizenTable.tableName,
          relationAlias: 'friends',
        );
        Order order = Order(
          column: relationTable.manyRelation.count(),
          orderDescending: false,
        );

        var query = SelectQueryBuilder(
          table: relationTable,
        ).withOrderBy([order]).build();

        expect(
          query,
          'WITH "order_by_citizen_friends_citizen_0" AS (SELECT "citizen"."id" AS "citizen.id", COUNT("citizen_friends_citizen"."friend_id") AS "count" FROM "citizen" LEFT JOIN "citizen" AS "citizen_friends_citizen" ON "citizen"."id" = "citizen_friends_citizen"."friend_id" GROUP BY "citizen"."id") SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "order_by_citizen_friends_citizen_0" ON "citizen"."id" = "order_by_citizen_friends_citizen_0"."citizen.id" ORDER BY "order_by_citizen_friends_citizen_0"."count" ASC NULLS FIRST',
        );
      },
    );
  });

  group('Given model with self relation with explicit column name', () {
    var citizenTable = TableWithExplicitSelfRelation(tableName: 'citizen');

    test(
      'when where expression depends on self relation then output includes joins according to table relations.',
      () {
        var relationTable = TableWithExplicitSelfRelation(
          tableName: citizenTable.tableName,
          tableRelation: TableRelation([
            TableRelationEntry(
              relationAlias: 'friend',
              field: ColumnInt(
                'friend_id',
                citizenTable,
                fieldName: 'friendId',
              ),
              foreignField: ColumnInt(
                'citizen_id',
                citizenTable,
                fieldName: 'citizenId',
              ),
            ),
          ]),
        );

        var query = SelectQueryBuilder(table: citizenTable)
            .withWhere(
              ColumnString(
                'citizen_name',
                relationTable,
                fieldName: 'citizenName',
              ).equals('Alex'),
            )
            .build();

        expect(
          query,
          'SELECT "citizen"."id" AS "citizen.id", "citizen"."friend_id" AS "citizen.friendId" FROM "citizen" LEFT JOIN "citizen" AS "citizen_friend_citizen" ON "citizen"."friend_id" = "citizen_friend_citizen"."citizen_id" WHERE "citizen_friend_citizen"."citizen_name" = \'Alex\'',
        );
      },
    );
  });

  group('Given CountQueryBuilder with explicit column names', () {
    var citizenTable = Table<int?>(tableName: 'citizen');

    test(
      'when filtered count column is used in where expression then query is a sub queried count query.',
      () {
        var relationTable = TableWithExplicitManyRelation(
          tableName: citizenTable.tableName,
          relationAlias: 'friends',
        );
        var query = CountQueryBuilder(table: citizenTable)
            .withWhere(
              relationTable.manyRelation.count((t) => t.id.equals(5)) > 3,
            )
            .build();

        expect(
          query,
          'WITH "where_count_citizen_friends_citizen_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "citizen" AS "citizen_friends_citizen" ON "citizen"."id" = "citizen_friends_citizen"."friend_id" WHERE "citizen"."id" = 5 GROUP BY "citizen"."id" HAVING COUNT("citizen_friends_citizen"."friend_id") > 3) SELECT COUNT("citizen"."id") FROM "citizen" WHERE "citizen"."id" IN (SELECT "where_count_citizen_friends_citizen_0"."citizen.id" FROM "where_count_citizen_friends_citizen_0")',
        );
      },
    );

    test(
      'when none expression is used with explicit column then query uses NOT IN with field query alias.',
      () {
        var relationTable = TableWithExplicitManyRelation(
          tableName: citizenTable.tableName,
          relationAlias: 'friends',
        );
        var query = CountQueryBuilder(table: citizenTable)
            .withWhere(
              relationTable.manyRelation.none((t) => t.id.equals(5)),
            )
            .build();

        expect(
          query,
          'WITH "where_none_citizen_friends_citizen_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "citizen" AS "citizen_friends_citizen" ON "citizen"."id" = "citizen_friends_citizen"."friend_id" WHERE "citizen"."id" = 5 AND "citizen_friends_citizen"."friend_id" IS NOT NULL GROUP BY "citizen"."id") SELECT COUNT("citizen"."id") FROM "citizen" WHERE "citizen"."id" NOT IN (SELECT "where_none_citizen_friends_citizen_0"."citizen.id" FROM "where_none_citizen_friends_citizen_0")',
        );
      },
    );

    test(
      'when every expression is used with explicit column then query uses NOT IN with field query alias.',
      () {
        var relationTable = TableWithExplicitManyRelation(
          tableName: citizenTable.tableName,
          relationAlias: 'friends',
        );
        var query = CountQueryBuilder(table: citizenTable)
            .withWhere(
              relationTable.manyRelation.every((t) => t.id.equals(5)),
            )
            .build();

        expect(
          query,
          'WITH "where_every_citizen_friends_citizen_0" AS (SELECT "citizen"."id" AS "citizen.id" FROM "citizen" LEFT JOIN "citizen" AS "citizen_friends_citizen" ON "citizen"."id" = "citizen_friends_citizen"."friend_id" WHERE NOT "citizen"."id" = 5 OR "citizen_friends_citizen"."friend_id" IS NULL GROUP BY "citizen"."id") SELECT COUNT("citizen"."id") FROM "citizen" WHERE "citizen"."id" NOT IN (SELECT "where_every_citizen_friends_citizen_0"."citizen.id" FROM "where_every_citizen_friends_citizen_0")',
        );
      },
    );
  });

  group('Given DeleteQueryBuilder with explicit column names', () {
    var citizenTable = TableWithExplicitColumn(tableName: 'citizen');
    var companyTable = Table<int?>(tableName: 'company');

    test(
      'when deleting a table with explicit column names with where and order by then the order by uses the field alias in the sql',
      () {
        final table = TableWithColumnOverride();
        final query =
            DeleteQueryBuilder(
                  table: table,
                )
                .withWhere(const Expression('"user_name"=test'))
                .withReturn(Returning.all)
                .withOrderBy([
                  Order(column: table.userName),
                ])
                .build();

        expect(
          query,
          'WITH deleted_rows AS (DELETE FROM "${table.tableName}" WHERE "user_name"=test '
          'RETURNING "${table.tableName}"."id" AS "${table.tableName}.id", '
          '"${table.tableName}"."user_name" AS "${table.tableName}.userName", '
          '"${table.tableName}"."user_age" AS "${table.tableName}.userAge") '
          'SELECT * FROM deleted_rows '
          'ORDER BY "${table.tableName}.userName" ASC NULLS LAST',
        );
      },
    );

    test(
      'when deleting a table with explicit column names and multiple order by columns then the order by uses the field aliases in the sql',
      () {
        final table = TableWithColumnOverride();
        final query =
            DeleteQueryBuilder(
              table: table,
            ).withReturn(Returning.all).withOrderBy([
              Order(column: table.userName),
              Order(column: table.userAge, orderDescending: true),
            ]).build();

        expect(
          query,
          'WITH deleted_rows AS (DELETE FROM "${table.tableName}" '
          'RETURNING "${table.tableName}"."id" AS "${table.tableName}.id", '
          '"${table.tableName}"."user_name" AS "${table.tableName}.userName", '
          '"${table.tableName}"."user_age" AS "${table.tableName}.userAge") '
          'SELECT * FROM deleted_rows '
          'ORDER BY "${table.tableName}.userName" ASC NULLS LAST, '
          '"${table.tableName}.userAge" DESC NULLS FIRST',
        );
      },
    );

    test(
      'when query with return id and order by is built then format exception is thrown.',
      () {
        final table = TableWithColumnOverride();
        final queryBuilder =
            DeleteQueryBuilder(
                table: table,
              )
              ..withReturn(Returning.id)
              ..withOrderBy([
                Order(column: table.userName),
              ]);

        expect(
          () => queryBuilder.build(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.toString(),
              'message',
              equals(
                'FormatException: The following expressions need to be removed or modified:\n'
                'Order by is not supported when returning is set to Returning.id.',
              ),
            ),
          ),
        );
      },
    );

    test(
      'when query with return none and order by is built then format exception is thrown.',
      () {
        final table = TableWithColumnOverride();
        final queryBuilder =
            DeleteQueryBuilder(
                table: table,
              )
              ..withReturn(Returning.none)
              ..withOrderBy([
                Order(column: table.userName),
              ]);

        expect(
          () => queryBuilder.build(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.toString(),
              'message',
              equals(
                'FormatException: The following expressions need to be removed or modified:\n'
                'Order by is not supported when returning is set to Returning.none.',
              ),
            ),
          ),
        );
      },
    );

    test(
      'when delete query orders by a column that references its own table then format exception is thrown.',
      () {
        final table = TableWithColumnOverride();
        var relationTable = TableWithExplicitColumn(
          tableName: table.tableName,
          tableRelation: TableRelation([
            TableRelationEntry(
              relationAlias: 'father',
              field: ColumnInt('fatherId', table),
              foreignField: ColumnInt('id', table),
            ),
          ]),
        );

        var queryBuilder =
            DeleteQueryBuilder(
                table: table,
              )
              ..withReturn(Returning.all)
              ..withOrderBy([
                Order(column: ColumnString('user_age', relationTable)),
              ]);

        expect(
          () => queryBuilder.build(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.toString(),
              'message',
              equals(
                'FormatException: The following expressions need to be removed or modified:\n'
                'DeleteQueryBuilder orderBy only supports columns from "user" and its aliases. '
                'Column "user_father_user"."user_age" resolves to alias "user_father_user.user_age", which is not present in the returned result.',
              ),
            ),
          ),
        );
      },
    );

    test(
      'when delete query orders by column count then format exception is thrown.',
      () {
        var relationTable = TableWithExplicitManyRelation(
          tableName: citizenTable.tableName,
          relationAlias: 'friends',
        );

        var queryBuilder =
            DeleteQueryBuilder(
                table: citizenTable,
              )
              ..withReturn(Returning.all)
              ..withOrderBy([
                Order(column: relationTable.manyRelation.count()),
              ]);

        expect(
          () => queryBuilder.build(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.toString(),
              'message',
              equals(
                'FormatException: The following expressions need to be removed or modified:\n'
                'DeleteQueryBuilder does not support ordering returned rows by ColumnCount.',
              ),
            ),
          ),
        );
      },
    );

    test(
      'when delete query order by has different table as base then exception is thrown.',
      () {
        var queryBuilder =
            DeleteQueryBuilder(
                table: citizenTable,
              )
              ..withReturn(Returning.all)
              ..withOrderBy([
                Order(column: ColumnString('name', companyTable)),
              ]);

        expect(
          () => queryBuilder.build(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.toString(),
              'message',
              equals(
                'FormatException: The following expressions need to be removed or modified:\n'
                'DeleteQueryBuilder orderBy only supports columns from "citizen".',
              ),
            ),
          ),
        );
      },
    );

    test(
      'when where expression depends on relations then output includes using according to table relations.',
      () {
        var relationTable = TableWithExplicitColumn(
          tableName: companyTable.tableName,
          tableRelation: TableRelation([
            TableRelationEntry(
              relationAlias: 'company',
              field: ColumnInt(
                'company_id',
                citizenTable,
                fieldName: 'companyId',
              ),
              foreignField: ColumnInt(
                'company_id',
                companyTable,
                fieldName: 'companyId',
              ),
            ),
          ]),
        );

        var query = DeleteQueryBuilder(table: citizenTable)
            .withWhere(
              ColumnString(
                'company_name',
                relationTable,
                fieldName: 'companyName',
              ).equals('Serverpod'),
            )
            .build();

        expect(
          query,
          'DELETE FROM "citizen" USING "company" AS "citizen_company_company" WHERE "citizen_company_company"."company_name" = \'Serverpod\' AND "citizen"."company_id" = "citizen_company_company"."company_id"',
        );
      },
    );

    test(
      'when where expression depends on nested relations then output includes using according to table relations.',
      () {
        var nestedRelationTable = TableWithExplicitColumn(
          tableName: citizenTable.tableName,
          tableRelation: TableRelation([
            TableRelationEntry(
              relationAlias: 'company',
              field: ColumnInt(
                'company_id',
                citizenTable,
                fieldName: 'companyId',
              ),
              foreignField: ColumnInt(
                'company_id',
                companyTable,
                fieldName: 'companyId',
              ),
            ),
            TableRelationEntry(
              relationAlias: 'ceo',
              field: ColumnInt(
                'ceo_id',
                companyTable,
                fieldName: 'ceoId',
              ),
              foreignField: ColumnInt(
                'citizen_id',
                citizenTable,
                fieldName: 'citizenId',
              ),
            ),
          ]),
        );

        var query = DeleteQueryBuilder(table: citizenTable)
            .withWhere(
              ColumnString(
                'citizen_name',
                nestedRelationTable,
                fieldName: 'citizenName',
              ).equals('Alex'),
            )
            .build();

        expect(
          query,
          'DELETE FROM "citizen" USING "company" AS "citizen_company_company", "citizen" AS "citizen_company_company_ceo_citizen" WHERE "citizen_company_company_ceo_citizen"."citizen_name" = \'Alex\' AND "citizen"."company_id" = "citizen_company_company"."company_id" AND "citizen_company_company"."ceo_id" = "citizen_company_company_ceo_citizen"."citizen_id"',
        );
      },
    );

    test(
      'when any expression is used and order by is built then output is a valid SQL query.',
      () {
        final table = TableWithColumnOverride();
        var relationTable = TableWithExplicitManyRelation(
          tableName: table.tableName,
          relationAlias: 'friends',
        );

        final query =
            DeleteQueryBuilder(
                  table: table,
                )
                .withWhere(relationTable.manyRelation.any())
                .withReturn(Returning.all)
                .withOrderBy([
                  Order(column: table.userAge),
                ])
                .build();

        expect(
          query,
          'WITH "where_any_user_friends_user_0" AS (SELECT "user"."id" AS "user.id" FROM "user" LEFT JOIN "user" AS "user_friends_user" ON "user"."id" = "user_friends_user"."friend_id" WHERE "user_friends_user"."friend_id" IS NOT NULL GROUP BY "user"."id") , deleted_rows AS (DELETE FROM "user" WHERE "user"."id" IN (SELECT "where_any_user_friends_user_0"."user.id" FROM "where_any_user_friends_user_0") RETURNING "user"."id" AS "user.id", "user"."user_name" AS "user.userName", "user"."user_age" AS "user.userAge") SELECT * FROM deleted_rows ORDER BY "user.userAge" ASC NULLS LAST',
        );
      },
    );
  });

  group('Given many relation joining on non-id column with explicit names', () {
    var citizenTable = Table<int?>(tableName: 'citizen');

    test(
      'when none expression is used on non-id join then query uses NOT IN with correct field query alias.',
      () {
        var relationTable = TableWithManyRelationOnNonId(
          tableName: citizenTable.tableName,
          relationAlias: 'colleagues',
        );
        var query = CountQueryBuilder(table: citizenTable)
            .withWhere(
              relationTable.manyRelation.none((t) => t.id.equals(5)),
            )
            .build();

        // Should use company_id in the NOT IN clause, not id
        expect(
          query,
          'WITH "where_none_citizen_colleagues_citizen_0" AS (SELECT "citizen"."company_id" AS "citizen.companyId" FROM "citizen" LEFT JOIN "citizen" AS "citizen_colleagues_citizen" ON "citizen"."company_id" = "citizen_colleagues_citizen"."company_id" WHERE "citizen"."id" = 5 AND "citizen_colleagues_citizen"."company_id" IS NOT NULL GROUP BY "citizen"."company_id") SELECT COUNT("citizen"."id") FROM "citizen" WHERE "citizen"."company_id" NOT IN (SELECT "where_none_citizen_colleagues_citizen_0"."citizen.company_id" FROM "where_none_citizen_colleagues_citizen_0")',
        );
      },
    );
  });
}

class TableWithExplicitColumn extends Table<int?> {
  late final ColumnInt companyId;

  TableWithExplicitColumn({
    required super.tableName,
    super.tableRelation,
  }) {
    companyId = ColumnInt('company_id', this, fieldName: 'companyId');
  }

  @override
  List<Column> get columns => [id, companyId];
}

class TableWithExplicitManyRelation extends Table<int?> {
  final String _relationAlias;

  TableWithExplicitManyRelation({
    String? relationAlias,
    required super.tableName,
    super.tableRelation,
  }) : _relationAlias = relationAlias ?? '';

  ManyRelation<TableWithExplicitManyRelation>? _manyRelation;

  ManyRelation<TableWithExplicitManyRelation> get manyRelation {
    if (_manyRelation != null) return _manyRelation!;

    var relationTable = createRelationTable(
      relationFieldName: _relationAlias,
      field: id,
      foreignField: ColumnInt(
        'friend_id',
        this,
        fieldName: 'friendId',
      ) /* This should really be something different than the "id" column but by reusing it we are saved from creating a different table. */,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => TableWithExplicitManyRelation(
        relationAlias: _relationAlias,
        tableName: tableName,
        tableRelation: foreignTableRelation,
      ),
    );

    _manyRelation = ManyRelation<TableWithExplicitManyRelation>(
      tableWithRelations: relationTable,
      table: TableWithExplicitManyRelation(
        relationAlias: _relationAlias,
        tableName: tableName,
      ),
    );
    return _manyRelation!;
  }

  @override
  List<Column> get columns => [id];
}

class TableWithExplicitSelfRelation extends Table<int?> {
  late final ColumnInt friendId;

  TableWithExplicitSelfRelation({
    required super.tableName,
    super.tableRelation,
  }) {
    friendId = ColumnInt('friend_id', this, fieldName: 'friendId');
  }

  @override
  List<Column> get columns => [id, friendId];
}

class TableWithManyRelationOnNonId extends Table<int?> {
  final String _relationAlias;
  late final ColumnInt companyId;

  TableWithManyRelationOnNonId({
    String? relationAlias,
    required super.tableName,
    super.tableRelation,
  }) : _relationAlias = relationAlias ?? '' {
    companyId = ColumnInt('company_id', this, fieldName: 'companyId');
  }

  ManyRelation<TableWithManyRelationOnNonId>? _manyRelation;

  ManyRelation<TableWithManyRelationOnNonId> get manyRelation {
    if (_manyRelation != null) return _manyRelation!;

    var relationTable = createRelationTable(
      relationFieldName: _relationAlias,
      field: companyId,
      foreignField: ColumnInt(
        'company_id',
        this,
        fieldName: 'companyId',
      ),
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => TableWithManyRelationOnNonId(
        relationAlias: _relationAlias,
        tableName: tableName,
        tableRelation: foreignTableRelation,
      ),
    );

    _manyRelation = ManyRelation<TableWithManyRelationOnNonId>(
      tableWithRelations: relationTable,
      table: TableWithManyRelationOnNonId(
        relationAlias: _relationAlias,
        tableName: tableName,
      ),
    );
    return _manyRelation!;
  }

  @override
  List<Column> get columns => [id, companyId];
}
