import 'package:uuid/uuid.dart';

import 'pgvector.dart';
import 'postgis.dart';

/// Base for generated `copyWith` defaults that distinguish omission from null.
///
/// Sentinels are generated-code infrastructure, not field values. Generated
/// code must check for them before accessing any members of the field's type.
abstract class UndefinedSentinel {
  /// Creates an undefined value for a generated `copyWith` parameter.
  const UndefinedSentinel();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('An undefined copyWith argument is not a value.');
}

/// An omitted list argument in generated `copyWith` methods.
class $UndefinedList<T> extends UndefinedSentinel implements List<T> {
  /// Creates an undefined list argument.
  const $UndefinedList();
}

/// An omitted map argument in generated `copyWith` methods.
class $UndefinedMap<K, V> extends UndefinedSentinel implements Map<K, V> {
  /// Creates an undefined map argument.
  const $UndefinedMap();
}

/// An omitted set argument in generated `copyWith` methods.
class $UndefinedSet<T> extends UndefinedSentinel implements Set<T> {
  /// Creates an undefined set argument.
  const $UndefinedSet();
}

/// An omitted date-time argument in generated `copyWith` methods.
class $UndefinedDateTime extends UndefinedSentinel implements DateTime {
  /// Creates an undefined date-time argument.
  const $UndefinedDateTime();
}

/// An omitted UUID argument in generated `copyWith` methods.
class $UndefinedUuidValue extends UndefinedSentinel implements UuidValue {
  /// Creates an undefined UUID argument.
  const $UndefinedUuidValue();
}

/// An omitted duration argument in generated `copyWith` methods.
class $UndefinedDuration extends UndefinedSentinel implements Duration {
  /// Creates an undefined duration argument.
  const $UndefinedDuration();
}

/// An omitted URI argument in generated `copyWith` methods.
class $UndefinedUri extends UndefinedSentinel implements Uri {
  /// Creates an undefined URI argument.
  const $UndefinedUri();
}

/// An omitted vector argument in generated `copyWith` methods.
class $UndefinedVector extends UndefinedSentinel implements Vector {
  /// Creates an undefined vector argument.
  const $UndefinedVector();
}

/// An omitted half-vector argument in generated `copyWith` methods.
class $UndefinedHalfVector extends UndefinedSentinel implements HalfVector {
  /// Creates an undefined half-vector argument.
  const $UndefinedHalfVector();
}

/// An omitted sparse-vector argument in generated `copyWith` methods.
class $UndefinedSparseVector extends UndefinedSentinel implements SparseVector {
  /// Creates an undefined sparse-vector argument.
  const $UndefinedSparseVector();
}

/// An omitted bit-vector argument in generated `copyWith` methods.
class $UndefinedBit extends UndefinedSentinel implements Bit {
  /// Creates an undefined bit-vector argument.
  const $UndefinedBit();
}

/// An omitted geography point argument in generated `copyWith` methods.
class $UndefinedGeographyPoint extends UndefinedSentinel
    implements GeographyPoint {
  /// Creates an undefined geography point argument.
  const $UndefinedGeographyPoint();
}

/// An omitted geography line-string argument in generated `copyWith` methods.
class $UndefinedGeographyLineString extends UndefinedSentinel
    implements GeographyLineString {
  /// Creates an undefined geography line-string argument.
  const $UndefinedGeographyLineString();
}

/// An omitted geography polygon argument in generated `copyWith` methods.
class $UndefinedGeographyPolygon extends UndefinedSentinel
    implements GeographyPolygon {
  /// Creates an undefined geography polygon argument.
  const $UndefinedGeographyPolygon();
}

/// An omitted geography collection argument in generated `copyWith` methods.
class $UndefinedGeographyGeometryCollection extends UndefinedSentinel
    implements GeographyGeometryCollection {
  /// Creates an undefined geography collection argument.
  const $UndefinedGeographyGeometryCollection();
}
