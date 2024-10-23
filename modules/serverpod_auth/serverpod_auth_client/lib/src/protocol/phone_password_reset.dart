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

/// Information about an phone number password reset.
abstract class PhonePasswordReset implements _i1.SerializableModel {
  PhonePasswordReset._({
    this.userName,
    required this.phoneNumber,
  });

  factory PhonePasswordReset({
    String? userName,
    required String phoneNumber,
  }) = _PhonePasswordResetImpl;

  factory PhonePasswordReset.fromJson(Map<String, dynamic> jsonSerialization) {
    return PhonePasswordReset(
      userName: jsonSerialization['userName'] as String?,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
    );
  }

  /// The user name of the user.
  String? userName;

  /// The phone number of the user.
  String phoneNumber;

  PhonePasswordReset copyWith({
    String? userName,
    String? phoneNumber,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (userName != null) 'userName': userName,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PhonePasswordResetImpl extends PhonePasswordReset {
  _PhonePasswordResetImpl({
    String? userName,
    required String phoneNumber,
  }) : super._(
          userName: userName,
          phoneNumber: phoneNumber,
        );

  @override
  PhonePasswordReset copyWith({
    Object? userName = _Undefined,
    String? phoneNumber,
  }) {
    return PhonePasswordReset(
      userName: userName is String? ? userName : this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
