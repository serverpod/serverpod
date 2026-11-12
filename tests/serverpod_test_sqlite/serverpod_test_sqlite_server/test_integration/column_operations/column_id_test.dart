import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';

Future<void> _deleteAll(Session session) async {
  await TownInt.db.updateWhere(
    session,
    columnValues: (t) => [t.mayorId(null)],
    where: (_) => Constant.bool(true),
  );
  await CitizenInt.db.deleteWhere(session, where: (_) => Constant.bool(true));
  await CompanyUuid.db.deleteWhere(session, where: (_) => Constant.bool(true));
  await TownInt.db.deleteWhere(session, where: (_) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  late TownInt stockholm;
  late TownInt uppsala;
  late CompanyUuid serverpod;
  late CompanyUuid systemair;
  late CompanyUuid pantor;
  late CitizenInt alex;
  late CitizenInt isak;

  setUpAll(() async {
    stockholm = await TownInt.db.insertRow(session, TownInt(name: 'Stockholm'));
    uppsala = await TownInt.db.insertRow(session, TownInt(name: 'Uppsala'));
    await TownInt.db.insertRow(session, TownInt(name: 'Malmo'));

    serverpod = await CompanyUuid.db.insertRow(
      session,
      CompanyUuid(name: 'Serverpod', townId: stockholm.id!),
    );
    systemair = await CompanyUuid.db.insertRow(
      session,
      CompanyUuid(name: 'Systemair', townId: stockholm.id!),
    );
    pantor = await CompanyUuid.db.insertRow(
      session,
      CompanyUuid(name: 'Pantor', townId: stockholm.id!),
    );

    alex = await CitizenInt.db.insertRow(
      session,
      CitizenInt(name: 'Alex', companyId: serverpod.id!),
    );
    isak = await CitizenInt.db.insertRow(
      session,
      CitizenInt(name: 'Isak', companyId: serverpod.id!),
    );

    await TownInt.db.updateRow(session, stockholm.copyWith(mayorId: alex.id));
    await TownInt.db.updateRow(session, uppsala.copyWith(mayorId: isak.id));
  });

  tearDownAll(() async => await _deleteAll(session));

  group('Given a table with int ids', () {
    test(
      'when filtering the id using inSet with a set literal then matching rows are returned.',
      () async {
        var result = await TownInt.db.find(
          session,
          where: (t) => t.id.inSet({stockholm.id, uppsala.id}),
        );

        expect(
          result.map((town) => town.name),
          unorderedEquals(['Stockholm', 'Uppsala']),
        );
      },
    );

    test(
      'when filtering the id using notInSet with a set literal then the other rows are returned.',
      () async {
        var result = await TownInt.db.find(
          session,
          where: (t) => t.id.notInSet({stockholm.id}),
        );

        expect(
          result.map((town) => town.name),
          unorderedEquals(['Uppsala', 'Malmo']),
        );
      },
    );
  });

  group('Given a table with UuidValue ids', () {
    test(
      'when filtering the id using inSet with a set literal then matching rows are returned.',
      () async {
        var result = await CompanyUuid.db.find(
          session,
          where: (t) => t.id.inSet({serverpod.id, systemair.id}),
        );

        expect(
          result.map((company) => company.name),
          unorderedEquals(['Serverpod', 'Systemair']),
        );
      },
    );

    test(
      'when filtering the id using notInSet with a set literal then the other rows are returned.',
      () async {
        var result = await CompanyUuid.db.find(
          session,
          where: (t) => t.id.notInSet({serverpod.id, pantor.id}),
        );

        expect(result.map((company) => company.name), ['Systemair']);
      },
    );
  });

  group('Given an optional relation that is not set on every row', () {
    test(
      'when filtering the related id using inSet with null then rows without the relation are also returned.',
      () async {
        var result = await TownInt.db.find(
          session,
          where: (t) => t.mayor.id.inSet({alex.id, null}),
        );

        expect(
          result.map((town) => town.name),
          unorderedEquals(['Stockholm', 'Malmo']),
        );
      },
    );

    test(
      'when filtering the related id using notInSet with null then only rows with another related row are returned.',
      () async {
        var result = await TownInt.db.find(
          session,
          where: (t) => t.mayor.id.notInSet({alex.id, null}),
        );

        expect(result.map((town) => town.name), ['Uppsala']);
      },
    );
  });
}
