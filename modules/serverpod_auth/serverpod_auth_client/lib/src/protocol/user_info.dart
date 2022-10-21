/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class UserInfo extends _i1.SerializableEntity {
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

  factory UserInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserInfo(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userIdentifier: serializationManager
          .deserializeJson<String>(jsonSerialization['userIdentifier']),
      userName: serializationManager
          .deserializeJson<String>(jsonSerialization['userName']),
      fullName: serializationManager
          .deserializeJson<String?>(jsonSerialization['fullName']),
      email: serializationManager
          .deserializeJson<String?>(jsonSerialization['email']),
      created: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['created']),
      imageUrl: serializationManager
          .deserializeJson<String?>(jsonSerialization['imageUrl']),
      scopeNames: serializationManager
          .deserializeJson<List<String>>(jsonSerialization['scopeNames']),
      active: serializationManager
          .deserializeJson<bool>(jsonSerialization['active']),
      blocked: serializationManager
          .deserializeJson<bool>(jsonSerialization['blocked']),
      suspendedUntil: serializationManager
          .deserializeJson<DateTime?>(jsonSerialization['suspendedUntil']),
    );
  }

  int? id;

  String userIdentifier;

  String userName;

  String? fullName;

  String? email;

  DateTime created;

  String? imageUrl;

  List<String> scopeNames;

  bool active;

  bool blocked;

  DateTime? suspendedUntil;

  @override
  String get className => 'serverpod_auth_server.UserInfo';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created,
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil,
    };
  }
}
