/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class LogEntry extends SerializableEntity {
  String get className => 'LogEntry';

  int id;
  int serverId;
  int logLevel;
  DateTime time;
  String stackTrace;
  int callLogId;
  String message;

  LogEntry({
    this.id,
    this.serverId,
    this.logLevel,
    this.time,
    this.stackTrace,
    this.callLogId,
    this.message,
});

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    logLevel = _data['logLevel'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    stackTrace = _data['stackTrace'];
    callLogId = _data['callLogId'];
    message = _data['message'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'logLevel': logLevel,
      'time': time?.toUtc()?.toIso8601String(),
      'stackTrace': stackTrace,
      'callLogId': callLogId,
      'message': message,
    });
  }
}

