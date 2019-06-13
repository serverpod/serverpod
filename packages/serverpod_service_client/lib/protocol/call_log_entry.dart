/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class CallLogEntry extends SerializableEntity {
  String get className => 'CallLogEntry';

  int id;
  int numQueries;
  DateTime time;
  double duration;
  int serverId;
  String error;
  String stackTrace;
  String method;
  String endpoint;
  bool slow;

  CallLogEntry({
    this.id,
    this.numQueries,
    this.time,
    this.duration,
    this.serverId,
    this.error,
    this.stackTrace,
    this.method,
    this.endpoint,
    this.slow,
});

  CallLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    numQueries = _data['numQueries'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    duration = _data['duration'];
    serverId = _data['serverId'];
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    method = _data['method'];
    endpoint = _data['endpoint'];
    slow = _data['slow'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numQueries': numQueries,
      'time': time?.toUtc()?.toIso8601String(),
      'duration': duration,
      'serverId': serverId,
      'error': error,
      'stackTrace': stackTrace,
      'method': method,
      'endpoint': endpoint,
      'slow': slow,
    });
  }
}

