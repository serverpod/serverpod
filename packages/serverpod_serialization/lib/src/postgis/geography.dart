/// Abstract base class for all PostGIS geography types.
///
/// All concrete types ([GeographyPoint], [GeographyLineString],
/// [GeographyPolygon], [GeographyGeometryCollection]) implement this interface,
/// allowing spatial operations on columns to accept any geography value.
abstract class Geography {
  /// Spatial reference system identifier. Defaults to WGS 84 (EPSG:4326).
  int get srid;

  /// Returns the EWKT representation for PostGIS, e.g.
  /// `SRID=4326;POINT(-0.12 51.5)`.
  String toEwkt();
}
