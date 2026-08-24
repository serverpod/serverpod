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
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;
import 'log_settings.dart' as _illv0ea4;
import 'log_settings_override.dart' as _i5sjxqb6;

/// Runtime settings of the server.
abstract class RuntimeSettings
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RuntimeSettings._({
    this.id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  });

  factory RuntimeSettings({
    int? id,
    required _illv0ea4.LogSettings logSettings,
    required List<_i5sjxqb6.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) = _RuntimeSettingsImpl;

  factory RuntimeSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return RuntimeSettings(
      id: jsonSerialization['id'] as int?,
      logSettings: _ic00rqxb.Protocol().deserialize<_illv0ea4.LogSettings>(
        jsonSerialization['logSettings'],
      ),
      logSettingsOverrides: _ic00rqxb.Protocol()
          .deserialize<List<_i5sjxqb6.LogSettingsOverride>>(
            jsonSerialization['logSettingsOverrides'],
          ),
      logServiceCalls: _is.BoolJsonExtension.fromJson(
        jsonSerialization['logServiceCalls'],
      ),
      logMalformedCalls: _is.BoolJsonExtension.fromJson(
        jsonSerialization['logMalformedCalls'],
      ),
    );
  }

  static final t = RuntimeSettingsTable();

  static const db = RuntimeSettingsRepository._();

  @override
  int? id;

  /// Log settings.
  _illv0ea4.LogSettings logSettings;

  /// List of log setting overrides.
  List<_i5sjxqb6.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool logServiceCalls;

  /// True if malformed calls should be logged.
  bool logMalformedCalls;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RuntimeSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RuntimeSettings copyWith({
    int? id,
    _illv0ea4.LogSettings? logSettings,
    List<_i5sjxqb6.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.RuntimeSettings',
      if (id != null) 'id': id,
      'logSettings': logSettings.toJson(),
      'logSettingsOverrides': logSettingsOverrides.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.RuntimeSettings',
      if (id != null) 'id': id,
      'logSettings': logSettings.toJsonForProtocol(),
      'logSettingsOverrides': logSettingsOverrides.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  static RuntimeSettingsInclude include({
    _is.SelectColumnsBuilder<RuntimeSettingsTable>? select,
  }) {
    return RuntimeSettingsInclude.internal_(
      selectedColumns: select?.call(RuntimeSettings.t),
    );
  }

  static RuntimeSettingsIncludeList includeList({
    _is.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    _is.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    RuntimeSettingsInclude? include,
    _is.SelectColumnsBuilder<RuntimeSettingsTable>? select,
  }) {
    return RuntimeSettingsIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      include: include,
      selectedColumns: select?.call(RuntimeSettings.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RuntimeSettingsImpl extends RuntimeSettings {
  _RuntimeSettingsImpl({
    int? id,
    required _illv0ea4.LogSettings logSettings,
    required List<_i5sjxqb6.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) : super._(
         id: id,
         logSettings: logSettings,
         logSettingsOverrides: logSettingsOverrides,
         logServiceCalls: logServiceCalls,
         logMalformedCalls: logMalformedCalls,
       );

  /// Returns a shallow copy of this [RuntimeSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RuntimeSettings copyWith({
    Object? id = _Undefined,
    _illv0ea4.LogSettings? logSettings,
    List<_i5sjxqb6.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  }) {
    return RuntimeSettings(
      id: id is int? ? id : this.id,
      logSettings: logSettings ?? this.logSettings.copyWith(),
      logSettingsOverrides:
          logSettingsOverrides ??
          this.logSettingsOverrides.map((e0) => e0.copyWith()).toList(),
      logServiceCalls: logServiceCalls ?? this.logServiceCalls,
      logMalformedCalls: logMalformedCalls ?? this.logMalformedCalls,
    );
  }
}

class RuntimeSettingsUpdateTable extends _is.UpdateTable<RuntimeSettingsTable> {
  RuntimeSettingsUpdateTable(super.table);

  _is.ColumnValue<_illv0ea4.LogSettings, _illv0ea4.LogSettings> logSettings(
    _illv0ea4.LogSettings value,
  ) => _is.ColumnValue(
    table.logSettings,
    value,
  );

  _is.ColumnValue<
    List<_i5sjxqb6.LogSettingsOverride>,
    List<_i5sjxqb6.LogSettingsOverride>
  >
  logSettingsOverrides(List<_i5sjxqb6.LogSettingsOverride> value) =>
      _is.ColumnValue(
        table.logSettingsOverrides,
        value,
      );

  _is.ColumnValue<bool, bool> logServiceCalls(bool value) => _is.ColumnValue(
    table.logServiceCalls,
    value,
  );

  _is.ColumnValue<bool, bool> logMalformedCalls(bool value) => _is.ColumnValue(
    table.logMalformedCalls,
    value,
  );
}

class RuntimeSettingsTable extends _is.Table<int?> {
  RuntimeSettingsTable({super.tableRelation})
    : super(tableName: 'serverpod_runtime_settings') {
    updateTable = RuntimeSettingsUpdateTable(this);
    logSettings = _is.ColumnSerializable<_illv0ea4.LogSettings>(
      'logSettings',
      this,
    );
    logSettingsOverrides =
        _is.ColumnSerializable<List<_i5sjxqb6.LogSettingsOverride>>(
          'logSettingsOverrides',
          this,
        );
    logServiceCalls = _is.ColumnBool(
      'logServiceCalls',
      this,
    );
    logMalformedCalls = _is.ColumnBool(
      'logMalformedCalls',
      this,
    );
  }

  late final RuntimeSettingsUpdateTable updateTable;

  /// Log settings.
  late final _is.ColumnSerializable<_illv0ea4.LogSettings> logSettings;

  /// List of log setting overrides.
  late final _is.ColumnSerializable<List<_i5sjxqb6.LogSettingsOverride>>
  logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  late final _is.ColumnBool logServiceCalls;

  /// True if malformed calls should be logged.
  late final _is.ColumnBool logMalformedCalls;

  @override
  List<_is.Column> get columns => [
    id,
    logSettings,
    logSettingsOverrides,
    logServiceCalls,
    logMalformedCalls,
  ];
}

class RuntimeSettingsInclude extends _is.IncludeObject {
  RuntimeSettingsInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RuntimeSettings.t;
}

class RuntimeSettingsIncludeList extends _is.IncludeList {
  RuntimeSettingsIncludeList.internal_({
    _is.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(RuntimeSettings.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RuntimeSettings.t;
}

class RuntimeSettingsRepository {
  const RuntimeSettingsRepository._();

  /// Returns a list of [RuntimeSettings]s matching the given query parameters.
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
  Future<List<RuntimeSettings>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    _is.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RuntimeSettings>(
      where: where?.call(RuntimeSettings.t),
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RuntimeSettings] matching the given query parameters.
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
  Future<RuntimeSettings?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? offset,
    _is.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    _is.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RuntimeSettings>(
      where: where?.call(RuntimeSettings.t),
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RuntimeSettings] by its [id] or null if no such row exists.
  Future<RuntimeSettings?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RuntimeSettings>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RuntimeSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [RuntimeSettings]s will have their `id` fields set.
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
  Future<List<RuntimeSettings>> insert(
    _is.DatabaseSession session,
    List<RuntimeSettings> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RuntimeSettings>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RuntimeSettings] and returns the inserted row.
  ///
  /// The returned [RuntimeSettings] will have its `id` field set.
  Future<RuntimeSettings> insertRow(
    _is.DatabaseSession session,
    RuntimeSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RuntimeSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RuntimeSettings]s in the list and returns the resulting rows.
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
  /// The returned [RuntimeSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RuntimeSettings>> upsert(
    _is.DatabaseSession session,
    List<RuntimeSettings> rows, {
    required _is.ColumnSelections<RuntimeSettingsTable> conflictColumns,
    _is.ColumnSelections<RuntimeSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<RuntimeSettingsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RuntimeSettings>(
      rows,
      conflictColumns: conflictColumns(RuntimeSettings.t),
      updateColumns: updateColumns?.call(RuntimeSettings.t),
      updateWhere: updateWhere?.call(RuntimeSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RuntimeSettings] and returns the resulting row.
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
  /// The returned [RuntimeSettings] will have its `id` field set.
  Future<RuntimeSettings?> upsertRow(
    _is.DatabaseSession session,
    RuntimeSettings row, {
    required _is.ColumnSelections<RuntimeSettingsTable> conflictColumns,
    _is.ColumnSelections<RuntimeSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<RuntimeSettingsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RuntimeSettings>(
      row,
      conflictColumns: conflictColumns(RuntimeSettings.t),
      updateColumns: updateColumns?.call(RuntimeSettings.t),
      updateWhere: updateWhere?.call(RuntimeSettings.t),
      transaction: transaction,
    );
  }

  /// Updates all [RuntimeSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RuntimeSettings>> update(
    _is.DatabaseSession session,
    List<RuntimeSettings> rows, {
    _is.ColumnSelections<RuntimeSettingsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RuntimeSettings>(
      rows,
      columns: columns?.call(RuntimeSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RuntimeSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RuntimeSettings> updateRow(
    _is.DatabaseSession session,
    RuntimeSettings row, {
    _is.ColumnSelections<RuntimeSettingsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RuntimeSettings>(
      row,
      columns: columns?.call(RuntimeSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RuntimeSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RuntimeSettings?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RuntimeSettingsUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RuntimeSettings>(
      id,
      columnValues: columnValues(RuntimeSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RuntimeSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RuntimeSettings>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RuntimeSettingsUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<RuntimeSettingsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    _is.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RuntimeSettings>(
      columnValues: columnValues(RuntimeSettings.t.updateTable),
      where: where(RuntimeSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RuntimeSettings]s in the list and returns the deleted rows.
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
  Future<List<RuntimeSettings>> delete(
    _is.DatabaseSession session,
    List<RuntimeSettings> rows, {
    _is.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    _is.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RuntimeSettings>(
      rows,
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RuntimeSettings].
  Future<RuntimeSettings> deleteRow(
    _is.DatabaseSession session,
    RuntimeSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RuntimeSettings>(
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
  Future<List<RuntimeSettings>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RuntimeSettingsTable> where,
    _is.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    _is.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RuntimeSettings>(
      where: where(RuntimeSettings.t),
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RuntimeSettings>(
      where: where?.call(RuntimeSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RuntimeSettings] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RuntimeSettingsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RuntimeSettings>(
      where: where(RuntimeSettings.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
