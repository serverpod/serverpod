/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class RuntimeSettings extends TableRow {
  @override
  String get className => 'RuntimeSettings';
  @override
  String get tableName => 'serverpod_runtime_settings';

  static final t = RuntimeSettingsTable();

  @override
  int? id;
  late LogSettings logSettings;
  late List<LogSettingsOverride> logSettingsOverrides;
  late bool logServiceCalls;
  late bool logMalformedCalls;

  RuntimeSettings({
    this.id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  });

  RuntimeSettings.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    logSettings = LogSettings.fromSerialization(_data['logSettings']);
    logSettingsOverrides = _data['logSettingsOverrides']!
        .map<LogSettingsOverride>(
            (a) => LogSettingsOverride.fromSerialization(a))
        ?.toList();
    logServiceCalls = _data['logServiceCalls']!;
    logMalformedCalls = _data['logMalformedCalls']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'logSettings': logSettings.serialize(),
      'logSettingsOverrides': logSettingsOverrides
          .map((LogSettingsOverride a) => a.serialize())
          .toList(),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'logSettings': logSettings.serialize(),
      'logSettingsOverrides': logSettingsOverrides
          .map((LogSettingsOverride a) => a.serialize())
          .toList(),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'logSettings': logSettings.serialize(),
      'logSettingsOverrides': logSettingsOverrides
          .map((LogSettingsOverride a) => a.serialize())
          .toList(),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'logSettings':
        logSettings = value;
        return;
      case 'logSettingsOverrides':
        logSettingsOverrides = value;
        return;
      case 'logServiceCalls':
        logServiceCalls = value;
        return;
      case 'logMalformedCalls':
        logMalformedCalls = value;
        return;
      default:
        throw UnimplementedError();
    }
  }
}

class RuntimeSettingsTable extends Table {
  RuntimeSettingsTable() : super(tableName: 'serverpod_runtime_settings');

  @override
  String tableName = 'serverpod_runtime_settings';
  final id = ColumnInt('id');
  final logSettings = ColumnSerializable('logSettings');
  final logSettingsOverrides = ColumnSerializable('logSettingsOverrides');
  final logServiceCalls = ColumnBool('logServiceCalls');
  final logMalformedCalls = ColumnBool('logMalformedCalls');

  @override
  List<Column> get columns => [
        id,
        logSettings,
        logSettingsOverrides,
        logServiceCalls,
        logMalformedCalls,
      ];
}

@Deprecated('Use RuntimeSettingsTable.t instead.')
RuntimeSettingsTable tRuntimeSettings = RuntimeSettingsTable();
