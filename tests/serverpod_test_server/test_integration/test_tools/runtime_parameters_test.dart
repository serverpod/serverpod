import 'package:serverpod/database.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given withServerpod with runtime parameters set globally'
    'when querying runtime parameters globally',
    runtimeParametersBuilder: (params) => [
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
        minParallelTableScanSize: 2048,
        parallelSetupCost: 2,
        maintenanceWorkMem: 65536 * 3,
        maxParallelMaintenanceWorkers: 6,
        maxParallelWorkersPerGather: 3,
      ),
    ],
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test('then all parameters are applied correctly', () async {
        var hnswCheckQuery = HnswIndexQueryOptions().buildCheckValues();
        var hnswResult = await session.db.unsafeQuery(hnswCheckQuery);
        var hnswRow = hnswResult.first.toColumnMap();
        expect(hnswRow['hnsw_ef_search'], '50');
        expect(hnswRow['hnsw_iterative_scan'], 'relaxed_order');
        expect(hnswRow['hnsw_max_scan_tuples'], '500');
        expect(hnswRow['hnsw_scan_mem_multiplier'], '2');

        var ivfflatCheckQuery = IvfflatIndexQueryOptions().buildCheckValues();
        var ivfflatResult = await session.db.unsafeQuery(ivfflatCheckQuery);
        var ivfflatRow = ivfflatResult.first.toColumnMap();
        expect(ivfflatRow['ivfflat_probes'], '6');
        expect(ivfflatRow['ivfflat_iterative_scan'], 'relaxed_order');
        expect(ivfflatRow['ivfflat_max_probes'], '12');

        var vectorCheckQuery = VectorIndexQueryOptions().buildCheckValues();
        var vectorResult = await session.db.unsafeQuery(vectorCheckQuery);
        var vectorRow = vectorResult.first.toColumnMap();
        expect(vectorRow['enable_indexscan'], 'off');
        expect(vectorRow['enable_seqscan'], 'on');
        expect(vectorRow['min_parallel_table_scan_size'], '16MB');
        expect(vectorRow['parallel_setup_cost'], '2');
        expect(vectorRow['maintenance_work_mem'], '192MB');
        expect(vectorRow['max_parallel_maintenance_workers'], '6');
        expect(vectorRow['max_parallel_workers_per_gather'], '3');
      });
    },
  );

  withServerpod(
    'Given withServerpod with runtime parameters set globally'
    'when setting local parameters in transaction',
    runtimeParametersBuilder: (params) => [
      params.hnswIndexQuery(
        efSearch: 50,
        iterativeScan: IterativeScan.relaxed,
        maxScanTuples: 500,
        scanMemMultiplier: 2,
      ),
    ],
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test('then local parameters override global ones temporarily', () async {
        var checkQuery = HnswIndexQueryOptions().buildCheckValues();

        await session.db.transaction((transaction) async {
          // The savepoint is needed to avoid altering global parameters, since
          // the test framework runs all tests in a single transaction.
          final savePoint = await transaction.createSavepoint();

          await transaction.setRuntimeParameters((params) => [
                params.hnswIndexQuery(
                  efSearch: 100,
                  iterativeScan: IterativeScan.strict,
                  maxScanTuples: 1000,
                  scanMemMultiplier: 3,
                ),
              ]);

          var localResult = await session.db.unsafeQuery(
            checkQuery,
            transaction: transaction,
          );

          expect(localResult.length, 1);
          var localRow = localResult.first.toColumnMap();
          expect(localRow['hnsw_ef_search'], '100');
          expect(localRow['hnsw_iterative_scan'], 'strict_order');
          expect(localRow['hnsw_max_scan_tuples'], '1000');
          expect(localRow['hnsw_scan_mem_multiplier'], '3');

          await savePoint.rollback();
        });

        var globalResult = await session.db.unsafeQuery(checkQuery);

        expect(globalResult.length, 1);
        var globalRow = globalResult.first.toColumnMap();
        expect(globalRow['hnsw_ef_search'], '50');
        expect(globalRow['hnsw_iterative_scan'], 'relaxed_order');
        expect(globalRow['hnsw_max_scan_tuples'], '500');
        expect(globalRow['hnsw_scan_mem_multiplier'], '2');
      });
    },
  );

  withServerpod(
    'Given withServerpod without runtimeParametersBuilder',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test(
          'when querying runtime parameters globally '
          'then no database parameters are set', () async {
        var hnswCheckQuery = HnswIndexQueryOptions().buildCheckValues();
        var hnswResult = await session.db.unsafeQuery(hnswCheckQuery);
        var hnswRow = hnswResult.first.toColumnMap();

        var ivfflatCheckQuery = IvfflatIndexQueryOptions().buildCheckValues();
        var ivfflatResult = await session.db.unsafeQuery(ivfflatCheckQuery);
        var ivfflatRow = ivfflatResult.first.toColumnMap();

        // Checking VectorIndexQueryOptions is skipped because all of these
        // options are standard PostgreSQL configuration settings and have
        // default values set by the database.
        var allParameters = {...hnswRow, ...ivfflatRow};

        for (var parameter in [
          ...HnswIndexQueryOptions().options.keys,
          ...IvfflatIndexQueryOptions().options.keys,
        ]) {
          var paramName = parameter.replaceAll('.', '_');
          expect(allParameters[paramName], anyOf(isNull, isEmpty));
        }
      });
    },
  );
}
