/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

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
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      verificationCode: serializationManager
          .deserialize<String>(jsonSerialization['verificationCode']),
      expiration: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiration']),
    );
  }

  int? id;

  int userId;

  String verificationCode;

  DateTime expiration;

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
