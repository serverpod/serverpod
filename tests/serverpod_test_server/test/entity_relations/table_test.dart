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
        var columnExpressionsWithObjectRelations = columnExpressions
            .where((element) => element.tableRelations != null);

        expect(columnExpressionsWithObjectRelations.length, 2);
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
        expect(nestedRelationAccess.tableRelations?.length, 3);
      });

      test(
          'then first table relation describes relation for citizen oldCompany field.',
          () {
        var firstObjectRelation = nestedRelationAccess.tableRelations![0];

        expectObjectRelationWith(
          firstObjectRelation,
          tableName: 'company',
          queryPrefix: 'citizen_oldCompany_',
          foreignTableColumn: 'citizen."oldCompanyId"',
          column: 'citizen_oldCompany_company."id"',
        );
      }, skip: nestedRelationAccess.tableRelations == null);

      test(
          'then second table relation describes relation for company town field.',
          () {
        var firstObjectRelation = nestedRelationAccess.tableRelations![1];

        expectObjectRelationWith(
          firstObjectRelation,
          tableName: 'town',
          queryPrefix: 'citizen_oldCompany_company_town_',
          foreignTableColumn: 'citizen_oldCompany_company."townId"',
          column: 'citizen_oldCompany_company_town_town."id"',
        );
      }, skip: nestedRelationAccess.tableRelations == null);

      test('then third table relation describes relation for town mayor field.',
          () {
        var firstObjectRelation = nestedRelationAccess.tableRelations![2];

        expectObjectRelationWith(
          firstObjectRelation,
          tableName: 'citizen',
          queryPrefix: 'citizen_oldCompany_company_town_town_mayor_',
          foreignTableColumn: 'citizen_oldCompany_company_town_town."mayorId"',
          column: 'citizen_oldCompany_company_town_town_mayor_citizen."id"',
        );
      }, skip: nestedRelationAccess.tableRelations == null);
    });
  });
}

void expectObjectRelationWith(
  dynamic
      tableRelation /* Dynamic is used since we don't want to expose the ObjectRelation class */, {
  required String tableName,
  required String queryPrefix,
  required String foreignTableColumn,
  required String column,
}) {
  expect(tableRelation.tableName, tableName);
  expect(tableRelation.queryPrefix, queryPrefix);
  expect(tableRelation.foreignTableColumn.toString(), foreignTableColumn);
  expect(tableRelation.column.toString(), column);
}
