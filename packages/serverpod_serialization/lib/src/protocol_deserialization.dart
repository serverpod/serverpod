import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'builtin_serialization_metadata.dart';

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
          List<String>? classNames,
          String? classNamePrefix,
          ProtocolDeserialization metadata,
        })
      >();

  final Set<Type> _types;
  final Set<String>? _classNames;
  final String? _classNamePrefix;

  /// Module protocols in their original fallback order.
  final List<SerializationManager> modules;

  final Map<Type, List<SerializationManager>> _routes = {};
  final Map<(Type, String), List<SerializationManager>> _classRoutes = {};
  final Set<(Type, String?)> _resolving = {};

  // Discriminators come from payloads, so their cache must remain bounded.
  static const _maxClassRoutes = 1024;

  List<(ProtocolDeserializationProvider, ProtocolDeserialization)>?
  _dependencies;

  /// Creates metadata for a generated protocol whose final fallback is
  /// [SerializationManager.deserialize].
  ///
  /// [types] must contain every locally handled type. Modules without metadata
  /// remain eligible for every type, allowing independently regenerated modules.
  /// [classNames] declares the local names accepted by class-name dispatch.
  /// Omit it for older or custom protocols whose accepted names are unknown.
  /// [classNamePrefix] is the prefix stripped by this protocol from object JSON,
  /// including the trailing dot, or null if the protocol does not strip one.
  ProtocolDeserialization({
    required Iterable<Type> types,
    required List<SerializationManager> modules,
    Iterable<String>? classNames,
    this._classNamePrefix,
  }) : _types = Set.unmodifiable(types),
       _classNames = classNames == null ? null : Set.unmodifiable(classNames),
       modules = List.unmodifiable(modules);

  /// Reuses generated metadata until its declarations change on hot reload.
  ///
  /// Lists must be constant lists of type tear-offs, constructor tear-offs,
  /// and class names respectively.
  /// Hot reload updates those constants while preserving [protocol], so a
  /// changed list replaces its metadata, including its cached module routes.
  factory ProtocolDeserialization.cached(
    SerializationManager protocol, {
    required List<Type Function()> types,
    required List<SerializationManager Function()> modules,
    List<String>? classNames,
    String? classNamePrefix,
  }) {
    final previous = _declarations[protocol];

    if (previous != null &&
        identical(previous.types, types) &&
        identical(previous.modules, modules) &&
        identical(previous.classNames, classNames) &&
        previous.classNamePrefix == classNamePrefix) {
      return previous.metadata;
    }

    final metadata = ProtocolDeserialization(
      types: types.map((type) => type()),
      modules: modules.map((module) => module()).toList(),
      classNames: classNames,
      classNamePrefix: classNamePrefix,
    );

    _declarations[protocol] = (
      types: types,
      modules: modules,
      classNames: classNames,
      classNamePrefix: classNamePrefix,
      metadata: metadata,
    );

    return metadata;
  }

  /// Returns modules that may handle [type], preserving fallback order.
  ///
  /// For payloads with a class discriminator, use [modulesForDeserialization]
  /// instead: an otherwise unrelated module may recognize that name.
  /// Cached routes are invalidated when any reachable module replaces its
  /// metadata, including modules previously excluded from the route.
  List<SerializationManager> modulesForType(Type type) {
    return modulesForDeserialization(type);
  }

  /// Returns modules that may decode [type] or the payload's [className].
  ///
  /// Candidates retain their original order. A recognized discriminator may
  /// select a subtype or satisfy an Object/dynamic request; an unrecognized
  /// discriminator may still fall back to the expected type. Older protocols
  /// without class-name declarations remain eligible for tagged payloads.
  /// Pass the original discriminator from object JSON: each candidate applies
  /// its own prefix normalization, just as it does when decoding that JSON.
  List<SerializationManager> modulesForDeserialization(
    Type type, {
    String? className,
  }) {
    _refreshDependencies();

    final key = (type, className);
    final cached = className == null ? _routes[type] : _classRoutes[key];
    if (cached != null) return cached;

    _resolving.add(key);
    try {
      final result = List<SerializationManager>.unmodifiable(
        modules.where((module) {
          return module is! ProtocolDeserializationProvider ||
              module.deserializationMetadata._mayDeserialize(type, className);
        }),
      );

      if (className == null) {
        _routes[type] = result;
      } else {
        if (_classRoutes.length >= _maxClassRoutes) {
          _classRoutes.remove(_classRoutes.keys.first);
        }
        _classRoutes[(type, className)] = result;
      }

      return result;
    } finally {
      _resolving.remove(key);
    }
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
    _classRoutes.clear();

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

  /// Reads the original class discriminator without removing a module prefix.
  ///
  /// Returns null for non-map values or a missing discriminator. A discriminator
  /// with a non-string value throws a type error, as generated protocols do.
  static String? readClassName(dynamic data) {
    if (data is! Map) return null;

    return data['__className__'] as String?;
  }

  /// Removes at most one occurrence of this protocol's [prefix].
  ///
  /// Pass the original discriminator to each protocol. A name normalized for
  /// one protocol must not be used to plan another protocol's decoding route.
  static String? normalizeClassName(String? className, {String? prefix}) {
    if (className != null && prefix != null && className.startsWith(prefix)) {
      return className.substring(prefix.length);
    }

    return className;
  }

  bool _mayDeserialize(Type type, String? className) {
    final localClassName = normalizeClassName(
      className,
      prefix: _classNamePrefix,
    );
    return _types.contains(type) ||
        BuiltinSerializationMetadata.supportsType(type) ||
        (localClassName != null &&
            (_classNames == null ||
                _classNames.contains(localClassName) ||
                BuiltinSerializationMetadata.supportsClassName(
                  localClassName,
                ))) ||
        _resolving.contains((type, className)) ||
        modulesForDeserialization(type, className: className).isNotEmpty;
  }
}
