import 'dart:typed_data';

import 'geography.dart';
import 'geography_point.dart';

/// Represents a geographic polygon (exterior ring + optional holes) for PostGIS.
class GeographyPolygon implements Geography {
  /// Exterior ring — ordered list of points that close the polygon.
  final List<GeographyPoint> exteriorRing;

  /// Interior rings (holes), each a closed list of points.
  final List<List<GeographyPoint>> holes;

  /// Spatial reference system identifier. Defaults to WGS 84 (EPSG:4326).
  @override
  final int srid;

  /// Creates a new [GeographyPolygon].
  const GeographyPolygon({
    required this.exteriorRing,
    this.holes = const [],
    this.srid = 4326,
  });

  /// Creates a [GeographyPolygon] from its EWKB binary representation
  /// as returned by PostgreSQL for geography columns.
  factory GeographyPolygon.fromBinary(Uint8List bytes) {
    final buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);
    final isLittleEndian = bytes[0] == 1;
    final endian = isLittleEndian ? Endian.little : Endian.big;

    final type = buf.getUint32(1, endian);
    final hasSrid = (type & 0x20000000) != 0;

    var offset = 5;
    var srid = 4326;
    if (hasSrid) {
      srid = buf.getInt32(offset, endian);
      offset += 4;
    }

    final numRings = buf.getUint32(offset, endian);
    offset += 4;

    final rings = <List<GeographyPoint>>[];
    for (var r = 0; r < numRings; r++) {
      final numPoints = buf.getUint32(offset, endian);
      offset += 4;
      final ring = <GeographyPoint>[];
      for (var i = 0; i < numPoints; i++) {
        final longitude = buf.getFloat64(offset, endian);
        final latitude = buf.getFloat64(offset + 8, endian);
        ring.add(GeographyPoint(longitude: longitude, latitude: latitude, srid: srid));
        offset += 16;
      }
      rings.add(ring);
    }

    return GeographyPolygon(
      exteriorRing: rings.isNotEmpty ? rings[0] : const [],
      holes: rings.length > 1 ? rings.sublist(1) : const [],
      srid: srid,
    );
  }

  static String _ringToStr(List<GeographyPoint> ring) =>
      '(${ring.map((p) => '${p.longitude} ${p.latitude}').join(', ')})';

  @override
  String toEwkt() {
    final rings = [exteriorRing, ...holes].map(_ringToStr).join(', ');
    return 'SRID=$srid;POLYGON($rings)';
  }

  @override
  String toString() => toEwkt();

  @override
  bool operator ==(Object other) =>
      other is GeographyPolygon &&
      other.srid == srid &&
      other.exteriorRing.length == exteriorRing.length &&
      List.generate(
        exteriorRing.length,
        (i) => exteriorRing[i] == other.exteriorRing[i],
      ).every((v) => v) &&
      other.holes.length == holes.length &&
      List.generate(
        holes.length,
        (hi) =>
            holes[hi].length == other.holes[hi].length &&
            List.generate(
              holes[hi].length,
              (pi) => holes[hi][pi] == other.holes[hi][pi],
            ).every((v) => v),
      ).every((v) => v);

  @override
  int get hashCode => Object.hash(
    srid,
    Object.hashAll(exteriorRing),
    Object.hashAll(holes.map(Object.hashAll)),
  );
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
      final srid = value['srid'] as int? ?? 4326;
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
    var srid = 4326;
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
