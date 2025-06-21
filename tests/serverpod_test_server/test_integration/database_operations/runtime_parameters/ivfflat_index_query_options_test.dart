import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  group('Given IvfflatIndexQueryOptions runtime parameters', () {
    test('when setting parameters globally then options are applied globally.',
        () async {
      var session = await IntegrationTestServer(
        runtimeParametersBuilder: (params) => [
          params.ivfflatIndexQuery(
            probes: 5,
            iterativeScan: IterativeScan.relaxed,
            maxProbes: 10,
          ),
        ],
      ).session();

      var checkQuery = IvfflatIndexQueryOptions().buildCheckValues();
      var result = await session.db.unsafeQuery(checkQuery);

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['ivfflat_probes'], '5');
      expect(row['ivfflat_iterative_scan'], 'relaxed_order');
      expect(row['ivfflat_max_probes'], '10');
    });

    test(
        'when setting parameters in transaction then they do not affect global settings.',
        () async {
      var checkQuery = IvfflatIndexQueryOptions().buildCheckValues();

      var session = await IntegrationTestServer(
        runtimeParametersBuilder: (params) => [
          params.ivfflatIndexQuery(
            probes: 5,
            iterativeScan: IterativeScan.relaxed,
            maxProbes: 10,
          ),
        ],
      ).session();

      await session.db.transaction((transaction) async {
        await transaction.setRuntimeParameters(
          (params) => [
            params.ivfflatIndexQuery(
              probes: 10,
              iterativeScan: IterativeScan.off,
              maxProbes: 15,
            ),
          ],
        );

        var localResult = await session.db.unsafeQuery(
          checkQuery,
          transaction: transaction,
        );
        var localRow = localResult.first.toColumnMap();

        expect(localRow['ivfflat_probes'], '10');
        expect(localRow['ivfflat_iterative_scan'], 'off');
        expect(localRow['ivfflat_max_probes'], '15');
      });

      var globalResult = await session.db.unsafeQuery(checkQuery);
      var globalRow = globalResult.first.toColumnMap();
      expect(globalRow['ivfflat_probes'], '5');
      expect(globalRow['ivfflat_iterative_scan'], 'relaxed_order');
      expect(globalRow['ivfflat_max_probes'], '10');
    });
  });
}
