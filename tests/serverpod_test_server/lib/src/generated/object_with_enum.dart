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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'test_enum.dart' as _ionapfu9;

abstract class ObjectWithEnum
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithEnum._({
    this.id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
    required this.enumListList,
  });

  factory ObjectWithEnum({
    int? id,
    required _ionapfu9.TestEnum testEnum,
    _ionapfu9.TestEnum? nullableEnum,
    required List<_ionapfu9.TestEnum> enumList,
    required List<_ionapfu9.TestEnum?> nullableEnumList,
    required List<List<_ionapfu9.TestEnum>> enumListList,
  }) = _ObjectWithEnumImpl;

  factory ObjectWithEnum.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithEnum(
      id: jsonSerialization['id'] as int?,
      testEnum: _ionapfu9.TestEnum.fromJson(
        (jsonSerialization['testEnum'] as int),
      ),
      nullableEnum: jsonSerialization['nullableEnum'] == null
          ? null
          : _ionapfu9.TestEnum.fromJson(
              (jsonSerialization['nullableEnum'] as int),
            ),
      enumList: _igqrxdcj.Protocol().deserialize<List<_ionapfu9.TestEnum>>(
        jsonSerialization['enumList'],
      ),
      nullableEnumList: _igqrxdcj.Protocol()
          .deserialize<List<_ionapfu9.TestEnum?>>(
            jsonSerialization['nullableEnumList'],
          ),
      enumListList: _igqrxdcj.Protocol()
          .deserialize<List<List<_ionapfu9.TestEnum>>>(
            jsonSerialization['enumListList'],
          ),
    );
  }

  static final t = ObjectWithEnumTable();

  static const db = ObjectWithEnumRepository._();

  @override
  int? id;

  _ionapfu9.TestEnum testEnum;

  _ionapfu9.TestEnum? nullableEnum;

  List<_ionapfu9.TestEnum> enumList;

  List<_ionapfu9.TestEnum?> nullableEnumList;

  List<List<_ionapfu9.TestEnum>> enumListList;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithEnum]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithEnum copyWith({
    int? id,
    _ionapfu9.TestEnum? testEnum,
    _ionapfu9.TestEnum? nullableEnum,
    List<_ionapfu9.TestEnum>? enumList,
    List<_ionapfu9.TestEnum?>? nullableEnumList,
    List<List<_ionapfu9.TestEnum>>? enumListList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithEnum',
      if (id != null) 'id': id,
      'testEnum': testEnum.toJson(),
      if (nullableEnum != null) 'nullableEnum': nullableEnum?.toJson(),
      'enumList': enumList.toJson(valueToJson: (v) => v.toJson()),
      'nullableEnumList': nullableEnumList.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'enumListList': enumListList.toJson(
        valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
      ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithEnum',
      if (id != null) 'id': id,
      'testEnum': testEnum.toJson(),
      if (nullableEnum != null) 'nullableEnum': nullableEnum?.toJson(),
      'enumList': enumList.toJson(valueToJson: (v) => v.toJson()),
      'nullableEnumList': nullableEnumList.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'enumListList': enumListList.toJson(
        valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
      ),
    };
  }

  static ObjectWithEnumInclude include() {
    return ObjectWithEnumInclude.internal_();
  }

  static ObjectWithEnumIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    ObjectWithEnumInclude? include,
  }) {
    return ObjectWithEnumIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithEnumImpl extends ObjectWithEnum {
  _ObjectWithEnumImpl({
    int? id,
    required _ionapfu9.TestEnum testEnum,
    _ionapfu9.TestEnum? nullableEnum,
    required List<_ionapfu9.TestEnum> enumList,
    required List<_ionapfu9.TestEnum?> nullableEnumList,
    required List<List<_ionapfu9.TestEnum>> enumListList,
  }) : super._(
         id: id,
         testEnum: testEnum,
         nullableEnum: nullableEnum,
         enumList: enumList,
         nullableEnumList: nullableEnumList,
         enumListList: enumListList,
       );

  /// Returns a shallow copy of this [ObjectWithEnum]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithEnum copyWith({
    Object? id = _Undefined,
    _ionapfu9.TestEnum? testEnum,
    Object? nullableEnum = _Undefined,
    List<_ionapfu9.TestEnum>? enumList,
    List<_ionapfu9.TestEnum?>? nullableEnumList,
    List<List<_ionapfu9.TestEnum>>? enumListList,
  }) {
    return ObjectWithEnum(
      id: id is int? ? id : this.id,
      testEnum: testEnum ?? this.testEnum,
      nullableEnum: nullableEnum is _ionapfu9.TestEnum?
          ? nullableEnum
          : this.nullableEnum,
      enumList: enumList ?? this.enumList.map((e0) => e0).toList(),
      nullableEnumList:
          nullableEnumList ?? this.nullableEnumList.map((e0) => e0).toList(),
      enumListList:
          enumListList ??
          this.enumListList.map((e0) => e0.map((e1) => e1).toList()).toList(),
    );
  }
}

