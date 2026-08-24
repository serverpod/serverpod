/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import 'unique_data.dart' as _iufhyrjh;

abstract class RelatedUniqueData
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RelatedUniqueData._({
    this.id,
    required this.uniqueDataId,
    this.uniqueData,
    required this.number,
  });

  factory RelatedUniqueData({
    int? id,
    required int uniqueDataId,
    _iufhyrjh.UniqueData? uniqueData,
    required int number,
  }) = _RelatedUniqueDataImpl;

  factory RelatedUniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return RelatedUniqueData(
      id: jsonSerialization['id'] as int?,
      uniqueDataId: jsonSerialization['uniqueDataId'] as int,
      uniqueData: jsonSerialization['uniqueData'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_iufhyrjh.UniqueData>(
              jsonSerialization['uniqueData'],
            ),
      number: jsonSerialization['number'] as int,
    );
  }

  static final t = RelatedUniqueDataTable();

  static const db = RelatedUniqueDataRepository._();

  @override
  int? id;

  int uniqueDataId;

  _iufhyrjh.UniqueData? uniqueData;

  int number;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RelatedUniqueData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RelatedUniqueData copyWith({
    int? id,
    int? uniqueDataId,
    _iufhyrjh.UniqueData? uniqueData,
    int? number,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RelatedUniqueData',
      if (id != null) 'id': id,
      'uniqueDataId': uniqueDataId,
      if (uniqueData != null) 'uniqueData': uniqueData?.toJson(),
      'number': number,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RelatedUniqueData',
      if (id != null) 'id': id,
      'uniqueDataId': uniqueDataId,
      if (uniqueData != null) 'uniqueData': uniqueData?.toJsonForProtocol(),
      'number': number,
    };
  }

  static RelatedUniqueDataInclude include({
    _iufhyrjh.UniqueDataInclude? uniqueData,
    _is.SelectColumnsBuilder<RelatedUniqueDataTable>? select,
  }) {
    return RelatedUniqueDataInclude.internal_(
      uniqueData: uniqueData,
      selectedColumns: select?.call(RelatedUniqueData.t),
    );
  }

  static RelatedUniqueDataIncludeList includeList({
    _is.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    _is.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    RelatedUniqueDataInclude? include,
    _is.SelectColumnsBuilder<RelatedUniqueDataTable>? select,
  }) {
    return RelatedUniqueDataIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      include: include,
      selectedColumns: select?.call(RelatedUniqueData.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelatedUniqueDataImpl extends RelatedUniqueData {
  _RelatedUniqueDataImpl({
    int? id,
    required int uniqueDataId,
    _iufhyrjh.UniqueData? uniqueData,
    required int number,
  }) : super._(
         id: id,
         uniqueDataId: uniqueDataId,
         uniqueData: uniqueData,
         number: number,
       );

  /// Returns a shallow copy of this [RelatedUniqueData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RelatedUniqueData copyWith({
    Object? id = _Undefined,
    int? uniqueDataId,
    Object? uniqueData = _Undefined,
    int? number,
  }) {
    return RelatedUniqueData(
      id: id is int? ? id : this.id,
      uniqueDataId: uniqueDataId ?? this.uniqueDataId,
      uniqueData: uniqueData is _iufhyrjh.UniqueData?
          ? uniqueData
          : this.uniqueData?.copyWith(),
      number: number ?? this.number,
    );
  }
}

class RelatedUniqueDataUpdateTable
    extends _is.UpdateTable<RelatedUniqueDataTable> {
  RelatedUniqueDataUpdateTable(super.table);

  _is.ColumnValue<int, int> uniqueDataId(int value) => _is.ColumnValue(
    table.uniqueDataId,
    value,
  );

  _is.ColumnValue<int, int> number(int value) => _is.ColumnValue(
    table.number,
    value,
  );
}

class RelatedUniqueDataTable extends _is.Table<int?> {
  RelatedUniqueDataTable({super.tableRelation})
    : super(tableName: 'related_unique_data') {
    updateTable = RelatedUniqueDataUpdateTable(this);
    uniqueDataId = _is.ColumnInt(
      'uniqueDataId',
      this,
    );
    number = _is.ColumnInt(
      'number',
      this,
    );
  }

  late final RelatedUniqueDataUpdateTable updateTable;

  late final _is.ColumnInt uniqueDataId;

  _iufhyrjh.UniqueDataTable? _uniqueData;

  late final _is.ColumnInt number;

  _iufhyrjh.UniqueDataTable get uniqueData {
    if (_uniqueData != null) return _uniqueData!;
    _uniqueData = _is.createRelationTable(
      relationFieldName: 'uniqueData',
      field: RelatedUniqueData.t.uniqueDataId,
      foreignField: _iufhyrjh.UniqueData.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iufhyrjh.UniqueDataTable(tableRelation: foreignTableRelation),
    );
    return _uniqueData!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    uniqueDataId,
    number,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'uniqueData') {
      return uniqueData;
    }
    return null;
  }
}

class RelatedUniqueDataInclude extends _is.IncludeObject {
  RelatedUniqueDataInclude.internal_({
    _iufhyrjh.UniqueDataInclude? uniqueData,
    this.selectedColumns,
  }) {
    _uniqueData = uniqueData;
  }

  _iufhyrjh.UniqueDataInclude? _uniqueData;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'uniqueData': _uniqueData};

  @override
  _is.Table<int?> get table => RelatedUniqueData.t;
}

