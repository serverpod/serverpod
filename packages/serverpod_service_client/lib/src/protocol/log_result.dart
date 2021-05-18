/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class LogResult extends SerializableEntity {
  @override
  String get className => 'LogResult';

  int? id;
  late List<LogEntry> entries;

  LogResult({
    this.id,
    required this.entries,
});

  LogResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    entries = _data['entries']!.map<LogEntry>((a) => LogEntry.fromSerialization(a))?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'entries': entries.map((LogEntry a) => a.serialize()).toList(),
    });
  }
}

