/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class LogEntry extends SerializableEntity {
  @override
  String get className => 'LogEntry';

  int? id;
  late int sessionLogId;
  int? messageId;
  String? reference;
  late String serverId;
  late DateTime time;
  late LogLevel logLevel;
  late String message;
  String? error;
  String? stackTrace;
  late int order;

  LogEntry({
    this.id,
    required this.sessionLogId,
    this.messageId,
    this.reference,
    required this.serverId,
    required this.time,
    required this.logLevel,
    required this.message,
    this.error,
    this.stackTrace,
    required this.order,
  });

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogId = _data['sessionLogId']!;
    messageId = _data['messageId'];
    reference = _data['reference'];
    serverId = _data['serverId']!;
    time = DateTime.tryParse(_data['time'])!;
    logLevel = LogLevel.fromSerialization(_data['logLevel']);
    message = _data['message']!;
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    order = _data['order']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'reference': reference,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel.serialize(),
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
      'order': order,
    });
  }
}
