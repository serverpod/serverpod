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
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import 'test_enum_enhanced.dart' as _it39smib;
import 'test_enum_enhanced_by_name.dart' as _izw460bh;

abstract class ObjectWithEnumEnhanced
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithEnumEnhanced._({
    this.id,
    required this.byIndex,
    this.nullableByIndex,
    required this.byIndexList,
    required this.byName,
    this.nullableByName,
    required this.byNameList,
  });

  factory ObjectWithEnumEnhanced({
    int? id,
    required _it39smib.TestEnumEnhanced byIndex,
    _it39smib.TestEnumEnhanced? nullableByIndex,
    required List<_it39smib.TestEnumEnhanced> byIndexList,
    required _izw460bh.TestEnumEnhancedByName byName,
    _izw460bh.TestEnumEnhancedByName? nullableByName,
    required List<_izw460bh.TestEnumEnhancedByName> byNameList,
  }) = _ObjectWithEnumEnhancedImpl;

  factory ObjectWithEnumEnhanced.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithEnumEnhanced(
      id: jsonSerialization['id'] as int?,
      byIndex: _it39smib.TestEnumEnhanced.fromJson(
        (jsonSerialization['byIndex'] as int),
      ),
      nullableByIndex: jsonSerialization['nullableByIndex'] == null
          ? null
          : _it39smib.TestEnumEnhanced.fromJson(
              (jsonSerialization['nullableByIndex'] as int),
            ),
      byIndexList: _i08l111i.Protocol()
          .deserialize<List<_it39smib.TestEnumEnhanced>>(
            jsonSerialization['byIndexList'],
          ),
      byName: _izw460bh.TestEnumEnhancedByName.fromJson(
        (jsonSerialization['byName'] as String),
      ),
      nullableByName: jsonSerialization['nullableByName'] == null
          ? null
          : _izw460bh.TestEnumEnhancedByName.fromJson(
              (jsonSerialization['nullableByName'] as String),
            ),
      byNameList: _i08l111i.Protocol()
          .deserialize<List<_izw460bh.TestEnumEnhancedByName>>(
            jsonSerialization['byNameList'],
          ),
    );
  }

  static final t = ObjectWithEnumEnhancedTable();

  static const db = ObjectWithEnumEnhancedRepository._();

  @override
  int? id;

  _it39smib.TestEnumEnhanced byIndex;

  _it39smib.TestEnumEnhanced? nullableByIndex;

  List<_it39smib.TestEnumEnhanced> byIndexList;

  _izw460bh.TestEnumEnhancedByName byName;

  _izw460bh.TestEnumEnhancedByName? nullableByName;

  List<_izw460bh.TestEnumEnhancedByName> byNameList;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithEnumEnhanced copyWith({
    int? id,
    _it39smib.TestEnumEnhanced? byIndex,
    _it39smib.TestEnumEnhanced? nullableByIndex,
    List<_it39smib.TestEnumEnhanced>? byIndexList,
    _izw460bh.TestEnumEnhancedByName? byName,
    _izw460bh.TestEnumEnhancedByName? nullableByName,
    List<_izw460bh.TestEnumEnhancedByName>? byNameList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithEnumEnhanced',
      if (id != null) 'id': id,
      'byIndex': byIndex.toJson(),
      if (nullableByIndex != null) 'nullableByIndex': nullableByIndex?.toJson(),
      'byIndexList': byIndexList.toJson(valueToJson: (v) => v.toJson()),
      'byName': byName.toJson(),
      if (nullableByName != null) 'nullableByName': nullableByName?.toJson(),
      'byNameList': byNameList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithEnumEnhanced',
      if (id != null) 'id': id,
      'byIndex': byIndex.toJson(),
      if (nullableByIndex != null) 'nullableByIndex': nullableByIndex?.toJson(),
      'byIndexList': byIndexList.toJson(valueToJson: (v) => v.toJson()),
      'byName': byName.toJson(),
      if (nullableByName != null) 'nullableByName': nullableByName?.toJson(),
      'byNameList': byNameList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  static ObjectWithEnumEnhancedInclude include() {
    return ObjectWithEnumEnhancedInclude.internal_();
  }

  static ObjectWithEnumEnhancedIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    ObjectWithEnumEnhancedInclude? include,
  }) {
    return ObjectWithEnumEnhancedIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithEnumEnhancedImpl extends ObjectWithEnumEnhanced {
  _ObjectWithEnumEnhancedImpl({
    int? id,
    required _it39smib.TestEnumEnhanced byIndex,
    _it39smib.TestEnumEnhanced? nullableByIndex,
    required List<_it39smib.TestEnumEnhanced> byIndexList,
    required _izw460bh.TestEnumEnhancedByName byName,
    _izw460bh.TestEnumEnhancedByName? nullableByName,
    required List<_izw460bh.TestEnumEnhancedByName> byNameList,
  }) : super._(
         id: id,
         byIndex: byIndex,
         nullableByIndex: nullableByIndex,
         byIndexList: byIndexList,
         byName: byName,
         nullableByName: nullableByName,
         byNameList: byNameList,
       );

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithEnumEnhanced copyWith({
    Object? id = _Undefined,
    _it39smib.TestEnumEnhanced? byIndex,
    Object? nullableByIndex = _Undefined,
    List<_it39smib.TestEnumEnhanced>? byIndexList,
    _izw460bh.TestEnumEnhancedByName? byName,
    Object? nullableByName = _Undefined,
    List<_izw460bh.TestEnumEnhancedByName>? byNameList,
  }) {
    return ObjectWithEnumEnhanced(
      id: id is int? ? id : this.id,
      byIndex: byIndex ?? this.byIndex,
      nullableByIndex: nullableByIndex is _it39smib.TestEnumEnhanced?
          ? nullableByIndex
          : this.nullableByIndex,
      byIndexList: byIndexList ?? this.byIndexList.map((e0) => e0).toList(),
      byName: byName ?? this.byName,
      nullableByName: nullableByName is _izw460bh.TestEnumEnhancedByName?
          ? nullableByName
          : this.nullableByName,
      byNameList: byNameList ?? this.byNameList.map((e0) => e0).toList(),
    );
  }
}

class ObjectWithEnumEnhancedUpdateTable
    extends _is.UpdateTable<ObjectWithEnumEnhancedTable> {
  ObjectWithEnumEnhancedUpdateTable(super.table);

  _is.ColumnValue<_it39smib.TestEnumEnhanced, _it39smib.TestEnumEnhanced>
  byIndex(_it39smib.TestEnumEnhanced value) => _is.ColumnValue(
    table.byIndex,
    value,
  );

  _is.ColumnValue<_it39smib.TestEnumEnhanced, _it39smib.TestEnumEnhanced>
  nullableByIndex(_it39smib.TestEnumEnhanced? value) => _is.ColumnValue(
    table.nullableByIndex,
    value,
  );

  _is.ColumnValue<
    List<_it39smib.TestEnumEnhanced>,
    List<_it39smib.TestEnumEnhanced>
  >
  byIndexList(List<_it39smib.TestEnumEnhanced> value) => _is.ColumnValue(
    table.byIndexList,
    value,
  );

  _is.ColumnValue<
    _izw460bh.TestEnumEnhancedByName,
    _izw460bh.TestEnumEnhancedByName
  >
  byName(_izw460bh.TestEnumEnhancedByName value) => _is.ColumnValue(
    table.byName,
    value,
  );

  _is.ColumnValue<
    _izw460bh.TestEnumEnhancedByName,
    _izw460bh.TestEnumEnhancedByName
  >
  nullableByName(_izw460bh.TestEnumEnhancedByName? value) => _is.ColumnValue(
    table.nullableByName,
    value,
  );

  _is.ColumnValue<
    List<_izw460bh.TestEnumEnhancedByName>,
    List<_izw460bh.TestEnumEnhancedByName>
  >
  byNameList(List<_izw460bh.TestEnumEnhancedByName> value) => _is.ColumnValue(
    table.byNameList,
    value,
  );
}

class ObjectWithEnumEnhancedTable extends _is.Table<int?> {
  ObjectWithEnumEnhancedTable({super.tableRelation})
    : super(tableName: 'object_with_enum_enhanced') {
    updateTable = ObjectWithEnumEnhancedUpdateTable(this);
    byIndex = _is.ColumnEnum(
      'byIndex',
      this,
      _is.EnumSerialization.byIndex,
    );
    nullableByIndex = _is.ColumnEnum(
      'nullableByIndex',
      this,
      _is.EnumSerialization.byIndex,
    );
    byIndexList = _is.ColumnSerializable<List<_it39smib.TestEnumEnhanced>>(
      'byIndexList',
      this,
    );
    byName = _is.ColumnEnum(
      'byName',
      this,
      _is.EnumSerialization.byName,
    );
    nullableByName = _is.ColumnEnum(
      'nullableByName',
      this,
      _is.EnumSerialization.byName,
    );
    byNameList = _is.ColumnSerializable<List<_izw460bh.TestEnumEnhancedByName>>(
      'byNameList',
      this,
    );
  }

  late final ObjectWithEnumEnhancedUpdateTable updateTable;

  late final _is.ColumnEnum<_it39smib.TestEnumEnhanced> byIndex;

  late final _is.ColumnEnum<_it39smib.TestEnumEnhanced> nullableByIndex;

  late final _is.ColumnSerializable<List<_it39smib.TestEnumEnhanced>>
  byIndexList;

  late final _is.ColumnEnum<_izw460bh.TestEnumEnhancedByName> byName;

  late final _is.ColumnEnum<_izw460bh.TestEnumEnhancedByName> nullableByName;

  late final _is.ColumnSerializable<List<_izw460bh.TestEnumEnhancedByName>>
  byNameList;

  @override
  List<_is.Column> get columns => [
    id,
    byIndex,
    nullableByIndex,
    byIndexList,
    byName,
    nullableByName,
    byNameList,
  ];
}

class ObjectWithEnumEnhancedInclude extends _is.IncludeObject {
  ObjectWithEnumEnhancedInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithEnumEnhanced.t;
}

class ObjectWithEnumEnhancedIncludeList extends _is.IncludeList {
  ObjectWithEnumEnhancedIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithEnumEnhanced.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithEnumEnhanced.t;
}

class ObjectWithEnumEnhancedRepository {
  const ObjectWithEnumEnhancedRepository._();

  /// Returns a list of [ObjectWithEnumEnhanced]s matching the given query parameters.
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
  Future<List<ObjectWithEnumEnhanced>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithEnumEnhanced>(
      where: where?.call(ObjectWithEnumEnhanced.t),
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithEnumEnhanced] matching the given query parameters.
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
  Future<ObjectWithEnumEnhanced?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithEnumEnhanced>(
      where: where?.call(ObjectWithEnumEnhanced.t),
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithEnumEnhanced] by its [id] or null if no such row exists.
  Future<ObjectWithEnumEnhanced?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithEnumEnhanced>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithEnumEnhanced]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithEnumEnhanced]s will have their `id` fields set.
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
  Future<List<ObjectWithEnumEnhanced>> insert(
    _is.DatabaseSession session,
    List<ObjectWithEnumEnhanced> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithEnumEnhanced>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithEnumEnhanced] and returns the inserted row.
  ///
  /// The returned [ObjectWithEnumEnhanced] will have its `id` field set.
  Future<ObjectWithEnumEnhanced> insertRow(
    _is.DatabaseSession session,
    ObjectWithEnumEnhanced row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithEnumEnhanced>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithEnumEnhanced]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithEnumEnhanced]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithEnumEnhanced>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithEnumEnhanced> rows, {
    required _is.ColumnSelections<ObjectWithEnumEnhancedTable> conflictColumns,
    _is.ColumnSelections<ObjectWithEnumEnhancedTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithEnumEnhanced>(
      rows,
      conflictColumns: conflictColumns(ObjectWithEnumEnhanced.t),
      updateColumns: updateColumns?.call(ObjectWithEnumEnhanced.t),
      updateWhere: updateWhere?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithEnumEnhanced] and returns the resulting row.
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
  /// The returned [ObjectWithEnumEnhanced] will have its `id` field set.
  Future<ObjectWithEnumEnhanced?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithEnumEnhanced row, {
    required _is.ColumnSelections<ObjectWithEnumEnhancedTable> conflictColumns,
    _is.ColumnSelections<ObjectWithEnumEnhancedTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithEnumEnhanced>(
      row,
      conflictColumns: conflictColumns(ObjectWithEnumEnhanced.t),
      updateColumns: updateColumns?.call(ObjectWithEnumEnhanced.t),
      updateWhere: updateWhere?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithEnumEnhanced]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithEnumEnhanced>> update(
    _is.DatabaseSession session,
    List<ObjectWithEnumEnhanced> rows, {
    _is.ColumnSelections<ObjectWithEnumEnhancedTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithEnumEnhanced>(
      rows,
      columns: columns?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithEnumEnhanced]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithEnumEnhanced> updateRow(
    _is.DatabaseSession session,
    ObjectWithEnumEnhanced row, {
    _is.ColumnSelections<ObjectWithEnumEnhancedTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithEnumEnhanced>(
      row,
      columns: columns?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithEnumEnhanced] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithEnumEnhanced?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithEnumEnhancedUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithEnumEnhanced>(
      id,
      columnValues: columnValues(ObjectWithEnumEnhanced.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithEnumEnhanced]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithEnumEnhanced>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithEnumEnhancedUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithEnumEnhanced>(
      columnValues: columnValues(ObjectWithEnumEnhanced.t.updateTable),
      where: where(ObjectWithEnumEnhanced.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithEnumEnhanced]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithEnumEnhanced>> delete(
    _is.DatabaseSession session,
    List<ObjectWithEnumEnhanced> rows, {
    _is.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithEnumEnhanced>(
      rows,
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithEnumEnhanced].
  Future<ObjectWithEnumEnhanced> deleteRow(
    _is.DatabaseSession session,
    ObjectWithEnumEnhanced row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithEnumEnhanced>(
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
  Future<List<ObjectWithEnumEnhanced>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable> where,
    _is.OrderByBuilder<ObjectWithEnumEnhancedTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumEnhancedTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithEnumEnhanced>(
      where: where(ObjectWithEnumEnhanced.t),
      orderBy: orderBy?.call(ObjectWithEnumEnhanced.t),
      orderByList: orderByList?.call(ObjectWithEnumEnhanced.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithEnumEnhanced>(
      where: where?.call(ObjectWithEnumEnhanced.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithEnumEnhanced] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithEnumEnhancedTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithEnumEnhanced>(
      where: where(ObjectWithEnumEnhanced.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
