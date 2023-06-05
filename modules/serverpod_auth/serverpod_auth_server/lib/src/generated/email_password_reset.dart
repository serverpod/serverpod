/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class _Undefined {}

/// Information about an email password reset.
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
          .deserialize<String>(jsonSerialization['userName']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
    );
  }

  /// The user name of the user.
  final String userName;

  /// The email of the user.
  final String email;

  late Function({
    String? userName,
    String? email,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is EmailPasswordReset &&
            (identical(
                  other.userName,
                  userName,
                ) ||
                other.userName == userName) &&
            (identical(
                  other.email,
                  email,
                ) ||
                other.email == email));
  }

  @override
  int get hashCode => Object.hash(
        userName,
        email,
      );

  EmailPasswordReset _copyWith({
    String? userName,
    String? email,
  }) {
    return EmailPasswordReset(
      userName: userName ?? this.userName,
      email: email ?? this.email,
    );
  }
}
