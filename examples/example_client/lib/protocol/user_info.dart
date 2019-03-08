/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';

class UserInfo extends SerializableEntity {
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

