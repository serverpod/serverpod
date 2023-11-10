/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Represents a snapshot of the number of open connections the server currently
/// is handling. An entry is written every minute for each server. All health
/// data can be accessed through Serverpod Insights.
abstract class ServerHealthConnectionInfo extends _i1.TableRow {
  ServerHealthConnectionInfo._({
    int? id,
    required this.serverId,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
    required this.granularity,
  }) : super(id);

  factory ServerHealthConnectionInfo({
    int? id,
    required String serverId,
    required DateTime timestamp,
    required int active,
    required int closing,
    required int idle,
    required int granularity,
  }) = _ServerHealthConnectionInfoImpl;

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

  static final t = ServerHealthConnectionInfoTable();

  static const db = ServerHealthConnectionInfoRepository._();

  /// The server associated with this connection info.
  String serverId;

  /// The time when the connections was checked, granularity is one minute.
  DateTime timestamp;

  /// Number of active connections currently open.
  int active;

  /// Number of connections currently closing.
  int closing;

  /// Number of connections currently idle.
  int idle;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  int granularity;

  @override
  _i1.Table get table => t;

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
  @Deprecated('Will be removed in 2.0.0')
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

  @override
  Map<String, dynamic> allToJson() {
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
      case 'granularity':
        granularity = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ServerHealthConnectionInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<ServerHealthConnectionInfo?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ServerHealthConnectionInfo?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ServerHealthConnectionInfo>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ServerHealthConnectionInfo>(
      where: where(ServerHealthConnectionInfo.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
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

  static ServerHealthConnectionInfoInclude include() {
    return ServerHealthConnectionInfoInclude._();
  }

  static ServerHealthConnectionInfoIncludeList includeList({
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    ServerHealthConnectionInfoInclude? include,
  }) {
    return ServerHealthConnectionInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: include,
    );
  }
}

class _Undefined {}

class _ServerHealthConnectionInfoImpl extends ServerHealthConnectionInfo {
  _ServerHealthConnectionInfoImpl({
    int? id,
    required String serverId,
    required DateTime timestamp,
    required int active,
    required int closing,
    required int idle,
    required int granularity,
  }) : super._(
          id: id,
          serverId: serverId,
          timestamp: timestamp,
          active: active,
          closing: closing,
          idle: idle,
          granularity: granularity,
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
      id: id is int? ? id : this.id,
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
  ServerHealthConnectionInfoTable({super.tableRelation})
      : super(tableName: 'serverpod_health_connection_info') {
    serverId = _i1.ColumnString(
      'serverId',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    active = _i1.ColumnInt(
      'active',
      this,
    );
    closing = _i1.ColumnInt(
      'closing',
      this,
    );
    idle = _i1.ColumnInt(
      'idle',
      this,
    );
    granularity = _i1.ColumnInt(
      'granularity',
      this,
    );
  }

  /// The server associated with this connection info.
  late final _i1.ColumnString serverId;

  /// The time when the connections was checked, granularity is one minute.
  late final _i1.ColumnDateTime timestamp;

  /// Number of active connections currently open.
  late final _i1.ColumnInt active;

  /// Number of connections currently closing.
  late final _i1.ColumnInt closing;

  /// Number of connections currently idle.
  late final _i1.ColumnInt idle;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  late final _i1.ColumnInt granularity;

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
    ServerHealthConnectionInfoTable();

class ServerHealthConnectionInfoInclude extends _i1.IncludeObject {
  ServerHealthConnectionInfoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ServerHealthConnectionInfo.t;
}

class ServerHealthConnectionInfoIncludeList extends _i1.IncludeList {
  ServerHealthConnectionInfoIncludeList._({
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ServerHealthConnectionInfo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ServerHealthConnectionInfo.t;
}

class ServerHealthConnectionInfoRepository {
  const ServerHealthConnectionInfoRepository._();

  Future<List<ServerHealthConnectionInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServerHealthConnectionInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerHealthConnectionInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ServerHealthConnectionInfo>(
      where: where?.call(ServerHealthConnectionInfo.t),
      orderBy: orderBy?.call(ServerHealthConnectionInfo.t),
      orderByList: orderByList?.call(ServerHealthConnectionInfo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ServerHealthConnectionInfo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
    int? offset,
    _i1.OrderByBuilder<ServerHealthConnectionInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServerHealthConnectionInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ServerHealthConnectionInfo>(
      where: where?.call(ServerHealthConnectionInfo.t),
      orderBy: orderBy?.call(ServerHealthConnectionInfo.t),
      orderByList: orderByList?.call(ServerHealthConnectionInfo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ServerHealthConnectionInfo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ServerHealthConnectionInfo>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ServerHealthConnectionInfo>> insert(
    _i1.Session session,
    List<ServerHealthConnectionInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ServerHealthConnectionInfo>(
      rows,
      transaction: transaction,
    );
  }

  Future<ServerHealthConnectionInfo> insertRow(
    _i1.Session session,
    ServerHealthConnectionInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ServerHealthConnectionInfo>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ServerHealthConnectionInfo>> update(
    _i1.Session session,
    List<ServerHealthConnectionInfo> rows, {
    _i1.ColumnSelections<ServerHealthConnectionInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ServerHealthConnectionInfo>(
      rows,
      columns: columns?.call(ServerHealthConnectionInfo.t),
      transaction: transaction,
    );
  }

  Future<ServerHealthConnectionInfo> updateRow(
    _i1.Session session,
    ServerHealthConnectionInfo row, {
    _i1.ColumnSelections<ServerHealthConnectionInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ServerHealthConnectionInfo>(
      row,
      columns: columns?.call(ServerHealthConnectionInfo.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ServerHealthConnectionInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ServerHealthConnectionInfo>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ServerHealthConnectionInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ServerHealthConnectionInfo>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ServerHealthConnectionInfo>(
      where: where(ServerHealthConnectionInfo.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ServerHealthConnectionInfoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ServerHealthConnectionInfo>(
      where: where?.call(ServerHealthConnectionInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
