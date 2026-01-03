import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Expose toJson on DateTime
/// Expose static fromJson builder
extension DateTimeJsonExtension on DateTime {
  /// Returns a deserialized version of the [DateTime].
  static DateTime fromJson(dynamic value) {
    if (value is DateTime) return value;
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

/// Expose toJson on PostgisPoint
/// Expose static fromJson builder
extension GeographyPointJsonExtension on GeographyPoint {
  /// Returns a deserialized version of the [GeographyPoint].
  static GeographyPoint fromJson(dynamic value) {
    if (value is GeographyPoint) return value;

    if (value is String) return _fromString(value);

    if (value is List) return _fromList(value);

    if (value is Map) return _fromMap(value as Map<String, dynamic>);

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [GeographyPoint] as a GeoJSON-like map.
  Map<String, dynamic> toJson() => {
    'type': 'Point',
    'coordinates': [longitude, latitude],
  };

  /// Returns a serialized version suitable for protocol transport.
  Map<String, dynamic> toJsonForProtocol() => toJson();

  static GeographyPoint _fromList(List<dynamic> list) {
    return GeographyPoint(
      (list[0] as num).toDouble(),
      (list[1] as num).toDouble(),
    );
  }

  static GeographyPoint _fromMap(Map<String, dynamic> map) {
    if (map.containsKey('coordinates')) {
      var coords = map['coordinates'];
      if (coords is List && coords.length >= 2) {
        return _fromList(coords);
      }
    }

    if (map.containsKey('longitude') && map.containsKey('latitude')) {
      return GeographyPoint(
        (map['longitude'] as num).toDouble(),
        (map['latitude'] as num).toDouble(),
      );
    }

    if (map.containsKey('lon') && map.containsKey('lat')) {
      return GeographyPoint(
        (map['lon'] as num).toDouble(),
        (map['lat'] as num).toDouble(),
      );
    }

    if (map.containsKey('x') && map.containsKey('y')) {
      return GeographyPoint(
        (map['x'] as num).toDouble(),
        (map['y'] as num).toDouble(),
      );
    }

    throw DeserializationTypeNotFoundException(type: map.runtimeType);
  }

  static GeographyPoint _fromString(String value) {
    value = value.trim();

    // Handle WKT POINT(x y) or SRID=4326;POINT(x y)
    if (value.toUpperCase().contains('POINT')) {
      return GeographyPoint.fromWkt(value);
    }

    // Try JSON decode
    try {
      var decoded = json.decode(value);
      if (decoded is List) return _fromList(decoded);
      if (decoded is Map) return _fromMap(decoded.cast<String, dynamic>());
    } catch (_) {}

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }
}

/// Expose toJson on PostgisPolygon
/// Expose static fromJson builder
extension GeographyPolygonJsonExtension on GeographyPolygon {
  /// Returns a deserialized version of the [GeographyPolygon].
  static GeographyPolygon fromJson(dynamic value) {
    if (value is GeographyPolygon) return value;

    if (value is String) return _fromString(value);

    if (value is List) return _fromList(value);

    if (value is Map) return _fromMap(value as Map<String, dynamic>);

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [GeographyPolygon] as a GeoJSON-like map.
  Map<String, dynamic> toJson() => {
    'type': 'Polygon',
    'coordinates': rings
        .map((r) => r.map((p) => [p.longitude, p.latitude]).toList())
        .toList(),
    if (srid != null) 'srid': srid,
  };

  /// Returns a serialized version suitable for protocol transport.
  Map<String, dynamic> toJsonForProtocol() => toJson();

  static GeographyPolygon _fromList(List<dynamic> list) {
    // Support multiple input shapes:
    // - List of rings: [ [ [x,y], [x,y], ... ], [ ... ] ]
    // - Single ring as flat list of numbers: [x,y,x,y,...]
    // - Ring as flat list of numbers inside a ring: [ [x,y,x,y,...] ]
    if (list.isNotEmpty && list.every((e) => e is num)) {
      final coords = list.cast<num>();
      final pts = <GeographyPoint>[];
      for (var i = 0; i + 1 < coords.length; i += 2) {
        pts.add(GeographyPoint(coords[i].toDouble(), coords[i + 1].toDouble()));
      }
      return GeographyPolygon([pts]);
    }

    final rings = list.map<List<GeographyPoint>>((r) {
      if (r is List) {
        // If the ring itself is a flat list of numbers, pair them up.
        if (r.isNotEmpty && r.every((e) => e is num)) {
          final coords = r.cast<num>();
          final pts = <GeographyPoint>[];
          for (var i = 0; i + 1 < coords.length; i += 2) {
            pts.add(
              GeographyPoint(coords[i].toDouble(), coords[i + 1].toDouble()),
            );
          }
          return pts;
        }

        return r.map<GeographyPoint>((pt) {
          if (pt is GeographyPoint) return pt;
          if (pt is List) {
            return GeographyPoint(
              (pt[0] as num).toDouble(),
              (pt[1] as num).toDouble(),
            );
          }
          if (pt is Map) {
            return GeographyPoint.fromJson(pt.cast<String, dynamic>());
          }
          throw DeserializationTypeNotFoundException(type: pt.runtimeType);
        }).toList();
      }
      throw DeserializationTypeNotFoundException(type: r.runtimeType);
    }).toList();

    return GeographyPolygon(rings);
  }

  static GeographyPolygon _fromMap(Map<String, dynamic> map) {
    final srid = map['srid'] as int?;
    dynamic ringsData;
    if (map.containsKey('rings')) {
      ringsData = map['rings'];
    } else if (map.containsKey('coordinates')) {
      ringsData = map['coordinates'];
    } else {
      throw DeserializationTypeNotFoundException(type: map.runtimeType);
    }

    if (ringsData is List) {
      final rings = ringsData.map<List<GeographyPoint>>((r) {
        if (r is List) {
          return r.map<GeographyPoint>((pt) {
            if (pt is GeographyPoint) return pt;
            if (pt is List) {
              return GeographyPoint(
                (pt[0] as num).toDouble(),
                (pt[1] as num).toDouble(),
              );
            }
            if (pt is Map) {
              return GeographyPoint.fromJson(pt.cast<String, dynamic>());
            }
            throw DeserializationTypeNotFoundException(type: pt.runtimeType);
          }).toList();
        }
        throw DeserializationTypeNotFoundException(type: r.runtimeType);
      }).toList();

      return GeographyPolygon(rings, srid: srid);
    }

    throw DeserializationTypeNotFoundException(type: map.runtimeType);
  }

  static GeographyPolygon _fromString(String value) {
    value = value.trim();

    // Handle WKT POLYGON(...) or SRID=...;POLYGON(...)
    if (value.toUpperCase().startsWith('POLYGON') ||
        value.toUpperCase().startsWith('SRID=')) {
      try {
        return GeographyPolygon.fromWkt(value);
      } catch (_) {}
    }

    // Try JSON decode
    try {
      var decoded = json.decode(value);
      if (decoded is List) return _fromList(decoded);
      if (decoded is Map) return _fromMap(decoded.cast<String, dynamic>());
    } catch (_) {}

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }
}

/// Expose toJson on PostgisMultiPolygon
/// Expose static fromJson builder
extension GeographyMultiPolygonJsonExtension on GeographyMultiPolygon {
  /// Returns a deserialized version of the [GeographyMultiPolygon].
  static GeographyMultiPolygon fromJson(dynamic value) {
    if (value is GeographyMultiPolygon) return value;

    if (value is String) return _fromString(value);

    if (value is List) return _fromList(value);

    if (value is Map) return _fromMap(value as Map<String, dynamic>);

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [GeographyMultiPolygon] as a GeoJSON-like map.
  Map<String, dynamic> toJson() => {
    'type': 'MultiPolygon',
    'coordinates': polygons
        .map(
          (p) => p.rings
              .map((r) => r.map((pt) => [pt.longitude, pt.latitude]).toList())
              .toList(),
        )
        .toList(),
    if (srid != null) 'srid': srid,
  };

  /// Returns a serialized version suitable for protocol transport.
  Map<String, dynamic> toJsonForProtocol() => toJson();

  static GeographyMultiPolygon _fromList(List<dynamic> list) {
    // Robustly interpret a variety of shapes returned by drivers:
    // - list of polygons: [ polygon1, polygon2, ... ]
    // - polygon as a flat numeric list: [x,y,x,y,...]
    // - mixed lists where numeric runs represent a polygon
    final polys = <GeographyPolygon>[];

    GeographyPolygon parsePolygonFromDynamic(dynamic p) {
      if (p is GeographyPolygon) return p;
      if (p is Map) return GeographyPolygon.fromJson(p.cast<String, dynamic>());
      if (p is List) {
        // Flat numeric list -> single ring
        if (p.isNotEmpty && p.every((e) => e is num)) {
          final coords = p.cast<num>();
          final pts = <GeographyPoint>[];
          for (var i = 0; i + 1 < coords.length; i += 2) {
            pts.add(
              GeographyPoint(coords[i].toDouble(), coords[i + 1].toDouble()),
            );
          }
          return GeographyPolygon([pts]);
        }

        // Otherwise interpret as list of rings
        final rings = p.map<List<GeographyPoint>>((r) {
          if (r is List) {
            if (r.isNotEmpty && r.every((e) => e is num)) {
              final coords = r.cast<num>();
              final pts = <GeographyPoint>[];
              for (var i = 0; i + 1 < coords.length; i += 2) {
                pts.add(
                  GeographyPoint(
                    coords[i].toDouble(),
                    coords[i + 1].toDouble(),
                  ),
                );
              }
              return pts;
            }

            return r.map<GeographyPoint>((pt) {
              if (pt is GeographyPoint) return pt;
              if (pt is List) {
                return GeographyPoint(
                  (pt[0] as num).toDouble(),
                  (pt[1] as num).toDouble(),
                );
              }
              if (pt is Map) {
                return GeographyPoint.fromJson(pt.cast<String, dynamic>());
              }
              throw DeserializationTypeNotFoundException(type: pt.runtimeType);
            }).toList();
          }
          throw DeserializationTypeNotFoundException(type: r.runtimeType);
        }).toList();

        return GeographyPolygon(rings);
      }

      throw DeserializationTypeNotFoundException(type: p.runtimeType);
    }

    var i = 0;
    while (i < list.length) {
      final item = list[i];
      if (item is num) {
        // Accumulate contiguous numeric values into a flat polygon (single ring)
        final nums = <num>[];
        while (i < list.length && list[i] is num) {
          nums.add(list[i] as num);
          i++;
        }
        if (nums.length >= 2) {
          final pts = <GeographyPoint>[];
          for (var j = 0; j + 1 < nums.length; j += 2) {
            pts.add(GeographyPoint(nums[j].toDouble(), nums[j + 1].toDouble()));
          }
          polys.add(GeographyPolygon([pts]));
          continue;
        }
        // Single stray number: skip it
        continue;
      }

      if (item is List || item is Map || item is GeographyPolygon) {
        polys.add(parsePolygonFromDynamic(item));
        i++;
        continue;
      }

      // Unknown element type: try to parse as polygon or skip
      try {
        polys.add(parsePolygonFromDynamic(item));
      } catch (_) {
        // Skip unknown element types to be forgiving
      }
      i++;
    }

    return GeographyMultiPolygon(polys);
  }

  static GeographyMultiPolygon _fromMap(Map<String, dynamic> map) {
    final srid = map['srid'] as int?;

    if (map.containsKey('polygons')) {
      final polysRaw = map['polygons'];
      if (polysRaw is List) {
        final polys = polysRaw.map<GeographyPolygon>((p) {
          if (p is GeographyPolygon) return p;
          if (p is Map) {
            return GeographyPolygon.fromJson(p.cast<String, dynamic>());
          }
          throw DeserializationTypeNotFoundException(type: p.runtimeType);
        }).toList();
        return GeographyMultiPolygon(polys, srid: srid);
      }
    }

    if (map.containsKey('coordinates')) {
      final coords = map['coordinates'];
      if (coords is List) {
        final polys = coords.map<GeographyPolygon>((polyCoords) {
          if (polyCoords is List) {
            // Support both nested rings ([[[x,y],...],...]) and flat numeric arrays for a polygon
            // e.g. polygon coordinates might be a flat list [x,y,x,y,...] representing a single ring
            if (polyCoords.isNotEmpty && polyCoords.every((e) => e is num)) {
              final coords = polyCoords.cast<num>();
              final pts = <GeographyPoint>[];
              for (var i = 0; i + 1 < coords.length; i += 2) {
                pts.add(
                  GeographyPoint(
                    coords[i].toDouble(),
                    coords[i + 1].toDouble(),
                  ),
                );
              }
              return GeographyPolygon([pts]);
            }

            final rings = polyCoords.map<List<GeographyPoint>>((ringCoords) {
              if (ringCoords is List) {
                // If the ring is a flat list of numbers, pair them up.
                if (ringCoords.isNotEmpty &&
                    ringCoords.every((e) => e is num)) {
                  final coords = ringCoords.cast<num>();
                  final pts = <GeographyPoint>[];
                  for (var i = 0; i + 1 < coords.length; i += 2) {
                    pts.add(
                      GeographyPoint(
                        coords[i].toDouble(),
                        coords[i + 1].toDouble(),
                      ),
                    );
                  }
                  return pts;
                }

                return ringCoords.map<GeographyPoint>((pt) {
                  if (pt is List) {
                    return GeographyPoint(
                      (pt[0] as num).toDouble(),
                      (pt[1] as num).toDouble(),
                    );
                  }
                  if (pt is Map) {
                    return GeographyPoint.fromJson(pt.cast<String, dynamic>());
                  }
                  throw DeserializationTypeNotFoundException(
                    type: pt.runtimeType,
                  );
                }).toList();
              }
              throw DeserializationTypeNotFoundException(
                type: ringCoords.runtimeType,
              );
            }).toList();
            return GeographyPolygon(rings);
          }
          throw DeserializationTypeNotFoundException(
            type: polyCoords.runtimeType,
          );
        }).toList();

        return GeographyMultiPolygon(polys, srid: srid);
      }
    }

    throw DeserializationTypeNotFoundException(type: map.runtimeType);
  }

  static GeographyMultiPolygon _fromString(String value) {
    value = value.trim();

    // Handle WKT MULTIPOLYGON(...) or SRID=...;MULTIPOLYGON(...)
    if (value.toUpperCase().startsWith('MULTIPOLYGON') ||
        value.toUpperCase().startsWith('SRID=')) {
      try {
        return GeographyMultiPolygon.fromWkt(value);
      } catch (_) {}
    }

    // Try JSON decode
    try {
      var decoded = json.decode(value);
      if (decoded is List) return _fromList(decoded);
      if (decoded is Map) return _fromMap(decoded.cast<String, dynamic>());
    } catch (_) {}

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }
}

/// Expose toJson on PostgisLineString
/// Expose static fromJson builder
extension GeographyLineStringJsonExtension on GeographyLineString {
  /// Returns a deserialized version of the [GeographyLineString].
  static GeographyLineString fromJson(dynamic value) {
    if (value is GeographyLineString) return value;

    if (value is String) return _fromString(value);

    if (value is List) return _fromList(value);

    if (value is Map) return _fromMap(value as Map<String, dynamic>);

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }

  /// Returns a serialized version of the [GeographyLineString] as a GeoJSON-like map.
  Map<String, dynamic> toJson() => {
    'type': 'LineString',
    'coordinates': points.map((p) => [p.longitude, p.latitude]).toList(),
    if (srid != null) 'srid': srid,
  };

  /// Returns a serialized version suitable for protocol transport.
  Map<String, dynamic> toJsonForProtocol() => toJson();

  static GeographyLineString _fromList(List<dynamic> list) {
    // Support flat numeric arrays [x,y,x,y,...] as well as lists of points
    if (list.isNotEmpty && list.every((e) => e is num)) {
      final coords = list.cast<num>();
      final pts = <GeographyPoint>[];
      for (var i = 0; i + 1 < coords.length; i += 2) {
        pts.add(GeographyPoint(coords[i].toDouble(), coords[i + 1].toDouble()));
      }
      return GeographyLineString(pts);
    }

    // If a MultiLineString-like structure is passed (list of lines), take the first line
    // Example: [ [ [x,y], [x,y] ], [ [x,y], [x,y] ] ]
    if (list.isNotEmpty &&
        list.first is List &&
        (list.first as List).isNotEmpty &&
        (list.first as List).first is List) {
      final firstLine = (list.first as List).cast<dynamic>();
      final pts = firstLine.map<GeographyPoint>((p) {
        if (p is GeographyPoint) return p;
        if (p is List) {
          return GeographyPoint(
            (p[0] as num).toDouble(),
            (p[1] as num).toDouble(),
          );
        }
        if (p is Map) return GeographyPoint.fromJson(p.cast<String, dynamic>());
        throw DeserializationTypeNotFoundException(type: p.runtimeType);
      }).toList();
      return GeographyLineString(pts);
    }

    final pts = list.map<GeographyPoint>((p) {
      if (p is GeographyPoint) return p;
      if (p is List) {
        return GeographyPoint(
          (p[0] as num).toDouble(),
          (p[1] as num).toDouble(),
        );
      }
      if (p is Map) return GeographyPoint.fromJson(p.cast<String, dynamic>());
      throw DeserializationTypeNotFoundException(type: p.runtimeType);
    }).toList();

    return GeographyLineString(pts);
  }

  static GeographyLineString _fromMap(Map<String, dynamic> map) {
    final srid = map['srid'] as int?;

    if (map.containsKey('points')) {
      final ptsRaw = map['points'];
      if (ptsRaw is List) {
        final pts = ptsRaw.map<GeographyPoint>((p) {
          if (p is GeographyPoint) return p;
          if (p is Map) {
            return GeographyPoint.fromJson(p.cast<String, dynamic>());
          }
          throw DeserializationTypeNotFoundException(type: p.runtimeType);
        }).toList();
        return GeographyLineString(pts, srid: srid);
      }
    }

    if (map.containsKey('coordinates')) {
      final coords = map['coordinates'];
      if (coords is List) {
        // If coordinates is a flat list of numbers, pair them up.
        if (coords.isNotEmpty && coords.every((e) => e is num)) {
          final flat = coords.cast<num>();
          final pts = <GeographyPoint>[];
          for (var i = 0; i + 1 < flat.length; i += 2) {
            pts.add(GeographyPoint(flat[i].toDouble(), flat[i + 1].toDouble()));
          }
          return GeographyLineString(pts, srid: srid);
        }

        // Handle MultiLineString-style coordinates: list of lines -> take first line
        if (coords.isNotEmpty &&
            coords.first is List &&
            (coords.first as List).isNotEmpty &&
            (coords.first as List).first is List) {
          final firstLine = (coords.first as List).cast<dynamic>();
          final pts = firstLine.map<GeographyPoint>((c) {
            if (c is List) {
              return GeographyPoint(
                (c[0] as num).toDouble(),
                (c[1] as num).toDouble(),
              );
            }
            if (c is Map) {
              return GeographyPoint.fromJson(c.cast<String, dynamic>());
            }
            throw DeserializationTypeNotFoundException(type: c.runtimeType);
          }).toList();
          return GeographyLineString(pts, srid: srid);
        }

        final pts = coords.map<GeographyPoint>((c) {
          if (c is List) {
            return GeographyPoint(
              (c[0] as num).toDouble(),
              (c[1] as num).toDouble(),
            );
          }
          if (c is Map) {
            return GeographyPoint.fromJson(c.cast<String, dynamic>());
          }
          throw DeserializationTypeNotFoundException(type: c.runtimeType);
        }).toList();
        return GeographyLineString(pts, srid: srid);
      }
    }

    throw DeserializationTypeNotFoundException(type: map.runtimeType);
  }

  static GeographyLineString _fromString(String value) {
    value = value.trim();

    // Handle WKT LINESTRING(...) or SRID=...;LINESTRING(...)
    if (value.toUpperCase().startsWith('LINESTRING') ||
        value.toUpperCase().startsWith('SRID=')) {
      try {
        return GeographyLineString.fromWkt(value);
      } catch (_) {}
    }

    // Try JSON decode
    try {
      var decoded = json.decode(value);
      if (decoded is List) return _fromList(decoded);
      if (decoded is Map) return _fromMap(decoded.cast<String, dynamic>());
    } catch (_) {}

    throw DeserializationTypeNotFoundException(type: value.runtimeType);
  }
}
