/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database bindings for an email reset.
abstract class EmailReset extends _i1.SerializableEntity {
  const EmailReset._();

  const factory EmailReset({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) = _EmailReset;

  factory EmailReset.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailReset(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      verificationCode: serializationManager
          .deserialize<String>(jsonSerialization['verificationCode']),
      expiration: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiration']),
    );
  }

  EmailReset copyWith({
    int? id,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The id of the user that is resetting his/her password.
  int get userId;

  /// The verification code for the password reset.
  String get verificationCode;

  /// The expiration time for the password reset.
  DateTime get expiration;
}

class _Undefined {}

/// Database bindings for an email reset.
class _EmailReset extends EmailReset {
  const _EmailReset({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The id of the user that is resetting his/her password.
  @override
  final int userId;

  /// The verification code for the password reset.
  @override
  final String verificationCode;

  /// The expiration time for the password reset.
  @override
  final DateTime expiration;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is EmailReset &&
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
                  other.verificationCode,
                  verificationCode,
                ) ||
                other.verificationCode == verificationCode) &&
            (identical(
                  other.expiration,
                  expiration,
                ) ||
                other.expiration == expiration));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        verificationCode,
        expiration,
      );

  @override
  EmailReset copyWith({
    Object? id = _Undefined,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  }) {
    return EmailReset(
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
      expiration: expiration ?? this.expiration,
    );
  }
}
