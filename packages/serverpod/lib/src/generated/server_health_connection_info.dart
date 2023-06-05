/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ServerHealthConnectionInfoExpressionBuilder = _i1.Expression Function(
    ServerHealthConnectionInfoTable);

/// Represents a snapshot of the number of open connections the server currently
/// is handling. An entry is written every minute for each server. All health
/// data can be accessed through Serverpod Insights.
abstract class ServerHealthConnectionInfo extends _i1.TableRow {
  const ServerHealthConnectionInfo._();

  const factory ServerHealthConnectionInfo({
    int? id,
    required String serverId,
    required DateTime timestamp,
    required int active,
    required int closing,
    required int idle,
    required int granularity,
  }) = _ServerHealthConnectionInfo;

  factory ServerHealthConnectionInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerHealthConnectionInfo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      timestamp: serializationManager
          .deserialize<DateTime>(jsonSerialization['timestamp']),
      active:
          serializationManager.deserialize<int>(jsonSerialization['active']),
      closing:
          serializationManager.deserialize<int>(jsonSerialization['closing']),
      idle: serializationManager.deserialize<int>(jsonSerialization['idle']),
      granularity: serializationManager
          .deserialize<int>(jsonSerialization['granularity']),
    );
  }

  static const t = ServerHealthConnectionInfoTable();

  ServerHealthConnectionInfo copyWith({
    int? id,
    String? serverId,
    DateTime? timestamp,
    int? active,
    int? closing,
    int? idle,
    int? granularity,
  });
  @override
  String get tableName => 'serverpod_health_connection_info';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'serverId': serverId,
      'timestamp': timestamp,
      'active': active,
      'closing': closing,
      'idle': idle,
      'granularity': granularity,
    };
  }

  static Future<List<ServerHealthConnectionInfo>> find(
    _i1.Session session, {
    ServerHealthConnectionInfoExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ServerHealthConnectionInfo>(
      where: where != null ? where(ServerHealthConnectionInfo.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ServerHealthConnectionInfo?> findSingleRow(
    _i1.Session session, {
    ServerHealthConnectionInfoExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ServerHealthConnectionInfo>(
      where: where != null ? where(ServerHealthConnectionInfo.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ServerHealthConnectionInfo?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ServerHealthConnectionInfo>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ServerHealthConnectionInfoExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ServerHealthConnectionInfo>(
      where: where(ServerHealthConnectionInfo.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ServerHealthConnectionInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ServerHealthConnectionInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ServerHealthConnectionInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ServerHealthConnectionInfoExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ServerHealthConnectionInfo>(
      where: where != null ? where(ServerHealthConnectionInfo.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  /// The server associated with this connection info.
  String get serverId;

  /// The time when the connections was checked, granularity is one minute.
  DateTime get timestamp;

  /// Number of active connections currently open.
  int get active;

  /// Number of connections currently closing.
  int get closing;

  /// Number of connections currently idle.
  int get idle;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  int get granularity;
}

class _Undefined {}

/// Represents a snapshot of the number of open connections the server currently
/// is handling. An entry is written every minute for each server. All health
/// data can be accessed through Serverpod Insights.
class _ServerHealthConnectionInfo extends ServerHealthConnectionInfo {
  const _ServerHealthConnectionInfo({
    int? id,
    required this.serverId,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
    required this.granularity,
  }) : super._();

  /// The server associated with this connection info.
  @override
  final String serverId;

  /// The time when the connections was checked, granularity is one minute.
  @override
  final DateTime timestamp;

  /// Number of active connections currently open.
  @override
  final int active;

  /// Number of connections currently closing.
  @override
  final int closing;

  /// Number of connections currently idle.
  @override
  final int idle;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  @override
  final int granularity;

  @override
  String get tableName => 'serverpod_health_connection_info';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'timestamp': timestamp,
      'active': active,
      'closing': closing,
      'idle': idle,
      'granularity': granularity,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ServerHealthConnectionInfo &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.timestamp,
                  timestamp,
                ) ||
                other.timestamp == timestamp) &&
            (identical(
                  other.active,
                  active,
                ) ||
                other.active == active) &&
            (identical(
                  other.closing,
                  closing,
                ) ||
                other.closing == closing) &&
            (identical(
                  other.idle,
                  idle,
                ) ||
                other.idle == idle) &&
            (identical(
                  other.granularity,
                  granularity,
                ) ||
                other.granularity == granularity));
  }

  @override
  int get hashCode => Object.hash(
        id,
        serverId,
        timestamp,
        active,
        closing,
        idle,
        granularity,
      );

  @override
  ServerHealthConnectionInfo copyWith({
    Object? id = _Undefined,
    String? serverId,
    DateTime? timestamp,
    int? active,
    int? closing,
    int? idle,
    int? granularity,
  }) {
    return ServerHealthConnectionInfo(
      id: id == _Undefined ? this.id : (id as int?),
      serverId: serverId ?? this.serverId,
      timestamp: timestamp ?? this.timestamp,
      active: active ?? this.active,
      closing: closing ?? this.closing,
      idle: idle ?? this.idle,
      granularity: granularity ?? this.granularity,
    );
  }
}

class ServerHealthConnectionInfoTable extends _i1.Table {
  const ServerHealthConnectionInfoTable()
      : super(tableName: 'serverpod_health_connection_info');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The server associated with this connection info.
  final serverId = const _i1.ColumnString('serverId');

  /// The time when the connections was checked, granularity is one minute.
  final timestamp = const _i1.ColumnDateTime('timestamp');

  /// Number of active connections currently open.
  final active = const _i1.ColumnInt('active');

  /// Number of connections currently closing.
  final closing = const _i1.ColumnInt('closing');

  /// Number of connections currently idle.
  final idle = const _i1.ColumnInt('idle');

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  final granularity = const _i1.ColumnInt('granularity');

  @override
  List<_i1.Column> get columns => [
        id,
        serverId,
        timestamp,
        active,
        closing,
        idle,
        granularity,
      ];
}

@Deprecated('Use ServerHealthConnectionInfoTable.t instead.')
ServerHealthConnectionInfoTable tServerHealthConnectionInfo =
    const ServerHealthConnectionInfoTable();
