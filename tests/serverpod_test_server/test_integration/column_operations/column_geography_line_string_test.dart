import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final _routeAB = GeographyLineString(
  points: [
    GeographyPoint(longitude: -0.1278, latitude: 51.5074), // London
    GeographyPoint(longitude: 2.3522, latitude: 48.8566), // Paris
  ],
);

final _routeBC = GeographyLineString(
  points: [
    GeographyPoint(longitude: 2.3522, latitude: 48.8566), // Paris
    GeographyPoint(longitude: 13.405, latitude: 52.52), // Berlin
  ],
);

final _routeABC = GeographyLineString(
  points: [
    GeographyPoint(longitude: -0.1278, latitude: 51.5074), // London
    GeographyPoint(longitude: 2.3522, latitude: 48.8566), // Paris
    GeographyPoint(longitude: 13.405, latitude: 52.52), // Berlin
  ],
);

Future<void> _deleteAll(Session session) async {
  await ObjectWithGeographyLineString.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async => await _deleteAll(session));

  group('Given geography line string column in database', () {
    test(
      'when inserting a row then the row is returned with correct values.',
      () async {
        var inserted = await ObjectWithGeographyLineString.db.insertRow(
          session,
          ObjectWithGeographyLineString(lineString: _routeAB),
        );

        expect(inserted.id, isNotNull);
        expect(inserted.lineString, equals(_routeAB));
        expect(inserted.lineStringNullable, isNull);
      },
    );

    test(
      'when inserting a row with a nullable field then it round-trips correctly.',
      () async {
        var inserted = await ObjectWithGeographyLineString.db.insertRow(
          session,
          ObjectWithGeographyLineString(
            lineString: _routeAB,
            lineStringNullable: _routeBC,
          ),
        );

        expect(inserted.lineString, equals(_routeAB));
        expect(inserted.lineStringNullable, equals(_routeBC));
      },
    );

    test('when fetching by id then the correct row is returned.', () async {
      var inserted = await ObjectWithGeographyLineString.db.insertRow(
        session,
        ObjectWithGeographyLineString(lineString: _routeABC),
      );

      var fetched = await ObjectWithGeographyLineString.db.findById(
        session,
        inserted.id!,
      );

      expect(fetched, isNotNull);
      expect(fetched!.lineString, equals(_routeABC));
    });

    test('when updating a row then the new value is persisted.', () async {
      var inserted = await ObjectWithGeographyLineString.db.insertRow(
        session,
        ObjectWithGeographyLineString(lineString: _routeAB),
      );

      var updated = await ObjectWithGeographyLineString.db.updateRow(
        session,
        inserted.copyWith(lineString: _routeBC),
      );

      expect(updated.lineString, equals(_routeBC));

      var fetched = await ObjectWithGeographyLineString.db.findById(
        session,
        inserted.id!,
      );
      expect(fetched!.lineString, equals(_routeBC));
    });

    test('when inserting multiple rows then all rows are returned.', () async {
      await ObjectWithGeographyLineString.db.insert(session, [
        ObjectWithGeographyLineString(lineString: _routeAB),
        ObjectWithGeographyLineString(lineString: _routeBC),
        ObjectWithGeographyLineString(lineString: _routeABC),
      ]);

      var result = await ObjectWithGeographyLineString.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test('when deleting a row then it is no longer in the database.', () async {
      var inserted = await ObjectWithGeographyLineString.db.insertRow(
        session,
        ObjectWithGeographyLineString(lineString: _routeAB),
      );

      await ObjectWithGeographyLineString.db.deleteRow(session, inserted);

      var fetched = await ObjectWithGeographyLineString.db.findById(
        session,
        inserted.id!,
      );
      expect(fetched, isNull);
    });

    test(
      'when filtering by equality then only matching rows are returned.',
      () async {
        await ObjectWithGeographyLineString.db.insert(session, [
          ObjectWithGeographyLineString(lineString: _routeAB),
          ObjectWithGeographyLineString(lineString: _routeBC),
        ]);

        var result = await ObjectWithGeographyLineString.db.find(
          session,
          where: (t) => t.lineString.equals(_routeAB),
        );

        expect(result.length, 1);
        expect(result.first.lineString, equals(_routeAB));
      },
    );

    test(
      'when filtering with dwithin then only nearby lines are returned.',
      () async {
        // _routeAB passes through London-Paris area; _routeABC passes through London-Paris-Berlin.
        await ObjectWithGeographyLineString.db.insert(session, [
          ObjectWithGeographyLineString(lineString: _routeAB),
          ObjectWithGeographyLineString(lineString: _routeBC),
        ]);

        // Point near London; _routeAB starts there, _routeBC does not.
        final nearLondon = GeographyPoint(longitude: -0.13, latitude: 51.51);

        var result = await ObjectWithGeographyLineString.db.find(
          session,
          where: (t) => t.lineString.dwithin(nearLondon, 10000), // 10 km
        );

        expect(result.length, 1);
        expect(result.first.lineString, equals(_routeAB));
      },
    );

    test(
      'when updating nullable field to null then null is persisted.',
      () async {
        var inserted = await ObjectWithGeographyLineString.db.insertRow(
          session,
          ObjectWithGeographyLineString(
            lineString: _routeAB,
            lineStringNullable: _routeBC,
          ),
        );

        var updated = await ObjectWithGeographyLineString.db.updateRow(
          session,
          inserted.copyWith(lineStringNullable: null),
        );

        expect(updated.lineStringNullable, isNull);
      },
    );
  });
}
