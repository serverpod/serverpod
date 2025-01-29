/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'log_settings.dart' as _i2;
import 'log_settings_override.dart' as _i3;

/// Runtime settings of the server.
abstract class RuntimeSettings
    implements _i1.TableRow, _i1.ProtocolSerialization {
  RuntimeSettings._({
    this.id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  });

  factory RuntimeSettings({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i3.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) = _RuntimeSettingsImpl;

  factory RuntimeSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return RuntimeSettings(
      id: jsonSerialization['id'] as int?,
      logSettings: _i2.LogSettings.fromJson(
          (jsonSerialization['logSettings'] as Map<String, dynamic>)),
      logSettingsOverrides: (jsonSerialization['logSettingsOverrides'] as List)
          .map((e) =>
              _i3.LogSettingsOverride.fromJson((e as Map<String, dynamic>)))
          .toList(),
      logServiceCalls: jsonSerialization['logServiceCalls'] as bool,
      logMalformedCalls: jsonSerialization['logMalformedCalls'] as bool,
    );
  }

  static final t = RuntimeSettingsTable();

  static const db = RuntimeSettingsRepository._();

  @override
  int? id;

  /// Log settings.
  _i2.LogSettings logSettings;

  /// List of log setting overrides.
  List<_i3.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool logServiceCalls;

  /// True if malformed calls should be logged.
  bool logMalformedCalls;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [RuntimeSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RuntimeSettings copyWith({
    int? id,
    _i2.LogSettings? logSettings,
    List<_i3.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'logSettings': logSettings.toJson(),
      'logSettingsOverrides':
          logSettingsOverrides.toJson(valueToJson: (v) => v.toJson()),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'logSettings': logSettings.toJsonForProtocol(),
      'logSettingsOverrides': logSettingsOverrides.toJson(
          valueToJson: (v) => v.toJsonForProtocol()),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  static RuntimeSettingsInclude include() {
    return RuntimeSettingsInclude._();
  }

  static RuntimeSettingsIncludeList includeList({
    _i1.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    RuntimeSettingsInclude? include,
  }) {
    return RuntimeSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RuntimeSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RuntimeSettingsImpl extends RuntimeSettings {
  _RuntimeSettingsImpl({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i3.LogSettingsOverride> logSettingsOverrides,
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
  @_i1.useResult
  @override
  RuntimeSettings copyWith({
    Object? id = _Undefined,
    _i2.LogSettings? logSettings,
    List<_i3.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  }) {
    return RuntimeSettings(
      id: id is int? ? id : this.id,
      logSettings: logSettings ?? this.logSettings.copyWith(),
      logSettingsOverrides: logSettingsOverrides ??
          this.logSettingsOverrides.map((e0) => e0.copyWith()).toList(),
      logServiceCalls: logServiceCalls ?? this.logServiceCalls,
      logMalformedCalls: logMalformedCalls ?? this.logMalformedCalls,
    );
  }
}

class RuntimeSettingsTable extends _i1.Table {
  RuntimeSettingsTable({super.tableRelation})
      : super(tableName: 'serverpod_runtime_settings') {
    logSettings = _i1.ColumnSerializable(
      'logSettings',
      this,
    );
    logSettingsOverrides = _i1.ColumnSerializable(
      'logSettingsOverrides',
      this,
    );
    logServiceCalls = _i1.ColumnBool(
      'logServiceCalls',
      this,
    );
    logMalformedCalls = _i1.ColumnBool(
      'logMalformedCalls',
      this,
    );
  }

  /// Log settings.
  late final _i1.ColumnSerializable logSettings;

  /// List of log setting overrides.
  late final _i1.ColumnSerializable logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  late final _i1.ColumnBool logServiceCalls;

  /// True if malformed calls should be logged.
  late final _i1.ColumnBool logMalformedCalls;

  @override
  List<_i1.Column> get columns => [
        id,
        logSettings,
        logSettingsOverrides,
        logServiceCalls,
        logMalformedCalls,
      ];
}

class RuntimeSettingsInclude extends _i1.IncludeObject {
  RuntimeSettingsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => RuntimeSettings.t;
}

class RuntimeSettingsIncludeList extends _i1.IncludeList {
  RuntimeSettingsIncludeList._({
    _i1.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RuntimeSettings.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => RuntimeSettings.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<RuntimeSettings>(
      where: where?.call(RuntimeSettings.t),
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? offset,
    _i1.OrderByBuilder<RuntimeSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RuntimeSettingsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<RuntimeSettings>(
      where: where?.call(RuntimeSettings.t),
      orderBy: orderBy?.call(RuntimeSettings.t),
      orderByList: orderByList?.call(RuntimeSettings.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [RuntimeSettings] by its [id] or null if no such row exists.
  Future<RuntimeSettings?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<RuntimeSettings>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [RuntimeSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [RuntimeSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<RuntimeSettings>> insert(
    _i1.Session session,
    List<RuntimeSettings> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RuntimeSettings>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RuntimeSettings] and returns the inserted row.
  ///
  /// The returned [RuntimeSettings] will have its `id` field set.
  Future<RuntimeSettings> insertRow(
    _i1.Session session,
    RuntimeSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RuntimeSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RuntimeSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RuntimeSettings>> update(
    _i1.Session session,
    List<RuntimeSettings> rows, {
    _i1.ColumnSelections<RuntimeSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RuntimeSettings>(
      rows,
      columns: columns?.call(RuntimeSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RuntimeSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RuntimeSettings> updateRow(
    _i1.Session session,
    RuntimeSettings row, {
    _i1.ColumnSelections<RuntimeSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RuntimeSettings>(
      row,
      columns: columns?.call(RuntimeSettings.t),
      transaction: transaction,
    );
  }

  /// Deletes all [RuntimeSettings]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RuntimeSettings>> delete(
    _i1.Session session,
    List<RuntimeSettings> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RuntimeSettings>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RuntimeSettings].
  Future<RuntimeSettings> deleteRow(
    _i1.Session session,
    RuntimeSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RuntimeSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RuntimeSettings>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RuntimeSettingsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RuntimeSettings>(
      where: where(RuntimeSettings.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RuntimeSettingsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RuntimeSettings>(
      where: where?.call(RuntimeSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
