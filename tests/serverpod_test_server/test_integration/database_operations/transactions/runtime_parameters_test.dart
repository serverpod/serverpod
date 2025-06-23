import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  test(
      'Given a transaction with HnswIndexQueryOptions parameters '
      'when setting parameters using transaction.setRuntimeParameters '
      'then options are applied locally to the transaction', () async {
    await session.db.transaction((transaction) async {
      await transaction.setRuntimeParameters((params) => [
            params.hnswIndexQuery(
              efSearch: 75,
              iterativeScan: IterativeScan.strict,
              maxScanTuples: 750,
              scanMemMultiplier: 3,
            ),
          ]);

      var checkQuery = HnswIndexQueryOptions().buildCheckValues();
      var result = await session.db.unsafeQuery(
        checkQuery,
        transaction: transaction,
      );

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['hnsw_ef_search'], '75');
      expect(row['hnsw_iterative_scan'], 'strict_order');
      expect(row['hnsw_max_scan_tuples'], '750');
      expect(row['hnsw_scan_mem_multiplier'], '3');
    });
  });

  test(
      'Given a transaction with IvfflatIndexQueryOptions parameters '
      'when setting parameters using transaction.setRuntimeParameters '
      'then options are applied locally to the transaction', () async {
    await session.db.transaction((transaction) async {
      await transaction.setRuntimeParameters((params) => [
            params.ivfflatIndexQuery(
              probes: 8,
              iterativeScan: IterativeScan.relaxed,
              maxProbes: 20,
            ),
          ]);

      var checkQuery = IvfflatIndexQueryOptions().buildCheckValues();
      var result = await session.db.unsafeQuery(
        checkQuery,
        transaction: transaction,
      );

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['ivfflat_probes'], '8');
      expect(row['ivfflat_iterative_scan'], 'relaxed_order');
      expect(row['ivfflat_max_probes'], '20');
    });
  });

  test(
      'Given a transaction with VectorIndexQueryOptions parameters '
      'when setting parameters using transaction.setRuntimeParameters '
      'then options are applied locally to the transaction', () async {
    await session.db.transaction((transaction) async {
      await transaction.setRuntimeParameters((params) => [
            params.vectorIndexQuery(
              enableIndexScan: true,
              enableSeqScan: false,
              minParallelTableScanSize: 2048,
              parallelSetupCost: 3,
              maintenanceWorkMem: 65536 * 4,
              maxParallelMaintenanceWorkers: 8,
              maxParallelWorkersPerGather: 4,
            ),
          ]);

      var checkQuery = VectorIndexQueryOptions().buildCheckValues();
      var result = await session.db.unsafeQuery(
        checkQuery,
        transaction: transaction,
      );

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['enable_indexscan'], 'on');
      expect(row['enable_seqscan'], 'off');
      expect(row['min_parallel_table_scan_size'], '16MB');
      expect(row['parallel_setup_cost'], '3');
      expect(row['maintenance_work_mem'], '256MB');
      expect(row['max_parallel_maintenance_workers'], '8');
      expect(row['max_parallel_workers_per_gather'], '4');
    });
  });

  test(
      'Given a transaction with mixed runtime parameters '
      'when setting multiple different parameter types using transaction.setRuntimeParameters '
      'then all options are applied locally to the transaction', () async {
    await session.db.transaction((transaction) async {
      await transaction.setRuntimeParameters((params) => [
            params.hnswIndexQuery(
              efSearch: 50,
              iterativeScan: IterativeScan.relaxed,
              maxScanTuples: 500,
              scanMemMultiplier: 2,
            ),
            params.ivfflatIndexQuery(
              probes: 6,
              iterativeScan: IterativeScan.relaxed,
              maxProbes: 12,
            ),
            params.vectorIndexQuery(
              enableIndexScan: false,
              enableSeqScan: true,
              minParallelTableScanSize: 1024,
              parallelSetupCost: 2,
              maintenanceWorkMem: 65536 * 3,
              maxParallelMaintenanceWorkers: 6,
              maxParallelWorkersPerGather: 3,
            ),
          ]);

      var hnswCheckQuery = HnswIndexQueryOptions().buildCheckValues();
      var hnswResult = await session.db.unsafeQuery(
        hnswCheckQuery,
        transaction: transaction,
      );
      var hnswRow = hnswResult.first.toColumnMap();
      expect(hnswRow['hnsw_ef_search'], '50');
      expect(hnswRow['hnsw_iterative_scan'], 'relaxed_order');
      expect(hnswRow['hnsw_max_scan_tuples'], '500');
      expect(hnswRow['hnsw_scan_mem_multiplier'], '2');

      var ivfflatCheckQuery = IvfflatIndexQueryOptions().buildCheckValues();
      var ivfflatResult = await session.db.unsafeQuery(
        ivfflatCheckQuery,
        transaction: transaction,
      );
      var ivfflatRow = ivfflatResult.first.toColumnMap();
      expect(ivfflatRow['ivfflat_probes'], '6');
      expect(ivfflatRow['ivfflat_iterative_scan'], 'relaxed_order');
      expect(ivfflatRow['ivfflat_max_probes'], '12');

      var vectorCheckQuery = VectorIndexQueryOptions().buildCheckValues();
      var vectorResult = await session.db.unsafeQuery(
        vectorCheckQuery,
        transaction: transaction,
      );
      var vectorRow = vectorResult.first.toColumnMap();
      expect(vectorRow['enable_indexscan'], 'off');
      expect(vectorRow['enable_seqscan'], 'on');
      expect(vectorRow['min_parallel_table_scan_size'], '8MB');
      expect(vectorRow['parallel_setup_cost'], '2');
      expect(vectorRow['maintenance_work_mem'], '192MB');
      expect(vectorRow['max_parallel_maintenance_workers'], '6');
      expect(vectorRow['max_parallel_workers_per_gather'], '3');
    });
  });

  test(
      'Given a transaction with runtime parameters containing null values '
      'when setting parameters using transaction.setRuntimeParameters '
      'then only non-null values are applied to the transaction', () async {
    await session.db.transaction((transaction) async {
      await transaction.setRuntimeParameters((params) => [
            MapRuntimeParameters({
              'hnsw.ef_search': 80,
              'hnsw.iterative_scan': null,
              'hnsw.scan_mem_multiplier': 4,
            }),
          ]);

      var checkQuery = HnswIndexQueryOptions().buildCheckValues();
      var result = await session.db.unsafeQuery(
        checkQuery,
        transaction: transaction,
      );

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['hnsw_ef_search'], '80');
      expect(row['hnsw_scan_mem_multiplier'], '4');
      // When not yet set, parameters return an empty string
      expect(row['hnsw_iterative_scan'], isEmpty);
    });
  });

  test(
      'Given a transaction with custom runtime parameters supplied to the Serverpod instance '
      'when setting parameters using transaction.setRuntimeParameters '
      'then parameters set to null are cleared', () async {
    var customSession = await IntegrationTestServer(
        runtimeParametersBuilder: (params) => [
              params.hnswIndexQuery(
                iterativeScan: IterativeScan.strict,
              ),
            ]).session();

    var checkQuery = HnswIndexQueryOptions().buildCheckValues();

    await customSession.db.transaction((transaction) async {
      var resultBefore = await customSession.db.unsafeQuery(
        checkQuery,
        transaction: transaction,
      );

      expect(resultBefore.length, 1);
      var rowBefore = resultBefore.first.toColumnMap();
      expect(rowBefore['hnsw_iterative_scan'], 'strict_order');

      await transaction.setRuntimeParameters((params) => [
            MapRuntimeParameters({
              'hnsw.iterative_scan': null,
            }),
          ]);

      var resultInside = await customSession.db.unsafeQuery(
        checkQuery,
        transaction: transaction,
      );

      expect(resultInside.length, 1);
      var rowInside = resultInside.first.toColumnMap();
      expect(rowInside['hnsw_iterative_scan'], isEmpty);
    });

    var resultAfter = await customSession.db.unsafeQuery(checkQuery);

    expect(resultAfter.length, 1);
    var rowAfter = resultAfter.first.toColumnMap();
    expect(rowAfter['hnsw_iterative_scan'], 'strict_order');
  });
}
