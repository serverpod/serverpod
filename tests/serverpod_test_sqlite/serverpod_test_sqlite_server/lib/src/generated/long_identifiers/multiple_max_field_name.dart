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

abstract class MultipleMaxFieldName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MultipleMaxFieldName._({
    this.id,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) : _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId = null;

  factory MultipleMaxFieldName({
    int? id,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) = _MultipleMaxFieldNameImpl;

  factory MultipleMaxFieldName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MultipleMaxFieldNameImplicit._(
      id: jsonSerialization['id'] as int?,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          jsonSerialization['thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1']
              as String,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          jsonSerialization['thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2']
              as String,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
          jsonSerialization['_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId']
              as int?,
    );
  }

  static final t = MultipleMaxFieldNameTable();

  static const db = MultipleMaxFieldNameRepository._();

  @override
  int? id;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2;

  final int? _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MultipleMaxFieldName copyWith({
    int? id,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MultipleMaxFieldName',
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
      if (_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId !=
          null)
        '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId':
            _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MultipleMaxFieldName',
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    };
  }

  static MultipleMaxFieldNameInclude include() {
    return MultipleMaxFieldNameInclude._();
  }

  static MultipleMaxFieldNameIncludeList includeList({
    _is.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    MultipleMaxFieldNameInclude? include,
  }) {
    return MultipleMaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MultipleMaxFieldNameImpl extends MultipleMaxFieldName {
  _MultipleMaxFieldNameImpl({
    int? id,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) : super._(
         id: id,
         thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
             thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
         thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
             thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
       );

  /// Returns a shallow copy of this [MultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  }) {
    return MultipleMaxFieldNameImplicit._(
      id: id is int? ? id : this.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1 ??
          this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2 ??
          this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
          this._relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
    );
  }
}

class MultipleMaxFieldNameImplicit extends _MultipleMaxFieldNameImpl {
  MultipleMaxFieldNameImplicit._({
    int? id,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    int? $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
  }) : _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId =
           $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
       super(
         id: id,
         thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
             thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
         thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
             thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
       );

  factory MultipleMaxFieldNameImplicit(
    MultipleMaxFieldName multipleMaxFieldName, {
    int? $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
  }) {
    return MultipleMaxFieldNameImplicit._(
      id: multipleMaxFieldName.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1:
          multipleMaxFieldName
              .thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2:
          multipleMaxFieldName
              .thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
          $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
    );
  }

  @override
  final int? _relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId;
}

class MultipleMaxFieldNameUpdateTable
    extends _is.UpdateTable<MultipleMaxFieldNameTable> {
  MultipleMaxFieldNameUpdateTable(super.table);

  _is.ColumnValue<String, String>
  thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1(String value) =>
      _is.ColumnValue(
        table.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
        value,
      );

  _is.ColumnValue<String, String>
  thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2(String value) =>
      _is.ColumnValue(
        table.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
        value,
      );

  _is.ColumnValue<int, int>
  $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId(
    int? value,
  ) => _is.ColumnValue(
    table.$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
    value,
  );
}

class MultipleMaxFieldNameTable extends _is.Table<int?> {
  MultipleMaxFieldNameTable({super.tableRelation})
    : super(tableName: 'multiple_max_field_name') {
    updateTable = MultipleMaxFieldNameUpdateTable(this);
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1 =
        _is.ColumnString(
          'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1',
          this,
        );
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2 =
        _is.ColumnString(
          'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2',
          this,
        );
    $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId =
        _is.ColumnInt(
          '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId',
          this,
        );
  }

  late final MultipleMaxFieldNameUpdateTable updateTable;

  late final _is.ColumnString
  thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1;

  late final _is.ColumnString
  thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2;

  late final _is.ColumnInt
  $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId;

  @override
  List<_is.Column> get columns => [
    id,
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
    $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
  ];

  @override
  List<_is.Column> get managedColumns => [
    id,
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1,
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2,
  ];
}

class MultipleMaxFieldNameInclude extends _is.IncludeObject {
  MultipleMaxFieldNameInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MultipleMaxFieldName.t;
}

class MultipleMaxFieldNameIncludeList extends _is.IncludeList {
  MultipleMaxFieldNameIncludeList._({
    _is.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MultipleMaxFieldName.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MultipleMaxFieldName.t;
}

class MultipleMaxFieldNameRepository {
  const MultipleMaxFieldNameRepository._();

  /// Returns a list of [MultipleMaxFieldName]s matching the given query parameters.
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
  Future<List<MultipleMaxFieldName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MultipleMaxFieldName>(
      where: where?.call(MultipleMaxFieldName.t),
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MultipleMaxFieldName] matching the given query parameters.
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
  Future<MultipleMaxFieldName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? offset,
    _is.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MultipleMaxFieldName>(
      where: where?.call(MultipleMaxFieldName.t),
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MultipleMaxFieldName] by its [id] or null if no such row exists.
  Future<MultipleMaxFieldName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MultipleMaxFieldName>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MultipleMaxFieldName]s in the list and returns the inserted rows.
  ///
  /// The returned [MultipleMaxFieldName]s will have their `id` fields set.
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
  Future<List<MultipleMaxFieldName>> insert(
    _is.DatabaseSession session,
    List<MultipleMaxFieldName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MultipleMaxFieldName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MultipleMaxFieldName] and returns the inserted row.
  ///
  /// The returned [MultipleMaxFieldName] will have its `id` field set.
  Future<MultipleMaxFieldName> insertRow(
    _is.DatabaseSession session,
    MultipleMaxFieldName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MultipleMaxFieldName]s in the list and returns the resulting rows.
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
  /// The returned [MultipleMaxFieldName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MultipleMaxFieldName>> upsert(
    _is.DatabaseSession session,
    List<MultipleMaxFieldName> rows, {
    required _is.ColumnSelections<MultipleMaxFieldNameTable> conflictColumns,
    _is.ColumnSelections<MultipleMaxFieldNameTable>? updateColumns,
    _is.WhereExpressionBuilder<MultipleMaxFieldNameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MultipleMaxFieldName>(
      rows,
      conflictColumns: conflictColumns(MultipleMaxFieldName.t),
      updateColumns: updateColumns?.call(MultipleMaxFieldName.t),
      updateWhere: updateWhere?.call(MultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MultipleMaxFieldName] and returns the resulting row.
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
  /// The returned [MultipleMaxFieldName] will have its `id` field set.
  Future<MultipleMaxFieldName?> upsertRow(
    _is.DatabaseSession session,
    MultipleMaxFieldName row, {
    required _is.ColumnSelections<MultipleMaxFieldNameTable> conflictColumns,
    _is.ColumnSelections<MultipleMaxFieldNameTable>? updateColumns,
    _is.WhereExpressionBuilder<MultipleMaxFieldNameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MultipleMaxFieldName>(
      row,
      conflictColumns: conflictColumns(MultipleMaxFieldName.t),
      updateColumns: updateColumns?.call(MultipleMaxFieldName.t),
      updateWhere: updateWhere?.call(MultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates all [MultipleMaxFieldName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MultipleMaxFieldName>> update(
    _is.DatabaseSession session,
    List<MultipleMaxFieldName> rows, {
    _is.ColumnSelections<MultipleMaxFieldNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MultipleMaxFieldName>(
      rows,
      columns: columns?.call(MultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MultipleMaxFieldName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MultipleMaxFieldName> updateRow(
    _is.DatabaseSession session,
    MultipleMaxFieldName row, {
    _is.ColumnSelections<MultipleMaxFieldNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MultipleMaxFieldName>(
      row,
      columns: columns?.call(MultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MultipleMaxFieldName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MultipleMaxFieldName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MultipleMaxFieldNameUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MultipleMaxFieldName>(
      id,
      columnValues: columnValues(MultipleMaxFieldName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MultipleMaxFieldName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MultipleMaxFieldName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MultipleMaxFieldNameUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<MultipleMaxFieldNameTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MultipleMaxFieldName>(
      columnValues: columnValues(MultipleMaxFieldName.t.updateTable),
      where: where(MultipleMaxFieldName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MultipleMaxFieldName]s in the list and returns the deleted rows.
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
  Future<List<MultipleMaxFieldName>> delete(
    _is.DatabaseSession session,
    List<MultipleMaxFieldName> rows, {
    _is.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MultipleMaxFieldName>(
      rows,
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MultipleMaxFieldName].
  Future<MultipleMaxFieldName> deleteRow(
    _is.DatabaseSession session,
    MultipleMaxFieldName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MultipleMaxFieldName>(
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
  Future<List<MultipleMaxFieldName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MultipleMaxFieldNameTable> where,
    _is.OrderByBuilder<MultipleMaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MultipleMaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MultipleMaxFieldName>(
      where: where(MultipleMaxFieldName.t),
      orderBy: orderBy?.call(MultipleMaxFieldName.t),
      orderByList: orderByList?.call(MultipleMaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MultipleMaxFieldNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MultipleMaxFieldName>(
      where: where?.call(MultipleMaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MultipleMaxFieldName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MultipleMaxFieldNameTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MultipleMaxFieldName>(
      where: where(MultipleMaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
