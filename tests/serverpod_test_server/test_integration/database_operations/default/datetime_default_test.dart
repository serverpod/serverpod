import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "default" fields,', () {
    tearDownAll(() async => DateTimeDefault.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        ));

    group('when creating a record in the database,', () {
      var object = DateTimeDefault();
      late DateTimeDefault databaseObject;

      setUpAll(() async {
        databaseObject = await DateTimeDefault.db.insertRow(
          session,
          object,
        );
      });

      test(
        'then all fields should be in UTC',
        () {
          expect(databaseObject.dateTimeDefaultNow.isUtc, true);
          expect(databaseObject.dateTimeDefaultStr.isUtc, true);
          expect(databaseObject.dateTimeDefaultStrNull?.isUtc, true);
        },
      );

      test(
        'then all fields value should match the defaults',
        () {
          expect(
            databaseObject.dateTimeDefaultNow
                .difference(DateTime.now())
                .inSeconds,
            0,
          );

          expect(
            databaseObject.dateTimeDefaultStr,
            DateTime.parse('2024-05-34T22:00:00.000Z'),
          );

          expect(
            databaseObject.dateTimeDefaultStrNull,
            DateTime.parse('2024-05-34T22:00:00.000Z'),
          );
        },
      );
    });
  });

  group('Given a class with "defaultModel" fields,', () {
    tearDownAll(() async => DateTimeDefaultModel.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        ));

    group('when creating a record in the database,', () {
      var object = DateTimeDefaultModel();
      late DateTimeDefaultModel databaseObject;

      setUpAll(() async {
        databaseObject = await DateTimeDefaultModel.db.insertRow(
          session,
          object,
        );
      });

      test(
        'then all fields should be in UTC',
        () {
          expect(databaseObject.dateTimeDefaultModelNow.isUtc, true);
          expect(databaseObject.dateTimeDefaultModelStr.isUtc, true);
          expect(databaseObject.dateTimeDefaultModelStrNull?.isUtc, true);
        },
      );

      test(
        'then all fields value should match the defaults',
        () {
          expect(
            databaseObject.dateTimeDefaultModelNow
                .difference(DateTime.now())
                .inSeconds,
            0,
          );

          expect(
            databaseObject.dateTimeDefaultModelStr,
            DateTime.parse("2024-05-34T22:00:00.000Z"),
          );

          expect(
            databaseObject.dateTimeDefaultModelStrNull,
            DateTime.parse("2024-05-34T22:00:00.000Z"),
          );
        },
      );
    });
  });

  group('Given a class with "defaultPersist" fields,', () {
    tearDownAll(() async => DateTimeDefaultPersist.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        ));

    group('when creating a record in the database,', () {
      var object = DateTimeDefaultPersist();
      late DateTimeDefaultPersist databaseObject;

      setUpAll(() async {
        databaseObject = await DateTimeDefaultPersist.db.insertRow(
          session,
          object,
        );
      });

      test(
        'then all fields should be in UTC',
        () {
          expect(databaseObject.dateTimeDefaultPersistNow?.isUtc, true);
          expect(databaseObject.dateTimeDefaultPersistStr?.isUtc, true);
        },
      );

      test(
        'then all fields value should match the defaults',
        () {
          expect(
            databaseObject.dateTimeDefaultPersistNow!
                .difference(DateTime.now())
                .inSeconds,
            0,
          );

          expect(
            databaseObject.dateTimeDefaultPersistStr,
            DateTime.parse("2024-05-10T22:00:00.000Z"),
          );
        },
      );
    });

    group('when creating a record in the database with an unsafe query,', () {
      late DateTimeDefaultPersist? databaseObject;

      setUpAll(() async {
        await session.db.unsafeQuery(
          '''
          INSERT INTO ${DateTimeDefaultPersist.t.tableName}
          VALUES (DEFAULT, DEFAULT);
          ''',
        );
        databaseObject = await DateTimeDefaultPersist.db.findFirstRow(session);
      });

      test(
        'then all fields should be in UTC',
        () {
          expect(databaseObject?.dateTimeDefaultPersistNow?.isUtc, true);
          expect(databaseObject?.dateTimeDefaultPersistStr?.isUtc, true);
        },
      );

      test(
        'then all fields value should match the defaults',
        () {
          expect(
            databaseObject!.dateTimeDefaultPersistNow!
                .difference(DateTime.now())
                .inSeconds,
            0,
          );

          expect(
            databaseObject!.dateTimeDefaultPersistStr,
            DateTime.parse("2024-05-10T22:00:00.000Z"),
          );
        },
      );
    });
  });

  group('Given a class with mixed default fields,', () {
    tearDownAll(() async => DateTimeDefaultMix.db.deleteWhere(
          session,
          where: (_) => Constant.bool(true),
        ));

    group('when creating a record in the database with an unsafe query,', () {
      late DateTimeDefaultMix? databaseObject;

      setUpAll(() async {
        await session.db.unsafeQuery(
          '''
          INSERT INTO "${DateTimeDefaultMix.t.tableName}" ("dateTimeDefaultAndDefaultModel", "dateTimeDefaultAndDefaultPersist", "dateTimeDefaultModelAndDefaultPersist")
          VALUES ('2024-05-10T22:00:00.000Z', DEFAULT, DEFAULT);
          ''',
        );
        databaseObject = await DateTimeDefaultMix.db.findFirstRow(session);
      });

      test(
          'then all fields with "defaultPersist" value should have "defaultPersist" values and not other defaults',
          () {
        expect(
          databaseObject?.dateTimeDefaultAndDefaultPersist,
          DateTime.tryParse('2024-05-10T22:00:00.000Z'),
        );
        expect(
          databaseObject?.dateTimeDefaultModelAndDefaultPersist,
          DateTime.tryParse('2024-05-10T22:00:00.000Z'),
        );
      });
    });
  });
}
