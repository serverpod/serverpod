import 'dart/definitions.dart';
import 'models/definitions.dart';

/// Defines a projects protocol.
/// This does not include stuff the [ProtocolYamlFileAnalyzer] analyzed.
class ProtocolDefinition {
  /// The endpoints that are a part of this protocol.
  /// This does not include endpoints from other modules or package:serverpod.
  final List<EndpointDefinition> endpoints;

  final List<SerializableModelDefinition> models;

  /// The future calls that are a part of this protocol.
  final List<FutureCallDefinition> futureCalls;

  /// The aliases of the module dependencies that have `database: sync` models,
  /// which are not part of [models].
  final Set<String> moduleAliasesWithSyncTables;

  /// Create a new [ProtocolDefinition].
  const ProtocolDefinition({
    required this.endpoints,
    required this.models,
    required this.futureCalls,
    this.moduleAliasesWithSyncTables = const {},
  });
}
