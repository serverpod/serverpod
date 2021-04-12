/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class QueryLogEntry extends SerializableEntity {
  @override
  String get className => 'QueryLogEntry';

  int? id;
  late int sessionLogId;
  late String query;
  late double duration;
  int? numRows;

  QueryLogEntry({
    this.id,
    required this.sessionLogId,
    required this.query,
    required this.duration,
    this.numRows,
});

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogId = _data['sessionLogId']!;
    query = _data['query']!;
    duration = _data['duration']!;
    numRows = _data['numRows'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
    });
  }
}

