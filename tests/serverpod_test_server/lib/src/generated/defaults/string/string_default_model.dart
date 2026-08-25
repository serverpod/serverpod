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

abstract class StringDefaultModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StringDefaultModel._({
    this.id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) : stringDefaultModel =
           stringDefaultModel ?? 'This is a default model value',
       stringDefaultModelNull =
           stringDefaultModelNull ?? 'This is a default model null value';

  factory StringDefaultModel({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) = _StringDefaultModelImpl;

  factory StringDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefaultModel(
      id: jsonSerialization['id'] as int?,
      stringDefaultModel: jsonSerialization['stringDefaultModel'] as String?,
      stringDefaultModelNull:
          jsonSerialization['stringDefaultModelNull'] as String?,
    );
  }

  static final t = StringDefaultModelTable();

  static const db = StringDefaultModelRepository._();

  @override
  int? id;

  String stringDefaultModel;

  String stringDefaultModelNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StringDefaultModel copyWith({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StringDefaultModel',
      if (id != null) 'id': id,
      'stringDefaultModel': stringDefaultModel,
      'stringDefaultModelNull': stringDefaultModelNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StringDefaultModel',
      if (id != null) 'id': id,
      'stringDefaultModel': stringDefaultModel,
      'stringDefaultModelNull': stringDefaultModelNull,
    };
  }

  static StringDefaultModelInclude include({
    _is.SelectColumnsBuilder<StringDefaultModelTable>? select,
  }) {
    return StringDefaultModelInclude._(
      selectedColumns: select?.call(StringDefaultModel.t),
    );
  }

  static StringDefaultModelIncludeList includeList({
    _is.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    StringDefaultModelInclude? include,
    _is.SelectColumnsBuilder<StringDefaultModelTable>? select,
  }) {
    return StringDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      include: include,
      selectedColumns: select?.call(StringDefaultModel.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultModelImpl extends StringDefaultModel {
  _StringDefaultModelImpl({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) : super._(
         id: id,
         stringDefaultModel: stringDefaultModel,
         stringDefaultModelNull: stringDefaultModelNull,
       );

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StringDefaultModel copyWith({
    Object? id = _Undefined,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) {
    return StringDefaultModel(
      id: id is int? ? id : this.id,
      stringDefaultModel: stringDefaultModel ?? this.stringDefaultModel,
      stringDefaultModelNull:
          stringDefaultModelNull ?? this.stringDefaultModelNull,
    );
  }
}

class StringDefaultModelUpdateTable
    extends _is.UpdateTable<StringDefaultModelTable> {
  StringDefaultModelUpdateTable(super.table);

  _is.ColumnValue<String, String> stringDefaultModel(String value) =>
      _is.ColumnValue(
        table.stringDefaultModel,
        value,
      );

  _is.ColumnValue<String, String> stringDefaultModelNull(String value) =>
      _is.ColumnValue(
        table.stringDefaultModelNull,
        value,
      );
}

class StringDefaultModelTable extends _is.Table<int?> {
  StringDefaultModelTable({super.tableRelation})
    : super(tableName: 'string_default_model') {
    updateTable = StringDefaultModelUpdateTable(this);
    stringDefaultModel = _is.ColumnString(
      'stringDefaultModel',
      this,
    );
    stringDefaultModelNull = _is.ColumnString(
      'stringDefaultModelNull',
      this,
    );
  }

  late final StringDefaultModelUpdateTable updateTable;

  late final _is.ColumnString stringDefaultModel;

  late final _is.ColumnString stringDefaultModelNull;

  @override
  List<_is.Column> get columns => [
    id,
    stringDefaultModel,
    stringDefaultModelNull,
  ];
}

class StringDefaultModelInclude extends _is.IncludeObject {
  StringDefaultModelInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StringDefaultModel.t;
}

class StringDefaultModelIncludeList extends _is.IncludeList {
  StringDefaultModelIncludeList._({
    _is.WhereExpressionBuilder<StringDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(StringDefaultModel.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StringDefaultModel.t;
}

class StringDefaultModelRepository {
  const StringDefaultModelRepository._();

  /// Returns a list of [StringDefaultModel]s matching the given query parameters.
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
  Future<List<StringDefaultModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StringDefaultModel] matching the given query parameters.
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
  Future<StringDefaultModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StringDefaultModel] by its [id] or null if no such row exists.
  Future<StringDefaultModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StringDefaultModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<StringDefaultModel>(
      id,
      transaction: transaction,
      select: select?.call(StringDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StringDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [StringDefaultModel]s will have their `id` fields set.
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
  Future<List<StringDefaultModel>> insert(
    _is.DatabaseSession session,
    List<StringDefaultModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StringDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StringDefaultModel] and returns the inserted row.
  ///
  /// The returned [StringDefaultModel] will have its `id` field set.
  Future<StringDefaultModel> insertRow(
    _is.DatabaseSession session,
    StringDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StringDefaultModel]s in the list and returns the resulting rows.
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
  /// The returned [StringDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultModel>> upsert(
    _is.DatabaseSession session,
    List<StringDefaultModel> rows, {
    required _is.ColumnSelections<StringDefaultModelTable> conflictColumns,
    _is.ColumnSelections<StringDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StringDefaultModel>(
      rows,
      conflictColumns: conflictColumns(StringDefaultModel.t),
      updateColumns: updateColumns?.call(StringDefaultModel.t),
      updateWhere: updateWhere?.call(StringDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StringDefaultModel] and returns the resulting row.
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
  /// The returned [StringDefaultModel] will have its `id` field set.
  Future<StringDefaultModel?> upsertRow(
    _is.DatabaseSession session,
    StringDefaultModel row, {
    required _is.ColumnSelections<StringDefaultModelTable> conflictColumns,
    _is.ColumnSelections<StringDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StringDefaultModel>(
      row,
      conflictColumns: conflictColumns(StringDefaultModel.t),
      updateColumns: updateColumns?.call(StringDefaultModel.t),
      updateWhere: updateWhere?.call(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultModel>> update(
    _is.DatabaseSession session,
    List<StringDefaultModel> rows, {
    _is.ColumnSelections<StringDefaultModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StringDefaultModel>(
      rows,
      columns: columns?.call(StringDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StringDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StringDefaultModel> updateRow(
    _is.DatabaseSession session,
    StringDefaultModel row, {
    _is.ColumnSelections<StringDefaultModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefaultModel>(
      row,
      columns: columns?.call(StringDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StringDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StringDefaultModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StringDefaultModelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StringDefaultModel>(
      id,
      columnValues: columnValues(StringDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StringDefaultModelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<StringDefaultModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StringDefaultModel>(
      columnValues: columnValues(StringDefaultModel.t.updateTable),
      where: where(StringDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StringDefaultModel]s in the list and returns the deleted rows.
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
  Future<List<StringDefaultModel>> delete(
    _is.DatabaseSession session,
    List<StringDefaultModel> rows, {
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StringDefaultModel>(
      rows,
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StringDefaultModel].
  Future<StringDefaultModel> deleteRow(
    _is.DatabaseSession session,
    StringDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefaultModel>(
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
  Future<List<StringDefaultModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultModelTable> where,
    _is.OrderByBuilder<StringDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StringDefaultModel>(
      where: where(StringDefaultModel.t),
      orderBy: orderBy?.call(StringDefaultModel.t),
      orderByList: orderByList?.call(StringDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StringDefaultModel>(
      where: where?.call(StringDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StringDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StringDefaultModel>(
      where: where(StringDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
