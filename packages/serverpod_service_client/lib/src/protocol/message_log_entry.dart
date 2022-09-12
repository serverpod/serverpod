/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class MessageLogEntry extends SerializableEntity {
  @override
  String get className => 'MessageLogEntry';

  int? id;
  late int sessionLogId;
  late String serverId;
  late int messageId;
  late String endpoint;
  late String messageName;
  late double duration;
  String? error;
  String? stackTrace;
  late bool slow;
  late int order;

  MessageLogEntry({
    this.id,
    required this.sessionLogId,
    required this.serverId,
    required this.messageId,
    required this.endpoint,
    required this.messageName,
    required this.duration,
    this.error,
    this.stackTrace,
    required this.slow,
    required this.order,
  });

  MessageLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogId = _data['sessionLogId']!;
    serverId = _data['serverId']!;
    messageId = _data['messageId']!;
    endpoint = _data['endpoint']!;
    messageName = _data['messageName']!;
    duration = _data['duration']!;
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    slow = _data['slow']!;
    order = _data['order']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      'error': error,
      'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    });
  }
}
