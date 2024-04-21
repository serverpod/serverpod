/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Runtime settings of the server.
abstract class RuntimeSettings extends _i1.TableRow {
  RuntimeSettings._({
    int? id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  }) : super(id);

  factory RuntimeSettings({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i2.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) = _RuntimeSettingsImpl;

  factory RuntimeSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return RuntimeSettings(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      logSettings: serializationManager
          .deserialize<_i2.LogSettings>(jsonSerialization['logSettings']),
      logSettingsOverrides:
          serializationManager.deserialize<List<_i2.LogSettingsOverride>>(
              jsonSerialization['logSettingsOverrides']),
      logServiceCalls: serializationManager
          .deserialize<bool>(jsonSerialization['logServiceCalls']),
      logMalformedCalls: serializationManager
          .deserialize<bool>(jsonSerialization['logMalformedCalls']),
    );
  }

  static final t = RuntimeSettingsTable();

  static const db = RuntimeSettingsRepository._();

  /// Log settings.
  _i2.LogSettings logSettings;

  /// List of log setting overrides.
  List<_i2.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool logServiceCalls;

  /// True if malformed calls should be logged.
  bool logMalformedCalls;

  @override
  _i1.Table get table => t;

  RuntimeSettings copyWith({
    int? id,
    _i2.LogSettings? logSettings,
    List<_i2.LogSettingsOverride>? logSettingsOverrides,
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
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'logSettings': logSettings.allToJson(),
      'logSettingsOverrides':
          logSettingsOverrides.toJson(valueToJson: (v) => v.allToJson()),
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
}

class _Undefined {}

class _RuntimeSettingsImpl extends RuntimeSettings {
  _RuntimeSettingsImpl({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i2.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) : super._(
          id: id,
          logSettings: logSettings,
          logSettingsOverrides: logSettingsOverrides,
          logServiceCalls: logServiceCalls,
          logMalformedCalls: logMalformedCalls,
        );

  @override
  RuntimeSettings copyWith({
    Object? id = _Undefined,
    _i2.LogSettings? logSettings,
    List<_i2.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  }) {
    return RuntimeSettings(
      id: id is int? ? id : this.id,
      logSettings: logSettings ?? this.logSettings.copyWith(),
      logSettingsOverrides:
          logSettingsOverrides ?? this.logSettingsOverrides.clone(),
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
