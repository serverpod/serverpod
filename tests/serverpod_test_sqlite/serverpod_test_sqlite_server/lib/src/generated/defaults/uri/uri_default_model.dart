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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UriDefaultModel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UriDefaultModel._({
    this.id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  }) : uriDefaultModel =
           uriDefaultModel ?? Uri.parse('https://serverpod.dev/defaultModel'),
       uriDefaultModelNull =
           uriDefaultModelNull ??
           Uri.parse('https://serverpod.dev/defaultModel');

  factory UriDefaultModel({
    int? id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  }) = _UriDefaultModelImpl;

  factory UriDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefaultModel(
      id: jsonSerialization['id'] as int?,
      uriDefaultModel: jsonSerialization['uriDefaultModel'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(jsonSerialization['uriDefaultModel']),
      uriDefaultModelNull: jsonSerialization['uriDefaultModelNull'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(
              jsonSerialization['uriDefaultModelNull'],
            ),
    );
  }

  static final t = UriDefaultModelTable();

  static const db = UriDefaultModelRepository._();

  @override
  int? id;

  Uri uriDefaultModel;

  Uri? uriDefaultModelNull;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UriDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefaultModel copyWith({
    int? id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UriDefaultModel',
      if (id != null) 'id': id,
      'uriDefaultModel': uriDefaultModel.toJson(),
      if (uriDefaultModelNull != null)
        'uriDefaultModelNull': uriDefaultModelNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UriDefaultModel',
      if (id != null) 'id': id,
      'uriDefaultModel': uriDefaultModel.toJson(),
      if (uriDefaultModelNull != null)
        'uriDefaultModelNull': uriDefaultModelNull?.toJson(),
    };
  }

  static UriDefaultModelInclude include() {
    return UriDefaultModelInclude._();
  }

  static UriDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<UriDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultModelTable>? orderByList,
    UriDefaultModelInclude? include,
  }) {
    return UriDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(UriDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultModelImpl extends UriDefaultModel {
  _UriDefaultModelImpl({
    int? id,
    Uri? uriDefaultModel,
    Uri? uriDefaultModelNull,
  }) : super._(
         id: id,
         uriDefaultModel: uriDefaultModel,
         uriDefaultModelNull: uriDefaultModelNull,
       );

  /// Returns a shallow copy of this [UriDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefaultModel copyWith({
    Object? id = _Undefined,
    Uri? uriDefaultModel,
    Object? uriDefaultModelNull = _Undefined,
  }) {
    return UriDefaultModel(
      id: id is int? ? id : this.id,
      uriDefaultModel: uriDefaultModel ?? this.uriDefaultModel,
      uriDefaultModelNull: uriDefaultModelNull is Uri?
          ? uriDefaultModelNull
          : this.uriDefaultModelNull,
    );
  }
}

class UriDefaultModelUpdateTable extends _i1.UpdateTable<UriDefaultModelTable> {
  UriDefaultModelUpdateTable(super.table);

  _i1.ColumnValue<Uri, Uri> uriDefaultModel(Uri value) => _i1.ColumnValue(
    table.uriDefaultModel,
    value,
  );

  _i1.ColumnValue<Uri, Uri> uriDefaultModelNull(Uri? value) => _i1.ColumnValue(
    table.uriDefaultModelNull,
    value,
  );
}

class UriDefaultModelTable extends _i1.Table<int?> {
  UriDefaultModelTable({super.tableRelation})
    : super(tableName: 'uri_default_model') {
    updateTable = UriDefaultModelUpdateTable(this);
    uriDefaultModel = _i1.ColumnUri(
      'uriDefaultModel',
      this,
    );
    uriDefaultModelNull = _i1.ColumnUri(
      'uriDefaultModelNull',
      this,
    );
  }

  late final UriDefaultModelUpdateTable updateTable;

  late final _i1.ColumnUri uriDefaultModel;

  late final _i1.ColumnUri uriDefaultModelNull;

  @override
  List<_i1.Column> get columns => [
    id,
    uriDefaultModel,
    uriDefaultModelNull,
  ];
}

class UriDefaultModelInclude extends _i1.IncludeObject {
  UriDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UriDefaultModel.t;
}

class UriDefaultModelIncludeList extends _i1.IncludeList {
  UriDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<UriDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UriDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UriDefaultModel.t;
}

class UriDefaultModelRepository {
  const UriDefaultModelRepository._();

