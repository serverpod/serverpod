import 'dart:typed_data';

import 'geography.dart';

/// Represents a geographic point with longitude, latitude, and spatial
/// reference system identifier (SRID) for use with PostGIS.
class GeographyPoint implements Geography {
  /// Longitude (X coordinate) in decimal degrees.
  final double longitude;

  /// Latitude (Y coordinate) in decimal degrees.
  final double latitude;

  /// Spatial reference system identifier. Defaults to WGS 84 (EPSG:4326).
  @override
  final int srid;

  /// Creates a new [GeographyPoint].
  const GeographyPoint({
    required this.longitude,
    required this.latitude,
    this.srid = Geography.defaultSrid,
  });

  /// Creates a [GeographyPoint] from its EWKB binary representation
  /// as returned by PostgreSQL for geography columns.
  factory GeographyPoint.fromBinary(Uint8List bytes) {
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

    final longitude = buf.getFloat64(offset, endian);
    final latitude = buf.getFloat64(offset + 8, endian);

    return GeographyPoint(longitude: longitude, latitude: latitude, srid: srid);
  }

  @override
  String toEwkt() => 'SRID=$srid;POINT($longitude $latitude)';

  /// Returns the EWKT representation accepted by PostGIS for inserts.
  @override
  String toString() => toEwkt();

  @override
  bool operator ==(Object other) =>
      other is GeographyPoint &&
      other.longitude == longitude &&
      other.latitude == latitude &&
      other.srid == srid;

  @override
  int get hashCode => Object.hash(longitude, latitude, srid);
}
