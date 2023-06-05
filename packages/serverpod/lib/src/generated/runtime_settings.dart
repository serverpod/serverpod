/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

typedef RuntimeSettingsExpressionBuilder = _i1.Expression Function(
    RuntimeSettingsTable);

/// Runtime settings of the server.
abstract class RuntimeSettings extends _i1.TableRow {
  const RuntimeSettings._();

  const factory RuntimeSettings({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i2.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) = _RuntimeSettings;

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

  static const t = RuntimeSettingsTable();

  RuntimeSettings copyWith({
    int? id,
    _i2.LogSettings? logSettings,
    List<_i2.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  });
  @override
  String get tableName => 'serverpod_runtime_settings';
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
  }) async {
    return session.db.findSingleRow<RuntimeSettings>(
      where: where != null ? where(RuntimeSettings.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<RuntimeSettings?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<RuntimeSettings>(id);
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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<RuntimeSettings> insert(
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

  /// Log settings.
  _i2.LogSettings get logSettings;

  /// List of log setting overrides.
  List<_i2.LogSettingsOverride> get logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool get logServiceCalls;

  /// True if malformed calls should be logged.
  bool get logMalformedCalls;
}

class _Undefined {}

/// Runtime settings of the server.
class _RuntimeSettings extends RuntimeSettings {
  const _RuntimeSettings({
    int? id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  }) : super._();

  /// Log settings.
  @override
  final _i2.LogSettings logSettings;

  /// List of log setting overrides.
  @override
  final List<_i2.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  @override
  final bool logServiceCalls;

  /// True if malformed calls should be logged.
  @override
  final bool logMalformedCalls;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is RuntimeSettings &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.logSettings,
                  logSettings,
                ) ||
                other.logSettings == logSettings) &&
            (identical(
                  other.logServiceCalls,
                  logServiceCalls,
                ) ||
                other.logServiceCalls == logServiceCalls) &&
            (identical(
                  other.logMalformedCalls,
                  logMalformedCalls,
                ) ||
                other.logMalformedCalls == logMalformedCalls) &&
            const _i3.DeepCollectionEquality().equals(
              logSettingsOverrides,
              other.logSettingsOverrides,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        logSettings,
        logServiceCalls,
        logMalformedCalls,
        const _i3.DeepCollectionEquality().hash(logSettingsOverrides),
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
      id: id == _Undefined ? this.id : (id as int?),
      logSettings: logSettings ?? this.logSettings,
      logSettingsOverrides: logSettingsOverrides ?? this.logSettingsOverrides,
      logServiceCalls: logServiceCalls ?? this.logServiceCalls,
      logMalformedCalls: logMalformedCalls ?? this.logMalformedCalls,
    );
  }
}

class RuntimeSettingsTable extends _i1.Table {
  const RuntimeSettingsTable() : super(tableName: 'serverpod_runtime_settings');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// Log settings.
  final logSettings = const _i1.ColumnSerializable('logSettings');

  /// List of log setting overrides.
  final logSettingsOverrides =
      const _i1.ColumnSerializable('logSettingsOverrides');

  /// True if service calls to Serverpod Insights should be logged.
  final logServiceCalls = const _i1.ColumnBool('logServiceCalls');

  /// True if malformed calls should be logged.
  final logMalformedCalls = const _i1.ColumnBool('logMalformedCalls');

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
RuntimeSettingsTable tRuntimeSettings = const RuntimeSettingsTable();
