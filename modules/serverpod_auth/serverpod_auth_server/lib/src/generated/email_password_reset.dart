/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class EmailPasswordReset extends _i1.SerializableEntity {
  EmailPasswordReset({
    required this.userName,
    required this.email,
  });

  factory EmailPasswordReset.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailPasswordReset(
      userName: serializationManager
          .deserializeJson<String>(jsonSerialization['userName']),
      email: serializationManager
          .deserializeJson<String>(jsonSerialization['email']),
    );
  }

  String userName;

  String email;

  @override
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'userName': userName,
      'email': email,
    };
  }
}
