/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for a sign in with email.
abstract class AnonymousAuth implements _i1.SerializableModel {
  AnonymousAuth._({
    this.id,
    required this.userId,
    required this.hash,
  });

  factory AnonymousAuth({
    int? id,
    required int userId,
    required String hash,
  }) = _AnonymousAuthImpl;

  factory AnonymousAuth.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnonymousAuth(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      hash: jsonSerialization['hash'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The hashed password of the user.
  String hash;

  /// Returns a shallow copy of this [AnonymousAuth]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousAuth copyWith({
    int? id,
    int? userId,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'hash': hash,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousAuthImpl extends AnonymousAuth {
  _AnonymousAuthImpl({
    int? id,
    required int userId,
    required String hash,
  }) : super._(
          id: id,
          userId: userId,
          hash: hash,
        );

  /// Returns a shallow copy of this [AnonymousAuth]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? hash,
  }) {
    return AnonymousAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      hash: hash ?? this.hash,
    );
  }
}
