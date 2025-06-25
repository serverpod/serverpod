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

      var result = options.build(isLocal: false);
      expect(
        result,
        'SET test.boolean_true = on;\n'
        'SET test.boolean_false = off;\n'
        'SET test.integer_value = 17;\n'
        'SET test.string_value = \'test_string\';\n'
        'SET test.enum_value = strict_order;\n'
        'SET nested.option = \'nested_value\';\n'
        'SET test.null_value TO DEFAULT;',
      );
    });

    test(
        'when build is called with mixed null and non-null values then null values become TO DEFAULT.',
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

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET test.boolean_true = on;\n'
        'SET test.boolean_false TO DEFAULT;\n'
        'SET test.integer_value TO DEFAULT;\n'
        'SET test.string_value = \'partial_test\';\n'
        'SET test.enum_value TO DEFAULT;\n'
        'SET test.nested_parameters TO DEFAULT;\n'
        'SET test.null_value TO DEFAULT;',
      );
    });

    test(
        'when build is called with only null values then TO DEFAULT is used for all parameters.',
        () {
      var options = const _ComprehensiveRuntimeParameters();

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET test.boolean_true TO DEFAULT;\n'
        'SET test.boolean_false TO DEFAULT;\n'
        'SET test.integer_value TO DEFAULT;\n'
        'SET test.string_value TO DEFAULT;\n'
        'SET test.enum_value TO DEFAULT;\n'
        'SET test.nested_parameters TO DEFAULT;\n'
        'SET test.null_value TO DEFAULT;',
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
        'SET LOCAL test.boolean_false TO DEFAULT;\n'
        'SET LOCAL test.integer_value = 100;\n'
        'SET LOCAL test.string_value TO DEFAULT;\n'
        'SET LOCAL test.enum_value TO DEFAULT;\n'
        'SET LOCAL nested.option = \'nested_value\';\n'
        'SET LOCAL test.null_value TO DEFAULT;',
      );
    });

    group('with enum handling', () {
      test('when IterativeScan.off is used then off is generated.', () {
        var options = const _ComprehensiveRuntimeParameters(
          enumValue: IterativeScan.off,
        );

        var result = options.build(isLocal: false);

        expect(result, contains('SET test.enum_value = off;'));
      });

      test('when IterativeScan.strict is used then strict_order is generated.',
          () {
        var options = const _ComprehensiveRuntimeParameters(
          enumValue: IterativeScan.strict,
        );

        var result = options.build(isLocal: false);

        expect(result, contains('SET test.enum_value = strict_order;'));
      });

      test(
          'when IterativeScan.relaxed is used then relaxed_order is generated.',
          () {
        var options = const _ComprehensiveRuntimeParameters(
          enumValue: IterativeScan.relaxed,
        );

        var result = options.build(isLocal: false);

        expect(result, contains('SET test.enum_value = relaxed_order;'));
      });
    });

    group('with boolean conversion', () {
      test('when boolean is true then on is used in SQL.', () {
        var options = const _ComprehensiveRuntimeParameters(
          booleanTrue: true,
        );

        var result = options.build(isLocal: false);

        expect(result, contains('SET test.boolean_true = on;'));
      });

      test('when boolean is false then off is used in SQL.', () {
        var options = const _ComprehensiveRuntimeParameters(
          booleanFalse: false,
        );

        var result = options.build(isLocal: false);

        expect(result, contains('SET test.boolean_false = off;'));
      });
    });

    group('with nested RuntimeParameters', () {
      test(
          'when nested RuntimeParameters is provided then nested build is called.',
          () {
        var options = _ComprehensiveRuntimeParameters(
          nestedParameters: _NestedRuntimeParameters(),
        );

        var result = options.build(isLocal: false);

        expect(result, contains('SET nested.option = \'nested_value\';'));
      });

      test(
          'when nested RuntimeParameters and isLocal true then nested receives isLocal.',
          () {
        var options = _ComprehensiveRuntimeParameters(
          nestedParameters: _NestedRuntimeParameters(),
        );

        var result = options.build(isLocal: true);

        expect(result, contains('SET LOCAL nested.option = \'nested_value\';'));
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

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET hnsw.ef_search = 100;\n'
        'SET hnsw.iterative_scan = strict_order;\n'
        'SET hnsw.max_scan_tuples = 1000;\n'
        'SET hnsw.scan_mem_multiplier = 2;',
      );
    });

    test('when created with no parameters then default values are used.', () {
      var options = const HnswIndexQueryOptions();

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET hnsw.ef_search = 40;\n'
        'SET hnsw.iterative_scan = off;\n'
        'SET hnsw.max_scan_tuples = 20000;\n'
        'SET hnsw.scan_mem_multiplier = 1;',
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
        'SET LOCAL hnsw.iterative_scan = relaxed_order;\n'
        'SET LOCAL hnsw.max_scan_tuples = 20000;\n'
        'SET LOCAL hnsw.scan_mem_multiplier = 1;',
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
        iterativeScan: IterativeScan.relaxed,
        maxProbes: 10,
      );

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET ivfflat.probes = 5;\n'
        'SET ivfflat.iterative_scan = relaxed_order;\n'
        'SET ivfflat.max_probes = 10;',
      );
    });

    test('when created with no parameters then default values are used.', () {
      var options = const IvfflatIndexQueryOptions();

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET ivfflat.probes = 1;\n'
        'SET ivfflat.iterative_scan = off;\n'
        'SET ivfflat.max_probes = 32768;',
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
        'SET LOCAL ivfflat.iterative_scan = off;\n'
        'SET LOCAL ivfflat.max_probes = 15;',
      );
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

    group('with constructor validation', () {
      test('when iterative scan is strict then assertion error is thrown.', () {
        expect(
          () => IvfflatIndexQueryOptions(iterativeScan: IterativeScan.strict),
          throwsA(isA<AssertionError>()),
        );
      });

      test(
          'when iterative scan is not strict then no assertion error is thrown.',
          () {
        expect(
          () => const IvfflatIndexQueryOptions(
              iterativeScan: IterativeScan.relaxed),
          returnsNormally,
        );
      });

      test('when iterative scan is off then no assertion error is thrown.', () {
        expect(
          () =>
              const IvfflatIndexQueryOptions(iterativeScan: IterativeScan.off),
          returnsNormally,
        );
      });
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
        parallelSetupCost: 1000.0,
        maintenanceWorkMem: 64,
        maxParallelMaintenanceWorkers: 4,
        maxParallelWorkersPerGather: 2,
      );

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET enable_indexscan = on;\n'
        'SET enable_seqscan = off;\n'
        'SET min_parallel_table_scan_size = 1024;\n'
        'SET parallel_setup_cost = 1000.0;\n'
        'SET maintenance_work_mem = 64;\n'
        'SET max_parallel_maintenance_workers = 4;\n'
        'SET max_parallel_workers_per_gather = 2;',
      );
    });

    test('when created with no parameters then default values are used.', () {
      var options = const VectorIndexQueryOptions();

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET enable_indexscan = on;\n'
        'SET enable_seqscan = on;\n'
        'SET min_parallel_table_scan_size = 1024;\n'
        'SET parallel_setup_cost = 1000.0;\n'
        'SET maintenance_work_mem = 65536;\n'
        'SET max_parallel_maintenance_workers = 2;\n'
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
        'SET LOCAL min_parallel_table_scan_size = 512;\n'
        'SET LOCAL parallel_setup_cost = 1000.0;\n'
        'SET LOCAL maintenance_work_mem = 65536;\n'
        'SET LOCAL max_parallel_maintenance_workers = 2;\n'
        'SET LOCAL max_parallel_workers_per_gather = 2;',
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

  group('Given a SearchPathsConfig', () {
    test(
        'when build is called with search paths then correct SQL statement is returned.',
        () {
      var options = SearchPathsConfig(
        searchPaths: ['public', 'custom_schema', 'another_schema'],
      );

      var result = options.build(isLocal: false);

      expect(
        result,
        "SET search_path TO 'public', 'custom_schema', 'another_schema';",
      );
    });

    test('when build is called with null search paths then TO DEFAULT is used.',
        () {
      var options = const SearchPathsConfig(
        searchPaths: null,
      );

      var result = options.build(isLocal: false);

      expect(
        result,
        'SET search_path TO DEFAULT;',
      );
    });

    test(
        'when build is called with isLocal true then LOCAL is included in SQL statement.',
        () {
      var options = SearchPathsConfig(
        searchPaths: ['public', 'custom_schema'],
      );

      var result = options.build(isLocal: true);

      expect(
        result,
        "SET LOCAL search_path TO 'public', 'custom_schema';",
      );
    });

    test(
        'when build is called with isLocal true and null paths then LOCAL TO DEFAULT is used.',
        () {
      var options = const SearchPathsConfig(
        searchPaths: null,
      );

      var result = options.build(isLocal: true);

      expect(
        result,
        'SET LOCAL search_path TO DEFAULT;',
      );
    });

    test(
        'when buildCheckValues is called then SELECT statement with search_path option is returned.',
        () {
      var options = SearchPathsConfig(
        searchPaths: ['public'],
      );

      var result = options.buildCheckValues();

      expect(
        result,
        "SELECT current_setting('search_path', true) as search_path;",
      );
    });

    group('with constructor validation', () {
      test('when search paths list is empty then assertion error is thrown.',
          () {
        expect(
          () => SearchPathsConfig(searchPaths: []),
          throwsA(isA<AssertionError>()),
        );
      });

      test('when search paths list is null then no assertion error is thrown.',
          () {
        expect(
          () => const SearchPathsConfig(searchPaths: null),
          returnsNormally,
        );
      });

      test(
          'when search paths list has valid entries then no assertion error is thrown.',
          () {
        expect(
          () => SearchPathsConfig(searchPaths: ['public', 'custom']),
          returnsNormally,
        );
      });
    });
  });

  group('Given RuntimeParametersBuilder', () {
    test(
        'when using hnswIndexQuery then correct HnswIndexQueryOptions is created.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.hnswIndexQuery(
        efSearch: 100,
        iterativeScan: IterativeScan.strict,
        maxScanTuples: 1000,
        scanMemMultiplier: 2,
      );

      expect(options, isA<HnswIndexQueryOptions>());
      expect(options.efSearch, 100);
      expect(options.iterativeScan, IterativeScan.strict);
      expect(options.maxScanTuples, 1000);
      expect(options.scanMemMultiplier, 2);
    });

    test(
        'when using ivfflatIndexQuery then correct IvfflatIndexQueryOptions is created.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.ivfflatIndexQuery(
        probes: 5,
        iterativeScan: IterativeScan.relaxed,
        maxProbes: 10,
      );

      expect(options, isA<IvfflatIndexQueryOptions>());
      expect(options.probes, 5);
      expect(options.iterativeScan, IterativeScan.relaxed);
      expect(options.maxProbes, 10);
    });

    test(
        'when using vectorIndexQuery then correct VectorIndexQueryOptions is created.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.vectorIndexQuery(
        enableIndexScan: true,
        enableSeqScan: false,
        minParallelTableScanSize: 1024,
        parallelSetupCost: 1000,
        maintenanceWorkMem: 64,
        maxParallelMaintenanceWorkers: 4,
        maxParallelWorkersPerGather: 2,
      );

      expect(options, isA<VectorIndexQueryOptions>());
      expect(options.enableIndexScan, true);
      expect(options.enableSeqScan, false);
      expect(options.minParallelTableScanSize, 1024);
      expect(options.parallelSetupCost, 1000);
      expect(options.maintenanceWorkMem, 64);
      expect(options.maxParallelMaintenanceWorkers, 4);
      expect(options.maxParallelWorkersPerGather, 2);
    });

    test('when using hnswIndexQuery with no parameters then defaults are used.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.hnswIndexQuery();

      expect(options, isA<HnswIndexQueryOptions>());
      expect(options.efSearch, 40);
      expect(options.iterativeScan, IterativeScan.off);
      expect(options.maxScanTuples, 20000);
      expect(options.scanMemMultiplier, 1);
    });

    test(
        'when using ivfflatIndexQuery with no parameters then defaults are used.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.ivfflatIndexQuery();

      expect(options, isA<IvfflatIndexQueryOptions>());
      expect(options.probes, 1);
      expect(options.iterativeScan, IterativeScan.off);
      expect(options.maxProbes, 32768);
    });

    test(
        'when using vectorIndexQuery with no parameters then defaults are used.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.vectorIndexQuery();

      expect(options, isA<VectorIndexQueryOptions>());
      expect(options.enableIndexScan, true);
      expect(options.enableSeqScan, true);
      expect(options.minParallelTableScanSize, 1024);
      expect(options.parallelSetupCost, 1000.0);
      expect(options.maintenanceWorkMem, 65536);
      expect(options.maxParallelMaintenanceWorkers, 2);
      expect(options.maxParallelWorkersPerGather, 2);
    });

    test('when using searchPaths then correct SearchPathsConfig is created.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.searchPaths(['public', 'custom_schema']);

      expect(options, isA<SearchPathsConfig>());
      expect(options.searchPaths, ['public', 'custom_schema']);
    });

    test(
        'when using searchPaths with null then correct SearchPathsConfig is created.',
        () {
      var builder = RuntimeParametersBuilder();
      var options = builder.searchPaths(null);

      expect(options, isA<SearchPathsConfig>());
      expect(options.searchPaths, null);
    });
  });

  group('Given a MapRuntimeParameters', () {
    test(
        'when build is called with various types then correct SQL is returned.',
        () {
      var params = MapRuntimeParameters({
        'custom.string': 'value',
        'custom.int': 42,
        'custom.bool': true,
        'custom.null': null,
      });

      var result = params.build(isLocal: false);

      expect(
        result,
        'SET custom.string = \'value\';\n'
        'SET custom.int = 42;\n'
        'SET custom.bool = on;\n'
        'SET custom.null TO DEFAULT;',
      );
    });

    test(
        'when build is called with nested RuntimeParameters then nested SQL is included.',
        () {
      var params = MapRuntimeParameters({
        'outer.key': 'outer',
        'nested': MapRuntimeParameters({'nested.key': 'nested'}),
      });

      var result = params.build(isLocal: false);

      expect(result, contains("SET outer.key = 'outer';"));
      expect(result, contains("SET nested.key = 'nested';"));
    });

    test('when build is called with isLocal true then LOCAL is included.', () {
      var params = MapRuntimeParameters({'custom.key': 1});

      var result = params.build(isLocal: true);

      expect(result, 'SET LOCAL custom.key = 1;');
    });

    test('when buildCheckValues is called then SELECT statement is correct.',
        () {
      var params = MapRuntimeParameters({
        'a': 1,
        'b': 'x',
      });
      var result = params.buildCheckValues();
      expect(
        result,
        "SELECT current_setting('a', true) as a, current_setting('b', true) as b;",
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
