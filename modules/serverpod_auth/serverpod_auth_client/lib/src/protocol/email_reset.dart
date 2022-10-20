/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class EmailReset extends _i1.SerializableEntity {
  EmailReset({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  });

  factory EmailReset.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailReset(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      userId: serializationManager
          .deserializeJson<int>(jsonSerialization['userId']),
      verificationCode: serializationManager
          .deserializeJson<String>(jsonSerialization['verificationCode']),
      expiration: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['expiration']),
    );
  }

  int? id;

  int userId;

  String verificationCode;

  DateTime expiration;

  @override
  String get className => 'serverpod_auth_server.EmailReset';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration,
    };
  }
}
