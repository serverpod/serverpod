import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/concepts/table_relation.dart';

/// Test util for building a table with relations.
class TableRelationBuilder {
  final List<TableRelationEntry> _entries = [];
  final Table _table;

  /// Creates a new [TableRelationBuilder] for the given [table].
  TableRelationBuilder(this._table);

  /// In iteration order, adds relations from the relation list
  /// using the relation aliases.
  ///
  /// Uses the ID column as key for the relation on both sides for the tables.
  TableRelationBuilder withRelationsFrom(List<BuilderRelation> relations) {
    var firstRelation = relations.first;
    var table = firstRelation.table;
    var relationAlias = firstRelation.relationAlias;

    for (var relation in relations.skip(1)) {
      _addRelationBetween(table, relation.table, relationAlias);
      table = relation.table;
      relationAlias = relation.relationAlias;
    }

    _addRelationBetween(table, _table, relationAlias);

    return this;
  }

  /// Builds a table with the relations added.
  Table build() {
    return Table(
      tableName: _table.tableName,
      tableRelation: TableRelation(_entries),
    );
  }

  void _addRelationBetween(
    Table table,
    Table foreignTable,
    String relationAlias,
  ) {
    _entries.add(TableRelationEntry(
      relationAlias: relationAlias,
      field: table.id,
      foreignField: foreignTable.id,
    ));
  }
}

/// A relation used by the [ManyRelationBuilder].
class BuilderRelation {
  /// The table to be joined.
  final Table table;

  /// The alias of the relation.
  final String relationAlias;

  /// Creates a new [BuilderRelation].
  BuilderRelation(this.table, this.relationAlias);
}