class ObjectWithEnumUpdateTable extends _is.UpdateTable<ObjectWithEnumTable> {
  ObjectWithEnumUpdateTable(super.table);

  _is.ColumnValue<_ionapfu9.TestEnum, _ionapfu9.TestEnum> testEnum(
    _ionapfu9.TestEnum value,
  ) => _is.ColumnValue(
    table.testEnum,
    value,
  );

  _is.ColumnValue<_ionapfu9.TestEnum, _ionapfu9.TestEnum> nullableEnum(
    _ionapfu9.TestEnum? value,
  ) => _is.ColumnValue(
    table.nullableEnum,
    value,
  );

  _is.ColumnValue<List<_ionapfu9.TestEnum>, List<_ionapfu9.TestEnum>> enumList(
    List<_ionapfu9.TestEnum> value,
  ) => _is.ColumnValue(
    table.enumList,
    value,
  );

  _is.ColumnValue<List<_ionapfu9.TestEnum?>, List<_ionapfu9.TestEnum?>>
  nullableEnumList(List<_ionapfu9.TestEnum?> value) => _is.ColumnValue(
    table.nullableEnumList,
    value,
  );

  _is.ColumnValue<
    List<List<_ionapfu9.TestEnum>>,
    List<List<_ionapfu9.TestEnum>>
  >
  enumListList(List<List<_ionapfu9.TestEnum>> value) => _is.ColumnValue(
    table.enumListList,
    value,
  );
}

class ObjectWithEnumTable extends _is.Table<int?> {
  ObjectWithEnumTable({super.tableRelation})
    : super(tableName: 'object_with_enum') {
    updateTable = ObjectWithEnumUpdateTable(this);
    testEnum = _is.ColumnEnum(
      'testEnum',
      this,
      _is.EnumSerialization.byIndex,
    );
    nullableEnum = _is.ColumnEnum(
      'nullableEnum',
      this,
      _is.EnumSerialization.byIndex,
    );
    enumList = _is.ColumnSerializable<List<_ionapfu9.TestEnum>>(
      'enumList',
      this,
    );
    nullableEnumList = _is.ColumnSerializable<List<_ionapfu9.TestEnum?>>(
      'nullableEnumList',
      this,
    );
    enumListList = _is.ColumnSerializable<List<List<_ionapfu9.TestEnum>>>(
      'enumListList',
      this,
    );
  }

  late final ObjectWithEnumUpdateTable updateTable;

  late final _is.ColumnEnum<_ionapfu9.TestEnum> testEnum;

  late final _is.ColumnEnum<_ionapfu9.TestEnum> nullableEnum;

  late final _is.ColumnSerializable<List<_ionapfu9.TestEnum>> enumList;

  late final _is.ColumnSerializable<List<_ionapfu9.TestEnum?>> nullableEnumList;

  late final _is.ColumnSerializable<List<List<_ionapfu9.TestEnum>>>
  enumListList;

