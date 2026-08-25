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

abstract class EnumDefaultModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EnumDefaultModel._({
    this.id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) : byNameEnumDefaultModel =
           byNameEnumDefaultModel ?? _iwklobdz.ByNameEnum.byName1,
       byNameEnumDefaultModelNull =
           byNameEnumDefaultModelNull ?? _iwklobdz.ByNameEnum.byName2,
       byIndexEnumDefaultModel =
           byIndexEnumDefaultModel ?? _ido5z594.ByIndexEnum.byIndex1,
       byIndexEnumDefaultModelNull =
           byIndexEnumDefaultModelNull ?? _ido5z594.ByIndexEnum.byIndex2;

  factory EnumDefaultModel({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) = _EnumDefaultModelImpl;

  factory EnumDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultModel(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultModel:
          jsonSerialization['byNameEnumDefaultModel'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultModel'] as String),
            ),
      byNameEnumDefaultModelNull:
          jsonSerialization['byNameEnumDefaultModelNull'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultModelNull'] as String),
            ),
      byIndexEnumDefaultModel:
          jsonSerialization['byIndexEnumDefaultModel'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefaultModel'] as int),
            ),
      byIndexEnumDefaultModelNull:
          jsonSerialization['byIndexEnumDefaultModelNull'] == null
          ? null
          : _ido5z594.ByIndexEnum.fromJson(
              (jsonSerialization['byIndexEnumDefaultModelNull'] as int),
            ),
    );
  }

  static final t = EnumDefaultModelTable();

  static const db = EnumDefaultModelRepository._();

  @override
  int? id;

  _iwklobdz.ByNameEnum byNameEnumDefaultModel;

  _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull;

  _ido5z594.ByIndexEnum byIndexEnumDefaultModel;

  _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EnumDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EnumDefaultModel copyWith({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnumDefaultModel',
      if (id != null) 'id': id,
      'byNameEnumDefaultModel': byNameEnumDefaultModel.toJson(),
      if (byNameEnumDefaultModelNull != null)
        'byNameEnumDefaultModelNull': byNameEnumDefaultModelNull?.toJson(),
      'byIndexEnumDefaultModel': byIndexEnumDefaultModel.toJson(),
      if (byIndexEnumDefaultModelNull != null)
        'byIndexEnumDefaultModelNull': byIndexEnumDefaultModelNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnumDefaultModel',
      if (id != null) 'id': id,
      'byNameEnumDefaultModel': byNameEnumDefaultModel.toJson(),
      if (byNameEnumDefaultModelNull != null)
        'byNameEnumDefaultModelNull': byNameEnumDefaultModelNull?.toJson(),
      'byIndexEnumDefaultModel': byIndexEnumDefaultModel.toJson(),
      if (byIndexEnumDefaultModelNull != null)
        'byIndexEnumDefaultModelNull': byIndexEnumDefaultModelNull?.toJson(),
    };
  }

  static EnumDefaultModelInclude include({
    _is.SelectColumnsBuilder<EnumDefaultModelTable>? select,
  }) {
    return EnumDefaultModelInclude._(
      selectedColumns: select?.call(EnumDefaultModel.t),
    );
  }

  static EnumDefaultModelIncludeList includeList({
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    EnumDefaultModelInclude? include,
    _is.SelectColumnsBuilder<EnumDefaultModelTable>? select,
  }) {
    return EnumDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      include: include,
      selectedColumns: select?.call(EnumDefaultModel.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultModelImpl extends EnumDefaultModel {
  _EnumDefaultModelImpl({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelNull,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModelNull,
  }) : super._(
         id: id,
         byNameEnumDefaultModel: byNameEnumDefaultModel,
         byNameEnumDefaultModelNull: byNameEnumDefaultModelNull,
         byIndexEnumDefaultModel: byIndexEnumDefaultModel,
         byIndexEnumDefaultModelNull: byIndexEnumDefaultModelNull,
       );

  /// Returns a shallow copy of this [EnumDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EnumDefaultModel copyWith({
    Object? id = _Undefined,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModel,
    Object? byNameEnumDefaultModelNull = _Undefined,
    _ido5z594.ByIndexEnum? byIndexEnumDefaultModel,
    Object? byIndexEnumDefaultModelNull = _Undefined,
  }) {
    return EnumDefaultModel(
      id: id is int? ? id : this.id,
      byNameEnumDefaultModel:
          byNameEnumDefaultModel ?? this.byNameEnumDefaultModel,
      byNameEnumDefaultModelNull:
          byNameEnumDefaultModelNull is _iwklobdz.ByNameEnum?
          ? byNameEnumDefaultModelNull
          : this.byNameEnumDefaultModelNull,
      byIndexEnumDefaultModel:
          byIndexEnumDefaultModel ?? this.byIndexEnumDefaultModel,
      byIndexEnumDefaultModelNull:
          byIndexEnumDefaultModelNull is _ido5z594.ByIndexEnum?
          ? byIndexEnumDefaultModelNull
          : this.byIndexEnumDefaultModelNull,
    );
  }
}

class EnumDefaultModelUpdateTable
    extends _is.UpdateTable<EnumDefaultModelTable> {
  EnumDefaultModelUpdateTable(super.table);

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum>
  byNameEnumDefaultModel(_iwklobdz.ByNameEnum value) => _is.ColumnValue(
    table.byNameEnumDefaultModel,
    value,
  );

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum>
  byNameEnumDefaultModelNull(_iwklobdz.ByNameEnum? value) => _is.ColumnValue(
    table.byNameEnumDefaultModelNull,
    value,
  );

  _is.ColumnValue<_ido5z594.ByIndexEnum, _ido5z594.ByIndexEnum>
  byIndexEnumDefaultModel(_ido5z594.ByIndexEnum value) => _is.ColumnValue(
    table.byIndexEnumDefaultModel,
    value,
  );

  _is.ColumnValue<_ido5z594.ByIndexEnum, _ido5z594.ByIndexEnum>
  byIndexEnumDefaultModelNull(_ido5z594.ByIndexEnum? value) => _is.ColumnValue(
    table.byIndexEnumDefaultModelNull,
    value,
  );
}

class EnumDefaultModelTable extends _is.Table<int?> {
  EnumDefaultModelTable({super.tableRelation})
    : super(tableName: 'enum_default_model') {
    updateTable = EnumDefaultModelUpdateTable(this);
    byNameEnumDefaultModel = _is.ColumnEnum(
      'byNameEnumDefaultModel',
      this,
      _is.EnumSerialization.byName,
    );
    byNameEnumDefaultModelNull = _is.ColumnEnum(
      'byNameEnumDefaultModelNull',
      this,
      _is.EnumSerialization.byName,
    );
    byIndexEnumDefaultModel = _is.ColumnEnum(
      'byIndexEnumDefaultModel',
      this,
      _is.EnumSerialization.byIndex,
    );
    byIndexEnumDefaultModelNull = _is.ColumnEnum(
      'byIndexEnumDefaultModelNull',
      this,
      _is.EnumSerialization.byIndex,
    );
  }

  late final EnumDefaultModelUpdateTable updateTable;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum> byNameEnumDefaultModel;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum> byNameEnumDefaultModelNull;

  late final _is.ColumnEnum<_ido5z594.ByIndexEnum> byIndexEnumDefaultModel;

  late final _is.ColumnEnum<_ido5z594.ByIndexEnum> byIndexEnumDefaultModelNull;

  @override
  List<_is.Column> get columns => [
    id,
    byNameEnumDefaultModel,
    byNameEnumDefaultModelNull,
    byIndexEnumDefaultModel,
    byIndexEnumDefaultModelNull,
  ];
}

class EnumDefaultModelInclude extends _is.IncludeObject {
  EnumDefaultModelInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EnumDefaultModel.t;
}

class EnumDefaultModelIncludeList extends _is.IncludeList {
  EnumDefaultModelIncludeList._({
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(EnumDefaultModel.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EnumDefaultModel.t;
}

class EnumDefaultModelRepository {
  const EnumDefaultModelRepository._();

  /// Returns a list of [EnumDefaultModel]s matching the given query parameters.
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
  Future<List<EnumDefaultModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EnumDefaultModel] matching the given query parameters.
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
  Future<EnumDefaultModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EnumDefaultModel] by its [id] or null if no such row exists.
  Future<EnumDefaultModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EnumDefaultModel>(
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
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EnumDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EnumDefaultModel.t),
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
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<EnumDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EnumDefaultModel.t),
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
    _is.SelectColumnsBuilder<EnumDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EnumDefaultModel>(
      id,
      transaction: transaction,
      select: select?.call(EnumDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EnumDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [EnumDefaultModel]s will have their `id` fields set.
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
  Future<List<EnumDefaultModel>> insert(
    _is.DatabaseSession session,
    List<EnumDefaultModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EnumDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EnumDefaultModel] and returns the inserted row.
  ///
  /// The returned [EnumDefaultModel] will have its `id` field set.
  Future<EnumDefaultModel> insertRow(
    _is.DatabaseSession session,
    EnumDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnumDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EnumDefaultModel]s in the list and returns the resulting rows.
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
  /// The returned [EnumDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultModel>> upsert(
    _is.DatabaseSession session,
    List<EnumDefaultModel> rows, {
    required _is.ColumnSelections<EnumDefaultModelTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EnumDefaultModel>(
      rows,
      conflictColumns: conflictColumns(EnumDefaultModel.t),
      updateColumns: updateColumns?.call(EnumDefaultModel.t),
      updateWhere: updateWhere?.call(EnumDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EnumDefaultModel] and returns the resulting row.
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
  /// The returned [EnumDefaultModel] will have its `id` field set.
  Future<EnumDefaultModel?> upsertRow(
    _is.DatabaseSession session,
    EnumDefaultModel row, {
    required _is.ColumnSelections<EnumDefaultModelTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EnumDefaultModel>(
      row,
      conflictColumns: conflictColumns(EnumDefaultModel.t),
      updateColumns: updateColumns?.call(EnumDefaultModel.t),
      updateWhere: updateWhere?.call(EnumDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultModel>> update(
    _is.DatabaseSession session,
    List<EnumDefaultModel> rows, {
    _is.ColumnSelections<EnumDefaultModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EnumDefaultModel>(
      rows,
      columns: columns?.call(EnumDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EnumDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EnumDefaultModel> updateRow(
    _is.DatabaseSession session,
    EnumDefaultModel row, {
    _is.ColumnSelections<EnumDefaultModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnumDefaultModel>(
      row,
      columns: columns?.call(EnumDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnumDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EnumDefaultModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EnumDefaultModelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EnumDefaultModel>(
      id,
      columnValues: columnValues(EnumDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EnumDefaultModelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<EnumDefaultModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EnumDefaultModel>(
      columnValues: columnValues(EnumDefaultModel.t.updateTable),
      where: where(EnumDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EnumDefaultModel]s in the list and returns the deleted rows.
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
  Future<List<EnumDefaultModel>> delete(
    _is.DatabaseSession session,
    List<EnumDefaultModel> rows, {
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EnumDefaultModel>(
      rows,
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EnumDefaultModel].
  Future<EnumDefaultModel> deleteRow(
    _is.DatabaseSession session,
    EnumDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnumDefaultModel>(
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
  Future<List<EnumDefaultModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultModelTable> where,
    _is.OrderByBuilder<EnumDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EnumDefaultModel>(
      where: where(EnumDefaultModel.t),
      orderBy: orderBy?.call(EnumDefaultModel.t),
      orderByList: orderByList?.call(EnumDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EnumDefaultModel>(
      where: where?.call(EnumDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EnumDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EnumDefaultModel>(
      where: where(EnumDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
