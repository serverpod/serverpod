/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class EmailAuth extends _i1.SerializableEntity {
  EmailAuth({
    this.id,
    required this.userId,
    required this.email,
    required this.hash,
  });

  factory EmailAuth.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailAuth(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userId: serializationManager
          .deserializeJson<int>(jsonSerialization['userId']),
      email: serializationManager
          .deserializeJson<String>(jsonSerialization['email']),
      hash: serializationManager
          .deserializeJson<String>(jsonSerialization['hash']),
    );
  }

  int? id;

  int userId;

  String email;

  String hash;

  @override
  String get className => 'serverpod_auth_server.EmailAuth';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }
}
