/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

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
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userName: serializationManager
          .deserializeJson<String>(jsonSerialization['userName']),
      email: serializationManager
          .deserializeJson<String>(jsonSerialization['email']),
      hash: serializationManager
          .deserializeJson<String>(jsonSerialization['hash']),
      verificationCode: serializationManager
          .deserializeJson<String>(jsonSerialization['verificationCode']),
    );
  }

  int? id;

  String userName;

  String email;

  String hash;

  String verificationCode;

  @override
  String get className => 'serverpod_auth_server.EmailCreateAccountRequest';
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
