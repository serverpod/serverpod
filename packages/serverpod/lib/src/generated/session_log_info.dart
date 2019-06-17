/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class SessionLogInfo extends SerializableEntity {
  String get className => 'SessionLogInfo';

  int id;
  CallLogEntry callLogEntry;
  List<QueryLogEntry> queries;
  List<LogEntry> messageLog;

  SessionLogInfo({
    this.id,
    this.callLogEntry,
    this.queries,
    this.messageLog,
});

  SessionLogInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    callLogEntry = _data['callLogEntry'] != null ? CallLogEntry.fromSerialization(_data['callLogEntry']) : null;
    queries = _data['queries']?.map<QueryLogEntry>((a) => QueryLogEntry.fromSerialization(a))?.toList();
    messageLog = _data['messageLog']?.map<LogEntry>((a) => LogEntry.fromSerialization(a))?.toList();
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'callLogEntry': callLogEntry?.serialize(),
      'queries': queries?.map((QueryLogEntry a) => a.serialize())?.toList(),
      'messageLog': messageLog?.map((LogEntry a) => a.serialize())?.toList(),
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'callLogEntry': callLogEntry?.serialize(),
      'queries': queries?.map((QueryLogEntry a) => a.serialize())?.toList(),
      'messageLog': messageLog?.map((LogEntry a) => a.serialize())?.toList(),
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'callLogEntry': callLogEntry?.serialize(),
      'queries': queries?.map((QueryLogEntry a) => a.serialize())?.toList(),
      'messageLog': messageLog?.map((LogEntry a) => a.serialize())?.toList(),
    });
  }
}

