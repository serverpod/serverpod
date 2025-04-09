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
import 'package:uuid/uuid.dart' as _i2;

/// There is no user ID stored with the request.
/// If an existing user should be assigned to this specific request,
/// store that with the request's `id` and link them up during registration.
abstract class EmailAccountRequest implements _i1.SerializableModel {
  EmailAccountRequest._({
    _i1.UuidValue? id,
    required this.created,
    required this.expiration,
    required this.email,
    required this.passwordHash,
    required this.verificationCode,
  }) : id = id ?? _i2.Uuid().v4obj();

  factory EmailAccountRequest({
    _i1.UuidValue? id,
    required DateTime created,
    required DateTime expiration,
    required String email,
    required String passwordHash,
    required String verificationCode,
  }) = _EmailAccountRequestImpl;

  factory EmailAccountRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      expiration:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  /// The time when this authentication was created.
  DateTime created;

  /// The expiration time for the account verification to complete.
  DateTime expiration;

  /// The email of the user.
  ///
  /// Stored in lower-case by convention.
  String email;

  /// The hashed password of the user.
  String passwordHash;

  /// The verification code sent to the user.
  String verificationCode;

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountRequest copyWith({
    _i1.UuidValue? id,
    DateTime? created,
    DateTime? expiration,
    String? email,
    String? passwordHash,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'created': created.toJson(),
      'expiration': expiration.toJson(),
      'email': email,
      'passwordHash': passwordHash,
      'verificationCode': verificationCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountRequestImpl extends EmailAccountRequest {
  _EmailAccountRequestImpl({
    _i1.UuidValue? id,
    required DateTime created,
    required DateTime expiration,
    required String email,
    required String passwordHash,
    required String verificationCode,
  }) : super._(
          id: id,
          created: created,
          expiration: expiration,
          email: email,
          passwordHash: passwordHash,
          verificationCode: verificationCode,
        );

  /// Returns a shallow copy of this [EmailAccountRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountRequest copyWith({
    Object? id = _Undefined,
    DateTime? created,
    DateTime? expiration,
    String? email,
    String? passwordHash,
    String? verificationCode,
  }) {
    return EmailAccountRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      created: created ?? this.created,
      expiration: expiration ?? this.expiration,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
