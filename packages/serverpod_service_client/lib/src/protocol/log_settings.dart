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

class LogSettings extends SerializableEntity {
  @override
  String get className => 'LogSettings';

  int? id;
  late int logLevel;
  late bool logAllSessions;
  late bool logAllQueries;
  late bool logSlowSessions;
  late bool logSlowQueries;
  late bool logFailedSessions;
  late bool logFailedQueries;
  late double slowSessionDuration;
  late double slowQueryDuration;

  LogSettings({
    this.id,
    required this.logLevel,
    required this.logAllSessions,
    required this.logAllQueries,
    required this.logSlowSessions,
    required this.logSlowQueries,
    required this.logFailedSessions,
    required this.logFailedQueries,
    required this.slowSessionDuration,
    required this.slowQueryDuration,
  });

  LogSettings.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    logLevel = _data['logLevel']!;
    logAllSessions = _data['logAllSessions']!;
    logAllQueries = _data['logAllQueries']!;
    logSlowSessions = _data['logSlowSessions']!;
    logSlowQueries = _data['logSlowQueries']!;
    logFailedSessions = _data['logFailedSessions']!;
    logFailedQueries = _data['logFailedQueries']!;
    slowSessionDuration = _data['slowSessionDuration']!;
    slowQueryDuration = _data['slowQueryDuration']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'logLevel': logLevel,
      'logAllSessions': logAllSessions,
      'logAllQueries': logAllQueries,
      'logSlowSessions': logSlowSessions,
      'logSlowQueries': logSlowQueries,
      'logFailedSessions': logFailedSessions,
      'logFailedQueries': logFailedQueries,
      'slowSessionDuration': slowSessionDuration,
      'slowQueryDuration': slowQueryDuration,
    });
  }
}
