/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class RuntimeSettings extends SerializableEntity {
  String get className => 'RuntimeSettings';

  int id;
  bool logAllCalls;
  bool logAllQueries;
  bool logSlowCalls;
  bool logSlowQueries;
  bool logFailedCalls;
  bool logMalformedCalls;
  int logLevel;
  double slowQueryDuration;
  double slowCallDuration;

  RuntimeSettings({
    this.id,
    this.logAllCalls,
    this.logAllQueries,
    this.logSlowCalls,
    this.logSlowQueries,
    this.logFailedCalls,
    this.logMalformedCalls,
    this.logLevel,
    this.slowQueryDuration,
    this.slowCallDuration,
});

  RuntimeSettings.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    logAllCalls = _data['logAllCalls'];
    logAllQueries = _data['logAllQueries'];
    logSlowCalls = _data['logSlowCalls'];
    logSlowQueries = _data['logSlowQueries'];
    logFailedCalls = _data['logFailedCalls'];
    logMalformedCalls = _data['logMalformedCalls'];
    logLevel = _data['logLevel'];
    slowQueryDuration = _data['slowQueryDuration'];
    slowCallDuration = _data['slowCallDuration'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'logAllCalls': logAllCalls,
      'logAllQueries': logAllQueries,
      'logSlowCalls': logSlowCalls,
      'logSlowQueries': logSlowQueries,
      'logFailedCalls': logFailedCalls,
      'logMalformedCalls': logMalformedCalls,
      'logLevel': logLevel,
      'slowQueryDuration': slowQueryDuration,
      'slowCallDuration': slowCallDuration,
    });
  }
}

