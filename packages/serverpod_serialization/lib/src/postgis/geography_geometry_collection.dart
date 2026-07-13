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
    this.srid = Geography.defaultSrid,
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
        .map((g) => g.toEwkt().replaceFirst(RegExp(r'SRID=\d+;'), ''))
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

  Geography readGeometry([int parentSrid = Geography.defaultSrid]) {
    final e = _readByteOrder();
    final rawType = _readUint32(e);
    final geomType = rawType & 0xFF;
    final hasSrid = (rawType & 0x20000000) != 0;
    var srid = parentSrid;
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
        final geoms = List.generate(numGeoms, (_) => readGeometry(srid));
        return GeographyGeometryCollection(geometries: geoms, srid: srid);

      default:
        throw ArgumentError('Unsupported WKB geometry type: $geomType');
    }
  }
}
