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

  group(
    'Given a citizen watching its company town mayor through a cyclic relation, ',
    () {
      late Town town;
      late Town otherTown;
      late Company company;
      late Citizen citizen;
      late StreamIterator<List<Citizen>> iterator;

      setUp(() async {
        town = await Town.db.insertRow(session, Town(name: 'Stockholm'));
        otherTown = await Town.db.insertRow(session, Town(name: 'Uppsala'));
        company = await Company.db.insertRow(
          session,
          Company(name: 'Serverpod', townId: town.id!),
        );
        citizen = await Citizen.db.insertRow(
          session,
          Citizen(name: 'Alex', companyId: company.id!),
        );
        town = await Town.db.updateRow(
          session,
          town.copyWith(mayorId: citizen.id),
        );
        iterator = StreamIterator(
          Citizen.db.watch(
            session,
            where: (t) => t.company.town.mayor.name.equals('Alex'),
            throttle: null,
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
        await Town.db.updateWhere(
          session,
          columnValues: (t) => [t.mayorId(null)],
          where: (t) => Constant.bool(true),
        );
        await Citizen.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Company.db.deleteWhere(
          session,
          where: (t) => Constant.bool(true),
        );
        await Town.db.deleteWhere(session, where: (t) => Constant.bool(true));
      });

      group('when the town no longer has a mayor, ', () {
        late List<Citizen> rows;

        setUp(() async {
          await Town.db.updateRow(session, town.copyWith(mayorId: null));
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          rows = iterator.current;
        });

        test('then the citizen no longer matches the watched query.', () {
          expect(rows, isEmpty);
        });
      });

      group('when the company moves to a town without a mayor, ', () {
        late List<Citizen> rows;

        setUp(() async {
          await Company.db.updateRow(
            session,
            company.copyWith(townId: otherTown.id),
          );
          await iterator.moveNext().timeout(const Duration(seconds: 5));
          rows = iterator.current;
        });

        test('then the citizen no longer matches the watched query.', () {
          expect(rows, isEmpty);
        });
      });
    },
  );
}
