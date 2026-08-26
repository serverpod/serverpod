/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../models_with_relations/one_to_one/citizen.dart' as _igho3lba;

abstract class Town implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Town._({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory Town({
    int? id,
    required String name,
    int? mayorId,
    _igho3lba.Citizen? mayor,
  }) = _TownImpl;

  factory Town.fromJson(Map<String, dynamic> jsonSerialization) {
    return Town(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      mayorId: jsonSerialization['mayorId'] as int?,
      mayor: jsonSerialization['mayor'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_igho3lba.Citizen>(
              jsonSerialization['mayor'],
            ),
    );
  }

  static final t = TownTable();

  static const db = TownRepository._();

  @override
  int? id;

  String name;

  int? mayorId;

  _igho3lba.Citizen? mayor;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Town]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Town copyWith({
    int? id,
    String? name,
    int? mayorId,
    _igho3lba.Citizen? mayor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Town',
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Town',
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [TownInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static TownInclude include({_igho3lba.CitizenInclude? mayor}) {
    return TownInclude._(mayor: mayor);
  }

  /// Builds a complete [TownIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static TownIncludeList includeList({
    _isd.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    TownInclude? include,
  }) {
    return TownIncludeList._(
      where: where?.call(Town.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [TownJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static TownJsonInclude includeJson({
    _igho3lba.CitizenJsonInclude? mayor,
    _isd.SelectColumnsBuilder<TownTable>? select,
  }) {
    return _TownJsonInclude._(
      mayor: mayor,
      selectedColumns: select?.call(Town.t),
    );
  }

  /// Builds a JSON-compatible [TownJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static TownJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    TownJsonInclude? include,
    _isd.SelectColumnsBuilder<TownTable>? select,
  }) {
    return _TownJsonIncludeList._(
      where: where?.call(Town.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      include: include,
      selectedColumns: select?.call(Town.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TownImpl extends Town {
  _TownImpl({
    int? id,
    required String name,
    int? mayorId,
    _igho3lba.Citizen? mayor,
  }) : super._(
         id: id,
         name: name,
         mayorId: mayorId,
         mayor: mayor,
       );

  /// Returns a shallow copy of this [Town]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Town copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return Town(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _igho3lba.Citizen? ? mayor : this.mayor?.copyWith(),
    );
  }
}

class TownUpdateTable extends _isd.UpdateTable<TownTable> {
  TownUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );

  _isd.ColumnValue<int, int> mayorId(int? value) => _isd.ColumnValue(
    table.mayorId,
    value,
  );
}

class TownTable extends _isd.Table<int?> {
  TownTable({super.tableRelation}) : super(tableName: 'town') {
    updateTable = TownUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
    mayorId = _isd.ColumnInt(
      'mayorId',
      this,
    );
  }

  late final TownUpdateTable updateTable;

  late final _isd.ColumnString name;

  late final _isd.ColumnInt mayorId;

  _igho3lba.CitizenTable? _mayor;

  _igho3lba.CitizenTable get mayor {
    if (_mayor != null) return _mayor!;
    _mayor = _isd.createRelationTable(
      relationFieldName: 'mayor',
      field: Town.t.mayorId,
      foreignField: _igho3lba.Citizen.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _igho3lba.CitizenTable(tableRelation: foreignTableRelation),
    );
    return _mayor!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    name,
    mayorId,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'mayor') {
      return mayor;
    }
    return null;
  }
}

abstract interface class TownJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class TownJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class TownInclude extends _isd.IncludeObject
    implements TownJsonInclude, _isd.FullModelInclude {
  TownInclude._({_igho3lba.CitizenInclude? mayor}) {
    _mayor = mayor;
  }

  _igho3lba.CitizenInclude? _mayor;

  @override
  Map<String, _isd.Include?> get includes => {'mayor': _mayor};

  @override
  _isd.Table<int?> get table => Town.t;
}

final class TownIncludeList extends _isd.IncludeList
    implements TownJsonIncludeList, _isd.FullModelInclude {
  TownIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    TownInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Town.t;
}

final class _TownJsonInclude extends _isd.IncludeObject
    implements TownJsonInclude {
  _TownJsonInclude._({
    _igho3lba.CitizenJsonInclude? mayor,
    this.selectedColumns,
  }) {
    _mayor = mayor;
  }

  _igho3lba.CitizenJsonInclude? _mayor;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {'mayor': _mayor};

  @override
  _isd.Table<int?> get table => Town.t;
}

final class _TownJsonIncludeList extends _isd.IncludeList
    implements TownJsonIncludeList {
  _TownJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    TownJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Town.t;
}

class TownRepository {
  const TownRepository._();

  final attachRow = const TownAttachRowRepository._();

  final detachRow = const TownDetachRowRepository._();

  /// Returns a list of [Town]s matching the given query parameters.
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
  Future<List<Town>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    _isd.Transaction? transaction,
    TownInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Town>(
      where: where?.call(Town.t),
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Town] matching the given query parameters.
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
  Future<Town?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TownTable>? where,
    int? offset,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    _isd.Transaction? transaction,
    TownInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Town>(
      where: where?.call(Town.t),
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Town] by its [id] or null if no such row exists.
  Future<Town?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    TownInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Town>(
      id,
      transaction: transaction,
      include: include,
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    _isd.Transaction? transaction,
    TownJsonInclude? include,
    _isd.SelectColumnsBuilder<TownTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Town>(
      where: where?.call(Town.t),
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Town.t),
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TownTable>? where,
    int? offset,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    _isd.Transaction? transaction,
    TownJsonInclude? include,
    _isd.SelectColumnsBuilder<TownTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Town>(
      where: where?.call(Town.t),
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Town.t),
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
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    TownJsonInclude? include,
    _isd.SelectColumnsBuilder<TownTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Town>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Town.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Town]s in the list and returns the inserted rows.
  ///
  /// The returned [Town]s will have their `id` fields set.
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
  Future<List<Town>> insert(
    _isd.DatabaseSession session,
    List<Town> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Town>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Town] and returns the inserted row.
  ///
  /// The returned [Town] will have its `id` field set.
  Future<Town> insertRow(
    _isd.DatabaseSession session,
    Town row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Town>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Town]s in the list and returns the resulting rows.
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
  /// The returned [Town]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Town>> upsert(
    _isd.DatabaseSession session,
    List<Town> rows, {
    required _isd.ColumnSelections<TownTable> conflictColumns,
    _isd.ColumnSelections<TownTable>? updateColumns,
    _isd.WhereExpressionBuilder<TownTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Town>(
      rows,
      conflictColumns: conflictColumns(Town.t),
      updateColumns: updateColumns?.call(Town.t),
      updateWhere: updateWhere?.call(Town.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Town] and returns the resulting row.
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
  /// The returned [Town] will have its `id` field set.
  Future<Town?> upsertRow(
    _isd.DatabaseSession session,
    Town row, {
    required _isd.ColumnSelections<TownTable> conflictColumns,
    _isd.ColumnSelections<TownTable>? updateColumns,
    _isd.WhereExpressionBuilder<TownTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Town>(
      row,
      conflictColumns: conflictColumns(Town.t),
      updateColumns: updateColumns?.call(Town.t),
      updateWhere: updateWhere?.call(Town.t),
      transaction: transaction,
    );
  }

  /// Updates all [Town]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Town>> update(
    _isd.DatabaseSession session,
    List<Town> rows, {
    _isd.ColumnSelections<TownTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Town>(
      rows,
      columns: columns?.call(Town.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Town]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Town> updateRow(
    _isd.DatabaseSession session,
    Town row, {
    _isd.ColumnSelections<TownTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Town>(
      row,
      columns: columns?.call(Town.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Town] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Town?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<TownUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Town>(
      id,
      columnValues: columnValues(Town.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Town]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Town>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<TownUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<TownTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Town>(
      columnValues: columnValues(Town.t.updateTable),
      where: where(Town.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Town]s in the list and returns the deleted rows.
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
  Future<List<Town>> delete(
    _isd.DatabaseSession session,
    List<Town> rows, {
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Town>(
      rows,
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Town].
  Future<Town> deleteRow(
    _isd.DatabaseSession session,
    Town row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Town>(
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
  Future<List<Town>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<TownTable> where,
    _isd.OrderByBuilder<TownTable>? orderBy,
    _isd.OrderByListBuilder<TownTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Town>(
      where: where(Town.t),
      orderBy: orderBy?.call(Town.t),
      orderByList: orderByList?.call(Town.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TownTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Town>(
      where: where?.call(Town.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Town] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<TownTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Town>(
      where: where(Town.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class TownAttachRowRepository {
  const TownAttachRowRepository._();

  /// Creates a relation between the given [Town] and [Citizen]
  /// by setting the [Town]'s foreign key `mayorId` to refer to the [Citizen].
  Future<void> mayor(
    _isd.DatabaseSession session,
    Town town,
    _igho3lba.Citizen mayor, {
    _isd.Transaction? transaction,
  }) async {
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }
    if (mayor.id == null) {
      throw ArgumentError.notNull('mayor.id');
    }

    var $town = town.copyWith(mayorId: mayor.id);
    await session.db.updateRow<Town>(
      $town,
      columns: [Town.t.mayorId],
      transaction: transaction,
    );
  }
}

class TownDetachRowRepository {
  const TownDetachRowRepository._();

  /// Detaches the relation between this [Town] and the [Citizen] set in `mayor`
  /// by setting the [Town]'s foreign key `mayorId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> mayor(
    _isd.DatabaseSession session,
    Town town, {
    _isd.Transaction? transaction,
  }) async {
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }

    var $town = town.copyWith(mayorId: null);
    await session.db.updateRow<Town>(
      $town,
      columns: [Town.t.mayorId],
      transaction: transaction,
    );
  }
}
