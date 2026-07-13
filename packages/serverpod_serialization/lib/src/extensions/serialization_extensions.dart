import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Expose static fromJson builder for bool that handles bool or int values.
/// Required to handle SQL boolean values that are stored as 0 or 1.
extension BoolJsonExtension on bool {
  /// Returns a deserialized version of the [bool].
  static bool fromJson(dynamic value) {
    if (value is bool) return value;
    if (value is int) {
      if (value != 0 && value != 1) {
        throw DeserializationTypeNotFoundException(
          message: 'Expected int to be 0 or 1, but got $value',
          type: int,
        );
      }
      return value == 1;
    }
    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }
}

/// Expose toJson on DateTime
/// Expose static fromJson builder
extension DateTimeJsonExtension on DateTime {
  /// Returns a deserialized version of the [DateTime].
  static DateTime fromJson(dynamic value) {
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }
    return DateTime.parse(value as String);
  }

  /// Returns a serialized version of the [DateTime] in UTC.
  String toJson() => toUtc().toIso8601String();
}

/// Expose toJson on Duration
/// Expose static fromJson builder
extension DurationJsonExtension on Duration {
  /// Returns a deserialized version of the [Duration].
  static Duration fromJson<T>(dynamic value) {
    if (value is Duration) return value;
    return Duration(milliseconds: value as int);
  }

  /// Returns a serialized version of the [Duration] in milliseconds.
  int toJson() => inMilliseconds;
}

/// Expose toJson on UuidValue
/// Expose static fromJson builder
extension UuidValueJsonExtension on UuidValue {
  /// Returns a deserialized version of the [UuidValue].
  static UuidValue fromJson(dynamic value) {
    if (value is UuidValue) return value;
    if (value is Uint8List) return UuidValue.fromByteList(value);
    return UuidValue.withValidation(value as String);
  }

  /// Returns a serialized version of the [UuidValue] as a [String].
  String toJson() => uuid;
}

/// Expose toJson on Uri
/// Expose static fromJson builder
extension UriJsonExtension on Uri {
  /// Returns a deserialized version of the [UuidValue].
  static Uri fromJson(dynamic value) {
    if (value is Uri) return value;
    return Uri.parse(value as String);
  }

  /// Returns a serialized version of the [Uri] as a [String].
  String toJson() => toString();
}

/// Expose toJson on BigInt
/// Expose static fromJson builder
extension BigIntJsonExtension on BigInt {
  /// Returns a deserialized version of the [BigInt].
  static BigInt fromJson(dynamic value) {
    if (value is BigInt) return value;
    return BigInt.parse(value as String);
  }

  /// Returns a serialized version of the [BigInt] as a [String].
  String toJson() => toString();
}

/// Expose toJson on ByteData
/// Expose static fromJson builder
extension ByteDataJsonExtension on ByteData {
  /// Returns a deserialized version of the [ByteData]
  static ByteData fromJson(dynamic value) {
    if (value is ByteData) return value;
    if (value is Uint8List) {
      return ByteData.view(
        value.buffer,
        value.offsetInBytes,
        value.lengthInBytes,
      );
    }

    return (value as String).base64DecodedNullSafeByteData();
  }

  /// Returns a serialized version of the [ByteData] as a base64 encoded
  /// [String].
  String toJson() => base64encodedString();
}

/// Expose toJson on Map
extension MapJsonExtension<K, V> on Map<K, V> {
  Type get _keyType => K;

  /// Returns a serialized version of the [Map] with keys and values serialized.
  dynamic toJson({
    dynamic Function(K)? keyToJson,
    dynamic Function(V)? valueToJson,
  }) {
    if (_keyType == String && keyToJson == null && valueToJson == null) {
      return this;
    }

    // This implementation is here to support the old decoder behavior
    // this should not be needed if the decoder is updated to not look for a nested
    // map with 'k' and 'v' keys. If that is done the return type can be changed
    // to Map<dynamic, dynamic>.
    if (_keyType != String) {
      return entries.map((e) {
        var serializedKey = keyToJson != null ? keyToJson(e.key) : e.key;
        var serializedValue = valueToJson != null
            ? valueToJson(e.value)
            : e.value;
        return {'k': serializedKey, 'v': serializedValue};
      }).toList();
    }

    return map((key, value) {
      var serializedKey = keyToJson != null ? keyToJson(key) : key;
      var serializedValue = valueToJson != null ? valueToJson(value) : value;
      return MapEntry(serializedKey, serializedValue);
    });
  }
}

/// Expose toJson on List
extension ListJsonExtension<T> on List<T> {
  /// Returns a serialized version of the [List] with values serialized.
  List<dynamic> toJson({dynamic Function(T)? valueToJson}) {
    if (valueToJson == null) return this;

    return map<dynamic>(valueToJson).toList();
  }
}

