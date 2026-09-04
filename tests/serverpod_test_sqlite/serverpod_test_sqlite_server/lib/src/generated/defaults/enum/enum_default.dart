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

abstract class EnumDefault
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EnumDefault._({
    this.id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  }) : byNameEnumDefault = byNameEnumDefault ?? _iwklobdz.ByNameEnum.byName1,
       byNameEnumDefaultNull =
           byNameEnumDefaultNull ?? _iwklobdz.ByNameEnum.byName2,
       byIndexEnumDefault =
           byIndexEnumDefault ?? _ido5z594.ByIndexEnum.byIndex1,
       byIndexEnumDefaultNull =
           byIndexEnumDefaultNull ?? _ido5z594.ByIndexEnum.byIndex2;

  factory EnumDefault({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  }) = _EnumDefaultImpl;

  factory EnumDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefault(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefault: jsonSerialization['byNameEnumDefault'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefault'] as String),
            ),
      byNameEnumDefaultNull: jsonSerialization['byNameEnumDefaultNull'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultNull'] as String),
            ),
      byIndexEnumDefault: jsonSerialization['byIndexEnumDefault'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefault'] as int),
            ),
      byIndexEnumDefaultNull:
          jsonSerialization['byIndexEnumDefaultNull'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefaultNull'] as int),
            ),
    );
  }

  static final t = EnumDefaultTable();

  static const db = EnumDefaultRepository._();

  @override
  int? id;

  _iwklobdz.ByNameEnum byNameEnumDefault;

  _iwklobdz.ByNameEnum? byNameEnumDefaultNull;

  _ido5z594.ByIndexEnum byIndexEnumDefault;

  _ido5z594.ByIndexEnum? byIndexEnumDefaultNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EnumDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EnumDefault copyWith({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnumDefault',
      if (id != null) 'id': id,
      'byNameEnumDefault': byNameEnumDefault.toJson(),
      if (byNameEnumDefaultNull != null)
        'byNameEnumDefaultNull': byNameEnumDefaultNull?.toJson(),
      'byIndexEnumDefault': byIndexEnumDefault.toJson(),
      if (byIndexEnumDefaultNull != null)
        'byIndexEnumDefaultNull': byIndexEnumDefaultNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnumDefault',
      if (id != null) 'id': id,
      'byNameEnumDefault': byNameEnumDefault.toJson(),
      if (byNameEnumDefaultNull != null)
        'byNameEnumDefaultNull': byNameEnumDefaultNull?.toJson(),
      'byIndexEnumDefault': byIndexEnumDefault.toJson(),
      if (byIndexEnumDefaultNull != null)
        'byIndexEnumDefaultNull': byIndexEnumDefaultNull?.toJson(),
    };
  }

  /// Builds a complete [EnumDefaultInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EnumDefaultInclude include() {
    return EnumDefaultInclude._();
  }

  /// Builds a complete [EnumDefaultIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EnumDefaultIncludeList includeList({
    _is.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    EnumDefaultInclude? include,
  }) {
    return EnumDefaultIncludeList._(
      where: where?.call(EnumDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [EnumDefaultJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static EnumDefaultJsonInclude includeJson({
    _is.SelectColumnsBuilder<EnumDefaultTable>? select,
  }) {
    return _EnumDefaultJsonInclude._(
      selectedColumns: select?.call(EnumDefault.t),
    );
  }

  /// Builds a JSON-compatible [EnumDefaultJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static EnumDefaultJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    EnumDefaultJsonInclude? include,
    _is.SelectColumnsBuilder<EnumDefaultTable>? select,
  }) {
    return _EnumDefaultJsonIncludeList._(
      where: where?.call(EnumDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      include: include,
      selectedColumns: select?.call(EnumDefault.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultImpl extends EnumDefault {
  _EnumDefaultImpl({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    _iwklobdz.ByNameEnum? byNameEnumDefaultNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultNull,
  }) : super._(
         id: id,
         byNameEnumDefault: byNameEnumDefault,
         byNameEnumDefaultNull: byNameEnumDefaultNull,
         byIndexEnumDefault: byIndexEnumDefault,
         byIndexEnumDefaultNull: byIndexEnumDefaultNull,
       );

  /// Returns a shallow copy of this [EnumDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EnumDefault copyWith({
    Object? id = _Undefined,
    _iwklobdz.ByNameEnum? byNameEnumDefault,
    Object? byNameEnumDefaultNull = _Undefined,
    _ido5z594.ByIndexEnum? byIndexEnumDefault,
    Object? byIndexEnumDefaultNull = _Undefined,
  }) {
    return EnumDefault(
      id: id is int? ? id : this.id,
      byNameEnumDefault: byNameEnumDefault ?? this.byNameEnumDefault,
      byNameEnumDefaultNull: byNameEnumDefaultNull is _iwklobdz.ByNameEnum?
          ? byNameEnumDefaultNull
          : this.byNameEnumDefaultNull,
      byIndexEnumDefault: byIndexEnumDefault ?? this.byIndexEnumDefault,
      byIndexEnumDefaultNull: byIndexEnumDefaultNull is _ido5z594.ByIndexEnum?
          ? byIndexEnumDefaultNull
          : this.byIndexEnumDefaultNull,
    );
  }
}

class EnumDefaultUpdateTable extends _is.UpdateTable<EnumDefaultTable> {
  EnumDefaultUpdateTable(super.table);

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum> byNameEnumDefault(
    _iwklobdz.ByNameEnum value,
  ) => _is.ColumnValue(
    table.byNameEnumDefault,
    value,
  );

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum>
  byNameEnumDefaultNull(_iwklobdz.ByNameEnum? value) => _is.ColumnValue(
    table.byNameEnumDefaultNull,
    value,
  );

  _is.ColumnValue<_ido5z594.ByIndexEnum, _ido5z594.ByIndexEnum>
  byIndexEnumDefault(_ido5z594.ByIndexEnum value) => _is.ColumnValue(
    table.byIndexEnumDefault,
    value,
  );

  _is.ColumnValue<_ido5z594.ByIndexEnum, _ido5z594.ByIndexEnum>
  byIndexEnumDefaultNull(_ido5z594.ByIndexEnum? value) => _is.ColumnValue(
    table.byIndexEnumDefaultNull,
    value,
  );
}

class EnumDefaultTable extends _is.Table<int?> {
  EnumDefaultTable({super.tableRelation}) : super(tableName: 'enum_default') {
    updateTable = EnumDefaultUpdateTable(this);
    byNameEnumDefault = _is.ColumnEnum(
      'byNameEnumDefault',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    byNameEnumDefaultNull = _is.ColumnEnum(
      'byNameEnumDefaultNull',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    byIndexEnumDefault = _is.ColumnEnum(
      'byIndexEnumDefault',
      this,
      _is.EnumSerialization.byIndex,
      hasDefault: true,
    );
    byIndexEnumDefaultNull = _is.ColumnEnum(
      'byIndexEnumDefaultNull',
      this,
      _is.EnumSerialization.byIndex,
      hasDefault: true,
    );
  }

  late final EnumDefaultUpdateTable updateTable;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum> byNameEnumDefault;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum> byNameEnumDefaultNull;

  late final _is.ColumnEnum<_ido5z594.ByIndexEnum> byIndexEnumDefault;

  late final _is.ColumnEnum<_ido5z594.ByIndexEnum> byIndexEnumDefaultNull;

  @override
  List<_is.Column> get columns => [
    id,
    byNameEnumDefault,
    byNameEnumDefaultNull,
    byIndexEnumDefault,
    byIndexEnumDefaultNull,
  ];
}

abstract interface class EnumDefaultJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class EnumDefaultJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class EnumDefaultInclude extends _is.IncludeObject
    implements EnumDefaultJsonInclude, _is.FullModelInclude {
  EnumDefaultInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EnumDefault.t;
}

final class EnumDefaultIncludeList extends _is.IncludeList
    implements EnumDefaultJsonIncludeList, _is.FullModelInclude {
  EnumDefaultIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EnumDefaultInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EnumDefault.t;
}

final class _EnumDefaultJsonInclude extends _is.IncludeObject
    implements EnumDefaultJsonInclude {
  _EnumDefaultJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EnumDefault.t;
}

final class _EnumDefaultJsonIncludeList extends _is.IncludeList
    implements EnumDefaultJsonIncludeList {
  _EnumDefaultJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EnumDefaultJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EnumDefault.t;
}

class EnumDefaultRepository {
  const EnumDefaultRepository._();

  /// Returns a list of [EnumDefault]s matching the given query parameters.
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
  Future<List<EnumDefault>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EnumDefault>(
      where: where?.call(EnumDefault.t),
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EnumDefault] matching the given query parameters.
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
  Future<EnumDefault?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EnumDefault>(
      where: where?.call(EnumDefault.t),
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EnumDefault] by its [id] or null if no such row exists.
  Future<EnumDefault?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EnumDefault>(
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
    _is.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EnumDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EnumDefault>(
      where: where?.call(EnumDefault.t),
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EnumDefault.t),
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
    _is.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EnumDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EnumDefault>(
      where: where?.call(EnumDefault.t),
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EnumDefault.t),
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
    _is.SelectColumnsBuilder<EnumDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EnumDefault>(
      id,
      transaction: transaction,
      select: select?.call(EnumDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EnumDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [EnumDefault]s will have their `id` fields set.
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
  Future<List<EnumDefault>> insert(
    _is.DatabaseSession session,
    List<EnumDefault> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EnumDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EnumDefault] and returns the inserted row.
  ///
  /// The returned [EnumDefault] will have its `id` field set.
  Future<EnumDefault> insertRow(
    _is.DatabaseSession session,
    EnumDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnumDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EnumDefault]s in the list and returns the resulting rows.
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
  /// The returned [EnumDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefault>> upsert(
    _is.DatabaseSession session,
    List<EnumDefault> rows, {
    required _is.ColumnSelections<EnumDefaultTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EnumDefault>(
      rows,
      conflictColumns: conflictColumns(EnumDefault.t),
      updateColumns: updateColumns?.call(EnumDefault.t),
      updateWhere: updateWhere?.call(EnumDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EnumDefault] and returns the resulting row.
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
  /// The returned [EnumDefault] will have its `id` field set.
  Future<EnumDefault?> upsertRow(
    _is.DatabaseSession session,
    EnumDefault row, {
    required _is.ColumnSelections<EnumDefaultTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EnumDefault>(
      row,
      conflictColumns: conflictColumns(EnumDefault.t),
      updateColumns: updateColumns?.call(EnumDefault.t),
      updateWhere: updateWhere?.call(EnumDefault.t),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefault>> update(
    _is.DatabaseSession session,
    List<EnumDefault> rows, {
    _is.ColumnSelections<EnumDefaultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EnumDefault>(
      rows,
      columns: columns?.call(EnumDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EnumDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EnumDefault> updateRow(
    _is.DatabaseSession session,
    EnumDefault row, {
    _is.ColumnSelections<EnumDefaultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnumDefault>(
      row,
      columns: columns?.call(EnumDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnumDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EnumDefault?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EnumDefaultUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EnumDefault>(
      id,
      columnValues: columnValues(EnumDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefault>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EnumDefaultUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EnumDefaultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EnumDefault>(
      columnValues: columnValues(EnumDefault.t.updateTable),
      where: where(EnumDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EnumDefault]s in the list and returns the deleted rows.
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
  Future<List<EnumDefault>> delete(
    _is.DatabaseSession session,
    List<EnumDefault> rows, {
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EnumDefault>(
      rows,
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EnumDefault].
  Future<EnumDefault> deleteRow(
    _is.DatabaseSession session,
    EnumDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnumDefault>(
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
  Future<List<EnumDefault>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultTable> where,
    _is.OrderByBuilder<EnumDefaultTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EnumDefault>(
      where: where(EnumDefault.t),
      orderBy: orderBy?.call(EnumDefault.t),
      orderByList: orderByList?.call(EnumDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EnumDefault>(
      where: where?.call(EnumDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EnumDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EnumDefault>(
      where: where(EnumDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
