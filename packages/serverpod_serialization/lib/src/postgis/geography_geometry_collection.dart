import 'dart:typed_data';

import 'geography.dart';
import 'geography_line_string.dart';
import 'geography_point.dart';
import 'geography_polygon.dart';

/// Represents a PostGIS GeometryCollection — a heterogeneous collection of
/// [Geography] values (points, line strings, polygons).
class GeographyGeometryCollection implements Geography {
  /// The geometries in this collection.
  final List<Geography> geometries;

  /// Spatial reference system identifier. Defaults to WGS 84 (EPSG:4326).
  @override
  final int srid;

  /// Creates a new [GeographyGeometryCollection].
  const GeographyGeometryCollection({
    required this.geometries,
    this.srid = 4326,
  });

  /// Creates a [GeographyGeometryCollection] from its EWKB binary
  /// representation as returned by PostgreSQL for geography columns.
  factory GeographyGeometryCollection.fromBinary(Uint8List bytes) {
    final reader = _WkbParser(bytes);
    final result = reader.readGeometry();
    if (result is! GeographyGeometryCollection) {
      throw ArgumentError(
        'Expected GeometryCollection WKB but got ${result.runtimeType}',
      );
    }
    return result;
  }

  @override
  String toEwkt() {
    // Sub-geometries are written without their SRID prefix (the collection
    // carries the single SRID).
    final inner = geometries
        .map((g) => g.toEwkt().replaceFirst('SRID=$srid;', ''))
        .join(', ');
    return 'SRID=$srid;GEOMETRYCOLLECTION($inner)';
  }

  @override
  String toString() => toEwkt();

  @override
  bool operator ==(Object other) =>
      other is GeographyGeometryCollection &&
      other.srid == srid &&
      other.geometries.length == geometries.length &&
      List.generate(
        geometries.length,
        (i) => geometries[i] == other.geometries[i],
      ).every((v) => v);

  @override
  int get hashCode => Object.hash(srid, Object.hashAll(geometries));
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
      final srid = value['srid'] as int? ?? 4326;
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
    var srid = 4326;
    if (s.startsWith('SRID=')) {
      final semi = s.indexOf(';');
      srid = int.parse(s.substring(5, semi));
      s = s.substring(semi + 1);
    }
    s = s.trim();
    final start = s.indexOf('(');
    final inner = s.substring(start + 1, s.length - 1).trim();
    final geoms = _splitTopLevel(inner)
        .map((g) => _geomFromEwktString(g.trim()))
        .toList();
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

// ---------------------------------------------------------------------------
// Stateful WKB parser used only for GeometryCollection binary decoding.
// ---------------------------------------------------------------------------

class _WkbParser {
  final Uint8List _bytes;
  final ByteData _buf;
  int _offset = 0;

  _WkbParser(Uint8List bytes)
      : _bytes = bytes,
        _buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);

  Endian _readByteOrder() {
    final bo = _bytes[_offset++];
    return bo == 1 ? Endian.little : Endian.big;
  }

  int _readUint32(Endian e) {
    final v = _buf.getUint32(_offset, e);
    _offset += 4;
    return v;
  }

  int _readInt32(Endian e) {
    final v = _buf.getInt32(_offset, e);
    _offset += 4;
    return v;
  }

  double _readFloat64(Endian e) {
    final v = _buf.getFloat64(_offset, e);
    _offset += 8;
    return v;
  }

  GeographyPoint _readPoint(Endian e, int srid) {
    final lon = _readFloat64(e);
    final lat = _readFloat64(e);
    return GeographyPoint(longitude: lon, latitude: lat, srid: srid);
  }

  Geography readGeometry() {
    final e = _readByteOrder();
    final rawType = _readUint32(e);
    final geomType = rawType & 0xFF;
    final hasSrid = (rawType & 0x20000000) != 0;
    var srid = 4326;
    if (hasSrid) srid = _readInt32(e);

    switch (geomType) {
      case 1: // Point
        return _readPoint(e, srid);

      case 2: // LineString
        final numPoints = _readUint32(e);
        final points = List.generate(numPoints, (_) => _readPoint(e, srid));
        return GeographyLineString(points: points, srid: srid);

      case 3: // Polygon
        final numRings = _readUint32(e);
        final rings = List.generate(numRings, (_) {
          final numPoints = _readUint32(e);
          return List.generate(numPoints, (_) => _readPoint(e, srid));
        });
        return GeographyPolygon(
          exteriorRing: rings.isNotEmpty ? rings[0] : const [],
          holes: rings.length > 1 ? rings.sublist(1) : const [],
          srid: srid,
        );

      case 7: // GeometryCollection
        final numGeoms = _readUint32(e);
        final geoms = List.generate(numGeoms, (_) => readGeometry());
        return GeographyGeometryCollection(geometries: geoms, srid: srid);

      default:
        throw ArgumentError('Unsupported WKB geometry type: $geomType');
    }
  }
}
