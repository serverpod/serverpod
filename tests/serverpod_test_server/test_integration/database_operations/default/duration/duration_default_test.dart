import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" Duration fields,', () {
    tearDownAll(
      () async => DurationDefault.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "default=1d 2h 10min 30s 100ms" field value should be the expected duration',
      () async {
        var object = DurationDefault();
        var databaseObject = await DurationDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.durationDefault,
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
      'when creating a record in the database, then the nullable "default=2d 1h 20min 40s 100ms" field value should be the expected duration',
      () async {
        var object = DurationDefault();
        var databaseObject = await DurationDefault.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.durationDefaultNull,
          equals(
            Duration(
              days: 2,
              hours: 1,
              minutes: 20,
              seconds: 40,
              milliseconds: 100,
            ),
          ),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "durationDefault" field value should match the provided value',
      () async {
        var specificDuration = Duration(
          days: 3,
          hours: 4,
          minutes: 15,
          seconds: 45,
          milliseconds: 500,
        );
        var specificObject = DurationDefault(
          durationDefault: specificDuration,
        );
        var specificDatabaseObject = await DurationDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.durationDefault,
          equals(specificDuration),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "durationDefaultNull" field value should match the provided value',
      () async {
        var specificDuration = Duration(
          days: 3,
          hours: 5,
          minutes: 25,
          seconds: 50,
          milliseconds: 600,
        );
        var specificObject = DurationDefault(
          durationDefaultNull: specificDuration,
        );
        var specificDatabaseObject = await DurationDefault.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.durationDefaultNull,
          equals(specificDuration),
        );
      },
    );
  });
}
