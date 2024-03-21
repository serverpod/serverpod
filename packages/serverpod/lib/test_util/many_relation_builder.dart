import 'package:serverpod/database.dart';

/// Test util for building a many relation.
class ManyRelationBuilder {
  final Table _table;

  /// Creates a new [ManyRelationBuilder] for the given [table].
  /// Throws [ArgumentError] if [table] does not have a table relation.
  ManyRelationBuilder(this._table) {
    if (_table.tableRelation == null) {
      throw ArgumentError('Table must have a table relation.');
    }
  }

  /// Builds a many relation.
  ManyRelation build() {
    return ManyRelation(
      tableWithRelations: _table,
      table: Table(
        tableName: _table.tableName,
        tableRelation: _table.tableRelation!.lastRelation,
      ),
    );
  }
}
