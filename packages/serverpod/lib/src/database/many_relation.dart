import 'package:serverpod/serverpod.dart';

/// Many relation field between two tables.
class ManyRelation<T extends Table> {
  /// Many side table including table relations.
  final T _tableWithRelations;

  /// Many side table without table relations.
  final T _table;

  /// Creates a new [ManyRelation].
  ManyRelation({required T tableWithRelations, required T table})
      : _table = table,
        _tableWithRelations = tableWithRelations;

  /// Returns an expression that counts the number of rows in the relation.
  ColumnCount count([Expression Function(T)? where]) {
    return ColumnCount(where?.call(_table), _tableWithRelations.id);
  }

  /// Returns all models where none of the related models match filtering criteria.
  NoneExpression none([Expression Function(T)? where]) {
    return NoneExpression(
        ColumnCount(where?.call(_table), _tableWithRelations.id));
  }

  /// Returns all models where any of the related models match filtering criteria.
  AnyExpression any([Expression Function(T)? where]) {
    return AnyExpression(
        ColumnCount(where?.call(_table), _tableWithRelations.id));
  }

  /// Returns all models where all of the related models match filtering criteria.
  EveryExpression every(Expression Function(T) where) {
    return EveryExpression(
        ColumnCount(where.call(_table), _tableWithRelations.id));
  }
}
