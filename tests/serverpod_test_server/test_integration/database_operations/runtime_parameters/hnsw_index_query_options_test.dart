import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  group('Given HnswIndexQueryOptions runtime parameters', () {
    test('when setting parameters globally then options are applied globally.',
        () async {
      var session = await IntegrationTestServer(
        runtimeParametersBuilder: (params) => [
          params.hnswIndexQuery(
            efSearch: 100,
            iterativeScan: IterativeScan.strict,
            maxScanTuples: 1000,
            scanMemMultiplier: 2,
          ),
        ],
      ).session();

      var checkQuery = HnswIndexQueryOptions().buildCheckValues();
      var result = await session.db.unsafeQuery(checkQuery);

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['hnsw_ef_search'], '100');
      expect(row['hnsw_iterative_scan'], 'strict_order');
      expect(row['hnsw_max_scan_tuples'], '1000');
      expect(row['hnsw_scan_mem_multiplier'], '2');
    });

    test(
        'when setting parameters in transaction then they do not affect global settings.',
        () async {
      var checkQuery = HnswIndexQueryOptions().buildCheckValues();

      var session = await IntegrationTestServer(
        runtimeParametersBuilder: (params) => [
          params.hnswIndexQuery(
            efSearch: 100,
            iterativeScan: IterativeScan.strict,
            maxScanTuples: 1000,
            scanMemMultiplier: 2,
          ),
        ],
      ).session();

      await session.db.transaction((transaction) async {
        await transaction.setRuntimeParameters(
          (params) => [
            params.hnswIndexQuery(
              efSearch: 200,
              iterativeScan: IterativeScan.relaxed,
              maxScanTuples: 500,
              scanMemMultiplier: 1,
            ),
          ],
        );

        var localResult = await session.db.unsafeQuery(
          checkQuery,
          transaction: transaction,
        );
        var localRow = localResult.first.toColumnMap();

        expect(localRow['hnsw_ef_search'], '200');
        expect(localRow['hnsw_iterative_scan'], 'relaxed_order');
        expect(localRow['hnsw_max_scan_tuples'], '500');
        expect(localRow['hnsw_scan_mem_multiplier'], '1');
      });

      var globalResult = await session.db.unsafeQuery(checkQuery);
      var globalRow = globalResult.first.toColumnMap();
      expect(globalRow['hnsw_ef_search'], '100');
      expect(globalRow['hnsw_iterative_scan'], 'strict_order');
      expect(globalRow['hnsw_max_scan_tuples'], '1000');
      expect(globalRow['hnsw_scan_mem_multiplier'], '2');
    });
  });
}
