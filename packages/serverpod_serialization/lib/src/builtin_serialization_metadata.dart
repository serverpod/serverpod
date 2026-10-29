import 'dart:typed_data';

import 'package:meta/meta.dart' show internal;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Built-in types and wire names used by protocol route planning.
///
/// These declarations match the fallback handlers in [SerializationManager].
@internal
abstract final class BuiltinSerializationMetadata {
  static const _primitives = <_PrimitiveType<Object>>[
    _PrimitiveType<int>('int'),
    _PrimitiveType<double>('double'),
    _PrimitiveType<String>('String'),
    _PrimitiveType<bool>('bool'),
    _PrimitiveType<DateTime>('DateTime'),
    _PrimitiveType<ByteData>('ByteData'),
    _PrimitiveType<Duration>('Duration'),
    _PrimitiveType<UuidValue>('UuidValue'),
    _PrimitiveType<Uri>('Uri'),
    _PrimitiveType<BigInt>('BigInt'),
    _PrimitiveType<Vector>('Vector'),
    _PrimitiveType<HalfVector>('HalfVector'),
    _PrimitiveType<SparseVector>('SparseVector'),
    _PrimitiveType<Bit>('Bit'),
    _PrimitiveType<GeographyPoint>('GeographyPoint'),
    _PrimitiveType<GeographyLineString>('GeographyLineString'),
    _PrimitiveType<GeographyPolygon>('GeographyPolygon'),
    _PrimitiveType<GeographyGeometryCollection>('GeographyGeometryCollection'),
  ];

  static final _types = <Type>{
    for (final primitive in _primitives) primitive.type,
    for (final primitive in _primitives) primitive.nullableType,
  };

  static final _classNames = <String>{
    'null',
    for (final primitive in _primitives) primitive.className,
    'List',
    'Set',
    'Map',
  };

  /// Whether the base serialization manager handles [type].
  static bool supportsType(Type type) => _types.contains(type);

  /// Whether the base serialization manager recognizes [className].
  static bool supportsClassName(String className) =>
      _classNames.contains(className);
}

final class _PrimitiveType<T extends Object> {
  final String className;

  const _PrimitiveType(this.className);

  Type get type => T;

  Type get nullableType => getType<T?>();
}
