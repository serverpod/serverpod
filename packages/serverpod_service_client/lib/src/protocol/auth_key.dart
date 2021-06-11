/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class AuthKey extends SerializableEntity {
  @override
  String get className => 'AuthKey';

  int? id;
  late int userId;
  late String hash;
  String? key;
  late List<String> scopes;
  late String method;

  AuthKey({
    this.id,
    required this.userId,
    required this.hash,
    this.key,
    required this.scopes,
    required this.method,
});

  AuthKey.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    hash = _data['hash']!;
    key = _data['key'];
    scopes = _data['scopes']!.cast<String>();
    method = _data['method']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'hash': hash,
      'key': key,
      'scopes': scopes,
      'method': method,
    });
  }
}

