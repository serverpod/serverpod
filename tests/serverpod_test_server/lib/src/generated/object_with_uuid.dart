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
import 'package:meta/meta.dart' as _i057hz1u;
import 'package:serverpod/serverpod.dart' as _is;

abstract class ObjectWithUuid
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithUuid._({
    this.id,
    required this.uuid,
    this.uuidNullable,
  });

  factory ObjectWithUuid({
    int? id,
    required _is.UuidValue uuid,
    _is.UuidValue? uuidNullable,
  }) = _ObjectWithUuidImpl;

  factory ObjectWithUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithUuid(
      id: jsonSerialization['id'] as int?,
      uuid: _is.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      uuidNullable: jsonSerialization['uuidNullable'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidNullable'],
            ),
    );
  }

  static final t = ObjectWithUuidTable();

  static const db = ObjectWithUuidRepository._();

  @override
  int? id;

  _is.UuidValue uuid;

  _is.UuidValue? uuidNullable;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithUuid copyWith({
    int? id,
    _is.UuidValue? uuid,
    _is.UuidValue? uuidNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithUuid',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      if (uuidNullable != null) 'uuidNullable': uuidNullable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithUuid',
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      if (uuidNullable != null) 'uuidNullable': uuidNullable?.toJson(),
    };
  }

  static ObjectWithUuidInclude include() {
    return ObjectWithUuidInclude.internal_();
  }

  static ObjectWithUuidIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    ObjectWithUuidInclude? include,
  }) {
    return ObjectWithUuidIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithUuidImpl extends ObjectWithUuid {
  _ObjectWithUuidImpl({
    int? id,
    required _is.UuidValue uuid,
    _is.UuidValue? uuidNullable,
  }) : super._(
         id: id,
         uuid: uuid,
         uuidNullable: uuidNullable,
       );

  /// Returns a shallow copy of this [ObjectWithUuid]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithUuid copyWith({
    Object? id = _Undefined,
    _is.UuidValue? uuid,
    Object? uuidNullable = _Undefined,
  }) {
    return ObjectWithUuid(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      uuidNullable: uuidNullable is _is.UuidValue?
          ? uuidNullable
          : this.uuidNullable,
    );
  }
}

class ObjectWithUuidUpdateTable extends _is.UpdateTable<ObjectWithUuidTable> {
  ObjectWithUuidUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuid(_is.UuidValue value) =>
      _is.ColumnValue(
        table.uuid,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidNullable(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidNullable,
    value,
  );
}

class ObjectWithUuidTable extends _is.Table<int?> {
  ObjectWithUuidTable({super.tableRelation})
    : super(tableName: 'object_with_uuid') {
    updateTable = ObjectWithUuidUpdateTable(this);
    uuid = _is.ColumnUuid(
      'uuid',
      this,
    );
    uuidNullable = _is.ColumnUuid(
      'uuidNullable',
      this,
    );
  }

  late final ObjectWithUuidUpdateTable updateTable;

  late final _is.ColumnUuid uuid;

  late final _is.ColumnUuid uuidNullable;

  @override
  List<_is.Column> get columns => [
    id,
    uuid,
    uuidNullable,
  ];
}

class ObjectWithUuidInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  ObjectWithUuidInclude.internal_({List<_is.Column>? this.selectedColumns}) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithUuid.t;
}

class ObjectWithUuidIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  ObjectWithUuidIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithUuid.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithUuid.t;
}

class ObjectWithUuidRepository {
  const ObjectWithUuidRepository._();

  /// Returns a list of [ObjectWithUuid]s matching the given query parameters.
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
  Future<List<ObjectWithUuid>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithUuid] matching the given query parameters.
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
  Future<ObjectWithUuid?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithUuid] by its [id] or null if no such row exists.
  Future<ObjectWithUuid?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithUuid>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithUuid]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithUuid]s will have their `id` fields set.
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
  Future<List<ObjectWithUuid>> insert(
    _is.DatabaseSession session,
    List<ObjectWithUuid> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithUuid>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithUuid] and returns the inserted row.
  ///
  /// The returned [ObjectWithUuid] will have its `id` field set.
  Future<ObjectWithUuid> insertRow(
    _is.DatabaseSession session,
    ObjectWithUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithUuid>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithUuid]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithUuid]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithUuid>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithUuid> rows, {
    required _is.ColumnSelections<ObjectWithUuidTable> conflictColumns,
    _is.ColumnSelections<ObjectWithUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithUuidTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithUuid>(
      rows,
      conflictColumns: conflictColumns(ObjectWithUuid.t),
      updateColumns: updateColumns?.call(ObjectWithUuid.t),
      updateWhere: updateWhere?.call(ObjectWithUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithUuid] and returns the resulting row.
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
  /// The returned [ObjectWithUuid] will have its `id` field set.
  Future<ObjectWithUuid?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithUuid row, {
    required _is.ColumnSelections<ObjectWithUuidTable> conflictColumns,
    _is.ColumnSelections<ObjectWithUuidTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithUuidTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithUuid>(
      row,
      conflictColumns: conflictColumns(ObjectWithUuid.t),
      updateColumns: updateColumns?.call(ObjectWithUuid.t),
      updateWhere: updateWhere?.call(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithUuid]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithUuid>> update(
    _is.DatabaseSession session,
    List<ObjectWithUuid> rows, {
    _is.ColumnSelections<ObjectWithUuidTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithUuid>(
      rows,
      columns: columns?.call(ObjectWithUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithUuid]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithUuid> updateRow(
    _is.DatabaseSession session,
    ObjectWithUuid row, {
    _is.ColumnSelections<ObjectWithUuidTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithUuid>(
      row,
      columns: columns?.call(ObjectWithUuid.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithUuid] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithUuid?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithUuidUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithUuid>(
      id,
      columnValues: columnValues(ObjectWithUuid.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithUuid]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithUuid>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithUuidUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ObjectWithUuidTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithUuid>(
      columnValues: columnValues(ObjectWithUuid.t.updateTable),
      where: where(ObjectWithUuid.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithUuid]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithUuid>> delete(
    _is.DatabaseSession session,
    List<ObjectWithUuid> rows, {
    _is.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithUuid>(
      rows,
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithUuid].
  Future<ObjectWithUuid> deleteRow(
    _is.DatabaseSession session,
    ObjectWithUuid row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithUuid>(
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
  Future<List<ObjectWithUuid>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithUuidTable> where,
    _is.OrderByBuilder<ObjectWithUuidTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithUuidTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithUuid>(
      where: where(ObjectWithUuid.t),
      orderBy: orderBy?.call(ObjectWithUuid.t),
      orderByList: orderByList?.call(ObjectWithUuid.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithUuidTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithUuid>(
      where: where?.call(ObjectWithUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithUuid] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithUuidTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithUuid>(
      where: where(ObjectWithUuid.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