class RelatedUniqueDataIncludeList extends _is.IncludeList {
  RelatedUniqueDataIncludeList.internal_({
    _is.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(RelatedUniqueData.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RelatedUniqueData.t;
}

class RelatedUniqueDataRepository {
  const RelatedUniqueDataRepository._();

  final attachRow = const RelatedUniqueDataAttachRowRepository._();

  /// Returns a list of [RelatedUniqueData]s matching the given query parameters.
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
  Future<List<RelatedUniqueData>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    _is.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    RelatedUniqueDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RelatedUniqueData] matching the given query parameters.
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
  Future<RelatedUniqueData?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? offset,
    _is.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    _is.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    RelatedUniqueDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RelatedUniqueData] by its [id] or null if no such row exists.
  Future<RelatedUniqueData?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    RelatedUniqueDataInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RelatedUniqueData>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RelatedUniqueData]s in the list and returns the inserted rows.
  ///
  /// The returned [RelatedUniqueData]s will have their `id` fields set.
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
  Future<List<RelatedUniqueData>> insert(
    _is.DatabaseSession session,
    List<RelatedUniqueData> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RelatedUniqueData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RelatedUniqueData] and returns the inserted row.
  ///
  /// The returned [RelatedUniqueData] will have its `id` field set.
  Future<RelatedUniqueData> insertRow(
    _is.DatabaseSession session,
    RelatedUniqueData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RelatedUniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RelatedUniqueData]s in the list and returns the resulting rows.
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
  /// The returned [RelatedUniqueData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelatedUniqueData>> upsert(
    _is.DatabaseSession session,
    List<RelatedUniqueData> rows, {
    required _is.ColumnSelections<RelatedUniqueDataTable> conflictColumns,
    _is.ColumnSelections<RelatedUniqueDataTable>? updateColumns,
    _is.WhereExpressionBuilder<RelatedUniqueDataTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RelatedUniqueData>(
      rows,
      conflictColumns: conflictColumns(RelatedUniqueData.t),
      updateColumns: updateColumns?.call(RelatedUniqueData.t),
      updateWhere: updateWhere?.call(RelatedUniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RelatedUniqueData] and returns the resulting row.
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
  /// The returned [RelatedUniqueData] will have its `id` field set.
  Future<RelatedUniqueData?> upsertRow(
    _is.DatabaseSession session,
    RelatedUniqueData row, {
    required _is.ColumnSelections<RelatedUniqueDataTable> conflictColumns,
    _is.ColumnSelections<RelatedUniqueDataTable>? updateColumns,
    _is.WhereExpressionBuilder<RelatedUniqueDataTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RelatedUniqueData>(
      row,
      conflictColumns: conflictColumns(RelatedUniqueData.t),
      updateColumns: updateColumns?.call(RelatedUniqueData.t),
      updateWhere: updateWhere?.call(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates all [RelatedUniqueData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelatedUniqueData>> update(
    _is.DatabaseSession session,
    List<RelatedUniqueData> rows, {
    _is.ColumnSelections<RelatedUniqueDataTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RelatedUniqueData>(
      rows,
      columns: columns?.call(RelatedUniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RelatedUniqueData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RelatedUniqueData> updateRow(
    _is.DatabaseSession session,
    RelatedUniqueData row, {
    _is.ColumnSelections<RelatedUniqueDataTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RelatedUniqueData>(
      row,
      columns: columns?.call(RelatedUniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RelatedUniqueData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RelatedUniqueData?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RelatedUniqueDataUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RelatedUniqueData>(
      id,
      columnValues: columnValues(RelatedUniqueData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RelatedUniqueData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelatedUniqueData>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RelatedUniqueDataUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<RelatedUniqueDataTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    _is.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RelatedUniqueData>(
      columnValues: columnValues(RelatedUniqueData.t.updateTable),
      where: where(RelatedUniqueData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RelatedUniqueData]s in the list and returns the deleted rows.
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
  Future<List<RelatedUniqueData>> delete(
    _is.DatabaseSession session,
    List<RelatedUniqueData> rows, {
    _is.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    _is.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RelatedUniqueData>(
      rows,
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RelatedUniqueData].
  Future<RelatedUniqueData> deleteRow(
    _is.DatabaseSession session,
    RelatedUniqueData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RelatedUniqueData>(
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
  Future<List<RelatedUniqueData>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RelatedUniqueDataTable> where,
    _is.OrderByBuilder<RelatedUniqueDataTable>? orderBy,
    _is.OrderByListBuilder<RelatedUniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RelatedUniqueData>(
      where: where(RelatedUniqueData.t),
      orderBy: orderBy?.call(RelatedUniqueData.t),
      orderByList: orderByList?.call(RelatedUniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RelatedUniqueDataTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RelatedUniqueData>(
      where: where?.call(RelatedUniqueData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RelatedUniqueData] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RelatedUniqueDataTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RelatedUniqueData>(
      where: where(RelatedUniqueData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RelatedUniqueDataAttachRowRepository {
  const RelatedUniqueDataAttachRowRepository._();

  /// Creates a relation between the given [RelatedUniqueData] and [UniqueData]
  /// by setting the [RelatedUniqueData]'s foreign key `uniqueDataId` to refer to the [UniqueData].
  Future<void> uniqueData(
    _is.DatabaseSession session,
    RelatedUniqueData relatedUniqueData,
    _iufhyrjh.UniqueData uniqueData, {
    _is.Transaction? transaction,
  }) async {
    if (relatedUniqueData.id == null) {
      throw ArgumentError.notNull('relatedUniqueData.id');
    }
    if (uniqueData.id == null) {
      throw ArgumentError.notNull('uniqueData.id');
    }

    var $relatedUniqueData = relatedUniqueData.copyWith(
      uniqueDataId: uniqueData.id,
    );
    await session.db.updateRow<RelatedUniqueData>(
      $relatedUniqueData,
      columns: [RelatedUniqueData.t.uniqueDataId],
      transaction: transaction,
    );
  }
}
