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
  String message;

  LogEntry({
    this.id,
    this.serverId,
    this.logLevel,
    this.time,
    this.stackTrace,
    this.message,
});

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    id = data['id'];
    serverId = data['serverId'];
    logLevel = data['logLevel'];
    time = data['time'] != null ? DateTime.tryParse(data['time']) : null;
    stackTrace = data['stackTrace'];
    message = data['message'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'logLevel': logLevel,
      'time': time?.toUtc()?.toIso8601String(),
      'stackTrace': stackTrace,
      'message': message,
    });
  }
}

