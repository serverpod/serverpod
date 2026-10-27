import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Optional capability implemented by protocols generated with typed routing.
///
/// Older protocols need no changes and retain their original fallback behavior.
abstract interface class ProtocolDeserializationProvider
    implements SerializationManager {
  /// Immutable typed handlers and module order for this protocol.
  ProtocolDeserialization get deserializationMetadata;
}

/// Immutable type declarations used to avoid probing unrelated protocols.
///
/// Generated protocols declare every local typed handler, including nullable
/// and container types, and their dependencies in deserialization order.
/// This metadata never changes class names or caches deserialized values.
class ProtocolDeserialization {
  static final _declarations =
      Expando<
        ({
          List<Type Function()> types,
          List<SerializationManager Function()> modules,
          ProtocolDeserialization metadata,
        })
      >();

  final Set<Type> _types;

  /// Module protocols in their original fallback order.
  final List<SerializationManager> modules;

  final Map<Type, List<SerializationManager>> _routes = {};
  final Set<Type> _resolving = {};

  List<(ProtocolDeserializationProvider, ProtocolDeserialization)>?
  _dependencies;

  /// Creates metadata for a generated protocol whose final fallback is
  /// [SerializationManager.deserialize].
  ///
  /// [types] must contain every locally handled type. Modules without metadata
  /// remain eligible for every type, allowing independently regenerated modules.
  ProtocolDeserialization({
    required Iterable<Type> types,
    required List<SerializationManager> modules,
  }) : _types = Set.unmodifiable(types),
       modules = List.unmodifiable(modules);

  /// Reuses generated metadata until its declarations change on hot reload.
  ///
  /// Both lists must be constant lists of type and constructor tear-offs.
  /// Hot reload updates those constants while preserving [protocol], so a
  /// changed list replaces its metadata, including its cached module routes.
  factory ProtocolDeserialization.cached(
    SerializationManager protocol, {
    required List<Type Function()> types,
    required List<SerializationManager Function()> modules,
  }) {
    final previous = _declarations[protocol];

    if (previous != null &&
        identical(previous.types, types) &&
        identical(previous.modules, modules)) {
      return previous.metadata;
    }

    final metadata = ProtocolDeserialization(
      types: types.map((type) => type()),
      modules: modules.map((module) => module()).toList(),
    );

    _declarations[protocol] = (
      types: types,
      modules: modules,
      metadata: metadata,
    );

    return metadata;
  }

  /// Returns modules that may handle [type], preserving fallback order.
  ///
  /// Use the full [modules] list when routing by a class discriminator: an
  /// otherwise unrelated module may recognize that name. This method only
  /// answers questions about typed dispatch, independently of the payload.
  /// Cached routes are invalidated when any reachable module replaces its
  /// metadata, including modules previously excluded from the route.
  List<SerializationManager> modulesForType(Type type) {
    _refreshDependencies();

    return _routes.putIfAbsent(
      type,
      () {
        _resolving.add(type);
        try {
          return List.unmodifiable(
            modules.where((module) {
              return module is! ProtocolDeserializationProvider ||
                  module.deserializationMetadata._mayDeserialize(type);
            }),
          );
        } finally {
          _resolving.remove(type);
        }
      },
    );
  }

  void _refreshDependencies() {
    final previous = _dependencies;

    if (previous != null &&
        previous.every(
          (entry) => identical(entry.$1.deserializationMetadata, entry.$2),
        )) {
      return;
    }

    _routes.clear();

    final dependencies =
        <(ProtocolDeserializationProvider, ProtocolDeserialization)>[];
    final visited = Set<ProtocolDeserializationProvider>.identity();

    void visit(SerializationManager module) {
      if (module is! ProtocolDeserializationProvider || !visited.add(module)) {
        return;
      }

      final metadata = module.deserializationMetadata;
      dependencies.add((module, metadata));

      for (final dependency in metadata.modules) {
        visit(dependency);
      }
    }

    for (final module in modules) {
      visit(module);
    }

    _dependencies = dependencies;
  }

  bool _mayDeserialize(Type type) {
    return _types.contains(type) ||
        _primitiveTypes.contains(type) ||
        _resolving.contains(type) ||
        modulesForType(type).isNotEmpty;
  }

  // These are the final fallback handlers in SerializationManager.deserialize.
  static final Set<Type> _primitiveTypes = {
    int,
    getType<int?>(),
    double,
    getType<double?>(),
    String,
    getType<String?>(),
    bool,
    getType<bool?>(),
    DateTime,
    getType<DateTime?>(),
    ByteData,
    getType<ByteData?>(),
    Duration,
    getType<Duration?>(),
    UuidValue,
    getType<UuidValue?>(),
    Vector,
    getType<Vector?>(),
    HalfVector,
    getType<HalfVector?>(),
    SparseVector,
    getType<SparseVector?>(),
    Bit,
    getType<Bit?>(),
    GeographyPoint,
    getType<GeographyPoint?>(),
    GeographyLineString,
    getType<GeographyLineString?>(),
    GeographyPolygon,
    getType<GeographyPolygon?>(),
    GeographyGeometryCollection,
    getType<GeographyGeometryCollection?>(),
    Uri,
    getType<Uri?>(),
    BigInt,
    getType<BigInt?>(),
  };
}
