import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'server_config_features.dart';

/// Official Serverpod modules that may appear in analytics payloads.
///
/// Matched against [ModuleConfig.name], which is the server package name with
/// the `_server` suffix removed. Third-party and custom modules are counted in
/// `counts.module_count` but never named.
const officialServerpodModules = {
  'serverpod_auth',
  'serverpod_auth_bridge',
  'serverpod_auth_core',
  'serverpod_auth_idp',
  'serverpod_auth_migration',
  'serverpod_chat',
};

/// Prefix for index tags, completed with the index type as written in the model
/// (`index_gin`, `index_hnsw`, …).
///
/// The type is not checked against a copy of the supported list: the model
/// validator (`validateIndexType`) already rejects anything else, so a project
/// that reaches the generator cannot carry an unknown type, and a copy here
/// would only go stale when a new index type is added.
const indexTagPrefix = 'index_';

/// Canonical protocol/config capability tags for analytics.
///
/// A closed vocabulary — except for [indexTagPrefix] tags, whose suffix comes
/// from the already-validated model. [ProtocolFeatureAnalyzer] only emits tags
/// accepted by [isProtocolFeatureTag], so no user-authored name can reach
/// PostHog.
const protocolFeatureTags = <String>{
  // Database and server configuration.
  'postgres',
  'sqlite',
  ...ServerConfigFeatures.availableTags,
  // Endpoints.
  'future_call',
  'streaming_endpoint',
  'endpoint_inheritance',
  // Models.
  'sealed_model',
  'model_inheritance',
  'immutable_model',
  'server_only_model',
  'shared_model',
  'shared_table_model',
  'table_model',
  'client_database',
  'unmanaged_migration',
  // Exceptions, kept separate from models so the two adoption curves are not
  // merged into one.
  'exception_model',
  'sealed_exception',
  'exception_inheritance',
  // Enums.
  'enhanced_enum',
  // Fields.
  'server_only_field',
  'tail_field',
  'vector_field',
  'geography_field',
  // Relations.
  'list_relation',
  'object_relation',
  'foreign_relation',
  // Indexes.
  'unique_field',
  'unique_index',
  'unique_per_index',
};

/// Index type suffixes are lowercase identifiers by grammar.
final _indexTagPattern = RegExp('^$indexTagPrefix[a-z][a-z0-9_]{0,31}\$');

/// Whether [tag] may be sent as a `cli.generate` feature tag.
bool isProtocolFeatureTag(String tag) =>
    protocolFeatureTags.contains(tag) || _indexTagPattern.hasMatch(tag);

/// Keys of the `counts` map on `cli.generate`.
///
/// Project-level totals. Per-feature occurrence counts live in `feature_counts`
/// instead, keyed by the same tags as `features`.
const generateCountKeys = {
  'model_count',
  'table_model_count',
  'shared_model_count',
  'shared_table_model_count',
  'endpoint_count',
  'endpoint_method_count',
  'enum_count',
  'exception_count',
  'relation_count',
  'index_count',
  'future_call_count',
  'module_count',
};

class ProtocolAnalyticsSnapshot {
  const ProtocolAnalyticsSnapshot({
    required this.features,
    required this.featureCounts,
    required this.serverpodModules,
    required this.counts,
  });

  /// Sorted capability tags present in the project.
  final List<String> features;

  /// How many times each countable tag in [features] occurs, so a project with
  /// one sealed model is distinguishable from one built entirely on sealed
  /// hierarchies. Configuration tags (`postgres`, `redis`, …) are omitted:
  /// they are present or absent, never counted.
  final Map<String, int> featureCounts;

  final List<String> serverpodModules;
  final Map<String, int> counts;
}

