/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;

abstract class ObjectWithTrgm
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithTrgm._({
    this.id,
    required this.searchText,
    required this.searchTextIndexed,
    this.nullableSearchTextIndexed,
  });

  factory ObjectWithTrgm({
    int? id,
    required String searchText,
    required String searchTextIndexed,
    String? nullableSearchTextIndexed,
  }) = _ObjectWithTrgmImpl;

  factory ObjectWithTrgm.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithTrgm(
      id: jsonSerialization['id'] as int?,
      searchText: jsonSerialization['searchText'] as String,
      searchTextIndexed: jsonSerialization['searchTextIndexed'] as String,
      nullableSearchTextIndexed:
          jsonSerialization['nullableSearchTextIndexed'] as String?,
    );
  }

  static final t = ObjectWithTrgmTable();

  static const db = ObjectWithTrgmRepository._();

  @override
  int? id;

  String searchText;

  String searchTextIndexed;

  String? nullableSearchTextIndexed;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithTrgm]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithTrgm copyWith({
    int? id,
    String? searchText,
    String? searchTextIndexed,
    String? nullableSearchTextIndexed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithTrgm',
      if (id != null) 'id': id,
      'searchText': searchText,
      'searchTextIndexed': searchTextIndexed,
      if (nullableSearchTextIndexed != null)
        'nullableSearchTextIndexed': nullableSearchTextIndexed,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithTrgm',
      if (id != null) 'id': id,
      'searchText': searchText,
      'searchTextIndexed': searchTextIndexed,
      if (nullableSearchTextIndexed != null)
        'nullableSearchTextIndexed': nullableSearchTextIndexed,
    };
  }

  static ObjectWithTrgmInclude include() {
    return ObjectWithTrgmInclude._();
  }

  static ObjectWithTrgmIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithTrgmTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithTrgmTable>? orderByList,
    ObjectWithTrgmInclude? include,
  }) {
    return ObjectWithTrgmIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithTrgm.t),
      orderByList: orderByList?.call(ObjectWithTrgm.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithTrgmImpl extends ObjectWithTrgm {
  _ObjectWithTrgmImpl({
    int? id,
    required String searchText,
    required String searchTextIndexed,
    String? nullableSearchTextIndexed,
  }) : super._(
         id: id,
         searchText: searchText,
         searchTextIndexed: searchTextIndexed,
         nullableSearchTextIndexed: nullableSearchTextIndexed,
       );

  /// Returns a shallow copy of this [ObjectWithTrgm]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithTrgm copyWith({
    Object? id = _Undefined,
    String? searchText,
    String? searchTextIndexed,
    Object? nullableSearchTextIndexed = _Undefined,
  }) {
    return ObjectWithTrgm(
      id: id is int? ? id : this.id,
      searchText: searchText ?? this.searchText,
      searchTextIndexed: searchTextIndexed ?? this.searchTextIndexed,
      nullableSearchTextIndexed: nullableSearchTextIndexed is String?
          ? nullableSearchTextIndexed
          : this.nullableSearchTextIndexed,
    );
  }
}

class ObjectWithTrgmUpdateTable extends _is.UpdateTable<ObjectWithTrgmTable> {
  ObjectWithTrgmUpdateTable(super.table);

  _is.ColumnValue<String, String> searchText(String value) => _is.ColumnValue(
    table.searchText,
    value,
  );

  _is.ColumnValue<String, String> searchTextIndexed(String value) =>
      _is.ColumnValue(
        table.searchTextIndexed,
        value,
      );

  _is.ColumnValue<String, String> nullableSearchTextIndexed(String? value) =>
      _is.ColumnValue(
        table.nullableSearchTextIndexed,
        value,
      );
}

class ObjectWithTrgmTable extends _is.Table<int?> {
  ObjectWithTrgmTable({super.tableRelation})
    : super(tableName: 'object_with_trgm') {
    updateTable = ObjectWithTrgmUpdateTable(this);
    searchText = _is.ColumnString(
      'searchText',
      this,
    );
    searchTextIndexed = _is.ColumnString(
      'searchTextIndexed',
      this,
    );
    nullableSearchTextIndexed = _is.ColumnString(
      'nullableSearchTextIndexed',
      this,
    );
  }

  late final ObjectWithTrgmUpdateTable updateTable;

  late final _is.ColumnString searchText;

  late final _is.ColumnString searchTextIndexed;

  late final _is.ColumnString nullableSearchTextIndexed;

  @override
  List<_is.Column> get columns => [
    id,
    searchText,
    searchTextIndexed,
    nullableSearchTextIndexed,
  ];
}

class ObjectWithTrgmInclude extends _is.IncludeObject {
  ObjectWithTrgmInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithTrgm.t;
}

