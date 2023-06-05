/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a sign in with email.
abstract class EmailAuth extends _i1.SerializableEntity {
  const EmailAuth._();

  const factory EmailAuth({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) = _EmailAuth;

  factory EmailAuth.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailAuth(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      hash: serializationManager.deserialize<String>(jsonSerialization['hash']),
    );
  }

  EmailAuth copyWith({
    int? id,
    int? userId,
    String? email,
    String? hash,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  int get userId;

  /// The email of the user.
  String get email;

  /// The hashed password of the user.
  String get hash;
}

class _Undefined {}

/// Database bindings for a sign in with email.
class _EmailAuth extends EmailAuth {
  const _EmailAuth({
    this.id,
    required this.userId,
    required this.email,
    required this.hash,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  @override
  final int userId;

  /// The email of the user.
  @override
  final String email;

  /// The hashed password of the user.
  @override
  final String hash;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is EmailAuth &&
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
                  other.email,
                  email,
                ) ||
                other.email == email) &&
            (identical(
                  other.hash,
                  hash,
                ) ||
                other.hash == hash));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        email,
        hash,
      );

  @override
  EmailAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? email,
    String? hash,
  }) {
    return EmailAuth(
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      email: email ?? this.email,
      hash: hash ?? this.hash,
    );
  }
}
