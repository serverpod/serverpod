/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import '../../serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class RuntimeSettings extends TableRow {
  @override
  String get className => 'RuntimeSettings';
  @override
  String get tableName => 'serverpod_runtime_settings';

  static final RuntimeSettingsTable t = RuntimeSettingsTable();

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
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    logSettings = LogSettings.fromSerialization(_data['logSettings']);
    logSettingsOverrides = _data['logSettingsOverrides']!
        .map<LogSettingsOverride>((Map<String, dynamic> a) =>
            LogSettingsOverride.fromSerialization(a))
        ?.toList();
    logServiceCalls = _data['logServiceCalls']!;
    logMalformedCalls = _data['logMalformedCalls']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
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
    return wrapSerializationData(<String, dynamic>{
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
    return wrapSerializationData(<String, dynamic>{
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
  void setColumn(String columnName, dynamic value) {
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

  static Future<List<RuntimeSettings>> find(
    Session session, {
    RuntimeSettingsExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<RuntimeSettings>(
      where: where != null ? where(RuntimeSettings.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<RuntimeSettings?> findSingleRow(
    Session session, {
    RuntimeSettingsExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<RuntimeSettings>(
      where: where != null ? where(RuntimeSettings.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<RuntimeSettings?> findById(Session session, int id) async {
    return session.db.findById<RuntimeSettings>(id);
  }

  static Future<int> delete(
    Session session, {
    required RuntimeSettingsExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<RuntimeSettings>(
      where: where(RuntimeSettings.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    RuntimeSettings row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    RuntimeSettings row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    RuntimeSettings row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    RuntimeSettingsExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<RuntimeSettings>(
      where: where != null ? where(RuntimeSettings.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef RuntimeSettingsExpressionBuilder = Expression Function(
    RuntimeSettingsTable t);

class RuntimeSettingsTable extends Table {
  RuntimeSettingsTable() : super(tableName: 'serverpod_runtime_settings');

  @override
  String tableName = 'serverpod_runtime_settings';
  final ColumnInt id = ColumnInt('id');
  final ColumnSerializable logSettings = ColumnSerializable('logSettings');
  final ColumnSerializable logSettingsOverrides =
      ColumnSerializable('logSettingsOverrides');
  final ColumnBool logServiceCalls = ColumnBool('logServiceCalls');
  final ColumnBool logMalformedCalls = ColumnBool('logMalformedCalls');

  @override
  List<Column> get columns => <Column>[
        id,
        logSettings,
        logSettingsOverrides,
        logServiceCalls,
        logMalformedCalls,
      ];
}

@Deprecated('Use RuntimeSettingsTable.t instead.')
RuntimeSettingsTable tRuntimeSettings = RuntimeSettingsTable();
