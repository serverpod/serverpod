import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

class MockTransaction implements Transaction {
  @override
  Future<void> cancel() async {}

  @override
  Future<Savepoint> createSavepoint() {
    throw UnimplementedError();
  }

  @override
  Future<void> setRuntimeParameters(RuntimeParametersListBuilder builder) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> runtimeParameters = {};
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  group('Given a transaction that does not match required database transaction',
      () {
    var invalidTransactionType = MockTransaction();

    test('when calling `find` then an error is thrown', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.find(
            session,
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when calling `findFirstRow` then an error is thrown', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.findFirstRow(
            session,
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });

    test('when calling `findById` then an error is thrown', () async {
      expect(
        session.db.transaction<void>((transaction) async {
          await UniqueData.db.findById(
            session,
            1,
            transaction: invalidTransactionType,
          );
        }),
        throwsArgumentError,
      );
    });
  });

  group('Given finding an object inside a transaction that is committed', () {
    test('when calling `find` with transaction then does find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.find(
          session,
          transaction: transaction,
        );

        expect(data, hasLength(1));
        expect(data[0].number, 111);
        expect(data[0].email, 'test@serverpod.com');
      });
    });

    test(
        'when calling `find` without transaction then does not find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.find(
          session,
        );

        expect(data, hasLength(0));
      });
    });

    test(
        'when calling `findFirstRow` with transaction then does find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.findFirstRow(
          session,
          transaction: transaction,
        );

        expect(data, isNot(equals(null)));
        expect(data?.number, 111);
        expect(data?.email, 'test@serverpod.com');
      });
    });

    test(
        'when calling `findFirstRow` without transaction then does not find the object',
        () async {
      await session.db.transaction((transaction) async {
        await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.findFirstRow(
          session,
        );

        expect(data, equals(null));
      });
    });

    test('when calling `findById` with transaction then does find the object',
        () async {
      await session.db.transaction((transaction) async {
        var insertedData = await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var fetchedData = await UniqueData.db.findById(
          session,
          insertedData.id!,
          transaction: transaction,
        );

        expect(fetchedData, isNot(equals(null)));
        expect(fetchedData?.number, 111);
        expect(fetchedData?.email, 'test@serverpod.com');
      });
    });

    test(
        'when calling `find` without transaction then does not find the object',
        () async {
      await session.db.transaction((transaction) async {
        var insertedData = await UniqueData.db.insertRow(
          session,
          UniqueData(number: 111, email: 'test@serverpod.com'),
          transaction: transaction,
        );

        var data = await UniqueData.db.findById(
          session,
          insertedData.id!,
        );

        expect(data, equals(null));
      });
    });
  });

  test(
      'Given list relation '
      'when creating all objects inside a transaction '
      'then includeList should include the related objects', () async {
    await session.db.transaction((transaction) async {
      var serverpod = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
        transaction: transaction,
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
        transaction: transaction,
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
        transaction: transaction,
      );

      await Organization.db.attach.people(
        session,
        serverpod,
        [person1, person2],
        transaction: transaction,
      );

      var organizations = await Organization.db.findFirstRow(
        session,
        orderBy: (t) => t.id,
        include: Organization.include(
          people: Person.includeList(),
        ),
        transaction: transaction,
      );

      expect(organizations?.people, hasLength(2));
    });
  });

  group('Given deeply nested list relation ', () {
    tearDown(() async {
      await Person.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Organization.db
          .deleteWhere(session, where: (_) => Constant.bool(true));
      await City.db.deleteWhere(session, where: (_) => Constant.bool(true));
    });

    test(
        'when creating all objects inside a transaction '
        'then includeList should include the nested related objects', () async {
      await session.db.transaction((transaction) async {
        var stockholm = await City.db.insertRow(
          session,
          City(name: 'Stockholm'),
          transaction: transaction,
        );
        var gothenburg = await City.db.insertRow(
          session,
          City(name: 'Gothenburg'),
          transaction: transaction,
        );

        var serverpod = await Organization.db.insertRow(
          session,
          Organization(name: 'Serverpod'),
          transaction: transaction,
        );
        var flutter = await Organization.db.insertRow(
          session,
          Organization(name: 'Flutter'),
          transaction: transaction,
        );

        var person1 = await Person.db.insertRow(
          session,
          Person(name: 'John Doe'),
          transaction: transaction,
        );
        var person2 = await Person.db.insertRow(
          session,
          Person(name: 'Jane Doe'),
          transaction: transaction,
        );
        var person3 = await Person.db.insertRow(
          session,
          Person(name: 'Alice'),
          transaction: transaction,
        );
        var person4 = await Person.db.insertRow(
          session,
          Person(name: 'Bob'),
          transaction: transaction,
        );

        await City.db.attach.citizens(
          session,
          stockholm,
          [person1, person2],
          transaction: transaction,
        );
        await City.db.attach.citizens(
          session,
          gothenburg,
          [person3, person4],
          transaction: transaction,
        );

        await City.db.attach.organizations(
          session,
          stockholm,
          [serverpod, flutter],
          transaction: transaction,
        );

        await Organization.db.attach.people(
          session,
          serverpod,
          [person1, person2],
          transaction: transaction,
        );
        await Organization.db.attach.people(
          session,
          flutter,
          [person3, person4],
          transaction: transaction,
        );

        var organization = await Organization.db.findById(
          session,
          serverpod.id!,
          include: Organization.include(
            city: City.include(
              citizens: Person.includeList(),
            ),
          ),
          transaction: transaction,
        );

        expect(organization?.city?.citizens, hasLength(2));

        var citizenIds = organization?.city?.citizens?.map((e) => e.id);
        expect(citizenIds, contains(person1.id));
        expect(citizenIds, contains(person2.id));
      });
    });
  });
}
