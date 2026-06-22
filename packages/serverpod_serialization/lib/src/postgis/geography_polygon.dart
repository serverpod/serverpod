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
    this.srid = Geography.defaultSrid,
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
    var srid = Geography.defaultSrid;
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
        ring.add(
          GeographyPoint(longitude: longitude, latitude: latitude, srid: srid),
        );
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
