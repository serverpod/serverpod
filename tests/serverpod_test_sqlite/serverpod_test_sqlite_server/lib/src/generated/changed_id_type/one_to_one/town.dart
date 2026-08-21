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
import '../../changed_id_type/one_to_one/citizen.dart' as _i7hzilwf;

abstract class TownInt
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TownInt._({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory TownInt({
    int? id,
    required String name,
    int? mayorId,
    _i7hzilwf.CitizenInt? mayor,
  }) = _TownIntImpl;

  factory TownInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return TownInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      mayorId: jsonSerialization['mayorId'] as int?,
      mayor: jsonSerialization['mayor'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_i7hzilwf.CitizenInt>(
              jsonSerialization['mayor'],
            ),
    );
  }

  static final t = TownIntTable();

  static const db = TownIntRepository._();

  @override
  int? id;

  String name;

  int? mayorId;

  _i7hzilwf.CitizenInt? mayor;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TownInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TownInt copyWith({
    int? id,
    String? name,
    int? mayorId,
    _i7hzilwf.CitizenInt? mayor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TownInt',
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TownInt',
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJsonForProtocol(),
    };
  }

  static TownIntInclude include({_i7hzilwf.CitizenIntInclude? mayor}) {
    return TownIntInclude._(mayor: mayor);
  }

  static TownIntIncludeList includeList({
    _is.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TownIntTable>? orderBy,
    _is.OrderByListBuilder<TownIntTable>? orderByList,
    TownIntInclude? include,
  }) {
    return TownIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TownIntImpl extends TownInt {
  _TownIntImpl({
    int? id,
    required String name,
    int? mayorId,
    _i7hzilwf.CitizenInt? mayor,
  }) : super._(
         id: id,
         name: name,
         mayorId: mayorId,
         mayor: mayor,
       );

  /// Returns a shallow copy of this [TownInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TownInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return TownInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _i7hzilwf.CitizenInt? ? mayor : this.mayor?.copyWith(),
    );
  }
}

class TownIntUpdateTable extends _is.UpdateTable<TownIntTable> {
  TownIntUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> mayorId(int? value) => _is.ColumnValue(
    table.mayorId,
    value,
  );
}

class TownIntTable extends _is.Table<int?> {
  TownIntTable({super.tableRelation}) : super(tableName: 'town_int') {
    updateTable = TownIntUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    mayorId = _is.ColumnInt(
      'mayorId',
      this,
    );
  }

  late final TownIntUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt mayorId;

  _i7hzilwf.CitizenIntTable? _mayor;

  _i7hzilwf.CitizenIntTable get mayor {
    if (_mayor != null) return _mayor!;
    _mayor = _is.createRelationTable(
      relationFieldName: 'mayor',
      field: TownInt.t.mayorId,
      foreignField: _i7hzilwf.CitizenInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i7hzilwf.CitizenIntTable(tableRelation: foreignTableRelation),
    );
    return _mayor!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    mayorId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'mayor') {
      return mayor;
    }
    return null;
  }
}

class TownIntInclude extends _is.IncludeObject {
  TownIntInclude._({_i7hzilwf.CitizenIntInclude? mayor}) {
    _mayor = mayor;
  }

  _i7hzilwf.CitizenIntInclude? _mayor;

  @override
  Map<String, _is.Include?> get includes => {'mayor': _mayor};

  @override
  _is.Table<int?> get table => TownInt.t;
}

