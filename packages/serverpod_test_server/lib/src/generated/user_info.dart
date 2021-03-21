/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class UserInfo extends TableRow {
  String get className => 'UserInfo';
  String get tableName => 'user_info';

  int id;
  String name;
  String password;
  int another;
  String test;

  UserInfo({
    this.id,
    this.name,
    this.password,
    this.another,
    this.test,
});

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name'];
    password = _data['password'];
    another = _data['another'];
    test = _data['test'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'password': password,
      'another': another,
      'test': test,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'password': password,
      'another': another,
      'test': test,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'password': password,
      'another': another,
      'test': test,
    });
  }
}

class UserInfoTable extends Table {
  UserInfoTable() : super(tableName: 'user_info');

  String tableName = 'user_info';
  final id = ColumnInt('id');
  final name = ColumnString('name');
  final password = ColumnString('password');
  final another = ColumnInt('another');
  final test = ColumnString('test');

  List<Column> get columns => [
    id,
    name,
    password,
    another,
    test,
  ];
}

UserInfoTable tUserInfo = UserInfoTable();
