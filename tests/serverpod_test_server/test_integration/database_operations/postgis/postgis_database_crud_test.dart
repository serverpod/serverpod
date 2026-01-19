import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';
import 'dummy_postgis_data.dart';

void main() async {
  withServerpod(
    'PostGIS CRUD Operations for ObjectWithPostgis',
    (sessionBuilder, _) {
      group('Testing POSTGIS Point CRUD Operations', () {
        test(
          'Given inserting ObjectWithPostgis with point then it is inserted correctly.',
          () async {
            var session = sessionBuilder.build();

            await session.db.transaction((transaction) async {
              var postgisObject = ObjectWithPostgis(
                point: DummyPostgisData.sanFranciscoPoint,
                pointNullable: DummyPostgisData.newYorkPoint,
                lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
                polygon: DummyPostgisData.simpleSquarePolygon,
                multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              );

              var insertedObject = await ObjectWithPostgis.db.insertRow(
                session,
                postgisObject,
                transaction: transaction,
              );

              expect(insertedObject.id, isNotNull);
              expect(insertedObject.point.latitude, equals(37.7749));
              expect(insertedObject.point.longitude, equals(-122.4194));
              expect(insertedObject.pointNullable?.latitude, equals(40.7128));
            });
          },
        );

        test(
          'Given inserted ObjectWithPostgis when fetching by id then all fields are retrieved correctly.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.londonPoint,
              pointNullable: null,
              lineString: DummyPostgisData.londonToParisLine,
              lineStringNullable: DummyPostgisData.seattleToSanDiegoLine,
              polygon: DummyPostgisData.trianglePolygon,
              multiPolygon: DummyPostgisData.threeTrianglesMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched, isNotNull);
            expect(fetched!.point.latitude, equals(51.5074));
            expect(fetched.point.longitude, equals(-0.1276));
            expect(fetched.pointNullable, isNull);
            expect(fetched.lineStringNullable, isNotNull);
          },
        );

        test(
          'Given multiple ObjectWithPostgis when finding all then they are all retrieved.',
          () async {
            var session = sessionBuilder.build();

            final objects = [
              ObjectWithPostgis(
                point: DummyPostgisData.sanFranciscoPoint,
                lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
                polygon: DummyPostgisData.simpleSquarePolygon,
                multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              ),
              ObjectWithPostgis(
                point: DummyPostgisData.tokyoPoint,
                lineString: DummyPostgisData.londonToParisLine,
                polygon: DummyPostgisData.trianglePolygon,
                multiPolygon: DummyPostgisData.threeTrianglesMultiPolygon,
              ),
            ];

            for (var obj in objects) {
              await ObjectWithPostgis.db.insertRow(session, obj);
            }

            var allObjects = await ObjectWithPostgis.db.find(session);

            expect(allObjects.length, greaterThanOrEqualTo(2));
            expect(allObjects.any((o) => o.point.latitude == 37.7749), isTrue);
            expect(allObjects.any((o) => o.point.latitude == 35.6762), isTrue);
          },
        );
      });

      group('Testing POSTGIS LineString CRUD Operations', () {
        test(
          'Given inserting ObjectWithPostgis with linestring then it is inserted correctly.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.equatorPoint,
              lineString: DummyPostgisData.seattleToSanDiegoLine,
              lineStringNullable: DummyPostgisData.triangleLine,
              polygon: DummyPostgisData.pentagonPolygon,
              multiPolygon: DummyPostgisData.mixedShapesMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched, isNotNull);
            expect(fetched!.lineString.points.length, equals(4));
            expect(
              fetched.lineString.points.first.latitude,
              equals(47.6062),
            );
          },
        );

        test(
          'Given updating ObjectWithPostgis linestring when updating then changes are persisted.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.sanFranciscoPoint,
              lineString: DummyPostgisData.londonToParisLine,
              polygon: DummyPostgisData.simpleSquarePolygon,
              multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var updated = inserted.copyWith(
              lineString: DummyPostgisData.seattleToSanDiegoLine,
            );

            await ObjectWithPostgis.db.updateRow(session, updated);

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched!.lineString.points.length, equals(4));
            expect(fetched.lineString.points.first.latitude, equals(47.6062));
          },
        );
      });

      group('Testing POSTGIS Polygon CRUD Operations', () {
        test(
          'Given inserting ObjectWithPostgis with polygon then it is inserted correctly.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.tokyoPoint,
              lineString: DummyPostgisData.triangleLine,
              polygon: DummyPostgisData.polygonWithHole,
              polygonNullable: DummyPostgisData.largeSquarePolygon,
              multiPolygon: DummyPostgisData.islandsMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched, isNotNull);
            expect(fetched!.polygon.rings.length, equals(2)); // exterior + hole
            expect(fetched.polygonNullable, isNotNull);
          },
        );

        test(
          'Given updating ObjectWithPostgis polygon when updating then changes are persisted.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.equatorPoint,
              lineString: DummyPostgisData.londonToParisLine,
              polygon: DummyPostgisData.simpleSquarePolygon,
              multiPolygon: DummyPostgisData.threeTrianglesMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var updated = inserted.copyWith(
              polygon: DummyPostgisData.polygonWithHole,
              polygonNullable: DummyPostgisData.pentagonPolygon,
            );

            await ObjectWithPostgis.db.updateRow(session, updated);

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched!.polygon.rings.length, equals(2));
            expect(fetched.polygonNullable!.rings.first.length, equals(6));
          },
        );
      });

      group('Testing POSTGIS MultiPolygon CRUD Operations', () {
        test(
          'Given inserting ObjectWithPostgis with multipolygon then it is inserted correctly.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.newYorkPoint,
              lineString: DummyPostgisData.seattleToSanDiegoLine,
              polygon: DummyPostgisData.pentagonPolygon,
              multiPolygon: DummyPostgisData.mixedShapesMultiPolygon,
              multiPolygonNullable: DummyPostgisData.islandsMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched, isNotNull);
            expect(fetched!.multiPolygon.polygons.length, equals(3));
            expect(fetched.multiPolygonNullable!.polygons.length, equals(3));
          },
        );

        test(
          'Given updating ObjectWithPostgis multipolygon when updating then changes are persisted.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.sanFranciscoPoint,
              lineString: DummyPostgisData.londonToParisLine,
              polygon: DummyPostgisData.simpleSquarePolygon,
              multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var updated = inserted.copyWith(
              multiPolygon: DummyPostgisData.mixedShapesMultiPolygon,
            );

            await ObjectWithPostgis.db.updateRow(session, updated);

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched!.multiPolygon.polygons.length, equals(3));
          },
        );
      });

      group('Testing POSTGIS Delete Operations', () {
        test(
          'Given inserted ObjectWithPostgis when deleting then it is removed from database.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.londonPoint,
              lineString: DummyPostgisData.londonToParisLine,
              polygon: DummyPostgisData.trianglePolygon,
              multiPolygon: DummyPostgisData.threeTrianglesMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var beforeDelete = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );
            expect(beforeDelete, isNotNull);

            await ObjectWithPostgis.db.deleteRow(session, inserted);

            var afterDelete = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );
            expect(afterDelete, isNull);
          },
        );

        test(
          'Given multiple ObjectWithPostgis when deleting specific one then only that one is removed.',
          () async {
            var session = sessionBuilder.build();

            final obj1 = ObjectWithPostgis(
              point: DummyPostgisData.sanFranciscoPoint,
              lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
              polygon: DummyPostgisData.simpleSquarePolygon,
              multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
            );

            final obj2 = ObjectWithPostgis(
              point: DummyPostgisData.tokyoPoint,
              lineString: DummyPostgisData.londonToParisLine,
              polygon: DummyPostgisData.trianglePolygon,
              multiPolygon: DummyPostgisData.threeTrianglesMultiPolygon,
            );

            var inserted1 = await ObjectWithPostgis.db.insertRow(session, obj1);
            var inserted2 = await ObjectWithPostgis.db.insertRow(session, obj2);

            await ObjectWithPostgis.db.deleteRow(session, inserted1);

            var found1 = await ObjectWithPostgis.db.findById(
              session,
              inserted1.id!,
            );
            var found2 = await ObjectWithPostgis.db.findById(
              session,
              inserted2.id!,
            );

            expect(found1, isNull);
            expect(found2, isNotNull);
          },
        );
      });

      group('Testing POSTGIS Nullable Fields', () {
        test(
          'Given ObjectWithPostgis with null geometry fields when inserting then nulls are preserved.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.equatorPoint,
              pointNullable: null,
              lineString: DummyPostgisData.triangleLine,
              lineStringNullable: null,
              polygon: DummyPostgisData.pentagonPolygon,
              polygonNullable: null,
              multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              multiPolygonNullable: null,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched!.pointNullable, isNull);
            expect(fetched.lineStringNullable, isNull);
            expect(fetched.polygonNullable, isNull);
            expect(fetched.multiPolygonNullable, isNull);
            expect(fetched.point, isNotNull);
            expect(fetched.lineString, isNotNull);
          },
        );

        test(
          'Given ObjectWithPostgis with all nullable fields set when updating to null then nulls are persisted.',
          () async {
            var session = sessionBuilder.build();

            var postgisObject = ObjectWithPostgis(
              point: DummyPostgisData.sanFranciscoPoint,
              pointNullable: DummyPostgisData.newYorkPoint,
              lineString: DummyPostgisData.londonToParisLine,
              lineStringNullable: DummyPostgisData.seattleToSanDiegoLine,
              polygon: DummyPostgisData.simpleSquarePolygon,
              polygonNullable: DummyPostgisData.largeSquarePolygon,
              multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              multiPolygonNullable: DummyPostgisData.threeTrianglesMultiPolygon,
            );

            var inserted = await ObjectWithPostgis.db.insertRow(
              session,
              postgisObject,
            );

            var updated = inserted.copyWith(
              pointNullable: null,
              lineStringNullable: null,
              polygonNullable: null,
              multiPolygonNullable: null,
            );

            await ObjectWithPostgis.db.updateRow(session, updated);

            var fetched = await ObjectWithPostgis.db.findById(
              session,
              inserted.id!,
            );

            expect(fetched!.pointNullable, isNull);
            expect(fetched.lineStringNullable, isNull);
            expect(fetched.polygonNullable, isNull);
            expect(fetched.multiPolygonNullable, isNull);
          },
        );
      });

      group('Testing POSTGIS Bulk Operations', () {
        test(
          'Given multiple ObjectWithPostgis when inserting in batch then all are inserted.',
          () async {
            var session = sessionBuilder.build();

            final objects = [
              ObjectWithPostgis(
                point: DummyPostgisData.sanFranciscoPoint,
                lineString: DummyPostgisData.sanFranciscoToLosAngelesLine,
                polygon: DummyPostgisData.simpleSquarePolygon,
                multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              ),
              ObjectWithPostgis(
                point: DummyPostgisData.londonPoint,
                lineString: DummyPostgisData.londonToParisLine,
                polygon: DummyPostgisData.trianglePolygon,
                multiPolygon: DummyPostgisData.threeTrianglesMultiPolygon,
              ),
              ObjectWithPostgis(
                point: DummyPostgisData.tokyoPoint,
                lineString: DummyPostgisData.seattleToSanDiegoLine,
                polygon: DummyPostgisData.pentagonPolygon,
                multiPolygon: DummyPostgisData.mixedShapesMultiPolygon,
              ),
            ];

            var inserted = await ObjectWithPostgis.db.insert(
              session,
              objects,
            );

            expect(inserted.length, equals(3));
            expect(inserted.every((o) => o.id != null), isTrue);
          },
        );

        test(
          'Given multiple ObjectWithPostgis when updating in batch then all are updated.',
          () async {
            var session = sessionBuilder.build();

            final objects = [
              ObjectWithPostgis(
                point: DummyPostgisData.sanFranciscoPoint,
                lineString: DummyPostgisData.londonToParisLine,
                polygon: DummyPostgisData.simpleSquarePolygon,
                multiPolygon: DummyPostgisData.twoSquaresMultiPolygon,
              ),
              ObjectWithPostgis(
                point: DummyPostgisData.tokyoPoint,
                lineString: DummyPostgisData.londonToParisLine,
                polygon: DummyPostgisData.trianglePolygon,
                multiPolygon: DummyPostgisData.threeTrianglesMultiPolygon,
              ),
            ];

            var inserted = await ObjectWithPostgis.db.insert(
              session,
              objects,
            );

            var updated = inserted.map((o) {
              return o.copyWith(
                lineString: DummyPostgisData.seattleToSanDiegoLine,
              );
            }).toList();

            await ObjectWithPostgis.db.update(session, updated);

            var fetched = await ObjectWithPostgis.db.find(session);
            expect(
              fetched
                  .where(
                    (o) => o.id == inserted[0].id || o.id == inserted[1].id,
                  )
                  .every((o) => o.lineString.points.length == 4),
              isTrue,
            );
          },
        );
      });
    },
  );
}
