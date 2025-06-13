import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given IvfFlatIndexQueryOptions runtime parameters', () {
    test('when setting parameters globally then options are applied globally.',
        () async {
      var options = const IvfFlatIndexQueryOptions(
        probes: 5,
        iterativeScan: IterativeScan.strict,
        maxProbes: 10,
      );

      await session.db.setRuntimeParameters([options]);

      var checkQuery = options.buildCheckValues();
      var result = await session.db.unsafeQuery(checkQuery);

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['ivfflat_probes'], '5');
      expect(row['ivfflat_iterative_scan'], 'strict_order');
      expect(row['ivfflat_max_probes'], '10');
    });

    test(
        'when setting parameters locally in a transaction then options are applied locally.',
        () async {
      var options = const IvfFlatIndexQueryOptions(
        probes: 3,
        iterativeScan: IterativeScan.relaxed,
        maxProbes: 15,
      );

      await session.db.transaction((transaction) async {
        await session.db.setRuntimeParameters(
          [options],
          transaction: transaction,
        );

        var checkQuery = options.buildCheckValues();
        var result = await session.db.unsafeQuery(
          checkQuery,
          transaction: transaction,
        );

        expect(result.length, 1);
        var row = result.first.toColumnMap();
        expect(row['ivfflat_probes'], '3');
        expect(row['ivfflat_iterative_scan'], 'relaxed_order');
        expect(row['ivfflat_max_probes'], '15');
      });
    });

    test(
        'when setting parameters with null values then only later non-null values are set and override earlier ones.',
        () async {
      var allOptions = const IvfFlatIndexQueryOptions(
        probes: 5,
        iterativeScan: IterativeScan.strict,
        maxProbes: 10,
      );
      await session.db.setRuntimeParameters([allOptions]);

      var options = const IvfFlatIndexQueryOptions(
        probes: 7,
        iterativeScan: null,
        maxProbes: null,
      );

      await session.db.setRuntimeParameters([options]);

      var checkQuery = options.buildCheckValues();
      var result = await session.db.unsafeQuery(checkQuery);

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['ivfflat_probes'], '7');
      expect(row['ivfflat_iterative_scan'], 'strict_order');
      expect(row['ivfflat_max_probes'], '10');
    });

    test(
        'when setting parameters in transaction then they do not affect global settings.',
        () async {
      var globalOptions = const IvfFlatIndexQueryOptions(
        probes: 5,
        iterativeScan: IterativeScan.strict,
        maxProbes: 10,
      );
      await session.db.setRuntimeParameters([globalOptions]);

      await session.db.transaction((transaction) async {
        var localOptions = const IvfFlatIndexQueryOptions(
          probes: 10,
          iterativeScan: IterativeScan.relaxed,
          maxProbes: 15,
        );
        await session.db.setRuntimeParameters(
          [localOptions],
          transaction: transaction,
        );

        var checkQuery = localOptions.buildCheckValues();
        var localResult = await session.db.unsafeQuery(
          checkQuery,
          transaction: transaction,
        );
        var localRow = localResult.first.toColumnMap();

        expect(localRow['ivfflat_probes'], '10');
        expect(localRow['ivfflat_iterative_scan'], 'relaxed_order');
        expect(localRow['ivfflat_max_probes'], '15');
      });

      var checkQuery = globalOptions.buildCheckValues();
      var globalResult = await session.db.unsafeQuery(checkQuery);
      var globalRow = globalResult.first.toColumnMap();
      expect(globalRow['ivfflat_probes'], '5');
      expect(globalRow['ivfflat_iterative_scan'], 'strict_order');
      expect(globalRow['ivfflat_max_probes'], '10');
    });
  });
}
