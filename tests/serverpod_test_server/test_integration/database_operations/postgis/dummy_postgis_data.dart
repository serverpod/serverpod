// Dummy data for PostGIS geometry types testing
// All coordinates are in WGS84 (SRID 4326)

import 'package:serverpod/serverpod.dart';

class DummyPostgisData {
  static GeographyPoint sanFranciscoPoint = GeographyPoint(-122.4194, 37.7749);
  static GeographyPoint newYorkPoint = GeographyPoint(-74.0060, 40.7128);
  static GeographyPoint londonPoint = GeographyPoint(-0.1276, 51.5074);
  static GeographyPoint tokyoPoint = GeographyPoint(139.6503, 35.6762);
  static GeographyPoint equatorPoint = GeographyPoint(0.0, 0.0);

  static GeographyLineString sanFranciscoToLosAngelesLine = GeographyLineString(
    [
      GeographyPoint(-122.4194, 37.7749), // San Francisco
      GeographyPoint(-121.8863, 37.3382), // San Jose
      GeographyPoint(-121.8944, 36.6002), // Monterey
      GeographyPoint(-120.6625, 35.2828), // San Luis Obispo
      GeographyPoint(-119.2945, 34.2805), // Malibu
      GeographyPoint(-118.2437, 34.0522), // Los Angeles
    ],
  );

  static GeographyLineString londonToParisLine = GeographyLineString([
    GeographyPoint(-0.1276, 51.5074), // London
    GeographyPoint(2.3522, 48.8566), // Paris
  ]);

  static GeographyLineString seattleToSanDiegoLine = GeographyLineString([
    GeographyPoint(-122.3321, 47.6062), // Seattle
    GeographyPoint(-106.3270, 42.8026), // Wyoming
    GeographyPoint(-104.6021, 38.2919), // Colorado
    GeographyPoint(-117.1611, 32.7157), // San Diego
  ]);

  static GeographyLineString triangleLine = GeographyLineString([
    GeographyPoint(0.0, 0.0),
    GeographyPoint(0.0, 1.0),
    GeographyPoint(1.0, 0.5),
  ]);

  static GeographyPolygon simpleSquarePolygon = GeographyPolygon([
    [
      GeographyPoint(-120.0, 40.0),
      GeographyPoint(-119.9, 40.0),
      GeographyPoint(-119.9, 40.1),
      GeographyPoint(-120.0, 40.1),
      GeographyPoint(-120.0, 40.0),
    ],
  ]);

  static GeographyPolygon trianglePolygon = GeographyPolygon([
    [
      GeographyPoint(0.0, 0.0),
      GeographyPoint(0.0, 1.0),
      GeographyPoint(1.0, 0.5),
      GeographyPoint(0.0, 0.0),
    ],
  ]);

  static GeographyPolygon pentagonPolygon = GeographyPolygon([
    [
      GeographyPoint(0.0, 0.0),
      GeographyPoint(-0.3, 1.0),
      GeographyPoint(1.0, 0.8),
      GeographyPoint(1.0, -0.8),
      GeographyPoint(-0.3, -1.0),
      GeographyPoint(0.0, 0.0),
    ],
  ]);

  static GeographyPolygon polygonWithHole = GeographyPolygon([
    // Exterior ring
    [
      GeographyPoint(0.0, 0.0),
      GeographyPoint(5.0, 0.0),
      GeographyPoint(5.0, 5.0),
      GeographyPoint(0.0, 5.0),
      GeographyPoint(0.0, 0.0),
    ],
    // Hole (interior ring)
    [
      GeographyPoint(1.5, 1.5),
      GeographyPoint(3.5, 1.5),
      GeographyPoint(3.5, 3.5),
      GeographyPoint(1.5, 3.5),
      GeographyPoint(1.5, 1.5),
    ],
  ]);

  static GeographyPolygon largeSquarePolygon = GeographyPolygon([
    [
      GeographyPoint(-120.0, 40.0),
      GeographyPoint(-110.0, 40.0),
      GeographyPoint(-110.0, 50.0),
      GeographyPoint(-120.0, 50.0),
      GeographyPoint(-120.0, 40.0),
    ],
  ]);

