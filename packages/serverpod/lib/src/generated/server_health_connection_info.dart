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

class ServerHealthConnectionInfo extends TableRow {
  @override
  String get className => 'ServerHealthConnectionInfo';
  @override
  String get tableName => 'serverpod_health_connection_info';

  static final t = ServerHealthConnectionInfoTable();

  @override
  int? id;
  late String serverId;
  late int type;
  late DateTime timestamp;
  late int active;
  late int closing;
  late int idle;

  ServerHealthConnectionInfo({
    this.id,
    required this.serverId,
    required this.type,
    required this.timestamp,
    required this.active,
    required this.closing,
    required this.idle,
  });

  ServerHealthConnectionInfo.fromSerialization(
      Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    type = _data['type']!;
    timestamp = DateTime.tryParse(_data['timestamp'])!;
    active = _data['active']!;
    closing = _data['closing']!;
    idle = _data['idle']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'active': active,
      'closing': closing,
      'idle': idle,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'active': active,
      'closing': closing,
      'idle': idle,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'type': type,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'active': active,
      'closing': closing,
      'idle': idle,
    });
  }

  @override
  void setColumn(String columnName, value) {
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
    Session session, {
    ServerHealthConnectionInfoExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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
    Session session, {
    ServerHealthConnectionInfoExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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
      Session session, int id) async {
    return session.db.findById<ServerHealthConnectionInfo>(id);
  }

  static Future<int> delete(
    Session session, {
    required ServerHealthConnectionInfoExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ServerHealthConnectionInfo>(
      where: where(ServerHealthConnectionInfo.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ServerHealthConnectionInfo row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ServerHealthConnectionInfo row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ServerHealthConnectionInfo row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ServerHealthConnectionInfoExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ServerHealthConnectionInfo>(
      where: where != null ? where(ServerHealthConnectionInfo.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ServerHealthConnectionInfoExpressionBuilder = Expression Function(
    ServerHealthConnectionInfoTable t);

class ServerHealthConnectionInfoTable extends Table {
  ServerHealthConnectionInfoTable()
      : super(tableName: 'serverpod_health_connection_info');

  @override
  String tableName = 'serverpod_health_connection_info';
  final id = ColumnInt('id');
  final serverId = ColumnString('serverId');
  final type = ColumnInt('type');
  final timestamp = ColumnDateTime('timestamp');
  final active = ColumnInt('active');
  final closing = ColumnInt('closing');
  final idle = ColumnInt('idle');

  @override
  List<Column> get columns => [
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
