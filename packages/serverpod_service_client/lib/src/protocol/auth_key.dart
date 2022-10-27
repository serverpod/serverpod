/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class AuthKey extends _i1.SerializableEntity {
  AuthKey({
    this.id,
    required this.userId,
    required this.hash,
    this.key,
    required this.scopeNames,
    required this.method,
  });

  factory AuthKey.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return AuthKey(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userId: serializationManager
          .deserializeJson<int>(jsonSerialization['userId']),
      hash: serializationManager
          .deserializeJson<String>(jsonSerialization['hash']),
      key: serializationManager
          .deserializeJson<String?>(jsonSerialization['key']),
      scopeNames: serializationManager
          .deserializeJson<List<String>>(jsonSerialization['scopeNames']),
      method: serializationManager
          .deserializeJson<String>(jsonSerialization['method']),
    );
  }

  int? id;

  int userId;

  String hash;

  String? key;

  List<String> scopeNames;

  String method;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'hash': hash,
      'key': key,
      'scopeNames': scopeNames,
      'method': method,
    };
  }
}
