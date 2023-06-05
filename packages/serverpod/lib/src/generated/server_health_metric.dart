/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ServerHealthMetricExpressionBuilder = _i1.Expression Function(
    ServerHealthMetricTable);

/// Represents a snapshot of a specific health metric. An entry is written every
/// minute for each server. All health data can be accessed through Serverpod
/// Insights.
abstract class ServerHealthMetric extends _i1.TableRow {
  const ServerHealthMetric._();

  const factory ServerHealthMetric({
    int? id,
    required String name,
    required String serverId,
    required DateTime timestamp,
    required bool isHealthy,
    required double value,
    required int granularity,
  }) = _ServerHealthMetric;

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

  static const t = ServerHealthMetricTable();

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
  String get tableName => 'serverpod_health_metric';
  @override
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

  static Future<ServerHealthMetric?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ServerHealthMetric>(id);
  }

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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<ServerHealthMetric> insert(
    _i1.Session session,
    ServerHealthMetric row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

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

  /// The name of the metric.
  String get name;

  /// The server associated with this metric.
  String get serverId;

  /// The time when the connections was checked, granularity is one minute.
  DateTime get timestamp;

  /// True if the metric is healthy.
  bool get isHealthy;

  /// The value of the metric.
  double get value;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  int get granularity;
}

class _Undefined {}

/// Represents a snapshot of a specific health metric. An entry is written every
/// minute for each server. All health data can be accessed through Serverpod
/// Insights.
class _ServerHealthMetric extends ServerHealthMetric {
  const _ServerHealthMetric({
    int? id,
    required this.name,
    required this.serverId,
    required this.timestamp,
    required this.isHealthy,
    required this.value,
    required this.granularity,
  }) : super._();

  /// The name of the metric.
  @override
  final String name;

  /// The server associated with this metric.
  @override
  final String serverId;

  /// The time when the connections was checked, granularity is one minute.
  @override
  final DateTime timestamp;

  /// True if the metric is healthy.
  @override
  final bool isHealthy;

  /// The value of the metric.
  @override
  final double value;

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  @override
  final int granularity;

  @override
  String get tableName => 'serverpod_health_metric';
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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ServerHealthMetric &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
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
                  other.isHealthy,
                  isHealthy,
                ) ||
                other.isHealthy == isHealthy) &&
            (identical(
                  other.value,
                  value,
                ) ||
                other.value == value) &&
            (identical(
                  other.granularity,
                  granularity,
                ) ||
                other.granularity == granularity));
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        serverId,
        timestamp,
        isHealthy,
        value,
        granularity,
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
      id: id == _Undefined ? this.id : (id as int?),
      name: name ?? this.name,
      serverId: serverId ?? this.serverId,
      timestamp: timestamp ?? this.timestamp,
      isHealthy: isHealthy ?? this.isHealthy,
      value: value ?? this.value,
      granularity: granularity ?? this.granularity,
    );
  }
}

class ServerHealthMetricTable extends _i1.Table {
  const ServerHealthMetricTable() : super(tableName: 'serverpod_health_metric');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The name of the metric.
  final name = const _i1.ColumnString('name');

  /// The server associated with this metric.
  final serverId = const _i1.ColumnString('serverId');

  /// The time when the connections was checked, granularity is one minute.
  final timestamp = const _i1.ColumnDateTime('timestamp');

  /// True if the metric is healthy.
  final isHealthy = const _i1.ColumnBool('isHealthy');

  /// The value of the metric.
  final value = const _i1.ColumnDouble('value');

  /// The granularity of this timestamp, null represents 1 minute, other valid
  /// values are 60 minutes and 1440 minutes (one day).
  final granularity = const _i1.ColumnInt('granularity');

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
ServerHealthMetricTable tServerHealthMetric = const ServerHealthMetricTable();
