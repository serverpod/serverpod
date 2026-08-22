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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;

abstract class SharedTableRecord
    implements _isd.TableRow<int?>, _iss.ProtocolSerialization {
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
    required _ilwf0zl1.SharedEnum sharedEnum,
    _ilwf0zl1.SharedSubclass? sharedSubclass,
    int? itemCount,
  }) = _SharedTableRecordImpl;

  factory SharedTableRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedTableRecord(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      sharedEnum: _ilwf0zl1.SharedEnum.fromJson(
        (jsonSerialization['sharedEnum'] as String),
      ),
      sharedSubclass: jsonSerialization['sharedSubclass'] == null
          ? null
          : _ilwf0zl1.Protocol().deserialize<_ilwf0zl1.SharedSubclass>(
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

  _ilwf0zl1.SharedEnum sharedEnum;

  _ilwf0zl1.SharedSubclass? sharedSubclass;

  int itemCount;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedTableRecord]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  SharedTableRecord copyWith({
    int? id,
    String? name,
    _ilwf0zl1.SharedEnum? sharedEnum,
    _ilwf0zl1.SharedSubclass? sharedSubclass,
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
    return SharedTableRecordInclude.internal_();
  }

  static SharedTableRecordIncludeList includeList({
    _isd.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _isd.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    SharedTableRecordInclude? include,
  }) {
    return SharedTableRecordIncludeList.internal_(
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
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedTableRecordImpl extends SharedTableRecord {
  _SharedTableRecordImpl({
    int? id,
    required String name,
    required _ilwf0zl1.SharedEnum sharedEnum,
    _ilwf0zl1.SharedSubclass? sharedSubclass,
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
  @_iss.useResult
  @override
  SharedTableRecord copyWith({
    Object? id = _Undefined,
    String? name,
    _ilwf0zl1.SharedEnum? sharedEnum,
    Object? sharedSubclass = _Undefined,
    int? itemCount,
  }) {
    return SharedTableRecord(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      sharedEnum: sharedEnum ?? this.sharedEnum,
      sharedSubclass: sharedSubclass is _ilwf0zl1.SharedSubclass?
          ? sharedSubclass
          : this.sharedSubclass?.copyWith(),
      itemCount: itemCount ?? this.itemCount,
    );
  }
}

class SharedTableRecordUpdateTable
    extends _isd.UpdateTable<SharedTableRecordTable> {
  SharedTableRecordUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );

  _isd.ColumnValue<_ilwf0zl1.SharedEnum, _ilwf0zl1.SharedEnum> sharedEnum(
    _ilwf0zl1.SharedEnum value,
  ) => _isd.ColumnValue(
    table.sharedEnum,
    value,
  );

  _isd.ColumnValue<_ilwf0zl1.SharedSubclass, _ilwf0zl1.SharedSubclass>
  sharedSubclass(_ilwf0zl1.SharedSubclass? value) => _isd.ColumnValue(
    table.sharedSubclass,
    value,
  );

  _isd.ColumnValue<int, int> itemCount(int value) => _isd.ColumnValue(
    table.itemCount,
    value,
  );
}

class SharedTableRecordTable extends _isd.Table<int?> {
  SharedTableRecordTable({super.tableRelation})
    : super(tableName: 'shared_table_record') {
    updateTable = SharedTableRecordUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
    sharedEnum = _isd.ColumnEnum(
      'sharedEnum',
      this,
      _isd.EnumSerialization.byName,
    );
    sharedSubclass = _isd.ColumnSerializable<_ilwf0zl1.SharedSubclass>(
      'sharedSubclass',
      this,
    );
    itemCount = _isd.ColumnInt(
      'itemCount',
      this,
      hasDefault: true,
    );
  }

  late final SharedTableRecordUpdateTable updateTable;

  late final _isd.ColumnString name;

  late final _isd.ColumnEnum<_ilwf0zl1.SharedEnum> sharedEnum;

  late final _isd.ColumnSerializable<_ilwf0zl1.SharedSubclass> sharedSubclass;

  late final _isd.ColumnInt itemCount;

  @override
  List<_isd.Column> get columns => [
    id,
    name,
    sharedEnum,
    sharedSubclass,
    itemCount,
  ];
}

class SharedTableRecordInclude extends _isd.IncludeObject {
  @_i057hz1u.internal
  SharedTableRecordInclude.internal_({
    List<_isd.Column>? this.selectedColumns,
  }) {}

  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => SharedTableRecord.t;
}

class SharedTableRecordIncludeList extends _isd.IncludeList {
  @_i057hz1u.internal
  SharedTableRecordIncludeList.internal_({
    _isd.WhereExpressionBuilder<SharedTableRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_isd.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(SharedTableRecord.t);
  }

  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => SharedTableRecord.t;
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _isd.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? offset,
    _isd.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _isd.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session,
    List<SharedTableRecord> rows, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    SharedTableRecord row, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<SharedTableRecord> rows, {
    required _isd.ColumnSelections<SharedTableRecordTable> conflictColumns,
    _isd.ColumnSelections<SharedTableRecordTable>? updateColumns,
    _isd.WhereExpressionBuilder<SharedTableRecordTable>? updateWhere,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    SharedTableRecord row, {
    required _isd.ColumnSelections<SharedTableRecordTable> conflictColumns,
    _isd.ColumnSelections<SharedTableRecordTable>? updateColumns,
    _isd.WhereExpressionBuilder<SharedTableRecordTable>? updateWhere,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<SharedTableRecord> rows, {
    _isd.ColumnSelections<SharedTableRecordTable>? columns,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    SharedTableRecord row, {
    _isd.ColumnSelections<SharedTableRecordTable>? columns,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<SharedTableRecordUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<SharedTableRecordUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<SharedTableRecordTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _isd.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<SharedTableRecord> rows, {
    _isd.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _isd.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    SharedTableRecord row, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SharedTableRecordTable> where,
    _isd.OrderByBuilder<SharedTableRecordTable>? orderBy,
    _isd.OrderByListBuilder<SharedTableRecordTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SharedTableRecordTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<SharedTableRecord>(
      where: where?.call(SharedTableRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SharedTableRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SharedTableRecordTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SharedTableRecord>(
      where: where(SharedTableRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
