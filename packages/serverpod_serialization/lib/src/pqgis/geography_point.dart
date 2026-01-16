/// PostGIS point representation and simple WKT/JSON helpers.
class GeographyPoint {
  /// The longitude of the point.
  final double longitude;

  /// The latitude of the point.
  final double latitude;

  /// The SRID of the point, or null if not set.
  final int? srid;

  /// Creates a new [GeographyPoint] with the given [longitude], [latitude]
  /// and optional [srid].
  const GeographyPoint(this.longitude, this.latitude, {this.srid});

  /// Create from JSON map: prefer `{'longitude': <num>, 'latitude': <num>}` but
  /// accept legacy keys `lon/lat` and `x/y`.
  factory GeographyPoint.fromJson(Map<String, dynamic> json) {
    final lonVal = json['longitude'] ?? json['lon'] ?? json['x'];
    final latVal = json['latitude'] ?? json['lat'] ?? json['y'];
    return GeographyPoint(
      (lonVal as num).toDouble(),
      (latVal as num).toDouble(),
      srid: json['srid'] as int?,
    );
  }

  /// Convert this [GeographyPoint] to a JSON map.
  Map<String, dynamic> toJson() => {
    'longitude': longitude,
    'latitude': latitude,
    if (srid != null) 'srid': srid,
  };

  /// Parse a WKT `POINT` or an SRID prefixed WKT like `SRID=4326;POINT(x y)`.
  ///
  /// Examples:
  /// - `POINT(30 10)`
  /// - `SRID=4326;POINT(-71.064544 42.28787)`
  factory GeographyPoint.fromWkt(String wkt) {
    var s = wkt.trim();

    int? parsedSrid;
    // optional SRID=xxxx; prefix
    final sridMatch = RegExp(
      r'^SRID=(\d+);',
      caseSensitive: false,
    ).firstMatch(s);
    if (sridMatch != null) {
      parsedSrid = int.parse(sridMatch.group(1)!);
      s = s.substring(sridMatch.end).trim();
    }

    final pointMatch = RegExp(
      r'^POINT\s*\(([^)]+)\)',
      caseSensitive: false,
    ).firstMatch(s);
    if (pointMatch == null) {
      throw FormatException('Invalid WKT POINT: $wkt');
    }

    // Accept both space- and comma-separated coordinates (some drivers return `POINT(x,y)`).
    final coords = pointMatch.group(1)!.trim().split(RegExp(r'[\s,]+'));
    if (coords.length < 2) {
      throw FormatException(
        'Invalid POINT coordinates: ${pointMatch.group(1)}',
      );
    }
    final lon = double.parse(coords[0]);
    final lat = double.parse(coords[1]);
    return GeographyPoint(lon, lat, srid: parsedSrid);
  }

  /// Convert to WKT (no SRID prefix). Use `toWktWithSrid` to include SRID.
  String toWkt() => 'POINT(${_fmt(longitude)} ${_fmt(latitude)})';

  /// Convert to WKT and include SRID prefix if available.
  String toWktWithSrid() => srid != null ? 'SRID=$srid;${toWkt()}' : toWkt();

  @override
  String toString() => toWktWithSrid();

  /// Return a copy of this [GeographyPoint] with the provided fields replaced.
  GeographyPoint copyWith({double? longitude, double? latitude, int? srid}) {
    return GeographyPoint(
      longitude ?? this.longitude,
      latitude ?? this.latitude,
      srid: srid ?? this.srid,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GeographyPoint &&
      other.longitude == longitude &&
      other.latitude == latitude &&
      other.srid == srid;

  @override
  int get hashCode => Object.hash(longitude, latitude, srid);

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toString();
  }
}
