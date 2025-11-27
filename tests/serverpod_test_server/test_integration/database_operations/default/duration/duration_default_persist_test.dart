import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" Duration fields,', () {
    tearDownAll(
      () async => DurationDefaultPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultPersist=1d 2h 10min 30s 100ms" field should be the expected duration',
      () async {
        var object = DurationDefaultPersist();
        var databaseObject = await DurationDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.durationDefaultPersist,
          equals(
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
          ),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=1d 2h 10min 30s 100ms" field should be the expected duration',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${DurationDefaultPersist.t.tableName}
        VALUES (DEFAULT);
        ''',
        );
        var databaseObject = await DurationDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject?.durationDefaultPersist,
          equals(
            Duration(
              days: 1,
              hours: 2,
              minutes: 10,
              seconds: 30,
              milliseconds: 100,
            ),
          ),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "durationDefaultPersist" field value should match the provided value',
      () async {
        var specificDuration = Duration(
          days: 3,
          hours: 4,
          minutes: 15,
          seconds: 45,
          milliseconds: 500,
        );
        var specificObject = DurationDefaultPersist(
          durationDefaultPersist: specificDuration,
        );
        var specificDatabaseObject = await DurationDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.durationDefaultPersist,
          equals(specificDuration),
        );
      },
    );
  });
}
