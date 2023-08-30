import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given entities with deep nested relations', () {
    group('when building expression with deep nested relations', () {
      Expression expression =
          Citizen.t.oldCompany.town.mayor.name.equals('Alex') &
              Citizen.t.company.name.equals('Serverpod');

      test('then query prefix is built based on relations.', () {
        expect(expression.toString(),
            '(citizen_oldCompany_company_town_town_mayor_citizen."name" = \'Alex\' AND citizen_company_company."name" = \'Serverpod\')');
      });

      test('then node exists for each sub expression.', () {
        expect(expression.nodes.length, 4);
      });

      test('then each column expression has table relation.', () {
        var columnExpressions = expression.nodes.whereType<Column>();
        var columnExpressionsWithTableRelations = columnExpressions
            .where((element) => element.tableRelations != null);

        expect(columnExpressionsWithTableRelations.length, 2,
            reason:
                'Table relation should exists for each column expression since we traverse a relation field.');
      });
    });

    group('when accessing nested relations fields', () {
      var nestedRelationAccess = Citizen.t.oldCompany.town.mayor.name;

      test('then query prefix is built based on relations.', () {
        expect(nestedRelationAccess.toString(),
            'citizen_oldCompany_company_town_town_mayor_citizen."name"');
      });

      test('then table relations exists.', () {
        expect(nestedRelationAccess.tableRelations, isNotNull);
      });

      test('then an table relation is build for each table relation reference.',
          () {
        expect(nestedRelationAccess.tableRelations?.length, 3,
            reason:
                'A table relation for each relation field traversal should be built, Citizen -> Company -> Town.');
      });

      test(
          'then first table relation describes relation for citizen oldCompany field.',
          () {
        var firstTableRelation = nestedRelationAccess.tableRelations![0];

        expectTableRelationWith(
          actualTable: firstTableRelation,
          expectedTableName: 'company',
          expectedQueryPrefix: 'citizen_oldCompany_',
          expectedForeignTableColumn: 'citizen."oldCompanyId"',
          expectedColumn: 'citizen_oldCompany_company."id"',
        );
      }, skip: nestedRelationAccess.tableRelations == null);

      test(
          'then second table relation describes relation for company town field.',
          () {
        var secondTableRelation = nestedRelationAccess.tableRelations![1];

        expectTableRelationWith(
          actualTable: secondTableRelation,
          expectedTableName: 'town',
          expectedQueryPrefix: 'citizen_oldCompany_company_town_',
          expectedForeignTableColumn: 'citizen_oldCompany_company."townId"',
          expectedColumn: 'citizen_oldCompany_company_town_town."id"',
        );
      }, skip: nestedRelationAccess.tableRelations == null);

      test('then third table relation describes relation for town mayor field.',
          () {
        var thirdTableRelation = nestedRelationAccess.tableRelations![2];

        expectTableRelationWith(
          actualTable: thirdTableRelation,
          expectedTableName: 'citizen',
          expectedQueryPrefix: 'citizen_oldCompany_company_town_town_mayor_',
          expectedForeignTableColumn:
              'citizen_oldCompany_company_town_town."mayorId"',
          expectedColumn:
              'citizen_oldCompany_company_town_town_mayor_citizen."id"',
        );
      }, skip: nestedRelationAccess.tableRelations == null);
    });
  });
}

void expectTableRelationWith({
  required dynamic
      actualTable /* Dynamic is used since we don't want to expose the TableRelation class */,
  required String expectedTableName,
  required String expectedQueryPrefix,
  required String expectedForeignTableColumn,
  required String expectedColumn,
}) {
  expect(actualTable.tableName, expectedTableName,
      reason: 'Table name is wrong.');
  expect(actualTable.queryPrefix, expectedQueryPrefix,
      reason: 'Query prefix is wrong.');
  expect(actualTable.foreignTableColumn.toString(), expectedForeignTableColumn,
      reason: 'Foreign table column is wrong.');
  expect(actualTable.column.toString(), expectedColumn,
      reason: 'Column is wrong.');
}
