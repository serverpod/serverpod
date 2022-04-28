/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import '../../serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class SessionLogEntry extends TableRow {
  @override
  String get className => 'SessionLogEntry';
  @override
  String get tableName => 'serverpod_session_log';

  static final SessionLogEntryTable t = SessionLogEntryTable();

  @override
  int? id;
  late int serverId;
  late DateTime time;
  String? module;
  String? endpoint;
  String? method;
  double? duration;
  int? numQueries;
  bool? slow;
  String? error;
  String? stackTrace;
  int? authenticatedUserId;

  SessionLogEntry({
    this.id,
    required this.serverId,
    required this.time,
    this.module,
    this.endpoint,
    this.method,
    this.duration,
    this.numQueries,
    this.slow,
    this.error,
    this.stackTrace,
    this.authenticatedUserId,
  });

  SessionLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    time = DateTime.tryParse(_data['time'])!;
    module = _data['module'];
    endpoint = _data['endpoint'];
    method = _data['method'];
    duration = _data['duration'];
    numQueries = _data['numQueries'];
    slow = _data['slow'];
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    authenticatedUserId = _data['authenticatedUserId'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
    });
  }

  @override
  void setColumn(String columnName, dynamic value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'time':
        time = value;
        return;
      case 'module':
        module = value;
        return;
      case 'endpoint':
        endpoint = value;
        return;
      case 'method':
        method = value;
        return;
      case 'duration':
        duration = value;
        return;
      case 'numQueries':
        numQueries = value;
        return;
      case 'slow':
        slow = value;
        return;
      case 'error':
        error = value;
        return;
      case 'stackTrace':
        stackTrace = value;
        return;
      case 'authenticatedUserId':
        authenticatedUserId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<SessionLogEntry>> find(
    Session session, {
    SessionLogEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<SessionLogEntry>(
      where: where != null ? where(SessionLogEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SessionLogEntry?> findSingleRow(
    Session session, {
    SessionLogEntryExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SessionLogEntry>(
      where: where != null ? where(SessionLogEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SessionLogEntry?> findById(Session session, int id) async {
    return session.db.findById<SessionLogEntry>(id);
  }

  static Future<int> delete(
    Session session, {
    required SessionLogEntryExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    SessionLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    SessionLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    SessionLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    SessionLogEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<SessionLogEntry>(
      where: where != null ? where(SessionLogEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef SessionLogEntryExpressionBuilder = Expression Function(
    SessionLogEntryTable t);

class SessionLogEntryTable extends Table {
  SessionLogEntryTable() : super(tableName: 'serverpod_session_log');

  @override
  String tableName = 'serverpod_session_log';
  final ColumnInt id = ColumnInt('id');
  final ColumnInt serverId = ColumnInt('serverId');
  final ColumnDateTime time = ColumnDateTime('time');
  final ColumnString module = ColumnString('module');
  final ColumnString endpoint = ColumnString('endpoint');
  final ColumnString method = ColumnString('method');
  final ColumnDouble duration = ColumnDouble('duration');
  final ColumnInt numQueries = ColumnInt('numQueries');
  final ColumnBool slow = ColumnBool('slow');
  final ColumnString error = ColumnString('error');
  final ColumnString stackTrace = ColumnString('stackTrace');
  final ColumnInt authenticatedUserId = ColumnInt('authenticatedUserId');

  @override
  List<Column> get columns => <Column>[
        id,
        serverId,
        time,
        module,
        endpoint,
        method,
        duration,
        numQueries,
        slow,
        error,
        stackTrace,
        authenticatedUserId,
      ];
}

@Deprecated('Use SessionLogEntryTable.t instead.')
SessionLogEntryTable tSessionLogEntry = SessionLogEntryTable();
