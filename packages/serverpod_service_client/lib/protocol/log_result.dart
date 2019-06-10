/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
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
}

