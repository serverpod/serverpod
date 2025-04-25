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

abstract class EmailAccountPasswordResetRequest
    implements _i1.SerializableModel {
  EmailAccountPasswordResetRequest._({
    _i1.UuidValue? id,
    required this.authenticationId,
    required this.created,
    required this.expiration,
    required this.verificationCode,
  }) : id = id ?? _i2.Uuid().v4obj();

  factory EmailAccountPasswordResetRequest({
    _i1.UuidValue? id,
    required _i1.UuidValue authenticationId,
    required DateTime created,
    required DateTime expiration,
    required String verificationCode,
  }) = _EmailAccountPasswordResetRequestImpl;

  factory EmailAccountPasswordResetRequest.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authenticationId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['authenticationId']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      expiration:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  /// The id of the [EmailAuthentication] this request belongs to.
  _i1.UuidValue authenticationId;

  /// The time when this request was created.
  DateTime created;

  /// The expiration time for the password reset.
  DateTime expiration;

  /// The verification code for the password reset.
  String verificationCode;

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetRequest copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authenticationId,
    DateTime? created,
    DateTime? expiration,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authenticationId': authenticationId.toJson(),
      'created': created.toJson(),
      'expiration': expiration.toJson(),
      'verificationCode': verificationCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountPasswordResetRequestImpl
    extends EmailAccountPasswordResetRequest {
  _EmailAccountPasswordResetRequestImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authenticationId,
    required DateTime created,
    required DateTime expiration,
    required String verificationCode,
  }) : super._(
          id: id,
          authenticationId: authenticationId,
          created: created,
          expiration: expiration,
          verificationCode: verificationCode,
        );

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetRequest copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authenticationId,
    DateTime? created,
    DateTime? expiration,
    String? verificationCode,
  }) {
    return EmailAccountPasswordResetRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      authenticationId: authenticationId ?? this.authenticationId,
      created: created ?? this.created,
      expiration: expiration ?? this.expiration,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
