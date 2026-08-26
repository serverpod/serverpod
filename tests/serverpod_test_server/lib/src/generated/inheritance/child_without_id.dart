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
import 'package:serverpod/serverpod.dart' as _is;
import '../protocol.dart' as _iv35mfmj;

abstract class ChildClassWithoutId extends _iv35mfmj.ParentClassWithoutId
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ChildClassWithoutId._({
    this.id,
    required super.grandParentField,
    required super.parentField,
    required this.childField,
  });

  factory ChildClassWithoutId({
    _is.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) = _ChildClassWithoutIdImpl;

  factory ChildClassWithoutId.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildClassWithoutId(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  static final t = ChildClassWithoutIdTable();

  static const db = ChildClassWithoutIdRepository._();

  @override
  _is.UuidValue? id;

  String childField;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  ChildClassWithoutId copyWith({
    Object? id,
    String? grandParentField,
    String? parentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildClassWithoutId',
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChildClassWithoutId',
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  /// Builds a complete [ChildClassWithoutIdInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ChildClassWithoutIdInclude include() {
    return ChildClassWithoutIdInclude._();
  }

  /// Builds a complete [ChildClassWithoutIdIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ChildClassWithoutIdIncludeList includeList({
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    ChildClassWithoutIdInclude? include,
  }) {
    return ChildClassWithoutIdIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ChildClassWithoutIdJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ChildClassWithoutIdJsonInclude includeJson({
    _is.SelectColumnsBuilder<ChildClassWithoutIdTable>? select,
  }) {
    return _ChildClassWithoutIdJsonInclude._(
      selectedColumns: select?.call(ChildClassWithoutId.t),
    );
  }

  /// Builds a JSON-compatible [ChildClassWithoutIdJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ChildClassWithoutIdJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    ChildClassWithoutIdJsonInclude? include,
    _is.SelectColumnsBuilder<ChildClassWithoutIdTable>? select,
  }) {
    return _ChildClassWithoutIdJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      include: include,
      selectedColumns: select?.call(ChildClassWithoutId.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildClassWithoutIdImpl extends ChildClassWithoutId {
  _ChildClassWithoutIdImpl({
    _is.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) : super._(
         id: id,
         grandParentField: grandParentField,
         parentField: parentField,
         childField: childField,
       );

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChildClassWithoutId copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
    String? childField,
  }) {
    return ChildClassWithoutId(
      id: id is _is.UuidValue? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
    );
  }
}

class ChildClassWithoutIdUpdateTable
    extends _is.UpdateTable<ChildClassWithoutIdTable> {
  ChildClassWithoutIdUpdateTable(super.table);

  _is.ColumnValue<String, String> grandParentField(String value) =>
      _is.ColumnValue(
        table.grandParentField,
        value,
      );

  _is.ColumnValue<String, String> parentField(String value) => _is.ColumnValue(
    table.parentField,
    value,
  );

  _is.ColumnValue<String, String> childField(String value) => _is.ColumnValue(
    table.childField,
    value,
  );
}

class ChildClassWithoutIdTable extends _is.Table<_is.UuidValue?> {
  ChildClassWithoutIdTable({super.tableRelation})
    : super(tableName: 'child_table_with_inherited_id') {
    updateTable = ChildClassWithoutIdUpdateTable(this);
    grandParentField = _is.ColumnString(
      'grandParentField',
      this,
    );
    parentField = _is.ColumnString(
      'parentField',
      this,
    );
    childField = _is.ColumnString(
      'childField',
      this,
    );
  }

  late final ChildClassWithoutIdUpdateTable updateTable;

  late final _is.ColumnString grandParentField;

  late final _is.ColumnString parentField;

  late final _is.ColumnString childField;

  @override
  List<_is.Column> get columns => [
    id,
    grandParentField,
    parentField,
    childField,
  ];
}

abstract interface class ChildClassWithoutIdJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ChildClassWithoutIdJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ChildClassWithoutIdInclude extends _is.IncludeObject
    implements ChildClassWithoutIdJsonInclude, _is.FullModelInclude {
  ChildClassWithoutIdInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ChildClassWithoutId.t;
}

final class ChildClassWithoutIdIncludeList extends _is.IncludeList
    implements ChildClassWithoutIdJsonIncludeList, _is.FullModelInclude {
  ChildClassWithoutIdIncludeList._({
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ChildClassWithoutIdInclude? super.include,
  }) {
    super.where = where?.call(ChildClassWithoutId.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ChildClassWithoutId.t;
}

final class _ChildClassWithoutIdJsonInclude extends _is.IncludeObject
    implements ChildClassWithoutIdJsonInclude {
  _ChildClassWithoutIdJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ChildClassWithoutId.t;
}

final class _ChildClassWithoutIdJsonIncludeList extends _is.IncludeList
    implements ChildClassWithoutIdJsonIncludeList {
  _ChildClassWithoutIdJsonIncludeList._({
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ChildClassWithoutIdJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ChildClassWithoutId.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ChildClassWithoutId.t;
}

class ChildClassWithoutIdRepository {
  const ChildClassWithoutIdRepository._();

  /// Returns a list of [ChildClassWithoutId]s matching the given query parameters.
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
  Future<List<ChildClassWithoutId>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ChildClassWithoutId] matching the given query parameters.
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
  Future<ChildClassWithoutId?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? offset,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ChildClassWithoutId] by its [id] or null if no such row exists.
  Future<ChildClassWithoutId?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ChildClassWithoutId>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ChildClassWithoutIdTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ChildClassWithoutId.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? offset,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ChildClassWithoutIdTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ChildClassWithoutId.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ChildClassWithoutIdTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ChildClassWithoutId>(
      id,
      transaction: transaction,
      select: select?.call(ChildClassWithoutId.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ChildClassWithoutId]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildClassWithoutId]s will have their `id` fields set.
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
  Future<List<ChildClassWithoutId>> insert(
    _is.DatabaseSession session,
    List<ChildClassWithoutId> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ChildClassWithoutId>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ChildClassWithoutId] and returns the inserted row.
  ///
  /// The returned [ChildClassWithoutId] will have its `id` field set.
  Future<ChildClassWithoutId> insertRow(
    _is.DatabaseSession session,
    ChildClassWithoutId row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildClassWithoutId>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ChildClassWithoutId]s in the list and returns the resulting rows.
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
  /// The returned [ChildClassWithoutId]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildClassWithoutId>> upsert(
    _is.DatabaseSession session,
    List<ChildClassWithoutId> rows, {
    required _is.ColumnSelections<ChildClassWithoutIdTable> conflictColumns,
    _is.ColumnSelections<ChildClassWithoutIdTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ChildClassWithoutId>(
      rows,
      conflictColumns: conflictColumns(ChildClassWithoutId.t),
      updateColumns: updateColumns?.call(ChildClassWithoutId.t),
      updateWhere: updateWhere?.call(ChildClassWithoutId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ChildClassWithoutId] and returns the resulting row.
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
  /// The returned [ChildClassWithoutId] will have its `id` field set.
  Future<ChildClassWithoutId?> upsertRow(
    _is.DatabaseSession session,
    ChildClassWithoutId row, {
    required _is.ColumnSelections<ChildClassWithoutIdTable> conflictColumns,
    _is.ColumnSelections<ChildClassWithoutIdTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ChildClassWithoutId>(
      row,
      conflictColumns: conflictColumns(ChildClassWithoutId.t),
      updateColumns: updateColumns?.call(ChildClassWithoutId.t),
      updateWhere: updateWhere?.call(ChildClassWithoutId.t),
      transaction: transaction,
    );
  }

  /// Updates all [ChildClassWithoutId]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildClassWithoutId>> update(
    _is.DatabaseSession session,
    List<ChildClassWithoutId> rows, {
    _is.ColumnSelections<ChildClassWithoutIdTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ChildClassWithoutId>(
      rows,
      columns: columns?.call(ChildClassWithoutId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ChildClassWithoutId]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildClassWithoutId> updateRow(
    _is.DatabaseSession session,
    ChildClassWithoutId row, {
    _is.ColumnSelections<ChildClassWithoutIdTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildClassWithoutId>(
      row,
      columns: columns?.call(ChildClassWithoutId.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildClassWithoutId] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildClassWithoutId?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ChildClassWithoutIdUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildClassWithoutId>(
      id,
      columnValues: columnValues(ChildClassWithoutId.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildClassWithoutId]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildClassWithoutId>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ChildClassWithoutIdUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ChildClassWithoutIdTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ChildClassWithoutId>(
      columnValues: columnValues(ChildClassWithoutId.t.updateTable),
      where: where(ChildClassWithoutId.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ChildClassWithoutId]s in the list and returns the deleted rows.
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
  Future<List<ChildClassWithoutId>> delete(
    _is.DatabaseSession session,
    List<ChildClassWithoutId> rows, {
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ChildClassWithoutId>(
      rows,
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ChildClassWithoutId].
  Future<ChildClassWithoutId> deleteRow(
    _is.DatabaseSession session,
    ChildClassWithoutId row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildClassWithoutId>(
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
  Future<List<ChildClassWithoutId>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildClassWithoutIdTable> where,
    _is.OrderByBuilder<ChildClassWithoutIdTable>? orderBy,
    _is.OrderByListBuilder<ChildClassWithoutIdTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ChildClassWithoutId>(
      where: where(ChildClassWithoutId.t),
      orderBy: orderBy?.call(ChildClassWithoutId.t),
      orderByList: orderByList?.call(ChildClassWithoutId.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildClassWithoutIdTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ChildClassWithoutId>(
      where: where?.call(ChildClassWithoutId.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ChildClassWithoutId] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildClassWithoutIdTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ChildClassWithoutId>(
      where: where(ChildClassWithoutId.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