  /// Returns a list of [UriDefaultModel]s matching the given query parameters.
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
  Future<List<UriDefaultModel>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UriDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UriDefaultModel>(
      where: where?.call(UriDefaultModel.t),
      orderBy: orderBy?.call(UriDefaultModel.t),
      orderByList: orderByList?.call(UriDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UriDefaultModel] matching the given query parameters.
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
  Future<UriDefaultModel?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UriDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<UriDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UriDefaultModel>(
      where: where?.call(UriDefaultModel.t),
      orderBy: orderBy?.call(UriDefaultModel.t),
      orderByList: orderByList?.call(UriDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UriDefaultModel] by its [id] or null if no such row exists.
  Future<UriDefaultModel?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UriDefaultModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UriDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [UriDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UriDefaultModel>> insert(
    _i1.DatabaseSession session,
    List<UriDefaultModel> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UriDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UriDefaultModel] and returns the inserted row.
  ///
  /// The returned [UriDefaultModel] will have its `id` field set.
  Future<UriDefaultModel> insertRow(
    _i1.DatabaseSession session,
    UriDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UriDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UriDefaultModel]s in the list and returns the resulting rows.
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
  /// The returned [UriDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  Future<List<UriDefaultModel>> upsert(
    _i1.DatabaseSession session,
    List<UriDefaultModel> rows, {
    required _i1.ColumnSelections<UriDefaultModelTable> conflictColumns,
    _i1.ColumnSelections<UriDefaultModelTable>? updateColumns,
    _i1.WhereExpressionBuilder<UriDefaultModelTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsert<UriDefaultModel>(
      rows,
      conflictColumns: conflictColumns(UriDefaultModel.t),
      updateColumns: updateColumns?.call(UriDefaultModel.t),
      updateWhere: updateWhere?.call(UriDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Upserts a single [UriDefaultModel] and returns the resulting row.
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
  /// The returned [UriDefaultModel] will have its `id` field set.
  Future<UriDefaultModel?> upsertRow(
    _i1.DatabaseSession session,
    UriDefaultModel row, {
    required _i1.ColumnSelections<UriDefaultModelTable> conflictColumns,
    _i1.ColumnSelections<UriDefaultModelTable>? updateColumns,
    _i1.WhereExpressionBuilder<UriDefaultModelTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UriDefaultModel>(
      row,
      conflictColumns: conflictColumns(UriDefaultModel.t),
      updateColumns: updateColumns?.call(UriDefaultModel.t),
      updateWhere: updateWhere?.call(UriDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UriDefaultModel>> update(
    _i1.DatabaseSession session,
    List<UriDefaultModel> rows, {
    _i1.ColumnSelections<UriDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UriDefaultModel>(
      rows,
      columns: columns?.call(UriDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UriDefaultModel> updateRow(
    _i1.DatabaseSession session,
    UriDefaultModel row, {
    _i1.ColumnSelections<UriDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UriDefaultModel>(
      row,
      columns: columns?.call(UriDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UriDefaultModel?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UriDefaultModelUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UriDefaultModel>(
      id,
      columnValues: columnValues(UriDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UriDefaultModel>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UriDefaultModelUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UriDefaultModelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UriDefaultModelTable>? orderBy,
    _i1.OrderByListBuilder<UriDefaultModelTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UriDefaultModel>(
      columnValues: columnValues(UriDefaultModel.t.updateTable),
      where: where(UriDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultModel.t),
      orderByList: orderByList?.call(UriDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UriDefaultModel]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UriDefaultModel>> delete(
    _i1.DatabaseSession session,
    List<UriDefaultModel> rows, {
    _i1.OrderByBuilder<UriDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UriDefaultModel>(
      rows,
      orderBy: orderBy?.call(UriDefaultModel.t),
      orderByList: orderByList?.call(UriDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [UriDefaultModel].
  Future<UriDefaultModel> deleteRow(
    _i1.DatabaseSession session,
    UriDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UriDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<UriDefaultModel>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UriDefaultModelTable> where,
    _i1.OrderByBuilder<UriDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UriDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UriDefaultModel>(
      where: where(UriDefaultModel.t),
      orderBy: orderBy?.call(UriDefaultModel.t),
      orderByList: orderByList?.call(UriDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UriDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UriDefaultModel>(
      where: where?.call(UriDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UriDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UriDefaultModelTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UriDefaultModel>(
      where: where(UriDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
