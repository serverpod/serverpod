/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A request for creating an email signin. Created during the sign up process
/// to keep track of the user's details and verification code.
abstract class EmailCreateAccountRequest extends _i1.SerializableEntity {
  const EmailCreateAccountRequest._();

  const factory EmailCreateAccountRequest({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) = _EmailCreateAccountRequest;

  factory EmailCreateAccountRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailCreateAccountRequest(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userName: serializationManager
          .deserialize<String>(jsonSerialization['userName']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      hash: serializationManager.deserialize<String>(jsonSerialization['hash']),
      verificationCode: serializationManager
          .deserialize<String>(jsonSerialization['verificationCode']),
    );
  }

  EmailCreateAccountRequest copyWith({
    int? id,
    String? userName,
    String? email,
    String? hash,
    String? verificationCode,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The name of the user.
  String get userName;

  /// The email of the user.
  String get email;

  /// Hash of the user's requested password.
  String get hash;

  /// The verification code sent to the user.
  String get verificationCode;
}

class _Undefined {}

/// A request for creating an email signin. Created during the sign up process
/// to keep track of the user's details and verification code.
class _EmailCreateAccountRequest extends EmailCreateAccountRequest {
  const _EmailCreateAccountRequest({
    this.id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The name of the user.
  @override
  final String userName;

  /// The email of the user.
  @override
  final String email;

  /// Hash of the user's requested password.
  @override
  final String hash;

  /// The verification code sent to the user.
  @override
  final String verificationCode;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is EmailCreateAccountRequest &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userName,
                  userName,
                ) ||
                other.userName == userName) &&
            (identical(
                  other.email,
                  email,
                ) ||
                other.email == email) &&
            (identical(
                  other.hash,
                  hash,
                ) ||
                other.hash == hash) &&
            (identical(
                  other.verificationCode,
                  verificationCode,
                ) ||
                other.verificationCode == verificationCode));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userName,
        email,
        hash,
        verificationCode,
      );

  @override
  EmailCreateAccountRequest copyWith({
    Object? id = _Undefined,
    String? userName,
    String? email,
    String? hash,
    String? verificationCode,
  }) {
    return EmailCreateAccountRequest(
      id: id == _Undefined ? this.id : (id as int?),
      userName: userName ?? this.userName,
      email: email ?? this.email,
      hash: hash ?? this.hash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
