/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for an email reset.
abstract class EmailReset extends _i1.SerializableEntity {
  EmailReset._({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  });

  factory EmailReset({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) = _EmailResetImpl;

  factory EmailReset.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailReset(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      verificationCode: jsonSerialization['verificationCode'] as String,
      expiration: DateTime.parse((jsonSerialization['expiration'] as String)),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the user that is resetting his/her password.
  int userId;

  /// The verification code for the password reset.
  String verificationCode;

  /// The expiration time for the password reset.
  DateTime expiration;

  EmailReset copyWith({
    int? id,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toJson(),
    };
  }
}

class _Undefined {}

class _EmailResetImpl extends EmailReset {
  _EmailResetImpl({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) : super._(
          id: id,
          userId: userId,
          verificationCode: verificationCode,
          expiration: expiration,
        );

  @override
  EmailReset copyWith({
    Object? id = _Undefined,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  }) {
    return EmailReset(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
      expiration: expiration ?? this.expiration,
    );
  }
}
