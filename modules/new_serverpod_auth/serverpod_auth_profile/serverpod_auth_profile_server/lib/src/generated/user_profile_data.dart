/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UserProfileData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserProfileData._({
    this.userName,
    this.fullName,
    this.email,
  });

  factory UserProfileData({
    String? userName,
    String? fullName,
    String? email,
  }) = _UserProfileDataImpl;

  factory UserProfileData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfileData(
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
    );
  }

  /// The first name of the user or the user's nickname.
  String? userName;

  /// The full name of the user.
  String? fullName;

  /// The email of the user.
  ///
  /// Stored in lower-case.
  String? email;

  /// Returns a shallow copy of this [UserProfileData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfileData copyWith({
    String? userName,
    String? fullName,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileDataImpl extends UserProfileData {
  _UserProfileDataImpl({
    String? userName,
    String? fullName,
    String? email,
  }) : super._(
          userName: userName,
          fullName: fullName,
          email: email,
        );

  /// Returns a shallow copy of this [UserProfileData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfileData copyWith({
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
  }) {
    return UserProfileData(
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
    );
  }
}
