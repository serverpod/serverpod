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

abstract class StringDefaultMix
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StringDefaultMix._({
    this.id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) : stringDefaultAndDefaultModel =
           stringDefaultAndDefaultModel ?? 'This is a default model value',
       stringDefaultAndDefaultPersist =
           stringDefaultAndDefaultPersist ?? 'This is a default value',
       stringDefaultModelAndDefaultPersist =
           stringDefaultModelAndDefaultPersist ?? 'This is a default value';

  factory StringDefaultMix({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) = _StringDefaultMixImpl;

  factory StringDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefaultMix(
      id: jsonSerialization['id'] as int?,
      stringDefaultAndDefaultModel:
          jsonSerialization['stringDefaultAndDefaultModel'] as String?,
      stringDefaultAndDefaultPersist:
          jsonSerialization['stringDefaultAndDefaultPersist'] as String?,
      stringDefaultModelAndDefaultPersist:
          jsonSerialization['stringDefaultModelAndDefaultPersist'] as String?,
    );
  }

  static final t = StringDefaultMixTable();

  static const db = StringDefaultMixRepository._();

  @override
  int? id;

  String stringDefaultAndDefaultModel;

  String stringDefaultAndDefaultPersist;

  String stringDefaultModelAndDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StringDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StringDefaultMix copyWith({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StringDefaultMix',
      if (id != null) 'id': id,
      'stringDefaultAndDefaultModel': stringDefaultAndDefaultModel,
      'stringDefaultAndDefaultPersist': stringDefaultAndDefaultPersist,
      'stringDefaultModelAndDefaultPersist':
          stringDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StringDefaultMix',
      if (id != null) 'id': id,
      'stringDefaultAndDefaultModel': stringDefaultAndDefaultModel,
      'stringDefaultAndDefaultPersist': stringDefaultAndDefaultPersist,
      'stringDefaultModelAndDefaultPersist':
          stringDefaultModelAndDefaultPersist,
    };
  }

  /// Builds a complete [StringDefaultMixInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static StringDefaultMixInclude include() {
    return StringDefaultMixInclude._();
  }

  /// Builds a complete [StringDefaultMixIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static StringDefaultMixIncludeList includeList({
    _is.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    StringDefaultMixInclude? include,
  }) {
    return StringDefaultMixIncludeList._(
      where: where?.call(StringDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [StringDefaultMixJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static StringDefaultMixJsonInclude includeJson({
    _is.SelectColumnsBuilder<StringDefaultMixTable>? select,
  }) {
    return _StringDefaultMixJsonInclude._(
      selectedColumns: select?.call(StringDefaultMix.t),
    );
  }

  /// Builds a JSON-compatible [StringDefaultMixJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static StringDefaultMixJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    StringDefaultMixJsonInclude? include,
    _is.SelectColumnsBuilder<StringDefaultMixTable>? select,
  }) {
    return _StringDefaultMixJsonIncludeList._(
      where: where?.call(StringDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      include: include,
      selectedColumns: select?.call(StringDefaultMix.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultMixImpl extends StringDefaultMix {
  _StringDefaultMixImpl({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         stringDefaultAndDefaultModel: stringDefaultAndDefaultModel,
         stringDefaultAndDefaultPersist: stringDefaultAndDefaultPersist,
         stringDefaultModelAndDefaultPersist:
             stringDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [StringDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StringDefaultMix copyWith({
    Object? id = _Undefined,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) {
    return StringDefaultMix(
      id: id is int? ? id : this.id,
      stringDefaultAndDefaultModel:
          stringDefaultAndDefaultModel ?? this.stringDefaultAndDefaultModel,
      stringDefaultAndDefaultPersist:
          stringDefaultAndDefaultPersist ?? this.stringDefaultAndDefaultPersist,
      stringDefaultModelAndDefaultPersist:
          stringDefaultModelAndDefaultPersist ??
          this.stringDefaultModelAndDefaultPersist,
    );
  }
}

class StringDefaultMixUpdateTable
    extends _is.UpdateTable<StringDefaultMixTable> {
  StringDefaultMixUpdateTable(super.table);

  _is.ColumnValue<String, String> stringDefaultAndDefaultModel(String value) =>
      _is.ColumnValue(
        table.stringDefaultAndDefaultModel,
        value,
      );

  _is.ColumnValue<String, String> stringDefaultAndDefaultPersist(
    String value,
  ) => _is.ColumnValue(
    table.stringDefaultAndDefaultPersist,
    value,
  );

  _is.ColumnValue<String, String> stringDefaultModelAndDefaultPersist(
    String value,
  ) => _is.ColumnValue(
    table.stringDefaultModelAndDefaultPersist,
    value,
  );
}

class StringDefaultMixTable extends _is.Table<int?> {
  StringDefaultMixTable({super.tableRelation})
    : super(tableName: 'string_default_mix') {
    updateTable = StringDefaultMixUpdateTable(this);
    stringDefaultAndDefaultModel = _is.ColumnString(
      'stringDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    stringDefaultAndDefaultPersist = _is.ColumnString(
      'stringDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    stringDefaultModelAndDefaultPersist = _is.ColumnString(
      'stringDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final StringDefaultMixUpdateTable updateTable;

  late final _is.ColumnString stringDefaultAndDefaultModel;

  late final _is.ColumnString stringDefaultAndDefaultPersist;

  late final _is.ColumnString stringDefaultModelAndDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    stringDefaultAndDefaultModel,
    stringDefaultAndDefaultPersist,
    stringDefaultModelAndDefaultPersist,
  ];
}

abstract interface class StringDefaultMixJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class StringDefaultMixJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class StringDefaultMixInclude extends _is.IncludeObject
    implements StringDefaultMixJsonInclude, _is.FullModelInclude {
  StringDefaultMixInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StringDefaultMix.t;
}

final class StringDefaultMixIncludeList extends _is.IncludeList
    implements StringDefaultMixJsonIncludeList, _is.FullModelInclude {
  StringDefaultMixIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    StringDefaultMixInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StringDefaultMix.t;
}

final class _StringDefaultMixJsonInclude extends _is.IncludeObject
    implements StringDefaultMixJsonInclude {
  _StringDefaultMixJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StringDefaultMix.t;
}

final class _StringDefaultMixJsonIncludeList extends _is.IncludeList
    implements StringDefaultMixJsonIncludeList {
  _StringDefaultMixJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    StringDefaultMixJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StringDefaultMix.t;
}

class StringDefaultMixRepository {
  const StringDefaultMixRepository._();

  /// Returns a list of [StringDefaultMix]s matching the given query parameters.
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
  Future<List<StringDefaultMix>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StringDefaultMix] matching the given query parameters.
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
  Future<StringDefaultMix?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StringDefaultMix] by its [id] or null if no such row exists.
  Future<StringDefaultMix?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StringDefaultMix>(
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
    _is.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefaultMix.t),
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
    _is.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefaultMix.t),
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
    _is.SelectColumnsBuilder<StringDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<StringDefaultMix>(
      id,
      transaction: transaction,
      select: select?.call(StringDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StringDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [StringDefaultMix]s will have their `id` fields set.
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
  Future<List<StringDefaultMix>> insert(
    _is.DatabaseSession session,
    List<StringDefaultMix> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StringDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StringDefaultMix] and returns the inserted row.
  ///
  /// The returned [StringDefaultMix] will have its `id` field set.
  Future<StringDefaultMix> insertRow(
    _is.DatabaseSession session,
    StringDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StringDefaultMix]s in the list and returns the resulting rows.
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
  /// The returned [StringDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultMix>> upsert(
    _is.DatabaseSession session,
    List<StringDefaultMix> rows, {
    required _is.ColumnSelections<StringDefaultMixTable> conflictColumns,
    _is.ColumnSelections<StringDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StringDefaultMix>(
      rows,
      conflictColumns: conflictColumns(StringDefaultMix.t),
      updateColumns: updateColumns?.call(StringDefaultMix.t),
      updateWhere: updateWhere?.call(StringDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StringDefaultMix] and returns the resulting row.
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
  /// The returned [StringDefaultMix] will have its `id` field set.
  Future<StringDefaultMix?> upsertRow(
    _is.DatabaseSession session,
    StringDefaultMix row, {
    required _is.ColumnSelections<StringDefaultMixTable> conflictColumns,
    _is.ColumnSelections<StringDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StringDefaultMix>(
      row,
      conflictColumns: conflictColumns(StringDefaultMix.t),
      updateColumns: updateColumns?.call(StringDefaultMix.t),
      updateWhere: updateWhere?.call(StringDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultMix>> update(
    _is.DatabaseSession session,
    List<StringDefaultMix> rows, {
    _is.ColumnSelections<StringDefaultMixTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StringDefaultMix>(
      rows,
      columns: columns?.call(StringDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StringDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StringDefaultMix> updateRow(
    _is.DatabaseSession session,
    StringDefaultMix row, {
    _is.ColumnSelections<StringDefaultMixTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefaultMix>(
      row,
      columns: columns?.call(StringDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StringDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StringDefaultMix?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StringDefaultMixUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StringDefaultMix>(
      id,
      columnValues: columnValues(StringDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefaultMix>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StringDefaultMixUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<StringDefaultMixTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StringDefaultMix>(
      columnValues: columnValues(StringDefaultMix.t.updateTable),
      where: where(StringDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StringDefaultMix]s in the list and returns the deleted rows.
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
  Future<List<StringDefaultMix>> delete(
    _is.DatabaseSession session,
    List<StringDefaultMix> rows, {
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StringDefaultMix>(
      rows,
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StringDefaultMix].
  Future<StringDefaultMix> deleteRow(
    _is.DatabaseSession session,
    StringDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefaultMix>(
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
  Future<List<StringDefaultMix>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultMixTable> where,
    _is.OrderByBuilder<StringDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StringDefaultMix>(
      where: where(StringDefaultMix.t),
      orderBy: orderBy?.call(StringDefaultMix.t),
      orderByList: orderByList?.call(StringDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultMixTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StringDefaultMix>(
      where: where?.call(StringDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StringDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultMixTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StringDefaultMix>(
      where: where(StringDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
