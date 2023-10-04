/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Represents a snapshot of a specific health metric. An entry is written every
/// minute for each server. All health data can be accessed through Serverpod
/// Insights.
abstract class ServerHealthMetric extends _i1.TableRow {
  ServerHealthMetric._({
    int? id,
    required this.name,
    required this.serverId,
    required this.timestamp,
    required this.isHealthy,
    required this.value,
    required this.granularity,
  }) : super(id);

  factory ServerHealthMetric({
    int? id,
    required String name,
    required String serverId,
    required DateTime timestamp,
    required bool isHealthy,
    required double value,
    required int granularity,
  }) = _ServerHealthMetricImpl;

  factory ServerHealthMetric.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerHealthMetric(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      timestamp: serializationManager
          .deserialize<DateTime>(jsonSerialization['timestamp']),
      isHealthy: serializationManager
          .deserialize<bool>(jsonSerialization['isHealthy']),
      value:
          serializationManager.deserialize<double>(jsonSerialization['value']),
      granularity: serializationManager
          .deserialize<int>(jsonSerialization['granularity']),
    );
  }

  static final t = ServerHealthMetricTable();

  static const db = ServerHealthMetricRepository._();

  /// The name of the metric.
  String name;

  /// The server associated with this metric.
  String serverId;

  /// The time when the connections was checked, granularity is one minute.
  DateTime timestamp;

  /// True if the metric is healthy.
  bool isHealthy;

  /// The value of the metric.
  double value;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  int granularity;

  @override
  _i1.Table get table => t;

  ServerHealthMetric copyWith({
    int? id,
    String? name,
    String? serverId,
    DateTime? timestamp,
    bool? isHealthy,
    double? value,
    int? granularity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp,
      'isHealthy': isHealthy,
      'value': value,
      'granularity': granularity,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp,
      'isHealthy': isHealthy,
      'value': value,
      'granularity': granularity,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp,
      'isHealthy': isHealthy,
      'value': value,
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
      case 'name':
        name = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'timestamp':
        timestamp = value;
        return;
      case 'isHealthy':
        isHealthy = value;
        return;
      case 'value':
        value = value;
        return;
      case 'granularity':
        granularity = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<ServerHealthMetric>> find(
    _i1.Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ServerHealthMetric>(
      where: where != null ? where(ServerHealthMetric.t) : null,
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
  static Future<ServerHealthMetric?> findSingleRow(
    _i1.Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ServerHealthMetric>(
      where: where != null ? where(ServerHealthMetric.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<ServerHealthMetric?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ServerHealthMetric>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required ServerHealthMetricExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ServerHealthMetric>(
      where: where(ServerHealthMetric.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    ServerHealthMetric row, {
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
    ServerHealthMetric row, {
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
    ServerHealthMetric row, {
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
    ServerHealthMetricExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ServerHealthMetric>(
      where: where != null ? where(ServerHealthMetric.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ServerHealthMetricInclude include() {
    return ServerHealthMetricInclude._();
  }
}

class _Undefined {}

class _ServerHealthMetricImpl extends ServerHealthMetric {
  _ServerHealthMetricImpl({
    int? id,
    required String name,
    required String serverId,
    required DateTime timestamp,
    required bool isHealthy,
    required double value,
    required int granularity,
  }) : super._(
          id: id,
          name: name,
          serverId: serverId,
          timestamp: timestamp,
          isHealthy: isHealthy,
          value: value,
          granularity: granularity,
        );

  @override
  ServerHealthMetric copyWith({
    Object? id = _Undefined,
    String? name,
    String? serverId,
    DateTime? timestamp,
    bool? isHealthy,
    double? value,
    int? granularity,
  }) {
    return ServerHealthMetric(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      serverId: serverId ?? this.serverId,
      timestamp: timestamp ?? this.timestamp,
      isHealthy: isHealthy ?? this.isHealthy,
      value: value ?? this.value,
      granularity: granularity ?? this.granularity,
    );
  }
}

typedef ServerHealthMetricExpressionBuilder = _i1.Expression Function(
    ServerHealthMetricTable);

class ServerHealthMetricTable extends _i1.Table {
  ServerHealthMetricTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_health_metric') {
    name = _i1.ColumnString(
      'name',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    serverId = _i1.ColumnString(
      'serverId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    isHealthy = _i1.ColumnBool(
      'isHealthy',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    value = _i1.ColumnDouble(
      'value',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    granularity = _i1.ColumnInt(
      'granularity',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The name of the metric.
  late final _i1.ColumnString name;

  /// The server associated with this metric.
  late final _i1.ColumnString serverId;

  /// The time when the connections was checked, granularity is one minute.
  late final _i1.ColumnDateTime timestamp;

  /// True if the metric is healthy.
  late final _i1.ColumnBool isHealthy;

  /// The value of the metric.
  late final _i1.ColumnDouble value;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  late final _i1.ColumnInt granularity;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        serverId,
        timestamp,
        isHealthy,
        value,
        granularity,
      ];
}

@Deprecated('Use ServerHealthMetricTable.t instead.')
ServerHealthMetricTable tServerHealthMetric = ServerHealthMetricTable();

class ServerHealthMetricInclude extends _i1.Include {
  ServerHealthMetricInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ServerHealthMetric.t;
}

class ServerHealthMetricRepository {
  const ServerHealthMetricRepository._();

  Future<List<ServerHealthMetric>> find(
    _i1.Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ServerHealthMetric>(
      where: where?.call(ServerHealthMetric.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<ServerHealthMetric?> findRow(
    _i1.Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<ServerHealthMetric>(
      where: where?.call(ServerHealthMetric.t),
      transaction: transaction,
    );
  }

  Future<ServerHealthMetric?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ServerHealthMetric>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ServerHealthMetric>> insert(
    _i1.Session session,
    List<ServerHealthMetric> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ServerHealthMetric>(
      rows,
      transaction: transaction,
    );
  }

  Future<ServerHealthMetric> insertRow(
    _i1.Session session,
    ServerHealthMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ServerHealthMetric>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ServerHealthMetric>> update(
    _i1.Session session,
    List<ServerHealthMetric> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ServerHealthMetric>(
      rows,
      transaction: transaction,
    );
  }

  Future<ServerHealthMetric> updateRow(
    _i1.Session session,
    ServerHealthMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ServerHealthMetric>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ServerHealthMetric> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ServerHealthMetric>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ServerHealthMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ServerHealthMetric>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required ServerHealthMetricExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ServerHealthMetric>(
      where: where(ServerHealthMetric.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ServerHealthMetric>(
      where: where?.call(ServerHealthMetric.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
