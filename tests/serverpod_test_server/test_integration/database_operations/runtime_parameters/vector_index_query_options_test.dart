import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  group('Given VectorIndexQueryOptions runtime parameters', () {
    test('when setting parameters globally then options are applied globally.',
        () async {
      var session = await IntegrationTestServer(
        runtimeParametersBuilder: (params) => [
          params.vectorIndexQuery(
            enableIndexScan: true,
            enableSeqScan: false,
            minParallelTableScanSize: 1024,
            parallelSetupCost: 1,
            maintenanceWorkMem: 65536,
            maxParallelMaintenanceWorkers: 4,
            maxParallelWorkersPerGather: 2,
          ),
        ],
      ).session();

      var checkQuery = VectorIndexQueryOptions().buildCheckValues();
      var result = await session.db.unsafeQuery(checkQuery);

      expect(result.length, 1);
      var row = result.first.toColumnMap();
      expect(row['enable_indexscan'], 'on');
      expect(row['enable_seqscan'], 'off');
      expect(row['min_parallel_table_scan_size'], '8MB');
      expect(row['parallel_setup_cost'], '1');
      expect(row['maintenance_work_mem'], '64MB');
      expect(row['max_parallel_maintenance_workers'], '4');
      expect(row['max_parallel_workers_per_gather'], '2');
    });

    test(
        'when setting parameters in transaction then they do not affect global settings.',
        () async {
      var checkQuery = VectorIndexQueryOptions().buildCheckValues();

      var session = await IntegrationTestServer(
        runtimeParametersBuilder: (params) => [
          params.vectorIndexQuery(
            enableIndexScan: true,
            enableSeqScan: false,
            minParallelTableScanSize: 1024,
            parallelSetupCost: 1,
            maintenanceWorkMem: 65536,
            maxParallelMaintenanceWorkers: 4,
            maxParallelWorkersPerGather: 2,
          ),
        ],
      ).session();

      await session.db.transaction((transaction) async {
        await transaction.setRuntimeParameters(
          (params) => [
            params.vectorIndexQuery(
              enableIndexScan: false,
              enableSeqScan: true,
              minParallelTableScanSize: 512,
              parallelSetupCost: 2,
              maintenanceWorkMem: 65536 * 2,
              maxParallelMaintenanceWorkers: 2,
              maxParallelWorkersPerGather: 1,
            ),
          ],
        );

        var localResult = await session.db.unsafeQuery(
          checkQuery,
          transaction: transaction,
        );
        var localRow = localResult.first.toColumnMap();
        expect(localRow['enable_indexscan'], 'off');
        expect(localRow['enable_seqscan'], 'on');
        expect(localRow['min_parallel_table_scan_size'], '4MB');
        expect(localRow['parallel_setup_cost'], '2');
        expect(localRow['maintenance_work_mem'], '128MB');
        expect(localRow['max_parallel_maintenance_workers'], '2');
        expect(localRow['max_parallel_workers_per_gather'], '1');
      });

      var globalResult = await session.db.unsafeQuery(checkQuery);
      var globalRow = globalResult.first.toColumnMap();
      expect(globalRow['enable_indexscan'], 'on');
      expect(globalRow['enable_seqscan'], 'off');
      expect(globalRow['min_parallel_table_scan_size'], '8MB');
      expect(globalRow['parallel_setup_cost'], '1');
      expect(globalRow['maintenance_work_mem'], '64MB');
      expect(globalRow['max_parallel_maintenance_workers'], '4');
      expect(globalRow['max_parallel_workers_per_gather'], '2');
    });
  });
}
