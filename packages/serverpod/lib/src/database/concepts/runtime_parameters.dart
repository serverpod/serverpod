import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/database_pool_manager.dart';

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
  Iterable<String> buildStatements({required bool isLocal}) =>
      options.entries.map((e) {
        var value = e.value;
        if (value is String) value = DatabasePoolManager.encoder.convert(value);
        if (value is RuntimeParameters) return value.build(isLocal: isLocal);
        if (value is IterativeScan) value = value.alias;
        if (value is bool) value = (value == true) ? 'on' : 'off';

        if (value == null) {
          value = 'TO DEFAULT';
        } else if (this is SearchPathsConfig) {
          value = (value as List<String>)
              .map((s) => DatabasePoolManager.encoder.convert(s))
              .join(', ');
          value = 'TO $value';
        } else {
          value = '= $value';
        }
        return 'SET ${isLocal ? 'LOCAL ' : ''}${e.key} $value;';
      }).where((e) => e != '');

  /// Returns the SQL statement to set the runtime parameters. If [isLocal] is
  /// true, options are set for the current transaction only and not globally.
  String build({required bool isLocal}) =>
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

/// Runtime parameters that can be built from a map of options.
class MapRuntimeParameters extends RuntimeParameters {
  /// Creates a new runtime parameters object from a map of options.
  MapRuntimeParameters(this.options);

  @override
  Map<String, dynamic> options;
}

/// Query options for the HNSW index.
class HnswIndexQueryOptions extends RuntimeParameters {
  /// The ef search parameter for HNSW index. Default is 40.
  final int efSearch;

  /// The iterative scan limit. Default is off.
  final IterativeScan iterativeScan;

  /// The maximum number of tuples to scan. Default is 20000.
  final int maxScanTuples;

  /// The memory multiplier for the scan. Default is 1.
  final int scanMemMultiplier;

