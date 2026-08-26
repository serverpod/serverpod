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
import '../../defaults/enum/enums/by_index_enum.dart' as _ido5z594;
import '../../defaults/enum/enums/by_name_enum.dart' as _iwklobdz;

abstract class EnumDefaultPersist
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EnumDefaultPersist._({
    this.id,
    this.byNameEnumDefaultPersist,
    this.byIndexEnumDefaultPersist,
  });

  factory EnumDefaultPersist({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultPersist,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultPersist,
  }) = _EnumDefaultPersistImpl;

  factory EnumDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultPersist(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultPersist:
          jsonSerialization['byNameEnumDefaultPersist'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultPersist'] as String),
            ),
      byIndexEnumDefaultPersist:
          jsonSerialization['byIndexEnumDefaultPersist'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefaultPersist'] as int),
            ),
    );
  }

  static final t = EnumDefaultPersistTable();

  static const db = EnumDefaultPersistRepository._();

  @override
  int? id;

  _iwklobdz.ByNameEnum? byNameEnumDefaultPersist;

  _ido5z594.ByIndexEnum? byIndexEnumDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EnumDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EnumDefaultPersist copyWith({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultPersist,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnumDefaultPersist',
      if (id != null) 'id': id,
      if (byNameEnumDefaultPersist != null)
        'byNameEnumDefaultPersist': byNameEnumDefaultPersist?.toJson(),
      if (byIndexEnumDefaultPersist != null)
        'byIndexEnumDefaultPersist': byIndexEnumDefaultPersist?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnumDefaultPersist',
      if (id != null) 'id': id,
      if (byNameEnumDefaultPersist != null)
        'byNameEnumDefaultPersist': byNameEnumDefaultPersist?.toJson(),
      if (byIndexEnumDefaultPersist != null)
        'byIndexEnumDefaultPersist': byIndexEnumDefaultPersist?.toJson(),
    };
  }

  /// Builds a complete [EnumDefaultPersistInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EnumDefaultPersistInclude include() {
    return EnumDefaultPersistInclude._();
  }

  /// Builds a complete [EnumDefaultPersistIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EnumDefaultPersistIncludeList includeList({
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    EnumDefaultPersistInclude? include,
  }) {
    return EnumDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [EnumDefaultPersistJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static EnumDefaultPersistJsonInclude includeJson({
    _is.SelectColumnsBuilder<EnumDefaultPersistTable>? select,
  }) {
    return _EnumDefaultPersistJsonInclude._(
      selectedColumns: select?.call(EnumDefaultPersist.t),
    );
  }

  /// Builds a JSON-compatible [EnumDefaultPersistJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static EnumDefaultPersistJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    EnumDefaultPersistJsonInclude? include,
    _is.SelectColumnsBuilder<EnumDefaultPersistTable>? select,
  }) {
    return _EnumDefaultPersistJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      include: include,
      selectedColumns: select?.call(EnumDefaultPersist.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultPersistImpl extends EnumDefaultPersist {
  _EnumDefaultPersistImpl({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultPersist,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultPersist,
  }) : super._(
         id: id,
         byNameEnumDefaultPersist: byNameEnumDefaultPersist,
         byIndexEnumDefaultPersist: byIndexEnumDefaultPersist,
       );

  /// Returns a shallow copy of this [EnumDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EnumDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? byNameEnumDefaultPersist = _Undefined,
    Object? byIndexEnumDefaultPersist = _Undefined,
  }) {
    return EnumDefaultPersist(
      id: id is int? ? id : this.id,
      byNameEnumDefaultPersist:
          byNameEnumDefaultPersist is _iwklobdz.ByNameEnum?
          ? byNameEnumDefaultPersist
          : this.byNameEnumDefaultPersist,
      byIndexEnumDefaultPersist:
          byIndexEnumDefaultPersist is _ido5z594.ByIndexEnum?
          ? byIndexEnumDefaultPersist
          : this.byIndexEnumDefaultPersist,
    );
  }
}

class EnumDefaultPersistUpdateTable
    extends _is.UpdateTable<EnumDefaultPersistTable> {
  EnumDefaultPersistUpdateTable(super.table);

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum>
  byNameEnumDefaultPersist(_iwklobdz.ByNameEnum? value) => _is.ColumnValue(
    table.byNameEnumDefaultPersist,
    value,
  );

  _is.ColumnValue<_ido5z594.ByIndexEnum, _ido5z594.ByIndexEnum>
  byIndexEnumDefaultPersist(_ido5z594.ByIndexEnum? value) => _is.ColumnValue(
    table.byIndexEnumDefaultPersist,
    value,
  );
}

class EnumDefaultPersistTable extends _is.Table<int?> {
  EnumDefaultPersistTable({super.tableRelation})
    : super(tableName: 'enum_default_persist') {
    updateTable = EnumDefaultPersistUpdateTable(this);
    byNameEnumDefaultPersist = _is.ColumnEnum(
      'byNameEnumDefaultPersist',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    byIndexEnumDefaultPersist = _is.ColumnEnum(
      'byIndexEnumDefaultPersist',
      this,
      _is.EnumSerialization.byIndex,
      hasDefault: true,
    );
  }

  late final EnumDefaultPersistUpdateTable updateTable;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum> byNameEnumDefaultPersist;

  late final _is.ColumnEnum<_ido5z594.ByIndexEnum> byIndexEnumDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    byNameEnumDefaultPersist,
    byIndexEnumDefaultPersist,
  ];
}

