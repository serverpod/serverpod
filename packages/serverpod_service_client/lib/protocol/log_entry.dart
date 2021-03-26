/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class LogEntry extends SerializableEntity {
  String get className => 'LogEntry';

  int? id;
  int? serverId;
  DateTime? time;
  int? logLevel;
  String? message;
  String? stackTrace;
  int? sessionLogId;

  LogEntry({
    this.id,
    this.serverId,
    this.time,
    this.logLevel,
    this.message,
    this.stackTrace,
    this.sessionLogId,
});

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    logLevel = _data['logLevel'];
    message = _data['message'];
    stackTrace = _data['stackTrace'];
    sessionLogId = _data['sessionLogId'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }
}

