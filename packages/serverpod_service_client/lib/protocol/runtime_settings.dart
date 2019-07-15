/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class RuntimeSettings extends SerializableEntity {
  String get className => 'RuntimeSettings';

  int id;
  bool logFailedCalls;
  bool logSlowQueries;
  bool logSlowCalls;
  double slowQueryDuration;
  bool logAllQueries;
  double slowCallDuration;
  bool logAllCalls;
  int logLevel;
  bool logMalformedCalls;

  RuntimeSettings({
    this.id,
    this.logFailedCalls,
    this.logSlowQueries,
    this.logSlowCalls,
    this.slowQueryDuration,
    this.logAllQueries,
    this.slowCallDuration,
    this.logAllCalls,
    this.logLevel,
    this.logMalformedCalls,
});

  RuntimeSettings.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    logFailedCalls = _data['logFailedCalls'];
    logSlowQueries = _data['logSlowQueries'];
    logSlowCalls = _data['logSlowCalls'];
    slowQueryDuration = _data['slowQueryDuration'];
    logAllQueries = _data['logAllQueries'];
    slowCallDuration = _data['slowCallDuration'];
    logAllCalls = _data['logAllCalls'];
    logLevel = _data['logLevel'];
    logMalformedCalls = _data['logMalformedCalls'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'logFailedCalls': logFailedCalls,
      'logSlowQueries': logSlowQueries,
      'logSlowCalls': logSlowCalls,
      'slowQueryDuration': slowQueryDuration,
      'logAllQueries': logAllQueries,
      'slowCallDuration': slowCallDuration,
      'logAllCalls': logAllCalls,
      'logLevel': logLevel,
      'logMalformedCalls': logMalformedCalls,
    });
  }
}

