/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class SessionLogInfo extends SerializableEntity {
  @override
  String get className => 'SessionLogInfo';

  int? id;
  late SessionLogEntry sessionLogEntry;
  late List<QueryLogEntry> queries;
  late List<LogEntry> messageLog;

  SessionLogInfo({
    this.id,
    required this.sessionLogEntry,
    required this.queries,
    required this.messageLog,
});

  SessionLogInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogEntry = SessionLogEntry.fromSerialization(_data['sessionLogEntry']);
    queries = _data['queries']!.map<QueryLogEntry>((a) => QueryLogEntry.fromSerialization(a))?.toList();
    messageLog = _data['messageLog']!.map<LogEntry>((a) => LogEntry.fromSerialization(a))?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLogEntry': sessionLogEntry.serialize(),
      'queries': queries.map((QueryLogEntry a) => a.serialize()).toList(),
      'messageLog': messageLog.map((LogEntry a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'sessionLogEntry': sessionLogEntry.serialize(),
      'queries': queries.map((QueryLogEntry a) => a.serialize()).toList(),
      'messageLog': messageLog.map((LogEntry a) => a.serialize()).toList(),
    });
  }
}

