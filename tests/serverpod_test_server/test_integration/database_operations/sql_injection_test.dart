import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

/// Regression tests for GHSA-868m-gf4j-xr8g, where a String shaped like the
/// serialized ByteData marker `decode('...', 'base64')` was emitted into SQL
/// without escaping. Such strings are called marker-shaped below.

/// Matches all rows, once injected
const _orTruePayload =
    "decode('','base64')::text OR 1=1 "
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

  group('Given a table with a string column holding two rows', () {
    setUp(() async {
      await Types.db.insert(session, [
        Types(aString: 'alice-secret'),
        Types(aString: 'bob-secret'),
      ]);
    });

    group('and a marker-shaped string that tries to match all rows,', () {
      test(
        'when finding rows with a string equality filter on it, '
        'then it is treated as data and no rows match (no comparison bypass).',
        () async {
          var hits = await Types.db.find(
            session,
            where: (t) => t.aString.equals(_orTruePayload),
          );

          expect(hits, isEmpty);
        },
      );

      test(
        'when deleting rows with a string equality filter on it, '
        'then no rows are deleted.',
        () async {
          await Types.db.deleteWhere(
            session,
            where: (t) => t.aString.equals(_orTruePayload),
          );

          expect(await Types.db.count(session), equals(2));
        },
      );
    });

    group('and a marker-shaped string that tries to run a subselect,', () {
      test(
        'when finding rows with a string equality filter on it, '
        'then the subselect never executes and no rows match (no arbitrary read primitive).',
        () async {
          var hits = await Types.db.find(
            session,
            where: (t) => t.aString.equals(_subselectPayload),
          );

          expect(hits, isEmpty);
        },
      );
    });
  });

  group(
    'Given a table with a string column and a marker-shaped string that tries to match all rows,',
    () {
      test(
        'when inserting the string, then it is stored verbatim.',
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
        'when updating a row to the string, then it is stored verbatim.',
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
    },
  );

  group(
    'Given a table with a Uri column and a Uri carrying a single quote,',
    () {
      var hostileUri = Uri.parse("https://example.com/x'y?q='z");

      test(
        'when updating a row to the Uri through column values, '
        'then the quote is escaped and the Uri is stored verbatim.',
        () async {
          var inserted = await Types.db.insertRow(
            session,
            Types(aString: 'target'),
          );

          await Types.db.updateWhere(
            session,
            columnValues: (t) => [t.aUri(hostileUri)],
            where: (t) => t.aString.equals('target'),
          );

          var reread = await Types.db.findById(session, inserted.id!);
          expect(reread!.aUri, equals(hostileUri));
        },
      );

      test(
        'when finding rows with a Uri equality filter on it, '
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
    },
  );
}