/// Expose toJson on Set
extension SetJsonExtension<T> on Set<T> {
  /// Returns a serialized version of the [Set] with values serialized.
  List<dynamic> toJson({dynamic Function(T)? valueToJson}) {
    if (valueToJson == null) return toList();

    return map<dynamic>(valueToJson).toList();
  }
}

/// Expose toJson on Vector
extension VectorJsonExtension on Vector {
  /// Returns a serialized version of the [Vector] with values serialized.
  static Vector fromJson(dynamic value) {
    if (value is Uint8List) return Vector.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return Vector(value.cast<double>());
    if (value is Vector) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [Vector] as a [List<double>].
  List<double> toJson() => toList();

  static Vector _fromString(String value) {
    return Vector((json.decode(value) as List).cast<double>());
  }
}

/// Expose toJson on HalfVector
extension HalfVectorJsonExtension on HalfVector {
  /// Returns a deserialized version of the [HalfVector] from various formats.
  static HalfVector fromJson(dynamic value) {
    if (value is Uint8List) return HalfVector.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return HalfVector(value.cast<double>());
    if (value is HalfVector) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [HalfVector] as a [List<double>].
  List<double> toJson() => toList();

  static HalfVector _fromString(String value) {
    return HalfVector((json.decode(value) as List).cast<double>());
  }
}

/// Expose toJson on SparseVector
extension SparseVectorJsonExtension on SparseVector {
  /// Returns a deserialized version of the [SparseVector] from various formats.
  static SparseVector fromJson(dynamic value) {
    if (value is Uint8List) return SparseVector.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return SparseVector(value.cast<double>());
    if (value is SparseVector) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [SparseVector] as a [String].
  String toJson() => toString();

  static SparseVector _fromString(String value) {
    // Handle string format like "{1:1.0,3:2.0,5:3.0}/6"
    if (value.startsWith('{') && value.contains('}/')) {
      return SparseVector.fromString(value);
    }
    return SparseVector((json.decode(value) as List).cast<double>());
  }
}

/// Expose toJson on Bit
extension BitJsonExtension on Bit {
  /// Returns a deserialized version of the [Bit] from various formats.
  static Bit fromJson(dynamic value) {
    if (value is Uint8List) return Bit.fromBinary(value);
    if (value is String) return _fromString(value);
    if (value is List) return _fromList(value);
    if (value is Bit) return value;

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [Bit] as a [String].
  String toJson() => toString();

  static Bit _fromList(List<dynamic> value) {
    return Bit(value.map((v) => v == 1 || v == true).toList());
  }

  static Bit _fromString(String value) {
    return value.contains('0') || value.contains('1')
        ? Bit.fromString(value)
        : _fromList(json.decode(value) as List);
  }
}

/// Expose toJson on [GeographyPoint] and a static fromJson builder.
extension GeographyPointJsonExtension on GeographyPoint {
  /// Returns a deserialized [GeographyPoint] from various formats.
  ///
  /// Handles:
  /// - [GeographyPoint] — returned as-is
  /// - [Uint8List] — decoded from EWKB binary (as returned by PostgreSQL)
  /// - [String] — decoded from EWKT (e.g. `SRID=4326;POINT(-0.12 51.5)`)
  /// - [Map] — decoded from a JSON map with longitude/latitude/srid keys
  static GeographyPoint fromJson(dynamic value) {
    if (value is GeographyPoint) return value;
    if (value is Uint8List) return GeographyPoint.fromBinary(value);
    if (value is String) return _fromEwkt(value);
    if (value is Map) {
      return GeographyPoint(
        longitude: (value['longitude'] as num).toDouble(),
        latitude: (value['latitude'] as num).toDouble(),
        srid: value['srid'] as int? ?? Geography.defaultSrid,
      );
    }
    throw ArgumentError(
      'Cannot deserialize ${value.runtimeType} as GeographyPoint',
    );
  }

  static GeographyPoint _fromEwkt(String value) {
    var s = value;
    var srid = Geography.defaultSrid;
    if (s.startsWith('SRID=')) {
      final semi = s.indexOf(';');
      srid = int.parse(s.substring(5, semi));
      s = s.substring(semi + 1);
    }
    final open = s.indexOf('(');
    final close = s.indexOf(')');
    final parts = s.substring(open + 1, close).split(' ');
    return GeographyPoint(
      longitude: double.parse(parts[0]),
      latitude: double.parse(parts[1]),
      srid: srid,
    );
  }

