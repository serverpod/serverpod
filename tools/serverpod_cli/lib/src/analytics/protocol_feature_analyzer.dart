import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Official Serverpod modules that may appear in analytics payloads.
const officialServerpodModules = {
  'serverpod_auth',
  'serverpod_auth_core',
  'serverpod_auth_idp',
  'serverpod_chat',
};

/// Canonical protocol/config capability tags for analytics.
const protocolFeatureTags = {
  'postgres',
  'postgres_embedded',
  'sqlite',
  'future_call',
  'streaming_endpoint',
  'login_required_endpoint',
  'sealed_model',
  'immutable_model',
  'list_relation',
  'object_relation',
  'foreign_relation',
};

class ProtocolAnalyticsSnapshot {
  const ProtocolAnalyticsSnapshot({
    required this.features,
    required this.serverpodModules,
    required this.counts,
  });

  final List<String> features;
  final List<String> serverpodModules;
  final Map<String, int> counts;
}

class ProtocolFeatureAnalyzer {
  static ProtocolAnalyticsSnapshot analyze({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
    Set<String>? serverPubspecDependencies,
  }) {
    return ProtocolAnalyticsSnapshot(
      features: _analyzeFeatures(
        protocolDefinition: protocolDefinition,
        config: config,
        serverPubspecDependencies: serverPubspecDependencies ?? const {},
      ),
      serverpodModules: _analyzeModules(config),
      counts: _analyzeCounts(protocolDefinition, config),
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
  ) {
    var enumCount = 0;
    var relationCount = 0;

    for (final model in protocolDefinition.models) {
      if (model is EnumDefinition) {
        enumCount += 1;
      }
      if (model is ModelClassDefinition) {
        for (final field in model.fields) {
          final relation = field.relation;
          if (relation != null) relationCount += 1;
        }
      }
    }

    return {
      'model_count': protocolDefinition.models.length,
      'endpoint_count': protocolDefinition.endpoints
          .where((endpoint) => !endpoint.isAbstract)
          .length,
      'enum_count': enumCount,
      'relation_count': relationCount,
      'future_call_count': protocolDefinition.futureCalls.length,
      'module_count': config.modulesDependent.length,
    };
  }

  static List<String> _analyzeFeatures({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
    required Set<String> serverPubspecDependencies,
  }) {
    final features = <String>{};

    if (config.isFeatureEnabled(ServerpodFeature.database)) {
      switch (config.databaseDialect) {
        case DatabaseDialect.postgres:
          features.add('postgres');
        case DatabaseDialect.sqlite:
          features.add('sqlite');
      }
    }

    if (serverPubspecDependencies.contains('serverpod_embedded_postgres')) {
      features.add('postgres_embedded');
    }

    if (protocolDefinition.futureCalls.isNotEmpty) {
      features.add('future_call');
    }

    for (final endpoint in protocolDefinition.endpoints) {
      if (endpoint.isAbstract) continue;
      for (final method in endpoint.methods) {
        if (method is MethodStreamDefinition) {
          features.add('streaming_endpoint');
        }
      }
    }

    for (final model in protocolDefinition.models) {
      if (model is! ModelClassDefinition) continue;
      if (model.isSealed) features.add('sealed_model');
      if (model.isImmutable) features.add('immutable_model');
      for (final field in model.fields) {
        final relation = field.relation;
        switch (relation) {
          case ListRelationDefinition():
            features.add('list_relation');
          case ObjectRelationDefinition():
            features.add('object_relation');
          case ForeignRelationDefinition():
            features.add('foreign_relation');
          default:
            break;
        }
      }
    }

    return features.where(protocolFeatureTags.contains).toList()..sort();
  }
}
