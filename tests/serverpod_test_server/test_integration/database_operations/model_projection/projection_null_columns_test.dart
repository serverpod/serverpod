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
    await OrderUuid.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await CustomerInt.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  tearDown(() async {
    await OrderUuid.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await CustomerInt.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
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
        var results = await ProjectedOrder.db.findAsJson(
          session,
          select: (t) => [t.summary],
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

        var results = await ProjectedOrder.db.findAsJson(
          session,
          select: (t) => [t.summary],
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

        var result = await ProjectedUser.db.findFirstRowAsJson(
          session,
          include: ProjectedUser.include(
            address: ProjectedAddress.include(
              select: (table) => [table.street],
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

        var result = await Citizen.db.findFirstRowAsJson(
          session,
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

    test(
      'Given citizens in database, when using findAsJson with select, then only selected root columns are returned.',
      () async {
        var town = await Town.db.insertRow(
          session,
          Town(name: 'Tech Town'),
        );
        var company = await Company.db.insertRow(
          session,
          Company(name: 'Serverpod Corp', townId: town.id!),
        );
        var citizen = await Citizen.db.insertRow(
          session,
          Citizen(name: 'Charlie', companyId: company.id!),
        );

        var results = await Citizen.db.findAsJson(
          session,
          select: (t) => [t.name],
        );

        expect(results.length, 1);
        expect(results.first['name'], 'Charlie');
        expect(results.first.containsKey('id'), isFalse);
        expect(results.first.containsKey('companyId'), isFalse);

        var firstRow = await Citizen.db.findFirstRowAsJson(
          session,
          select: (t) => [t.name],
        );
        expect(firstRow?['name'], 'Charlie');
        expect(firstRow?.containsKey('id'), isFalse);

        var byId = await Citizen.db.findByIdAsJson(
          session,
          citizen.id!,
          select: (t) => [t.name],
        );
        expect(byId?['name'], 'Charlie');
        expect(byId?.containsKey('id'), isFalse);
      },
    );

    test(
      'Given related models, when using include with select, then nested relations only return selected columns.',
      () async {
        var town = await Town.db.insertRow(
          session,
          Town(name: 'River Town'),
        );
        var company = await Company.db.insertRow(
          session,
          Company(name: 'Acme Logistics', townId: town.id!),
        );
        await Citizen.db.insertRow(
          session,
          Citizen(name: 'David', companyId: company.id!),
        );

        var result = await Citizen.db.findFirstRowAsJson(
          session,
          select: (t) => [t.name],
          include: Citizen.include(
            company: Company.include(
              select: (c) => [c.name],
            ),
          ),
        );

        expect(result, isNotNull);
        expect(result?['name'], 'David');
        expect(result?.containsKey('id'), isFalse);
        expect(result?['company'], isNotNull);
        expect(result?['company']['name'], 'Acme Logistics');
        expect(result?['company'].containsKey('id'), isFalse);
        expect(result?['company'].containsKey('townId'), isFalse);
      },
    );

    test(
      'Given generated model repository, when using findAsJson with strongly typed select, then only selected columns are returned.',
      () async {
        var customer = await CustomerInt.db.insertRow(
          session,
          CustomerInt(name: 'Alice'),
        );

        var results = await CustomerInt.db.findAsJson(
          session,
          select: (customer) => [customer.name],
        );

        expect(results.length, 1);
        expect(results.first['name'], 'Alice');
        expect(results.first.containsKey('id'), isFalse);

        var firstRow = await CustomerInt.db.findFirstRowAsJson(
          session,
          select: (customer) => [customer.name],
        );
        expect(firstRow?['name'], 'Alice');
        expect(firstRow?.containsKey('id'), isFalse);

        var byId = await CustomerInt.db.findByIdAsJson(
          session,
          customer.id!,
          select: (customer) => [customer.name],
        );
        expect(byId?['name'], 'Alice');
        expect(byId?.containsKey('id'), isFalse);
      },
    );

    test(
      'Given customer with orders, when using findAsJson with includeList and select omitting primary and foreign keys, '
      'then list relation is resolved properly and only selected columns are in returned maps.',
      () async {
        var customer = await CustomerInt.db.insertRow(
          session,
          CustomerInt(name: 'Bob'),
        );

        await OrderUuid.db.insertRow(
          session,
          OrderUuid(
            description: 'First order',
            customerId: customer.id!,
          ),
        );
        await OrderUuid.db.insertRow(
          session,
          OrderUuid(
            description: 'Second order',
            customerId: customer.id!,
          ),
        );

        var results = await CustomerInt.db.findAsJson(
          session,
          select: (customer) => [customer.name],
          orderBy: (t) => t.id,
          include: CustomerInt.include(
            orders: OrderUuid.includeList(
              select: (order) => [order.description],
            ),
          ),
        );

        var sessionResults = await session.db.findAsJson<CustomerInt>(
          select: [CustomerInt.t.name],
          orderBy: CustomerInt.t.id,
          include: CustomerInt.include(
            orders: OrderUuid.includeList(
              select: (order) => [order.description],
            ),
          ),
        );
        expect(sessionResults.length, 1);

        var firstRow = await session.db.findFirstRowAsJson<CustomerInt>(
          select: [CustomerInt.t.name],
          orderBy: CustomerInt.t.id,
          include: CustomerInt.include(
            orders: OrderUuid.includeList(
              select: (order) => [order.description],
            ),
          ),
        );
        expect(firstRow?['name'], 'Bob');

        expect(results.length, 1);
        var row = results.first;
        expect(row['name'], 'Bob');
        expect(row.containsKey('id'), isFalse);

        var orders = row['orders'] as List;
        expect(orders.length, 2);

        for (var order in orders) {
          expect(order, isA<Map<String, dynamic>>());
          expect(order.containsKey('description'), isTrue);
          expect(order.containsKey('id'), isFalse);
          expect(order.containsKey('customer'), isFalse);
        }

        var descriptions = orders.map((o) => o['description']).toList();
        expect(descriptions, containsAll(['First order', 'Second order']));
      },
    );
  });
}
