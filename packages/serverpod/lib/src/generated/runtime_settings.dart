/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class RuntimeSettings extends TableRow {
  String get className => 'RuntimeSettings';
  String get tableName => 'serverpod_runtime_settings';

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
  Map<String, dynamic> serializeForDatabase() {
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

  Map<String, dynamic> serializeAll() {
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

class RuntimeSettingsTable extends Table {
  RuntimeSettingsTable() : super(tableName: 'serverpod_runtime_settings');

  String tableName = 'serverpod_runtime_settings';
  final id = ColumnInt('id');
  final logFailedCalls = ColumnBool('logFailedCalls');
  final logSlowQueries = ColumnBool('logSlowQueries');
  final logSlowCalls = ColumnBool('logSlowCalls');
  final slowQueryDuration = ColumnDouble('slowQueryDuration');
  final logAllQueries = ColumnBool('logAllQueries');
  final slowCallDuration = ColumnDouble('slowCallDuration');
  final logAllCalls = ColumnBool('logAllCalls');
  final logLevel = ColumnInt('logLevel');
  final logMalformedCalls = ColumnBool('logMalformedCalls');

  List<Column> get columns => [
    id,
    logFailedCalls,
    logSlowQueries,
    logSlowCalls,
    slowQueryDuration,
    logAllQueries,
    slowCallDuration,
    logAllCalls,
    logLevel,
    logMalformedCalls,
  ];
}

RuntimeSettingsTable tRuntimeSettings = RuntimeSettingsTable();
