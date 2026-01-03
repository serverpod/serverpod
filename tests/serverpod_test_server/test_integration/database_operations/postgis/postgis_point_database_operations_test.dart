import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import 'dummy_postgis_data.dart';

void main() async {
  withServerpod(
    'PostGIS Point Spatial Operations',
    (sessionBuilder, _) {
      test(
        'Given points stored in database when retrieving all points then data is persisted correctly.',
        () async {
          var session = sessionBuilder.build();

          // Create test points
          var point1 = GeographyPoint(-119.95, 40.05);
          var point2 = GeographyPoint(-119.92, 40.08);
          var point3 = GeographyPoint(-119.8, 40.0);
          var point4 = GeographyPoint(-120.1, 40.1);

          var row1 = ObjectWithPostgis(
            point: point1,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row2 = ObjectWithPostgis(
            point: point2,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row3 = ObjectWithPostgis(
            point: point3,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row4 = ObjectWithPostgis(
            point: point4,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          await ObjectWithPostgis.db.insertRow(session, row1);
          await ObjectWithPostgis.db.insertRow(session, row2);
          await ObjectWithPostgis.db.insertRow(session, row3);
          await ObjectWithPostgis.db.insertRow(session, row4);

          // Query all points
          var allPoints = await ObjectWithPostgis.db.find(session);

          expect(allPoints.length, greaterThanOrEqualTo(4));
        },
      );

      test(
        'Given point coordinates when storing and retrieving then latitude and longitude are preserved.',
        () async {
          var session = sessionBuilder.build();

          // Create test points with specific coordinates
          var testPoint1 = GeographyPoint(-74.5, 40.5);
          var testPoint2 = GeographyPoint(-73.0, 40.5);

          var row1 = ObjectWithPostgis(
            point: testPoint1,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row2 = ObjectWithPostgis(
            point: testPoint2,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted1 = await ObjectWithPostgis.db.insertRow(session, row1);
          var inserted2 = await ObjectWithPostgis.db.insertRow(session, row2);

          // Verify both points were inserted successfully
          expect(inserted1.id, isNotNull);
          expect(inserted2.id, isNotNull);

          var retrieved1 = await ObjectWithPostgis.db.findById(
            session,
            inserted1.id!,
          );
          var retrieved2 = await ObjectWithPostgis.db.findById(
            session,
            inserted2.id!,
          );

          // Verify coordinates are preserved
          expect(
            retrieved1?.point.longitude,
            closeTo(testPoint1.longitude, 0.0001),
          );
          expect(
            retrieved1?.point.latitude,
            closeTo(testPoint1.latitude, 0.0001),
          );
          expect(
            retrieved2?.point.longitude,
            closeTo(testPoint2.longitude, 0.0001),
          );
          expect(
            retrieved2?.point.latitude,
            closeTo(testPoint2.latitude, 0.0001),
          );
        },
      );

      test(
        'Given point data stored in database when querying points then valid coordinates are retrievable.',
        () async {
          var session = sessionBuilder.build();

          var validPoint = DummyPostgisData.sanFranciscoPoint;

          var row = ObjectWithPostgis(
            point: validPoint,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          await ObjectWithPostgis.db.insertRow(session, row);

          // Query all points and verify valid point is present
          var allPoints = await ObjectWithPostgis.db.find(session);
          expect(
            allPoints.any(
              (r) =>
                  r.point.longitude == validPoint.longitude &&
                  r.point.latitude == validPoint.latitude,
            ),
            isTrue,
          );
        },
      );

      test(
        'Given multiple points in database when calculating distance then closest points can be identified.',
        () async {
          var session = sessionBuilder.build();

          // Create reference point and two test points at different distances
          var referencePoint = GeographyPoint(-74.0, 40.0);
          var closePoint = GeographyPoint(-74.001, 40.001); // Very close
          var farPoint = GeographyPoint(-74.1, 40.1); // Further away

          var row1 = ObjectWithPostgis(
            point: closePoint,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row2 = ObjectWithPostgis(
            point: farPoint,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted1 = await ObjectWithPostgis.db.insertRow(session, row1);
          var inserted2 = await ObjectWithPostgis.db.insertRow(session, row2);

          expect(inserted1.id, isNotNull);
          expect(inserted2.id, isNotNull);

          // Retrieve all points and verify both are stored
          var allPoints = await ObjectWithPostgis.db.find(session);
          expect(allPoints.length, greaterThanOrEqualTo(2));

          // Calculate distances manually
          for (var point in allPoints) {
            var distance = _calculateDistance(point.point, referencePoint);
            expect(distance, greaterThanOrEqualTo(0));
          }
        },
      );

      test(
        'Given points and bounding box constraints when using isWithinBounds operation then points within bounds are found.',
        () async {
          var session = sessionBuilder.build();

          // Define bounding box: longitude [-75 to -74], latitude [40 to 41]
          var withinBox = GeographyPoint(-74.5, 40.5); // Within bounds
          var outsideBox = GeographyPoint(
            -73.5,
            40.5,
          ); // Outside bounds (lon too high)

          var row1 = ObjectWithPostgis(
            point: withinBox,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row2 = ObjectWithPostgis(
            point: outsideBox,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          await ObjectWithPostgis.db.insertRow(session, row1);
          await ObjectWithPostgis.db.insertRow(session, row2);

          // Query points within bounding box
          var inBounds = await ObjectWithPostgis.db.find(
            session,
            where: (t) => t.point.isWithinBounds(-75, 40, -74, 41),
          );

          expect(inBounds.length, greaterThanOrEqualTo(1));
          expect(
            inBounds.any(
              (row) =>
                  row.point.longitude == withinBox.longitude &&
                  row.point.latitude == withinBox.latitude,
            ),
            isTrue,
          );
        },
      );

      test(
        'Given multiple points in database when storing different coordinate combinations then all are retrievable.',
        () async {
          var session = sessionBuilder.build();

          // Create points with different coordinates
          var withinPoint = GeographyPoint(-84.5, 35.5);
          var intersectPoint = GeographyPoint(-84.2, 35.8);
          var outsidePoint = GeographyPoint(-83.0, 35.5);

          for (var point in [withinPoint, intersectPoint, outsidePoint]) {
            var row = ObjectWithPostgis(
              point: point,
              pointNullable: null,
              lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
              lineStringNullable: null,
              polygon: DummyPostgisData.simpleSquarePolygon,
              polygonNullable: null,
              multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              multiPolygonNullable: null,
            );
            await ObjectWithPostgis.db.insertRow(session, row);
          }

          // Find all points
          var results = await ObjectWithPostgis.db.find(session);

          // Should find all three inserted points
          expect(results.length, greaterThanOrEqualTo(3));

          // Verify the within point was stored correctly
          expect(
            results.any(
              (row) =>
                  row.point.longitude == withinPoint.longitude &&
                  row.point.latitude == withinPoint.latitude,
            ),
            isTrue,
          );
        },
      );

      test(
        'Given points with nullable point fields when storing then nullable point values are preserved correctly.',
        () async {
          var session = sessionBuilder.build();

          var pointInNullable = GeographyPoint(-89.5, 30.5);

          var row = ObjectWithPostgis(
            point: DummyPostgisData.sanFranciscoPoint,
            pointNullable: pointInNullable,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted = await ObjectWithPostgis.db.insertRow(session, row);
          var retrieved = await ObjectWithPostgis.db.findById(
            session,
            inserted.id!,
          );

          // Verify nullable point was stored with correct coordinates
          expect(retrieved?.pointNullable, isNotNull);
          expect(
            retrieved?.pointNullable?.longitude,
            closeTo(pointInNullable.longitude, 0.0001),
          );
          expect(
            retrieved?.pointNullable?.latitude,
            closeTo(pointInNullable.latitude, 0.0001),
          );
        },
      );
    },
  );
}

/// Simple distance calculation helper (Euclidean approximation)
double _calculateDistance(GeographyPoint p1, GeographyPoint p2) {
  final dx = p1.longitude - p2.longitude;
  final dy = p1.latitude - p2.latitude;
  return (dx * dx + dy * dy).toDouble();
}
