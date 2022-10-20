/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class EmailFailedSignIn extends _i1.SerializableEntity {
  EmailFailedSignIn({
    this.id,
    required this.email,
    required this.time,
    required this.ipAddress,
  });

  factory EmailFailedSignIn.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailFailedSignIn(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      email: serializationManager
          .deserializeJson<String>(jsonSerialization['email']),
      time: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['time']),
      ipAddress: serializationManager
          .deserializeJson<String>(jsonSerialization['ipAddress']),
    );
  }

  int? id;

  String email;

  DateTime time;

  String ipAddress;

  @override
  String get className => 'serverpod_auth_server.EmailFailedSignIn';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
    };
  }
}
