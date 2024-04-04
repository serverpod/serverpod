/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a sign in with email.
abstract class EmailAuth extends _i1.SerializableEntity {
  EmailAuth._({
    this.id,
    required this.userId,
    required this.email,
    required this.hash,
  });

  factory EmailAuth({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) = _EmailAuthImpl;

  factory EmailAuth.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAuth(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      email: jsonSerialization['email'] as String,
      hash: jsonSerialization['hash'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The email of the user.
  String email;

  /// The hashed password of the user.
  String hash;

  EmailAuth copyWith({
    int? id,
    int? userId,
    String? email,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }
}

class _Undefined {}

class _EmailAuthImpl extends EmailAuth {
  _EmailAuthImpl({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) : super._(
          id: id,
          userId: userId,
          email: email,
          hash: hash,
        );

  @override
  EmailAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? email,
    String? hash,
  }) {
    return EmailAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      hash: hash ?? this.hash,
    );
  }
}
