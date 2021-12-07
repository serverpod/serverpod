/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class MethodInfo extends TableRow {
  @override
  String get className => 'MethodInfo';
  @override
  String get tableName => 'serverpod_method';

  @override
  int? id;
  late String endpoint;
  late String method;

  MethodInfo({
    this.id,
    required this.endpoint,
    required this.method,
  });

  MethodInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    endpoint = _data['endpoint']!;
    method = _data['method']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'endpoint': endpoint,
      'method': method,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'endpoint': endpoint,
      'method': method,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'endpoint': endpoint,
      'method': method,
    });
  }
}

class MethodInfoTable extends Table {
  MethodInfoTable() : super(tableName: 'serverpod_method');

  @override
  String tableName = 'serverpod_method';
  final id = ColumnInt('id');
  final endpoint = ColumnString('endpoint');
  final method = ColumnString('method');

  @override
  List<Column> get columns => [
        id,
        endpoint,
        method,
      ];
}

MethodInfoTable tMethodInfo = MethodInfoTable();
