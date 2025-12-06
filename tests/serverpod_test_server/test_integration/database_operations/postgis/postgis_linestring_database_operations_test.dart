import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import 'dummy_postgis_data.dart';

void main() async {
  withServerpod(
    'PostGIS LineString Spatial Operations',
    (sessionBuilder, _) {
      test(
        'Given linestrings in database when storing different routes then all are retrievable.',
        () async {
          var session = sessionBuilder.build();

          // Line with multiple segments
          var routeLine1 = GeographyLineString([
            GeographyPoint(-76.0, 40.5),
            GeographyPoint(-75.0, 40.5),
            GeographyPoint(-73.0, 40.5),
          ]);

          // Simple line with 2 points
          var routeLine2 = GeographyLineString([
            GeographyPoint(-73.0, 39.0),
            GeographyPoint(-72.0, 39.0),
          ]);

          var row1 = ObjectWithPostgis(
            point: DummyPostgisData.sanFranciscoPoint,
            pointNullable: null,
            lineString: routeLine1,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row2 = ObjectWithPostgis(
            point: DummyPostgisData.newYorkPoint,
            pointNullable: null,
            lineString: routeLine2,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted1 = await ObjectWithPostgis.db.insertRow(session, row1);
          var inserted2 = await ObjectWithPostgis.db.insertRow(session, row2);

          var retrieved1 = await ObjectWithPostgis.db.findById(
            session,
            inserted1.id!,
          );
          var retrieved2 = await ObjectWithPostgis.db.findById(
            session,
            inserted2.id!,
          );

          expect(retrieved1?.lineString.points.length, equals(3));
          expect(retrieved2?.lineString.points.length, equals(2));
        },
      );

      test(
        'Given linestrings when storing and retrieving then all coordinate points are preserved.',
        () async {
          var session = sessionBuilder.build();

          var routes = [
            DummyPostgisData.sanFranciscoToLosAngelesLine,
            DummyPostgisData.londonToParisLine,
            DummyPostgisData.seattleToSanDiegoLine,
            DummyPostgisData.triangleLine,
          ];

          for (var route in routes) {
            var row = ObjectWithPostgis(
              point: DummyPostgisData.sanFranciscoPoint,
              pointNullable: null,
              lineString: route,
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

            expect(
              retrieved?.lineString.points.length,
              equals(route.points.length),
              reason:
                  'Line with ${route.points.length} points should have same count after retrieval',
            );

            expect(
              retrieved?.lineString.points.first.longitude,
              closeTo(route.points.first.longitude, 0.0001),
            );
            expect(
              retrieved?.lineString.points.last.longitude,
              closeTo(route.points.last.longitude, 0.0001),
            );
          }
        },
      );

      test(
        'Given linestrings in database when updating with new coordinates then changes are persisted.',
        () async {
          var session = sessionBuilder.build();

          var originalLine = DummyPostgisData.sanFranciscoToLosAngelesLine;
          var newLine = DummyPostgisData.londonToParisLine;

          var row = ObjectWithPostgis(
            point: DummyPostgisData.sanFranciscoPoint,
            pointNullable: null,
            lineString: originalLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted = await ObjectWithPostgis.db.insertRow(session, row);

          // Update with new linestring
          inserted.lineString = newLine;
          var updated = await ObjectWithPostgis.db.updateRow(session, inserted);

          var retrieved = await ObjectWithPostgis.db.findById(
            session,
            updated.id!,
          );
          expect(
            retrieved?.lineString.points.length,
            equals(newLine.points.length),
          );
          expect(
            retrieved?.lineString.points.first.longitude,
            closeTo(newLine.points.first.longitude, 0.0001),
          );
        },
      );

      test(
        'Given nullable linestring fields when setting values then nullable operations work correctly.',
        () async {
          var session = sessionBuilder.build();

          var nullableLineValue = DummyPostgisData.seattleToSanDiegoLine;

          var row = ObjectWithPostgis(
            point: DummyPostgisData.sanFranciscoPoint,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: nullableLineValue,
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

          // Verify nullable line was stored
          expect(retrieved?.lineStringNullable, isNotNull);
          expect(
            retrieved?.lineStringNullable?.points.length,
            equals(nullableLineValue.points.length),
          );
        },
      );

      test(
        'Given nullable linestring field when setting to null then null is persisted correctly.',
        () async {
          var session = sessionBuilder.build();

          var row = ObjectWithPostgis(
            point: DummyPostgisData.sanFranciscoPoint,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: DummyPostgisData.londonToParisLine,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted = await ObjectWithPostgis.db.insertRow(session, row);

          // Clear nullable linestring
          inserted.lineStringNullable = null;
          var updated = await ObjectWithPostgis.db.updateRow(session, inserted);

          var retrieved = await ObjectWithPostgis.db.findById(
            session,
            updated.id!,
          );
          expect(retrieved?.lineStringNullable, isNull);
        },
      );

      test(
        'Given linestrings when updating nullable field then changes are persisted.',
        () async {
          var session = sessionBuilder.build();

          var initialNullableLine = DummyPostgisData.seattleToSanDiegoLine;
          var newNullableLine = DummyPostgisData.londonToParisLine;

          var row = ObjectWithPostgis(
            point: DummyPostgisData.sanFranciscoPoint,
            pointNullable: null,
            lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
            lineStringNullable: initialNullableLine,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted = await ObjectWithPostgis.db.insertRow(session, row);

          // Update nullable linestring
          inserted.lineStringNullable = newNullableLine;
          var updated = await ObjectWithPostgis.db.updateRow(session, inserted);

          var retrieved = await ObjectWithPostgis.db.findById(
            session,
            updated.id!,
          );
          expect(
            retrieved?.lineStringNullable?.points.length,
            equals(newNullableLine.points.length),
          );
          expect(
            retrieved?.lineStringNullable?.points.first.longitude,
            closeTo(newNullableLine.points.first.longitude, 0.0001),
          );
        },
      );

      test(
        'Given multiple linestrings when storing in database then all routes are retrievable.',
        () async {
          var session = sessionBuilder.build();

          // Multiple different routes
          var routes = [
            GeographyLineString([
              GeographyPoint(-84.5, 35.5),
              GeographyPoint(-84.2, 35.8),
            ]),
            GeographyLineString([
              GeographyPoint(-85.2, 35.5),
              GeographyPoint(-83.8, 35.5),
            ]),
            GeographyLineString([
              GeographyPoint(-83.0, 34.0),
              GeographyPoint(-82.0, 34.0),
            ]),
          ];

          for (var line in routes) {
            var row = ObjectWithPostgis(
              point: DummyPostgisData.sanFranciscoPoint,
              pointNullable: null,
              lineString: line,
              lineStringNullable: null,
              polygon: DummyPostgisData.simpleSquarePolygon,
              polygonNullable: null,
              multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              multiPolygonNullable: null,
            );
            await ObjectWithPostgis.db.insertRow(session, row);
          }

          // Retrieve all lines
          var results = await ObjectWithPostgis.db.find(session);

          // Should find all routes
          expect(results.length, greaterThanOrEqualTo(3));
        },
      );

      test(
        'Given linestrings with varying complexities when storing then all point counts are preserved.',
        () async {
          var session = sessionBuilder.build();

          // Simple line with 2 points
          var simpleLine = GeographyLineString([
            GeographyPoint(-122.4194, 37.7749),
            GeographyPoint(-118.2437, 34.0522),
          ]);

          // Complex line with multiple points
          var complexLine = GeographyLineString([
            GeographyPoint(0.0, 0.0),
            GeographyPoint(1.0, 1.0),
            GeographyPoint(2.0, 1.5),
            GeographyPoint(3.0, 2.0),
            GeographyPoint(4.0, 1.5),
          ]);

          var row1 = ObjectWithPostgis(
            point: DummyPostgisData.sanFranciscoPoint,
            pointNullable: null,
            lineString: simpleLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );
          var row2 = ObjectWithPostgis(
            point: DummyPostgisData.newYorkPoint,
            pointNullable: null,
            lineString: complexLine,
            lineStringNullable: null,
            polygon: DummyPostgisData.simpleSquarePolygon,
            polygonNullable: null,
            multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            multiPolygonNullable: null,
          );

          var inserted1 = await ObjectWithPostgis.db.insertRow(session, row1);
          var inserted2 = await ObjectWithPostgis.db.insertRow(session, row2);

          var retrieved1 = await ObjectWithPostgis.db.findById(
            session,
            inserted1.id!,
          );
          var retrieved2 = await ObjectWithPostgis.db.findById(
            session,
            inserted2.id!,
          );

          // Verify point counts
          expect(retrieved1?.lineString.points.length, equals(2));
          expect(retrieved2?.lineString.points.length, equals(5));

          // Verify coordinates preserved
          expect(
            retrieved1?.lineString.points.first.longitude,
            closeTo(-122.4194, 0.0001),
          );
          expect(
            retrieved2?.lineString.points.last.longitude,
            closeTo(4.0, 0.0001),
          );
        },
      );
    },
  );
}
