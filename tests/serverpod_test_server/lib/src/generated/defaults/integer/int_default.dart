/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class IntDefault implements _i1.TableRow, _i1.ProtocolSerialization {
  IntDefault._({
    this.id,
    int? intDefault,
    int? intDefaultNull,
  })  : intDefault = intDefault ?? 10,
        intDefaultNull = intDefaultNull ?? 20;

  factory IntDefault({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  }) = _IntDefaultImpl;

  factory IntDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefault(
      id: jsonSerialization['id'] as int?,
      intDefault: jsonSerialization['intDefault'] as int,
      intDefaultNull: jsonSerialization['intDefaultNull'] as int?,
    );
  }

  static final t = IntDefaultTable();

  static const db = IntDefaultRepository._();

  @override
  int? id;

  int intDefault;

  int? intDefaultNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [IntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefault copyWith({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'intDefault': intDefault,
      if (intDefaultNull != null) 'intDefaultNull': intDefaultNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'intDefault': intDefault,
      if (intDefaultNull != null) 'intDefaultNull': intDefaultNull,
    };
  }

  static IntDefaultInclude include() {
    return IntDefaultInclude._();
  }

  static IntDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultTable>? orderByList,
    IntDefaultInclude? include,
  }) {
    return IntDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IntDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultImpl extends IntDefault {
  _IntDefaultImpl({
    int? id,
    int? intDefault,
    int? intDefaultNull,
  }) : super._(
          id: id,
          intDefault: intDefault,
          intDefaultNull: intDefaultNull,
        );

  /// Returns a shallow copy of this [IntDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefault copyWith({
    Object? id = _Undefined,
    int? intDefault,
    Object? intDefaultNull = _Undefined,
  }) {
    return IntDefault(
      id: id is int? ? id : this.id,
      intDefault: intDefault ?? this.intDefault,
      intDefaultNull:
          intDefaultNull is int? ? intDefaultNull : this.intDefaultNull,
    );
  }
}

class IntDefaultTable extends _i1.Table {
  IntDefaultTable({super.tableRelation}) : super(tableName: 'int_default') {
    intDefault = _i1.ColumnInt(
      'intDefault',
      this,
      hasDefault: true,
    );
    intDefaultNull = _i1.ColumnInt(
      'intDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt intDefault;

  late final _i1.ColumnInt intDefaultNull;

  @override
  List<_i1.Column> get columns => [
        id,
        intDefault,
        intDefaultNull,
      ];
}

class IntDefaultInclude extends _i1.IncludeObject {
  IntDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => IntDefault.t;
}

class IntDefaultIncludeList extends _i1.IncludeList {
  IntDefaultIncludeList._({
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IntDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => IntDefault.t;
}

class IntDefaultRepository {
  const IntDefaultRepository._();

  /// Returns a list of [IntDefault]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<IntDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<IntDefault>(
      where: where?.call(IntDefault.t),
      orderBy: orderBy?.call(IntDefault.t),
      orderByList: orderByList?.call(IntDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [IntDefault] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<IntDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<IntDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<IntDefault>(
      where: where?.call(IntDefault.t),
      orderBy: orderBy?.call(IntDefault.t),
      orderByList: orderByList?.call(IntDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [IntDefault] by its [id] or null if no such row exists.
  Future<IntDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<IntDefault>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [IntDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [IntDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<IntDefault>> insert(
    _i1.Session session,
    List<IntDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<IntDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [IntDefault] and returns the inserted row.
  ///
  /// The returned [IntDefault] will have its `id` field set.
  Future<IntDefault> insertRow(
    _i1.Session session,
    IntDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IntDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IntDefault>> update(
    _i1.Session session,
    List<IntDefault> rows, {
    _i1.ColumnSelections<IntDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IntDefault>(
      rows,
      columns: columns?.call(IntDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IntDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IntDefault> updateRow(
    _i1.Session session,
    IntDefault row, {
    _i1.ColumnSelections<IntDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntDefault>(
      row,
      columns: columns?.call(IntDefault.t),
      transaction: transaction,
    );
  }

  /// Deletes all [IntDefault]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IntDefault>> delete(
    _i1.Session session,
    List<IntDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IntDefault>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IntDefault].
  Future<IntDefault> deleteRow(
    _i1.Session session,
    IntDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IntDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<IntDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IntDefault>(
      where: where(IntDefault.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<IntDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IntDefault>(
      where: where?.call(IntDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
