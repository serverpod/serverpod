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
  const GeographyLineString({required this.points, this.srid = 4326});

  /// Creates a [GeographyLineString] from its EWKB binary representation
  /// as returned by PostgreSQL for geography columns.
  factory GeographyLineString.fromBinary(Uint8List bytes) {
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
      final srid = value['srid'] as int? ?? 4326;
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
    var srid = 4326;
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
