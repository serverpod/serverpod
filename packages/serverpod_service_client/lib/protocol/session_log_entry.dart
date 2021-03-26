/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class SessionLogEntry extends SerializableEntity {
  String get className => 'SessionLogEntry';

  int? id;
  int? serverId;
  DateTime? time;
  String? endpoint;
  String? method;
  double? duration;
  int? numQueries;
  bool? slow;
  String? error;
  String? stackTrace;
  String? authenticatedUser;

  SessionLogEntry({
    this.id,
    this.serverId,
    this.time,
    this.endpoint,
    this.method,
    this.duration,
    this.numQueries,
    this.slow,
    this.error,
    this.stackTrace,
    this.authenticatedUser,
});

  SessionLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    endpoint = _data['endpoint'];
    method = _data['method'];
    duration = _data['duration'];
    numQueries = _data['numQueries'];
    slow = _data['slow'];
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    authenticatedUser = _data['authenticatedUser'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc().toIso8601String(),
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUser': authenticatedUser,
    });
  }
}