  @override
  List<_is.Column> get columns => [
    id,
    testEnum,
    nullableEnum,
    enumList,
    nullableEnumList,
    enumListList,
  ];
}

class ObjectWithEnumInclude extends _is.IncludeObject {
  ObjectWithEnumInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithEnum.t;
}

class ObjectWithEnumIncludeList extends _is.IncludeList {
  ObjectWithEnumIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithEnum.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithEnum.t;
}

class ObjectWithEnumRepository {
  const ObjectWithEnumRepository._();

  /// Returns a list of [ObjectWithEnum]s matching the given query parameters.
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
  Future<List<ObjectWithEnum>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithEnum] matching the given query parameters.
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
  Future<ObjectWithEnum?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithEnum] by its [id] or null if no such row exists.
  Future<ObjectWithEnum?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithEnum>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithEnum]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithEnum]s will have their `id` fields set.
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
  Future<List<ObjectWithEnum>> insert(
    _is.DatabaseSession session,
    List<ObjectWithEnum> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithEnum>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithEnum] and returns the inserted row.
  ///
  /// The returned [ObjectWithEnum] will have its `id` field set.
  Future<ObjectWithEnum> insertRow(
    _is.DatabaseSession session,
    ObjectWithEnum row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithEnum>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithEnum]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithEnum]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithEnum>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithEnum> rows, {
    required _is.ColumnSelections<ObjectWithEnumTable> conflictColumns,
    _is.ColumnSelections<ObjectWithEnumTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithEnumTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithEnum>(
      rows,
      conflictColumns: conflictColumns(ObjectWithEnum.t),
      updateColumns: updateColumns?.call(ObjectWithEnum.t),
      updateWhere: updateWhere?.call(ObjectWithEnum.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithEnum] and returns the resulting row.
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
  /// The returned [ObjectWithEnum] will have its `id` field set.
  Future<ObjectWithEnum?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithEnum row, {
    required _is.ColumnSelections<ObjectWithEnumTable> conflictColumns,
    _is.ColumnSelections<ObjectWithEnumTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithEnumTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithEnum>(
      row,
      conflictColumns: conflictColumns(ObjectWithEnum.t),
      updateColumns: updateColumns?.call(ObjectWithEnum.t),
      updateWhere: updateWhere?.call(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithEnum]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithEnum>> update(
    _is.DatabaseSession session,
    List<ObjectWithEnum> rows, {
    _is.ColumnSelections<ObjectWithEnumTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithEnum>(
      rows,
      columns: columns?.call(ObjectWithEnum.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithEnum]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithEnum> updateRow(
    _is.DatabaseSession session,
    ObjectWithEnum row, {
    _is.ColumnSelections<ObjectWithEnumTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithEnum>(
      row,
      columns: columns?.call(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithEnum] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithEnum?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithEnumUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithEnum>(
      id,
      columnValues: columnValues(ObjectWithEnum.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithEnum]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithEnum>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithEnumUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ObjectWithEnumTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithEnum>(
      columnValues: columnValues(ObjectWithEnum.t.updateTable),
      where: where(ObjectWithEnum.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithEnum]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithEnum>> delete(
    _is.DatabaseSession session,
    List<ObjectWithEnum> rows, {
    _is.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithEnum>(
      rows,
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithEnum].
  Future<ObjectWithEnum> deleteRow(
    _is.DatabaseSession session,
    ObjectWithEnum row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithEnum>(
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
  Future<List<ObjectWithEnum>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithEnumTable> where,
    _is.OrderByBuilder<ObjectWithEnumTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithEnumTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithEnum>(
      where: where(ObjectWithEnum.t),
      orderBy: orderBy?.call(ObjectWithEnum.t),
      orderByList: orderByList?.call(ObjectWithEnum.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithEnumTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithEnum>(
      where: where?.call(ObjectWithEnum.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithEnum] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithEnumTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithEnum>(
      where: where(ObjectWithEnum.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