  /// Returns the EWKT representation as a [String].
  ///
  /// This is the format the PostgreSQL encoder uses when building INSERT/UPDATE
  /// SQL. The value flows through [TableRow.toJson] → encoder → SQL literal.
  String toJson() => toEwkt();
}

/// Expose toJson on [GeographyLineString] and a static fromJson builder.
extension GeographyLineStringJsonExtension on GeographyLineString {
  /// Returns a deserialized [GeographyLineString] from various formats.
  ///
  /// Handles:
  /// - [GeographyLineString] — returned as-is
  /// - [Uint8List] — decoded from EWKB binary (as returned by PostgreSQL)
  /// - [String] — decoded from EWKT (e.g. `SRID=4326;LINESTRING(0 0, 1 1)`)
  /// - [Map] — decoded from a JSON map with srid and points keys
  static GeographyLineString fromJson(dynamic value) {
    if (value is GeographyLineString) return value;
    if (value is Uint8List) return GeographyLineString.fromBinary(value);
    if (value is String) return _fromEwkt(value);
    if (value is Map) {
      final srid = value['srid'] as int? ?? Geography.defaultSrid;
      final rawPoints = value['points'] as List;
      final points = rawPoints.map((p) {
        final m = p as Map;
        return GeographyPoint(
          longitude: (m['longitude'] as num).toDouble(),
          latitude: (m['latitude'] as num).toDouble(),
          srid: srid,
        );
      }).toList();
      return GeographyLineString(points: points, srid: srid);
    }
    throw ArgumentError(
      'Cannot deserialize ${value.runtimeType} as GeographyLineString',
    );
  }

  static GeographyLineString _fromEwkt(String value) {
    var s = value;
    var srid = Geography.defaultSrid;
    if (s.startsWith('SRID=')) {
      final semi = s.indexOf(';');
      srid = int.parse(s.substring(5, semi));
      s = s.substring(semi + 1);
    }
    final open = s.indexOf('(');
    final close = s.lastIndexOf(')');
    final coordStr = s.substring(open + 1, close).trim();
    final points = coordStr.isEmpty
        ? <GeographyPoint>[]
        : coordStr.split(',').map((part) {
            final xy = part.trim().split(' ');
            return GeographyPoint(
              longitude: double.parse(xy[0]),
              latitude: double.parse(xy[1]),
              srid: srid,
            );
          }).toList();
    return GeographyLineString(points: points, srid: srid);
  }

  /// Returns the EWKT representation as a [String].
  String toJson() => toEwkt();
}

/// Expose toJson on [GeographyPolygon] and a static fromJson builder.
extension GeographyPolygonJsonExtension on GeographyPolygon {
  /// Returns a deserialized [GeographyPolygon] from various formats.
  ///
  /// Handles:
  /// - [GeographyPolygon] — returned as-is
  /// - [Uint8List] — decoded from EWKB binary (as returned by PostgreSQL)
  /// - [String] — decoded from EWKT
  /// - [Map] — decoded from a JSON map with srid, exteriorRing, holes keys
  static GeographyPolygon fromJson(dynamic value) {
    if (value is GeographyPolygon) return value;
    if (value is Uint8List) return GeographyPolygon.fromBinary(value);
    if (value is String) return _fromEwkt(value);
    if (value is Map) {
      final srid = value['srid'] as int? ?? Geography.defaultSrid;
      List<GeographyPoint> parseRing(List pts) => pts.map((p) {
        final m = p as Map;
        return GeographyPoint(
          longitude: (m['longitude'] as num).toDouble(),
          latitude: (m['latitude'] as num).toDouble(),
          srid: srid,
        );
      }).toList();
      final exterior = parseRing(value['exteriorRing'] as List);
      final holes = (value['holes'] as List? ?? [])
          .map((h) => parseRing(h as List))
          .toList();
      return GeographyPolygon(exteriorRing: exterior, holes: holes, srid: srid);
    }
    throw ArgumentError(
      'Cannot deserialize ${value.runtimeType} as GeographyPolygon',
    );
  }

  static GeographyPolygon _fromEwkt(String value) {
    var s = value;
    var srid = Geography.defaultSrid;
    if (s.startsWith('SRID=')) {
      final semi = s.indexOf(';');
      srid = int.parse(s.substring(5, semi));
      s = s.substring(semi + 1);
    }
    // Strip "POLYGON(" prefix and trailing ")"
    s = s.trim();
    final start = s.indexOf('(');
    s = s.substring(start + 1, s.length - 1);

    final rings = <List<GeographyPoint>>[];
    // Each ring is "(lon lat, ...)"
    var depth = 0;
    var ringStart = 0;
    for (var i = 0; i < s.length; i++) {
      if (s[i] == '(') {
        depth++;
        if (depth == 1) ringStart = i;
      } else if (s[i] == ')') {
        depth--;
        if (depth == 0) {
          final ringStr = s.substring(ringStart + 1, i);
          final points = ringStr.split(',').map((part) {
            final xy = part.trim().split(' ');
            return GeographyPoint(
              longitude: double.parse(xy[0]),
              latitude: double.parse(xy[1]),
              srid: srid,
            );
          }).toList();
          rings.add(points);
        }
      }
    }

    return GeographyPolygon(
      exteriorRing: rings.isNotEmpty ? rings[0] : const [],
      holes: rings.length > 1 ? rings.sublist(1) : const [],
      srid: srid,
    );
  }

