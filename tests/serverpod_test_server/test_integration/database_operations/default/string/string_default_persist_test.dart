import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given a class with "defaultPersist" fields,', () {
    tearDownAll(
      () async => StringDefaultPersist.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      ),
    );

    test(
      'when creating a record in the database, then the "defaultPersist=\'This is a default persist value\'" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.stringDefaultPersist,
          equals('This is a default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "defaultPersist=\'This is a default persist value\'" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject?.stringDefaultPersist,
          equals('This is a default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersist" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersist: 'A specific persist value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject.stringDefaultPersist,
          equals('A specific persist value'),
        );
      },
    );

    // Additional tests for new fields

    test(
      'when creating a record in the database, then the "stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject
              .stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
          equals('This is a \'default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject
              ?.stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
          equals('This is a \'default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
              'A \'specific\' value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
          equals('A \'specific\' value'),
        );
      },
    );

    test(
      'when creating a record in the database, then the "stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject
              .stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
          equals('This is a \'default\' persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject
              ?.stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
          equals('This is a \'default\' persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
              'A \'specific\' value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
          equals('A \'specific\' value'),
        );
      },
    );

    test(
      'when creating a record in the database, then the "stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject
              .stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
          equals('This is a "default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject
              ?.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
          equals('This is a "default persist value'),
        );
        expect(
          databaseObject
              ?.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
          equals("This is a \"default persist value"),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
              'A "specific" value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
          equals('A "specific" value'),
        );
      },
    );

    test(
      'when creating a record in the database, then the "stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject
              .stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
          equals('This is a "default" persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject
              ?.stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
          equals('This is a "default" persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
              'A "specific" value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
          equals('A "specific" value'),
        );
      },
    );

    test(
      'when creating a record in the database, then the "stringDefaultPersistSingleQuoteWithOneDoubleQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
          equals('This is a "default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistSingleQuoteWithOneDoubleQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject?.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
          equals('This is a "default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistSingleQuoteWithOneDoubleQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistSingleQuoteWithOneDoubleQuote:
              'A "specific" value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistSingleQuoteWithOneDoubleQuote,
          equals('A "specific" value'),
        );
      },
    );

    test(
      'when creating a record in the database, then the "stringDefaultPersistSingleQuoteWithTwoDoubleQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
          equals('This is a "default" persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistSingleQuoteWithTwoDoubleQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject?.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
          equals('This is a "default" persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistSingleQuoteWithTwoDoubleQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
              'A "specific" value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
          equals('A "specific" value'),
        );
      },
    );

    test(
      'when creating a record in the database, then the "stringDefaultPersistDoubleQuoteWithOneSingleQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
          equals('This is a \'default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistDoubleQuoteWithOneSingleQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject?.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
          equals('This is a \'default persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistDoubleQuoteWithOneSingleQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistDoubleQuoteWithOneSingleQuote:
              'A \'specific\' value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistDoubleQuoteWithOneSingleQuote,
          equals('A \'specific\' value'),
        );
      },
    );

    test(
      'when creating a record in the database, then the "stringDefaultPersistDoubleQuoteWithTwoSingleQuote" field should match the default value',
      () async {
        var object = StringDefaultPersist();
        var databaseObject = await StringDefaultPersist.db.insertRow(
          session,
          object,
        );
        expect(
          databaseObject.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
          equals('This is a \'default\' persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with an unsafe query, then the "stringDefaultPersistDoubleQuoteWithTwoSingleQuote" field should match the default value',
      () async {
        await session.db.unsafeQuery(
          '''
        INSERT INTO ${StringDefaultPersist.t.tableName}
        VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
        ''',
        );
        var databaseObject = await StringDefaultPersist.db.findFirstRow(
          session,
        );
        expect(
          databaseObject?.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
          equals('This is a \'default\' persist value'),
        );
      },
    );

    test(
      'when creating a record in the database with a specific value, then the "stringDefaultPersistDoubleQuoteWithTwoSingleQuote" field value should match the provided value',
      () async {
        var specificObject = StringDefaultPersist(
          stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
              'A \'specific\' value',
        );
        var specificDatabaseObject = await StringDefaultPersist.db.insertRow(
          session,
          specificObject,
        );
        expect(
          specificDatabaseObject
              .stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
          equals('A \'specific\' value'),
        );
      },
    );
  });
}
