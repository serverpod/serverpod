import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a comprehensive RuntimeParameters implementation', () {
    test(
        'when build is called with all parameter types then correct SQL statements are returned.',
        () {
      var options = _ComprehensiveRuntimeParameters(
        booleanTrue: true,
        booleanFalse: false,
        integerValue: 17,
        stringValue: 'test_string',
        enumValue: IterativeScan.strict,
        nestedParameters: _NestedRuntimeParameters(),
        nullValue: null,
      );

      var result = options.build();
      expect(
        result,
        'SET test.boolean_true = on;\n'
        'SET test.boolean_false = off;\n'
        'SET test.integer_value = 17;\n'
        'SET test.string_value = test_string;\n'
        'SET test.enum_value = strict_order;\n'
        'SET nested.option = nested_value;',
      );
    });

    test(
        'when build is called with isLocal true then LOCAL is included in all SQL statements.',
        () {
      var options = _ComprehensiveRuntimeParameters(
        booleanTrue: true,
        integerValue: 100,
        nestedParameters: _NestedRuntimeParameters(),
      );

      var result = options.build(isLocal: true);

      expect(
        result,
        'SET LOCAL test.boolean_true = on;\n'
        'SET LOCAL test.integer_value = 100;\n'
        'SET LOCAL nested.option = nested_value;',
      );
    });

    test(
        'when build is called with only null values then empty string is returned.',
        () {
      var options = const _ComprehensiveRuntimeParameters();

      var result = options.build();

      expect(result, '');
    });

    test(
        'when build is called with mixed null and non-null values then only non-null values are included.',
        () {
      var options = const _ComprehensiveRuntimeParameters(
        booleanTrue: true,
        booleanFalse: null,
        integerValue: null,
        stringValue: 'partial_test',
        enumValue: null,
        nestedParameters: null,
        nullValue: null,
      );

      var result = options.build();

      expect(
        result,
        'SET test.boolean_true = on;\n'
        'SET test.string_value = partial_test;',
      );
    });

    group('with enum handling', () {
      test('when IterativeScan.strict is used then strict_order is generated.',
          () {
        var options = const _ComprehensiveRuntimeParameters(
          enumValue: IterativeScan.strict,
        );

        var result = options.build();

        expect(result, 'SET test.enum_value = strict_order;');
      });

      test(
          'when IterativeScan.relaxed is used then relaxed_order is generated.',
          () {
        var options = const _ComprehensiveRuntimeParameters(
          enumValue: IterativeScan.relaxed,
        );

        var result = options.build();

        expect(result, 'SET test.enum_value = relaxed_order;');
      });
    });

    group('with boolean conversion', () {
      test('when boolean is true then on is used in SQL.', () {
        var options = const _ComprehensiveRuntimeParameters(
          booleanTrue: true,
        );

        var result = options.build();

        expect(result, 'SET test.boolean_true = on;');
      });

      test('when boolean is false then off is used in SQL.', () {
        var options = const _ComprehensiveRuntimeParameters(
          booleanFalse: false,
        );

        var result = options.build();

        expect(result, 'SET test.boolean_false = off;');
      });
    });

    group('with nested RuntimeParameters', () {
      test(
          'when nested RuntimeParameters is provided then nested build is called.',
          () {
        var options = _ComprehensiveRuntimeParameters(
          nestedParameters: _NestedRuntimeParameters(),
        );

        var result = options.build();

        expect(result, 'SET nested.option = nested_value;');
      });

      test(
          'when nested RuntimeParameters and isLocal true then nested receives isLocal.',
          () {
        var options = _ComprehensiveRuntimeParameters(
          nestedParameters: _NestedRuntimeParameters(),
        );

        var result = options.build(isLocal: true);

        expect(result, 'SET LOCAL nested.option = nested_value;');
      });
    });
  });

  group('Given a HnswIndexQueryOptions', () {
    test(
        'when build is called with all parameters then correct SQL statements are returned.',
        () {
      var options = const HnswIndexQueryOptions(
        efSearch: 100,
        iterativeScan: IterativeScan.strict,
        maxScanTuples: 1000,
        scanMemMultiplier: 2,
      );

      var result = options.build();

      expect(
        result,
        'SET hnsw.ef_search = 100;\n'
        'SET hnsw.iterative_scan = strict_order;\n'
        'SET hnsw.max_scan_tuples = 1000;\n'
        'SET hnsw.scan_mem_multiplier = 2;',
      );
    });

    test(
        'when build is called with isLocal true then LOCAL is included in SQL statements.',
        () {
      var options = const HnswIndexQueryOptions(
        efSearch: 100,
        iterativeScan: IterativeScan.relaxed,
      );

      var result = options.build(isLocal: true);

      expect(
        result,
        'SET LOCAL hnsw.ef_search = 100;\n'
        'SET LOCAL hnsw.iterative_scan = relaxed_order;',
      );
    });

    test(
        'when build is called with null parameters then only non-null parameters are included.',
        () {
      var options = const HnswIndexQueryOptions(
        efSearch: 50,
        iterativeScan: null,
        maxScanTuples: null,
        scanMemMultiplier: 3,
      );

      var result = options.build();

      expect(
        result,
        'SET hnsw.ef_search = 50;\n'
        'SET hnsw.scan_mem_multiplier = 3;',
      );
    });

    test(
        'when buildCheckValues is called then SELECT statement with all options is returned.',
        () {
      var options = const HnswIndexQueryOptions();

      var result = options.buildCheckValues();

      expect(
        result,
        "SELECT current_setting('hnsw.ef_search', true) as hnsw_ef_search, "
        "current_setting('hnsw.iterative_scan', true) as hnsw_iterative_scan, "
        "current_setting('hnsw.max_scan_tuples', true) as hnsw_max_scan_tuples, "
        "current_setting('hnsw.scan_mem_multiplier', true) as hnsw_scan_mem_multiplier;",
      );
    });
  });

  group('Given a IvfflatIndexQueryOptions', () {
    test(
        'when build is called with all parameters then correct SQL statements are returned.',
        () {
      var options = const IvfflatIndexQueryOptions(
        probes: 5,
        iterativeScan: IterativeScan.strict,
        maxProbes: 10,
      );

      var result = options.build();

      expect(
        result,
        'SET ivfflat.probes = 5;\n'
        'SET ivfflat.iterative_scan = strict_order;\n'
        'SET ivfflat.max_probes = 10;',
      );
    });

    test(
        'when build is called with isLocal true then LOCAL is included in SQL statements.',
        () {
      var options = const IvfflatIndexQueryOptions(
        probes: 3,
        maxProbes: 15,
      );

      var result = options.build(isLocal: true);

      expect(
        result,
        'SET LOCAL ivfflat.probes = 3;\n'
        'SET LOCAL ivfflat.max_probes = 15;',
      );
    });

    test(
        'when build is called with partial parameters then only non-null parameters are included.',
        () {
      var options = const IvfflatIndexQueryOptions(
        probes: 7,
        iterativeScan: null,
        maxProbes: null,
      );

      var result = options.build();

      expect(result, 'SET ivfflat.probes = 7;');
    });

    test(
        'when buildCheckValues is called then SELECT statement with all options is returned.',
        () {
      var options = const IvfflatIndexQueryOptions();

      var result = options.buildCheckValues();

      expect(
        result,
        "SELECT current_setting('ivfflat.probes', true) as ivfflat_probes, "
        "current_setting('ivfflat.iterative_scan', true) as ivfflat_iterative_scan, "
        "current_setting('ivfflat.max_probes', true) as ivfflat_max_probes;",
      );
    });
  });

  group('Given a VectorIndexQueryOptions', () {
    test(
        'when build is called with all parameters then correct SQL statements are returned.',
        () {
      var options = const VectorIndexQueryOptions(
        enableIndexScan: true,
        enableSeqScan: false,
        minParallelTableScanSize: 1024,
        parallelSetupCost: 1000,
        maintenanceWorkMem: 64,
        maxParallelMaintenanceWorkers: 4,
        maxParallelWorkersPerGather: 2,
      );

      var result = options.build();

      expect(
        result,
        'SET enable_indexscan = on;\n'
        'SET enable_seqscan = off;\n'
        'SET min_parallel_table_scan_size = 1024;\n'
        'SET parallel_setup_cost = 1000;\n'
        'SET maintenance_work_mem = 64;\n'
        'SET max_parallel_maintenance_workers = 4;\n'
        'SET max_parallel_workers_per_gather = 2;',
      );
    });

    test(
        'when build is called with isLocal true then LOCAL is included in SQL statements.',
        () {
      var options = const VectorIndexQueryOptions(
        enableIndexScan: true,
        enableSeqScan: false,
        minParallelTableScanSize: 512,
      );

      var result = options.build(isLocal: true);

      expect(
        result,
        'SET LOCAL enable_indexscan = on;\n'
        'SET LOCAL enable_seqscan = off;\n'
        'SET LOCAL min_parallel_table_scan_size = 512;',
      );
    });

    test(
        'when build is called with mixed null and non-null parameters then only non-null parameters are included.',
        () {
      var options = const VectorIndexQueryOptions(
        enableIndexScan: true,
        enableSeqScan: null,
        minParallelTableScanSize: null,
        parallelSetupCost: 2000,
        maintenanceWorkMem: null,
        maxParallelMaintenanceWorkers: null,
        maxParallelWorkersPerGather: 3,
      );

      var result = options.build();

      expect(
        result,
        'SET enable_indexscan = on;\n'
        'SET parallel_setup_cost = 2000;\n'
        'SET max_parallel_workers_per_gather = 3;',
      );
    });

    test(
        'when buildCheckValues is called then SELECT statement with all options is returned.',
        () {
      var options = const VectorIndexQueryOptions();

      var result = options.buildCheckValues();

      expect(
        result,
        "SELECT current_setting('enable_indexscan', true) as enable_indexscan, "
        "current_setting('enable_seqscan', true) as enable_seqscan, "
        "current_setting('min_parallel_table_scan_size', true) as min_parallel_table_scan_size, "
        "current_setting('parallel_setup_cost', true) as parallel_setup_cost, "
        "current_setting('maintenance_work_mem', true) as maintenance_work_mem, "
        "current_setting('max_parallel_maintenance_workers', true) as max_parallel_maintenance_workers, "
        "current_setting('max_parallel_workers_per_gather', true) as max_parallel_workers_per_gather;",
      );
    });
  });
}

// Mock classes for testing RuntimeParameters behavior
class _ComprehensiveRuntimeParameters extends RuntimeParameters {
  final bool? booleanTrue;
  final bool? booleanFalse;
  final int? integerValue;
  final String? stringValue;
  final IterativeScan? enumValue;
  final RuntimeParameters? nestedParameters;
  final String? nullValue;

  const _ComprehensiveRuntimeParameters({
    this.booleanTrue,
    this.booleanFalse,
    this.integerValue,
    this.stringValue,
    this.enumValue,
    this.nestedParameters,
    this.nullValue,
  });

  @override
  Map<String, dynamic> get options => <String, dynamic>{
        'test.boolean_true': booleanTrue,
        'test.boolean_false': booleanFalse,
        'test.integer_value': integerValue,
        'test.string_value': stringValue,
        'test.enum_value': enumValue,
        'test.nested_parameters': nestedParameters,
        'test.null_value': nullValue,
      };
}

class _NestedRuntimeParameters extends RuntimeParameters {
  @override
  Map<String, dynamic> get options => <String, dynamic>{
        'nested.option': 'nested_value',
      };
}
