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
import 'package:serverpod_database/serverpod_database.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;
import 'package:serverpod_test_sqlite_shared/serverpod_test_sqlite_shared.dart'
    as _i3;

abstract class SharedTableRecord
    implements _i1.TableRow<int?>, _i2.ProtocolSerialization {
  SharedTableRecord._({
    this.id,
    required this.name,
    required this.sharedEnum,
    this.sharedSubclass,
    int? itemCount,
  }) : itemCount = itemCount ?? 0;

  factory SharedTableRecord({
    int? id,
    required String name,
    required _i3.SharedEnum sharedEnum,
    _i3.SharedSubclass? sharedSubclass,
    int? itemCount,
  }) = _SharedTableRecordImpl;

  factory SharedTableRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedTableRecord(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      sharedEnum: _i3.SharedEnum.fromJson(
        (jsonSerialization['sharedEnum'] as String),
      ),
      sharedSubclass: jsonSerialization['sharedSubclass'] == null
          ? null
          : _i3.Protocol().deserialize<_i3.SharedSubclass>(
              jsonSerialization['sharedSubclass'],
            ),
      itemCount: jsonSerialization['itemCount'] as int?,
    );
  }

  static final t = SharedTableRecordTable();

  static const db = SharedTableRecordRepository._();

  @override
  int? id;

  String name;

  _i3.SharedEnum sharedEnum;

  _i3.SharedSubclass? sharedSubclass;

  int itemCount;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedTableRecord]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  SharedTableRecord copyWith({
    int? id,
    String? name,
    _i3.SharedEnum? sharedEnum,
    _i3.SharedSubclass? sharedSubclass,
    int? itemCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedTableRecord',
      if (id != null) 'id': id,
      'name': name,
      'sharedEnum': sharedEnum.toJson(),
      if (sharedSubclass != null) 'sharedSubclass': sharedSubclass?.toJson(),
      'itemCount': itemCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedTableRecord',
      if (id != null) 'id': id,
      'name': name,
      'sharedEnum': sharedEnum.toJson(),
      if (sharedSubclass != null)
        'sharedSubclass': sharedSubclass?.toJsonForProtocol(),
      'itemCount': itemCount,
    };
  }

  static SharedTableRecordInclude include() {
    return SharedTableRecordInclude._();
  }

  static SharedTableRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _i1.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    SharedTableRecordInclude? include,
  }) {
    return SharedTableRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedTableRecord.t),
      orderByList: orderByList?.call(SharedTableRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedTableRecordImpl extends SharedTableRecord {
  _SharedTableRecordImpl({
    int? id,
    required String name,
    required _i3.SharedEnum sharedEnum,
    _i3.SharedSubclass? sharedSubclass,
    int? itemCount,
  }) : super._(
         id: id,
         name: name,
         sharedEnum: sharedEnum,
         sharedSubclass: sharedSubclass,
         itemCount: itemCount,
       );

  /// Returns a shallow copy of this [SharedTableRecord]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SharedTableRecord copyWith({
    Object? id = _Undefined,
    String? name,
    _i3.SharedEnum? sharedEnum,
    Object? sharedSubclass = _Undefined,
    int? itemCount,
  }) {
    return SharedTableRecord(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      sharedEnum: sharedEnum ?? this.sharedEnum,
      sharedSubclass: sharedSubclass is _i3.SharedSubclass?
          ? sharedSubclass
          : this.sharedSubclass?.copyWith(),
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

class SharedTableRecordUpdateTable
    extends _i1.UpdateTable<SharedTableRecordTable> {
  SharedTableRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<_i3.SharedEnum, _i3.SharedEnum> sharedEnum(
    _i3.SharedEnum value,
  ) => _i1.ColumnValue(
    table.sharedEnum,
    value,
  );

  _i1.ColumnValue<_i3.SharedSubclass, _i3.SharedSubclass> sharedSubclass(
    _i3.SharedSubclass? value,
  ) => _i1.ColumnValue(
    table.sharedSubclass,
    value,
  );

  _i1.ColumnValue<int, int> itemCount(int value) => _i1.ColumnValue(
    table.itemCount,
    value,
  );
}

class SharedTableRecordTable extends _i1.Table<int?> {
  SharedTableRecordTable({super.tableRelation})
    : super(tableName: 'shared_table_record') {
    updateTable = SharedTableRecordUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    sharedEnum = _i1.ColumnEnum(
      'sharedEnum',
      this,
      _i1.EnumSerialization.byName,
    );
    sharedSubclass = _i1.ColumnSerializable<_i3.SharedSubclass>(
      'sharedSubclass',
      this,
    );
    itemCount = _i1.ColumnInt(
      'itemCount',
      this,
      hasDefault: true,
    );
  }

  late final SharedTableRecordUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnEnum<_i3.SharedEnum> sharedEnum;

  late final _i1.ColumnSerializable<_i3.SharedSubclass> sharedSubclass;

  late final _i1.ColumnInt itemCount;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    sharedEnum,
    sharedSubclass,
    itemCount,
  ];
}

class SharedTableRecordInclude extends _i1.IncludeObject {
  SharedTableRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SharedTableRecord.t;
}

class SharedTableRecordIncludeList extends _i1.IncludeList {
  SharedTableRecordIncludeList._({
    _i1.WhereExpressionBuilder<SharedTableRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SharedTableRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SharedTableRecord.t;
}

class SharedTableRecordRepository {
  const SharedTableRecordRepository._();

  /// Returns a list of [SharedTableRecord]s matching the given query parameters.
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
  Future<List<SharedTableRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _i1.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SharedTableRecord>(
      where: where?.call(SharedTableRecord.t),
      orderBy: orderBy?.call(SharedTableRecord.t),
      orderByList: orderByList?.call(SharedTableRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SharedTableRecord] matching the given query parameters.
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
  Future<SharedTableRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _i1.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SharedTableRecord>(
      where: where?.call(SharedTableRecord.t),
      orderBy: orderBy?.call(SharedTableRecord.t),
      orderByList: orderByList?.call(SharedTableRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SharedTableRecord] by its [id] or null if no such row exists.
  Future<SharedTableRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SharedTableRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SharedTableRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [SharedTableRecord]s will have their `id` fields set.
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
  Future<List<SharedTableRecord>> insert(
    _i1.DatabaseSession session,
    List<SharedTableRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SharedTableRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SharedTableRecord] and returns the inserted row.
  ///
  /// The returned [SharedTableRecord] will have its `id` field set.
  Future<SharedTableRecord> insertRow(
    _i1.DatabaseSession session,
    SharedTableRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedTableRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SharedTableRecord]s in the list and returns the resulting rows.
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
  /// The returned [SharedTableRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedTableRecord>> upsert(
    _i1.DatabaseSession session,
    List<SharedTableRecord> rows, {
    required _i1.ColumnSelections<SharedTableRecordTable> conflictColumns,
    _i1.ColumnSelections<SharedTableRecordTable>? updateColumns,
    _i1.WhereExpressionBuilder<SharedTableRecordTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SharedTableRecord>(
      rows,
      conflictColumns: conflictColumns(SharedTableRecord.t),
      updateColumns: updateColumns?.call(SharedTableRecord.t),
      updateWhere: updateWhere?.call(SharedTableRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SharedTableRecord] and returns the resulting row.
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
  /// The returned [SharedTableRecord] will have its `id` field set.
  Future<SharedTableRecord?> upsertRow(
    _i1.DatabaseSession session,
    SharedTableRecord row, {
    required _i1.ColumnSelections<SharedTableRecordTable> conflictColumns,
    _i1.ColumnSelections<SharedTableRecordTable>? updateColumns,
    _i1.WhereExpressionBuilder<SharedTableRecordTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SharedTableRecord>(
      row,
      conflictColumns: conflictColumns(SharedTableRecord.t),
      updateColumns: updateColumns?.call(SharedTableRecord.t),
      updateWhere: updateWhere?.call(SharedTableRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [SharedTableRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedTableRecord>> update(
    _i1.DatabaseSession session,
    List<SharedTableRecord> rows, {
    _i1.ColumnSelections<SharedTableRecordTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SharedTableRecord>(
      rows,
      columns: columns?.call(SharedTableRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SharedTableRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedTableRecord> updateRow(
    _i1.DatabaseSession session,
    SharedTableRecord row, {
    _i1.ColumnSelections<SharedTableRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SharedTableRecord>(
      row,
      columns: columns?.call(SharedTableRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedTableRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SharedTableRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<SharedTableRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SharedTableRecord>(
      id,
      columnValues: columnValues(SharedTableRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SharedTableRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedTableRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SharedTableRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SharedTableRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _i1.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SharedTableRecord>(
      columnValues: columnValues(SharedTableRecord.t.updateTable),
      where: where(SharedTableRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedTableRecord.t),
      orderByList: orderByList?.call(SharedTableRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SharedTableRecord]s in the list and returns the deleted rows.
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
  Future<List<SharedTableRecord>> delete(
    _i1.DatabaseSession session,
    List<SharedTableRecord> rows, {
    _i1.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _i1.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SharedTableRecord>(
      rows,
      orderBy: orderBy?.call(SharedTableRecord.t),
      orderByList: orderByList?.call(SharedTableRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SharedTableRecord].
  Future<SharedTableRecord> deleteRow(
    _i1.DatabaseSession session,
    SharedTableRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedTableRecord>(
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
  Future<List<SharedTableRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SharedTableRecordTable> where,
    _i1.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _i1.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SharedTableRecord>(
      where: where(SharedTableRecord.t),
      orderBy: orderBy?.call(SharedTableRecord.t),
      orderByList: orderByList?.call(SharedTableRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SharedTableRecord>(
      where: where?.call(SharedTableRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SharedTableRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SharedTableRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SharedTableRecord>(
      where: where(SharedTableRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
