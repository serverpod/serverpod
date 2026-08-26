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

abstract class DoubleDefaultMix
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DoubleDefaultMix._({
    this.id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) : doubleDefaultAndDefaultModel = doubleDefaultAndDefaultModel ?? 20.5,
       doubleDefaultAndDefaultPersist = doubleDefaultAndDefaultPersist ?? 10.5,
       doubleDefaultModelAndDefaultPersist =
           doubleDefaultModelAndDefaultPersist ?? 10.5;

  factory DoubleDefaultMix({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) = _DoubleDefaultMixImpl;

  factory DoubleDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoubleDefaultMix(
      id: jsonSerialization['id'] as int?,
      doubleDefaultAndDefaultModel:
          (jsonSerialization['doubleDefaultAndDefaultModel'] as num?)
              ?.toDouble(),
      doubleDefaultAndDefaultPersist:
          (jsonSerialization['doubleDefaultAndDefaultPersist'] as num?)
              ?.toDouble(),
      doubleDefaultModelAndDefaultPersist:
          (jsonSerialization['doubleDefaultModelAndDefaultPersist'] as num?)
              ?.toDouble(),
    );
  }

  static final t = DoubleDefaultMixTable();

  static const db = DoubleDefaultMixRepository._();

  @override
  int? id;

  double doubleDefaultAndDefaultModel;

  double doubleDefaultAndDefaultPersist;

  double doubleDefaultModelAndDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DoubleDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoubleDefaultMix copyWith({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoubleDefaultMix',
      if (id != null) 'id': id,
      'doubleDefaultAndDefaultModel': doubleDefaultAndDefaultModel,
      'doubleDefaultAndDefaultPersist': doubleDefaultAndDefaultPersist,
      'doubleDefaultModelAndDefaultPersist':
          doubleDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoubleDefaultMix',
      if (id != null) 'id': id,
      'doubleDefaultAndDefaultModel': doubleDefaultAndDefaultModel,
      'doubleDefaultAndDefaultPersist': doubleDefaultAndDefaultPersist,
      'doubleDefaultModelAndDefaultPersist':
          doubleDefaultModelAndDefaultPersist,
    };
  }

  /// Builds a complete [DoubleDefaultMixInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DoubleDefaultMixInclude include() {
    return DoubleDefaultMixInclude._();
  }

  /// Builds a complete [DoubleDefaultMixIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DoubleDefaultMixIncludeList includeList({
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    DoubleDefaultMixInclude? include,
  }) {
    return DoubleDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [DoubleDefaultMixJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static DoubleDefaultMixJsonInclude includeJson({
    _is.SelectColumnsBuilder<DoubleDefaultMixTable>? select,
  }) {
    return _DoubleDefaultMixJsonInclude._(
      selectedColumns: select?.call(DoubleDefaultMix.t),
    );
  }

  /// Builds a JSON-compatible [DoubleDefaultMixJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static DoubleDefaultMixJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    DoubleDefaultMixJsonInclude? include,
    _is.SelectColumnsBuilder<DoubleDefaultMixTable>? select,
  }) {
    return _DoubleDefaultMixJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      include: include,
      selectedColumns: select?.call(DoubleDefaultMix.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoubleDefaultMixImpl extends DoubleDefaultMix {
  _DoubleDefaultMixImpl({
    int? id,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         doubleDefaultAndDefaultModel: doubleDefaultAndDefaultModel,
         doubleDefaultAndDefaultPersist: doubleDefaultAndDefaultPersist,
         doubleDefaultModelAndDefaultPersist:
             doubleDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [DoubleDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoubleDefaultMix copyWith({
    Object? id = _Undefined,
    double? doubleDefaultAndDefaultModel,
    double? doubleDefaultAndDefaultPersist,
    double? doubleDefaultModelAndDefaultPersist,
  }) {
    return DoubleDefaultMix(
      id: id is int? ? id : this.id,
      doubleDefaultAndDefaultModel:
          doubleDefaultAndDefaultModel ?? this.doubleDefaultAndDefaultModel,
      doubleDefaultAndDefaultPersist:
          doubleDefaultAndDefaultPersist ?? this.doubleDefaultAndDefaultPersist,
      doubleDefaultModelAndDefaultPersist:
          doubleDefaultModelAndDefaultPersist ??
          this.doubleDefaultModelAndDefaultPersist,
    );
  }
}

class DoubleDefaultMixUpdateTable
    extends _is.UpdateTable<DoubleDefaultMixTable> {
  DoubleDefaultMixUpdateTable(super.table);

  _is.ColumnValue<double, double> doubleDefaultAndDefaultModel(double value) =>
      _is.ColumnValue(
        table.doubleDefaultAndDefaultModel,
        value,
      );

  _is.ColumnValue<double, double> doubleDefaultAndDefaultPersist(
    double value,
  ) => _is.ColumnValue(
    table.doubleDefaultAndDefaultPersist,
    value,
  );

  _is.ColumnValue<double, double> doubleDefaultModelAndDefaultPersist(
    double value,
  ) => _is.ColumnValue(
    table.doubleDefaultModelAndDefaultPersist,
    value,
  );
}

class DoubleDefaultMixTable extends _is.Table<int?> {
  DoubleDefaultMixTable({super.tableRelation})
    : super(tableName: 'double_default_mix') {
    updateTable = DoubleDefaultMixUpdateTable(this);
    doubleDefaultAndDefaultModel = _is.ColumnDouble(
      'doubleDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    doubleDefaultAndDefaultPersist = _is.ColumnDouble(
      'doubleDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    doubleDefaultModelAndDefaultPersist = _is.ColumnDouble(
      'doubleDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final DoubleDefaultMixUpdateTable updateTable;

  late final _is.ColumnDouble doubleDefaultAndDefaultModel;

  late final _is.ColumnDouble doubleDefaultAndDefaultPersist;

  late final _is.ColumnDouble doubleDefaultModelAndDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    doubleDefaultAndDefaultModel,
    doubleDefaultAndDefaultPersist,
    doubleDefaultModelAndDefaultPersist,
  ];
}

abstract interface class DoubleDefaultMixJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class DoubleDefaultMixJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class DoubleDefaultMixInclude extends _is.IncludeObject
    implements DoubleDefaultMixJsonInclude, _is.FullModelInclude {
  DoubleDefaultMixInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoubleDefaultMix.t;
}

final class DoubleDefaultMixIncludeList extends _is.IncludeList
    implements DoubleDefaultMixJsonIncludeList, _is.FullModelInclude {
  DoubleDefaultMixIncludeList._({
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DoubleDefaultMixInclude? super.include,
  }) {
    super.where = where?.call(DoubleDefaultMix.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoubleDefaultMix.t;
}

final class _DoubleDefaultMixJsonInclude extends _is.IncludeObject
    implements DoubleDefaultMixJsonInclude {
  _DoubleDefaultMixJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoubleDefaultMix.t;
}

final class _DoubleDefaultMixJsonIncludeList extends _is.IncludeList
    implements DoubleDefaultMixJsonIncludeList {
  _DoubleDefaultMixJsonIncludeList._({
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DoubleDefaultMixJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(DoubleDefaultMix.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoubleDefaultMix.t;
}

class DoubleDefaultMixRepository {
  const DoubleDefaultMixRepository._();

  /// Returns a list of [DoubleDefaultMix]s matching the given query parameters.
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
  Future<List<DoubleDefaultMix>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DoubleDefaultMix] matching the given query parameters.
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
  Future<DoubleDefaultMix?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DoubleDefaultMix] by its [id] or null if no such row exists.
  Future<DoubleDefaultMix?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DoubleDefaultMix>(
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
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DoubleDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(DoubleDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DoubleDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(DoubleDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DoubleDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<DoubleDefaultMix>(
      id,
      transaction: transaction,
      select: select?.call(DoubleDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DoubleDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [DoubleDefaultMix]s will have their `id` fields set.
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
  Future<List<DoubleDefaultMix>> insert(
    _is.DatabaseSession session,
    List<DoubleDefaultMix> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DoubleDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DoubleDefaultMix] and returns the inserted row.
  ///
  /// The returned [DoubleDefaultMix] will have its `id` field set.
  Future<DoubleDefaultMix> insertRow(
    _is.DatabaseSession session,
    DoubleDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoubleDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DoubleDefaultMix]s in the list and returns the resulting rows.
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
  /// The returned [DoubleDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoubleDefaultMix>> upsert(
    _is.DatabaseSession session,
    List<DoubleDefaultMix> rows, {
    required _is.ColumnSelections<DoubleDefaultMixTable> conflictColumns,
    _is.ColumnSelections<DoubleDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DoubleDefaultMix>(
      rows,
      conflictColumns: conflictColumns(DoubleDefaultMix.t),
      updateColumns: updateColumns?.call(DoubleDefaultMix.t),
      updateWhere: updateWhere?.call(DoubleDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DoubleDefaultMix] and returns the resulting row.
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
  /// The returned [DoubleDefaultMix] will have its `id` field set.
  Future<DoubleDefaultMix?> upsertRow(
    _is.DatabaseSession session,
    DoubleDefaultMix row, {
    required _is.ColumnSelections<DoubleDefaultMixTable> conflictColumns,
    _is.ColumnSelections<DoubleDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DoubleDefaultMix>(
      row,
      conflictColumns: conflictColumns(DoubleDefaultMix.t),
      updateColumns: updateColumns?.call(DoubleDefaultMix.t),
      updateWhere: updateWhere?.call(DoubleDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoubleDefaultMix>> update(
    _is.DatabaseSession session,
    List<DoubleDefaultMix> rows, {
    _is.ColumnSelections<DoubleDefaultMixTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DoubleDefaultMix>(
      rows,
      columns: columns?.call(DoubleDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DoubleDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoubleDefaultMix> updateRow(
    _is.DatabaseSession session,
    DoubleDefaultMix row, {
    _is.ColumnSelections<DoubleDefaultMixTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoubleDefaultMix>(
      row,
      columns: columns?.call(DoubleDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoubleDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DoubleDefaultMix?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DoubleDefaultMixUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DoubleDefaultMix>(
      id,
      columnValues: columnValues(DoubleDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DoubleDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoubleDefaultMix>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DoubleDefaultMixUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DoubleDefaultMixTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DoubleDefaultMix>(
      columnValues: columnValues(DoubleDefaultMix.t.updateTable),
      where: where(DoubleDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DoubleDefaultMix]s in the list and returns the deleted rows.
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
  Future<List<DoubleDefaultMix>> delete(
    _is.DatabaseSession session,
    List<DoubleDefaultMix> rows, {
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DoubleDefaultMix>(
      rows,
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DoubleDefaultMix].
  Future<DoubleDefaultMix> deleteRow(
    _is.DatabaseSession session,
    DoubleDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoubleDefaultMix>(
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
  Future<List<DoubleDefaultMix>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoubleDefaultMixTable> where,
    _is.OrderByBuilder<DoubleDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<DoubleDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DoubleDefaultMix>(
      where: where(DoubleDefaultMix.t),
      orderBy: orderBy?.call(DoubleDefaultMix.t),
      orderByList: orderByList?.call(DoubleDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoubleDefaultMixTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DoubleDefaultMix>(
      where: where?.call(DoubleDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DoubleDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoubleDefaultMixTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DoubleDefaultMix>(
      where: where(DoubleDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
