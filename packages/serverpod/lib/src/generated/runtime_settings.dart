/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class RuntimeSettings extends TableRow {
  @override
  String get className => 'RuntimeSettings';
  @override
  String get tableName => 'serverpod_runtime_settings';

  @override
  int? id;
  late bool logAllCalls;
  late bool logAllQueries;
  late bool logSlowCalls;
  late bool logSlowQueries;
  late bool logFailedCalls;
  late bool logFailedQueries;
  late bool logMalformedCalls;
  late bool logServiceCalls;
  late int logLevel;
  late double slowQueryDuration;
  late double slowCallDuration;

  RuntimeSettings({
    this.id,
    required this.logAllCalls,
    required this.logAllQueries,
    required this.logSlowCalls,
    required this.logSlowQueries,
    required this.logFailedCalls,
    required this.logFailedQueries,
    required this.logMalformedCalls,
    required this.logServiceCalls,
    required this.logLevel,
    required this.slowQueryDuration,
    required this.slowCallDuration,
});

  RuntimeSettings.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    logAllCalls = _data['logAllCalls']!;
    logAllQueries = _data['logAllQueries']!;
    logSlowCalls = _data['logSlowCalls']!;
    logSlowQueries = _data['logSlowQueries']!;
    logFailedCalls = _data['logFailedCalls']!;
    logFailedQueries = _data['logFailedQueries']!;
    logMalformedCalls = _data['logMalformedCalls']!;
    logServiceCalls = _data['logServiceCalls']!;
    logLevel = _data['logLevel']!;
    slowQueryDuration = _data['slowQueryDuration']!;
    slowCallDuration = _data['slowCallDuration']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'logAllCalls': logAllCalls,
      'logAllQueries': logAllQueries,
      'logSlowCalls': logSlowCalls,
      'logSlowQueries': logSlowQueries,
      'logFailedCalls': logFailedCalls,
      'logFailedQueries': logFailedQueries,
      'logMalformedCalls': logMalformedCalls,
      'logServiceCalls': logServiceCalls,
      'logLevel': logLevel,
      'slowQueryDuration': slowQueryDuration,
      'slowCallDuration': slowCallDuration,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'logAllCalls': logAllCalls,
      'logAllQueries': logAllQueries,
      'logSlowCalls': logSlowCalls,
      'logSlowQueries': logSlowQueries,
      'logFailedCalls': logFailedCalls,
      'logFailedQueries': logFailedQueries,
      'logMalformedCalls': logMalformedCalls,
      'logServiceCalls': logServiceCalls,
      'logLevel': logLevel,
      'slowQueryDuration': slowQueryDuration,
      'slowCallDuration': slowCallDuration,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'logAllCalls': logAllCalls,
      'logAllQueries': logAllQueries,
      'logSlowCalls': logSlowCalls,
      'logSlowQueries': logSlowQueries,
      'logFailedCalls': logFailedCalls,
      'logFailedQueries': logFailedQueries,
      'logMalformedCalls': logMalformedCalls,
      'logServiceCalls': logServiceCalls,
      'logLevel': logLevel,
      'slowQueryDuration': slowQueryDuration,
      'slowCallDuration': slowCallDuration,
    });
  }
}

class RuntimeSettingsTable extends Table {
  RuntimeSettingsTable() : super(tableName: 'serverpod_runtime_settings');

  @override
  String tableName = 'serverpod_runtime_settings';
  final id = ColumnInt('id');
  final logAllCalls = ColumnBool('logAllCalls');
  final logAllQueries = ColumnBool('logAllQueries');
  final logSlowCalls = ColumnBool('logSlowCalls');
  final logSlowQueries = ColumnBool('logSlowQueries');
  final logFailedCalls = ColumnBool('logFailedCalls');
  final logFailedQueries = ColumnBool('logFailedQueries');
  final logMalformedCalls = ColumnBool('logMalformedCalls');
  final logServiceCalls = ColumnBool('logServiceCalls');
  final logLevel = ColumnInt('logLevel');
  final slowQueryDuration = ColumnDouble('slowQueryDuration');
  final slowCallDuration = ColumnDouble('slowCallDuration');

  @override
  List<Column> get columns => [
    id,
    logAllCalls,
    logAllQueries,
    logSlowCalls,
    logSlowQueries,
    logFailedCalls,
    logFailedQueries,
    logMalformedCalls,
    logServiceCalls,
    logLevel,
    slowQueryDuration,
    slowCallDuration,
  ];
}

RuntimeSettingsTable tRuntimeSettings = RuntimeSettingsTable();
