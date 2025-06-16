/// Base class for runtime parameters group to apply to the database.
abstract class RuntimeParameters {
  /// Base constructor for runtime parameters group.
  const RuntimeParameters();

  /// The options that this runtime parameters group can set. The key is the
  /// name of the option as it appears in the SQL statement, and the value is
  /// the value to set it to. The value can also be a [RuntimeParameters].
  Map<String, dynamic> get options;

  /// Returns a list with the SQL statements to set each runtime parameters.
  /// If [isLocal] is true, options are set for the current transaction only.
  Iterable<String> buildStatements({bool isLocal = false}) =>
      options.entries.where((e) => e.value != null).map((e) {
        var value = e.value;
        if (value is RuntimeParameters) return value.build(isLocal: isLocal);
        if (value is IterativeScan) value = '${value.name}_order';
        if (value is bool) value = e.value == true ? 'on' : 'off';
        return 'SET ${isLocal ? 'LOCAL ' : ''}${e.key} = $value;';
      }).where((e) => e != '');

  /// Returns the SQL statement to set the runtime parameters. If [isLocal] is
  /// true, options are set for the current transaction only and not globally.
  String build({bool isLocal = false}) =>
      buildStatements(isLocal: isLocal).join('\n');

  /// Returns a SELECT statement to check current values of all options.
  /// When running the query, parameters that were not yet set will return null.
  String buildCheckValues() {
    var optionsList = options.keys
        .map((k) => "current_setting('$k', true) as ${k.replaceAll('.', '_')}")
        .join(', ');
    return 'SELECT $optionsList;';
  }
}

/// Query options for the HNSW index.
class HnswIndexQueryOptions extends RuntimeParameters {
  /// The ef search parameter for HNSW index.
  final int? efSearch;

  /// The iterative scan limit.
  final IterativeScan? iterativeScan;

  /// The maximum number of tuples to scan.
  final int? maxScanTuples;

  /// The memory multiplier for the scan.
  final int? scanMemMultiplier;

  /// Creates a new HNSW index query options object.
  const HnswIndexQueryOptions({
    this.efSearch,
    this.iterativeScan,
    this.maxScanTuples,
    this.scanMemMultiplier,
  });

  @override
  Map<String, dynamic> get options => <String, dynamic>{
        'hnsw.ef_search': efSearch,
        'hnsw.iterative_scan': iterativeScan,
        'hnsw.max_scan_tuples': maxScanTuples,
        'hnsw.scan_mem_multiplier': scanMemMultiplier,
      };
}

/// Query options for the IVFFLAT index.
class IvfflatIndexQueryOptions extends RuntimeParameters {
  /// The number of probes for the IVFFLAT index.
  final int? probes;

  /// The iterative scan limit.
  final IterativeScan? iterativeScan;

  /// The maximum number of probes for the IVFFLAT index.
  final int? maxProbes;

  /// Creates a new IVFFLAT index query options object.
  const IvfflatIndexQueryOptions({
    this.probes,
    this.iterativeScan,
    this.maxProbes,
  });

  @override
  Map<String, dynamic> get options => <String, dynamic>{
        'ivfflat.probes': probes,
        'ivfflat.iterative_scan': iterativeScan,
        'ivfflat.max_probes': maxProbes,
      };
}

/// Query options for vector indexes.
class VectorIndexQueryOptions extends RuntimeParameters {
  /// Whether to enable index scan.
  final bool? enableIndexScan;

  /// Whether to enable sequential scan.
  final bool? enableSeqScan;

  /// The minimum parallel table scan size (in 8kB blocks).
  final int? minParallelTableScanSize;

  /// The parallel setup cost.
  final int? parallelSetupCost;

  /// The maintenance work memory (in KB).
  final int? maintenanceWorkMem;

  /// The maximum parallel maintenance workers.
  final int? maxParallelMaintenanceWorkers;

  /// The maximum parallel workers per gather.
  final int? maxParallelWorkersPerGather;

  /// Creates a new vector index query options object.
  const VectorIndexQueryOptions({
    this.enableIndexScan,
    this.enableSeqScan,
    this.minParallelTableScanSize,
    this.parallelSetupCost,
    this.maintenanceWorkMem,
    this.maxParallelMaintenanceWorkers,
    this.maxParallelWorkersPerGather,
  });

  @override
  Map<String, dynamic> get options => <String, dynamic>{
        'enable_indexscan': enableIndexScan,
        'enable_seqscan': enableSeqScan,
        'min_parallel_table_scan_size': minParallelTableScanSize,
        'parallel_setup_cost': parallelSetupCost,
        'maintenance_work_mem': maintenanceWorkMem,
        'max_parallel_maintenance_workers': maxParallelMaintenanceWorkers,
        'max_parallel_workers_per_gather': maxParallelWorkersPerGather,
      };
}

/// Automatically scan more of the index until enough results are found.
enum IterativeScan {
  /// Strict ensures results are in the exact order by distance.
  strict,

  /// Relaxed allows results to be slightly out of order by distance, but
  /// provides better recall.
  relaxed,
}
