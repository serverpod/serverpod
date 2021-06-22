/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class UserImage extends TableRow {
  @override
  String get className => 'serverpod_auth_server.UserImage';
  @override
  String get tableName => 'serverpod_user_image';

  @override
  int? id;
  late int userId;
  late int version;
  late String url;

  UserImage({
    this.id,
    required this.userId,
    required this.version,
    required this.url,
});

  UserImage.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    version = _data['version']!;
    url = _data['url']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    });
  }
}

class UserImageTable extends Table {
  UserImageTable() : super(tableName: 'serverpod_user_image');

  @override
  String tableName = 'serverpod_user_image';
  final id = ColumnInt('id');
  final userId = ColumnInt('userId');
  final version = ColumnInt('version');
  final url = ColumnString('url');

  @override
  List<Column> get columns => [
    id,
    userId,
    version,
    url,
  ];
}

UserImageTable tUserImage = UserImageTable();
