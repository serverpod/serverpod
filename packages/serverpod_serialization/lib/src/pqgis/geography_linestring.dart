import 'geography_point.dart';

/// PostGIS LineString: an ordered list of points.
class GeographyLineString {
  /// The points in the linestring.
  final List<GeographyPoint> points;

  /// The SRID (spatial reference identifier) of the linestring, or null if not specified.
  final int? srid;

  /// Creates a GeographyLineString with the given points and optional SRID.
  GeographyLineString(this.points, {this.srid});

  /// Creates a GeographyLineString from a JSON representation.
  factory GeographyLineString.fromJson(Map<String, dynamic> json) {
    final srid = json['srid'] as int?;
    final pointsRaw = json['points'];
    final coordsRaw = json['coordinates'];

    final List<GeographyPoint> pts;
    if (pointsRaw is List) {
      pts = pointsRaw
          .map((p) => GeographyPoint.fromJson(p as Map<String, dynamic>))
          .toList();
    } else if (coordsRaw is List) {
      pts = coordsRaw.map((p) {
        if (p is List) {
          if (p.length < 2) {
            throw FormatException('Invalid coordinate pair in LineString: $p');
          }
          return GeographyPoint(
            (p[0] as num).toDouble(),
            (p[1] as num).toDouble(),
          );
        }
        if (p is Map) {
          return GeographyPoint.fromJson(p.cast<String, dynamic>());
        }
        throw FormatException(
          'Invalid coordinate element in LineString: ${p.runtimeType}',
        );
      }).toList();
    } else {
      throw const FormatException(
        'Invalid LineString JSON: expected "points" or "coordinates".',
      );
    }
    return GeographyLineString(pts, srid: srid);
  }

  /// Converts the GeographyLineString to a JSON representation.
  Map<String, dynamic> toJson() => {
    'points': points.map((p) => p.toJson()).toList(),
    if (srid != null) 'srid': srid,
  };

  /// Parse WKT `LINESTRING` or `SRID=...;LINESTRING(...)`.
  factory GeographyLineString.fromWkt(String wkt) {
    var s = wkt.trim();
    int? parsedSrid;
    final sridMatch = RegExp(
      r'^SRID=(\d+);',
      caseSensitive: false,
    ).firstMatch(s);
    if (sridMatch != null) {
      parsedSrid = int.parse(sridMatch.group(1)!);
      s = s.substring(sridMatch.end).trim();
    }

    final emptyMatch = RegExp(
      r'^LINESTRING\s+EMPTY\s*$',
      caseSensitive: false,
    ).firstMatch(s);
    if (emptyMatch != null) {
      return GeographyLineString([], srid: parsedSrid);
    }

    final match = RegExp(
      r'^LINESTRING\s*\((.*)\)\s*$',
      caseSensitive: false,
    ).firstMatch(s);

    if (match == null) throw FormatException('Invalid WKT LINESTRING: $wkt');

    final inner = match.group(1)!.trim();
    if (inner.isEmpty) return GeographyLineString([], srid: parsedSrid);

    final pts = inner.split(',').map((part) {
      // Accept comma- or space-separated coordinate pairs.
      final coords = part.trim().split(RegExp(r'[\s,]+'));
      if (coords.length < 2) {
        throw FormatException('Invalid coordinate in LINESTRING: $part');
      }
      return GeographyPoint(double.parse(coords[0]), double.parse(coords[1]));
    }).toList();

    return GeographyLineString(pts, srid: parsedSrid);
  }

  /// Converts the GeographyLineString to WKT `LINESTRING(...)`.
  String toWkt() {
    if (points.isEmpty) return 'LINESTRING EMPTY';
    return 'LINESTRING(${points.map((p) => '${_fmt(p.longitude)} ${_fmt(p.latitude)}').join(', ')})';
  }

  /// Converts the GeographyLineString to WKT with optional SRID prefix.
  String toWktWithSrid() => srid != null ? 'SRID=$srid;${toWkt()}' : toWkt();

  @override
  String toString() => toWktWithSrid();

  /// Return a copy with optional replacement of points or srid.
  GeographyLineString copyWith({List<GeographyPoint>? points, int? srid}) {
    return GeographyLineString(
      points ?? this.points.map((p) => p).toList(),
      srid: srid ?? this.srid,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GeographyLineString &&
      other.points.length == points.length &&
      _pointsEqual(other.points, points) &&
      other.srid == srid;

  @override
  int get hashCode => Object.hash(
    srid,
    Object.hashAll(
      points.map((p) => Object.hash(p.longitude, p.latitude)),
    ),
  );

  static bool _pointsEqual(List<GeographyPoint> a, List<GeographyPoint> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toString();
  }
}
