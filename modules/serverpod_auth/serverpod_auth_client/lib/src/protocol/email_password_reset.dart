/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Information about an email password reset.
abstract class EmailPasswordReset implements _i1.SerializableModel {
  EmailPasswordReset._({
    this.userName,
    required this.email,
  });

  factory EmailPasswordReset({
    String? userName,
    required String email,
  }) = _EmailPasswordResetImpl;

  factory EmailPasswordReset.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailPasswordReset(
      userName: jsonSerialization['userName'] as String?,
      email: jsonSerialization['email'] as String,
    );
  }

  /// The user name of the user.
  String? userName;

  /// The email of the user.
  String email;

  /// Returns a shallow copy of this [EmailPasswordReset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailPasswordReset copyWith({
    String? userName,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (userName != null) 'userName': userName,
      'email': email,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailPasswordResetImpl extends EmailPasswordReset {
  _EmailPasswordResetImpl({
    String? userName,
    required String email,
  }) : super._(
          userName: userName,
          email: email,
        );

  /// Returns a shallow copy of this [EmailPasswordReset]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailPasswordReset copyWith({
    Object? userName = _Undefined,
    String? email,
  }) {
    return EmailPasswordReset(
      userName: userName is String? ? userName : this.userName,
      email: email ?? this.email,
    );
  }
}
