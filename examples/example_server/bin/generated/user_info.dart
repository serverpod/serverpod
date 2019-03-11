/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/database.dart';
import 'protocol.dart';

class UserInfo extends TableRow {
  static const String db = 'user_info';
  String get className => 'UserInfo';
  String get tableName => 'user_info';

  int id;
  String password;
  String name;

  UserInfo({
    this.id,
    this.password,
    this.name,
});

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    id = data['id'];
    password = data['password'];
    name = data['name'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'password': password,
      'name': name,
    });
  }
}

class UserInfoTable extends Table {

  static const String tableName = 'user_info';
  static const id = Column('id', int);
  static const password = Column('password', String);
  static const name = Column('name', String);
}
