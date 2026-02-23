import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/concepts/table_relation.dart';
import 'package:test/test.dart';

void main() {
  ValueEncoder.set(PostgresValueEncoder());

  group('Given table relation with explicit column name', () {
    var table = Table<int?>(tableName: 'company');
    var foreignTable = Table<int?>(tableName: 'citizen');
    var lastJoiningColumn = ColumnInt('ceo_id', table, fieldName: 'ceoId');
    var lastJoiningForeignColumn = ColumnInt(
      'citizen_id',
      foreignTable,
      fieldName: 'citizenId',
    );
    var tableRelationEntries = [
      TableRelationEntry(
        relationAlias: 'ceo',
        field: lastJoiningColumn,
        foreignField: lastJoiningForeignColumn,
      ),
    ];
    TableRelation tableRelation = TableRelation(tableRelationEntries);

    test('then field name is built correctly.', () {
      expect(
        tableRelation.fieldName,
        'ceo_id',
      );
    });

    test('then field query alias is built correctly.', () {
      expect(
        tableRelation.fieldQueryAlias,
        'company.ceo_id',
      );
    });

    test('then field query alias with joins is built correctly.', () {
      expect(
        tableRelation.fieldQueryAliasWithJoins,
        'company.ceo_id',
      );
    });

    test('then field name with joins is built correctly.', () {
      expect(
        tableRelation.fieldNameWithJoins,
        '"company"."ceo_id"',
      );
    });

    test('then foreign field name is built correctly.', () {
      expect(
        tableRelation.foreignFieldName,
        'citizenId',
      );
    });

    test('then foreign field name with joins is built correctly.', () {
      expect(
        tableRelation.foreignFieldNameWithJoins,
        '"company_ceo_citizen"."citizen_id"',
      );
    });

    test('then relation query alias is built correctly.', () {
      expect(
        tableRelation.relationQueryAlias,
        'company_ceo_citizen',
      );
    });
  });
}
