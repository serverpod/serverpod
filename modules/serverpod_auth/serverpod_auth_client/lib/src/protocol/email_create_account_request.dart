/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A request for creating an email signin. Created during the sign up process
/// to keep track of the user's details and verification code.
class EmailCreateAccountRequest extends _i1.SerializableEntity {
  EmailCreateAccountRequest({
    this.id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  });

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

  int? id;

  /// The name of the user.
  String userName;

  /// The email of the user.
  String email;

  /// Hash of the user's requested password.
  String hash;

  /// The verification code sent to the user.
  String verificationCode;

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
}
