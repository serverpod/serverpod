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

/// Database bindings for an phone number reset.
abstract class PhoneReset implements _i1.SerializableModel {
  PhoneReset._({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  });

  factory PhoneReset({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) = _PhoneResetImpl;

  factory PhoneReset.fromJson(Map<String, dynamic> jsonSerialization) {
    return PhoneReset(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      verificationCode: jsonSerialization['verificationCode'] as String,
      expiration:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
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

  PhoneReset copyWith({
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PhoneResetImpl extends PhoneReset {
  _PhoneResetImpl({
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
  PhoneReset copyWith({
    Object? id = _Undefined,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  }) {
    return PhoneReset(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
      expiration: expiration ?? this.expiration,
    );
  }
}
