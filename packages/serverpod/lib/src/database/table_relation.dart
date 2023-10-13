import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/src/database/columns.dart';

/// Records the relation between two tables.
/// This is typically only used internally by the serverpod framework.
@internal
class TableRelation {
  /// Records the relationship between multiple tables.
  /// Order is important, as it determines the order of joins in the query.
  final List<TableRelationEntry> _tableRelationEntries;

  /// Creates a new [TableRelation].
  /// Throws [ArgumentError] if [tableRelationEntries] is empty.
  TableRelation(this._tableRelationEntries) {
    if (_tableRelationEntries.isEmpty) {
      throw ArgumentError('TableRelation must have at least one entry.');
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

  /// Name of the table to be joined.
  String get lastForeignTableName {
    return _tableRelationEntries.last.foreignField.table.tableName;
  }

  /// Name of the last field to be joined.
  String get lastJoiningField {
    return '"${_fromRelationQueryAlias()}"."${_tableRelationEntries.last.field.columnName}"';
  }

  /// Name of the last foreign field to be joined.
  String get lastJoiningForeignField {
    return '"${_buildRelationQueryAlias()}"."${_tableRelationEntries.last.foreignField.columnName}"';
  }

  /// Name of the last foreign field to be joined as query alias.
  String get lastJoiningForeignFieldQueryAlias {
    return '"${_buildRelationQueryAlias()}"."${_tableRelationEntries.last.foreignField.queryAlias}"';
  }

  /// The base foreignFieldName without the query alias
  String get foreignFieldName {
    return _tableRelationEntries.last.foreignField.columnName;
  }

  /// The base fieldName without the query alias
  String get fieldName {
    return _tableRelationEntries.last.field.columnName;
  }

  /// The base foreignFieldName without the query alias
  String get tableName {
    return _tableRelationEntries.last.field.table.tableName;
  }

  /// Creates a new [TableRelation] from [this] and [relation].
  TableRelation copyAndAppend(TableRelationEntry relation) {
    return TableRelation([..._tableRelationEntries, relation]);
  }

  /// Retrieves the name of the table with the query prefix applied.
  String get relationQueryAlias => _buildRelationQueryAlias();

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
