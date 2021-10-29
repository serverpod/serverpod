/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class UserInfo extends TableRow {
  @override
  String get className => 'serverpod_auth_server.UserInfo';
  @override
  String get tableName => 'serverpod_user_info';

  @override
  int? id;
  late String userIdentifier;
  late String userName;
  String? fullName;
  String? email;
  late DateTime created;
  String? imageUrl;
  late List<String> scopeNames;
  late bool active;
  late bool blocked;
  DateTime? suspendedUntil;

  UserInfo({
    this.id,
    required this.userIdentifier,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.active,
    required this.blocked,
    this.suspendedUntil,
});

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userIdentifier = _data['userIdentifier']!;
    userName = _data['userName']!;
    fullName = _data['fullName'];
    email = _data['email'];
    created = DateTime.tryParse(_data['created'])!;
    imageUrl = _data['imageUrl'];
    scopeNames = _data['scopeNames']!.cast<String>();
    active = _data['active']!;
    blocked = _data['blocked']!;
    suspendedUntil = _data['suspendedUntil'] != null ? DateTime.tryParse(_data['suspendedUntil']) : null;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil?.toUtc().toIso8601String(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil?.toUtc().toIso8601String(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil?.toUtc().toIso8601String(),
    });
  }
}

class UserInfoTable extends Table {
  UserInfoTable() : super(tableName: 'serverpod_user_info');

  @override
  String tableName = 'serverpod_user_info';
  final id = ColumnInt('id');
  final userIdentifier = ColumnString('userIdentifier');
  final userName = ColumnString('userName');
  final fullName = ColumnString('fullName');
  final email = ColumnString('email');
  final created = ColumnDateTime('created');
  final imageUrl = ColumnString('imageUrl');
  final scopeNames = ColumnSerializable('scopeNames');
  final active = ColumnBool('active');
  final blocked = ColumnBool('blocked');
  final suspendedUntil = ColumnDateTime('suspendedUntil');

  @override
  List<Column> get columns => [
    id,
    userIdentifier,
    userName,
    fullName,
    email,
    created,
    imageUrl,
    scopeNames,
    active,
    blocked,
    suspendedUntil,
  ];
}

UserInfoTable tUserInfo = UserInfoTable();
