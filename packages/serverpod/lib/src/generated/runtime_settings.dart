/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

/// Runtime settings of the server.
class RuntimeSettings extends _i1.TableRow {
  RuntimeSettings({
    int? id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  }) : super(id);

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

  /// Log settings.
  _i2.LogSettings logSettings;

  /// List of log setting overrides.
  List<_i2.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool logServiceCalls;

  /// True if malformed calls should be logged.
  bool logMalformedCalls;

  @override
  String get tableName => 'serverpod_runtime_settings';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logSettings': logSettings,
      'logSettingsOverrides': logSettingsOverrides,
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'logSettings': logSettings,
      'logSettingsOverrides': logSettingsOverrides,
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'logSettings': logSettings,
      'logSettingsOverrides': logSettingsOverrides,
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'logSettings':
        logSettings = value;
        return;
      case 'logSettingsOverrides':
        logSettingsOverrides = value;
        return;
      case 'logServiceCalls':
        logServiceCalls = value;
        return;
      case 'logMalformedCalls':
        logMalformedCalls = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<RuntimeSettings>> find(
    _i1.Session session, {
    RuntimeSettingsExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    RuntimeSettingsInclude? include,
  }) async {
    return session.db.find<RuntimeSettings>(
      where: where != null ? where(RuntimeSettings.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<RuntimeSettings?> findSingleRow(
    _i1.Session session, {
    RuntimeSettingsExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    RuntimeSettingsInclude? include,
  }) async {
    return session.db.findSingleRow<RuntimeSettings>(
      where: where != null ? where(RuntimeSettings.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<RuntimeSettings?> findById(
    _i1.Session session,
    int id, {
    RuntimeSettingsInclude? include,
  }) async {
    return session.db.findById<RuntimeSettings>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required RuntimeSettingsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RuntimeSettings>(
      where: where(RuntimeSettings.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    RuntimeSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    RuntimeSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    RuntimeSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    RuntimeSettingsExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RuntimeSettings>(
      where: where != null ? where(RuntimeSettings.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef RuntimeSettingsExpressionBuilder = _i1.Expression Function(
    RuntimeSettingsTable);

class RuntimeSettingsTable extends _i1.Table {
  RuntimeSettingsTable() : super(tableName: 'serverpod_runtime_settings');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  /// Log settings.
  final logSettings = _i1.ColumnSerializable('logSettings');

  /// List of log setting overrides.
  final logSettingsOverrides = _i1.ColumnSerializable('logSettingsOverrides');

  /// True if service calls to Serverpod Insights should be logged.
  final logServiceCalls = _i1.ColumnBool('logServiceCalls');

  /// True if malformed calls should be logged.
  final logMalformedCalls = _i1.ColumnBool('logMalformedCalls');

  @override
  List<_i1.Column> get columns => [
        id,
        logSettings,
        logSettingsOverrides,
        logServiceCalls,
        logMalformedCalls,
      ];
}

@Deprecated('Use RuntimeSettingsTable.t instead.')
RuntimeSettingsTable tRuntimeSettings = RuntimeSettingsTable();

class RuntimeSettingsInclude extends _i1.Include {
  RuntimeSettingsInclude();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => RuntimeSettings.t;
}
