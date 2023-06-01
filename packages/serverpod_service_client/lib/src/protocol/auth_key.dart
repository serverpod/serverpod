/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:collection/collection.dart' as _i2;

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
  final int? id;

  /// The id of the user to provide access to.
  final int userId;

  /// The hashed version of the key.
  final String hash;

  /// The key sent to the server to authenticate.
  final String? key;

  /// The scopes this key provides access to.
  final List<String> scopeNames;

  /// The method of signing in this key was generated through. This can be email
  /// or different social logins.
  final String method;

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

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AuthKey &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.hash,
                  hash,
                ) ||
                other.hash == hash) &&
            (identical(
                  other.key,
                  key,
                ) ||
                other.key == key) &&
            (identical(
                  other.method,
                  method,
                ) ||
                other.method == method) &&
            const _i2.DeepCollectionEquality().equals(
              scopeNames,
              other.scopeNames,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        hash,
        key,
        method,
        const _i2.DeepCollectionEquality().hash(scopeNames),
      );

  AuthKey copyWith({
    int? id,
    int? userId,
    String? hash,
    String? key,
    List<String>? scopeNames,
    String? method,
  }) {
    return AuthKey(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hash: hash ?? this.hash,
      key: key ?? this.key,
      scopeNames: scopeNames ?? this.scopeNames,
      method: method ?? this.method,
    );
  }
}
