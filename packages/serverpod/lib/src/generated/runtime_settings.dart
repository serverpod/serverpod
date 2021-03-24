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
  Map<String, dynamic> serializeForDatabase() {
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

  Map<String, dynamic> serializeAll() {
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

class RuntimeSettingsTable extends Table {
  RuntimeSettingsTable() : super(tableName: 'serverpod_runtime_settings');

  String tableName = 'serverpod_runtime_settings';
  final id = ColumnInt('id');
  final logAllCalls = ColumnBool('logAllCalls');
  final logAllQueries = ColumnBool('logAllQueries');
  final logSlowCalls = ColumnBool('logSlowCalls');
  final logSlowQueries = ColumnBool('logSlowQueries');
  final logFailedCalls = ColumnBool('logFailedCalls');
  final logMalformedCalls = ColumnBool('logMalformedCalls');
  final logLevel = ColumnInt('logLevel');
  final slowQueryDuration = ColumnDouble('slowQueryDuration');
  final slowCallDuration = ColumnDouble('slowCallDuration');

  List<Column> get columns => [
    id,
    logAllCalls,
    logAllQueries,
    logSlowCalls,
    logSlowQueries,
    logFailedCalls,
    logMalformedCalls,
    logLevel,
    slowQueryDuration,
    slowCallDuration,
  ];
}

RuntimeSettingsTable tRuntimeSettings = RuntimeSettingsTable();
