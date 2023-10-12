import 'package:serverpod/serverpod.dart';

/// Many relation field between two tables.
class ManyRelation<T extends Table> {
  /// Many side table including table relations.
  final T tableWithRelations;

  /// Many side table without table relations.
  final T table;

  /// Creates a new [ManyRelation].
  ManyRelation({required this.tableWithRelations, required this.table});

  /// Returns an expression that counts the number of rows in the relation.
  ColumnCount count([Expression Function(T)? where]) {
    return ColumnCount(where?.call(table), table, tableWithRelations.id);
  }
}
