import 'dart:typed_data';

import 'geography.dart';
import 'geography_point.dart';

/// Represents a geographic line string (sequence of points) for use with PostGIS.
class GeographyLineString implements Geography {
  /// Ordered list of points that make up the line.
  final List<GeographyPoint> points;

  /// Spatial reference system identifier. Defaults to WGS 84 (EPSG:4326).
  @override
  final int srid;

  /// Creates a new [GeographyLineString].
  const GeographyLineString({
    required this.points,
    this.srid = Geography.defaultSrid,
  });

  /// Creates a [GeographyLineString] from its EWKB binary representation
  /// as returned by PostgreSQL for geography columns.
  factory GeographyLineString.fromBinary(Uint8List bytes) {
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

    final numPoints = buf.getUint32(offset, endian);
    offset += 4;

    final points = <GeographyPoint>[];
    for (var i = 0; i < numPoints; i++) {
      final longitude = buf.getFloat64(offset, endian);
      final latitude = buf.getFloat64(offset + 8, endian);
      points.add(
        GeographyPoint(longitude: longitude, latitude: latitude, srid: srid),
      );
      offset += 16;
    }

    return GeographyLineString(points: points, srid: srid);
  }

  @override
  String toEwkt() {
    final coords = points.map((p) => '${p.longitude} ${p.latitude}').join(', ');
    return 'SRID=$srid;LINESTRING($coords)';
  }

  @override
  String toString() => toEwkt();

  @override
  bool operator ==(Object other) =>
      other is GeographyLineString &&
      other.srid == srid &&
      other.points.length == points.length &&
      List.generate(
        points.length,
        (i) => points[i] == other.points[i],
      ).every((v) => v);

  @override
  int get hashCode => Object.hash(srid, Object.hashAll(points));
}
