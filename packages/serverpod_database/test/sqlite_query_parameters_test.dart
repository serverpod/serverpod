import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_query_parameters.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a query with no query parameters, '
    'when converted for SQLite, '
    'then the query is unchanged and the values list is empty.',
    () {
      const sql = r"SELECT * FROM t WHERE x = $1 AND note = 'Price is $1'";
      final (out, values) = convertQueryParametersForSqlite(sql, null);
      expect(out, sql);
      expect(values, isEmpty);
    },
  );

  test(
    'Given a query with one numbered positional placeholder in executable SQL, '
    'when converted for SQLite, '
    'then the placeholder is replaced with ? and the argument list is unchanged.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT * FROM t WHERE id = $1',
        QueryParameters.positional([42]),
      );
      expect(sql, 'SELECT * FROM t WHERE id = ?');
      expect(values, [42]);
    },
  );

  test(
    'Given a query with two numbered positional placeholders in order, '
    'when converted for SQLite, '
    'then both placeholders are replaced with ? and values preserve argument order.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT * FROM t WHERE a = $1 AND b = $2',
        QueryParameters.positional(['x', 'y']),
      );
      expect(sql, 'SELECT * FROM t WHERE a = ? AND b = ?');
      expect(values, ['x', 'y']);
    },
  );

  test(
    'Given a query with a two-digit numbered positional placeholder in executable SQL, '
    'when converted for SQLite, '
    'then each placeholder is replaced with ? and \$1 is not treated as part of \$10.',
    () {
      final args = List<Object?>.generate(10, (i) => i + 1);
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $1, $10',
        QueryParameters.positional(args),
      );
      expect(sql, 'SELECT ?, ?');
      expect(values, args);
    },
  );

  test(
    'Given a query with a positional placeholder index above the bound count, '
    'when converted for SQLite, '
    'then that token is left as literal text.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $10',
        QueryParameters.positional(['only']),
      );
      expect(sql, r'SELECT $10');
      expect(values, ['only']);
    },
  );

  test(
    r'Given a query that contains $0 before a valid positional placeholder, '
    'when converted for SQLite, '
    r'then $0 is copied literally and the valid placeholder is replaced with ?.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $0, $1',
        QueryParameters.positional([99]),
      );
      expect(sql, r'SELECT $0, ?');
      expect(values, [99]);
    },
  );

  test(
    r'Given a query that still contains $1 but has an empty positional parameter list, '
    'when converted for SQLite, '
    'then placeholders are not replaced.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $1',
        QueryParameters.positional([]),
      );
      expect(sql, r'SELECT $1');
      expect(values, isEmpty);
    },
  );

  test(
    'Given a query with adjacent positional placeholders and no separating space, '
    'when converted for SQLite, '
    'then both placeholders become ? in the same executable region.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $1$2',
        QueryParameters.positional(['p', 'q']),
      );
      expect(sql, 'SELECT ??');
      expect(values, ['p', 'q']);
    },
  );

  test(
    r'Given a query with $ characters that are not followed by positional placeholder indices, '
    'when converted for SQLite, '
    'then those dollar signs are copied literally and valid placeholders are replaced with ?.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $, $x, $1',
        QueryParameters.positional([9]),
      );
      expect(sql, r'SELECT $, $x, ?');
      expect(values, [9]);
    },
  );

  test(
    'Given a query with a positional placeholder in executable SQL and another inside a single-quoted string, '
    'when converted for SQLite, '
    'then only the executable placeholder is replaced with ? and the string text is unchanged.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r"SELECT $1 AS x WHERE note = 'Price is $1'",
        QueryParameters.positional(['a', 'b']),
      );
      expect(
        sql,
        r"SELECT ? AS x WHERE note = 'Price is $1'",
      );
      expect(values, ['a', 'b']);
    },
  );

  test(
    'Given a query with a positional placeholder inside a single-quoted string that uses doubled quotes, '
    'when converted for SQLite, '
    'then the placeholder inside the string literal is not rewritten.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r"SELECT $1 WHERE t = 'it''s $1'",
        QueryParameters.positional(['v']),
      );
      expect(sql, r"SELECT ? WHERE t = 'it''s $1'");
      expect(values, ['v']);
    },
  );

  test(
    'Given a query with a positional placeholder inside a double-quoted identifier, '
    'when converted for SQLite, '
    'then the placeholder inside the identifier is left unchanged.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $1 FROM t WHERE "col$1" = 1',
        QueryParameters.positional([7]),
      );
      expect(sql, r'SELECT ? FROM t WHERE "col$1" = 1');
      expect(values, [7]);
    },
  );

  test(
    'Given a query with a positional placeholder inside a double-quoted identifier that contains doubled quotes, '
    'when converted for SQLite, '
    'then the closing delimiter is found correctly.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $1 FROM "a""b$1""c"',
        QueryParameters.positional([1]),
      );
      expect(sql, r'SELECT ? FROM "a""b$1""c"');
      expect(values, [1]);
    },
  );

  test(
    'Given a query with a positional placeholder in executable SQL and another inside a line comment, '
    'when converted for SQLite, '
    'then placeholders inside the comment are unchanged.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'''SELECT $1 -- keep $2 here
WHERE 1 = 1''',
        QueryParameters.positional(['x', 'y']),
      );
      expect(
        sql,
        r'''SELECT ? -- keep $2 here
WHERE 1 = 1''',
      );
      expect(values, ['x', 'y']);
    },
  );

  test(
    'Given a query with a positional placeholder in executable SQL and another inside a block comment, '
    'when converted for SQLite, '
    'then placeholders inside the comment are unchanged.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $1 /* hide $2 */ WHERE 1 = 1',
        QueryParameters.positional(['p', 'q']),
      );
      expect(sql, r'SELECT ? /* hide $2 */ WHERE 1 = 1');
      expect(values, ['p', 'q']);
    },
  );

  test(
    'Given a query with an unterminated block comment after a positional placeholder in executable SQL, '
    'when converted for SQLite, '
    'then the remainder is treated as a comment and only leading code placeholders are rewritten.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT $1 /* open $2',
        QueryParameters.positional(['a', 'b']),
      );
      expect(sql, r'SELECT ? /* open $2');
      expect(values, ['a', 'b']);
    },
  );

  test(
    'Given a query with one named placeholder in executable SQL, '
    'when converted for SQLite, '
    'then the placeholder is replaced with ? and values match the map.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT * FROM t WHERE id = @id',
        QueryParameters.named({'id': 5}),
      );
      expect(sql, 'SELECT * FROM t WHERE id = ?');
      expect(values, [5]);
    },
  );

  test(
    'Given a query with two distinct named placeholders in a non-alphabetical order, '
    'when converted for SQLite, '
    'then bound values follow the first appearance of each name in the query.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT @b, @a',
        QueryParameters.named({'a': 1, 'b': 2}),
      );
      expect(sql, 'SELECT ?, ?');
      expect(values, [2, 1]);
    },
  );

  test(
    'Given a query with the same named placeholder repeated, '
    'when converted for SQLite, '
    'then the value list includes that name for each placeholder occurrence in binding order.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'WHERE x = @tag AND y = @tag',
        QueryParameters.named({'tag': 'z'}),
      );
      expect(sql, 'WHERE x = ? AND y = ?');
      expect(values, ['z', 'z']);
    },
  );

  test(
    'Given a query with a named placeholder in executable SQL and another only inside a single-quoted string, '
    'when converted for SQLite, '
    'then the placeholder inside the string is not replaced and the value list omits it.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r"SELECT @a WHERE msg = 'hello @b'",
        QueryParameters.named({'a': 1, 'b': 2}),
      );
      expect(sql, r"SELECT ? WHERE msg = 'hello @b'");
      expect(values, [1]);
    },
  );

  test(
    'Given a query with a named placeholder in executable SQL and another only inside a line comment, '
    'when converted for SQLite, '
    'then the placeholder in the comment is omitted from the value list and left unchanged.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'''SELECT @a -- @b
WHERE 1=1''',
        QueryParameters.named({'a': 1, 'b': 2}),
      );
      expect(sql, r'''SELECT ? -- @b
WHERE 1=1''');
      expect(values, [1]);
    },
  );

  test(
    'Given a query with a named placeholder in executable SQL and another only inside a block comment, '
    'when converted for SQLite, '
    'then the placeholder in the comment is omitted from the value list and left unchanged.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT @a /* @b */ WHERE 1=1',
        QueryParameters.named({'a': 1, 'b': 2}),
      );
      expect(sql, r'SELECT ? /* @b */ WHERE 1=1');
      expect(values, [1]);
    },
  );

  test(
    'Given a query that ends with @ and no identifier, '
    'when converted for SQLite, '
    'then the at-sign is copied literally.',
    () {
      final (sql, values) = convertQueryParametersForSqlite(
        r'SELECT 1@',
        QueryParameters.named({}),
      );
      expect(sql, r'SELECT 1@');
      expect(values, isEmpty);
    },
  );
}
