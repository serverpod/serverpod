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
  int? serverId;
  int? sessionLogId;
  late String query;
  late double duration;
  int? numRows;
  String? exception;
  String? stackTrace;

  QueryLogEntry({
    this.id,
    this.serverId,
    this.sessionLogId,
    required this.query,
    required this.duration,
    this.numRows,
    this.exception,
    this.stackTrace,
});

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    sessionLogId = _data['sessionLogId'];
    query = _data['query']!;
    duration = _data['duration']!;
    numRows = _data['numRows'];
    exception = _data['exception'];
    stackTrace = _data['stackTrace'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
      'exception': exception,
      'stackTrace': stackTrace,
    });
  }
}

