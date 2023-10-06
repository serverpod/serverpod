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

      test('then each in expression column is retrievable.', () {
        expect(expression.columns.length, 2);
      });

      test('then each column expression has table relation.', () {
        var columns = expression.columns;
        var columnWithTableRelations =
            columns.where((element) => element.table.tableRelation != null);

        expect(columnWithTableRelations.length, 2,
            reason:
                'Table relation should exists for each column in expression since we traverse a relation field.');
      });
    });

    group('when accessing nested relations fields', () {
      var nestedRelationAccess = Citizen.t.oldCompany.town.mayor.name;

      test('then query prefix is built based on relations.', () {
        expect(nestedRelationAccess.toString(),
            'citizen_oldCompany_company_town_town_mayor_citizen."name"');
      });

      test('then table relations exists.', () {
        expect(nestedRelationAccess.table.tableRelation, isNotNull);
      });

      test('then an table relation is build for each table relation reference.',
          () {
        expect(nestedRelationAccess.table.tableRelation?.getRelations.length, 3,
            reason:
                'A table relation for each relation field traversal should be built, Citizen -> Company -> Town.');
      });

      test(
          'then first table relation describes relation for citizen oldCompany field.',
          () {
        var firstTableRelation =
            nestedRelationAccess.table.tableRelation?.getRelations[0];

        expectTableRelationWith(
          actualTableRelation: firstTableRelation,
          expectedLastForeignTableName: 'company',
          expectedRelationQueryAlias: 'citizen_oldCompany_company',
          expectedLastJoiningField: 'citizen."oldCompanyId"',
          expectedLastJoiningForeignField: 'citizen_oldCompany_company."id"',
        );
      }, skip: nestedRelationAccess.table.tableRelation == null);

      test(
          'then second table relation describes relation for company town field.',
          () {
        var secondTableRelation =
            nestedRelationAccess.table.tableRelation?.getRelations[1];

        expectTableRelationWith(
          actualTableRelation: secondTableRelation,
          expectedLastForeignTableName: 'town',
          expectedRelationQueryAlias: 'citizen_oldCompany_company_town_town',
          expectedLastJoiningField: 'citizen_oldCompany_company."townId"',
          expectedLastJoiningForeignField:
              'citizen_oldCompany_company_town_town."id"',
        );
      }, skip: nestedRelationAccess.table.tableRelation == null);

      test('then third table relation describes relation for town mayor field.',
          () {
        var thirdTableRelation =
            nestedRelationAccess.table.tableRelation?.getRelations[2];

        expectTableRelationWith(
          actualTableRelation: thirdTableRelation,
          expectedLastForeignTableName: 'citizen',
          expectedRelationQueryAlias:
              'citizen_oldCompany_company_town_town_mayor_citizen',
          expectedLastJoiningField:
              'citizen_oldCompany_company_town_town."mayorId"',
          expectedLastJoiningForeignField:
              'citizen_oldCompany_company_town_town_mayor_citizen."id"',
        );
      }, skip: nestedRelationAccess.table.tableRelation == null);
    });
  });
}

void expectTableRelationWith({
  required dynamic
      actualTableRelation /* Dynamic is used since we don't want to expose the TableRelation class */,
  required String expectedLastForeignTableName,
  required String expectedRelationQueryAlias,
  required String expectedLastJoiningField,
  required String expectedLastJoiningForeignField,
}) {
  expect(actualTableRelation.relationQueryAlias, expectedRelationQueryAlias,
      reason: 'Relation query alias is wrong.');
  expect(actualTableRelation.lastForeignTableName, expectedLastForeignTableName,
      reason: 'Last foreign table name is wrong.');
  expect(actualTableRelation.lastJoiningField, expectedLastJoiningField,
      reason: 'Last joining field is wrong.');
  expect(actualTableRelation.lastJoiningForeignField,
      expectedLastJoiningForeignField,
      reason: 'Last joining foreign field is wrong.');
}
