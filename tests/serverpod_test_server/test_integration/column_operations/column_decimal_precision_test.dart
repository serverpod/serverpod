import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _deleteAll(Session session) async {
  await ObjectWithDecimalPrecision.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given Decimal(10,2) column in database', () {
    setUp(() async => await _deleteAll(session));
    tearDown(() async => await _deleteAll(session));

    test(
      'when inserting and retrieving a value then precision is preserved.',
      () async {
        var inserted = await ObjectWithDecimalPrecision.db.insertRow(
          session,
          ObjectWithDecimalPrecision(
            price: Decimal.parse('123.45'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
        );

        var result = await ObjectWithDecimalPrecision.db.findById(
          session,
          inserted.id!,
        );

        expect(result, isNotNull);
        expect(result!.price, Decimal.parse('123.45'));
      },
    );

    test(
      'when filtering using equals then matching row is returned.',
      () async {
        await ObjectWithDecimalPrecision.db.insert(session, [
          ObjectWithDecimalPrecision(
            price: Decimal.parse('100.00'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
          ObjectWithDecimalPrecision(
            price: Decimal.parse('200.00'),
            quantity: Decimal.parse('2.0000'),
            unbounded: Decimal.parse('2'),
          ),
        ]);

        var result = await ObjectWithDecimalPrecision.db.find(
          session,
          where: (t) => t.price.equals(Decimal.parse('100.00')),
        );

        expect(result.length, 1);
        expect(result.first.price, Decimal.parse('100.00'));
      },
    );

    test(
      'when filtering using greater than then matching rows are returned.',
      () async {
        await ObjectWithDecimalPrecision.db.insert(session, [
          ObjectWithDecimalPrecision(
            price: Decimal.parse('50.00'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
          ObjectWithDecimalPrecision(
            price: Decimal.parse('150.00'),
            quantity: Decimal.parse('2.0000'),
            unbounded: Decimal.parse('2'),
          ),
          ObjectWithDecimalPrecision(
            price: Decimal.parse('250.00'),
            quantity: Decimal.parse('3.0000'),
            unbounded: Decimal.parse('3'),
          ),
        ]);

        var result = await ObjectWithDecimalPrecision.db.find(
          session,
          where: (t) => t.price > Decimal.parse('100.00'),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using less than then matching rows are returned.',
      () async {
        await ObjectWithDecimalPrecision.db.insert(session, [
          ObjectWithDecimalPrecision(
            price: Decimal.parse('50.00'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
          ObjectWithDecimalPrecision(
            price: Decimal.parse('150.00'),
            quantity: Decimal.parse('2.0000'),
            unbounded: Decimal.parse('2'),
          ),
          ObjectWithDecimalPrecision(
            price: Decimal.parse('250.00'),
            quantity: Decimal.parse('3.0000'),
            unbounded: Decimal.parse('3'),
          ),
        ]);

        var result = await ObjectWithDecimalPrecision.db.find(
          session,
          where: (t) => t.price < Decimal.parse('200.00'),
        );

        expect(result.length, 2);
      },
    );

    test(
      'when filtering using between then matching rows are returned.',
      () async {
        await ObjectWithDecimalPrecision.db.insert(session, [
          ObjectWithDecimalPrecision(
            price: Decimal.parse('50.00'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
          ObjectWithDecimalPrecision(
            price: Decimal.parse('150.00'),
            quantity: Decimal.parse('2.0000'),
            unbounded: Decimal.parse('2'),
          ),
          ObjectWithDecimalPrecision(
            price: Decimal.parse('250.00'),
            quantity: Decimal.parse('3.0000'),
            unbounded: Decimal.parse('3'),
          ),
        ]);

        var result = await ObjectWithDecimalPrecision.db.find(
          session,
          where: (t) => t.price.between(
            Decimal.parse('100.00'),
            Decimal.parse('200.00'),
          ),
        );

        expect(result.length, 1);
        expect(result.first.price, Decimal.parse('150.00'));
      },
    );

    test(
      'when inserting a value that exceeds scale then PostgreSQL rounds it.',
      () async {
        var inserted = await ObjectWithDecimalPrecision.db.insertRow(
          session,
          ObjectWithDecimalPrecision(
            price: Decimal.parse('123.456'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
        );

        var result = await ObjectWithDecimalPrecision.db.findById(
          session,
          inserted.id!,
        );

        expect(result, isNotNull);
        expect(result!.price, Decimal.parse('123.46'));
      },
    );

    test(
      'when inserting NULL into nullable column then NULL is preserved.',
      () async {
        var inserted = await ObjectWithDecimalPrecision.db.insertRow(
          session,
          ObjectWithDecimalPrecision(
            price: Decimal.parse('10.00'),
            priceNullable: null,
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
        );

        var result = await ObjectWithDecimalPrecision.db.findById(
          session,
          inserted.id!,
        );

        expect(result, isNotNull);
        expect(result!.priceNullable, isNull);
      },
    );

    test(
      'when inserting max precision value then value is preserved.',
      () async {
        var inserted = await ObjectWithDecimalPrecision.db.insertRow(
          session,
          ObjectWithDecimalPrecision(
            price: Decimal.parse('99999999.99'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('1'),
          ),
        );

        var result = await ObjectWithDecimalPrecision.db.findById(
          session,
          inserted.id!,
        );

        expect(result, isNotNull);
        expect(result!.price, Decimal.parse('99999999.99'));
      },
    );
  });

  group('Given Decimal(19,4) column in database', () {
    setUp(() async => await _deleteAll(session));
    tearDown(() async => await _deleteAll(session));

    test(
      'when inserting and retrieving a value then precision is preserved.',
      () async {
        var inserted = await ObjectWithDecimalPrecision.db.insertRow(
          session,
          ObjectWithDecimalPrecision(
            price: Decimal.parse('1.00'),
            quantity: Decimal.parse('123456789012345.6789'),
            unbounded: Decimal.parse('1'),
          ),
        );

        var result = await ObjectWithDecimalPrecision.db.findById(
          session,
          inserted.id!,
        );

        expect(result, isNotNull);
        expect(result!.quantity, Decimal.parse('123456789012345.6789'));
      },
    );
  });

  group('Given unbounded Decimal column in database', () {
    setUp(() async => await _deleteAll(session));
    tearDown(() async => await _deleteAll(session));

    test(
      'when inserting and retrieving a value then precision is preserved.',
      () async {
        var inserted = await ObjectWithDecimalPrecision.db.insertRow(
          session,
          ObjectWithDecimalPrecision(
            price: Decimal.parse('1.00'),
            quantity: Decimal.parse('1.0000'),
            unbounded: Decimal.parse('123456789.123456789012345'),
          ),
        );

        var result = await ObjectWithDecimalPrecision.db.findById(
          session,
          inserted.id!,
        );

        expect(result, isNotNull);
        expect(
          result!.unbounded,
          Decimal.parse('123456789.123456789012345'),
        );
      },
    );
  });
}
