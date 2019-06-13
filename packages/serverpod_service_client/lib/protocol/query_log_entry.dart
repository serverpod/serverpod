/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class QueryLogEntry extends SerializableEntity {
  String get className => 'QueryLogEntry';

  int id;
  int numRows;
  String query;
  double duration;
  int callLogId;

  QueryLogEntry({
    this.id,
    this.numRows,
    this.query,
    this.duration,
    this.callLogId,
});

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    numRows = _data['numRows'];
    query = _data['query'];
    duration = _data['duration'];
    callLogId = _data['callLogId'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numRows': numRows,
      'query': query,
      'duration': duration,
      'callLogId': callLogId,
    });
  }
}

