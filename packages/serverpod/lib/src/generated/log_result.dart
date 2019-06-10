/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class LogResult extends SerializableEntity {
  String get className => 'LogResult';

  int id;
  List<LogEntry> entries;

  LogResult({
    this.id,
    this.entries,
});

  LogResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    entries = _data['entries']?.map<LogEntry>((a) => LogEntry.fromSerialization(a))?.toList();
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'entries': entries?.map((LogEntry a) => a.serialize())?.toList(),
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'entries': entries?.map((LogEntry a) => a.serialize())?.toList(),
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'entries': entries?.map((LogEntry a) => a.serialize())?.toList(),
    });
  }
}

