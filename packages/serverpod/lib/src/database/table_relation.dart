import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/expressions.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Called for all query aliases generated by [TableRelation].
typedef TruncateFunction = String Function(String identifier);

/// Records the relation between two tables.
/// All query aliases generated by [TableRelation] are truncated by the
/// [truncateFunction].
/// This is typically only used internally by the serverpod framework.
@internal
class TableRelation {
  /// Records the relationship between multiple tables.
  /// Order is important, as it determines the order of joins in the query.
  final List<TableRelationEntry> _tableRelationEntries;

  // Default initialized to truncate to Postgres max name length.
  TruncateFunction _truncateFunction = (String identifier) =>
      truncateIdentifier(identifier, DatabaseConstants.pgsqlMaxNameLimitation);

  /// Creates a new [TableRelation].
  /// Throws [ArgumentError] if [tableRelationEntries] is empty.
  ///
  /// [truncateFunction] is used to truncate query aliases generated by
  /// [TableRelation].
  /// If [truncateFunction] is not provided, the query aliases are truncated
  /// to Postgres max name length.
  TableRelation(
    this._tableRelationEntries, {
    TruncateFunction? truncateFunction,
  }) {
    if (_tableRelationEntries.isEmpty) {
      throw ArgumentError('TableRelation must have at least one entry.');
    }

    if (truncateFunction != null) {
      _truncateFunction = truncateFunction;
    }
  }

  /// Builds all table relations required to join the tables.
  List<TableRelation> get getRelations {
    return _tableRelationEntries
        .mapIndexed(
          (index, _) =>
              TableRelation(_tableRelationEntries.sublist(0, index + 1)),
        )
        .toList();
  }

  /// Name of table to be joined.
  String get fieldTableName {
    return _tableRelationEntries.last.field.table.tableName;
  }

  /// Table to be joined.
  Table get fieldTable {
    return _tableRelationEntries.last.field.table;
  }

  /// Name of foreign table to be joined.
  String get foreignTableName {
    return _tableRelationEntries.last.foreignField.table.tableName;
  }

  /// The field name that is joined on.
  String get fieldName {
    return _tableRelationEntries.last.field.columnName;
  }

  /// The field name query alias including table.
  String get fieldQueryAlias {
    return _truncateFunction(_tableRelationEntries.last.field.queryAlias);
  }

  /// Field column that is joined on.
  Column get fieldColumn {
    return _tableRelationEntries.last.field;
  }

  /// The query alias for field name to be joined on including all joins.
  String get fieldQueryAliasWithJoins {
    return _truncateFunction(
      '${_fromRelationQueryAlias()}.${_tableRelationEntries.last.field.columnName}',
    );
  }

  /// The field name to be joined on including all joins.
  String get fieldNameWithJoins {
    return '"${_truncateFunction(_fromRelationQueryAlias())}"."${_tableRelationEntries.last.field.columnName}"';
  }

  /// The foreign field name joined on.
  String get foreignFieldName {
    return _tableRelationEntries.last.foreignField.columnName;
  }

  /// The foreign field name with including the table escaped.
  String get foreignFieldBaseQuery {
    return _tableRelationEntries.last.foreignField.toString();
  }

  /// The foreign field name to be joined on including all joins.
  String get foreignFieldNameWithJoins {
    return '"${_truncateFunction(_buildRelationQueryAlias())}"."${_tableRelationEntries.last.foreignField.columnName}"';
  }

  /// The field name query alias including table.
  String get foreignFieldQueryAlias {
    return _truncateFunction(
      _tableRelationEntries.last.foreignField.queryAlias,
    );
  }

  /// Create a new [TableRelation] with only one entry for the last table
  /// relation.
  TableRelation get lastRelation {
    return TableRelation([_tableRelationEntries.last]);
  }

  /// Creates a new [TableRelation] from [this] and [relation].
  TableRelation copyAndAppend(TableRelationEntry relation) {
    return TableRelation([..._tableRelationEntries, relation]);
  }

  /// Retrieves the name of the table with the query prefix applied.
  String get relationQueryAlias =>
      _truncateFunction(_buildRelationQueryAlias());

  /// Builds the relation query alias including [TableRelationEntries]
  /// up until [end] index.
  ///
  /// If [end] is larger than the number of relations, all relations are used.
  String _buildRelationQueryAlias([int? end]) {
    if (end != null && end > _tableRelationEntries.length) {
      end = _tableRelationEntries.length;
    }

    var prefix = '';
    if (_tableRelationEntries.isEmpty) {
      return prefix;
    }

    prefix = _tableRelationEntries.first.field.table.tableName;

    for (var relation in _tableRelationEntries.sublist(0, end)) {
      prefix +=
          '_${relation.relationAlias}_${relation.foreignField.table.tableName}';
    }

    return prefix;
  }

  String _fromRelationQueryAlias() {
    return _buildRelationQueryAlias(_tableRelationEntries.length - 1);
  }
}

/// Entry for recording a relation between two tables.
/// This is typically only used internally by the serverpod framework.
@internal
class TableRelationEntry {
  /// Alias for the relation.
  final String relationAlias;

  /// Column field to join on.
  final Column field;

  /// Foreign Column field to join to.
  final Column foreignField;

  /// Creates a new [TableRelationEntry].
  TableRelationEntry({
    required this.relationAlias,
    required this.field,
    required this.foreignField,
  });
}
