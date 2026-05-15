import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

final _london = GeographyPoint(longitude: -0.1278, latitude: 51.5074);
final _paris = GeographyPoint(longitude: 2.3522, latitude: 48.8566);
final _newYork = GeographyPoint(longitude: -74.006, latitude: 40.7128);

Future<void> _deleteAll(Session session) async {
  await ObjectWithGeographyPoint.db.deleteWhere(
    session,
    where: (_) => Constant.bool(true),
  );
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async => await _deleteAll(session));

  group('Given geography point column in database', () {
    test(
      'when inserting a row then the row is returned with correct values.',
      () async {
        var inserted = await ObjectWithGeographyPoint.db.insertRow(
          session,
          ObjectWithGeographyPoint(location: _london),
        );

        expect(inserted.id, isNotNull);
        expect(inserted.location, equals(_london));
        expect(inserted.locationNullable, isNull);
      },
    );

    test(
      'when inserting a row with a nullable field then it round-trips correctly.',
      () async {
        var inserted = await ObjectWithGeographyPoint.db.insertRow(
          session,
          ObjectWithGeographyPoint(
            location: _paris,
            locationNullable: _london,
          ),
        );

        expect(inserted.location, equals(_paris));
        expect(inserted.locationNullable, equals(_london));
      },
    );

    test('when fetching by id then the correct row is returned.', () async {
      var inserted = await ObjectWithGeographyPoint.db.insertRow(
        session,
        ObjectWithGeographyPoint(location: _london),
      );

      var fetched = await ObjectWithGeographyPoint.db.findById(
        session,
        inserted.id!,
      );

      expect(fetched, isNotNull);
      expect(fetched!.location, equals(_london));
    });

    test('when updating a row then the new value is persisted.', () async {
      var inserted = await ObjectWithGeographyPoint.db.insertRow(
        session,
        ObjectWithGeographyPoint(location: _london),
      );

      var updated = await ObjectWithGeographyPoint.db.updateRow(
        session,
        inserted.copyWith(location: _paris),
      );

      expect(updated.location, equals(_paris));

      var fetched = await ObjectWithGeographyPoint.db.findById(
        session,
        inserted.id!,
      );
      expect(fetched!.location, equals(_paris));
    });

    test('when inserting multiple rows then all rows are returned.', () async {
      await ObjectWithGeographyPoint.db.insert(session, [
        ObjectWithGeographyPoint(location: _london),
        ObjectWithGeographyPoint(location: _paris),
        ObjectWithGeographyPoint(location: _newYork),
      ]);

      var result = await ObjectWithGeographyPoint.db.find(
        session,
        where: (_) => Constant.bool(true),
      );

      expect(result.length, 3);
    });

    test('when deleting a row then it is no longer in the database.', () async {
      var inserted = await ObjectWithGeographyPoint.db.insertRow(
        session,
        ObjectWithGeographyPoint(location: _london),
      );

      await ObjectWithGeographyPoint.db.deleteRow(session, inserted);

      var fetched = await ObjectWithGeographyPoint.db.findById(
        session,
        inserted.id!,
      );
      expect(fetched, isNull);
    });

    test(
      'when filtering by location equality then only matching rows are returned.',
      () async {
        await ObjectWithGeographyPoint.db.insert(session, [
          ObjectWithGeographyPoint(location: _london),
          ObjectWithGeographyPoint(location: _paris),
        ]);

        var result = await ObjectWithGeographyPoint.db.find(
          session,
          where: (t) => t.location.equals(_london),
        );

        expect(result.length, 1);
        expect(result.first.location, equals(_london));
      },
    );

    test(
      'when using count with a where clause then the correct count is returned.',
      () async {
        await ObjectWithGeographyPoint.db.insert(session, [
          ObjectWithGeographyPoint(location: _london),
          ObjectWithGeographyPoint(location: _paris),
          ObjectWithGeographyPoint(location: _london),
        ]);

        var count = await ObjectWithGeographyPoint.db.count(
          session,
          where: (t) => t.location.equals(_london),
        );

        expect(count, 2);
      },
    );

    test(
      'when updating nullable field to null then null is persisted.',
      () async {
        var inserted = await ObjectWithGeographyPoint.db.insertRow(
          session,
          ObjectWithGeographyPoint(
            location: _london,
            locationNullable: _paris,
          ),
        );

        var updated = await ObjectWithGeographyPoint.db.updateRow(
          session,
          inserted.copyWith(locationNullable: null),
        );

        expect(updated.locationNullable, isNull);
      },
    );
  });
}
