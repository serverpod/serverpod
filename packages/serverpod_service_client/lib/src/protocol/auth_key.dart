/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Provides a method of access for a user to authenticate with the server.
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
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      hash: serializationManager.deserialize<String>(jsonSerialization['hash']),
      key: serializationManager.deserialize<String?>(jsonSerialization['key']),
      scopeNames: serializationManager
          .deserialize<List<String>>(jsonSerialization['scopeNames']),
      method:
          serializationManager.deserialize<String>(jsonSerialization['method']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the user to provide access to.
  int userId;

  /// The hashed version of the key.
  String hash;

  /// The key sent to the server to authenticate.
  String? key;

  /// The scopes this key provides access to.
  List<String> scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
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
