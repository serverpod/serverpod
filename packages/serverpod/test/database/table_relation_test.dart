import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/expressions.dart';
import 'package:serverpod/src/database/table_relation.dart';
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
    var tableRelationEntries = [
      TableRelationEntry(
        relationAlias: 'ceo',
        field: ColumnInt('ceoId', table),
        foreignField: ColumnInt('id', foreignTable),
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

    group('when getRelations is called', () {
      test('then returns list with one element.', () {
        expect(tableRelation.getRelations.length, 1);
      });

      test(
          'then last element builds same buildRelationQueryAlias as outer element.',
          () {
        expect(tableRelation.getRelations.last.relationQueryAlias,
            tableRelation.relationQueryAlias);
      });
    });

    test('when lastForeignTableName is called then last table is returned.',
        () {
      expect(tableRelation.lastForeignTableName, 'citizen');
    });

    test(
        'when lastJoiningField is called then last joining field name is returned.',
        () {
      expect(tableRelation.lastJoiningField, 'company."ceoId"');
    });

    test('when lastJoiningForeignField is called then last foreign field name.',
        () {
      expect(tableRelation.lastJoiningForeignField, 'company_ceo_citizen."id"');
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
    test('when lastForeignTableName is called then last table is returned.',
        () {
      expect(tableRelation.lastForeignTableName, 'restaurant');
    });

    test(
        'when lastJoiningField is called then last joining field name is returned.',
        () {
      expect(tableRelation.lastJoiningField,
          'company_ceo_citizen."favoriteRestaurantId"');
    });

    test('when lastJoiningForeignField is called then last foreign field name.',
        () {
      expect(tableRelation.lastJoiningForeignField,
          'company_ceo_citizen_favoriteRestaurant_restaurant."id"');
    });
  });
}
