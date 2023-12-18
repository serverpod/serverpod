import 'dart/definitions.dart';
import 'entities/definitions.dart';

/// Defines a projects protocol.
/// This does not include stuff the [ProtocolYamlFileAnalyzer] analyzed.
class ProtocolDefinition {
  /// The endpoints that are a part of this protocol.
  /// This does not include endpoints from other modules or package:serverpod.
  final List<EndpointDefinition> endpoints;

  final List<SerializableModelDefinition> entities;

  /// Create a new [ProtocolDefinition].
  const ProtocolDefinition({
    required this.endpoints,
    required this.entities,
  });
}