class ObjectWithTrgmIncludeList extends _is.IncludeList {
  ObjectWithTrgmIncludeList._({
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithTrgm.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithTrgm.t;
}

class ObjectWithTrgmRepository {
  const ObjectWithTrgmRepository._();

  /// Returns a list of [ObjectWithTrgm]s matching the given query parameters.
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
  Future<List<ObjectWithTrgm>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithTrgmTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithTrgmTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithTrgm>(
      where: where?.call(ObjectWithTrgm.t),
      orderBy: orderBy?.call(ObjectWithTrgm.t),
      orderByList: orderByList?.call(ObjectWithTrgm.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ObjectWithTrgm]s matching the given query parameters every time the
  /// source tables are modified.
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
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `ObjectWithTrgm.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<ObjectWithTrgm>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithTrgmTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithTrgmTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ObjectWithTrgm>(
      where: where?.call(ObjectWithTrgm.t),
      orderBy: orderBy?.call(ObjectWithTrgm.t),
      orderByList: orderByList?.call(ObjectWithTrgm.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ObjectWithTrgm] matching the given query parameters.
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
  Future<ObjectWithTrgm?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithTrgmTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithTrgmTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithTrgm>(
      where: where?.call(ObjectWithTrgm.t),
      orderBy: orderBy?.call(ObjectWithTrgm.t),
      orderByList: orderByList?.call(ObjectWithTrgm.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithTrgm] by its [id] or null if no such row exists.
  Future<ObjectWithTrgm?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithTrgm>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithTrgm]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithTrgm]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithTrgm>> insert(
    _is.DatabaseSession session,
    List<ObjectWithTrgm> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithTrgm>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithTrgm] and returns the inserted row.
  ///
  /// The returned [ObjectWithTrgm] will have its `id` field set.
  Future<ObjectWithTrgm> insertRow(
    _is.DatabaseSession session,
    ObjectWithTrgm row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithTrgm>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithTrgm]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ObjectWithTrgm]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithTrgm>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithTrgm> rows, {
    required _is.ColumnSelections<ObjectWithTrgmTable> conflictColumns,
    _is.ColumnSelections<ObjectWithTrgmTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithTrgm>(
      rows,
      conflictColumns: conflictColumns(ObjectWithTrgm.t),
      updateColumns: updateColumns?.call(ObjectWithTrgm.t),
      updateWhere: updateWhere?.call(ObjectWithTrgm.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithTrgm] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ObjectWithTrgm] will have its `id` field set.
  Future<ObjectWithTrgm?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithTrgm row, {
    required _is.ColumnSelections<ObjectWithTrgmTable> conflictColumns,
    _is.ColumnSelections<ObjectWithTrgmTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithTrgm>(
      row,
      conflictColumns: conflictColumns(ObjectWithTrgm.t),
      updateColumns: updateColumns?.call(ObjectWithTrgm.t),
      updateWhere: updateWhere?.call(ObjectWithTrgm.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithTrgm]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithTrgm>> update(
    _is.DatabaseSession session,
    List<ObjectWithTrgm> rows, {
    _is.ColumnSelections<ObjectWithTrgmTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithTrgm>(
      rows,
      columns: columns?.call(ObjectWithTrgm.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithTrgm]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithTrgm> updateRow(
    _is.DatabaseSession session,
    ObjectWithTrgm row, {
    _is.ColumnSelections<ObjectWithTrgmTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithTrgm>(
      row,
      columns: columns?.call(ObjectWithTrgm.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithTrgm] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithTrgm?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithTrgmUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithTrgm>(
      id,
      columnValues: columnValues(ObjectWithTrgm.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithTrgm]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithTrgm>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithTrgmUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ObjectWithTrgmTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithTrgmTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithTrgmTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithTrgm>(
      columnValues: columnValues(ObjectWithTrgm.t.updateTable),
      where: where(ObjectWithTrgm.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithTrgm.t),
      orderByList: orderByList?.call(ObjectWithTrgm.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithTrgm]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithTrgm>> delete(
    _is.DatabaseSession session,
    List<ObjectWithTrgm> rows, {
    _is.OrderByBuilder<ObjectWithTrgmTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithTrgmTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithTrgm>(
      rows,
      orderBy: orderBy?.call(ObjectWithTrgm.t),
      orderByList: orderByList?.call(ObjectWithTrgm.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithTrgm].
  Future<ObjectWithTrgm> deleteRow(
    _is.DatabaseSession session,
    ObjectWithTrgm row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithTrgm>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithTrgm>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithTrgmTable> where,
    _is.OrderByBuilder<ObjectWithTrgmTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithTrgmTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithTrgm>(
      where: where(ObjectWithTrgm.t),
      orderBy: orderBy?.call(ObjectWithTrgm.t),
      orderByList: orderByList?.call(ObjectWithTrgm.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithTrgmTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithTrgm>(
      where: where?.call(ObjectWithTrgm.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithTrgm] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithTrgmTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithTrgm>(
      where: where(ObjectWithTrgm.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
