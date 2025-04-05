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

abstract class EmailAccount implements _i1.SerializableModel {
  EmailAccount._({
    this.id,
    required this.userId,
    required this.created,
    required this.email,
    required this.passwordHash,
  });

  factory EmailAccount({
    int? id,
    required int userId,
    required DateTime created,
    required String email,
    required String passwordHash,
  }) = _EmailAccountImpl;

  factory EmailAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccount(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the [AuthUser] this login belongs to.
  int userId;

  /// The time when this authentication was created.
  DateTime created;

  /// The email of the user.
  ///
  /// Stored in lower-case by convention.
  String email;

  /// The hashed password of the user.
  String passwordHash;

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccount copyWith({
    int? id,
    int? userId,
    DateTime? created,
    String? email,
    String? passwordHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'created': created.toJson(),
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountImpl extends EmailAccount {
  _EmailAccountImpl({
    int? id,
    required int userId,
    required DateTime created,
    required String email,
    required String passwordHash,
  }) : super._(
          id: id,
          userId: userId,
          created: created,
          email: email,
          passwordHash: passwordHash,
        );

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccount copyWith({
    Object? id = _Undefined,
    int? userId,
    DateTime? created,
    String? email,
    String? passwordHash,
  }) {
    return EmailAccount(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      created: created ?? this.created,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}
