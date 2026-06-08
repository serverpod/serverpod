/// Abstract base class for all PostGIS geography types.
///
/// All concrete types ([GeographyPoint], [GeographyLineString],
/// [GeographyPolygon], [GeographyGeometryCollection]) implement this interface,
/// allowing spatial operations on columns to accept any geography value.
abstract class Geography {
  /// The default spatial reference system identifier: WGS 84 (EPSG:4326).
  ///
  /// EPSG:4326 is the standard coordinate system for GPS and most geographic
  /// data, using longitude/latitude in degrees on the WGS 84 ellipsoid.
  static const int defaultSrid = 4326;

  /// Spatial reference system identifier. Defaults to [defaultSrid] (WGS 84).
  int get srid;

  /// Returns the EWKT representation for PostGIS, e.g.
  /// `SRID=4326;POINT(-0.12 51.5)`.
  String toEwkt();
}
