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
    return ColumnCount(where?.call(table), tableWithRelations.id);
  }

  /// Returns all entities where none of the related entities match filtering criteria.
  NoneExpression none([Expression Function(T)? where]) {
    return NoneExpression(
        ColumnCount(where?.call(table), tableWithRelations.id));
  }

  /// Returns all entities where any of the related entities match filtering criteria.
  AnyExpression any([Expression Function(T)? where]) {
    return AnyExpression(
        ColumnCount(where?.call(table), tableWithRelations.id));
  }
}
