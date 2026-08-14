import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

/// Regression tests for GHSA-868m-gf4j-xr8g.

/// Matches all rows, once injected
const _orTruePayload = "decode('','base64')::text OR 1=1 "
    "OR decode('','base64')=decode('', 'base64')";

/// Runs `(SELECT count(*) FROM types)`, once injected
const _subselectPayload =
    "decode('','base64')::text OR (SELECT count(*) FROM types) >= 0 "
    "OR decode('','base64')=decode('', 'base64')";

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await Types.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  group('Given rows in the database and a ColumnString equality filter', () {
    setUp(() async {
      await Types.db.insert(session, [
        Types(aString: 'alice-secret'),
        Types(aString: 'bob-secret'),
      ]);
    });

    test(
      'when the compared value is a marker-shaped payload carrying `OR 1=1` '
      'then it is treated as data and matches no rows (no comparison bypass).',
      () async {
        var hits = await Types.db.find(
          session,
          where: (t) => t.aString.equals(_orTruePayload),
        );

        expect(hits, isEmpty);
      },
    );

    test(
      'when the compared value is a marker-shaped payload carrying a subselect '
      'then the subselect never executes (no arbitrary read primitive).',
      () async {
        var hits = await Types.db.find(
          session,
          where: (t) => t.aString.equals(_subselectPayload),
        );

        expect(hits, isEmpty);
      },
    );

    test(
      'when the compared value is a marker-shaped payload that deletes rows via an injected predicate '
      'then no rows are affected.',
      () async {
        await Types.db.deleteWhere(
          session,
          where: (t) => t.aString.equals(_orTruePayload),
        );

        expect(await Types.db.count(session), equals(2));
      },
    );
  });

  group('Given a ColumnString round-trip through insert and update', () {
    test(
      'when a marker-shaped string is inserted then it is stored verbatim.',
      () async {
        var inserted = await Types.db.insertRow(
          session,
          Types(aString: _orTruePayload),
        );

        var reread = await Types.db.findById(session, inserted.id!);
        expect(reread!.aString, equals(_orTruePayload));
      },
    );

    test(
      'when a marker-shaped string is updated onto a row '
      'then it is stored verbatim.',
      () async {
        var inserted = await Types.db.insertRow(
          session,
          Types(aString: 'original'),
        );

        var updated = await Types.db.updateRow(
          session,
          inserted.copyWith(aString: _orTruePayload),
        );

        expect(updated.aString, equals(_orTruePayload));
      },
    );
  });

  group('Given a ColumnUri carrying a single quote', () {
    var hostileUri = Uri.parse("https://example.com/x'y?q='z");

    test(
      'when it is used in a ColumnUri.equals filter '
      'then it matches exactly its own row (escaped, not parsed as SQL).',
      () async {
        await Types.db.insert(session, [
          Types(aUri: hostileUri),
          Types(aUri: Uri.parse('https://example.com/other')),
        ]);

        var hits = await Types.db.find(
          session,
          where: (t) => t.aUri.equals(hostileUri),
        );

        expect(hits, hasLength(1));
        expect(hits.single.aUri, equals(hostileUri));
      },
    );
  });
}
