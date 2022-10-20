/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

class ServerHealthConnectionInfo extends _i1.TableRow {
  ServerHealthConnectionInfo({
    int? id,
    required this.serverId,
    required this.type,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
  }) : super(id);

  factory ServerHealthConnectionInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i2.SerializationManager serializationManager,
  ) {
    return ServerHealthConnectionInfo(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      type:
          serializationManager.deserializeJson<int>(jsonSerialization['type']),
      timestamp: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['timestamp']),
      active: serializationManager
          .deserializeJson<int>(jsonSerialization['active']),
      closing: serializationManager
          .deserializeJson<int>(jsonSerialization['closing']),
      idle:
          serializationManager.deserializeJson<int>(jsonSerialization['idle']),
    );
  }

  static final t = ServerHealthConnectionInfoTable();

  String serverId;

  int type;

  DateTime timestamp;

  int active;

  int closing;

  int idle;

  @override
  String get className => 'ServerHealthConnectionInfo';
  @override
  String get tableName => 'serverpod_health_connection_info';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp,
      'active': active,
      'closing': closing,
      'idle': idle,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp,
      'active': active,
      'closing': closing,
      'idle': idle,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp,
      'active': active,
      'closing': closing,
      'idle': idle,
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
      case 'serverId':
        serverId = value;
        return;
      case 'type':
        type = value;
        return;
      case 'timestamp':
        timestamp = value;
        return;
      case 'active':
        active = value;
        return;
      case 'closing':
        closing = value;
        return;
      case 'idle':
        idle = value;
        return;
      default:
        throw UnimplementedError();
    }
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
}

typedef ServerHealthConnectionInfoExpressionBuilder = _i1.Expression Function(
    ServerHealthConnectionInfoTable);

class ServerHealthConnectionInfoTable extends _i1.Table {
  ServerHealthConnectionInfoTable()
      : super(tableName: 'serverpod_health_connection_info');

  final id = _i1.ColumnInt('id');

  final serverId = _i1.ColumnString('serverId');

  final type = _i1.ColumnInt('type');

  final timestamp = _i1.ColumnDateTime('timestamp');

  final active = _i1.ColumnInt('active');

  final closing = _i1.ColumnInt('closing');

  final idle = _i1.ColumnInt('idle');

  @override
  List<_i1.Column> get columns => [
        id,
        serverId,
        type,
        timestamp,
        active,
        closing,
        idle,
      ];
}

@Deprecated('Use ServerHealthConnectionInfoTable.t instead.')
ServerHealthConnectionInfoTable tServerHealthConnectionInfo =
    ServerHealthConnectionInfoTable();
