import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  final session = await IntegrationTestServer().session();

  group('Given a committed simple data row with num 1, ', () {
    late SimpleData row;

    setUp(() async {
      row = await SimpleData.db.insertRow(session, SimpleData(num: 1));
    });

    tearDown(() async {
      await SimpleData.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    group(
      'when subscribing to a raw watch inside a transaction that commits num 2, ',
      () {
        late List<int> observedNums;

        setUp(() async {
          observedNums = [];
          final stream = session.db.unsafeWatch(
            'SELECT num FROM simple_data;',
            throttle: null,
          );
          late StreamIterator<int> iterator;
          await session.db.transaction((transaction) async {
            await SimpleData.db.updateRow(
              session,
              row.copyWith(num: 2),
              transaction: transaction,
            );
            iterator = StreamIterator(
              stream.map((result) => result.single[0] as int).distinct(),
            );
            addTearDown(iterator.cancel);
            await iterator.moveNext().timeout(const Duration(seconds: 5));
            observedNums.add(iterator.current);
          });
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          observedNums.add(iterator.current);

          await SimpleData.db.updateRow(session, row.copyWith(num: 3));
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          observedNums.add(iterator.current);
        });

        test(
          'then it observes only committed values and continues after commit.',
          () {
            expect(observedNums, [1, 2, 3]);
          },
        );
      },
    );

    group(
      'when subscribing to a typed watch inside a transaction that rolls back num 2, ',
      () {
        late List<int> observedNums;

        setUp(() async {
          observedNums = [];
          late StreamIterator<int> iterator;
          await session.db.transaction((transaction) async {
            await SimpleData.db.updateRow(
              session,
              row.copyWith(num: 2),
              transaction: transaction,
            );
            iterator = StreamIterator(
              SimpleData.db
                  .watch(session, throttle: null)
                  .map((rows) => rows.single.num)
                  .distinct(),
            );
            addTearDown(iterator.cancel);
            await iterator.moveNext().timeout(const Duration(seconds: 5));
            observedNums.add(iterator.current);
            await transaction.cancel();
          });

          await SimpleData.db.updateRow(session, row.copyWith(num: 3));
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          observedNums.add(iterator.current);
        });

        test(
          'then it excludes the rolled-back value and continues after rollback.',
          () {
            expect(observedNums, [1, 3]);
          },
        );
      },
    );

    group(
      'when creating a typed watch inside a transaction and subscribing after commit, ',
      () {
        late List<int> observedNums;

        setUp(() async {
          observedNums = [];
          late Stream<List<SimpleData>> stream;
          await session.db.transaction((transaction) async {
            stream = SimpleData.db.watch(session, throttle: null);
            await SimpleData.db.updateRow(
              session,
              row.copyWith(num: 2),
              transaction: transaction,
            );
          });
          final iterator = StreamIterator(
            stream.map((rows) => rows.single.num).distinct(),
          );
          addTearDown(iterator.cancel);
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          observedNums.add(iterator.current);

          await SimpleData.db.updateRow(session, row.copyWith(num: 3));
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          observedNums.add(iterator.current);
        });

        test('then it emits committed rows and observes later writes.', () {
          expect(observedNums, [2, 3]);
        });
      },
    );
  });

  group('Given a committed organization with no people, ', () {
    late Organization organization;

    setUp(() async {
      organization = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
      );
    });

    tearDown(() async {
      await Person.db.deleteWhere(session, where: (t) => Constant.bool(true));
      await Organization.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
    });

    group(
      'when subscribing to an included-list watch inside a transaction adding a person, ',
      () {
        late List<List<String>> observedPeople;

        setUp(() async {
          observedPeople = [];
          late StreamIterator<List<Organization>> iterator;
          late Person person;
          await session.db.transaction((transaction) async {
            person = await Person.db.insertRow(
              session,
              Person(name: 'Alex', organizationId: organization.id),
              transaction: transaction,
            );
            iterator = StreamIterator(
              Organization.db.watch(
                session,
                include: Organization.include(people: Person.includeList()),
                throttle: null,
              ),
            );
            addTearDown(iterator.cancel);
            await iterator.moveNext().timeout(const Duration(seconds: 5));
            observedPeople.add(
              iterator.current.single.people!.map((p) => p.name).toList(),
            );
          });
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          observedPeople.add(
            iterator.current.single.people!.map((p) => p.name).toList(),
          );

          await Person.db.updateRow(session, person.copyWith(name: 'Sam'));
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          observedPeople.add(
            iterator.current.single.people!.map((p) => p.name).toList(),
          );
        });

        test(
          'then included rows stay committed and keep refreshing after commit.',
          () {
            expect(observedPeople, [
              <String>[],
              ['Alex'],
              ['Sam'],
            ]);
          },
        );
      },
    );
  });
}
