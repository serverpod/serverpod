import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  late Session session;
  setUpAll(() async {
    session = await IntegrationTestServer().session();
  });
  tearDownAll(() => session.close());

  group('Given a simple data row in the SQLite database, ', () {
    setUp(() async {
      await SimpleData.db.insertRow(session, SimpleData(num: 1));
    });

    tearDown(() async {
      await SimpleData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    group('when watching a select query, ', () {
      late StreamIterator<DatabaseResult> iterator;

      setUp(() {
        iterator = StreamIterator(
          session.db.unsafeWatch('SELECT num FROM simple_data ORDER BY id;'),
        );
      });

      tearDown(() async {
        await iterator.cancel();
      });

      test('then the stream emits the current rows immediately.', () async {
        expect(await iterator.moveNext(), isTrue);
        expect(
          iterator.current.map((row) => row.toColumnMap()).toList(),
          [
            {'num': 1},
          ],
        );
      });
    });
  });

  group('Given simple data rows with nums 1 and 2, ', () {
    late SimpleData rowWithNum1;

    setUp(() async {
      rowWithNum1 = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      await SimpleData.db.insertRow(session, SimpleData(num: 2));
    });

    tearDown(() async {
      await SimpleData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    group(
      'when watching a select query with a filter using named QueryParameters, ',
      () {
        late StreamIterator<DatabaseResult> iterator;

        setUp(() {
          iterator = StreamIterator(
            session.db.unsafeWatch(
              'SELECT num FROM simple_data WHERE num = @num;',
              parameters: QueryParameters.named({'num': rowWithNum1.num}),
            ),
          );
        });

        tearDown(() async {
          await iterator.cancel();
        });

        test('then the stream emits only the matching rows.', () async {
          expect(await iterator.moveNext(), isTrue);
          expect(
            iterator.current.map((row) => row.toColumnMap()).toList(),
            [
              {'num': 1},
            ],
          );
        });
      },
    );

    group('when watching through the generated repository, ', () {
      late StreamIterator<List<SimpleData>> iterator;

      setUp(() {
        iterator = StreamIterator(
          SimpleData.db.watch(
            session,
            where: (t) => t.num.equals(1),
            orderBy: (t) => t.id,
          ),
        );
      });

      tearDown(() async {
        await iterator.cancel();
      });

      test(
        'then the stream emits the matching model rows immediately.',
        () async {
          expect(await iterator.moveNext(), isTrue);
          expect(iterator.current, hasLength(1));
          expect(iterator.current.single.num, 1);
          expect(iterator.current.single.id, rowWithNum1.id);
        },
      );
    });

    group('when watching with a typed where expression, ', () {
      late StreamIterator<List<SimpleData>> iterator;

      setUp(() {
        iterator = StreamIterator(
          session.db.watch<SimpleData>(
            where: SimpleData.t.num.equals(1),
            orderBy: SimpleData.t.id,
          ),
        );
      });

      tearDown(() async {
        await iterator.cancel();
      });

      test(
        'then the stream emits the matching model rows immediately.',
        () async {
          expect(await iterator.moveNext(), isTrue);
          expect(iterator.current, hasLength(1));
          expect(iterator.current.single.num, 1);
          expect(iterator.current.single.id, rowWithNum1.id);
        },
      );
    });
  });

  group('Given an active watch subscription on a simple data row, ', () {
    late StreamIterator<DatabaseResult> iterator;

    setUp(() async {
      await SimpleData.db.insertRow(session, SimpleData(num: 1));

      iterator = StreamIterator(
        session.db.unsafeWatch(
          'SELECT num FROM simple_data ORDER BY id;',
          throttle: const Duration(milliseconds: 10),
        ),
      );
      await iterator.moveNext();
    });

    tearDown(() async {
      await iterator.cancel();
      await SimpleData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    group('when a new row is inserted, ', () {
      setUp(() async {
        await SimpleData.db.insertRow(session, SimpleData(num: 2));
      });

      test('then the stream emits the updated result.', () async {
        expect(
          await iterator.moveNext().timeout(const Duration(seconds: 2)),
          isTrue,
        );
        expect(
          iterator.current.map((row) => row.toColumnMap()).toList(),
          [
            {'num': 1},
            {'num': 2},
          ],
        );
      });
    });
  });

  group(
    'Given an active typed watch subscription for simple data rows with num 1, ',
    () {
      late StreamIterator<List<SimpleData>> iterator;

      setUp(() async {
        await SimpleData.db.insertRow(session, SimpleData(num: 1));

        iterator = StreamIterator(
          session.db.watch<SimpleData>(
            where: SimpleData.t.num.equals(1),
            orderBy: SimpleData.t.id,
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a new row with num 1 is inserted, ', () {
        setUp(() async {
          await SimpleData.db.insertRow(session, SimpleData(num: 1));
        });

        test('then the stream emits the updated model rows.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(iterator.current, hasLength(2));
          expect(iterator.current.map((row) => row.num), [1, 1]);
        });
      });
    },
  );

  group('Given an active typed watch subscription on a simple data row, ', () {
    late SimpleData existingRow;
    late StreamIterator<List<SimpleData>> iterator;

    setUp(() async {
      existingRow = await SimpleData.db.insertRow(session, SimpleData(num: 1));

      iterator = StreamIterator(
        session.db.watch<SimpleData>(
          orderBy: SimpleData.t.id,
          throttle: const Duration(milliseconds: 10),
        ),
      );
      await iterator.moveNext();
    });

    tearDown(() async {
      await iterator.cancel();
      await SimpleData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    group('when that row is deleted, ', () {
      setUp(() async {
        await SimpleData.db.deleteRow(session, existingRow);
      });

      test('then the stream emits the remaining model rows.', () async {
        expect(
          await iterator.moveNext().timeout(const Duration(seconds: 2)),
          isTrue,
        );
        expect(iterator.current, isEmpty);
      });
    });
  });

  group(
    'Given an active typed watch subscription limited to the first simple data row ordered by num, ',
    () {
      late StreamIterator<List<SimpleData>> iterator;

      setUp(() async {
        await SimpleData.db.insertRow(session, SimpleData(num: 1));

        iterator = StreamIterator(
          session.db.watch<SimpleData>(
            orderBy: SimpleData.t.num,
            limit: 1,
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a row with a lower num is inserted, ', () {
        setUp(() async {
          await SimpleData.db.insertRow(session, SimpleData(num: 0));
        });

        test('then the stream emits the new limited result.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(iterator.current, hasLength(1));
          expect(iterator.current.single.num, 0);
        });
      });
    },
  );

  group(
    'Given an active typed watch subscription with an offset on simple data rows with nums 1 and 2, ',
    () {
      late StreamIterator<List<SimpleData>> iterator;

      setUp(() async {
        await SimpleData.db.insertRow(session, SimpleData(num: 1));
        await SimpleData.db.insertRow(session, SimpleData(num: 2));

        iterator = StreamIterator(
          session.db.watch<SimpleData>(
            orderBy: SimpleData.t.num,
            offset: 1,
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a new row is inserted, ', () {
        setUp(() async {
          await SimpleData.db.insertRow(session, SimpleData(num: 3));
        });

        test('then the stream emits the new offset result.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(iterator.current.map((row) => row.num), [2, 3]);
        });
      });
    },
  );

  group(
    'Given an active typed watch subscription on simple data that also triggers on the town table, ',
    () {
      late StreamIterator<List<SimpleData>> iterator;

      setUp(() async {
        await SimpleData.db.insertRow(session, SimpleData(num: 1));

        iterator = StreamIterator(
          session.db.watch<SimpleData>(
            orderBy: SimpleData.t.id,
            throttle: const Duration(milliseconds: 10),
            alsoTriggerOnTables: [Town.t],
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Town.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a town is inserted, ', () {
        setUp(() async {
          await Town.db.insertRow(session, Town(name: 'Uppsala'));
        });

        test(
          'then the stream emits the current simple data rows again.',
          () async {
            expect(
              await iterator.moveNext().timeout(const Duration(seconds: 2)),
              isTrue,
            );
            expect(iterator.current, hasLength(1));
            expect(iterator.current.single.num, 1);
          },
        );
      });
    },
  );

  group(
    'Given an active typed watch subscription on a simple data row, ',
    () {
      late StreamIterator<List<SimpleData>> iterator;
      late List<SimpleData> initialRows;

      setUp(() async {
        iterator = StreamIterator(
          session.db.watch<SimpleData>(
            orderBy: SimpleData.t.id,
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext().timeout(const Duration(seconds: 5));

        // Observe the insert through the active watch so its notification has
        // been consumed before testing an unrelated write.
        await SimpleData.db.insertRow(session, SimpleData(num: 1));
        await iterator.moveNext().timeout(const Duration(seconds: 5));
        initialRows = iterator.current;
      });

      tearDown(() async {
        await iterator.cancel();
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Town.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when an unrelated town is inserted, ', () {
        bool? nextEvent;

        setUp(() async {
          final pendingEvent = iterator.moveNext();
          await Town.db.insertRow(session, Town(name: 'Uppsala'));
          nextEvent = await pendingEvent
              .then<bool?>((value) => value)
              .timeout(
                const Duration(milliseconds: 400),
                onTimeout: () => null,
              );
        });

        test('then the stream does not emit again.', () {
          expect(initialRows.map((row) => row.num), [1]);
          // Both another result (true) and an unexpected stream end (false)
          // fail; only the absence of either event is accepted.
          expect(nextEvent, isNull);
        });
      });
    },
  );

  group('Given a company with a related town, ', () {
    late Company company;

    setUp(() async {
      final town = await Town.db.insertRow(session, Town(name: 'Stockholm'));
      company = await Company.db.insertRow(
        session,
        Company(name: 'Serverpod', townId: town.id!),
      );
    });

    tearDown(() async {
      await Company.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
      await Town.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    group('when watching companies and including the town, ', () {
      late StreamIterator<List<Company>> iterator;

      setUp(() {
        iterator = StreamIterator(
          session.db.watch<Company>(
            where: Company.t.id.equals(company.id!),
            include: Company.include(town: Town.include()),
          ),
        );
      });

      tearDown(() async {
        await iterator.cancel();
      });

      test(
        'then the stream emits the company with the town populated.',
        () async {
          expect(await iterator.moveNext(), isTrue);
          expect(iterator.current, hasLength(1));
          expect(iterator.current.single.name, 'Serverpod');
          expect(iterator.current.single.town?.name, 'Stockholm');
        },
      );
    });
  });

  group(
    'Given an active watch subscription on a company including its town, ',
    () {
      late Town town;
      late StreamIterator<List<Company>> iterator;

      setUp(() async {
        town = await Town.db.insertRow(session, Town(name: 'Stockholm'));
        final company = await Company.db.insertRow(
          session,
          Company(name: 'Serverpod', townId: town.id!),
        );

        iterator = StreamIterator(
          session.db.watch<Company>(
            where: Company.t.id.equals(company.id!),
            include: Company.include(town: Town.include()),
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Company.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Town.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when the town is updated, ', () {
        setUp(() async {
          await Town.db.updateRow(
            session,
            town.copyWith(name: 'Gothenburg'),
          );
        });

        test(
          'then the stream emits the company with the updated town.',
          () async {
            expect(
              await iterator.moveNext().timeout(const Duration(seconds: 2)),
              isTrue,
            );
            expect(iterator.current.single.town?.name, 'Gothenburg');
          },
        );
      });
    },
  );

  group(
    'Given an active watch subscription on companies filtered by town name, ',
    () {
      late Town town;
      late StreamIterator<List<Company>> iterator;

      setUp(() async {
        town = await Town.db.insertRow(session, Town(name: 'Stockholm'));
        await Company.db.insertRow(
          session,
          Company(name: 'Serverpod', townId: town.id!),
        );

        iterator = StreamIterator(
          session.db.watch<Company>(
            where: Company.t.town.name.equals('Stockholm'),
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Company.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Town.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when that town is renamed, ', () {
        setUp(() async {
          await Town.db.updateRow(
            session,
            town.copyWith(name: 'Gothenburg'),
          );
        });

        test('then the stream emits no matching companies.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(iterator.current, isEmpty);
        });
      });
    },
  );

  group(
    'Given an active watch subscription on a company including its town that also triggers on simple data, ',
    () {
      late Town town;
      late StreamIterator<List<Company>> iterator;

      setUp(() async {
        town = await Town.db.insertRow(session, Town(name: 'Stockholm'));
        final company = await Company.db.insertRow(
          session,
          Company(name: 'Serverpod', townId: town.id!),
        );

        iterator = StreamIterator(
          session.db.watch<Company>(
            where: Company.t.id.equals(company.id!),
            include: Company.include(town: Town.include()),
            throttle: const Duration(milliseconds: 10),
            alsoTriggerOnTables: [SimpleData.t],
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Company.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Town.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when the town is updated, ', () {
        setUp(() async {
          await Town.db.updateRow(
            session,
            town.copyWith(name: 'Malmo'),
          );
        });

        test(
          'then the stream emits the company with the updated town.',
          () async {
            expect(
              await iterator.moveNext().timeout(const Duration(seconds: 2)),
              isTrue,
            );
            expect(iterator.current.single.town?.name, 'Malmo');
          },
        );
      });
    },
  );

  group(
    'Given an active watch subscription on companies ordered by town name for towns named Alpha and Zeta, ',
    () {
      late Town alphaTown;
      late StreamIterator<List<Company>> iterator;

      setUp(() async {
        alphaTown = await Town.db.insertRow(session, Town(name: 'Alpha'));
        final zetaTown = await Town.db.insertRow(session, Town(name: 'Zeta'));
        await Company.db.insertRow(
          session,
          Company(name: 'Alpha Co', townId: alphaTown.id!),
        );
        await Company.db.insertRow(
          session,
          Company(name: 'Zeta Co', townId: zetaTown.id!),
        );

        iterator = StreamIterator(
          session.db.watch<Company>(
            orderBy: Company.t.town.name,
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Company.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Town.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when the first town is renamed, ', () {
        setUp(() async {
          await Town.db.updateRow(
            session,
            alphaTown.copyWith(name: 'Zulu'),
          );
        });

        test(
          'then the stream emits the companies in the reverse order.',
          () async {
            expect(
              await iterator.moveNext().timeout(const Duration(seconds: 2)),
              isTrue,
            );
            expect(iterator.current.map((row) => row.name), [
              'Zeta Co',
              'Alpha Co',
            ]);
          },
        );
      });
    },
  );

  group(
    'Given an active watch subscription on an organization with no people including its people, ',
    () {
      late Organization organization;
      late StreamIterator<List<Organization>> iterator;

      setUp(() async {
        organization = await Organization.db.insertRow(
          session,
          Organization(name: 'Serverpod'),
        );

        iterator = StreamIterator(
          session.db.watch<Organization>(
            where: Organization.t.id.equals(organization.id!),
            include: Organization.include(people: Person.includeList()),
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Person.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Organization.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a person is attached, ', () {
        setUp(() async {
          final person = await Person.db.insertRow(
            session,
            Person(name: 'Alex'),
          );
          await Organization.db.attach.people(session, organization, [person]);
        });

        test(
          'then the stream emits the organization with that person.',
          () async {
            expect(
              await iterator.moveNext().timeout(const Duration(seconds: 2)),
              isTrue,
            );
            expect(iterator.current.single.people, hasLength(1));
            expect(iterator.current.single.people?.single.name, 'Alex');
          },
        );
      });
    },
  );

  group(
    'Given an active watch subscription on organizations filtered by any person named Alex, ',
    () {
      late Organization organization;
      late StreamIterator<List<Organization>> iterator;

      setUp(() async {
        organization = await Organization.db.insertRow(
          session,
          Organization(name: 'Serverpod'),
        );

        iterator = StreamIterator(
          session.db.watch<Organization>(
            where: Organization.t.people.any((t) => t.name.equals('Alex')),
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Person.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Organization.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a person named Alex is inserted, ', () {
        setUp(() async {
          await Person.db.insertRow(
            session,
            Person(name: 'Alex', organizationId: organization.id),
          );
        });

        test('then the stream emits the matching organization.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(iterator.current, hasLength(1));
          expect(iterator.current.single.id, organization.id);
        });
      });
    },
  );

  group(
    'Given an active watch subscription on organizations filtered by none named Alex, ',
    () {
      late Organization organization;
      late StreamIterator<List<Organization>> iterator;

      setUp(() async {
        organization = await Organization.db.insertRow(
          session,
          Organization(name: 'Serverpod'),
        );

        iterator = StreamIterator(
          session.db.watch<Organization>(
            where: Organization.t.people.none((t) => t.name.equals('Alex')),
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Person.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Organization.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a person named Alex is inserted, ', () {
        setUp(() async {
          await Person.db.insertRow(
            session,
            Person(name: 'Alex', organizationId: organization.id),
          );
        });

        test('then the stream emits no matching organizations.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(iterator.current, isEmpty);
        });
      });
    },
  );

  group(
    'Given an active watch subscription on an organization including people named Alex, ',
    () {
      late Organization organization;
      late StreamIterator<List<Organization>> iterator;

      setUp(() async {
        organization = await Organization.db.insertRow(
          session,
          Organization(name: 'Serverpod'),
        );

        iterator = StreamIterator(
          session.db.watch<Organization>(
            where: Organization.t.id.equals(organization.id!),
            include: Organization.include(
              people: Person.includeList(
                where: (t) => t.name.equals('Alex'),
              ),
            ),
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Person.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Organization.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
      });

      group('when a person named Alex is attached, ', () {
        setUp(() async {
          final person = await Person.db.insertRow(
            session,
            Person(name: 'Alex'),
          );
          await Organization.db.attach.people(session, organization, [person]);
        });

        test(
          'then the stream emits the organization with that person.',
          () async {
            expect(
              await iterator.moveNext().timeout(const Duration(seconds: 2)),
              isTrue,
            );
            expect(iterator.current.single.people, hasLength(1));
            expect(iterator.current.single.people?.single.name, 'Alex');
          },
        );
      });
    },
  );
}
