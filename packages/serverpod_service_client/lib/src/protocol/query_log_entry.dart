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

class QueryLogEntry extends SerializableEntity {
  @override
  String get className => 'QueryLogEntry';

  int? id;
  late String serverId;
  late int sessionLogId;
  late String query;
  late double duration;
  int? numRows;
  String? error;
  String? stackTrace;

  QueryLogEntry({
    this.id,
    required this.serverId,
    required this.sessionLogId,
    required this.query,
    required this.duration,
    this.numRows,
    this.error,
    this.stackTrace,
  });

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    sessionLogId = _data['sessionLogId']!;
    query = _data['query']!;
    duration = _data['duration']!;
    numRows = _data['numRows'];
    error = _data['error'];
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
      'error': error,
      'stackTrace': stackTrace,
    });
  }
}
