/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class SessionLogInfo extends SerializableEntity {
  @override
  String get className => 'SessionLogInfo';

  int? id;
  late SessionLogEntry sessionLogEntry;
  late List<QueryLogEntry> queries;
  late List<LogEntry> logs;
  late List<MessageLogEntry> messages;

  SessionLogInfo({
    this.id,
    required this.sessionLogEntry,
    required this.queries,
    required this.logs,
    required this.messages,
  });

  SessionLogInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogEntry =
        SessionLogEntry.fromSerialization(_data['sessionLogEntry']);
    queries = _data['queries']!
        .map<QueryLogEntry>((a) => QueryLogEntry.fromSerialization(a))
        ?.toList();
    logs = _data['logs']!
        .map<LogEntry>((a) => LogEntry.fromSerialization(a))
        ?.toList();
    messages = _data['messages']!
        .map<MessageLogEntry>((a) => MessageLogEntry.fromSerialization(a))
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLogEntry': sessionLogEntry.serialize(),
      'queries': queries.map((QueryLogEntry a) => a.serialize()).toList(),
      'logs': logs.map((LogEntry a) => a.serialize()).toList(),
      'messages': messages.map((MessageLogEntry a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'sessionLogEntry': sessionLogEntry.serialize(),
      'queries': queries.map((QueryLogEntry a) => a.serialize()).toList(),
      'logs': logs.map((LogEntry a) => a.serialize()).toList(),
      'messages': messages.map((MessageLogEntry a) => a.serialize()).toList(),
    });
  }
}