class TownIntIncludeList extends _is.IncludeList {
  TownIntIncludeList._({
    _is.WhereExpressionBuilder<TownIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TownInt.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TownInt.t;
}

class TownIntRepository {
  const TownIntRepository._();

  final attachRow = const TownIntAttachRowRepository._();

  final detachRow = const TownIntDetachRowRepository._();

  /// Returns a list of [TownInt]s matching the given query parameters.
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
  Future<List<TownInt>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TownIntTable>? orderBy,
    _is.OrderByListBuilder<TownIntTable>? orderByList,
    _is.Transaction? transaction,
    TownIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TownInt>(
      where: where?.call(TownInt.t),
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TownInt] matching the given query parameters.
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
  Future<TownInt?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TownIntTable>? where,
    int? offset,
    _is.OrderByBuilder<TownIntTable>? orderBy,
    _is.OrderByListBuilder<TownIntTable>? orderByList,
    _is.Transaction? transaction,
    TownIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TownInt>(
      where: where?.call(TownInt.t),
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TownInt] by its [id] or null if no such row exists.
  Future<TownInt?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    TownIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TownInt>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TownInt]s in the list and returns the inserted rows.
  ///
  /// The returned [TownInt]s will have their `id` fields set.
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
  Future<List<TownInt>> insert(
    _is.DatabaseSession session,
    List<TownInt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TownInt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TownInt] and returns the inserted row.
  ///
  /// The returned [TownInt] will have its `id` field set.
  Future<TownInt> insertRow(
    _is.DatabaseSession session,
    TownInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TownInt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TownInt]s in the list and returns the resulting rows.
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
  /// The returned [TownInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TownInt>> upsert(
    _is.DatabaseSession session,
    List<TownInt> rows, {
    required _is.ColumnSelections<TownIntTable> conflictColumns,
    _is.ColumnSelections<TownIntTable>? updateColumns,
    _is.WhereExpressionBuilder<TownIntTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TownInt>(
      rows,
      conflictColumns: conflictColumns(TownInt.t),
      updateColumns: updateColumns?.call(TownInt.t),
      updateWhere: updateWhere?.call(TownInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TownInt] and returns the resulting row.
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
  /// The returned [TownInt] will have its `id` field set.
  Future<TownInt?> upsertRow(
    _is.DatabaseSession session,
    TownInt row, {
    required _is.ColumnSelections<TownIntTable> conflictColumns,
    _is.ColumnSelections<TownIntTable>? updateColumns,
    _is.WhereExpressionBuilder<TownIntTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TownInt>(
      row,
      conflictColumns: conflictColumns(TownInt.t),
      updateColumns: updateColumns?.call(TownInt.t),
      updateWhere: updateWhere?.call(TownInt.t),
      transaction: transaction,
    );
  }

  /// Updates all [TownInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TownInt>> update(
    _is.DatabaseSession session,
    List<TownInt> rows, {
    _is.ColumnSelections<TownIntTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TownInt>(
      rows,
      columns: columns?.call(TownInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TownInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TownInt> updateRow(
    _is.DatabaseSession session,
    TownInt row, {
    _is.ColumnSelections<TownIntTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TownInt>(
      row,
      columns: columns?.call(TownInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TownInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TownInt?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TownIntUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TownInt>(
      id,
      columnValues: columnValues(TownInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TownInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TownInt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TownIntUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TownIntTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TownIntTable>? orderBy,
    _is.OrderByListBuilder<TownIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TownInt>(
      columnValues: columnValues(TownInt.t.updateTable),
      where: where(TownInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TownInt]s in the list and returns the deleted rows.
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
  Future<List<TownInt>> delete(
    _is.DatabaseSession session,
    List<TownInt> rows, {
    _is.OrderByBuilder<TownIntTable>? orderBy,
    _is.OrderByListBuilder<TownIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TownInt>(
      rows,
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TownInt].
  Future<TownInt> deleteRow(
    _is.DatabaseSession session,
    TownInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TownInt>(
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
  Future<List<TownInt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TownIntTable> where,
    _is.OrderByBuilder<TownIntTable>? orderBy,
    _is.OrderByListBuilder<TownIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TownInt>(
      where: where(TownInt.t),
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TownInt>(
      where: where?.call(TownInt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TownInt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TownIntTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TownInt>(
      where: where(TownInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class TownIntAttachRowRepository {
  const TownIntAttachRowRepository._();

  /// Creates a relation between the given [TownInt] and [CitizenInt]
  /// by setting the [TownInt]'s foreign key `mayorId` to refer to the [CitizenInt].
  Future<void> mayor(
    _is.DatabaseSession session,
    TownInt townInt,
    _i7hzilwf.CitizenInt mayor, {
    _is.Transaction? transaction,
  }) async {
    if (townInt.id == null) {
      throw ArgumentError.notNull('townInt.id');
    }
    if (mayor.id == null) {
      throw ArgumentError.notNull('mayor.id');
    }

    var $townInt = townInt.copyWith(mayorId: mayor.id);
    await session.db.updateRow<TownInt>(
      $townInt,
      columns: [TownInt.t.mayorId],
      transaction: transaction,
    );
  }
}

class TownIntDetachRowRepository {
  const TownIntDetachRowRepository._();

  /// Detaches the relation between this [TownInt] and the [CitizenInt] set in `mayor`
  /// by setting the [TownInt]'s foreign key `mayorId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> mayor(
    _is.DatabaseSession session,
    TownInt townInt, {
    _is.Transaction? transaction,
  }) async {
    if (townInt.id == null) {
      throw ArgumentError.notNull('townInt.id');
    }

    var $townInt = townInt.copyWith(mayorId: null);
    await session.db.updateRow<TownInt>(
      $townInt,
      columns: [TownInt.t.mayorId],
      transaction: transaction,
    );
  }
}
