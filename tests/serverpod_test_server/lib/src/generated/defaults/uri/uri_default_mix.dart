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

abstract class UriDefaultMix
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UriDefaultMix._({
    this.id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) : uriDefaultAndDefaultModel =
           uriDefaultAndDefaultModel ??
           Uri.parse('https://serverpod.dev/defaultModel'),
       uriDefaultAndDefaultPersist =
           uriDefaultAndDefaultPersist ??
           Uri.parse('https://serverpod.dev/default'),
       uriDefaultModelAndDefaultPersist =
           uriDefaultModelAndDefaultPersist ??
           Uri.parse('https://serverpod.dev/defaultModel');

  factory UriDefaultMix({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) = _UriDefaultMixImpl;

  factory UriDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefaultMix(
      id: jsonSerialization['id'] as int?,
      uriDefaultAndDefaultModel:
          jsonSerialization['uriDefaultAndDefaultModel'] == null
          ? null
          : _is.UriJsonExtension.fromJson(
              jsonSerialization['uriDefaultAndDefaultModel'],
            ),
      uriDefaultAndDefaultPersist:
          jsonSerialization['uriDefaultAndDefaultPersist'] == null
          ? null
          : _is.UriJsonExtension.fromJson(
              jsonSerialization['uriDefaultAndDefaultPersist'],
            ),
      uriDefaultModelAndDefaultPersist:
          jsonSerialization['uriDefaultModelAndDefaultPersist'] == null
          ? null
          : _is.UriJsonExtension.fromJson(
              jsonSerialization['uriDefaultModelAndDefaultPersist'],
            ),
    );
  }

  static final t = UriDefaultMixTable();

  static const db = UriDefaultMixRepository._();

  @override
  int? id;

  Uri uriDefaultAndDefaultModel;

  Uri uriDefaultAndDefaultPersist;

  Uri uriDefaultModelAndDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UriDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UriDefaultMix copyWith({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UriDefaultMix',
      if (id != null) 'id': id,
      'uriDefaultAndDefaultModel': uriDefaultAndDefaultModel.toJson(),
      'uriDefaultAndDefaultPersist': uriDefaultAndDefaultPersist.toJson(),
      'uriDefaultModelAndDefaultPersist': uriDefaultModelAndDefaultPersist
          .toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UriDefaultMix',
      if (id != null) 'id': id,
      'uriDefaultAndDefaultModel': uriDefaultAndDefaultModel.toJson(),
      'uriDefaultAndDefaultPersist': uriDefaultAndDefaultPersist.toJson(),
      'uriDefaultModelAndDefaultPersist': uriDefaultModelAndDefaultPersist
          .toJson(),
    };
  }

  static UriDefaultMixInclude include({
    _is.SelectColumnsBuilder<UriDefaultMixTable>? select,
  }) {
    return UriDefaultMixInclude._(
      selectedColumns: select?.call(UriDefaultMix.t),
    );
  }

  static UriDefaultMixIncludeList includeList({
    _is.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    UriDefaultMixInclude? include,
    _is.SelectColumnsBuilder<UriDefaultMixTable>? select,
  }) {
    return UriDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      include: include,
      selectedColumns: select?.call(UriDefaultMix.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultMixImpl extends UriDefaultMix {
  _UriDefaultMixImpl({
    int? id,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         uriDefaultAndDefaultModel: uriDefaultAndDefaultModel,
         uriDefaultAndDefaultPersist: uriDefaultAndDefaultPersist,
         uriDefaultModelAndDefaultPersist: uriDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [UriDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UriDefaultMix copyWith({
    Object? id = _Undefined,
    Uri? uriDefaultAndDefaultModel,
    Uri? uriDefaultAndDefaultPersist,
    Uri? uriDefaultModelAndDefaultPersist,
  }) {
    return UriDefaultMix(
      id: id is int? ? id : this.id,
      uriDefaultAndDefaultModel:
          uriDefaultAndDefaultModel ?? this.uriDefaultAndDefaultModel,
      uriDefaultAndDefaultPersist:
          uriDefaultAndDefaultPersist ?? this.uriDefaultAndDefaultPersist,
      uriDefaultModelAndDefaultPersist:
          uriDefaultModelAndDefaultPersist ??
          this.uriDefaultModelAndDefaultPersist,
    );
  }
}

class UriDefaultMixUpdateTable extends _is.UpdateTable<UriDefaultMixTable> {
  UriDefaultMixUpdateTable(super.table);

  _is.ColumnValue<Uri, Uri> uriDefaultAndDefaultModel(Uri value) =>
      _is.ColumnValue(
        table.uriDefaultAndDefaultModel,
        value,
      );

  _is.ColumnValue<Uri, Uri> uriDefaultAndDefaultPersist(Uri value) =>
      _is.ColumnValue(
        table.uriDefaultAndDefaultPersist,
        value,
      );

  _is.ColumnValue<Uri, Uri> uriDefaultModelAndDefaultPersist(Uri value) =>
      _is.ColumnValue(
        table.uriDefaultModelAndDefaultPersist,
        value,
      );
}

class UriDefaultMixTable extends _is.Table<int?> {
  UriDefaultMixTable({super.tableRelation})
    : super(tableName: 'uri_default_mix') {
    updateTable = UriDefaultMixUpdateTable(this);
    uriDefaultAndDefaultModel = _is.ColumnUri(
      'uriDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    uriDefaultAndDefaultPersist = _is.ColumnUri(
      'uriDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    uriDefaultModelAndDefaultPersist = _is.ColumnUri(
      'uriDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final UriDefaultMixUpdateTable updateTable;

  late final _is.ColumnUri uriDefaultAndDefaultModel;

  late final _is.ColumnUri uriDefaultAndDefaultPersist;

  late final _is.ColumnUri uriDefaultModelAndDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    uriDefaultAndDefaultModel,
    uriDefaultAndDefaultPersist,
    uriDefaultModelAndDefaultPersist,
  ];
}

class UriDefaultMixInclude extends _is.IncludeObject {
  UriDefaultMixInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UriDefaultMix.t;
}

class UriDefaultMixIncludeList extends _is.IncludeList {
  UriDefaultMixIncludeList._({
    _is.WhereExpressionBuilder<UriDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UriDefaultMix.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UriDefaultMix.t;
}

class UriDefaultMixRepository {
  const UriDefaultMixRepository._();

  /// Returns a list of [UriDefaultMix]s matching the given query parameters.
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
  Future<List<UriDefaultMix>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UriDefaultMix] matching the given query parameters.
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
  Future<UriDefaultMix?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UriDefaultMix] by its [id] or null if no such row exists.
  Future<UriDefaultMix?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UriDefaultMix>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UriDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(UriDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UriDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(UriDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UriDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UriDefaultMix>(
      id,
      transaction: transaction,
      select: select?.call(UriDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UriDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [UriDefaultMix]s will have their `id` fields set.
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
  Future<List<UriDefaultMix>> insert(
    _is.DatabaseSession session,
    List<UriDefaultMix> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UriDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UriDefaultMix] and returns the inserted row.
  ///
  /// The returned [UriDefaultMix] will have its `id` field set.
  Future<UriDefaultMix> insertRow(
    _is.DatabaseSession session,
    UriDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UriDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UriDefaultMix]s in the list and returns the resulting rows.
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
  /// The returned [UriDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UriDefaultMix>> upsert(
    _is.DatabaseSession session,
    List<UriDefaultMix> rows, {
    required _is.ColumnSelections<UriDefaultMixTable> conflictColumns,
    _is.ColumnSelections<UriDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<UriDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UriDefaultMix>(
      rows,
      conflictColumns: conflictColumns(UriDefaultMix.t),
      updateColumns: updateColumns?.call(UriDefaultMix.t),
      updateWhere: updateWhere?.call(UriDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UriDefaultMix] and returns the resulting row.
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
  /// The returned [UriDefaultMix] will have its `id` field set.
  Future<UriDefaultMix?> upsertRow(
    _is.DatabaseSession session,
    UriDefaultMix row, {
    required _is.ColumnSelections<UriDefaultMixTable> conflictColumns,
    _is.ColumnSelections<UriDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<UriDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UriDefaultMix>(
      row,
      conflictColumns: conflictColumns(UriDefaultMix.t),
      updateColumns: updateColumns?.call(UriDefaultMix.t),
      updateWhere: updateWhere?.call(UriDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UriDefaultMix>> update(
    _is.DatabaseSession session,
    List<UriDefaultMix> rows, {
    _is.ColumnSelections<UriDefaultMixTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UriDefaultMix>(
      rows,
      columns: columns?.call(UriDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UriDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UriDefaultMix> updateRow(
    _is.DatabaseSession session,
    UriDefaultMix row, {
    _is.ColumnSelections<UriDefaultMixTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UriDefaultMix>(
      row,
      columns: columns?.call(UriDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UriDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UriDefaultMix?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UriDefaultMixUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UriDefaultMix>(
      id,
      columnValues: columnValues(UriDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UriDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UriDefaultMix>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UriDefaultMixUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UriDefaultMixTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UriDefaultMix>(
      columnValues: columnValues(UriDefaultMix.t.updateTable),
      where: where(UriDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UriDefaultMix]s in the list and returns the deleted rows.
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
  Future<List<UriDefaultMix>> delete(
    _is.DatabaseSession session,
    List<UriDefaultMix> rows, {
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UriDefaultMix>(
      rows,
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UriDefaultMix].
  Future<UriDefaultMix> deleteRow(
    _is.DatabaseSession session,
    UriDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UriDefaultMix>(
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
  Future<List<UriDefaultMix>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UriDefaultMixTable> where,
    _is.OrderByBuilder<UriDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<UriDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UriDefaultMix>(
      where: where(UriDefaultMix.t),
      orderBy: orderBy?.call(UriDefaultMix.t),
      orderByList: orderByList?.call(UriDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UriDefaultMixTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UriDefaultMix>(
      where: where?.call(UriDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UriDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UriDefaultMixTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UriDefaultMix>(
      where: where(UriDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
