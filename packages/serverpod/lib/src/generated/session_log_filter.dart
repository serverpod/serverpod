/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class SessionLogFilter extends SerializableEntity {
  @override
  String get className => 'SessionLogFilter';

  int? id;
  String? endpoint;
  String? method;
  String? futureCall;
  late bool slow;
  late bool error;
  int? lastSessionLogId;

  SessionLogFilter({
    this.id,
    this.endpoint,
    this.method,
    this.futureCall,
    required this.slow,
    required this.error,
    this.lastSessionLogId,
});

  SessionLogFilter.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    endpoint = _data['endpoint'];
    method = _data['method'];
    futureCall = _data['futureCall'];
    slow = _data['slow']!;
    error = _data['error']!;
    lastSessionLogId = _data['lastSessionLogId'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'slow': slow,
      'error': error,
      'lastSessionLogId': lastSessionLogId,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'slow': slow,
      'error': error,
      'lastSessionLogId': lastSessionLogId,
    });
  }
}

