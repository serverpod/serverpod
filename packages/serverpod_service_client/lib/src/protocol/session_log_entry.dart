/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class SessionLogEntry extends SerializableEntity {
  @override
  String get className => 'SessionLogEntry';

  int? id;
  late String serverId;
  late DateTime time;
  String? module;
  String? endpoint;
  String? method;
  double? duration;
  int? numQueries;
  bool? slow;
  String? error;
  String? stackTrace;
  int? authenticatedUserId;

  SessionLogEntry({
    this.id,
    required this.serverId,
    required this.time,
    this.module,
    this.endpoint,
    this.method,
    this.duration,
    this.numQueries,
    this.slow,
    this.error,
    this.stackTrace,
    this.authenticatedUserId,
  });

  SessionLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    time = DateTime.tryParse(_data['time'])!;
    module = _data['module'];
    endpoint = _data['endpoint'];
    method = _data['method'];
    duration = _data['duration'];
    numQueries = _data['numQueries'];
    slow = _data['slow'];
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    authenticatedUserId = _data['authenticatedUserId'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
    });
  }
}
