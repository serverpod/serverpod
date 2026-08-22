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
import 'package:meta/meta.dart' as _i057hz1u;
import 'package:serverpod/serverpod.dart' as _is;
import '../../defaults/enum/enums/by_name_enum.dart' as _iwklobdz;

abstract class EnumDefaultMix
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  EnumDefaultMix._({
    this.id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) : byNameEnumDefaultAndDefaultModel =
           byNameEnumDefaultAndDefaultModel ?? _iwklobdz.ByNameEnum.byName2,
       byNameEnumDefaultAndDefaultPersist =
           byNameEnumDefaultAndDefaultPersist ?? _iwklobdz.ByNameEnum.byName1,
       byNameEnumDefaultModelAndDefaultPersist =
           byNameEnumDefaultModelAndDefaultPersist ??
           _iwklobdz.ByNameEnum.byName1;

  factory EnumDefaultMix({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) = _EnumDefaultMixImpl;

  factory EnumDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnumDefaultMix(
      id: jsonSerialization['id'] as int?,
      byNameEnumDefaultAndDefaultModel:
          jsonSerialization['byNameEnumDefaultAndDefaultModel'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultAndDefaultModel'] as String),
            ),
      byNameEnumDefaultAndDefaultPersist:
          jsonSerialization['byNameEnumDefaultAndDefaultPersist'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultAndDefaultPersist']
                  as String),
            ),
      byNameEnumDefaultModelAndDefaultPersist:
          jsonSerialization['byNameEnumDefaultModelAndDefaultPersist'] == null
          ? null
          : _iwklobdz.ByNameEnum.fromJson(
              (jsonSerialization['byNameEnumDefaultModelAndDefaultPersist']
                  as String),
            ),
    );
  }

  static final t = EnumDefaultMixTable();

  static const db = EnumDefaultMixRepository._();

  @override
  int? id;

  _iwklobdz.ByNameEnum byNameEnumDefaultAndDefaultModel;

  _iwklobdz.ByNameEnum byNameEnumDefaultAndDefaultPersist;

  _iwklobdz.ByNameEnum byNameEnumDefaultModelAndDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [EnumDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EnumDefaultMix copyWith({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnumDefaultMix',
      if (id != null) 'id': id,
      'byNameEnumDefaultAndDefaultModel': byNameEnumDefaultAndDefaultModel
          .toJson(),
      'byNameEnumDefaultAndDefaultPersist': byNameEnumDefaultAndDefaultPersist
          .toJson(),
      'byNameEnumDefaultModelAndDefaultPersist':
          byNameEnumDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnumDefaultMix',
      if (id != null) 'id': id,
      'byNameEnumDefaultAndDefaultModel': byNameEnumDefaultAndDefaultModel
          .toJson(),
      'byNameEnumDefaultAndDefaultPersist': byNameEnumDefaultAndDefaultPersist
          .toJson(),
      'byNameEnumDefaultModelAndDefaultPersist':
          byNameEnumDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static EnumDefaultMixInclude include() {
    return EnumDefaultMixInclude.internal_();
  }

  static EnumDefaultMixIncludeList includeList({
    _is.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    EnumDefaultMixInclude? include,
  }) {
    return EnumDefaultMixIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnumDefaultMixImpl extends EnumDefaultMix {
  _EnumDefaultMixImpl({
    int? id,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         byNameEnumDefaultAndDefaultModel: byNameEnumDefaultAndDefaultModel,
         byNameEnumDefaultAndDefaultPersist: byNameEnumDefaultAndDefaultPersist,
         byNameEnumDefaultModelAndDefaultPersist:
             byNameEnumDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [EnumDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EnumDefaultMix copyWith({
    Object? id = _Undefined,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultModel,
    _iwklobdz.ByNameEnum? byNameEnumDefaultAndDefaultPersist,
    _iwklobdz.ByNameEnum? byNameEnumDefaultModelAndDefaultPersist,
  }) {
    return EnumDefaultMix(
      id: id is int? ? id : this.id,
      byNameEnumDefaultAndDefaultModel:
          byNameEnumDefaultAndDefaultModel ??
          this.byNameEnumDefaultAndDefaultModel,
      byNameEnumDefaultAndDefaultPersist:
          byNameEnumDefaultAndDefaultPersist ??
          this.byNameEnumDefaultAndDefaultPersist,
      byNameEnumDefaultModelAndDefaultPersist:
          byNameEnumDefaultModelAndDefaultPersist ??
          this.byNameEnumDefaultModelAndDefaultPersist,
    );
  }
}

class EnumDefaultMixUpdateTable extends _is.UpdateTable<EnumDefaultMixTable> {
  EnumDefaultMixUpdateTable(super.table);

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum>
  byNameEnumDefaultAndDefaultModel(_iwklobdz.ByNameEnum value) =>
      _is.ColumnValue(
        table.byNameEnumDefaultAndDefaultModel,
        value,
      );

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum>
  byNameEnumDefaultAndDefaultPersist(_iwklobdz.ByNameEnum value) =>
      _is.ColumnValue(
        table.byNameEnumDefaultAndDefaultPersist,
        value,
      );

  _is.ColumnValue<_iwklobdz.ByNameEnum, _iwklobdz.ByNameEnum>
  byNameEnumDefaultModelAndDefaultPersist(_iwklobdz.ByNameEnum value) =>
      _is.ColumnValue(
        table.byNameEnumDefaultModelAndDefaultPersist,
        value,
      );
}

class EnumDefaultMixTable extends _is.Table<int?> {
  EnumDefaultMixTable({super.tableRelation})
    : super(tableName: 'enum_default_mix') {
    updateTable = EnumDefaultMixUpdateTable(this);
    byNameEnumDefaultAndDefaultModel = _is.ColumnEnum(
      'byNameEnumDefaultAndDefaultModel',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    byNameEnumDefaultAndDefaultPersist = _is.ColumnEnum(
      'byNameEnumDefaultAndDefaultPersist',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    byNameEnumDefaultModelAndDefaultPersist = _is.ColumnEnum(
      'byNameEnumDefaultModelAndDefaultPersist',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
  }

  late final EnumDefaultMixUpdateTable updateTable;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum>
  byNameEnumDefaultAndDefaultModel;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum>
  byNameEnumDefaultAndDefaultPersist;

  late final _is.ColumnEnum<_iwklobdz.ByNameEnum>
  byNameEnumDefaultModelAndDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    byNameEnumDefaultAndDefaultModel,
    byNameEnumDefaultAndDefaultPersist,
    byNameEnumDefaultModelAndDefaultPersist,
  ];
}

class EnumDefaultMixInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  EnumDefaultMixInclude.internal_({List<_is.Column>? this.selectedColumns}) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => EnumDefaultMix.t;
}

class EnumDefaultMixIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  EnumDefaultMixIncludeList.internal_({
    _is.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(EnumDefaultMix.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => EnumDefaultMix.t;
}

class EnumDefaultMixRepository {
  const EnumDefaultMixRepository._();

  /// Returns a list of [EnumDefaultMix]s matching the given query parameters.
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
  Future<List<EnumDefaultMix>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EnumDefaultMix>(
      where: where?.call(EnumDefaultMix.t),
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EnumDefaultMix] matching the given query parameters.
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
  Future<EnumDefaultMix?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EnumDefaultMix>(
      where: where?.call(EnumDefaultMix.t),
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EnumDefaultMix] by its [id] or null if no such row exists.
  Future<EnumDefaultMix?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EnumDefaultMix>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EnumDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [EnumDefaultMix]s will have their `id` fields set.
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
  Future<List<EnumDefaultMix>> insert(
    _is.DatabaseSession session,
    List<EnumDefaultMix> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EnumDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EnumDefaultMix] and returns the inserted row.
  ///
  /// The returned [EnumDefaultMix] will have its `id` field set.
  Future<EnumDefaultMix> insertRow(
    _is.DatabaseSession session,
    EnumDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnumDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EnumDefaultMix]s in the list and returns the resulting rows.
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
  /// The returned [EnumDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultMix>> upsert(
    _is.DatabaseSession session,
    List<EnumDefaultMix> rows, {
    required _is.ColumnSelections<EnumDefaultMixTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EnumDefaultMix>(
      rows,
      conflictColumns: conflictColumns(EnumDefaultMix.t),
      updateColumns: updateColumns?.call(EnumDefaultMix.t),
      updateWhere: updateWhere?.call(EnumDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EnumDefaultMix] and returns the resulting row.
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
  /// The returned [EnumDefaultMix] will have its `id` field set.
  Future<EnumDefaultMix?> upsertRow(
    _is.DatabaseSession session,
    EnumDefaultMix row, {
    required _is.ColumnSelections<EnumDefaultMixTable> conflictColumns,
    _is.ColumnSelections<EnumDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<EnumDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EnumDefaultMix>(
      row,
      conflictColumns: conflictColumns(EnumDefaultMix.t),
      updateColumns: updateColumns?.call(EnumDefaultMix.t),
      updateWhere: updateWhere?.call(EnumDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultMix>> update(
    _is.DatabaseSession session,
    List<EnumDefaultMix> rows, {
    _is.ColumnSelections<EnumDefaultMixTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EnumDefaultMix>(
      rows,
      columns: columns?.call(EnumDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EnumDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EnumDefaultMix> updateRow(
    _is.DatabaseSession session,
    EnumDefaultMix row, {
    _is.ColumnSelections<EnumDefaultMixTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnumDefaultMix>(
      row,
      columns: columns?.call(EnumDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnumDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EnumDefaultMix?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<EnumDefaultMixUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EnumDefaultMix>(
      id,
      columnValues: columnValues(EnumDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EnumDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EnumDefaultMix>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EnumDefaultMixUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EnumDefaultMixTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EnumDefaultMix>(
      columnValues: columnValues(EnumDefaultMix.t.updateTable),
      where: where(EnumDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EnumDefaultMix]s in the list and returns the deleted rows.
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
  Future<List<EnumDefaultMix>> delete(
    _is.DatabaseSession session,
    List<EnumDefaultMix> rows, {
    _is.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EnumDefaultMix>(
      rows,
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EnumDefaultMix].
  Future<EnumDefaultMix> deleteRow(
    _is.DatabaseSession session,
    EnumDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnumDefaultMix>(
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
  Future<List<EnumDefaultMix>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultMixTable> where,
    _is.OrderByBuilder<EnumDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<EnumDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EnumDefaultMix>(
      where: where(EnumDefaultMix.t),
      orderBy: orderBy?.call(EnumDefaultMix.t),
      orderByList: orderByList?.call(EnumDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EnumDefaultMixTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EnumDefaultMix>(
      where: where?.call(EnumDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EnumDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EnumDefaultMixTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EnumDefaultMix>(
      where: where(EnumDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
