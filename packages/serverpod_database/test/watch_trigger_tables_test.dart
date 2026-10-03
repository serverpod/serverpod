import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_database/src/adapters/sqlite/watch_trigger_tables.dart';
import 'package:test/test.dart';

import 'test_util/many_relation_builder.dart';
import 'test_util/table_relation_builder.dart';

void main() {
  ValueEncoder.set(const PostgresValueEncoder());

  group('Given a company table related to a town table, ', () {
    late Table companyTable;
    late Table townTable;
    late Table townViaCompany;
    late ColumnString townName;

    setUp(() {
      companyTable = Table<int?>(tableName: 'company');
      townTable = Table<int?>(tableName: 'town');
      townViaCompany = TableRelationBuilder(townTable).withRelationsFrom([
        BuilderRelation(companyTable, 'town'),
      ]).build();
      townName = ColumnString('name', townViaCompany);
    });

    test(
      'when collecting trigger tables for the company table alone, '
      'then only the company table is included.',
      () {
        expect(
          collectWatchTriggerTables(table: companyTable),
          {'company'},
        );
      },
    );

    test(
      'when collecting trigger tables for a where clause on the related town name, '
      'then both company and town are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: companyTable,
            where: townName.equals('Stockholm'),
          ),
          {'company', 'town'},
        );
      },
    );

    test(
      'when collecting trigger tables for an order by on the related town name, '
      'then both company and town are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: companyTable,
            orderBy: [townName.asc()],
          ),
          {'company', 'town'},
        );
      },
    );

    test(
      'when collecting trigger tables for a town include, '
      'then both company and town are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: companyTable,
            include: _TestIncludeObject(townViaCompany),
          ),
          {'company', 'town'},
        );
      },
    );

    test(
      'when collecting trigger tables with an additional simple data table, '
      'then the extra table is added to the derived set.',
      () {
        expect(
          collectWatchTriggerTables(
            table: companyTable,
            extraTables: [Table<int?>(tableName: 'simple_data')],
          ),
          {'company', 'simple_data'},
        );
      },
    );

    test(
      'when collecting trigger tables for a raw SQL where expression, '
      'then only the queried table is included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: companyTable,
            where: const Expression('town.name = \'Stockholm\''),
          ),
          {'company'},
        );
      },
    );
  });

  group(
    'Given a citizen relation path through company and town back to citizen, ',
    () {
      late Table citizenTable;
      late Table mayorViaCompany;
      late ColumnString mayorName;

      setUp(() {
        citizenTable = Table<int?>(tableName: 'citizen');
        mayorViaCompany = TableRelationBuilder(citizenTable).withRelationsFrom([
          BuilderRelation(citizenTable, 'company'),
          BuilderRelation(Table<int?>(tableName: 'company'), 'town'),
          BuilderRelation(Table<int?>(tableName: 'town'), 'mayor'),
        ]).build();
        mayorName = ColumnString('name', mayorViaCompany);
      });

      test(
        'when collecting trigger tables for a filter on the mayor name, '
        'then citizen and both intermediate tables are included.',
        () {
          expect(
            collectWatchTriggerTables(
              table: citizenTable,
              where: mayorName.equals('Alex'),
            ),
            {'citizen', 'company', 'town'},
          );
        },
      );

      test(
        'when collecting trigger tables for ordering by the mayor name, '
        'then citizen and both intermediate tables are included.',
        () {
          expect(
            collectWatchTriggerTables(
              table: citizenTable,
              orderBy: [mayorName.asc()],
            ),
            {'citizen', 'company', 'town'},
          );
        },
      );

      test(
        'when collecting trigger tables for an include of the mayor, '
        'then citizen and both intermediate tables are included.',
        () {
          expect(
            collectWatchTriggerTables(
              table: citizenTable,
              include: _TestIncludeObject(mayorViaCompany),
            ),
            {'citizen', 'company', 'town'},
          );
        },
      );
    },
  );

  group('Given an organization with a people many relation, ', () {
    late Table organizationTable;
    late Table personTable;
    late Table personViaOrganization;
    late ManyRelation people;

    setUp(() {
      organizationTable = Table<int?>(tableName: 'organization');
      personTable = Table<int?>(tableName: 'person');
      personViaOrganization = TableRelationBuilder(personTable)
          .withRelationsFrom([
            BuilderRelation(organizationTable, 'people'),
          ])
          .build();
      people = ManyRelationBuilder(personViaOrganization).build();
    });

    test(
      'when collecting trigger tables for an any filter on person name, '
      'then both organization and person are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: organizationTable,
            where: people.any((t) => t.id.equals(1)),
          ),
          {'organization', 'person'},
        );
      },
    );

    test(
      'when collecting trigger tables for a none filter on person name, '
      'then both organization and person are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: organizationTable,
            where: people.none((t) => t.id.equals(1)),
          ),
          {'organization', 'person'},
        );
      },
    );

    test(
      'when collecting trigger tables for an every filter on person name, '
      'then both organization and person are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: organizationTable,
            where: people.every((t) => t.id.equals(1)),
          ),
          {'organization', 'person'},
        );
      },
    );

    test(
      'when collecting trigger tables for a count filter on people, '
      'then both organization and person are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: organizationTable,
            where: people.count((t) => t.id.equals(1)) > 0,
          ),
          {'organization', 'person'},
        );
      },
    );

    test(
      'when collecting trigger tables for an include list with a nested where, '
      'then both organization and person are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: organizationTable,
            include: _TestIncludeObject(
              organizationTable,
              {
                'people': _TestIncludeList(
                  table: personViaOrganization,
                  where: ColumnString('name', personTable).equals('Alex'),
                ),
              },
            ),
          ),
          {'organization', 'person'},
        );
      },
    );

    test(
      'when collecting trigger tables for a nested include list order by, '
      'then both organization and person are included.',
      () {
        expect(
          collectWatchTriggerTables(
            table: organizationTable,
            include: _TestIncludeObject(
              organizationTable,
              {
                'people': _TestIncludeList(
                  table: personViaOrganization,
                  orderByList: [ColumnString('name', personTable)],
                ),
              },
            ),
          ),
          {'organization', 'person'},
        );
      },
    );
  });
}

class _TestIncludeObject extends IncludeObject {
  _TestIncludeObject(this.table, [Map<String, Include?>? includes])
    : includes = includes ?? const {};

  @override
  final Table table;

  @override
  final Map<String, Include?> includes;
}

class _TestIncludeList extends IncludeList {
  _TestIncludeList({
    required this.table,
    super.where,
    super.orderByList,
    Map<String, Include?>? includes,
  }) : includes = includes ?? const {};

  @override
  final Table table;

  @override
  final Map<String, Include?> includes;
}
