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
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    entries = _data['entries']!
        .map<LogEntry>((Map<String, dynamic>a) => LogEntry.fromSerialization(a))
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'entries': entries.map((LogEntry a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'entries': entries.map((LogEntry a) => a.serialize()).toList(),
    });
  }
}
