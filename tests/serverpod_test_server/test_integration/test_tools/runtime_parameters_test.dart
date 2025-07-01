import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given withServerpod without runtimeParametersBuilder',
    (sessionBuilder, endpoints) {
      var session = sessionBuilder.build();

      test(
          'when querying runtime parameters globally '
          'then no database parameters are set.', () async {
        // Forces the pgvector extension to load. After the extension is loaded,
        // parameters default will return a value instead of null. Without this
        // query, the order of the tests can cause a null value to be returned.
        await session.db.ensureVectorLoaded();

        var hnswCheckQuery = HnswIndexQueryOptions().buildCheckValues();
        var hnswResult = await session.db.unsafeQuery(hnswCheckQuery);
        var hnswRow = hnswResult.first.toColumnMap();
        expect(hnswRow['hnsw_ef_search'], '40');
        expect(hnswRow['hnsw_iterative_scan'], 'off');
        expect(hnswRow['hnsw_max_scan_tuples'], '20000');
        expect(hnswRow['hnsw_scan_mem_multiplier'], '1');

        var ivfflatCheckQuery = IvfflatIndexQueryOptions().buildCheckValues();
        var ivfflatResult = await session.db.unsafeQuery(ivfflatCheckQuery);
        var ivfflatRow = ivfflatResult.first.toColumnMap();
        expect(ivfflatRow['ivfflat_probes'], '1');
        expect(ivfflatRow['ivfflat_iterative_scan'], 'off');
        expect(ivfflatRow['ivfflat_max_probes'], '32768');

        var vectorCheckQuery = VectorIndexQueryOptions().buildCheckValues();
        var vectorResult = await session.db.unsafeQuery(vectorCheckQuery);
        var vectorRow = vectorResult.first.toColumnMap();
        expect(vectorRow['enable_indexscan'], 'on');
        expect(vectorRow['enable_seqscan'], 'on');
        expect(vectorRow['min_parallel_table_scan_size'], '8MB');
        expect(vectorRow['parallel_setup_cost'], '1000');
        expect(vectorRow['maintenance_work_mem'], '64MB');
        expect(vectorRow['max_parallel_maintenance_workers'], '2');
        expect(vectorRow['max_parallel_workers_per_gather'], '2');
      });
    },
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
  );

  withServerpod(
    'Given withServerpod with runtime parameters set globally '
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

      Future<void> validateParameters() async {
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
      }

      test('then all parameters are applied correctly.', () async {
        await validateParameters();
      });

      test('then all parameters persist valid for subsequent tests.', () async {
        await validateParameters();
      });
    },
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
  );

  withServerpod(
    'Given withServerpod with runtime parameters set globally '
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

      test('then local parameters override global ones temporarily.', () async {
        await session.db.ensureVectorLoaded();
        var checkQuery = HnswIndexQueryOptions().buildCheckValues();

        await session.db.transaction((transaction) async {
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
        });

        var globalResult = await session.db.unsafeQuery(checkQuery);

        expect(globalResult.length, 1);
        var globalRow = globalResult.first.toColumnMap();
        expect(globalRow['hnsw_ef_search'], '50');
        expect(globalRow['hnsw_iterative_scan'], 'relaxed_order');
        expect(globalRow['hnsw_max_scan_tuples'], '500');
        expect(globalRow['hnsw_scan_mem_multiplier'], '2');
      });

      test('then other local parameters are not globally persisted.', () async {
        await session.db.ensureVectorLoaded();
        var checkQuery = IvfflatIndexQueryOptions().buildCheckValues();

        await session.db.transaction((transaction) async {
          await transaction.setRuntimeParameters((params) => [
                params.ivfflatIndexQuery(
                  probes: 2,
                  iterativeScan: IterativeScan.relaxed,
                  maxProbes: 4,
                ),
              ]);

          var localResult = await session.db.unsafeQuery(
            checkQuery,
            transaction: transaction,
          );

          expect(localResult.length, 1);
          var localRow = localResult.first.toColumnMap();
          expect(localRow['ivfflat_probes'], '2');
          expect(localRow['ivfflat_iterative_scan'], 'relaxed_order');
          expect(localRow['ivfflat_max_probes'], '4');
        });

        var globalResult = await session.db.unsafeQuery(checkQuery);

        expect(globalResult.length, 1);
        var globalRow = globalResult.first.toColumnMap();
        expect(globalRow['ivfflat_probes'], '1');
        expect(globalRow['ivfflat_iterative_scan'], 'off');
        expect(globalRow['ivfflat_max_probes'], '32768');
      });
    },
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
  );
}
