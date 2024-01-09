/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A request for creating an email signin. Created during the sign up process
/// to keep track of the user's details and verification code.
abstract class EmailCreateAccountRequest extends _i1.SerializableEntity {
  EmailCreateAccountRequest._({
    this.id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  });

  factory EmailCreateAccountRequest({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) = _EmailCreateAccountRequestImpl;

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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The name of the user.
  String userName;

  /// The email of the user.
  String email;

  /// Hash of the user's requested password.
  String hash;

  /// The verification code sent to the user.
  String verificationCode;

  EmailCreateAccountRequest copyWith({
    int? id,
    String? userName,
    String? email,
    String? hash,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }
}

class _Undefined {}

class _EmailCreateAccountRequestImpl extends EmailCreateAccountRequest {
  _EmailCreateAccountRequestImpl({
    int? id,
    required String userName,
    required String email,
    required String hash,
    required String verificationCode,
  }) : super._(
          id: id,
          userName: userName,
          email: email,
          hash: hash,
          verificationCode: verificationCode,
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
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      hash: hash ?? this.hash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
