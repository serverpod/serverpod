import 'package:meta/meta.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../serverpod_database.dart';

/// Resolves the output alias (`SELECT ... AS "<alias>"`) for every column
/// selected by a single query, guaranteeing that no two columns share an alias.
///
/// The column output alias is normally
/// `truncateIdentifier(column.fieldQueryAlias, 63)`. When two columns of a query
/// (e.g. from two relations included via the same long-named table) truncate to
/// the same string, one relation's value bleeds into the other's field on
/// deserialization. See https://github.com/serverpod/serverpod/issues/5287.
///
/// This resolver keeps that exact alias for every column that does not actually
/// collide, and only disambiguates genuine collisions by appending `_1`, `_2`,
/// … until unique. The result is a deterministic, pure function of
/// `(rootTable, include)`: the SQL builder and the result parser construct the
/// same resolver independently and therefore agree on every alias without
/// sharing state.
@internal
class ColumnAliasResolver {
  /// Map from a column's [Column.fieldQueryAlias] (unique per column when table
  /// aliases are unique) to its resolved, collision-free output alias.
  final Map<String, String> _aliasByFieldQueryAlias;

  ColumnAliasResolver._(this._aliasByFieldQueryAlias);

  /// Builds a resolver covering every column selected by a query rooted at
  /// [rootTable] with the given [include].
  ///
  /// Used by the result parser, which only knows `(rootTable, include)`. The
  /// query builder uses [ColumnAliasResolver.forColumns] with its actual select
  /// columns; for an include query the two enumerate the same columns in the
  /// same order, so they produce identical aliases.
  factory ColumnAliasResolver.forQuery(Table rootTable, Include? include) {
    return ColumnAliasResolver.forColumns(
      _orderedSelectedColumns(rootTable, include),
    );
  }

  /// Builds a resolver for an explicit, ordered list of selected [columns].
  factory ColumnAliasResolver.forColumns(Iterable<Column> columns) {
    var aliasByFieldQueryAlias = <String, String>{};
    var usedAliases = <String>{};

    for (var column in columns) {
      var key = column.fieldQueryAlias;
      // The same column can appear more than once (e.g. deduplicated in the
      // select list); the first occurrence owns the alias.
      if (aliasByFieldQueryAlias.containsKey(key)) continue;

      var alias = _allocateAlias(_baseAlias(key), usedAliases);
      aliasByFieldQueryAlias[key] = alias;
      usedAliases.add(alias);
    }

    return ColumnAliasResolver._(aliasByFieldQueryAlias);
  }

  /// The resolved output alias for [column].
  ///
  /// Falls back to the plain truncated alias for columns that were not part of
  /// the resolver's column set (e.g. projection columns); such columns are not
  /// involved in include deserialization and cannot collide there.
  String resolve(Column column) {
    return _aliasByFieldQueryAlias[column.fieldQueryAlias] ??
        _baseAlias(column.fieldQueryAlias);
  }
}

String _baseAlias(String fieldQueryAlias) => truncateIdentifier(
  fieldQueryAlias,
  DatabaseConstants.pgsqlMaxNameLimitation,
);

/// Returns [base] if unused, otherwise probes `base_1`, `base_2`, … (trimming
/// [base] so the result still fits the identifier length limit) until an unused
/// alias is found.
String _allocateAlias(String base, Set<String> usedAliases) {
  if (!usedAliases.contains(base)) return base;

  for (var counter = 1;; counter++) {
    var suffix = '_$counter';
    var maxBaseLength = DatabaseConstants.pgsqlMaxNameLimitation - suffix.length;
    var trimmedBase =
        base.length <= maxBaseLength ? base : base.substring(0, maxBaseLength);
    var candidate = '$trimmedBase$suffix';
    if (!usedAliases.contains(candidate)) return candidate;
  }
}

/// Columns in the exact order the result parser reads them: a table's own
/// columns followed by a depth-first walk over its object includes. This mirrors
/// both the order of the generated `SELECT` column list and the parser's
/// recursive traversal, so the alias assignment is identical on both sides.
List<Column> _orderedSelectedColumns(Table table, Include? include) {
  var columns = <Column>[...table.columns];
  if (include == null) return columns;

  include.includes.forEach((relationField, relationInclude) {
    if (relationInclude == null || relationInclude is IncludeList) return;

    var relationTable = table.getRelationTable(relationField);
    if (relationTable == null) return;

    columns.addAll(_orderedSelectedColumns(relationTable, relationInclude));
  });

  return columns;
}
