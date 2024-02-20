import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/concepts/table.dart';
import 'package:serverpod/src/database/concepts/table_relation.dart';
import 'package:serverpod/test_util/table_relation_builder.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test('Given empty list when trying to construct TableRelation then throws',
      () {
    expect(
        () => TableRelation([]),
        throwsA(isA<ArgumentError>().having(
          (e) => e.toString(),
          'message',
          equals(
              'Invalid argument(s): TableRelation must have at least one entry.'),
        )));
  });

  group('Given table relation with relation definition', () {
    var table = Table(tableName: 'company');
    var foreignTable = Table(tableName: 'citizen');
    var lastJoiningColumn = ColumnInt('ceoId', table);
    var lastJoiningForeignColumn = ColumnInt('id', foreignTable);
    var tableRelationEntries = [
      TableRelationEntry(
        relationAlias: 'ceo',
        field: lastJoiningColumn,
        foreignField: lastJoiningForeignColumn,
      ),
    ];
    TableRelation tableRelation = TableRelation(tableRelationEntries);

    test(
        'when buildRelationQueryAlias is called then query prefix is built correctly.',
        () {
      expect(
        tableRelation.relationQueryAlias,
        'company_ceo_citizen',
      );
    });

    test('when fieldTable is called then last field table is returned.', () {
      expect(
        tableRelation.fieldTable,
        table,
      );
    });

    test('when fieldColumn is called then last joining column is returned.',
        () {
      expect(
        tableRelation.fieldColumn,
        lastJoiningColumn,
      );
    });

    group('when getRelations is called', () {
      test('then returns list with one element.', () {
        expect(tableRelation.getRelations.length, 1);
      });

      test(
          'then last element builds same buildRelationQueryAlias as outer element.',
          () {
        expect(
          tableRelation.getRelations.last.relationQueryAlias,
          tableRelation.relationQueryAlias,
        );
      });
    });

    test('when foreignTableName is called then last foreign table is returned.',
        () {
      expect(tableRelation.foreignTableName, 'citizen');
    });

    test(
        'when fieldNameWithJoins is called then last joining field name is returned.',
        () {
      expect(tableRelation.fieldNameWithJoins, '"company"."ceoId"');
    });

    test(
        'when fieldQueryAliasWithJoins is called then last field query alias with joins is returned.',
        () {
      expect(tableRelation.fieldQueryAliasWithJoins, 'company.ceoId');
    });

    test(
        'when foreignFieldBaseQuery is called then the base query for the citizen is created.',
        () {
      expect(tableRelation.foreignFieldBaseQuery, '"citizen"."id"');
    });

    test(
        'when foreignFieldQueryAlias is called then the unescaped version of the base query for foreign field is created.',
        () {
      expect(tableRelation.foreignFieldQueryAlias, 'citizen.id');
    });

    test(
        'when fieldQueryAlias is called then the unescaped version of the base query for field is created.',
        () {
      expect(
        tableRelation.fieldQueryAlias,
        'company.ceoId',
      );
    });

    test(
        'when foreignFieldNameWithJoins is called then last foreign field name with joins is returned.',
        () {
      expect(tableRelation.foreignFieldNameWithJoins,
          '"company_ceo_citizen"."id"');
    });

    test('when fieldColumn is called then last joining column is returned.',
        () {
      expect(
        tableRelation.fieldColumn,
        lastJoiningColumn,
      );
    });

    group('when using copyAndAppend to create new table relation ', () {
      var table = Table(tableName: 'citizen');
      var foreignTable = Table(tableName: 'restaurant');
      var newTableRelation = tableRelation.copyAndAppend(
        TableRelationEntry(
          relationAlias: 'favoriteRestaurant',
          field: ColumnInt('favoriteRestaurantId', table),
          foreignField: ColumnInt('id', foreignTable),
        ),
      );
      test('then new table relation still starts with base table name.', () {
        expect(
          newTableRelation.relationQueryAlias,
          startsWith('company'),
        );
      });

      test('then new table relation builds query prefix correctly.', () {
        expect(
          newTableRelation.relationQueryAlias,
          'company_ceo_citizen_favoriteRestaurant_restaurant',
        );
      });
    });
  });

  group('Given table relation with multiple relation definitions', () {
    var companyTable = Table(tableName: 'company');
    var citizenTable = Table(tableName: 'citizen');
    var restaurantTable = Table(tableName: 'restaurant');
    var tableRelationEntries = [
      TableRelationEntry(
        relationAlias: 'ceo',
        field: ColumnInt('ceoId', companyTable),
        foreignField: ColumnInt('id', citizenTable),
      ),
      TableRelationEntry(
        relationAlias: 'favoriteRestaurant',
        field: ColumnInt('favoriteRestaurantId', citizenTable),
        foreignField: ColumnInt('id', restaurantTable),
      ),
    ];
    TableRelation tableRelation = TableRelation(tableRelationEntries);

    test(
        'when buildRelationQueryAlias is called then query prefix is built correctly.',
        () {
      expect(
        tableRelation.relationQueryAlias,
        'company_ceo_citizen_favoriteRestaurant_restaurant',
      );
    });

    group('when getRelations is called', () {
      test(
          'then returns list with one entry for each table relation definition.',
          () {
        expect(
          tableRelation.getRelations,
          hasLength(tableRelationEntries.length),
        );
      });

      test(
          'then last element builds same buildRelationQueryAlias as outer element.',
          () {
        expect(tableRelation.getRelations.last.relationQueryAlias,
            tableRelation.relationQueryAlias);
      });
    });
    test(
        'when foreignTableName is called then last foreign table name is returned.',
        () {
      expect(tableRelation.foreignTableName, 'restaurant');
    });

    test(
        'when fieldNameWithJoins is called then last joining field name is returned.',
        () {
      expect(tableRelation.fieldNameWithJoins,
          '"company_ceo_citizen"."favoriteRestaurantId"');
    });

    test(
        'when foreignFieldNameWithJoins is called then last foreign field name.',
        () {
      expect(tableRelation.foreignFieldNameWithJoins,
          '"company_ceo_citizen_favoriteRestaurant_restaurant"."id"');
    });

    test(
        'when fieldQueryAliasWithJoins is called then last field query alias with joins is returned.',
        () {
      expect(tableRelation.fieldQueryAliasWithJoins,
          'company_ceo_citizen.favoriteRestaurantId');
    });

    test(
        'when foreignFieldQuery is called then the base query for the citizen is created.',
        () {
      expect(tableRelation.foreignFieldBaseQuery, '"restaurant"."id"');
    });

    test(
        'when foreignFieldQueryAlias is called then the unescaped version of the base query for foreign field is created.',
        () {
      expect(tableRelation.foreignFieldQueryAlias, 'restaurant.id');
    });

    test(
        'when fieldQueryAlias is called then the unescaped version of the base query for field is created.',
        () {
      expect(
        tableRelation.fieldQueryAlias,
        'citizen.favoriteRestaurantId',
      );
    });

    test(
        'that we fetch last relation from when getting last joining foreign field then field field only contain last table join.',
        () {
      var lastRelation = tableRelation.lastRelation;

      expect(lastRelation.foreignFieldNameWithJoins,
          '"citizen_favoriteRestaurant_restaurant"."id"');
    });
  });

  group(
      'Given a table relation between two tables with long table and relation field names',
      () {
    var companyTableName =
        'company_company_company_company_company_company_company';
    var companyTable = Table(
      tableName: companyTableName,
    );
    var citizenTable = Table(
      tableName: 'citizen_citizen_citizen_citizen_citizen_citizen_citizen',
    );
    var joiningColumn = ColumnInt(
      'id_id_id_id_id_id_id_id_id_id_id_id_id_id_id_id_id_id_id_id',
      companyTable,
    );
    var joiningForeignColumn = ColumnInt(
        'employer_employer_employer_employer_employer_employer', citizenTable);
    var relationTable = createRelationTable(
      relationFieldName:
          'ceo_ceo_ceo_ceo_ceo_ceo_ceo_ceo_ceo_ceo_ceo_ceo_ceo_ceo',
      field: joiningColumn,
      foreignField: joiningForeignColumn,
      createTable: (foreignTableRelation) => Table(
        tableName: companyTableName,
        tableRelation: foreignTableRelation,
      ),
    );

    var tableRelation = relationTable.tableRelation;

    group('when getting field query alias', () {
      test('then alias is truncated', () {
        expect(
          tableRelation?.fieldQueryAlias,
          'company_company_company_company_company_company_company.id_2834',
        );
      });

      test(
          'then alias is deterministically truncated to same as colum query alias',
          () {
        expect(
          tableRelation?.fieldQueryAlias,
          truncateIdentifier(
            joiningColumn.queryAlias,
            DatabaseConstants.pgsqlMaxNameLimitation,
          ),
        );
      });
    });

    group('when getting foreign field query alias then alias is truncated', () {
      test('then alias is truncated', () {
        expect(
          tableRelation?.foreignFieldQueryAlias,
          'citizen_citizen_citizen_citizen_citizen_citizen_citizen.emp4790',
        );
      });

      test(
          'then alias is deterministically truncated to same as colum query alias',
          () {
        expect(
          tableRelation?.foreignFieldQueryAlias,
          truncateIdentifier(
            joiningForeignColumn.queryAlias,
            DatabaseConstants.pgsqlMaxNameLimitation,
          ),
        );
      });
    });
  });

  group('Given a table relation between three tables with long table names',
      () {
    var citizenTable = Table(
      tableName: 'citizen_citizen_citizen_citizen_citizen_citizen_citizen',
    );
    var companyTable = Table(
      tableName: 'company_company_company_company_company_company_company',
    );
    var addressTable = Table(
      tableName: 'address_address_address_address_address_address_address',
    );
    Table relationTable = TableRelationBuilder(companyTable).withRelationsFrom([
      BuilderRelation(citizenTable, 'customer'),
      BuilderRelation(addressTable, 'billing_address')
    ]).build();

    var tableRelation = relationTable.tableRelation;

    test('when getting field query alias with joins then alias is truncated',
        () {
      expect(
        tableRelation?.fieldQueryAliasWithJoins,
        'citizen_citizen_citizen_citizen_citizen_citizen_citizen_cus5b19',
      );
    });

    test('when getting field name with joins then alias is truncated', () {
      expect(
        tableRelation?.fieldNameWithJoins,
        '"citizen_citizen_citizen_citizen_citizen_citizen_citizen_cusa803"."id"',
      );
    });

    test('when getting foreign field name with joins then alias is truncated',
        () {
      expect(
        tableRelation?.foreignFieldNameWithJoins,
        '"citizen_citizen_citizen_citizen_citizen_citizen_citizen_cusa968"."id"',
      );
    });

    test('when getting relation query alias then alias is truncated', () {
      expect(
        tableRelation?.relationQueryAlias,
        'citizen_citizen_citizen_citizen_citizen_citizen_citizen_cusa968',
      );
    });
  });
}
