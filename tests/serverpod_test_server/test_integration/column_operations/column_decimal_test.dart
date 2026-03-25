import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _deleteAll(Session session) async {
  await ObjectWithDecimal.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  late ObjectWithDecimal highPrecisionRow;
  late ObjectWithDecimal nullableRow;
  late ObjectWithDecimal zeroRow;
  late ObjectWithDecimal negativeRow;
  late ObjectWithDecimal overflowRow;

  var highPrecision = Decimal.parse('123456789.123456789012345678');
  var overflow = Decimal.parse('1${List.filled(309, '0').join()}');

  setUpAll(() async {
    highPrecisionRow = await ObjectWithDecimal.db.insertRow(
      session,
      ObjectWithDecimal(
        notNullableDecimal: highPrecision,
        nullableDecimal: Decimal.parse('1.5'),
        highPrecisionDecimal: highPrecision,
      ),
    );

    nullableRow = await ObjectWithDecimal.db.insertRow(
      session,
      ObjectWithDecimal(
        notNullableDecimal: Decimal.parse('10'),
        nullableDecimal: null,
        highPrecisionDecimal: Decimal.parse('10'),
      ),
    );

    zeroRow = await ObjectWithDecimal.db.insertRow(
      session,
      ObjectWithDecimal(
        notNullableDecimal: Decimal.zero,
        nullableDecimal: Decimal.zero,
        highPrecisionDecimal: Decimal.zero,
      ),
    );

    negativeRow = await ObjectWithDecimal.db.insertRow(
      session,
      ObjectWithDecimal(
        notNullableDecimal: Decimal.parse('-42.7501'),
        nullableDecimal: Decimal.parse('-1'),
        highPrecisionDecimal: Decimal.parse('-42.7501'),
      ),
    );

    overflowRow = await ObjectWithDecimal.db.insertRow(
      session,
      ObjectWithDecimal(
        notNullableDecimal: overflow,
        nullableDecimal: overflow,
        highPrecisionDecimal: overflow,
      ),
    );
  });

  tearDownAll(() async {
    await _deleteAll(session);
  });

  group('Given decimal columns in database', () {
    test(
      'when reading back a high precision value then precision is preserved exactly.',
      () async {
        var result = await ObjectWithDecimal.db.findById(
          session,
          highPrecisionRow.id!,
        );

        expect(result, isNotNull);
        expect(result!.notNullableDecimal, highPrecision);
        expect(result.highPrecisionDecimal, highPrecision);
      },
    );

    test(
      'when reading back a nullable decimal value set to null then null is preserved.',
      () async {
        var result = await ObjectWithDecimal.db.findById(
          session,
          nullableRow.id!,
        );

        expect(result, isNotNull);
        expect(result!.nullableDecimal, isNull);
      },
    );

    test(
      'when reading back a zero decimal value then zero is preserved.',
      () async {
        var result = await ObjectWithDecimal.db.findById(session, zeroRow.id!);

        expect(result, isNotNull);
        expect(result!.notNullableDecimal, Decimal.zero);
      },
    );

    test(
      'when reading back a negative decimal value then sign and precision are preserved.',
      () async {
        var result = await ObjectWithDecimal.db.findById(
          session,
          negativeRow.id!,
        );

        expect(result, isNotNull);
        expect(result!.notNullableDecimal, Decimal.parse('-42.7501'));
      },
    );

    test(
      'when reading back a decimal value beyond double range then value is preserved.',
      () async {
        var result = await ObjectWithDecimal.db.findById(
          session,
          overflowRow.id!,
        );

        expect(result, isNotNull);
        expect(result!.notNullableDecimal, overflow);
      },
    );

    test(
      'when filtering using greater than then matching decimal rows are returned.',
      () async {
        var result = await ObjectWithDecimal.db.find(
          session,
          where: (t) => t.notNullableDecimal > Decimal.parse('100'),
        );

        expect(result.map((row) => row.id), contains(highPrecisionRow.id));
        expect(result.map((row) => row.id), contains(overflowRow.id));
      },
    );
  });
}