class ProtocolFeatureAnalyzer {
  static ProtocolAnalyticsSnapshot analyze({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    final tally = _FeatureTally();

    if (config.isFeatureEnabled(ServerpodFeature.database)) {
      switch (config.databaseDialect) {
        case DatabaseDialect.postgres:
          tally.flag('postgres');
        case DatabaseDialect.sqlite:
          tally.flag('sqlite');
      }
    }

    for (final tag in ServerConfigFeatures.load(
      p.joinAll(config.serverPackageDirectoryPathParts),
    ).tags) {
      tally.flag(tag);
    }

    if (protocolDefinition.futureCalls.isNotEmpty) {
      tally.count('future_call', protocolDefinition.futureCalls.length);
    }
    if (protocolDefinition.models.hasHostClientDatabaseTables) {
      tally.flag('client_database');
    }

    _analyzeEndpoints(protocolDefinition, tally);
    _analyzeModels(protocolDefinition, tally);

    return ProtocolAnalyticsSnapshot(
      features: tally.tags,
      featureCounts: tally.counts,
      serverpodModules: _analyzeModules(config),
      counts: _analyzeCounts(protocolDefinition, config, tally),
    );
  }

  static List<String> _analyzeModules(GeneratorConfig config) {
    final modules = <String>{};
    for (final module in config.modulesDependent) {
      if (officialServerpodModules.contains(module.name)) {
        modules.add(module.name);
      }
    }
    return modules.toList()..sort();
  }

  static Map<String, int> _analyzeCounts(
    ProtocolDefinition protocolDefinition,
    GeneratorConfig config,
    _FeatureTally tally,
  ) {
    final endpoints = protocolDefinition.endpoints
        .where((endpoint) => !endpoint.isAbstract)
        .toList();

    return {
      'model_count': protocolDefinition.models
          .whereType<ModelClassDefinition>()
          .length,
      'table_model_count': tally.countOf('table_model'),
      'shared_model_count': tally.countOf('shared_model'),
      'shared_table_model_count': tally.countOf('shared_table_model'),
      'endpoint_count': endpoints.length,
      'endpoint_method_count': endpoints.fold<int>(
        0,
        (sum, endpoint) => sum + endpoint.methods.length,
      ),
      'enum_count': protocolDefinition.models
          .whereType<EnumDefinition>()
          .length,
      'exception_count': protocolDefinition.models
          .whereType<ExceptionClassDefinition>()
          .length,
      'relation_count':
          tally.countOf('list_relation') +
          tally.countOf('object_relation') +
          tally.countOf('foreign_relation'),
      'index_count': tally.totalWithPrefix(indexTagPrefix),
      'future_call_count': protocolDefinition.futureCalls.length,
      'module_count': config.modulesDependent.length,
    };
  }

  static void _analyzeEndpoints(
    ProtocolDefinition protocolDefinition,
    _FeatureTally tally,
  ) {
    for (final endpoint in protocolDefinition.endpoints) {
      if (endpoint.isAbstract) continue;
      if (endpoint.extendsClass != null) {
        tally.count('endpoint_inheritance');
      }
      final streams = endpoint.methods.whereType<MethodStreamDefinition>();
      if (streams.isNotEmpty) {
        tally.count('streaming_endpoint', streams.length);
      }
    }
  }

  static void _analyzeModels(
    ProtocolDefinition protocolDefinition,
    _FeatureTally tally,
  ) {
    for (final model in protocolDefinition.models) {
      if (model.serverOnly) tally.count('server_only_model');
      if (model.isSharedModel) tally.count('shared_model');

      switch (model) {
        case EnumDefinition():
          if (model.isEnhanced) tally.count('enhanced_enum');
        case ExceptionClassDefinition():
          tally.count('exception_model');
          if (model.isSealed) tally.count('sealed_exception');
          if (model.extendsClass != null) tally.count('exception_inheritance');
          _analyzeFields(model, tally);
        case ModelClassDefinition():
          if (model.isSealed) tally.count('sealed_model');
          if (model.extendsClass != null) tally.count('model_inheritance');
          if (model.isImmutable) tally.count('immutable_model');
          if (model.tableName != null) {
            tally.count('table_model');
            if (model.isSharedModel) tally.count('shared_table_model');
            if (!model.manageMigration) tally.count('unmanaged_migration');
          }
          for (final index in model.indexes) {
            tally.count('$indexTagPrefix${index.type}');
            if (index.unique) tally.count('unique_index');
            if (_isUniqueFieldShorthand(model, index)) {
              tally.count('unique_field');
            }
          }
          _analyzeFields(model, tally);
      }
    }
  }

  static void _analyzeFields(ClassDefinition model, _FeatureTally tally) {
    for (final field in model.fields) {
      if (field.isTail) tally.count('tail_field');
      if (field.scope == ModelFieldScopeDefinition.serverOnly) {
        tally.count('server_only_field');
      }
      // Shorthand unique indexes are already present in [model.indexes] after
      // parsing, so only the `per` capability remains field-specific here.
      // Counting the index and btree tag again would double both adoption and
      // `index_count`.
      if (field.uniquePerFieldNames?.isNotEmpty ?? false) {
        tally.count('unique_per_index');
      }
      if (field.type.isVectorType) tally.count('vector_field');
      if (field.type.isGeographyType) tally.count('geography_field');

      switch (field.relation) {
        case ListRelationDefinition():
          tally.count('list_relation');
        case ObjectRelationDefinition():
          tally.count('object_relation');
        case ForeignRelationDefinition():
          tally.count('foreign_relation');
        default:
          break;
      }
    }
  }

  static bool _isUniqueFieldShorthand(
    ModelClassDefinition model,
    SerializableModelIndexDefinition index,
  ) {
    if (index.type != 'btree' ||
        !index.unique ||
        index.fields.length != 1 ||
        model.tableName == null) {
      return false;
    }

    final expectedName =
        SerializableModelFieldDefinition.buildAutoGeneratedUniqueIndexName(
          model.tableName!,
          index.fields,
        );

    return index.name == expectedName;
  }
}

/// Accumulates capability tags and how often each occurs.
///
/// [flag] records presence only — for configuration a project either has or
/// does not. [count] records an occurrence. Both feed the same tag list, so
/// `features` and `feature_counts` can never disagree about what is present.
class _FeatureTally {
  final _flags = <String>{};
  final _counts = <String, int>{};

  void flag(String tag) {
    if (!isProtocolFeatureTag(tag)) return;
    _flags.add(tag);
  }

  void count(String tag, [int amount = 1]) {
    if (!isProtocolFeatureTag(tag)) return;
    _counts[tag] = (_counts[tag] ?? 0) + amount;
  }

  int countOf(String tag) => _counts[tag] ?? 0;

  int totalWithPrefix(String prefix) => _counts.entries
      .where((entry) => entry.key.startsWith(prefix))
      .fold<int>(0, (sum, entry) => sum + entry.value);

  List<String> get tags => {..._flags, ..._counts.keys}.toList()..sort();

  Map<String, int> get counts => Map.fromEntries(
    _counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}