abstract interface class EnumDefaultPersistJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class EnumDefaultPersistJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class EnumDefaultPersistInclude extends _is.IncludeObject
    implements EnumDefaultPersistJsonInclude, _is.FullModelInclude {
  EnumDefaultPersistInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EnumDefaultPersist.t;
}

final class EnumDefaultPersistIncludeList extends _is.IncludeList
    implements EnumDefaultPersistJsonIncludeList, _is.FullModelInclude {
  EnumDefaultPersistIncludeList._({
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EnumDefaultPersistInclude? super.include,
  }) {
    super.where = where?.call(EnumDefaultPersist.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EnumDefaultPersist.t;
}

final class _EnumDefaultPersistJsonInclude extends _is.IncludeObject
    implements EnumDefaultPersistJsonInclude {
  _EnumDefaultPersistJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EnumDefaultPersist.t;
}

final class _EnumDefaultPersistJsonIncludeList extends _is.IncludeList
    implements EnumDefaultPersistJsonIncludeList {
  _EnumDefaultPersistJsonIncludeList._({
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EnumDefaultPersistJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EnumDefaultPersist.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EnumDefaultPersist.t;
}

class EnumDefaultPersistRepository {
  const EnumDefaultPersistRepository._();

  /// Returns a list of [EnumDefaultPersist]s matching the given query parameters.
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
  Future<List<EnumDefaultPersist>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EnumDefaultPersist] matching the given query parameters.
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
  Future<EnumDefaultPersist?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EnumDefaultPersist] by its [id] or null if no such row exists.
  Future<EnumDefaultPersist?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EnumDefaultPersist>(
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
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EnumDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EnumDefaultPersist.t),
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
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EnumDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EnumDefaultPersist.t),
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
    _is.SelectColumnsBuilder<EnumDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EnumDefaultPersist>(
      id,
      transaction: transaction,
      select: select?.call(EnumDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EnumDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [EnumDefaultPersist]s will have their `id` fields set.
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
  Future<List<EnumDefaultPersist>> insert(
    _is.DatabaseSession session,
    List<EnumDefaultPersist> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EnumDefaultPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EnumDefaultPersist] and returns the inserted row.
  ///
  /// The returned [EnumDefaultPersist] will have its `id` field set.
  Future<EnumDefaultPersist> insertRow(
    _is.DatabaseSession session,
    EnumDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnumDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EnumDefaultPersist]s in the list and returns the resulting rows.
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
  /// The returned [EnumDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultPersist>> upsert(
    _is.DatabaseSession session,
    List<EnumDefaultPersist> rows, {
    required _is.ColumnSelections<EnumDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EnumDefaultPersist>(
      rows,
      conflictColumns: conflictColumns(EnumDefaultPersist.t),
      updateColumns: updateColumns?.call(EnumDefaultPersist.t),
      updateWhere: updateWhere?.call(EnumDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EnumDefaultPersist] and returns the resulting row.
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
  /// The returned [EnumDefaultPersist] will have its `id` field set.
  Future<EnumDefaultPersist?> upsertRow(
    _is.DatabaseSession session,
    EnumDefaultPersist row, {
    required _is.ColumnSelections<EnumDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EnumDefaultPersist>(
      row,
      conflictColumns: conflictColumns(EnumDefaultPersist.t),
      updateColumns: updateColumns?.call(EnumDefaultPersist.t),
      updateWhere: updateWhere?.call(EnumDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultPersist>> update(
    _is.DatabaseSession session,
    List<EnumDefaultPersist> rows, {
    _is.ColumnSelections<EnumDefaultPersistTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EnumDefaultPersist>(
      rows,
      columns: columns?.call(EnumDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EnumDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EnumDefaultPersist> updateRow(
    _is.DatabaseSession session,
    EnumDefaultPersist row, {
    _is.ColumnSelections<EnumDefaultPersistTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnumDefaultPersist>(
      row,
      columns: columns?.call(EnumDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnumDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EnumDefaultPersist?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EnumDefaultPersistUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EnumDefaultPersist>(
      id,
      columnValues: columnValues(EnumDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultPersist>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EnumDefaultPersistUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EnumDefaultPersistTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EnumDefaultPersist>(
      columnValues: columnValues(EnumDefaultPersist.t.updateTable),
      where: where(EnumDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EnumDefaultPersist]s in the list and returns the deleted rows.
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
  Future<List<EnumDefaultPersist>> delete(
    _is.DatabaseSession session,
    List<EnumDefaultPersist> rows, {
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EnumDefaultPersist>(
      rows,
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EnumDefaultPersist].
  Future<EnumDefaultPersist> deleteRow(
    _is.DatabaseSession session,
    EnumDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnumDefaultPersist>(
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
  Future<List<EnumDefaultPersist>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultPersistTable> where,
    _is.OrderByBuilder<EnumDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EnumDefaultPersist>(
      where: where(EnumDefaultPersist.t),
      orderBy: orderBy?.call(EnumDefaultPersist.t),
      orderByList: orderByList?.call(EnumDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultPersistTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EnumDefaultPersist>(
      where: where?.call(EnumDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EnumDefaultPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultPersistTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EnumDefaultPersist>(
      where: where(EnumDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