  static GeographyMultiPolygon twoSquaresMultiPolygon = GeographyMultiPolygon([
    GeographyPolygon([
      [
        // First square
        GeographyPoint(-120.0, 40.0),
        GeographyPoint(-119.0, 40.0),
        GeographyPoint(-119.0, 41.0),
        GeographyPoint(-120.0, 41.0),
        GeographyPoint(-120.0, 40.0),
      ],
    ]),
    GeographyPolygon([
      [
        // Second square
        GeographyPoint(-120.0, 42.0),
        GeographyPoint(-119.0, 42.0),
        GeographyPoint(-119.0, 43.0),
        GeographyPoint(-120.0, 43.0),
        GeographyPoint(-120.0, 42.0),
      ],
    ]),
  ]);

  /// A multipolygon representing three triangular regions
  static GeographyMultiPolygon threeTrianglesMultiPolygon =
      GeographyMultiPolygon([
        GeographyPolygon([
          [
            // First triangle
            GeographyPoint(0.0, 0.0),
            GeographyPoint(0.0, 1.0),
            GeographyPoint(1.0, 0.5),
            GeographyPoint(0.0, 0.0),
          ],
        ]),
        GeographyPolygon([
          [
            // Second triangle
            GeographyPoint(0.0, 2.0),
            GeographyPoint(0.0, 3.0),
            GeographyPoint(1.0, 2.5),
            GeographyPoint(0.0, 2.0),
          ],
        ]),
        GeographyPolygon([
          [
            // Third triangle
            GeographyPoint(0.0, 4.0),
            GeographyPoint(0.0, 5.0),
            GeographyPoint(1.0, 4.5),
            GeographyPoint(0.0, 4.0),
          ],
        ]),
      ]);

  static GeographyMultiPolygon mixedShapesMultiPolygon = GeographyMultiPolygon([
    GeographyPolygon([
      [
        // Square
        GeographyPoint(0.0, 0.0),
        GeographyPoint(2.0, 0.0),
        GeographyPoint(2.0, 2.0),
        GeographyPoint(0.0, 2.0),
        GeographyPoint(0.0, 0.0),
      ],
    ]),
    GeographyPolygon([
      [
        // Triangle
        GeographyPoint(0.0, 3.0),
        GeographyPoint(0.0, 4.0),
        GeographyPoint(1.0, 3.5),
        GeographyPoint(0.0, 3.0),
      ],
    ]),
    GeographyPolygon([
      [
        // Pentagon
        GeographyPoint(0.0, 5.0),
        GeographyPoint(-0.3, 6.0),
        GeographyPoint(1.0, 5.8),
        GeographyPoint(1.0, 4.2),
        GeographyPoint(-0.3, 4.0),
        GeographyPoint(0.0, 5.0),
      ],
    ]),
  ]);

  static GeographyMultiPolygon islandsMultiPolygon = GeographyMultiPolygon([
    GeographyPolygon([
      [
        // Island 1
        GeographyPoint(0.0, 0.0),
        GeographyPoint(1.0, 0.0),
        GeographyPoint(1.0, 1.0),
        GeographyPoint(0.0, 1.0),
        GeographyPoint(0.0, 0.0),
      ],
    ]),
    GeographyPolygon([
      [
        // Island 2
        GeographyPoint(2.0, 2.0),
        GeographyPoint(3.0, 2.0),
        GeographyPoint(3.0, 3.0),
        GeographyPoint(2.0, 3.0),
        GeographyPoint(2.0, 2.0),
      ],
    ]),
    GeographyPolygon([
      [
        // Island 3
        GeographyPoint(0.5, 4.0),
        GeographyPoint(1.5, 4.0),
        GeographyPoint(1.5, 5.0),
        GeographyPoint(0.5, 5.0),
        GeographyPoint(0.5, 4.0),
      ],
    ]),
  ]);
}
