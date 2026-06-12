import 'package:meta/meta.dart';

import '../../query_parameters.dart';

typedef _LiteralOrComment = ({String text, int end});

/// Converts PostgreSQL-style `$1`, `$2`, … and `@name` placeholders to SQLite
/// `?` form, only in SQL **code** — never inside `'…'`, `"…"`, `-- …`, or
/// `/* … */`.
@internal
(String sql, List<Object?> values) convertQueryParametersForSqlite(
  String query,
  QueryParameters? parameters,
) {
  if (parameters == null) return (query, const []);

  return switch (parameters) {
    QueryParametersPositional(:final parameters) => (
      _convertPositional(query, parameters.length),
      parameters,
    ),
    QueryParametersNamed(:final parameters) => _convertNamed(query, parameters),
    _ => (query, const []),
  };
}

String _convertPositional(String sql, int paramCount) {
  final out = StringBuffer();
  var i = 0;
  while (i < sql.length) {
    final literal = _tryReadQuotedLiteralOrComment(sql, i);
    if (literal != null) {
      out.write(literal.text);
      i = literal.end;
      continue;
    }
    final end = _indexOfNextQuotedLiteralOrComment(sql, i);
    out.write(_replacePositionalInCodeSlice(sql, i, end, paramCount));
    i = end;
  }
  return out.toString();
}

(String sql, List<Object?>) _convertNamed(
  String sql,
  Map<String, Object?> map,
) {
  final namesInOrder = <String>[];
  final out = StringBuffer();
  var i = 0;
  while (i < sql.length) {
    final literal = _tryReadQuotedLiteralOrComment(sql, i);
    if (literal != null) {
      out.write(literal.text);
      i = literal.end;
      continue;
    }
    final end = _indexOfNextQuotedLiteralOrComment(sql, i);
    out.write(_replaceNamedInCodeSlice(sql, i, end, namesInOrder));
    i = end;
  }
  final values = namesInOrder.map((n) => map[n]).toList();
  return (out.toString(), values);
}

/// Returns the slice if [i] starts `'…'`, `"…"`, `--…`, or `/*…*/`.
_LiteralOrComment? _tryReadQuotedLiteralOrComment(String sql, int i) {
  if (i >= sql.length) return null;
  switch (sql.codeUnitAt(i)) {
    case 0x27: // '
      final end = _skipSingleQuotedString(sql, i);
      return (text: sql.substring(i, end), end: end);
    case 0x22: // "
      final end = _skipDoubleQuotedIdentifier(sql, i);
      return (text: sql.substring(i, end), end: end);
    case 0x2D:
      if (i + 1 < sql.length && sql.codeUnitAt(i + 1) == 0x2D) {
        var j = i + 2;
        while (j < sql.length) {
          final ch = sql.codeUnitAt(j);
          if (ch == 0x0A || ch == 0x0D) break;
          j++;
        }
        return (text: sql.substring(i, j), end: j);
      }
      return null;
    case 0x2F:
      if (i + 1 < sql.length && sql.codeUnitAt(i + 1) == 0x2A) {
        var j = i + 2;
        while (j < sql.length) {
          if (sql.codeUnitAt(j) == 0x2A &&
              j + 1 < sql.length &&
              sql.codeUnitAt(j + 1) == 0x2F) {
            j += 2;
            break;
          }
          j++;
        }
        return (text: sql.substring(i, j), end: j);
      }
      return null;
    default:
      return null;
  }
}

/// Smallest index ≥ [i] where a quoted literal or comment begins, or [sql.length].
int _indexOfNextQuotedLiteralOrComment(String sql, int i) {
  var j = i;
  while (j < sql.length) {
    final c = sql.codeUnitAt(j);
    if (c == 0x27 || c == 0x22) return j;
    if (c == 0x2D && j + 1 < sql.length && sql.codeUnitAt(j + 1) == 0x2D) {
      return j;
    }
    if (c == 0x2F && j + 1 < sql.length && sql.codeUnitAt(j + 1) == 0x2A) {
      return j;
    }
    j++;
  }
  return j;
}

/// `''` escapes a quote inside `'…'`.
int _skipSingleQuotedString(String sql, int openQuote) {
  var i = openQuote + 1;
  while (i < sql.length) {
    final c = sql.codeUnitAt(i);
    if (c == 0x27) {
      if (i + 1 < sql.length && sql.codeUnitAt(i + 1) == 0x27) {
        i += 2;
        continue;
      }
      return i + 1;
    }
    i++;
  }
  return i;
}

/// `"…"` delimited identifiers; `""` escapes a quote.
int _skipDoubleQuotedIdentifier(String sql, int openQuote) {
  var i = openQuote + 1;
  while (i < sql.length) {
    final c = sql.codeUnitAt(i);
    if (c == 0x22) {
      if (i + 1 < sql.length && sql.codeUnitAt(i + 1) == 0x22) {
        i += 2;
        continue;
      }
      return i + 1;
    }
    i++;
  }
  return i;
}

/// [start:end] contains no quotes or comments; only `$n` placeholders are rewritten.
String _replacePositionalInCodeSlice(
  String sql,
  int start,
  int end,
  int paramCount,
) {
  final out = StringBuffer();
  var i = start;
  while (i < end) {
    if (sql.codeUnitAt(i) == 0x24 && i + 1 < end) {
      final digitStart = i + 1;
      final d0 = sql.codeUnitAt(digitStart);
      if (d0 >= 0x30 && d0 <= 0x39) {
        var digitEnd = digitStart;
        while (digitEnd < end) {
          final d = sql.codeUnitAt(digitEnd);
          if (d < 0x30 || d > 0x39) break;
          digitEnd++;
        }
        final n = int.parse(sql.substring(digitStart, digitEnd));
        if (n >= 1 && n <= paramCount) {
          out.write('?');
          i = digitEnd;
          continue;
        }
      }
    }
    out.writeCharCode(sql.codeUnitAt(i));
    i++;
  }
  return out.toString();
}

final _namedParamLeadingWord = RegExp(r'^\w+');

/// Same slice contract as [_replacePositionalInCodeSlice]; collects `@name` order.
String _replaceNamedInCodeSlice(
  String sql,
  int start,
  int end,
  List<String> namesInOrder,
) {
  final out = StringBuffer();
  var i = start;
  while (i < end) {
    if (sql.codeUnitAt(i) == 0x40) {
      final name = _namedParamLeadingWord
          .firstMatch(
            sql.substring(i + 1, end),
          )
          ?.group(0);
      if (name != null) {
        namesInOrder.add(name);
        out.write('?');
        i += 1 + name.length;
        continue;
      }
    }
    out.writeCharCode(sql.codeUnitAt(i));
    i++;
  }
  return out.toString();
}
