/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ServerHealthMetric extends TableRow {
  @override
  String get className => 'ServerHealthMetric';
  @override
  String get tableName => 'serverpod_health_metric';

  static final t = ServerHealthMetricTable();

  @override
  int? id;
  late String name;
  late String serverId;
  late DateTime timestamp;
  late bool isHealthy;
  late double value;

  ServerHealthMetric({
    this.id,
    required this.name,
    required this.serverId,
    required this.timestamp,
    required this.isHealthy,
    required this.value,
  });

  ServerHealthMetric.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    serverId = _data['serverId']!;
    timestamp = DateTime.tryParse(_data['timestamp'])!;
    isHealthy = _data['isHealthy']!;
    value = _data['value']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'isHealthy': isHealthy,
      'value': value,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'isHealthy': isHealthy,
      'value': value,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'serverId': serverId,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'isHealthy': isHealthy,
      'value': value,
    });
  }

  @override
  void setColumn(String columnName, value) {
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
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ServerHealthMetric>> find(
    Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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
    Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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

  static Future<ServerHealthMetric?> findById(Session session, int id) async {
    return session.db.findById<ServerHealthMetric>(id);
  }

  static Future<int> delete(
    Session session, {
    required ServerHealthMetricExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ServerHealthMetric>(
      where: where(ServerHealthMetric.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ServerHealthMetric row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ServerHealthMetric row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ServerHealthMetric row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ServerHealthMetricExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ServerHealthMetric>(
      where: where != null ? where(ServerHealthMetric.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ServerHealthMetricExpressionBuilder = Expression Function(
    ServerHealthMetricTable t);

class ServerHealthMetricTable extends Table {
  ServerHealthMetricTable() : super(tableName: 'serverpod_health_metric');

  @override
  String tableName = 'serverpod_health_metric';
  final id = ColumnInt('id');
  final name = ColumnString('name');
  final serverId = ColumnString('serverId');
  final timestamp = ColumnDateTime('timestamp');
  final isHealthy = ColumnBool('isHealthy');
  final value = ColumnDouble('value');

  @override
  List<Column> get columns => [
        id,
        name,
        serverId,
        timestamp,
        isHealthy,
        value,
      ];
}

@Deprecated('Use ServerHealthMetricTable.t instead.')
ServerHealthMetricTable tServerHealthMetric = ServerHealthMetricTable();
