import 'dart:typed_data';

/// Represents a geographic point with longitude, latitude, and spatial
/// reference system identifier (SRID) for use with PostGIS.
class GeographyPoint {
  /// Longitude (X coordinate) in decimal degrees.
  final double longitude;

  /// Latitude (Y coordinate) in decimal degrees.
  final double latitude;

  /// Spatial reference system identifier. Defaults to WGS 84 (EPSG:4326).
  final int srid;

  /// Creates a new [GeographyPoint].
  const GeographyPoint({
    required this.longitude,
    required this.latitude,
    this.srid = 4326,
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
    var srid = 4326;
    if (hasSrid) {
      srid = buf.getInt32(offset, endian);
      offset += 4;
    }

    final longitude = buf.getFloat64(offset, endian);
    final latitude = buf.getFloat64(offset + 8, endian);

    return GeographyPoint(longitude: longitude, latitude: latitude, srid: srid);
  }

  /// Returns the EWKT representation accepted by PostGIS for inserts.
  @override
  String toString() => 'SRID=$srid;POINT($longitude $latitude)';

  @override
  bool operator ==(Object other) =>
      other is GeographyPoint &&
      other.longitude == longitude &&
      other.latitude == latitude &&
      other.srid == srid;

  @override
  int get hashCode => Object.hash(longitude, latitude, srid);
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
        srid: value['srid'] as int? ?? 4326,
      );
    }
    throw ArgumentError(
      'Cannot deserialize ${value.runtimeType} as GeographyPoint',
    );
  }

  static GeographyPoint _fromEwkt(String value) {
    var s = value;
    var srid = 4326;
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
  String toJson() => toString();
}
