/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class UserInfo extends TableRow {
  @override
  String get className => 'serverpod_auth_server.UserInfo';
  @override
  String get tableName => 'serverpod_user_info';

  @override
  int? id;
  late String userName;
  String? fullName;
  String? email;
  late DateTime created;
  String? avatarUrl;
  late List<String> scopes;
  late bool active;
  late bool blocked;

  UserInfo({
    this.id,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.avatarUrl,
    required this.scopes,
    required this.active,
    required this.blocked,
});

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userName = _data['userName']!;
    fullName = _data['fullName'];
    email = _data['email'];
    created = DateTime.tryParse(_data['created'])!;
    avatarUrl = _data['avatarUrl'];
    scopes = _data['scopes']!.cast<String>();
    active = _data['active']!;
    blocked = _data['blocked']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'avatarUrl': avatarUrl,
      'scopes': scopes,
      'active': active,
      'blocked': blocked,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'avatarUrl': avatarUrl,
      'scopes': scopes,
      'active': active,
      'blocked': blocked,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'avatarUrl': avatarUrl,
      'scopes': scopes,
      'active': active,
      'blocked': blocked,
    });
  }
}

class UserInfoTable extends Table {
  UserInfoTable() : super(tableName: 'serverpod_user_info');

  @override
  String tableName = 'serverpod_user_info';
  final id = ColumnInt('id');
  final userName = ColumnString('userName');
  final fullName = ColumnString('fullName');
  final email = ColumnString('email');
  final created = ColumnDateTime('created');
  final avatarUrl = ColumnString('avatarUrl');
  final scopes = ColumnSerializable('scopes');
  final active = ColumnBool('active');
  final blocked = ColumnBool('blocked');

  @override
  List<Column> get columns => [
    id,
    userName,
    fullName,
    email,
    created,
    avatarUrl,
    scopes,
    active,
    blocked,
  ];
}

UserInfoTable tUserInfo = UserInfoTable();
