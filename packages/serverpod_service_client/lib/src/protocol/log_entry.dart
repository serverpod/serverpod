/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class LogEntry extends SerializableEntity {
  @override
  String get className => 'LogEntry';

  int? id;
  late int serverId;
  late DateTime time;
  late int logLevel;
  late String message;
  String? exception;
  String? stackTrace;
  int? sessionLogId;

  LogEntry({
    this.id,
    required this.serverId,
    required this.time,
    required this.logLevel,
    required this.message,
    this.exception,
    this.stackTrace,
    this.sessionLogId,
});

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    time = DateTime.tryParse(_data['time'])!;
    logLevel = _data['logLevel']!;
    message = _data['message']!;
    exception = _data['exception'];
    stackTrace = _data['stackTrace'];
    sessionLogId = _data['sessionLogId'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'exception': exception,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }
}