  /// Creates a new HNSW index query options object.
  const HnswIndexQueryOptions({
    this.efSearch = 40,
    this.iterativeScan = IterativeScan.off,
    this.maxScanTuples = 20000,
    this.scanMemMultiplier = 1,
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
  /// The number of probes for the IVFFLAT index. Default is 1.
  final int probes;

  /// The iterative scan limit. Default is off.
  final IterativeScan iterativeScan;

  /// The maximum number of probes for the IVFFLAT index. Default to null (unset).
  final int maxProbes;

  /// Creates a new IVFFLAT index query options object.
  const IvfflatIndexQueryOptions({
    this.probes = 1,
    this.iterativeScan = IterativeScan.off,
    this.maxProbes = 32768,
  }) : assert(iterativeScan != IterativeScan.strict,
            'Strict iterative scan is not supported for IVFFLAT indexes');

  @override
  Map<String, dynamic> get options => <String, dynamic>{
        'ivfflat.probes': probes,
        'ivfflat.iterative_scan': iterativeScan,
        'ivfflat.max_probes': maxProbes,
      };
}

/// Query options for vector indexes.
class VectorIndexQueryOptions extends RuntimeParameters {
  /// Whether to enable index scan. Default is true.
  final bool enableIndexScan;

  /// Whether to enable sequential scan. Default is true.
  final bool enableSeqScan;

  /// The minimum parallel table scan size (in 8kB blocks). Default is 1024 blocks (8MB).
  final int minParallelTableScanSize;

  /// The parallel setup cost. Default is 1000.0.
  final double parallelSetupCost;

  /// The maintenance work memory (in KB). Default is 65536 (64MB).
  final int maintenanceWorkMem;

  /// The maximum parallel maintenance workers. Default is 2.
  final int maxParallelMaintenanceWorkers;

  /// The maximum parallel workers per gather. Default is 2.
  final int maxParallelWorkersPerGather;

  /// Creates a new vector index query options object.
  const VectorIndexQueryOptions({
    this.enableIndexScan = true,
    this.enableSeqScan = true,
    this.minParallelTableScanSize = 1024,
    this.parallelSetupCost = 1000.0,
    this.maintenanceWorkMem = 65536,
    this.maxParallelMaintenanceWorkers = 2,
    this.maxParallelWorkersPerGather = 2,
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

/// Search path configuration for database schema resolution.
class SearchPathsConfig extends RuntimeParameters {
  /// The search paths for schema resolution on the database. Default is null (no override).
  final List<String>? searchPaths;

  /// Creates a new search path runtime parameters object.
  const SearchPathsConfig({
    this.searchPaths,
  }) : assert(searchPaths == null || searchPaths.length > 0,
            'Search paths cannot be empty.');

  @override
  Map<String, dynamic> get options => <String, dynamic>{
        'search_path': searchPaths,
      };
}

/// Automatically scan more of the index until enough results are found.
enum IterativeScan {
  /// No iterative scan, use the specified efSearch or probes.
  off,

  /// Strict ensures results are in the exact order by distance.
  strict,

  /// Relaxed allows results to be slightly out of order by distance, but
  /// provides better recall.
  relaxed,
}

extension on IterativeScan {
  /// The alias of the iterative scan mode on the database.
  String get alias => this == IterativeScan.off ? 'off' : '${name}_order';
}

/// Builder class for runtime parameters that provides discoverable factory methods.
/// This enables the callback pattern: setRuntimeParameters((params) => [...])
class RuntimeParametersBuilder {
  /// Creates HNSW index query options for vector similarity search. For more
  /// information on each parameter, refer to the [HnswIndexQueryOptions] class.
  HnswIndexQueryOptions hnswIndexQuery({
    int efSearch = 40,
    IterativeScan iterativeScan = IterativeScan.off,
    int maxScanTuples = 20000,
    int scanMemMultiplier = 1,
  }) =>
      HnswIndexQueryOptions(
        efSearch: efSearch,
        iterativeScan: iterativeScan,
        maxScanTuples: maxScanTuples,
        scanMemMultiplier: scanMemMultiplier,
      );

  /// Creates IVFFLAT index query options for vector similarity search. For more
  /// information on each parameter, refer to the [IvfflatIndexQueryOptions] class.
  IvfflatIndexQueryOptions ivfflatIndexQuery({
    int probes = 1,
    IterativeScan iterativeScan = IterativeScan.off,
    int maxProbes = 32768,
  }) =>
      IvfflatIndexQueryOptions(
        probes: probes,
        iterativeScan: iterativeScan,
        maxProbes: maxProbes,
      );

  /// Creates vector index query options for general vector operations. For more
  /// information on each parameter, refer to the [VectorIndexQueryOptions] class.
  VectorIndexQueryOptions vectorIndexQuery({
    bool enableIndexScan = true,
    bool enableSeqScan = true,
    int minParallelTableScanSize = 1024,
    double parallelSetupCost = 1000.0,
    int maintenanceWorkMem = 65536,
    int maxParallelMaintenanceWorkers = 2,
    int maxParallelWorkersPerGather = 2,
  }) =>
      VectorIndexQueryOptions(
        enableIndexScan: enableIndexScan,
        enableSeqScan: enableSeqScan,
        minParallelTableScanSize: minParallelTableScanSize,
        parallelSetupCost: parallelSetupCost,
        maintenanceWorkMem: maintenanceWorkMem,
        maxParallelMaintenanceWorkers: maxParallelMaintenanceWorkers,
        maxParallelWorkersPerGather: maxParallelWorkersPerGather,
      );

  /// Define search paths for database schema resolution. Set to null to revert
  /// to the default search paths.
  SearchPathsConfig searchPaths([
    List<String>? searchPaths,
  ]) =>
      SearchPathsConfig(
        searchPaths: searchPaths,
      );
}

/// A function that returns a list of [RuntimeParameters] for configuring
/// database runtime parameters.
typedef RuntimeParametersListBuilder = List<RuntimeParameters> Function(
  RuntimeParametersBuilder params,
);

/// Extension to add vector specific utilities to the database.
extension VectorDatabase on Database {
  /// Ensures that the vector extension is loaded in the database.
  /// This is useful to ensure that vector runtime parameters default values
  /// are available. Otherwise, if parameters are queried before the extension
  /// is loaded, they will return null, making the behavior unpredictable.
  Future<void> ensureVectorLoaded() {
    return unsafeQuery("SELECT '[1, 2, 3]'::vector AS vec");
  }
}