  /// Returns the EWKT representation as a [String].
  String toJson() => toEwkt();
}

/// Expose toJson on [GeographyGeometryCollection] and a static fromJson builder.
extension GeographyGeometryCollectionJsonExtension
    on GeographyGeometryCollection {
  /// Returns a deserialized [GeographyGeometryCollection] from various formats.
  ///
  /// Handles:
  /// - [GeographyGeometryCollection] — returned as-is
  /// - [Uint8List] — decoded from EWKB binary (as returned by PostgreSQL)
  /// - [String] — decoded from EWKT
  /// - [Map] — decoded from a JSON map with srid and geometries keys
  static GeographyGeometryCollection fromJson(dynamic value) {
    if (value is GeographyGeometryCollection) return value;
    if (value is Uint8List) {
      return GeographyGeometryCollection.fromBinary(value);
    }
    if (value is String) return _fromEwkt(value);
    if (value is Map) {
      final srid = value['srid'] as int? ?? Geography.defaultSrid;
      // Each element is already a serialized geography (EWKT or map).
      final rawGeoms = value['geometries'] as List;
      final geoms = rawGeoms.map<Geography>((g) {
        if (g is String) return _geomFromEwktString(g);
        if (g is Map) return _geomFromMap(g);
        throw ArgumentError('Cannot deserialize geometry element: $g');
      }).toList();
      return GeographyGeometryCollection(geometries: geoms, srid: srid);
    }
    throw ArgumentError(
      'Cannot deserialize ${value.runtimeType} as GeographyGeometryCollection',
    );
  }

  static GeographyGeometryCollection _fromEwkt(String value) {
    var s = value;
    var srid = Geography.defaultSrid;
    if (s.startsWith('SRID=')) {
      final semi = s.indexOf(';');
      srid = int.parse(s.substring(5, semi));
      s = s.substring(semi + 1);
    }
    s = s.trim();
    final start = s.indexOf('(');
    final inner = s.substring(start + 1, s.length - 1).trim();
    final geoms = _splitTopLevel(
      inner,
    ).map((g) => _geomFromEwktString(g.trim())).toList();
    return GeographyGeometryCollection(geometries: geoms, srid: srid);
  }

  static Geography _geomFromEwktString(String s) {
    // Strip optional "SRID=xxx;" prefix before type-dispatching so that strings
    // like "SRID=4326;POINT(...)" are handled correctly.
    final body = s.contains(';') ? s.substring(s.indexOf(';') + 1).trim() : s;
    final upper = body.toUpperCase();
    if (upper.startsWith('POINT')) {
      return GeographyPointJsonExtension.fromJson(s);
    }
    if (upper.startsWith('LINESTRING')) {
      return GeographyLineStringJsonExtension.fromJson(s);
    }
    if (upper.startsWith('POLYGON')) {
      return GeographyPolygonJsonExtension.fromJson(s);
    }
    throw ArgumentError('Unsupported geometry type in EWKT: $s');
  }

  static Geography _geomFromMap(Map m) {
    final type = m['type'] as String?;
    switch (type) {
      case 'GeographyPoint':
        return GeographyPointJsonExtension.fromJson(m);
      case 'GeographyLineString':
        return GeographyLineStringJsonExtension.fromJson(m);
      case 'GeographyPolygon':
        return GeographyPolygonJsonExtension.fromJson(m);
      default:
        throw ArgumentError('Unknown geometry type map entry: $m');
    }
  }

  /// Splits a top-level comma-separated list, respecting nested parentheses.
  static List<String> _splitTopLevel(String s) {
    final parts = <String>[];
    var depth = 0;
    var start = 0;
    for (var i = 0; i < s.length; i++) {
      if (s[i] == '(') {
        depth++;
      } else if (s[i] == ')') {
        depth--;
      } else if (s[i] == ',' && depth == 0) {
        parts.add(s.substring(start, i));
        start = i + 1;
      }
    }
    if (start < s.length) parts.add(s.substring(start));
    return parts;
  }

  /// Returns the EWKT representation as a [String].
  String toJson() => toEwkt();
}
