/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Information about an email password reset.
abstract class EmailPasswordReset extends _i1.SerializableEntity {
  const EmailPasswordReset._();

  const factory EmailPasswordReset({
    required String userName,
    required String email,
  }) = _EmailPasswordReset;

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

  EmailPasswordReset copyWith({
    String? userName,
    String? email,
  });

  /// The user name of the user.
  String get userName;

  /// The email of the user.
  String get email;
}

/// Information about an email password reset.
class _EmailPasswordReset extends EmailPasswordReset {
  const _EmailPasswordReset({
    required this.userName,
    required this.email,
  }) : super._();

  /// The user name of the user.
  @override
  final String userName;

  /// The email of the user.
  @override
  final String email;

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

  @override
  EmailPasswordReset copyWith({
    String? userName,
    String? email,
  }) {
    return EmailPasswordReset(
      userName: userName ?? this.userName,
      email: email ?? this.email,
    );
  }
}
