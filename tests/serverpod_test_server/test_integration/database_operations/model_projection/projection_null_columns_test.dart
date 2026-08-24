// ignore_for_file: invalid_use_of_internal_member

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  setUp(() async {
    await Citizen.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await Company.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await Town.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedOrder.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedUser.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedAddress.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  tearDown(() async {
    await Citizen.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await Company.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await Town.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedOrder.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedUser.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedAddress.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  group('Null-column selection behavior in findAsJson', () {
    test(
      'Given two rows where one row has all selected fields as null, '
      'when calling findAsJson selecting only that nullable column, '
      'then both rows should be returned (the null row should not disappear).',
      () async {
        // Insert 2 orders:
        // Order 1 has summary = 'Has summary'
        // Order 2 has summary = null
        await ProjectedOrder.db.insert(session, [
          ProjectedOrder(
            description: 'Order 1',
            summary: 'Has summary',
            price: 10.0,
          ),
          ProjectedOrder(
            description: 'Order 2',
            summary: null,
            price: 20.0,
          ),
        ]);

        // Select ONLY the nullable column `summary` (without selecting `id`)
        var results = await session.db.findAsJson<ProjectedOrder>(
          include: ProjectedOrderInclude.internal_(
            selectedColumns: [ProjectedOrder.t.summary],
          ),
        );

        // There are 2 records in the database.
        // Both rows must be returned in the list.
        expect(
          results.length,
          2,
          reason:
              'Expected 2 rows to be returned, but rows where all selected '
              'columns evaluate to null are currently dropped by query_result_parser.',
        );
      },
    );

    test(
      'Given multiple rows where ALL rows have null for the selected column, '
      'when calling findAsJson, '
      'then all rows are returned as empty maps.',
      () async {
        await ProjectedOrder.db.insert(session, [
          ProjectedOrder(
            description: 'Order A',
            summary: null,
            price: 15.0,
          ),
          ProjectedOrder(
            description: 'Order B',
            summary: null,
            price: 30.0,
          ),
        ]);

        var results = await session.db.findAsJson<ProjectedOrder>(
          include: ProjectedOrderInclude.internal_(
            selectedColumns: [ProjectedOrder.t.summary],
          ),
        );

        expect(results.length, 2);
        expect(results[0], isEmpty);
        expect(results[1], isEmpty);
      },
    );

    test(
      'Given a user with an address, when querying with address included and selecting address street, '
      'then address should be properly populated.',
      () async {
        var address = await ProjectedAddress.db.insertRow(
          session,
          ProjectedAddress(
            street: 'Main Street',
            state: 'California',
            country: 'USA',
          ),
        );

        await ProjectedUser.db.insertRow(
          session,
          ProjectedUser(name: 'Alice', addressId: address.id!),
        );

        var result = await session.db.findFirstRowAsJson<ProjectedUser>(
          include: ProjectedUserInclude.internal_(
            address: ProjectedAddressInclude.internal_(
              selectedColumns: [ProjectedAddress.t.street],
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result?['name'], 'Alice');
        expect(result?['address'], isNotNull);
        expect(result?['address']['street'], 'Main Street');
      },
    );

    test(
      'Given a citizen without an optional oldCompany, '
      'when querying citizen with oldCompany included, '
      'then oldCompany should be null (and not an empty map).',
      () async {
        var town = await Town.db.insertRow(
          session,
          Town(name: 'Tech Town'),
        );

        var company = await Company.db.insertRow(
          session,
          Company(name: 'Current Tech Inc', townId: town.id!),
        );

        await Citizen.db.insertRow(
          session,
          Citizen(
            name: 'Bob',
            companyId: company.id!,
            oldCompanyId: null, // No old company!
          ),
        );

        var result = await session.db.findFirstRowAsJson<Citizen>(
          include: Citizen.include(
            oldCompany: Company.include(),
            company: Company.include(),
          ),
        );

        expect(result, isNotNull);
        expect(result?['name'], 'Bob');
        expect(result?['company'], isNotNull);
        expect(result?['oldCompany'], isNull);
      },
    );
  });
}
